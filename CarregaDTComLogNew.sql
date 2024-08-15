USE [copel_sysphera_dev]
GO
/****** Object:  StoredProcedure [dbo].[sp_carrega_dt_custo_de_construcao]    Script Date: 8/15/2024 7:01:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_carrega_dt_custo_de_construcao]

AS
BEGIN

	---Henrique Vianna
	---2024-08-02
	---Carrega os Dados do arquivo CSV para o DT

    declare @rownum1 int;
	declare @msg1 varchar(max);
	declare @competencia varchar(max);
	declare @rownum2 int;
	declare @msg2 varchar(max);
	declare @error varchar(max);

	BEGIN TRY

	--Delete from DT_get_movimentacao
	--where sk_tempo in (select distinct sk_tempo from DT_etl_tmp_get_movimentacao)

	set @rownum1 = @@ROWCOUNT

	select @competencia = tempo_l2 from d_tempo_app5
	where sk_tempo in (select distinct sk_tempo from DT_etl_tmp_get_movimentacao)

	set @msg1 = ''+ CAST(@rownum1 as varchar(max)) + ' Linhas deletadas na competência '+ CAST(@competencia as varchar(max)) +''

	exec sp_t6_etl_log_add @msg1, @grupo = 'Carregamento Tabela de Construção', @tipo_processo = 2

	INSERT INTO [dbo].[DT_get_movimentacao]
           ([cod_user]
           ,[dat_update]
           ,[empresa]
           ,[data_de_lancamento]
           ,[data_de_entrada]
           ,[elemento_pep]
           ,[classe_de_custo]
           ,[descr_classe_custo]
           ,[valor_moeda_transacao]
           ,[material_]
           ,[qtd_total_entrada]
           ,[unid_medida_lancada]
           ,[denominacao]
           ,[conta_lancto_contrapartida]
           ,[descricao_conta_contrapartida]
           ,[operacao_ref]
           ,[org_estorno]
           ,[estornado]
           ,[n_doc_de_referencia]
           ,[n_documento]
           ,[documento_de_compras]
           ,[item]
           ,[texto_do_pedido]
           ,[n_pessoal]
           ,[tipo_de_documento]
           ,[name]
           ,[status]
           ,[centcureq]
           ,[centcuresp]
           ,[cenlucro]
           ,[descricao]
           ,[descricao1]
           ,[detalhe]
           ,[perf_inv]
           ,[programa_o]
           ,[natureza]
           ,[excluir]
           ,[desembolso]
           ,[rec]
           ,[mod]
           ,[obs]
           ,[obs1]
           ,[recmod]
           ,[apos_fechamento]
		   ,sk_conta
		   ,sk_tempo
		   ,sk_cenario
		   ,sk_entidade
		   ,sk_contrato
		   ,sk_operacao)


	SELECT 
	  'hvianna'
	  ,GETDATE()
      ,[empresa]
      ,[data_de_lancamento]
      ,[data_de_entrada]
      ,[elemento_pep]
      ,[classe_de_custo]
      ,[descr_classe_custo]
      ,CAST(REPLACE(REPLACE([valor_moeda_transacao],'.',''),',','.') as numeric(28,14)) as valor_moeda_transacao
      ,[material_]
      ,CAST(REPLACE(REPLACE([qtd_total_entrada],'.',''),',','.') as numeric(28,14)) as qtd_total_entrada
      ,[unid_medida_lancada]
      ,[denominacao]
      ,[conta_lancto_contrapartida]
      ,[descricao_conta_contrapartida]
      ,[operacao_ref]
      ,[org_estorno]
      ,[estornado]
      ,[n_doc_de_referencia]
      ,[n_documento]
      ,[documento_de_compras]
      ,[item]
      ,[texto_do_pedido]
      ,[n_pessoal]
      ,[tipo_de_documento]
      ,[name]
      ,[status]
      ,[centcureq]
      ,[centcuresp]
      ,[cenlucro]
      ,[descricao]
      ,[descricao1]
      ,[detalhe]
      ,[perf_inv]
      ,[programa_o]
      ,[natureza]
      ,[excluir]
      ,[desembolso]
      ,[rec]
      ,[mod]
      ,[obs]
      ,[obs1]
      ,[recmod]
      ,[apos_fechamento]
	  ,sk_conta
	  ,sk_tempo
	  ,sk_cenario
	  ,sk_entidade
	  ,sk_contrato
	  ,sk_operacao
  FROM [dbo].[DT_etl_tmp_get_movimentacao]

  select top 1* from f_app5

  set @rownum2 = @@ROWCOUNT
  set @msg2 = '' +CAST(@rownum2 as varchar(max))+ ' Linhas carregadas na tabela de detalhe'
	

	exec sp_t6_etl_log_add @msg2, @grupo = 'Carregamento Tabela de Construção', @tipo_processo = 2

	END TRY

    BEGIN CATCH
	    declare @errorCode int;
		declare @errorMessage nvarchar(max);
		declare @descricao_erro varchar(max);
		select @errorCode = ERROR_NUMBER(), @errorMessage = ERROR_MESSAGE();
		select @error = CAST(error_number() as VARCHAR(100)) + '::' + ERROR_MESSAGE();
		set @descricao_erro = 'Erro no carregamento da tabela de detalhe. ' + @error

        exec sp_t6_etl_log_add  @descricao_erro, @grupo = 'Carregamento Tabela de Construção', @tipo_processo = 2, @tipo = 'E';
	 
        THROW;
    END CATCH


END
