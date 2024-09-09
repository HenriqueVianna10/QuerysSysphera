ALTER PROCEDURE [dbo].[sp_verifica_cubo]
 AS
 BEGIN
 DECLARE @count int;
 DECLARE @msg varchar(max);
 DECLARE @msg1 varchar(max);
 DECLARE @erro nvarchar(max)


  select @count = COUNT(*)  
  from   REP_XML         as x 
  where  x.flgLastSynchronized = 'S'
  and    x.codUserLock is not null
  and    x.codApplication in (5) -- Desconsidera novas aplicações.

  select @msg1 = 'Não Existem Aplicações Bloqueadas'

  IF @count = 0
  BEGIN

   exec sp_t6_etl_log_add @msg1, @grupo = 'sp_verifica_cubo', @tipo_processo = 5, @tipo = 'I'
  

  END
  IF @count > 0
  BEGIN
   select @msg = 'ERRO APP BLOQUEADA APP' + cast(a.codApplication as nvarchar(10)) + ' (' + a.namApplication + ') está bloqueada por ' +
         u.dscFirstName + ' ' + u.dscLastName + ' (' + u.codUser + ') ou NÃO SINCRONIZADA - Valid=' + x.flgValid + '; Sync=' + x.flgLastSynchronized
  from   REP_XML         as x inner join
         REP_APPLICATION as a on (a.codApplication = x.codApplication) inner join
         REP_USER        as u on (x.codUserLock = u.codUser)
  where  x.flgLastSynchronized = 'S'
  and    x.codUserLock is not null
  and    x.codApplication in (5) -- Desconsidera novas aplicações.


  exec sp_t6_etl_log_add @msg, @grupo = 'sp_verifica_cubo', @tipo_processo = 5, @tipo = 'E'
  END

 END
