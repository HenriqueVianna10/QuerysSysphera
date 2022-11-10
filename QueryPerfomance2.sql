
-- Script de Auditoria

create table #log(id int IDENTITY(1,1) NOT NULL,logName nvarchar(2000) NULL,col01 nvarchar(2000) NULL,col02 nvarchar(2000) NULL,col03 nvarchar(2000) NULL,col04 nvarchar(2000) NULL,col05 nvarchar(2000) NULL,col06 nvarchar(2000) NULL,col07 nvarchar(2000) NULL,col08 nvarchar(2000) NULL,col09 nvarchar(2000) NULL,col10 nvarchar(2000) NULL)

--insert into #log(logName,col01,col02,col03) values ('**********', '**********', '**********', '**********')
insert into #log(logName,col01,col02,col03) values ('', 'codApplication', 'namApplication', 'dscAdvise')
insert into #log(logName,col01,col02,col03,col04)
select 'REP_XML History' as logName, a.codApplication, a.namApplication, count(*) as numHistorico, case when count(*) > 1000 then 'CLEAN HISTORY' else '' end
from	REP_XML as x inner join REP_APPLICATION as a on (a.codApplication = x.codApplication)
where	flgLastSynchronized = 'N' and flgValid = 'N'
group by a.codApplication, a.namApplication


insert into #log(logName) values ('****************************************')
insert into #log(logName,col01,col02,col03) values ('', 'flgState', 'flgStateName', 'numInstances')
insert into #log(logName,col01,col02,col03,col04)
select	'WKF Instances History' as logName, a.flgState, b.flgStateName, count(*) as numInstances, case when count(*) > 10000 then 'MUST DELETE OLD INSTANCES' else '' end
from	REP_WORKFLOW_INSTANCE as a left outer join
		(select 0 as flgState, 'Running' as flgStateName UNION ALL
		 select 1 as flgState, 'Finished' as flgStateName UNION ALL
		 select 2 as flgState, 'Waiting' as flgStateName UNION ALL
		 select 3 as flgState, 'Paused' as flgStateName UNION ALL
		 select 4 as flgState, 'Stopped' as flgStateName UNION ALL
		 select 5 as flgState, 'Executing' as flgStateName UNION ALL
		 select 6 as flgState, 'Error' as flgStateName) as b on (a.flgState = b.flgState)
group by a.flgState, b.flgStateName

insert into #log(logName) values ('****************************************')
insert into #log(logName,col01,col02) values ('', 'codParameter', 'dscParameter')
insert into #log(logName,col01,col02)
select	'Parameters' as logName, codParameter, dscParameter
from	REP_PARAMETER
where	codParameter in ('EnableActiveDirectoryLogin','EnableLogs','EnableSingleSignOn','LastUpdateBuildNumber','PowerBIClientID','PowerPlanningUrl','reportingServicesCache','SyspheraWebFormInternalUrl','SyspheraWebFormUrl')
order by 2

insert into #log(logName) values ('****************************************')
insert into #log(logName,col01,col02,col03,col04) values ('', 'codApplication', 'namApplication', 'codParameter', 'dscParameter')
insert into #log(logName,col01,col02,col03,col04)
select	'Aplication Parameters' as logName, a.codApplication, a.namApplication, x.codParameter, x.dscParameter
from	REP_APPLICATION_PARAMETER as x inner join REP_APPLICATION as a on (a.codApplication = x.codApplication)
where	x.codParameter in ('CompressXMLCube','CompressXMLDimension','Integration')
order by 2


insert into #log(logName) values ('****************************************')
insert into #log(logName,col01,col02,col03,col04,col05,col06) values ('', 'TableName', 'SchemaName', 'RowCounts', 'TotalSpaceKB', 'UsedSpaceKB', 'UnusedSpaceKB')
insert into #log(logName,col01,col02,col03,col04,col05,col06)
SELECT top 20 'Big Tables - Top 20' as logName,
    t.NAME AS TableName,
    s.Name AS SchemaName,
    p.rows AS RowCounts,
    SUM(a.total_pages) * 8 AS TotalSpaceKB, 
    SUM(a.used_pages) * 8 AS UsedSpaceKB, 
    (SUM(a.total_pages) - SUM(a.used_pages)) * 8 AS UnusedSpaceKB
FROM 
    sys.tables t INNER JOIN      
    sys.indexes i ON t.OBJECT_ID = i.object_id INNER JOIN 
    sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id INNER JOIN 
    sys.allocation_units a ON p.partition_id = a.container_id LEFT OUTER JOIN 
    sys.schemas s ON t.schema_id = s.schema_id
WHERE 
--    t.NAME NOT LIKE 'dt%' AND 
	t.is_ms_shipped = 0 AND i.OBJECT_ID > 255 
GROUP BY     t.Name, s.Name, p.Rows
ORDER BY     5 desc


-- ACESSOS Últimos 30 dias
insert into #log(logName) values ('****************************************')
insert into #log(logName,col01,col02,col03) values ('', 'yyyymmdd', 'users', 'acessos')
insert into #log(logName,col01,col02,col03)
select 'Total logins last 30 days' as logName, format(datActionDate,'yyyy-MM-dd') as yyyymmdd, count(distinct codUser) users, count(*) acessos
from   REP_LOG_SECURITY_TRAIL
where  datActionDate >= DATEADD(DAY,-30,getdate())
group by format(datActionDate,'yyyy-MM-dd')
order by 1 desc

-- Últimas 30 conexões
insert into #log(logName) values ('****************************************')
insert into #log(logName,col01,col02,col03,col04,col05) values ('', 'date', 'codUser', 'nameUser', 'flgActive','dscDescription')
insert into #log(logName,col01,col02,col03,col04,col05)
select top 30 'Last 30 logins' as logName, t.datActionDate, t.codUser, u.dscFirstName + ' ' + u.dscLastName as userName, u.flgActive, t.dscDescription
from	REP_LOG_SECURITY_TRAIL as t inner join
		REP_USER as u on (u.codUser = t.codUser)
where	dscInformationType = 'Login'
order by t.datActionDate desc

-- Uso Últimos 15 Dias
insert into #log(logName) values ('****************************************')
insert into #log(logName,col01,col02,col03) values ('', 'dateExecution', 'objectName','executions')
insert into #log(logName,col01,col02,col03)
select	'Objects opened last 15 days' as logName, format(ex.datExecutionStart,'yyyy-MM-dd') as datExecution, ob.dscName, count(*) as execs
from	(select top 100 *
		 from REP_EXPLORER_OBJECT_EXECUTION
		 where  datExecutionStart >= DATEADD(DAY,-15,getdate())
		 order by datExecutionStart desc)as ex inner join
		REP_USER as ru on (ru.userCode = ex.codUser) inner join
		REP_EXPLORER_OBJECT as ob on (ob.codObject = ex.codObject)
where	ob.flgType in (3,4,6,7,11,14,15,18,21,22,29,30,31,38)
group by format(ex.datExecutionStart,'yyyy-MM-dd'), ob.dscName
order by 1 desc, 2


-- Licenças
insert into #log(logName) values ('****************************************')
insert into #log(logName,col01,col02,col03) values ('', 'profiles', 'QtdMainProfile', 'QtdMaindProfileConsolidation')
insert into #log(logName,col01,col02,col03)
select	'Usuários Ativos x Perfil' as logName,
		case
         when x.profiles = 'A' then '1.Admin'
		 when x.profiles = 'G' then '2.Manager'
		 when x.profiles = 'P' then '3.Planner'
		 when x.profiles = 'N' then '4.Analyst'
		 when x.profiles = 'X' then '5.None'
		 else 'ERROR'
	   end as profiles
      ,sum(x.MainProfile) as MainProfile
	  ,sum(x.MaindProfileConsolidation) as MaindProfileConsolidation
from  (select u.flgMainProfile as profiles
             ,count(*) as MainProfile
			 ,0 as MaindProfileConsolidation
       from   REP_USER as u
       where  flgActive = 'S'
       group by u.flgMainProfile
	   UNION ALL
       select u.flgMainProfileConsolidation as profiles
             ,0 as MainProfile
			 ,count(*) as MainProfileConsolidation
       from   REP_USER as u
       where  flgActive = 'S'
       group by u.flgMainProfileConsolidation) as x
group by case
           when x.profiles = 'A' then '1.Admin'
		   when x.profiles = 'G' then '2.Manager'
		   when x.profiles = 'P' then '3.Planner'
		   when x.profiles = 'N' then '4.Analyst'
		   when x.profiles = 'X' then '5.None'
		   else 'ERROR'
	     end

declare @totApps as int = 0;
declare @iter as int = 1;
declare @tableName as nvarchar(500);
declare @appName as nvarchar(500);
declare @sql as nvarchar(4000);

select	ROW_NUMBER() over(order by codApplication) as id, codApplication, namApplication
into	#apps
from	REP_APPLICATION

select @totApps = count(*) from #apps

insert into #log(logName) values (' ')
insert into #log(logName,col01,col02) values ('##############','- POR APP -','##############')
insert into #log(logName) values (' ')

while @iter <= @totApps 
begin

	select	@tableName = 'F_APP' + cast(codApplication as nvarchar(5)),
			@appName = namApplication
	from #apps where id = @iter

	insert into #log(logName,col01) values ('>>>>>>>>>  ' + @tableName + '  >>>>>>>>>','APP Name: '+@appName)

	set @sql = 'insert into #log(logName,col01,col02)'
	+ 'select ''' + @tableName + ' - #Registros'' as logName, count(*) as #registros, format(max(dat_update),''yyyy-MM-dd hh:mm'') as max_date from ' + @tableName
--	insert into #log(logName) values ('****************************************')
	insert into #log(logName,col01,col02) values ('', '#registros', 'max_date')
	EXECUTE sp_executesql @SQL;

	set @sql = 'insert into #log(logName,col01,col02)'
	+ 'select ''' + @tableName + ' - avg_fragmentation_in_percent'' as logName, avg_fragmentation_in_percent, case when avg_fragmentation_in_percent > 0.2 then ''DESFRAGMENTAR'' when avg_fragmentation_in_percent > 0.1 then ''MONITORAR'' else '' '' end from sys.dm_db_index_physical_stats (DB_ID(), OBJECT_ID(''' + @tableName
	+ '''), NULL, NULL, NULL) WHERE index_type_desc = ''CLUSTERED INDEX'' AND alloc_unit_type_desc = ''IN_ROW_DATA'''
--	insert into #log(logName) values ('****************************************')
	insert into #log(logName,col01) values ('', 'avg_fragmentation_in_percent')
	EXECUTE sp_executesql @SQL;

	set @sql = 'insert into #log(logName,col01,col02,col03,col04)'
	+ 'select ''' + @tableName + ' - dm_db_index_physical_stats'' as logName, a.index_id, name, avg_fragmentation_in_percent, case when avg_fragmentation_in_percent > 0.2 then ''DESFRAGMENTAR'' when avg_fragmentation_in_percent > 0.1 then ''MONITORAR'' else '' '' end from sys.dm_db_index_physical_stats (DB_ID(), OBJECT_ID(''' + @tableName
	+ '''), NULL, NULL, NULL) AS a JOIN sys.indexes AS b ON a.object_id = b.object_id AND a.index_id = b.index_id'
--	insert into #log(logName) values ('****************************************')
	insert into #log(logName,col01,col02,col03) values ('', 'index_id', 'name', 'avg_fragmentation_in_percent')
	EXECUTE sp_executesql @SQL;


-- POR DIMENSÃO
	declare @maxID as int;
	declare	@iterD as int;
	declare @dimName as nvarchar(200);

	select	codXML as id, namXML as dimension, codApplication
	into	#dim
	from	REP_XML
	where	codApplication in (select codApplication from #apps where id = @iter)
	and		codXMLType = 3
	and		flgValid = 'S'
	order by codXML

	select @maxID = max(id) from #dim
	select @iterD = min(id) from #dim

	insert into #log(logName) values ('')
	insert into #log(logName,col01) values ('*** APP '+@appName + ' - Dimensions ***', '#registros')

	while @iterD <= @maxID 
	begin

		select @dimName = 'd_' + dimension + '_app' + cast(codApplication as nvarchar(5)) from #dim where id = @iterD

--		insert into #log(logName) values ('>>>>>>>>>  ' + @dimName + '  >>>>>>>>>')

		set @sql = 'insert into #log(logName,col01,col02)'
		+ 'select ''' + @dimName + ''' as logName, count(*) as #registros, ' + cast(@iterD as nvarchar(20)) + ' from ' + @dimName
		EXECUTE sp_executesql @SQL;


		set @iterD = @iterD + 1

	end;

	drop table #dim;
	insert into #log(logName) values ('')

	set @iter = @iter + 1;

end;

select	id,logName, isNull(col01,''), isNull(col02,''), isNull(col03,''), isNull(col04,''), isNull(col05,''), isNull(col06,''), isNull(col07,''), isNull(col08,''), isNull(col09,''), isNull(col10,'')
from	#log
order by 1

drop table #log
drop table #apps





