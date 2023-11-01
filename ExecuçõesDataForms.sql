--Histórico de Execução Dataform
select a.dscName as Nome_formulário,
	   b.datExecutionStart as Data_Inicio,
	   b.datExecutionEnd as Data_Fim,
	   c.codUser
from REP_EXPLORER_OBJECT a
inner join REP_EXPLORER_OBJECT_EXECUTION b on a.codObject = b.codObject
inner join REP_USER c on b.codUser = c.userCode
where a.codReference = '4148'
order by datExecutionEnd desc

