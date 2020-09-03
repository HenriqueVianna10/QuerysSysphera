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