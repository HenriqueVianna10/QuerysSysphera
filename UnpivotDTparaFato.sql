select dt.cenario, dt.entidade, dt.centro_de_custos, temp.sk_tempo, codigo_produto, (Sum(valor) * Sum(custo_medio)) as value
from 
(
select cenario, entidade,centro_de_custos,codigo_produto,custo_medio,left(mes,3) as mes,right(mes,4) as ano, valor from 
(select cenario, entidade,centro_de_custos,codigo_produto,jan_2021, fev_2021, mar_2021, abr_2021,mai_2021, jun_2021, jul_2021, ago_2021, set_2021, out_2021, nov_2021, dez_2021, custo_medio
from DT_material_de_consumo)p
Unpivot (valor for Mes in 
			(jan_2021, fev_2021, mar_2021, abr_2021,mai_2021, jun_2021, jul_2021, ago_2021, set_2021, out_2021, nov_2021, dez_2021)
			) as unpvt ) as dt
			inner join d_tempo_app1 temp on temp.shortMonthName = dt.mes and temp.id_tempo_l0 = dt.ano
			where isnull(valor,0) <> 0 and isnull(custo_medio,0) <> 0
group by cenario, entidade, centro_de_custos,sk_tempo,codigo_produto