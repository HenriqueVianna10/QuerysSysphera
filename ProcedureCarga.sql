USE [PRJ_GRUPO_RBS]
GO

/****** Object:  StoredProcedure [dbo].[sp_etl_atualiza_DT_Pluri]    Script Date: 7/15/2020 5:55:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
Cria a tabela que vai receber os dados
CREATE TABLE [dbo].[tmp_etl_export_pluri_dados](
	[id] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
*/




CREATE PROCEDURE [dbo].[sp_etl_atualiza_DT_Pluri]
AS
BEGIN
	--
	-- Busca os dados do CSV 
	-- Insere os dados na DT
	-- Limpa Fato
	-- Insere os dados na fato
	-- Criado por: Henrique Vianna
	-- Data      : 2020-06-30
	-- limpa a tabela de dados CSV

	SET NOCOUNT ON;

	TRUNCATE TABLE tmp_etl_export_pluri_dados

	-- limpa a tabela com os dados pivotados
	TRUNCATE TABLE tmp_etl_export_pluri


	--traz os dados do arquivos CSV e insere na tabela de dados
	DECLARE @id INT;
	DECLARE @data VARBINARY(max);
	DECLARE @sk_cenario INT;
	DECLARE @ano INT;

	SELECT @id = max(identificador)
	FROM DT_importar_arquivo_plurianual as id

	SELECT @data = arquivo, 
		   @sk_cenario = cenario, 
		   @ano = ano
	FROM DT_importar_arquivo_plurianual
	WHERE identificador = @id 


	INSERT tmp_etl_export_pluri_dados (id)
	--SELECT replace(replace(value, '"', ''), CHAR(13), '') as id -- ALteração gabriel evitando campos delimitados por aspas
	SELECT value AS id
	FROM string_split(cast(@data AS VARCHAR(max)), CHAR(10));

	-- Pivoteia os dados e insere na tabela 
	WITH C
	AS (
		SELECT id
			,value
			,ROW_NUMBER() OVER (
				PARTITION BY id ORDER BY (
						SELECT NULL
						)
				) AS rn
		FROM tmp_etl_export_pluri_dados
		CROSS APPLY string_split(ID, ';') AS bk
		)
	INSERT INTO tmp_etl_export_pluri (
		cod_empresa
		,cod_pacote
		,cod_conta
		,sk_entidade
		,sk_conta
		,janeiro
		,fevereiro
		,marco
		,abril
		,maio
		,junho
		,julho
		,agosto
		,setembro
		,outubro
		,novembro
		,dezembro
		,Total
		)
	SELECT --Id
		[1] AS 'cod_empresa'
		,[2] AS 'cod_pacote'
		,[3] AS 'cod_conta'
		,[4] AS 'sk_entidade'
		,[5] AS 'sk_conta'
		,[6] AS 'janeiro'
		,[7] AS 'fevereiro'
		,[8] AS 'marco'
		,[9] AS 'abril'
		,[10] AS 'maio'
		,[11] AS 'junho'
		,[12] AS 'julho'
		,[13] AS 'agosto'
		,[14] AS 'setembro'
		,[15] AS 'outubro'
		,[16] AS 'novembro'
		,[17] AS 'dezembro'
		,[18] AS Total
	FROM C
	Pivot(max(Value) FOR RN IN (
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
				)) AS PVT


	
	-- limpa a dt que vai receber os dados
	TRUNCATE TABLE DT_etl_pluri_tmp

	--insere os dados na DT
	INSERT INTO DT_etl_pluri_tmp (
		 cod_user
		,dat_update
		,sk_entidade
		,sk_conta
		,janeiro
		,fevereiro
		,marco
		,abril
		,maio
		,junho
		,julho
		,agosto
		,setembro
		,outubro
		,novembro
		,dezembro
		,cod_empresa
		,cod_pacote
		,cod_conta
		,sk_cenario
		,sk_tempo
		,tmp_sk_conta
		,tmp_sk_entidade
		)
	SELECT 
		 'etl'
		,getdate()
		,-2
		,-2
		,cast(iif(ltrim(rtrim(replace(replace(janeiro, '.', ''), ',', '.'))) NOT IN ('','-'), ltrim(rtrim(replace(replace(janeiro, '.', ''), ',', '.'))), '0') AS DECIMAL(23, 4)) AS janeiro
		,cast(iif(ltrim(rtrim(replace(replace(fevereiro, '.', ''), ',', '.'))) NOT IN ('','-'), ltrim(rtrim(replace(replace(fevereiro, '.', ''), ',', '.'))), '0') AS DECIMAL(23, 4)) AS fevereiro
		,cast(iif(ltrim(rtrim(replace(replace(marco, '.', ''), ',', '.'))) NOT IN ('','-'), ltrim(rtrim(replace(replace(marco, '.', ''), ',', '.'))), '0') AS DECIMAL(23, 4)) AS marco
		,cast(iif(ltrim(rtrim(replace(replace(abril, '.', ''), ',', '.'))) NOT IN ('','-'), ltrim(rtrim(replace(replace(abril, '.', ''), ',', '.'))), '0') AS DECIMAL(23, 4)) AS abril
		,cast(iif(ltrim(rtrim(replace(replace(maio, '.', ''), ',', '.'))) NOT IN ('','-'), ltrim(rtrim(replace(replace(maio, '.', ''), ',', '.'))), '0') AS DECIMAL(23, 4)) AS maio
		,cast(iif(ltrim(rtrim(replace(replace(junho, '.', ''), ',', '.'))) NOT IN ('','-'), ltrim(rtrim(replace(replace(junho, '.', ''), ',', '.'))), '0') AS DECIMAL(23, 4)) AS junho
		,cast(iif(ltrim(rtrim(replace(replace(julho, '.', ''), ',', '.'))) NOT IN ('','-'), ltrim(rtrim(replace(replace(julho, '.', ''), ',', '.'))), '0') AS DECIMAL(23, 4)) AS julho
		,cast(iif(ltrim(rtrim(replace(replace(agosto, '.', ''), ',', '.'))) NOT IN ('','-'), ltrim(rtrim(replace(replace(agosto, '.', ''), ',', '.'))), '0') AS DECIMAL(23, 4)) AS agosto
		,cast(iif(ltrim(rtrim(replace(replace(setembro, '.', ''), ',', '.'))) NOT IN ('','-'), ltrim(rtrim(replace(replace(setembro, '.', ''), ',', '.'))), '0') AS DECIMAL(23, 4)) AS setembro
		,cast(iif(ltrim(rtrim(replace(replace(outubro, '.', ''), ',', '.'))) NOT IN ('','-'), ltrim(rtrim(replace(replace(outubro, '.', ''), ',', '.'))), '0') AS DECIMAL(23, 4)) AS outubro
		,cast(iif(ltrim(rtrim(replace(replace(novembro, '.', ''), ',', '.'))) NOT IN ('','-'), ltrim(rtrim(replace(replace(novembro, '.', ''), ',', '.'))), '0') AS DECIMAL(23, 4)) AS novembro
		,cast(iif(ltrim(rtrim(replace(replace(dezembro, '.', ''), ',', '.'))) NOT IN ('','-'), ltrim(rtrim(replace(replace(dezembro, '.', ''), ',', '.'))), '0') AS DECIMAL(23, 4)) AS dezembro
		,LTRIM(RTRIM(cod_empresa))
		,LTRIM(RTRIM(cod_pacote))
		,LTRIM(RTRIM(cod_conta))
		,@sk_cenario
		,@ano
		,LTRIM(RTRIM(sk_conta))
		,LTRIM(RTRIM(sk_entidade))
	FROM tmp_etl_export_pluri
	WHERE cod_pacote <> 'Pacote';

	--Atualiza as Sk das Contas
	Update DT_etl_pluri_tmp
	set sk_conta = tmp_sk_conta
	from DT_etl_pluri_tmp dt inner join
	d_conta_app3 c on dt.sk_conta = c.sk_conta
	where tmp_sk_conta in (select sk_conta from d_conta_app3)

	--Atualiza as Sk das Entidade
	Update DT_etl_pluri_tmp
	set sk_entidade = tmp_sk_entidade
	from DT_etl_pluri_tmp dt inner join
	d_entidade_app3 c on dt.sk_conta = c.sk_entidade
	where tmp_sk_entidade in (select sk_entidade from d_entidade_app3)


	--Limpa Fato
	DELETE 
	FROM f_app3
	WHERE sk_tempo IN (
			SELECT sk_tempo
			FROM d_tempo_app3 where id_tempo_l0 = @ano
			)
		AND sk_cenario = @sk_cenario

-- insere os dados na fato
	INSERT INTO f_app3 (
		 sk_conta
		,sk_tempo
		,sk_cenario
		,sk_entidade
		,value
		,cod_user
		,dat_update
		,type_update
		,sk_consolidacao
		)
	SELECT sk_conta
		,dte.sk_tempo
		,@sk_cenario
		,sk_entidade
		,Sum(value)
		,'etl'
		,getdate()
		,'6'
		,- 1
	FROM (
		SELECT sk_conta
			,sk_entidade
			,value
			,sk_tempo
			,competencia
		FROM DT_etl_pluri_tmp AS a
		unpivot(value FOR competencia IN (
					janeiro
					,fevereiro
					,marco
					,abril
					,maio
					,junho
					,julho
					,agosto
					,setembro
					,outubro
					,novembro
					,dezembro
					)) AS u
		) AS fto
	INNER JOIN d_tempo_app3 AS dte ON (
			dte.id_tempo_l0 = fto.sk_tempo
			AND replace(dte.monthName, 'ç', 'c') = fto.competencia
			)
		group by sk_conta, sk_entidade, dte.sk_tempo

END
GO


