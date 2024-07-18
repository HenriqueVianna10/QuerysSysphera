CREATE PROCEDURE [dbo].[sp_etl_addLogMessage]
	@logId     int,
	@objeto    nvarchar(500),
	@mensagem  nvarchar(4000),
	@rowCount  int = NULL,
	@logStatus nvarchar(500) = 'OK'
AS
BEGIN
	SET NOCOUNT ON;
  
	declare @cod_user as nvarchar(100) = 'etl'
	declare @data_log as nvarchar(100)
	select @data_log = convert(nvarchar(50), getdate(), 120)

	insert into DT_app01_etl_log_detalhe(dat_update,data_log ,cod_user ,log_id,objeto ,mensagem ,nro_registros,log_status) 
		                    values(getdate() ,@data_log,@cod_user,@logId,@objeto,@mensagem,@rowCount,@logStatus);

END
