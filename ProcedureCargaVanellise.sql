exec sp_atualiza_arquivo_stage

alter PROCEDURE [dbo].[sp_atualiza_arquivo_stage]
as
begin
			
			--Busca os dados do CSV
			--Valida Se O Mês Referência está correto
			--Limpa Referência da DT
			--Insere na DT
			--Criado por Henrique Vianna 12/11/2020

    ---Limpa a tabela que recebe o arquivo
		truncate table temp_etl_real_app1

	---Limpa a tabela com os dados pivotados
		truncate table tmp_etl_real_app1

	---Carrega os dados do csv

		DECLARE @id INT;
		DECLARE @data VARBINARY(max);
		DECLARE @mesreferencia varchar(max);
		
		select @id = max(identificador)
		from DT_etl_stag_arquivo_realizado_app1 as id

		select @data = carrega_csv
		from DT_etl_stag_arquivo_realizado_app1
		where identificador = @id 
		
		--insere os dados na temporária
		INSERT temp_etl_real_app1 (id)
		SELECT value as id
		from string_split(cast(@data as varchar(max)), char(10));

				
		--Pivoteia os dados e insere na tabela
		with c
		as (
			 select id, value, ROW_NUMBER() over (partition by id order by (select null)

			 )as rn
			 from temp_etl_real_app1 
			 cross apply string_split(id, ';') as bk
			 )
		insert into tmp_etl_real_app1  (
			vlr_saldo_inicial,
			vlr_debito,
			vlr_credito,
			vlr_saldo_final,
			dsc_mes_referencia,
			cod_conta_contabil,
			dsc_conta_contabil,
			cod_empresa,
			dsc_empresa,
			cod_centro_custo,
			dsc_centro_custo,
			cod_canal,
			dsc_canal,
			cod_cliente,
			dsc_cliente,
			cod_artigo,
			dsc_artigo,
			cod_segmento,
			dsc_segmento,
			cod_fase,
			dsc_fase)
	select --id
		[1] as 'vlr_saldo_inicial',
		[2] as 'vlr_debito',
		[3] as 'vlr_credito',
		[4] as 'vlr_saldo_final',
		[5] as 'dsc_mes_referencia',
		[6] as 'cod_conta_contabil',
		[7] as 'dsc_conta_contabil',
		[8] as 'cod_empresa',
		[9] as 'dsc_empresa',
		[10] as 'cod_centro_custo',
		[11] as 'dsc_centro_custo',
		[12] as 'cod_canal',
		[13] as 'dsc_canal',
		[14] as 'cod_cliente',
		[15] as 'dsc_cliente',
		[16] as 'cod_artigo',
		[17] as 'dsc_artigo',
		[18] as 'cod_segmento',
		[19] as 'dsc_segmento',
		[20] as 'cod_fase',
		[21] as 'dsc_fase'
		from c 
		pivot(max(value) for RN in ([1],
									[2],
									[3],
									[4],
									[5],
									[6],
									[7],
									[8],
									[9],
									[10],
									[11],
									[12],
									[13],
									[14],
									[15],
									[16],
									[17],
									[18],
									[19],
									[20],
									[21]
									)) as pvt



		update DT_etl_stag_arquivo_realizado_app1 set log = 'Erro'
		from tmp_etl_real_app1  as temp
		where @mesreferencia <> temp.dsc_mes_referencia

		update DT_etl_stag_arquivo_realizado_app1 set log = 'OK'
		from tmp_etl_real_app1 as temp
		where @mesreferencia = temp.dsc_mes_referencia

		--Deleta da DT dados com a mesma data de referência
		delete from DT_etl_stag_dados_realizado_app1 
		where dsc_mes_referencia = @mesreferencia

	

insert into DT_etl_stag_dados_realizado_app1(
		cod_user,
		dat_update,
		vlr_saldo_inicial,
		vlr_debito,
		vlr_credito,
		vlr_saldo_final,
		dsc_mes_referencia,
		cod_conta_contabil,
		dsc_conta_contabil,
		cod_empresa,
		dsc_empresa,
		cod_centro_custo,
		dsc_centro_custo,
		cod_canal,
		dsc_canal,
		cod_cliente,
		dsc_cliente,
		cod_artigo,
		dsc_artigo,
		cod_segmento,
		dsc_segmento,
		cod_fase,
		dsc_fase)
		select 
		'etl',
		GETDATE(),
		cast(iif(ltrim(rtrim(replace(replace(vlr_saldo_inicial, '.', ''), ',', '.'))) NOT IN ('','-'), ltrim(rtrim(replace(replace(vlr_saldo_inicial, '.', ''), ',', '.'))), '0') AS DECIMAL(23, 4)) AS vlr_saldo_inicial,
		cast(iif(ltrim(rtrim(replace(replace(vlr_debito, '.', ''), ',', '.'))) NOT IN ('','-'), ltrim(rtrim(replace(replace(vlr_debito, '.', ''), ',', '.'))), '0') AS DECIMAL(23, 4)) AS vlr_debito,
		cast(iif(ltrim(rtrim(replace(replace(vlr_credito, '.', ''), ',', '.'))) NOT IN ('','-'), ltrim(rtrim(replace(replace(vlr_credito, '.', ''), ',', '.'))), '0') AS DECIMAL(23, 4)) AS vlr_credito,
		cast(iif(ltrim(rtrim(replace(replace(vlr_saldo_final, '.', ''), ',', '.'))) NOT IN ('','-'), ltrim(rtrim(replace(replace(vlr_saldo_final, '.', ''), ',', '.'))), '0') AS DECIMAL(23, 4)) AS vlr_saldo_final,
		LTRIM(RTRIM(dsc_mes_referencia)),
		LTRIM(RTRIM(cod_conta_contabil)),
		LTRIM(RTRIM(dsc_conta_contabil)),
		LTRIM(RTRIM(cod_empresa)),
		LTRIM(RTRIM(dsc_empresa)),
		LTRIM(RTRIM(cod_centro_custo)),
		LTRIM(RTRIM(dsc_centro_custo)),
		LTRIM(RTRIM(cod_canal)),
		LTRIM(RTRIM(dsc_canal)),
		LTRIM(RTRIM(cod_cliente)),
		LTRIM(RTRIM(dsc_cliente)),
		LTRIM(RTRIM(cod_artigo)),
		LTRIM(RTRIM(dsc_artigo)),
		LTRIM(RTRIM(cod_segmento)),
		LTRIM(RTRIM(dsc_segmento)),
		LTRIM(RTRIM(cod_fase)),
		LTRIM(RTRIM(dsc_fase))
		from tmp_etl_real_app1 
		where vlr_saldo_final is not null and dsc_mes_referencia <> 'mes_referencia' and @mesreferencia = dsc_mes_referencia

END
GO
