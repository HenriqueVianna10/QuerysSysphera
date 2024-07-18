CREATE PROCEDURE [dbo].[sp_etl_logCarga_finish]
	 @logId       as int
	,@log_status  as nvarchar(50) = NULL
	,@observacoes as nvarchar(3000) = NULL
AS 

BEGIN
    

    SET NOCOUNT ON;

	declare @parametros   as nvarchar(300)
	
    --- Insere dados de execução na tabela de log 
    update DT_app01_etl_log
	set   data_fim = getdate()
	     ,fim_carga = convert(nvarchar(50), getdate(), 120)
		 ,log_status = isNull(@log_status,'OK')
		 ,tempo_minutos = CAST(DATEDIFF(MILLISECOND,data_inicio, getdate()) as decimal(20,2))/60000
		 ,descricao = descricao + case when len(isNull(@observacoes,'')) > 1 then ' | ' + @observacoes else '' end
	where id = @logId

END
