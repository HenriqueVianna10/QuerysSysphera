USE [Sysphera]
GO
/****** Object:  StoredProcedure [dbo].[sp_app09_headcount_01_carrega_excel_vetor_rh]    Script Date: 7/15/2025 4:05:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_app09_headcount_01_carrega_excel_vetor_rh]
(@id_instancia int null)
AS
BEGIN

	---Henrique Vianna
	---2025-06-30
	---Carrega os Dados do arquivo Excel para a tmp

    declare @rownum int;
	declare @msg varchar(max);
	declare @usuario nvarchar(40);
	declare @tipo_processo int = 3;
	declare @identificador int; 
	declare @sk_tempo int;


	select	@usuario = usuario 
	from	VW_DT_wkf_aux_user_instance_start
	where	identificador = @id_instancia

	select @usuario = ISNULL(@usuario,'admin') 
	
	truncate table DT_app09_tmp_etl_headcount

	exec sp_t6_etl_log_add 'Limpeza da Tabela Temporária', @grupo = 'Processamento do Excel', @tipo_processo = @tipo_processo

	select	@identificador = max(identificador) 
	from	DT_app09_etl_arquivo_rh

	select	@sk_tempo = mes 
	from	DT_app09_etl_arquivo_rh
	where	identificador = @identificador

	exec sp_t6_etl_log_add 'Carregamento do Arquivo', @grupo = 'Processamento do Excel', @tipo_processo = @tipo_processo

	INSERT INTO dbo.DT_app09_tmp_etl_headcount
           (cod_user
           ,dat_update
           ,emp
           ,filial
           ,cadastro
           ,nome
           ,[local]
           ,descricao_local
           ,admissao
           ,c_h
           ,codigo_posto
           ,nome_posto
           ,codigo_escala
           ,descricao_da_escala
           ,ccargo
           ,cargo
           ,nivel
           ,ccusto
           ,area
           ,gerencia
           ,superintendencia
           ,superintendencia_executiva
           ,diretoria_hospitalar
           ,salario_nominal
           ,ats 
           ,perc_ats 
           ,insalubridade
           ,periculosidade
           ,adicional_noturno 
           ,vale_refeicao_diario
           ,vale_alimentacao
           ,vale_combustivel_diario
           ,vale_transporte_diario
           ,comissoes 
           ,horas_dsr_comissao 
           ,comissao_com_dsr 
           ,remuneracao
           ,tabela_hay
           ,estsalposto
           ,grade
           ,tabhay_conv_horas
           ,posicao_em_relacao_ao_mercado
           ,codigo_sindicato
           ,sexo
           ,data_demissao
           ,descsituacao
           ,def
           ,ultima_promocaomerito
           ,racacor
           ,apelido_filial
           ,carga_horaria
           ,cbo
           ,pcd
           ,escolaridade
           ,tipo_de_contrato
           ,aux_faixa)
	SELECT 
       @usuario
      ,GETDATE()
      ,emp
      ,filial
      ,cadastro
      ,nome
      ,[local]
      ,descricao_local
      ,admissao
      ,ch
      ,codigo_posto
      ,nome_posto
      ,codigo_escala
      ,descricao_da_escala
      ,ccargo
      ,cargo
      ,nivel
      ,ccusto
      ,area
      ,gerencia
      ,superintendencia
      ,superintendencia_executiva
      ,diretoria_hospitalar
      ,CAST(salario_nominal as numeric(28,14))
	  ,CAST(ats as numeric(28,14))
	  ,CAST(_ats as numeric(28,14))
      ,CAST(insalubridade as numeric(28,14))
      ,CAST(periculosidade as numeric(28,14))
	  ,CAST(adicional_noturno as numeric(28,14))
      ,CAST(vale_refeicao_diario as numeric(28,14))
      ,CAST(vale_alimentacao as numeric(28,14))
      ,CAST(vale_combustivel_diario as numeric(28,14))
      ,CAST(vale_transporte_diario as numeric(28,14))
	  ,CAST(comissoes as numeric(28,14))
	  ,CAST(horas_dsr_comissao as numeric(28,14))
	  ,CAST(comissao_com_dsr as numeric(28,14))
      ,CAST(remuneracao as numeric(28,14))
      ,tabela_hay
      ,estsalposto
      ,grade
      ,tabhay_conv_horas
      ,CAST(posicao_em_relacao_ao_mercado as numeric(28,14))
      ,codigo_sindicato
      ,sexo
      ,data_demissao
      ,descsituacao
      ,def
      ,ultima_promocaomerito
      ,racacor
      ,apelido_filial
      ,carga_horaria
      ,cbo
      ,pcd
      ,escolaridade
      ,tipo_de_contrato
	  ,cast(salario_nominal as decimal(24,4)) / cast(isNull(tabela_hay,salario_nominal) as decimal(24,4))
	FROM DT_app09_etl_tmp_dados_headcount
	
	set @rownum = @@ROWCOUNT
	set @msg = 'Arquivo Carregado com Sucesso ' + CAST(@rownum as varchar(10)) + ' Registros Carregados'
	exec sp_t6_etl_log_add  @msg, @grupo = 'Processamento do Excel', @tipo_processo = @tipo_processo	
	
	exec sp_t6_etl_log_add  'Atualização de Sk´s.', @grupo = 'Processamento do Excel', @tipo_processo = @tipo_processo

	--Atualiza Sk´s Fixos
	UPDATE DT_app09_tmp_etl_headcount
	set sk_tempo = @sk_tempo,
		sk_conta = 47, --QL Final
		sk_cenario = 1, --Realizado
		sk_consolidacao = -1, --Original
		sk_entidade = -2, --Não Mapeado
		sk_centro_de_custo = -2, --Não Mapeado
		sk_cargo = -2, --Não Mapeado
		sk_carga_horaria = -2, --Não Mapeado
		sk_faixa = -2 --Não Mapeado

	--Atualiza Sks Entidade e CC
	UPDATE	DT
	set		sk_entidade = depara.sk_entidade,
			sk_centro_de_custo = depara.sk_centro_de_custo
	from	DT_app09_tmp_etl_headcount as DT inner join 
			DT_etl_depara_cc_sapiens depara on (DT.filial = depara.filial_sapiens and
												DT.ccusto = depara.centro_custo_sapiens)

	--Atualiza Sks Cargo
	UPDATE DT_app09_tmp_etl_headcount
	set sk_cargo = depara.cargo_sysphera
	from DT_app09_tmp_etl_headcount DT
	inner join DT_etl_depara_cargos_rh depara on DT.ccargo = depara.codigo_cargo

	--Atualiza Sks Carga Horária
	UPDATE DT_app09_tmp_etl_headcount
	set sk_carga_horaria = ch.sk_carga_horaria
	from DT_app09_tmp_etl_headcount DT
	inner join d_carga_horaria_app9 ch on LEFT(DT.c_h,3) = ch.num_carga_horaria

	--Atualiza Sks Faixa
	UPDATE DT_app09_tmp_etl_headcount
	set sk_faixa = fai.sk_faixa
	from DT_app09_tmp_etl_headcount DT
	inner join d_faixa_app9 fai on DT.aux_faixa >= fai.faixa_inicial and DT.aux_faixa < fai.faixa_final

	exec sp_t6_etl_log_add  'Atualização de Sk´s Concluida com Sucesso.', @grupo = 'Processamento do Excel', @tipo_processo = @tipo_processo

	-- Novos Cargos no DePara
	insert into DT_etl_depara_cargos_rh(cod_user, dat_update, codigo_cargo, nome_cargo, cargo_sysphera)
	select	distinct @usuario, getdate(), ccargo, cargo, -2
	from	DT_app09_tmp_etl_headcount
	where	sk_cargo = -2

	set @rownum = @@ROWCOUNT
	IF (isNull(@rownum,0) > 0)
	BEGIN
		set @msg = 'ATENÇÃO Encontrados ' + CAST(@rownum as varchar(10)) + ' NOVOS Cargos não mapeados.'
		exec sp_t6_etl_log_add  @msg, @grupo = 'Processamento do Excel', @tipo_processo = @tipo_processo	
	END

	-- Atualiza RelDim CC x Cargo
	insert into DT_reldim_centro_de_custo_x_cargo(cod_user, dat_update, centro_de_custo, cargo)
	select distinct @usuario, GETDATE(), sk_centro_de_custo, sk_cargo
	from	DT_app09_headcount_vetor
	where	sk_cargo <> -2 and sk_centro_de_custo <> - 2
	and CONCAT(sk_centro_de_custo, '|', sk_cargo) not in (select distinct CONCAT(centro_de_custo, '|', cargo) from DT_reldim_centro_de_custo_x_cargo)

	set @rownum = @@ROWCOUNT
	IF (isNull(@rownum,0) > 0)
	BEGIN
		set @msg = 'Encontradas ' + CAST(@rownum as varchar(10)) + ' NOVAS combinações no RelDim CC x Cargo.'
		exec sp_t6_etl_log_add  @msg, @grupo = 'Processamento do Excel', @tipo_processo = @tipo_processo	
	END

	-- Atualiza RelDim Cargo x Carga Horária
	insert into DT_reldim_cargo_x_carga_horaria(cod_user, dat_update, cargo, carga_horaria)
	select distinct @usuario, dat_update, sk_cargo, sk_carga_horaria
	from DT_app09_headcount_vetor
	where CONCAT(sk_cargo,'|',sk_carga_horaria) not in (select distinct CONCAT(cargo,'|',carga_horaria) from DT_reldim_cargo_x_carga_horaria)
	and sk_cargo <> -2 and sk_carga_horaria <> -2

	set @rownum = @@ROWCOUNT
	IF (isNull(@rownum,0) > 0)
	BEGIN
		set @msg = 'Encontradas ' + CAST(@rownum as varchar(10)) + ' NOVAS combinações no RelDim Cargo x Carga Horária.'
		exec sp_t6_etl_log_add  @msg, @grupo = 'Processamento do Excel', @tipo_processo = @tipo_processo	
	END

END

