CREATE PROCEDURE [dbo].[sp_etl_addLogStart]
  @logId     int,
  @objeto    nvarchar(500)
AS
BEGIN
  SET NOCOUNT ON;

  declare @cod_user as nvarchar(100) = 'etl'
  declare @data_log as nvarchar(100)
  select @data_log = convert(nvarchar(50), getdate(), 120)

  insert into DT_APP01_ETL_LOG_DETALHE(log_id,dat_update,data_log ,cod_user ,log_status ,objeto ,mensagem) 
                          values(@logId,getdate() ,@data_log,@cod_user,'-- BEGIN --',@objeto,'------------------ B E G I N ------------------');

END
