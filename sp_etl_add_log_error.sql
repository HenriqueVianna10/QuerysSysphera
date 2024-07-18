ALTER PROCEDURE [dbo].[sp_etl_addLogError]
	@logId     int,
	@objeto    nvarchar(500),
	@mensagem  nvarchar(4000),
	@errorMessage nvarchar(500),
	@errorCode    int = -1
AS
BEGIN
	SET NOCOUNT ON;

	declare @cod_user as nvarchar(100) = 'etl'
	declare @data_log as nvarchar(100)
	select @data_log = convert(nvarchar(50), getdate(), 120)

	insert into DT_app01_etl_log_detalhe(dat_update,data_log ,cod_user ,log_status,log_id,objeto ,mensagem ,cod_erro  ,mensagem_erro) 
	                        values(getdate() ,@data_log,@cod_user,'ERRO'    ,@logId,@objeto,@mensagem,@errorCode,@errorMessage);

	-- Encerra o Log de Carga com o erro.
	exec sp_etl_logCarga_finish @LogId, 'ERRO', @mensagem



END