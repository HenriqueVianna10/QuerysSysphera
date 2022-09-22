select * from REP_WORKFLOW_INSTANCE i
inner join REP_WORKFLOW_PROCESS p
        on p.codProcess = i.codProcess
where p.dscName like '%empenho%'
and i.flgState = 0




commit
begin tran
update REP_WORKFLOW_INSTANCE
set flgState = 4
from REP_WORKFLOW_INSTANCE i
inner join REP_WORKFLOW_PROCESS p
        on p.codProcess = i.codProcess
where p.dscName like '%empenho%'
and i.flgState = 0