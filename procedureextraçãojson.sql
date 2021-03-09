USE [PRJ_CRUZEIRODOSUL]
GO

/****** Object:  StoredProcedure [dbo].[sp_CARGA_DW_LANCONT_TE_NOVAS]    Script Date: 3/9/2021 6:54:55 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_CARGA_DW_LANCONT_TE_NOVAS]
(
@paramInstancia int
)
AS 
BEGIN

--Carga de Dados Remota Cruzeiro Oracle Lancont_TE

--Parametros
DECLARE @json varchar(max)
DECLARE @data_Ini AS DATETIME
DECLARE @data_fim DATETIME
DECLARE @Tarefa as uniqueidentifier


SELECT @data_Ini = cast((
				SELECT left(dscValue, 10)
				FROM REP_LOADPARAMETER
				WHERE codLoadParameter = 1048
				) AS DATETIME)

	SELECT @data_fim = cast((
				SELECT left(dscValue, 10)
				FROM REP_LOADPARAMETER
				WHERE codLoadParameter = 1049
				) AS DATETIME)

	SELECT @Tarefa =
					(select cast(ltrim(rtrim(dscValue)) as uniqueidentifier)
					from REP_WORKFLOW_INSTANCE_PARAMETER a  inner join 
					REP_WORKFLOW_PROCESS_PARAMETER b on a.codParameter = b.codParameter
					and b.dscName = 'Tarefa'
					where codInstance = @paramInstancia)

select @json = jsnSQLResult
from REP_DATALOAD_GATEWAY_TASK 
where dscStatus = 'OK' and codDataLoadGatewayTask = @Tarefa
	

--Limpa a tabela que vai receber
truncate table STG_LANCONT_TE_ORACLE

--limpa a stage no periodo que vão ser carregado os dados
delete from STG_LANCONT_NOVAS
where CAST(DATAMOV AS DATETIME) between @data_Ini and @data_fim

insert into STG_LANCONT_TE_ORACLE( CODCOLIGADA,  EMPRESA, CODFILIAL, FILIAL, DATAMOV, CODCCUSTO, CCUSTO, CODCONTA_AGRUP, CODCONTA, CONTA, VLR_DEBITO, VLR_CREDITO,  COMPLEMENTO)
select                             CODCOLIGADA,  EMPRESA, CODFILIAL, FILIAL, DATAMOV, CODCCUSTO, CCUSTO, CODCONTA_AGRUP, CODCONTA, CONTA, VLR_DEBITO, VLR_CREDITO,  COMPLEMENTO
from  OPENJSON( @json)
with( 
        CODCOLIGADA		varchar(2000) '$.CODCOLIGADA' ,
		EMPRESA			varchar(2000) '$.EMPRESA',
		CODFILIAL		varchar(2000) '$.CODFILIAL',
		FILIAL			varchar(2000) '$.FILIAL',
		DATAMOV			varchar(2000) '$.DATAMOV',
		CODCCUSTO		varchar(2000) '$.CODCCUSTO',
		CCUSTO			varchar(2000) '$.CCUSTO',
		CODCONTA_AGRUP  varchar(2000) '$.CODCONTA_AGRUP',
		CODCONTA		varchar(2000) '$.CODCONTA',
		CONTA			varchar(2000) '$.CONTA',
		VLR_DEBITO		varchar(2000) '$.VLR_DEBITO',
		VLR_CREDITO		varchar(2000) '$.VLR_CREDITO',
		COMPLEMENTO     varchar(4000) '$.COMPLEMENTO'
	)


--Insere os dados extraidos do json dentro da Stage

insert into STG_LANCONT_NOVAS(CODCOLIGADA, EMPRESA, CODFILIAL, FILIAL, DATAMOV, CODCCUSTO, CCUSTO, CODCONTA, CONTA, VLR_DEBITO, VLR_CREDITO, CODCONTA_AGRUP, COMPLEMENTO)		
select 
	CAST(CODCOLIGADA AS INT),
	CAST(EMPRESA AS NVARCHAR(120)),
	CAST(CODFILIAL AS INT), 
	CAST(FILIAL AS NVARCHAR(120)), 
	CAST(DATAMOV AS DATETIME),
	CAST(CODCCUSTO AS NVARCHAR(50)), 
	CAST(CCUSTO AS NVARCHAR(120)), 
	CAST(CODCONTA AS NVARCHAR(50)), 
	CAST(CONTA AS NVARCHAR(50)), 
	CAST(REPLACE(VLR_DEBITO, ',','.') AS FLOAT), 
	CAST(REPLACE(VLR_CREDITO, ',','.') AS FLOAT), 
	CAST(CODCONTA_AGRUP AS NVARCHAR(80)), 
	CAST(COMPLEMENTO AS NVARCHAR(500))
from STG_LANCONT_TE_ORACLE

END
GO


