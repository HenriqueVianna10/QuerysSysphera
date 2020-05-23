/*declare @ParamCenarioPlanejado int = 4;  (3) Orçamento 2018, (4) Orçamento 2019 */

select /*[sk_cenario], [cenario], [tipocenario],
[date_start], year([date_start]) as AnoInicio,
[date_end], year([date_end]) as AnoFim, t.ano,*/
t.[Label], t.[Value], t.[Value_SQL]
from [d_cenario_app1] c
inner join (select sk_tempo as [Value_SQL], tempo_l3 as [Label], tempo_l0 as [ano],
			convert(varchar(6), [date], 112) as [AnoMes],
			'[Tempo].[Tempo].[Todos].[' + tempo_l0 + '].[' + tempo_l1 + '].[' + tempo_l2 + '].[' + tempo_l3 + ']' as [Value]
			from d_tempo_app1
			) t on cast(t.[AnoMes] as int) between cast(convert(varchar(6), c.[date_start], 112) as int) and cast(convert(varchar(6), c.[date_end], 112) as int)
where [sk_cenario] = @ParamCenarioPlanejado
order by t.[Value_SQL]