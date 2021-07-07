/*Tarefa de Autenticação*/

create procedure [dbo].[sp_json_authentication]
as
begin

		insert into REP_DATALOAD_REST(datCreated,dscName,jsnParameter)values(getdate(),'authentication',
			N'{
				 "Url" :  "http://187.94.60.35:10385/rest_tst/Login?cUsr=sysphera&cPswd=petros@123" ,
				 "AuthenticateType" :  "None" ,
				 "UserName" :  "None" ,
				 "Password" :  "None" ,
				 "RequestMethod" :  "GET" ,
				 "Body" :   ""
				}')

end

exec sp_json_authentication


/*Tarefa 03: Atualiza Rep DataLoad Rest*/

CREATE PROCEDURE [dbo].[sp_rep_dataload_rest] 

(@Carga int )

AS

BEGIN

  SET NOCOUNT ON;

	declare @Token as nvarchar(500)
	declare @Competencia as nvarchar(100)
	-- truncate table rep_dataload_rest

	---- Insert para a autenticação

		select @Token = value from openjson 
						((select jsnResponse from REP_DATALOAD_REST where dscName = 'authentication' and dscHttpResponseCode = 'OK'))
						where [key] = 'CTOKEN'

						--substring(MAX(jsnResponse),73,32)
						--from  REP_DATALOAD_REST
						--where dscName = 'authentication' and dscHttpResponseCode = 'OK'

		select @Competencia = t.tempo_l0 + cast(month(t.date) as nvarchar(10))
							  from    REP_LOADPARAMETER l inner join d_tempo_app1 t on l.dscValue = t.sk_tempo
							  where   codLoadParameter = 1


				IF @Carga = 1 
				BEGIN
						-- Insert para os contratos. Substituir o TOKEN pelo que teve no retorno da autenticação.
							insert into REP_DATALOAD_REST(datCreated,dscName,jsnParameter)values(getdate(),'jsonContratos',
								N'{
										"Url" :  "http://187.94.60.35:10385/rest_tst/CN9?cToken=' + @Token + '"' + ' ,
										"AuthenticateType" :  "None" ,
										"UserName" :  "None" ,
										"Password" :  "None" ,
										"RequestMethod" :  "GET" ,
										"Body" :   ""
									}')
				END

				IF @Carga = 2
				BEGIN
							-- FUNCIONARIOS
							insert into REP_DATALOAD_REST(datCreated,dscName,jsnParameter)values(getdate(),'jsonFuncionarios',
								N'{
										"Url" :  "http://187.94.60.35:10385/rest_tst/SRA?cToken='+ @Token + '"' + ' ,
										"AuthenticateType" :  "None" ,
										"UserName" :  "None" ,
										"Password" :  "None" ,
										"RequestMethod" :  "GET" ,
										"Body" :   ""
									}')
				END

				IF @Carga = 3
				BEGIN
							-- VERBAS
							insert into REP_DATALOAD_REST(datCreated,dscName,jsnParameter)values(getdate(),'jsonVerbas',
								N'{
										"Url" :  "http://187.94.60.35:10385/rest_tst/SRD?cToken='+ @Token + '&ccompet=' + @Competencia + '"' + ' ,
										"AuthenticateType" :  "None" ,
										"UserName" :  "None" ,
										"Password" :  "None" ,
										"RequestMethod" :  "GET" ,
										"Body" :   ""
									}')
				END

				IF @Carga = 4
				BEGIN
								-- BALANCETE
							insert into REP_DATALOAD_REST(datCreated,dscName,jsnParameter)values(getdate(),'jsonBalancete',
								N'{
										"Url" :  "http://187.94.60.35:10385/rest_tst/BALANC?cToken='+ @Token + '&ccompet=' + @Competencia + '"' + ' ,
										"AuthenticateType" :  "None" ,
										"UserName" :  "None" ,
										"Password" :  "None" ,
										"RequestMethod" :  "GET" ,
										"Body" :   ""
									}')
				END

				IF @Carga = 5
				BEGIN
								-- PCO
							insert into REP_DATALOAD_REST(datCreated,dscName,jsnParameter)values(getdate(),'jsonPCO',
								N'{
										"Url" :  "http://187.94.60.35:10385/rest_tst/PCO?cToken='+ @Token + '&ccompet=' + @Competencia + '"' + ' ,
										"AuthenticateType" :  "None" ,
										"UserName" :  "None" ,
										"Password" :  "None" ,
										"RequestMethod" :  "GET" ,
										"Body" :   ""
									}')
				END

				IF @Carga = 6
				BEGIN
								-- CAPEX
							insert into REP_DATALOAD_REST(datCreated,dscName,jsnParameter)values(getdate(),'jsonCAPEX',
								N'{
										"Url" :  "http://187.94.60.35:10385/rest_tst/CAPEX?cToken='+ @Token + '"' + ' ,
										"AuthenticateType" :  "None" ,
										"UserName" :  "None" ,
										"Password" :  "None" ,
										"RequestMethod" :  "GET" ,
										"Body" :   ""
									}')
				END


		update REP_DATALOAD_REST
		set    dscHttpResponseCode = 'OK | OK'
		where  dscName = 'authentication'

END

exec sp_rep_dataload_rest 1

/*JSON > TMP*/

CREATE PROCEDURE [dbo].[sp_json_contratos]
  @pCodDataLoadRest as int = NULL
AS
BEGIN
  --
  -- Atualiza os dados de funcionarios
  --
  -- Criado por: Cristiano Leite
  -- Data      : 2019-07-26
  --
  SET NOCOUNT ON;

  declare @codDataLoadRest int = 1;
  declare @rownum int = 0;
  declare @message as nvarchar(2000);
  declare @dt_start datetime2 = getdate();
  declare @dt_end datetime2 = getdate();

  --exec etl.addLogStart 'sp_json_funcionarios';

  select @codDataLoadRest = max(codDataLoadRest)
        ,@message = 'PARAM: codDataLoadRest (MAX OK): ' + cast(max(codDataLoadRest) as nvarchar(5)) + ' de ' + convert(nvarchar, max(datCreated), 121)
  from   REP_DATALOAD_REST as r
  where  r.dscName = 'jsonContratos'
  and    r.dscHttpResponseCode = 'OK'

  IF (@pCodDataLoadRest is not null) 
    select @codDataLoadRest = @pCodDataLoadRest
	      ,@message = 'PARAM: pCodDataLoadRest (Parametro): ' + cast(@pCodDataLoadRest as nvarchar(5))

  IF (@codDataLoadRest is null)
    select @message = 'codDataLoadRest NÃO ENCONTRADO'

--    exec etl.addLogMessage 'sp_json_funcionarios', @message
  
  BEGIN TRY
    delete tmp_json_contratos

		insert into tmp_json_contratos    (CALCAPRO,
										   CANO,
										   CCATALOGO,
										   CCC,
										   CCOD,
										   CCODFORN,
										   CCONTSERV,
										   CCTACTB,
										   CDATAFIM,
										   CDATAINI,
										   CDESCCATA,
										   CDESCCC,
										   CDESCCTA,
										   CDESCFORN,
										   CDTASSINAT,
										   CFIL,
										   CMODAL,
										   CNUMCONTRA,
										   CNUMPETROS,
										   COBJETO,
										   CSETOR,
										   CTIPOREV,
										   CTPCONTRA,
										   CVIGENCIA,
										   NSALDO,
										   NVLRATUAL,
										   NVLRCTGCS)


		select ltrim(rtrim(CALCAPRO)),
			   ltrim(rtrim(CANO)),
			   ltrim(rtrim(CCATALOGO)),
			   ltrim(rtrim(CCC)),
			   ltrim(rtrim(CCOD)),
			   ltrim(rtrim(CCODFORN)),
			   ltrim(rtrim(CCONTSERV)),
			   ltrim(rtrim(CCTACTB)),
			   ltrim(rtrim(CDATAFIM)),
			   ltrim(rtrim(CDATAINI)),
			   ltrim(rtrim(CDESCCATA)),
			   ltrim(rtrim(CDESCCC)),
			   ltrim(rtrim(CDESCCTA)),
			   ltrim(rtrim(CDESCFORN)),
			   ltrim(rtrim(CDTASSINAT)),
			   ltrim(rtrim(CFIL)),
			   ltrim(rtrim(CMODAL)),
			   ltrim(rtrim(CNUMCONTRA)),
			   ltrim(rtrim(CNUMPETROS)),
			   ltrim(rtrim(COBJETO)),
			   ltrim(rtrim(CSETOR)),
			   ltrim(rtrim(CTIPOREV)),
			   ltrim(rtrim(CTPCONTRA)),
			   ltrim(rtrim(CVIGENCIA)),
			   ltrim(rtrim(NSALDO)),
			   ltrim(rtrim(NVLRATUAL)),
			   ltrim(rtrim(NVLRCTGCS))
		from OPENJSON(
		(select jsnResponse from REP_DATALOAD_REST where codDataLoadRest = @codDataLoadRest
		)
		) WITH (
			   CALCAPRO NVARCHAR(2000) '$.CALCAPRO',
			   CANO NVARCHAR(2000) '$.CANO',
			   CCATALOGO NVARCHAR(2000) '$.CCATALOGO',
			   CCC NVARCHAR(2000) '$.CCC',
			   CCOD NVARCHAR(2000) '$.CCOD',
			   CCODFORN NVARCHAR(2000) '$.CCODFORN',
			   CCONTSERV NVARCHAR(2000) '$.CCONTSERV',
			   CCTACTB NVARCHAR(2000) '$.CCTACTB',
			   CDATAFIM NVARCHAR(2000) '$.CDATAFIM',
			   CDATAINI NVARCHAR(2000) '$.CDATAINI',
			   CDESCCATA NVARCHAR(2000) '$.CDESCCATA',
			   CDESCCC NVARCHAR(2000) '$.CDESCCC',
			   CDESCCTA NVARCHAR(2000) '$.CDESCCTA',
			   CDESCFORN NVARCHAR(2000) '$.CDESCFORN',
			   CDTASSINAT NVARCHAR(2000) '$.CDTASSINAT',
			   CFIL NVARCHAR(2000) '$.CFIL',
			   CMODAL NVARCHAR(2000) '$.CMODAL',
			   CNUMCONTRA NVARCHAR(2000) '$.CNUMCONTRA',
			   CNUMPETROS NVARCHAR(2000) '$.CNUMPETROS',
			   COBJETO NVARCHAR(2000) '$.COBEJTO',
			   CSETOR NVARCHAR(2000) '$.CSETOR',
			   CTIPOREV NVARCHAR(2000) '$.CTIPOREV',
			   CTPCONTRA NVARCHAR(2000) '$.CTPCONTRA',
			   CVIGENCIA NVARCHAR(2000) '$.CVIGENCIA',
			   NSALDO NVARCHAR(2000) '$.NSALDO',
			   NVLRATUAL NVARCHAR(2000) '$.NVLRATUAL',
			   NVLRCTGCS NVARCHAR(2000) '$.NVRLTGCS'
			   )

			  
		update REP_DATALOAD_REST
		set    dscHttpResponseCode = 'OK | OK'
		where  codDataLoadRest = @codDataLoadRest


	END TRY
	BEGIN CATCH
		declare @errorCode int;
		declare @errorMessage nvarchar(max); 
		select @errorCode = ERROR_NUMBER(), @errorMessage = ERROR_MESSAGE();

		--exec etl.addLogError 'sp_json_funcionarios', 'Erro na atualização da TMP de Funcionarios', @errorMessage, @errorCode;
	 
		THROW;
    END CATCH

  END


/*Insere na DT Contratos*/
CREATE PROCEDURE [dbo].[sp_etl_app1_insere_contratos]

AS
BEGIN
	-- ********************************************************************** --
	-- Author:	Arthur Rasbold
	-- Date  :	2021-06-22
	-- Descr :	Insere dados de carga em uma tabela temporária
	--
	-- ********************************************************************** --

DECLARE @skCenario as int


TRUNCATE TABLE DT_etl_app1_contratos


select	@skCenario = dscValue 
from	REP_LOADPARAMETER 
where	codLoadParameter = 2



--CREATE TABLE tmp_json_contratos
--	  (
--	   CALCAPRO  ,
--	   CANO  ,
--	   CCATALOGO  ,
--	   CCC  ,
--	   CCOD  ,
--	   CCODFORN  ,
--	   CCONTSERV  ,
--	   CCTACTB  ,
--	   CDATAFIM  ,
--	   CDATAINI  ,
--	   CDESCCATA  ,
--	   CDESCCC  ,
--	   CDESCCTA  ,
--	   CDESCFORN  ,
--	   CDTASSINAT  ,
--	   CFIL  ,
--	   CMODAL  ,
--	   CNUMCONTRA  ,
--	   CNUMPETROS  ,
--	   COBJETO  ,
--	   CSETOR  ,
--	   CTIPOREV  ,
--	   CTPCONTRA  ,
--	   CVIGENCIA  ,
--	   NSALDO  ,
--	   NVLRATUAL  ,
--	   NVLRCTGCS 
--	  







INSERT INTO DT_etl_app1_contratos   (
									 cod_user
									,dat_update
									,ano
									,codigo_catalogo
									,centro_de_custo
									,codigo_fornecedor
									,servico
									,conta_contabil
									,data_inicio
									,data_fim
									,descricao_catalogo
									,descricao_centro_de_custos
									,descricao_conta_contabil
									,fornecedor
									,data_assinatura
									,filial
									,modalidade
									,moeda
									,numero_protheus
									,numero_contrato
									,objeto
									,setor
									,tipo_revisao
									,vigencia
									,saldo_contrato
									,valor_atual
									,valor_gcs
									,carregar
									,workflow
									,conta
									,entidade
									,tempo
									,conta_pai
									)

-- Alterar o try_cast depois do JSON ser tratado pelo cliente
   SELECT 
         'admin' AS USUARIO
        ,getdate() AS DATE
		,try_cast(CANO as int) as ANO
		,CCATALOGO
		,CCC	
		,CCODFORN
		,CCONTSERV
		,CCTACTB
		,convert(nvarchar, cast(CDATAINI as datetime), 112) as DATAINI
		,convert(nvarchar, cast(CDATAFIM as datetime), 112) as DATAFINAL
		,CDESCCATA
		,CDESCCC
		,CDESCCTA
		,CDESCFORN
		,convert(nvarchar, cast(CDTASSINAT as datetime), 112) as DATAFINAL
		,CFIL
		,CMODAL
		,1
		,CNUMPETROS
		,CNUMCONTRA
		,COBJETO
		,CSETOR
		,CTIPOREV
		,cast(CVIGENCIA as int) as VIGENCIA
		,NSALDO
		,NVLRATUAL
		,NVLRCTGCS
		,1 as CARREGAR
		,1 as WORKFLOW
		,-2
		,-2
		,-2
		,-2
	FROM tmp_json_contratos j




		--Atualiza contas não mapeadas
		update  DT_etl_app1_contratos
		set     conta = d.conta, conta_pai = c.sk_parent
		from    DT_depara_catalogo as d inner join 
				DT_etl_app1_contratos a on d.codigo_catalogo = a.codigo_catalogo  inner join
				d_conta_app1 c on c.codigo_catalogo = a.codigo_catalogo
		where   a.conta = -2
		
		-- Atualiza sk_parent da conta
		update  DT_etl_app1_contratos
		set     conta_pai = c.sk_parent
		from    DT_etl_app1_contratos a inner join
				d_conta_app1 c on c.codigo_catalogo = a.codigo_catalogo
		where   a.conta_pai = -2

		-- Atualiza DePara Código Catálogo
		insert into  DT_depara_catalogo (cod_user, dat_update, codigo_catalogo, nome_catalogo, conta, conta_contabil_pai)
		select distinct cod_user, dat_update, codigo_catalogo, descricao_catalogo, -2, -2
		from   DT_etl_app1_contratos as d
		where  d.conta = -2	and d.codigo_catalogo not in   (select codigo_catalogo 
															from   DT_depara_catalogo)


		--Atualiza entidade
		update  DT_etl_app1_contratos
		set		entidade = d.entidade
		from	DT_depara_entidade as d inner join 
				DT_etl_app1_contratos a on d.centro_de_custo_codigo = a.centro_de_custo
		where   a.entidade = -2

		-- Atualiza DePara Entidade
		insert into DT_depara_entidade (cod_user, dat_update, centro_de_custo_codigo, centro_de_custo_nome, entidade)
		select distinct 'admin', getdate(), centro_de_custo, descricao_centro_de_custos, -2
		from   DT_etl_app1_contratos as d
		where  d.entidade = -2 and d.centro_de_custo not in	(select centro_de_custo_codigo
															 from   DT_depara_entidade)


		-- Atualiza tempo
		update DT_etl_app1_contratos
		set    tempo = t.sk_tempo
		from   d_cenario_app1 c inner join d_tempo_app1 t on year(c.date_start) = t.tempo_l0
		where  t.monthnotunique = 'Janeiro' and c.sk_cenario = (@skCenario)

END

