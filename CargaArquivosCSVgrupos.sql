USE [cruzeirodosul_sysphera_prd]
GO
/****** Object:  StoredProcedure [dbo].[sp_exporta_gmd_csv]    Script Date: 5/4/2022 8:20:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/**
exec sp_exporta_gmd_csv 1,61
*/
ALTER procedure [dbo].[sp_exporta_gmd_csv]  as


DECLARE @cenario AS INT
DECLARE @tempo AS INT
DECLARE @txtCSV AS VARCHAR(max)
DECLARE @varCSV AS VARBINARY(max)
DECLARE @cenarionome AS VARCHAR(50)
DECLARE @periodonome AS VARCHAR(50)
DECLARE @icountRows INT
DECLARE @inumRow INT
DECLARE @sk_tempoini int



DECLARE @tableGMD TABLE (
	id INT identity
	,Pacote VARCHAR(100)
	)
DECLARE @pacote VARCHAR(100)

TRUNCATE TABLE DT_ETL_CSV_Dados_GMD

select @cenario = dscvalue from REP_LOADPARAMETER where codLoadParameter = 1033
select @tempo = dscvalue from REP_LOADPARAMETER where codLoadParameter = 1034

SELECT @cenarionome = (
		SELECT cenario
		FROM d_cenario_app3
		WHERE sk_cenario = @cenario
		)

SELECT @periodonome = (
		SELECT tempo_l4
		FROM d_tempo_app3
		WHERE sk_tempo = @tempo
		)
SELECT @sk_tempoini = b.sk_tempo
FROM d_tempo_app3 a
INNER JOIN d_tempo_app3 b ON a.yearnotunique = b.yearnotunique
	AND b.monthName = 'Janeiro'
WHERE a.sk_tempo = @tempo

INSERT INTO @tableGMD (Pacote)
SELECT DISTINCT conta_pai_gmd
FROM VW_DT_etl_dados_gmd
WHERE sk_cenario = @cenario
	AND sk_tempo between @sk_tempoini and @tempo

SELECT @icountRows = count(*)
FROM @tableGMD

SET @inumRow = 1

WHILE @inumRow <= @icountRows
BEGIN
	SELECT @pacote = Pacote
	FROM @tableGMD
	WHERE id = @inumRow

	SELECT @txtCSV = 'grupo;codcoligada;empresa;codfilial;filial;datamov;codccusto;centro_de_custos;codconta;conta;vlr_debito;vlr_credito;cenario;periodo;sk_conta;valor;codFornecedor;Fornecedor;Diretoria;Gerencia;conta_pai_gmd;Consolidacao;modalidade;produto;classificacao;tipo_negocio;consolidador;Status' + CHAR(10) + STUFF((
				SELECT  cast(ltrim(rtrim(grupo)) AS NVARCHAR(20)) + ';' + cast(codcoligada AS NVARCHAR(10)) + ';' + cast(empresa AS NVARCHAR(250)) + ';' + cast(codfilial AS NVARCHAR(10)) + ';' + cast(filial AS NVARCHAR(250)) + ';' + cast(datamov AS NVARCHAR(20)) + ';' + cast(codccusto AS NVARCHAR(50)) + ';' + cast(centro_de_custos AS NVARCHAR(250)) + ';' + cast(codconta AS NVARCHAR(50)) + ';' + cast(replace(conta,';','') AS NVARCHAR(250)) + ';' + cast(vlr_debito AS NVARCHAR(50)) + ';' + cast(vlr_credito AS NVARCHAR(50)) + ';' + cast(cenario AS NVARCHAR(50)) + ';' + cast(tempo AS NVARCHAR(50)) + ';' + cast(sk_conta AS NVARCHAR(100)) + ';' + cast(valor AS NVARCHAR(50)) + ';' + cast(codFornecedor AS NVARCHAR(20)) + ';' + cast(Fornecedor AS NVARCHAR(250)) + ';' + cast(Diretoria AS NVARCHAR(50)) + ';' + cast(Gerencia AS NVARCHAR(50)) + ';' + cast(conta_pai_gmd AS NVARCHAR(50)) + ';' + cast(consolidacao AS NVARCHAR(20))  + ';' + cast(modalidade AS NVARCHAR(50)) + ';' + cast(produto AS NVARCHAR(20)) + ';' + cast(classificacao_do_centro_de_custos AS NVARCHAR(20)) + ';' + cast(Tipo_Negocio AS NVARCHAR(40)) + ';' + cast(Consolidador AS NVARCHAR(50))+ ';' + cast(Status as nvarchar(20)) + CHAR(10)
				FROM VW_DT_etl_dados_gmd
				WHERE  sk_tempo between @sk_tempoini and @tempo
					AND sk_cenario = @cenario
					AND conta_pai_gmd = @pacote
				FOR XML PATH('')
				), 1, 0, '');

	SELECT @varCSV = cast(replace(@txtCSV,'&amp;','&') AS VARBINARY(max))

	INSERT INTO DT_ETL_CSV_Dados_GMD (
		cod_user
		,dat_update
		,cenario
		,arquivo
		,arquivo_fileName
		,periodo
		,data_criacao
		)
	VALUES (
		'admin'
		,getdate()
		,@cenarionome
		,@varCSV
		,'Pacote-' + @pacote + '.csv'
		,@periodonome
		,format(dateadd(hour, 2, getdate()), 'dd/MM/yyyy HH:mm')
		)

	SET @inumRow = @inumRow + 1
	SET @varCSV = NULL
	SET @txtCSV = NULL
END

