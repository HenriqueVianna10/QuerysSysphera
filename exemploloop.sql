SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_app01_rh_contabilizacao_folha_02_carrega_tmp]
(@id_instancia int)
as
	BEGIN
    
	---Henrique Vianna
	---2025-10-24
	---Carrega as páginas da REP_DATALOAD_REST para o Tabela Temporária
     declare @rownum int;
	 declare @msg varchar(max);
	 declare @txt nvarchar(max);
     declare @usuario nvarchar(40);
     declare @tipo_processo int = 1;

    select @usuario = usuario from VW_DT_wkf_aux_user_instance_start
	where identificador = @id_instancia

	select @usuario = ISNULL(@usuario,'admin')

    BEGIN TRY

	TRUNCATE TABLE DT_app01_etl_tmp_contabilizacao_folha

		DECLARE @counter INT;
		DECLARE @total INT;
		DECLARE @cod INT;
		DECLARE @table TABLE (
			id INT identity
			,cod INT
			)

		INSERT INTO @table (cod)
		SELECT codDataLoadRest
		FROM REP_DATALOAD_REST
		WHERE jsnResponse NOT LIKE '""' AND dscName <= 'Contabilização Folha - PRD'
        and dscHttpResponseCode = 'OK'

		SELECT @total = count(*)
		FROM REP_DATALOAD_REST
		WHERE jsnResponse NOT LIKE '""' AND dscName = 'Contabilização Folha - PRD'
        and dscHttpResponseCode = 'OK'

	
		SET @counter = 1

		WHILE @counter <= @total
		BEGIN
			SELECT @cod = cod
			FROM @table
			WHERE id = @counter

			INSERT INTO [dbo].[DT_app01_etl_tmp_contabilizacao_folha] (
				 [cod_user]
				,[dat_update]
				,[datlan]
				,[diaLancamento]
				,[mesLancamento]
				,[anoLancamento]
				,[sumValorCredito]
				,[sumValorDebito]
				,[valor]
				,[cpfFuncionario]
				,[codigoFuncionario]
				,[nomeFuncionario]
				,[codigoCargo]
				,[codigoSindicato]
				,[tipoLancamento]
				,[codConta]
				,[descricaoContabil]
                ,[codigoUnidade]
                ,[codigoCCusto]
                ,[historico]
                ,[posto]
                ,[sk_conta]
                ,[sk_cenario]
                ,[sk_entidade]
                ,[sk_consolidacao]
                ,[sk_cargo]
                ,[sk_funcionario]
				)
			SELECT
                @usuario
				,GETDATE()
				,[datlan]
				,[diaLancamento]
				,[mesLancamento]
				,[anoLancamento]
				,[sumValorCredito]
				,[sumValorDebito]
				,[valor]
				,[cpfFuncionario]
				,[codigoFuncionario]
				,[nomeFuncionario]
				,[codigoCargo]
				,[codigoSindicato]
				,[tipoLancamento]
				,[codConta]
				,[descricaoContabil]
                ,[codigoUnidade]
                ,[codigoCCusto]
                ,[historico]
                ,[posto]
                ,-2 as sk_conta --Não Mapeado
                ,1 as sk_cenario --Realizado
                ,5 as sk_entidade --Não Mapeado
                ,-1 as sk_consolidacao --Base
                ,23 as sk_cargo --Não Mapeado
                ,1164 as sk_funcionario --Não Mapeado
			FROM OPENJSON((
						SELECT JsnResponse
						FROM (
							SELECT codDataloadRest
								,jsnResponse AS JsnResponse
								,ROW_NUMBER() OVER (
									ORDER BY datExecuted DESC
									) AS Row#
							FROM rep_dataload_rest
							WHERE dscName = 'Contabilização Folha - PRD' AND dschttpresponsecode = 'OK' AND codDataloadRest = @cod
							) a
						WHERE a.row# = 1
						), '$.content') WITH (
					DATLAN VARCHAR(max) '$.DATLAN'
					,diaLancamento VARCHAR(max) '$.diaLancamento'
					,mesLancamento VARCHAR(max) '$.mesLancamento'
					,anoLancamento VARCHAR(max) '$.anoLancamento'
					,sumValorCredito VARCHAR(max) '$.sumValorCredito'
					,sumValorDebito VARCHAR(max) '$.sumValorDebito'
					,valor VARCHAR(max) '$.valor'
					,cpfFuncionario VARCHAR(max) '$.cpfFuncionario'
					,codigoFuncionario VARCHAR(max) '$.codigoFuncionario'
					,nomeFuncionario VARCHAR(max) '$.nomeFuncionario'
					,codigoCargo VARCHAR(max) '$.codigoCargo'
                    ,codigoSindicato VARCHAR(max) '$.codigoSindicato'
					,tipoLancamento VARCHAR(max) '$.tipoLancamento'
					,codConta VARCHAR(max) '$.codConta'
					,descricaoContabil VARCHAR(max) '$.descricaoContabil'
					,codigoUnidade VARCHAR(max) '$.codigoUnidade'
					,codigoCCusto VARCHAR(max) '$.codigoCCusto'
					,historico VARCHAR(max) '$.historico'
                    ,posto VARCHAR(max) '$.posto'
					)

			SET @counter = @counter + 1
		END


        select @rownum = COUNT(*) from DT_app01_etl_tmp_contabilizacao_folha

        set @msg = '' +CAST(@rownum as varchar(max))+ ' Linhas carregadas na tabela temporária.'
	

	exec sp_t6_etl_log_add @msg, @grupo = 'Tratamento de Dados', @tipo_processo = @tipo_processo


    exec sp_t6_etl_log_add  'Atualizando Dimensões.', @grupo = 'Tratamento de Dados', @tipo_processo = @tipo_processo



	exec sp_t6_etl_log_add  'Dimensões atualizadas com Sucesso.', @grupo = 'Tratamento de Dados', @tipo_processo = @tipo_processo



    END TRY
    BEGIN CATCH
        -- Tratamento de erro
        select @txt = 'ERRO: ' + ERROR_MESSAGE();
        exec sp_t6_etl_log_add @txt, @grupo = 'Tratamento de Dados', @tipo_processo = @tipo_processo, @tipo = 'E';
        THROW;
    END CATCH


END

