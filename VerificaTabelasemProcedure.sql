SELECT DISTINCT so.name
FROM syscomments sc
INNER JOIN sysobjects so ON sc.id=so.id
WHERE sc.TEXT LIKE '%f_app1_backup%'
 
 
SELECT DISTINCT so.name
FROM syscomments sc
INNER JOIN sysobjects so ON sc.id=so.id
WHERE sc.TEXT LIKE '%f_app1_backup%'
 

SELECT DISTINCT so.name
FROM syscomments sc
INNER JOIN sysobjects so ON sc.id=so.id
WHERE sc.TEXT LIKE '%f_app1_backup%'
 
 
select flgSubType, t.dscValue, p.dscName, p.* 
from REP_WORKFLOW_PROCESS_ITEM_TASK t
inner join REP_WORKFLOW_PROCESS_ITEM i
		on i.codItem = t.codItem
inner join REP_WORKFLOW_PROCESS p
		on p.codProcess = i.codProcess
where p.datInvalid is null
and t.dscValue like '%f_app1_backup%'