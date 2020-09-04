select cast(concat(ano,'-', IIF(len(mes) = 1, '0', ''),mes,'-01') as datetime) as date, date from d_cenario_app10 as cen
inner join d_tempo_app10 temp on  temp.date >= (cast(concat(ano,'-', IIF(len(mes) = 1, '0', ''),mes,'-01') as datetime))
where sk_cenario = 126 

select fto.sk_conta, fto.sk_projeto, proj.projeto as nome, ent.entidade as entidade, prj.coordenador as coordenador, cat.categoria as categoria, SUM(fto.value) as valor, prj.revisao
from f_app10 as fto
inner join
d_projeto_app10 as proj on fto.sk_projeto = proj.sk_projeto
inner join 
DT_projeto as prj on fto.sk_projeto = prj.dimensao_projeto and fto.sk_cenario = prj.cenario
inner join 
d_entidade_app10 as ent on fto.sk_entidade = ent.sk_entidade
inner join 
d_categoria_app10 as cat on fto.sk_categoria = cat.sk_categoria
inner join
d_cenario_app10 as cen on cen.sk_cenario = prj.cenario
--inner join 
--d_tempo_app10 as temp on temp.date >= (cast(concat(cen.ano,'-', IIF(len(cen.mes) = 1, '0', ''),cen.mes,'-01') as datetime))
--and fto.sk_tempo = temp.sk_tempo
where prj.cenario = 126 and sk_consolidacao = 17 and value <> 0 and sk_conta = 22  and prj.status = 1 and prj.revisao = 1
group by fto.sk_conta, fto.sk_projeto, proj.projeto, ent.entidade, prj.coordenador, cat.categoria, prj.revisao --temp.date
order by sk_projeto desc




select fto.sk_conta, fto.sk_projeto, proj.projeto as nome, ent.entidade as entidade, prj.coordenador as coordenador, cat.categoria as categoria, SUM(fto.value) as valor, prj.revisao
from f_app10 as fto
inner join
d_projeto_app10 as proj on fto.sk_projeto = proj.sk_projeto
inner join 
DT_projeto as prj on fto.sk_projeto = prj.dimensao_projeto and fto.sk_cenario = prj.cenario
inner join 
d_entidade_app10 as ent on fto.sk_entidade = ent.sk_entidade
inner join 
d_categoria_app10 as cat on fto.sk_categoria = cat.sk_categoria
inner join
d_cenario_app10 as cen on cen.sk_cenario = prj.cenario
inner join 
d_tempo_app10 as temp on temp.date <= (cast(concat(cen.ano,'-', IIF(len(cen.mes) = 1, '0', ''),cen.mes,'-01') as datetime))
and fto.sk_tempo = temp.sk_tempo
where prj.cenario = 127 and sk_consolidacao = 17 and value <> 0 and sk_conta = 22  and prj.status = 2 and prj.revisao = 1
and fto.sk_projeto in 
(SELECT 	
	dp.dimensao_projeto
FROM dbo.REP_WORKFLOW_INSTANCE ins WITH(NOLOCK) INNER JOIN
	dbo.REP_WORKFLOW_INSTANCE_PARAMETER AS par WITH(NOLOCK) ON(ins.codInstance = par.codInstance) INNER JOIN
	dbo.DT_projeto dp  ON(par.dscValue = CAST(dp.identificador AS NVARCHAR(MAX))) INNER JOIN
	dbo.REP_WORKFLOW_PROCESS_PARAMETER AS pan WITH(NOLOCK)  ON(par.codParameter = pan.codParameter) INNER JOIN
	(SELECT par.dscValue,MAX(ins.codInstance) AS codInstance
	FROM dbo.REP_WORKFLOW_INSTANCE ins WITH(NOLOCK) INNER JOIN
		dbo.REP_WORKFLOW_INSTANCE_PARAMETER AS par WITH(NOLOCK) ON(ins.codInstance = par.codInstance) INNER JOIN
		dbo.REP_WORKFLOW_PROCESS_PARAMETER AS pan WITH(NOLOCK)  ON(par.codParameter = pan.codParameter)
	WHERE pan.dscName='Projetos'
	GROUP BY par.dscValue) prj_ins ON(CAST(dp.identificador AS NVARCHAR(MAX))=prj_ins.dscValue AND ins.codInstance=prj_ins.codInstance) LEFT JOIN
	dbo.REP_WORKFLOW_INSTANCE_PARAMETER AS par2 WITH(NOLOCK) ON(ins.codInstance = par2.codInstance) inner JOIN
	dbo.REP_WORKFLOW_PROCESS_PARAMETER AS pan2 WITH(NOLOCK) ON( par2.codParameter = pan2.codParameter AND pan2.dscName='Responsável') LEFT JOIN
	dbo.REP_WORKFLOW_PROCESS_ITEM AS ite WITH(NOLOCK)  ON(ins.codItem = ite.codItem) LEFT JOIN
	dbo.REP_WORKFLOW_PROCESS_ITEM_TASK AS ita WITH(NOLOCK) ON( ite.codItem = ita.codItem) LEFT JOIN
	dbo.REP_WORKFLOW_PROCESS p WITH(NOLOCK) ON( ins.codProcess = p.codProcess) LEFT JOIN
	dbo.d_entidade_app10 e WITH(NOLOCK) ON( dp.entidade = e.sk_entidade) LEFT JOIN
	dbo.REP_WORKFLOW_INSTANCE_HISTORY AS hist WITH(NOLOCK) ON( ins.codInstance = hist.codInstance AND hist.datEnd IS NULL) LEFT JOIN
	dbo.REP_USER u WITH(NOLOCK) ON( par2.dscValue = u.codUser) LEFT JOIN
	dbo.REP_USER u2 WITH(NOLOCK) ON( hist.codUserStart = u2.codUser) 
WHERE pan.dscName='Projetos'
--AND ins.flgState NOT IN(1,4,5,6)
AND ita.dscName NOT IN('Revisar Viabilidade','Gerar Viabilidade')
AND dp.cenario= 127

AND p.dscName= '02 - Revisão de Projetos do CAPEX'

--AND (dp.identificador = @paramProjeto OR @paramProjeto = 0) 


GROUP BY dp.dimensao_projeto)
group by fto.sk_conta, fto.sk_projeto, proj.projeto, ent.entidade, prj.coordenador, cat.categoria, prj.revisao --temp.date
order by sk_projeto desc
