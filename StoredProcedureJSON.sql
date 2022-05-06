USE [petros_sysphera_prd]
GO
/****** Object:  StoredProcedure [dbo].[sp_json_pco]    Script Date: 5/6/2022 12:44:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[sp_json_pco]
  @pCodDataLoadRest as int = NULL
AS
BEGIN
  --
  -- Atualiza os dados de PCO
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

  --exec etl.addLogStart 'sp_json_PCO';

  select @codDataLoadRest = max(codDataLoadRest)
        ,@message = 'PARAM: codDataLoadRest (MAX OK): ' + cast(max(codDataLoadRest) as nvarchar(5)) + ' de ' + convert(nvarchar, max(datCreated), 121)
  from   REP_DATALOAD_REST as r
  where  r.dscName = 'jsonPCO'
  and    r.dscHttpResponseCode = 'OK'

  IF (@pCodDataLoadRest is not null) 
    select @codDataLoadRest = @pCodDataLoadRest
	      ,@message = 'PARAM: pCodDataLoadRest (Parametro): ' + cast(@pCodDataLoadRest as nvarchar(5))

  IF (@codDataLoadRest is null)
    select @message = 'codDataLoadRest NÃO ENCONTRADO'

--    exec etl.addLogMessage 'sp_json_PCO', @message
  
  BEGIN TRY
    delete tmp_json_PCO

		insert into tmp_json_PCO    	   (
											CCATALOGO,
											CCC,
											CCLASSE,
											CCO,
											CDESCCC,
											CDESCCO,
											CDESCCTL,
											CDT,
											CFIL,
											CHIST,
											CLOTE,
											CNUMCONTRA,
											CPROCESSO,
											CSTATUS,
											CTIPO,
											CTPSALDO,
											NCREDITO,
											NDEBITO,
											NLANCTO
											)


		select  ltrim(rtrim(CCATALOGO)) ,
				ltrim(rtrim(CCC)) ,
				ltrim(rtrim(CCLASSE)) ,
				ltrim(rtrim(CCO)) ,
				ltrim(rtrim(CDESCCC)) ,
				ltrim(rtrim(CDESCCO)),
				ltrim(rtrim(CDESCCTL)),
				ltrim(rtrim(CDT)),
				ltrim(rtrim(CFIL)),
				ltrim(rtrim(CHIST)),
				ltrim(rtrim(CLOTE)),
				ltrim(rtrim(CNUMCONTRA)),
				ltrim(rtrim(CPROCESSO)),
				ltrim(rtrim(CSTATUS)),
				ltrim(rtrim(CTIPO)),
				ltrim(rtrim(CTPSALDO)),
				ltrim(rtrim(NCREDITO)),
				ltrim(rtrim(NDEBITO)),
				ltrim(rtrim(NLANCTO))
	    from OPENJSON(
		(select jsnResponse from REP_DATALOAD_REST where codDataLoadRest = @codDataLoadRest)
		) WITH (
				CCATALOGO NVARCHAR(2000) '$.CCATALOGO' ,
				CCC NVARCHAR(2000) '$.CCC',
				CCLASSE NVARCHAR(2000) '$.CCLASSE',
				CCO NVARCHAR(2000) '$.CCO',
				CDESCCC NVARCHAR(2000) '$.CDESCCC',
				CDESCCO NVARCHAR(2000) '$.CDESCCO',
				CDESCCTL NVARCHAR(2000) '$.CDESCCTL',
				CDT NVARCHAR(2000) '$.CDT',
				CFIL NVARCHAR(2000) '$.CFIL',
				CHIST NVARCHAR(2000) '$.CHIST',
				CLOTE NVARCHAR(2000) '$.CLOTE',
				CNUMCONTRA NVARCHAR(2000) '$.CNUMCONTRA' ,
				CPROCESSO NVARCHAR(2000) '$.CPROCESSO',
				CSTATUS NVARCHAR(2000) '$.CSTATUS',
				CTIPO NVARCHAR(2000) '$.CTIPO',
				CTPSALDO NVARCHAR(2000) '$.CTPSALDO',
				NCREDITO NVARCHAR(2000) '$.NCREDITO',
				NDEBITO NVARCHAR(2000) '$.NDEBITO',
				NLANCTO NVARCHAR(2000) '$.NLANCTO'
				)

			  
		update REP_DATALOAD_REST
		set    dscHttpResponseCode = 'OK | OK'
		where  codDataLoadRest = @codDataLoadRest


	END TRY
	BEGIN CATCH
		declare @errorCode int;
		declare @errorMessage nvarchar(max); 
		select @errorCode = ERROR_NUMBER(), @errorMessage = ERROR_MESSAGE();

		--exec etl.addLogError 'sp_json_PCO', 'Erro na atualização da TMP de PCO', @errorMessage, @errorCode;
	 
		THROW;
    END CATCH

  END

