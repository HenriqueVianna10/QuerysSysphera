
ALTER PROCEDURE [dbo].[sp_carrega_tmp_gl_movimento]
 @logId as int
,@objetoPai as nvarchar(100) = NULL
AS
BEGIN

	--Henrique Vianna
	--2023-06-27
	--Carrega os dados do gateway para a tmp


	declare @objeto as nvarchar(100) = case when @objetoPai is not null then @objetoPai + '>>' else '' end + 'sp_carrega_tmp_gl_movimento';
    declare @rownum int;
	declare @responsavel as nvarchar(50);
    declare @mensagem as nvarchar(3000);

    exec sp_etl_addLogStart @logId, @objeto;

	 BEGIN TRY

		select @responsavel = isNull(a.cod_user,'etl')
		from   DT_app01_etl_cargas as a
		where  id = @logId

	    exec sp_etl_addLogMessage @logId, @objeto, @mensagem;

	    	--Limpa a stage que recebe o dado bruto
	TRUNCATE TABLE DT_app01_etl_tmp_gl_movimento

		exec sp_etl_addLogMessage @logId, @objeto, 'DT_app01_etl_tmp_gl_movimento';	


	--Insere os dados na stage
	INSERT INTO [dbo].[DT_app01_etl_tmp_gl_movimento] (
		 [ledger_id]
		,[flag_processamento]
		,[je_source]
		,[je_category]
		,[je_batch_id]
		,[je_header_id]
		,[je_lin_num_number]
		,[code_combination_id]
		,[period_name]
		,[mto_key]
		,[mvto_nome_lote]
		,[mvto_nome_lancamento]
		,[mvto_origem]
		,[mvto_categoria]
		,[mvto_tipo_lcto]
		,[mvto_revertido]
		,[mvto_lote_status]
		,[mvto_lcto_data]
		,[mvto_lcto_linha]
		,[mvto_moeda]
		,[mvto_deb]
		,[mvto_cred]
		,[mvto_deb_ctb]
		,[mvto_cred_ctb]
		,[mvto_historico]
		,[gjl_reference_1]
		,[gjl_reference_2]
		,[gjl_reference_3]
		,[gjl_reference_4]
		,[gjl_reference_5]
		,[gjl_reference_6]
		,[gjl_reference_7]
		,[gjl_reference_8]
		,[gjl_reference_9]
		,[gjl_reference_10]
		,[data_processamento]
		)

		SELECT 
      [ledger_id]
      ,[flag_processamento]
      ,[je_source]
      ,[je_category]
      ,[je_batch_id]
      ,[je_header_id]
      ,[je_line_num]
      ,[code_combination_id]
      ,[period_name]
      ,[mto_key]
      ,[mvto_nome_lote]
      ,[mvto_nome_lancamento]
      ,[mvto_origem]
      ,[mvto_categoria]
      ,[mvto_tipo_lcto]
      ,[mvto_revertido]
      ,[mvto_lote_status]
      ,[mvto_lcto_data]
      ,[mvto_lcto_linha]
      ,[mvto_moeda]
      ,[mvto_deb]
      ,[mvto_cred]
      ,[mvto_deb_ctb]
      ,[mvto_cred_ctb]
      ,[mvto_historico]
      ,[gjl_reference_1]
      ,[gjl_reference_2]
      ,[gjl_reference_3]
      ,[gjl_reference_4]
      ,[gjl_reference_5]
      ,[gjl_reference_6]
      ,[gjl_reference_7]
      ,[gjl_reference_8]
      ,[gjl_reference_9]
      ,[gjl_reference_10]
      ,[data_processamento]
  FROM [DT_busca_dados]

  exec sp_etl_addLogMessage @logId, @objeto, 'INSERT DT_app01_etl_tmp_gl_movimento OK', @@ROWCOUNT;



	---Atualiza SK Tempo 
	UPDATE DT_app01_etl_tmp_gl_movimento
	SET sk_tempo = tempo.sk_tempo
	FROM DT_app01_etl_tmp_gl_movimento DT
	inner join d_tempo_app1 tempo
	on RIGHT(DT.period_name,2) = RIGHT(tempo.tempo_l1,2)
	and LEFT(DT.period_name,3) = tempo.shortMonthName
	
	--Atualiza Dimensões Não Mapeados e Não Aplicável
	UPDATE DT_app01_etl_tmp_gl_movimento
	set sk_conta = -2, --Não Mapeado
		sk_conta_receita = NULL, --Não Mapeado
		sk_cenario = 1, --Realizado
		sk_entidade = -1, --Não Aplicável
		sk_servico = -1, --Não Aplicável
		sk_empresa = -1 ,--Não Aplicável
		sk_cliente_projeto = -1 ,--Não Aplicável,
		sk_entidade_para = -1 ,--Não Aplicável,
		sk_consolidacao = -1 --Original
	

	---Atualiza SK Conta 
	UPDATE DT_app01_etl_tmp_gl_movimento
	set sk_conta = T3.sk_conta,
		seg_conta_contabil = T2.seg_conta_contabil
	from DT_app01_etl_tmp_gl_movimento T1 
	inner join DT_app01_gl_pl_contas T2 on (T1.code_combination_id = T2.code_combination_id)
	inner join d_conta_app1 T3 on (T2.seg_conta_contabil = T3.num_conta)

	---Atualiza SK Empresa 
	UPDATE DT_app01_etl_tmp_gl_movimento
	set sk_empresa = t3.sk_empresa,
	    seg_empresa = t2.seg_empresa
	from DT_app01_etl_tmp_gl_movimento T1
	inner join DT_app01_gl_pl_contas T2 on (T1.code_combination_id = T2.code_combination_id)
	inner join d_empresa_app1 T3 on (T3.cod_cnpj = T2.seg_empresa)

	---Atualiza SK Entidade Tipo CC 
	UPDATE DT_app01_etl_tmp_gl_movimento
	set sk_entidade = t3.sk_entidade,
		seg_unidade_negocio = t2.seg_unidade_negocio,
		seg_centro_custo = t2.seg_centro_custo,
		tipo_map_entidade = 'Centro de Custo'
	from DT_app01_etl_tmp_gl_movimento T1
	inner join DT_app01_gl_pl_contas T2 on (T1.code_combination_id = T2.code_combination_id)
	inner join d_entidade_app1 T3 on (T3.seg_unidade_negocio = T2.seg_unidade_negocio and T3.seg_centro_custo = T2.seg_centro_custo)
	where T3.tipo = 'Centro de Custo' and t3.ativo = 'Sim'

    ---Atualiza SK Entidade Tipo CC Reclassificação - As Reclassificações Consideram apenas Entidades do Tipo Centro de Custo
	UPDATE DT_app01_etl_tmp_gl_movimento
	set sk_entidade = t3.sk_entidade,
		seg_unidade_negocio = t3.seg_unidade_negocio,
		tipo_map_entidade = 'Reclassificação'
		--seg_centro_custo = T2.seg_centro_custo
	from DT_app01_etl_tmp_gl_movimento T1
	inner join DT_app01_gl_pl_contas T2 on (T1.code_combination_id = T2.code_combination_id)
	inner join DT_app01_reclassificacao_realizado T3 on (T3.seg_unidade_negocio_origem = T2.seg_unidade_negocio and T3.seg_centro_de_custo = T2.seg_centro_custo)
	inner join d_entidade_app1 T4 on (T4.sk_entidade = t3.sk_entidade)
	where t4.tipo = 'Centro de Custo' and T4.ativo = 'Sim'

	 ---Atualiza SK Entidade Tipo Produto Novo Somente Contas do Grupo de Receita
	UPDATE DT_app01_etl_tmp_gl_movimento
	set sk_entidade = t3.sk_entidade,
		seg_produto = t2.seg_produto_,
		seg_unidade_negocio = t2.seg_unidade_negocio,
		tipo_map_entidade = 'Produto'
	from DT_app01_etl_tmp_gl_movimento T1
	inner join DT_app01_gl_pl_contas T2 on (T1.code_combination_id = T2.code_combination_id)
	inner join d_entidade_app1 T3 on (RIGHT(T3.codigo,4) = T2.seg_produto_ and T3.seg_centro_custo = T2.seg_centro_custo)
	where T3.tipo = 'Produto' and T1.seg_conta_contabil in (select num_conta from d_conta_app1 where sk_parent = 10) and t3.ativo = 'Sim'


	---Atualiza Sk Serviço
	UPDATE DT_app01_etl_tmp_gl_movimento
	set sk_servico = T3.sk_servico,
		seg_servico = T2.seg_servico
	from DT_app01_etl_tmp_gl_movimento T1
	inner join DT_app01_gl_pl_contas T2 on (T1.code_combination_id = T2.code_combination_id)
	inner join d_servico_app1 T3 on (T2.seg_servico = CAST(REPLACE(T3.codigo_servico,'S','') as INT))
	where T3.codigo_servico <> ''

	
    ---Atualiza Classificação Receita
    UPDATE DT_app01_etl_tmp_gl_movimento
    set sk_conta_receita = cr.sk_conta_destino
	--sk_servico = cr.sk_servico,   
    from DT_app01_etl_tmp_gl_movimento DT
    inner join DT_app01_classificacao_receita cr
	on DT.sk_conta = cr.sk_conta and DT.seg_unidade_negocio = cr.seg_unidade_negocio and DT.sk_servico = cr.sk_servico



	delete from DT_app01_etl_tmp_gl_movimento
	where period_name = 'AJU-22'

	delete from DT_app01_etl_tmp_gl_movimento
	where period_name = 'AJU-23'


	exec sp_etl_addLogMessage @logId, @objeto, 'UPDATE DT_app01_etl_tmp_gl_movimento OK', @@ROWCOUNT;

		exec sp_etl_addLogFinish @logId, @objeto;

	END TRY
    BEGIN CATCH
	    declare @errorCode int;
		declare @errorMessage nvarchar(max);
		select @errorCode = ERROR_NUMBER(), @errorMessage = ERROR_MESSAGE();

        exec sp_etl_addLogError @logId, @objeto, 'Erro na atualização da DT_app01_etl_tmp_gl_movimento', @errorMessage, @errorCode;
	 
        THROW;
    END CATCH


END