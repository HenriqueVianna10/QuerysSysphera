select 
	   u.cenario as Cenário,
	   u.entidade as Empresa,
	   u.cr as Centro_de_Responsabilidade,
	   u.conta as Rubrica,
	   u.[valor_jan] as Valor_Jan, 
       u.[valor_fev] as Valor_Fev, 
	   u.[valor_mar] as Valor_Mar, 
	   u.[valor_abr] as Valor_Abr, 
	   u.[valor_mai] as Valor_Mai, 
	   u.[valor_jun] as Valor_Jun, 
	   u.[valor_jul] as Valor_Jul, 
	   u.[valor_ago] as Valor_Ago, 
	   u.[valor_set] as Valor_Set, 
	   u.[valor_out] as Valor_Out, 
	   u.[valor_nov] as Valor_Nov, 
	   u.[valor_dez] as Valor_Dez,
	   u.[valor_jan] + u.[valor_fev] + u.[valor_mar] + u.[valor_abr] + u.[valor_mai] + u.[valor_jun] + u.[valor_jul] + u.[valor_ago] + u.[valor_set] + u.[valor_out] + u.[valor_nov] + u.[valor_dez] as Total
from (select [yearnotunique] as ano, lower('valor_' + t.[shortMonthName]) mes, f.[sk_cenario], f.[sk_conta], f.[sk_entidade],f.entidade,f.cr,f.conta,f.cenario,
	  f.[sk_consolidacao], f.[sk_centro_de_custo], f.[valor]
	  from [vw_app1] f
	  inner join [d_tempo_app1] t on f.[sk_tempo] = t.[sk_tempo]
	  where f.sk_cenario in (select max(sk_cenario) from d_cenario_app1 where principal = 'Sim')
	  and     len(isNull(f.codigo_conta,' ')) > 1
	  and     f.sk_consolidacao in (-1,2)
	  and     f.valor != 0 
	  ) as c
pivot (sum([valor]) for mes in ([valor_jan], [valor_fev], [valor_mar], [valor_abr], [valor_mai], [valor_jun], [valor_jul], [valor_ago], [valor_set], [valor_out], [valor_nov], [valor_dez])) as u