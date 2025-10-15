CREATE PROCEDURE [dbo].[sp_importa_ur_csv]
AS
BEGIN
	DECLARE @id INT;
	DECLARE @data VARBINARY(max);
	DECLARE @sk_cenario INT;
	DECLARE @ano INT;
	DECLARE @table AS TABLE (
		id INT identity
		,identificador INT
		)
	DECLARE @count AS INT;
	DECLARE @i AS INT;
	DECLARE @identificador AS INT;

	SET @i = 1

	TRUNCATE TABLE tmp_etl_export_ur_dados

	TRUNCATE TABLE tmp_etl_export_ur

	TRUNCATE TABLE DT_input_alteracoes_aux

	INSERT INTO @table (identificador)
	SELECT identificador
	FROM DT_etl_csv_importar_dados_ur AS id
	WHERE importar = 'Sim'

	SELECT @count = count(*)
	FROM @table

	WHILE @i <= @count
	BEGIN
		SELECT @identificador = identificador
		FROM @table
		WHERE id = @i

		SELECT @data = arquivo
		FROM DT_etl_csv_importar_dados_ur
		WHERE identificador = @identificador

		INSERT tmp_etl_export_ur_dados (id)
		SELECT value AS id
		FROM string_split(cast(@data AS VARCHAR(max)), CHAR(10));

		WITH C
		AS (
			SELECT id
				,value
				,ROW_NUMBER() OVER (
					PARTITION BY id ORDER BY (
							SELECT NULL
							)
					) AS rn
			FROM tmp_etl_export_ur_dados
			CROSS APPLY string_split(ID, ';') AS bk
			)
		INSERT INTO tmp_etl_export_ur (
			nome_funcionario
			,matricula
			,nome_funcao
			,cr
			,remuneracao_fixa
			,sindicato
			,nome_sindicato
			,multicontrato
			,codigo_afastado
			,motivo_afastamento
			,nome_localizacao
			,chefia
			,vinculo
			,grade
			,tipo_vaga
			,sk_entidade
			,head
			,artista
			,comissionado
			,hrbp
			,ur
			,mes_exclusao_vaga
			,mes_inclusao_vaga
			,mes_retorno_afastado
			,nova_remuneracao
			,mes_de_ajuste_remuneracao
			,altera_funcao
			,altera_cod_funcao
			,altera_grade
			,mes_de_alteracao_de_cr
			,alteracao_de_cr
			,localizacao_cod
			,altera_local_fisico
			,vaga_comissionada
			,descricao_ur
			)
		SELECT [1] AS 'nome_funcionario'
			,[2] AS 'matricula'
			,[3] AS 'nome_funcao'
			,[4] AS 'cr'
			,[5] AS 'remuneracao_fixa'
			,[6] AS 'sindicato'
			,[7] AS 'nome_sindicato'
			,[8] AS 'multicontrato'
			,[9] AS 'codigo_afastado'
			,[10] AS 'motivo_afastamento'
			,[11] AS 'nome_localizacao'
			,[12] AS 'chefia'
			,[13] AS 'vinculo'
			,[14] AS 'grade'
			,[15] AS 'tipo_vaga'
			,[16] AS 'sk_entidade'
			,[17] AS 'head'
			,[18] AS 'artista'
			,[19] AS 'comissionado'
			,[20] AS 'hrbp'
			,[21] AS 'ur'
			,[22] AS 'mes_exclusao_vaga'
			,[23] AS 'mes_inclusao_vaga'
			,[24] AS 'mes_retorno_afastado'
			,[25] AS 'nova_remuneracao'
			,[26] AS 'mes_de_ajuste_remuneracao'
			,[27] AS 'altera funcao'
			,[28] AS 'altera_cod_funcao'
			,[29] AS 'altera_grade'
			,[30] AS 'mes_de_alteracao_de_cr'
			,[31] AS 'alteracao_de_cr'
			,[32] AS 'localizacao_cod'
			,[33] AS 'altera_local_fisico'
			,[34] AS 'vaga_comissionada'
			,[35] AS 'descricao_ur'
		FROM c
		PIVOT(max(value) FOR rn IN (
					[1]
					,[2]
					,[3]
					,[4]
					,[5]
					,[6]
					,[7]
					,[8]
					,[9]
					,[10]
					,[11]
					,[12]
					,[13]
					,[14]
					,[15]
					,[16]
					,[17]
					,[18]
					,[19]
					,[20]
					,[21]
					,[22]
					,[23]
					,[24]
					,[25]
					,[26]
					,[27]
					,[28]
					,[29]
					,[30]
					,[31]
					,[32]
					,[33]
					,[34]
					,[35]
					)) AS PVT

		---Insere na DT
		INSERT INTO [dbo].[DT_input_alteracoes_aux] (
			[cod_user]
			,[dat_update]
			,[nome_funcionario]
			,[matricula]
			,[nome_funcao]
			,[cr]
			,[remuneracao_fixa]
			,[sindicato]
			,[nome_sindicato]
			,[multicontrato]
			,[codigo_afastado]
			,[motivo_afastamento]
			,[nome_localizacao]
			,[chefia]
			,[vinculo]
			,[grade]
			,[tipo_vaga]
			,[sk_entidade]
			,[head]
			,[artista]
			,[comissionado]
			,[hrbp]
			,[ur]
			,[mes_exclusao_vaga]
			,[mes_inclusao_vaga]
			,[mes_retorno_afastado]
			,[nova_remuneracao]
			,[mes_de_ajuste_remuneracao]
			,[altera_funcao]
			,[altera_cod_funcao]
			,[altera_grade]
			,[mes_de_alteracao_de_cr]
			,[alteracao_de_cr]
			,[localizacao_cod]
			,[altera_local_fisico]
			,[vaga_comissionada]
			,[descricao_ur]
			)
		SELECT 'admin.grbs'
			,GETDATE()
			,LTRIM(RTRIM(nome_funcionario))
			,LTRIM(RTRIM(matricula))
			,LTRIM(RTRIM(nome_funcao))
			,LTRIM(RTRIM(cr))
			,case when TRY_CONVERT(numeric(28,14), REPLACE(REPLACE(remuneracao_fixa, '.',''),',','.')) IS NULL
			then '0'
			else  Cast(Replace(Replace(remuneracao_fixa, '.', ''), ',','.') as numeric(28,14))
			end as remuneracao_fixa
			,LTRIM(RTRIM(sindicato))
			,LTRIM(RTRIM(nome_sindicato))
			,LTRIM(RTRIM(multicontrato))
			,LTRIM(RTRIM(codigo_afastado))
			,LTRIM(RTRIM(motivo_afastamento))
			,LTRIM(RTRIM(nome_localizacao))
			,LTRIM(RTRIM(chefia))
			,LTRIM(RTRIM(vinculo))
			,LTRIM(RTRIM(grade))
			,LTRIM(RTRIM(tipo_vaga))
			,LTRIM(RTRIM(sk_entidade))
			,LTRIM(RTRIM(head))
			,LTRIM(RTRIM(artista))
			,LTRIM(RTRIM(comissionado))
			,LTRIM(RTRIM(hrbp))
			,LTRIM(RTRIM(ur))
			,LTRIM(RTRIM(mes_exclusao_vaga))
			,LTRIM(RTRIM(mes_inclusao_vaga))
			,LTRIM(RTRIM(mes_retorno_afastado))
			,case when TRY_CONVERT(numeric(28,14), REPLACE(REPLACE(nova_remuneracao, '.',''),',','.')) IS NULL
			then '0'
			else  Cast(Replace(Replace(nova_remuneracao, '.', ''), ',','.') as numeric(28,14))
			end as nova_remuneracao
			,LTRIM(RTRIM(mes_de_ajuste_remuneracao))
			,LTRIM(RTRIM(altera_funcao))
			,LTRIM(RTRIM(altera_cod_funcao))
			,LTRIM(RTRIM(altera_grade))
			,LTRIM(RTRIM(mes_de_alteracao_de_cr))
			,LTRIM(RTRIM(alteracao_de_cr))
			,LTRIM(RTRIM(localizacao_cod))
			,LTRIM(RTRIM(altera_local_fisico))
			,LTRIM(RTRIM(vaga_comissionada))
			,LTRIM(RTRIM(descricao_ur))
		FROM tmp_etl_export_ur
		WHERE matricula is not null and ur <> 'ur'




		--Atualiza Campos
		UPDATE DT_input_alteracoes
		SET mes_exclusao_vaga = ISNULL(DT2.mes_exclusao_vaga, '')
			,mes_inclusao_vaga = ISNULL(DT2.mes_inclusao_vaga, '')
			,mes_retorno_afastado = ISNULL(DT2.mes_retorno_afastado, '')
			,nova_remuneracao = DT2.nova_remuneracao
			,mes_de_ajuste_remuneracao = ISNULL(DT2.mes_de_ajuste_remuneracao, '')
			,altera_funcao = ISNULL(DT2.altera_funcao, '')
			,altera_grade = ISNULL(DT2.altera_grade, '')
			,mes_de_alteracao_de_cr = ISNULL(DT2.mes_de_alteracao_de_cr, '')
			,localizacao_cod = ISNULL(DT2.localizacao_cod, '')
			,altera_local_fisico = ISNULL(DT2.altera_local_fisico, '')
			,vaga_comissionada = ISNULL(DT2.vaga_comissionada, '')
			,altera_codigo_funcao = ISNULL(DT2.altera_cod_funcao,'')
		FROM DT_input_alteracoes DT
		INNER JOIN DT_input_alteracoes_aux DT2 ON (DT.matricula = DT2.matricula AND DT.ur = DT2.ur)

		SET @i = @i + 1
	END
END