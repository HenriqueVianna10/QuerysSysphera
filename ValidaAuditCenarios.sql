select cen.cenario as Cenario, tempo.tempo_l4 as Mes, 
case when DT.value = '1' then 'Aberto'  
	 else 'Fechado'
	 end as [Status],
	 usr.codUser as Usuário,
	 dat_update as Data
from f_app1_scenario_audit DT
inner join d_cenario_app1 cen on DT.sk_scenario = cen.sk_cenario
inner join d_tempo_app1 tempo on DT.sk_time = tempo.sk_tempo
inner join REP_USER usr on usr.userCode = dt.user_code
where sk_scenario = 39
order by dat_update desc


