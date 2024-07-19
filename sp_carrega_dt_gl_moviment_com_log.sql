
ALTER PROCEDURE [dbo].[sp_carrega_dt_gl_movimento]
 @logId as int
,@objetoPai as nvarchar(100) = NULL
AS
BEGIN


	declare @objeto as nvarchar(100) = case when @objetoPai is not null then @objetoPai + '>>' else '' end + 'sp_carrega_dt_gl_movimento';
    declare @rownum int;
	declare @responsavel as nvarchar(50);
    declare @mensagem as nvarchar(3000);

    exec sp_etl_addLogStart @logId, @objeto;

	 BEGIN TRY

		exec sp_etl_addLogMessage @logId, @objeto, @mensagem;

	
	DELETE
	FROM DT_app01_gl_movimento
	WHERE sk_tempo = (
			SELECT DISTINCT sk_tempo
			FROM DT_app01_etl_tmp_gl_movimento
			)


		exec sp_etl_addLogMessage @logId, @objeto, 'limpa a DT_app01_gl_movimento somente no mes que vai ser carregado';	


	INSERT INTO [dbo].[DT_app01_gl_movimento] (
		 [cod_user]
		,[dat_update]
		,[ledger_id]
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
		,[sk_conta]
		,[sk_tempo]
		,[sk_cenario]
		,[sk_entidade]
		,[sk_servico]
		,[sk_empresa]
		,[sk_cliente_projeto]
		,[sk_entidade_para]
		,[sk_consolidacao]
		,[sk_conta_receita]
		,[seg_conta_contabil]
		,[seg_empresa]
		,[seg_unidade_negocio]
		,[seg_centro_custo]
		,seg_produto
		,seg_servico
		,tipo_mapeamento_entidade
		)
	SELECT 'admin'
		,GETDATE()
		,[ledger_id]
		,T1.flag_processamento
		,[je_source]
		,[je_category]
		,[je_batch_id]
		,[je_header_id]
		,[je_lin_num_number]
		,T1.code_combination_id
		,[period_name]
		,[mto_key]
		,[mvto_nome_lote]
		,[mvto_nome_lancamento]
		,[mvto_origem]
		,[mvto_categoria]
		,[mvto_tipo_lcto]
		,[mvto_revertido]
		,[mvto_lote_status]
		,LEFT([mvto_lcto_data],10)
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
		,LEFT(T1.data_processamento,10)
		,T1.sk_conta
		,T1.sk_tempo
		,T1.sk_cenario
		,T1.sk_entidade
		,T1.sk_servico
		,T1.sk_empresa
		,T1.sk_cliente_projeto
		,T1.sk_entidade_para
		,T1.sk_consolidacao
		,T1.sk_conta_receita
		,T1.seg_conta_contabil
		,T1.seg_empresa
		,T1.[seg_unidade_negocio]
		,T1.[seg_centro_custo]
		,T1.seg_produto
		,T1.seg_servico
		,t1.tipo_map_entidade
	FROM [dbo].[DT_app01_etl_tmp_gl_movimento] T1
	inner join DT_app01_gl_pl_contas T2 on (T1.code_combination_id = LEFT(T2.code_combination_id,7))
	where LEFT(t2.seg_conta_contabil,1) IN ('3','4','7')


	 exec sp_etl_addLogMessage @logId, @objeto, 'INSERT DT_app01_gl_movimento OK', @@ROWCOUNT;


	 exec sp_etl_addLogFinish @logId, @objeto;

	END TRY
    BEGIN CATCH
	    declare @errorCode int;
		declare @errorMessage nvarchar(max);
		select @errorCode = ERROR_NUMBER(), @errorMessage = ERROR_MESSAGE();

        exec sp_etl_addLogError @logId, @objeto, 'Erro no insert da DT_app01_gl_movimento', @errorMessage, @errorCode;
	 
        THROW;
    END CATCH





END
