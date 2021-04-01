USE [PRJ_SUPPLIER_DEV]
GO

/****** Object:  StoredProcedure [dbo].[SP_ETL_RAZAO_FIDC]    Script Date: 4/1/2021 6:17:14 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [dbo].[SP_ETL_RAZAO_FIDC]
AS
BEGIN

DECLARE @id INT
DECLARE @data varbinary(max)
DECLARE @SK_TEMPO INT
DECLARE @MES INT
DECLARE @ANO INT
DECLARE @EMPRESA INT


--Limpa a Tabela que recebe o arquivo
truncate table tmp_etl_razao_fidc_dados

--Limpa a tabela que recebe o pivot
truncate table tmp_etl_razao_fidc_export

--Parametro de Mes e Empresa

SELECT @SK_TEMPO = (select data from DT_carrega_arquivo_fidc
                     where identificador = @id)

SELECT @MES = (SELECT MONTH(DATE) FROM d_tempo_app1
				WHERE sk_tempo = @SK_TEMPO)

SELECT @ANO = (SELECT RIGHT(YEAR(DATE),2) FROM d_tempo_app1
			   WHERE sk_tempo = @SK_TEMPO)

SELECT @EMPRESA =  0

SELECT @id = max(identificador)
	FROM DT_carrega_arquivo_fidc as id

	SELECT @data = arquivo
	FROM DT_carrega_arquivo_fidc
	WHERE identificador = @id

--Limpa TMP Sysphera


truncate table DT_tmp_razao_fidc


--Limpa DT Razão Contábil (Somente o que vai ser carregado)
delete from DT_razao_contabil 
where  right(data_lote,2) = @ANO  and
        IIF(SUBSTRING(data_lote, 4,2) < 10, RIGHT(SUBSTRING(data_lote, 4,2),1), SUBSTRING(data_lote, 4,2)) = @MES  
		and codigo_empresa = @EMPRESA

--Insere os Dados na Tabela Auxiliar
INSERT tmp_etl_razao_fidc_dados (id)
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
		FROM tmp_etl_razao_fidc_dados
		CROSS APPLY string_split(ID, ';') AS bk
		)
	INSERT INTO tmp_etl_razao_fidc_export(
		conta_contabil,
		descricao,
		data_tmp,
		historico,
		complemento,
		contrapartida,
		debito,
		credito,
		saldo,
		dc,
		origem
		)
	SELECT --Id
		 [1] AS 'conta_contabil'
		,[2] AS 'descricao'
		,[3] AS 'data_tmp'
		,[4] AS 'historico'
		,[5] AS 'complemento'
		,[6] AS 'contrapartida'
		,[7] AS 'debito'
		,[8] AS 'credito'
		,[9] AS 'saldo'
		,[10] AS 'dc'
		,[11] AS 'origem'
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
				)) AS PVT

--Inserindo os Dados na Temporária
insert into DT_tmp_razao_fidc
	(
	 cod_user,
	 dat_update,
	 conta_contabil,
	 descricao,
	 data,
	 historico,
	 complemento,
	 contrapartida,
	 debito,
	 credito,
	 saldo,
	 dc,
	 origem
	 )

select 
	 'admin',
	 GETDATE(),
	 LTRIM(RTRIM(Replace(Replace(conta_contabil,'.',''),'-',''))) as conta_contabil,
	 RTRIM(LTRIM(descricao)) as descricao,
	 RTRIM(LTRIM(data_tmp)),
	 RTRIM(LTRIM(historico)) as historico,
	 RTRIM(LTRIM(complemento)) as complemento,
	 RTRIM(LTRIM(contrapartida)),
	 case when TRY_CONVERT(numeric(28,14), REPLACE(REPLACE(debito, '.',''),',','.')) IS NULL
	      then '0'
		  else  Cast(Replace(Replace(debito, '.', ''), ',','.') as numeric(28,14))
	 end as debito,
	 case when TRY_CONVERT(numeric(28,14), REPLACE(REPLACE(credito, '.',''),',','.')) IS NULL
	      then '0'
		  else  Cast(Replace(Replace(credito, '.', ''), ',','.') as numeric(28,14))
	 end as credito,
	 case when TRY_CONVERT(numeric(28,14), REPLACE(REPLACE(saldo, '.',''),',','.')) IS NULL
	      then '0'
		  else  Cast(Replace(Replace(saldo, '.', ''), ',','.') as numeric(28,14))
	 end as saldo,
	 LTRIM(RTRIM(dc)),
	 LTRIM(RTRIM(origem))
from tmp_etl_razao_fidc_export
where descricao IS NOT NULL and conta_contabil <> 'Conta Cont‡bil' and conta_contabil <> 'Relat—rio Raz‹o Consolidado' and conta_contabil <> 'Conta Contábil' and conta_contabil <> 'Cpnta Contábil'
and debito <> 'DÅ½bito' and debito <> 'Débito' and conta_contabil <> 'ï»¿Relatâ€”rio Razâ€¹o Consolidado'


--Insere no DT Razão
insert into DT_razao_contabil
(cod_user, dat_update, codigo_empresa,  data_lote, codigo_conta, descricao_lcto, complemento, contrapartida, valor_debito, valor_credito, valor_saldo,
 origem, natureza, nome_conta, valor_lcto, numero_conta, codigo_cc, entidade, valor)

select 'admin', 
	    getdate(), 
        0 as codigo_empresa, 
		data as data_lote, 
		conta_contabil as codigo_conta, 
		historico as descricao_lcto,
		complemento as complemento,
		contrapartida,
		debito,
		credito,
		saldo,
		origem,
		dc as Natureza,
		descricao as nome_conta,
		credito - debito as valor_lcto,
		conta_contabil as numero_conta,
		-1,
		5,
		credito - debito as valor
from DT_tmp_razao_fidc

--Atualiza Tmp
update DT_tmp_razao_fidc set sk_conta = b.conta
from DT_tmp_razao_fidc a 
inner join DT_mapeamento_conta b
on a.conta_contabil = b.numero_conta
where a.sk_conta IS NULL


--Atualiza Sk Conta
update DT_razao_contabil set conta = b.conta
from DT_razao_contabil a 
inner join DT_mapeamento_conta b
on a.numero_conta = b.numero_conta
where a.conta IS NULL

--Atualiza SK Tempo
update DT_razao_contabil set tempo = @SK_TEMPO

select * from DT_tmp_razao_fidc

END

GO


