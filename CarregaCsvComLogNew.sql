CREATE PROCEDURE [dbo].[sp_carrega_csv_custo_de_construcao]
(@id_instancia int null)
AS
BEGIN

	---Henrique Vianna
	---2024-08-02
	---Carrega os Dados do arquivo CSV para o DT

    declare @rownum int;
	declare @msg varchar(max);
	declare @check int;
	declare @cenario int;
	declare @usuario nvarchar(40);


	select @usuario = usuario from VW_DT_wkf_aux_user_instance_start
	where identificador = @id_instancia

	select @usuario = ISNULL(@usuario,'admin') 
	
	truncate table DT_etl_tmp_get_movimentacao --Trunca a tabela onde vai ser carregado os dados

	exec sp_t6_etl_log_add 'Limpeza da Tabela Temporária', @grupo = 'Processamento do CSV', @tipo_processo = 2

	DECLARE @identificador int; --Declaração do ID que vamos buscar sempre do último arquivo carregado

	select @identificador = max(id) from --select no dt pegando o último identificador da tabela
	 DT_carrega_arquivo_csv_razao_obras

	select @cenario = cenario from DT_carrega_arquivo_csv_razao_obras
	where id = @identificador


	exec sp_t6_etl_log_add 'Carregamento do Arquivo', @grupo = 'Processamento do CSV', @tipo_processo = 2

	INSERT INTO [dbo].[DT_etl_tmp_get_movimentacao]
			   ([linha]
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
			   ,[obs])
	select
		cast([1] as bigint) -1  as id_linha_csv,
			 [2] [empresa],
			 [3] [data_de_lancamento],
			 [4] [data_de_entrada],
			 [5] [elemento_pep],
			 [6] [classe_de_custo],
			 [7] [descr_classe_custo],
			 [8] [valor_moeda_transacao],
			 [9] [material_],
			 [10] [qtd_total_entrada],
			 [11] [unid_medida_lancada],
			 [12] [denominacao],
			 [13] [conta_lancto_contrapartida],
			 [14] [descricao_conta_contrapartida],
			 [15] [operacao_ref],
			 [16] [org_estorno],
			 [17] [estornado],
			 [18] [n_doc_de_referencia],
			 [19] [n_documento],
			 [20] [documento_de_compras],
			 [21] [item],
			 [22] [texto_do_pedido],
			 [23] [n_pessoal],
			 [24] [tipo_de_documento],
			 [25] [name],
			 [26] [status],
			 [27] [centcureq],
			 [28] [centcuresp],
			 [29] [cenlucro],
			 [30] [descricao],
			 [31] [descricao1],
			 [32] [detalhe],
			 [33] [perf_inv],
			 [34] [programa_o],
			 [35] [natureza],
			 [36] [excluir],
			 [37] [desembolso],
			 [38] [rec],
			 [39] [mod],
			 [40] [obs]
	from (
	   select
			id_linha, id, value, ROW_NUMBER() OVER (PARTITION BY id_linha ORDER BY (SELECT NULL)) AS rn
		from (
			select ltrim(ROW_NUMBER() OVER (ORDER BY (SELECT NULL))) + ';' + substring(value, 1, len(value)-1) id_linha, id
			from
				DT_carrega_arquivo_csv_razao_obras dt
				CROSS APPLY string_split(cast(dt.arquivo AS varchar(max)), CHAR(10)) l
			where
				l.value <> ''
				and dt.id = @identificador
			) Lin
			CROSS APPLY string_split(Lin.id_linha, ';') C
		) Col
		pivot(max(value) FOR RN IN (
		[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40])
	) AS pvt
	where
	  [1] > 1
	order by cast([1] as bigint);


	set @rownum = @@ROWCOUNT
	set @msg = 'Arquivo Carregado com Sucesso ' + CAST(@rownum as varchar(10)) + ' Registros Carregados'


	exec sp_t6_etl_log_add  @msg, @grupo = 'Processamento do CSV', @tipo_processo = 2
	
	
	exec sp_t6_etl_log_add  'Atualização de Sk´s.', @grupo = 'Processamento do CSV', @tipo_processo = 2


	exec sp_t6_etl_log_add  'Atualização de Sk´s Concluida com Sucesso.', @grupo = 'Processamento do CSV', @tipo_processo = 2



	select @check = LEN(empresa) from DT_etl_tmp_get_movimentacao

	IF @check != 4
	BEGIN

	exec sp_t6_etl_log_add 'Erro no carregamento do arquivo, verifique caracteres especiais ou quebras de linhas.', @grupo = 'Processamento do CSV', @tipo_processo = 2, @tipo = 'E'

	END


	


END
