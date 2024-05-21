select p.sk_conta,
	   p.sk_cenario,
	   p.sk_entidade,
	   p.sk_centro_de_custo,
	   sum(Janeiro) as Valor_JAN,
	   sum(Fevereiro) as Valor_FEV,
	   sum(Março) as Valor_MAR

from (
select 
		t.[date],
		t.monthName,
		v.sk_conta,
		v.sk_tempo,
		v.sk_cenario,
		v.sk_entidade,
		v.sk_centro_de_custo,
		v.ano,
		sum(v.valor) as value
from	vw_app1 as v 
inner join d_tempo_app1 t on v.sk_tempo = t.sk_tempo
where	v.sk_cenario in (select max(sk_cenario) from d_cenario_app1 where principal = 'Sim')
and     len(isNull(v.codigo_conta,' ')) > 1
and     v.sk_consolidacao in (-1,2)
and     v.valor != 0
group by t.[date],
		t.monthName,
		v.sk_conta,
		v.sk_tempo,
		v.sk_cenario,
		v.sk_entidade,
		v.sk_centro_de_custo,
		v.ano
)p
pivot(sum(p.value) for p.monthName in ([Janeiro],[Fevereiro],[Março])
)p

group by p.sk_conta, p.sk_cenario, p.sk_entidade, p.sk_centro_de_custo