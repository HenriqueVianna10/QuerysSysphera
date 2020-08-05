select 
codUser as Usuario,
datExecutionStart as Data,
dscReportPath as Relatorio

from REP_LOGREPORT  where datExecutionStart in(

select  max(datExecutionStart) as ultima_execucao from REP_LOGREPORT 
where codApplication = 10

and right(dscReportPath,charindex('/',Reverse(dscReportPath))-1) not in( 

'11.02.03.01 - CAPITAL EXPENDITURES',
'11.02.03.02 - CAPITAL EXPENDITURES BY AREA',
'11.02.03.04 - CAPEX - FORECAST DETALHADO',
'11.02.03.04 - CAPEX - FORECAST DETALHADO - COMPARAÇÃO CENARIOS',
'11.02.03.05 - CAPEX – ADERÊNCIA',
'11.02.03.09 - CAPEX - Checks and Balances',
'11.02.03.10 - CAPEX - Checks and Balances – Detailed',
'11.02.03.17 – CAPEX – Forecast Detalhado – Completo')
and dscReportPath not like '/Validação/%'
and codUser not like '%tc6%'
and codUser not like 'jackelline.barbosa'
and codUser not like 'AURELIO.NEVES'
group by 
dscReportPath, right(dscReportPath,charindex('/',Reverse(dscReportPath))),charindex('/',Reverse(dscReportPath))
)
order by datExecutionStart desc