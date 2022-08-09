USE [getnet_sysphera_prd]
GO
/****** Object:  StoredProcedure [dbo].[sp_carrega_stage_partidas_individuais]    Script Date: 8/9/2022 6:24:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[sp_carrega_stage_partidas_individuais]
as
	BEGIN
		--Carrega os Dados do Endpoint Partidas Individuais
		TRUNCATE TABLE stage_partidas_individuais

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
		WHERE jsnResponse NOT LIKE '%""%' AND dscName <> 'authentication'

		SELECT @total = count(*)
		FROM REP_DATALOAD_REST
		WHERE jsnResponse NOT LIKE '%""%' AND dscName <> 'authentication'

	
		SET @counter = 1

		WHILE @counter <= @total
		BEGIN
			SELECT @cod = cod
			FROM @table
			WHERE id = @counter

			INSERT INTO [dbo].[stage_partidas_individuais] (
				[denominacao_centro_custo]
				,[denominacao_categoria_valor]
				,[valor]
				,[classe_custo]
				,[denominacao]
				,[numero_documento]
				,[documento_compras]
				,[conta_contrapartida]
				,[data_documento]
				,[tipo_documento]
				,[categoria_valor]
				,[denominacao_classe_custo]
				,[data_lancamento]
				,[usuario]
				,[texto_pedido]
				,[centro_custo]
				,[denomincacao_conta_contrapartida]
				)
			SELECT [denominacao_centro_custo]
				,[denominacao_categoria_valor]
				,[valor]
				,[classe_custo]
				,[denominacao]
				,[numero_documento]
				,[documento_compras]
				,[conta_contrapartida]
				,[data_documento]
				,[tipo_documento]
				,[categoria_valor]
				,[denomincacao_classe_custo]
				,[data_lancamento]
				,[usuario]
				,[texto_pedido]
				,[centro_custo]
				,[denomincacao_conta_contrapartida]
			FROM OPENJSON((
						SELECT JsnResponse
						FROM (
							SELECT codDataloadRest
								,replace(JsnResponse, '{"resultado":', '') AS JsnResponse
								,ROW_NUMBER() OVER (
									ORDER BY datExecuted DESC
									) AS Row#
							FROM rep_dataload_rest
							WHERE dscName = 'PartidasIndividuais' AND dschttpresponsecode = 'OK' AND codDataloadRest = @cod
							) a
						WHERE a.row# = 1
						)) WITH (
					denominacao_centro_custo VARCHAR(max) '$.denominacao_centro_custo'
					,denominacao_categoria_valor VARCHAR(max) '$.denominacao_categoria_valor'
					,valor VARCHAR(max) '$.valor'
					,classe_custo VARCHAR(max) '$.classe_custo'
					,denominacao VARCHAR(max) '$.denominacao'
					,numero_documento VARCHAR(max) '$.numero_documento'
					,documento_compras VARCHAR(max) '$.documento_compras'
					,conta_contrapartida VARCHAR(max) '$.conta_contrapartida'
					,data_documento VARCHAR(max) '$.data_documento'
					,tipo_documento VARCHAR(max) '$.tipo_documento'
					,categoria_valor VARCHAR(max) '$.categoria_valor'
					,denomincacao_classe_custo VARCHAR(max) '$.denomincacao_classe_custo'
					,data_lancamento VARCHAR(max) '$.data_lancamento'
					,usuario VARCHAR(max) '$.usuario'
					,texto_pedido VARCHAR(max) '$.texto_pedido'
					,centro_custo VARCHAR(max) '$.centro_custo'
					,denomincacao_conta_contrapartida VARCHAR(max) '$.denomincacao_conta_contrapartida'
					)

			SET @counter = @counter + 1
		END
	END