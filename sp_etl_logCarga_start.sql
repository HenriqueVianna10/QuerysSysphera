CREATE PROCEDURE [dbo].[sp_etl_logCarga_start]
	 @CargaId     as int
	,@instanciaId as int
	,@observacoes as nvarchar(2000) = NULL
AS 

BEGIN
    -- 
	-- Adiciona o registro de execução do log e atualiza o idLog na DT_ETL_CARGAS
    -- Criado por: Henrique Vianna
    -- Data      : 2024-07-18
    --

    SET NOCOUNT ON;

    declare @cod_user     as nvarchar(50)
	declare @nome_user    as nvarchar(200)
	declare @inicio_carga as nvarchar(100)
	declare @parametros   as nvarchar(300) = '';
	declare @cenario      as int
	declare @tempo        as int
	declare @codApp       as int
	
    select @codApp = a.cod_app   ---Busca a Aplicação
	from   DT_app01_etl_cargas as a
	where  a.id = @CargaId       ---O Carga ID é setado na instÂncia do processo de workflow


	-- Busca o Responsável (código e nome)
	select @cod_user = w.codUserStart
	      ,@nome_user = u.dscFirstName + ' ' + u.dscLastName + ' (' + u.codUser + ')'
	from   REP_WORKFLOW_INSTANCE_HISTORY as w inner join
	       REP_USER as u on (w.codUserStart = u.codUser)
	where  w.codInstance = @instanciaId
	and    w.flgAction = 1
	and    w.codUserStart is not null  

	set @cod_user = isNull(@cod_user,'etl');

	select @inicio_carga =  convert(nvarchar(50), DATEADD(hour,-3,GETDATE()), 120) --Removendo três horas devido ao fuso do banco

    if @codApp = 1 -- Planejamento Financeiro
	begin
		select @parametros = '( '+ 'Cenário: Realizado || Competência:' + LEFT(dscValue,7) + ')'
		from REP_LOADPARAMETER as a
		where codLoadParameter = 5

	end

    --- Insere dados de execução na tabela de log 
    insert into DT_app01_etl_log(cod_user, dat_update, data_inicio, instancia_id, inicio_carga , log_status, carga_id, descricao, parametros, usuario_carga)
                         values (@cod_user, getdate(), getdate()  , @instanciaId, @inicio_carga,'INICIADO' ,@CargaId ,isNull(@observacoes,''),@parametros, @cod_user) 

	update DT_app01_etl_cargas
	set    log_id = @@IDENTITY
	where  id = @CargaId


END
