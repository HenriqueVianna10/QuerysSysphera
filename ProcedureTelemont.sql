USE [Sysphera]
GO

/****** Object:  StoredProcedure [dbo].[sp_Carrega_ETL_HEADCOUNT]    Script Date: 16/03/2021 11:16:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[sp_Carrega_ETL_HEADCOUNT]
AS 
BEGIN 

--Parâmetros
DECLARE @sk_tempo INT
DECLARE @ano INT
DECLARE @mes INT

--SK_TEMPO
select @sk_tempo = (select dscValue 
					from REP_LOADPARAMETER
					where codLoadParameter = 9)


--ETL Ano
select @ano = (select Year(date)
			   from REP_LOADPARAMETER a
			   inner join d_tempo_app1 b on a.dscValue = b.sk_tempo
			   where a.codLoadParameter = 9)

--ETL MES
select @mes = (select MONTH(date)
			   from REP_LOADPARAMETER a
               inner join d_tempo_app1 b on a.dscValue = b.sk_tempo
               where a.codLoadParameter = 9)

--Limpa o mês que vai ser carregado
delete from DT_ETL_HEADCOUNT
where sk_mes = @mes and sk_ano = @ano

--Insere os dados no Datatable
insert into DT_ETL_HEADCOUNT
(cod_user, dat_update, sk_ano, sk_mes, cod_cc, cc, valor_rateio, chapa, funcionario, regional, filial, situacao, inicio_ferias, fim_ferias,
 fim_aviso_previo, codigo_funcao, funcao, admissao, demitido, admitido, demissao, contabiliza_visao_ggo, contabiliza_visao_ddg, sk_tempo, sk_entidade,
 sk_conta, sk_auxiliar)
select 
	   'ETL',
	   getdate(),
	   SK_ANO,
	   SK_MES,
	   LTRIM(RTRIM(COD_CC)),
	   LTRIM(RTRIM(CC)),
	   CAST(REPLACE(VALOR_RATEIO, ',','.') as float) / 100,
	   CHAPA,
	   LTRIM(RTRIM(FUNCIONARIO)),
	   LTRIM(REGIONAL),
	   LTRIM(RTRIM(FILIAL)),
	   LTRIM(RTRIM(SITUACAO)),
	   INICIO_FERIAS,
	   FIM_FERIAS,
	   FIM_AVISO_PREVIO,
	   LTRIM(RTRIM(CODIGO_FUNCAO)),
	   LTRIM(RTRIM(FUNCAO)),
	   ADMISSAO,
	   LTRIM(RTRIM(DEMITIDO)),
	   LTRIM(RTRIM(ADMITIDO)),
	   DEMISSAO,
	   LTRIM(RTRIM(CONTABILIZA_VISAO_GGO)),
	   LTRIM(RTRIM(CONTABILIZA_VISAO_DDG)),
	   @sk_tempo,
	   -2 as sk_entidade,
	   -2 as sk_conta,
	   -2 as sk_auxiliar   
from [Stage].[dbo].[STG_HC]
where SK_MES = @mes and SK_ANO = @ano

/*--Atualiza Sk´s Tempo
update DT_ETL_HEADCOUNT set sk_tempo = t.sk_tempo 
from DT_ETL_HEADCOUNT as d inner join 
d_tempo_app1 as t on (Month(t.date) = IIF(d.sk_mes < 10, CONCAT('0', d.sk_mes), d.sk_mes) and Year(t.date) = d.sk_ano)
where d.sk_mes = @mes and d.sk_ano = @ano
*/

--Atualiza Sk´s Entidade
update DT_ETL_HEADCOUNT set sk_entidade = e.sk_entidade
from DT_ETL_HEADCOUNT as d inner join 
d_entidade_app1 as e on d.cod_cc = e.codigo_centro_de_custo
where d.sk_mes = @mes and d.sk_ano = @ano


END 

GO


