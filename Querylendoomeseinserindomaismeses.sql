select w.tempo1, w.tempo2, w.tempo3
From (
select distinct 397 as sk_conta, /*@cenario as sk_cenario,*/ temp2.sk_tempo as tempo2, DT.sk_entidade, DT.sk_lotacao, DT.sk_centro_de_custo, -1 as sk_consolidacao, temp2.tempo_l4, temp3.sk_tempo as tempo3, temp.sk_tempo as tempo1
from f_app2 fto
inner join DT_lotacao_tmp DT on (DT.sk_entidade = fto.sk_entidade and DT.sk_lotacao = Fto.sk_lotacao and DT.sk_centro_de_custo = FTo.sk_centro_de_custo)
inner join d_tempo_app2 Temp on (RIGHT(DT.mes_retorno_afastado,2) = RIGHT(YEAR(Temp.date),2) and SUBSTRING(DT.mes_retorno_afastado,4,2) = IIF(CAST(MONTH(temp.date) as VARCHAR(max)) <= 9, '0' + CAST(MONTH(temp.DATE) as VARCHAR(max)), CAST(MONTH(temp.DATE) as VARCHAR(max))))
inner join d_cenario_app2 cen on (cen.sk_cenario = 15)
inner join d_tempo_app2 temp2 on 1 = 1
inner join d_tempo_app2 temp3 on (YEAR(cen.date_end) = YEAR(temp3.date) and MONTH(cen.date_end) = MONTH(temp3.date))
inner join f_app2_scenario_audit [audit] on (fto.sk_cenario = [audit].sk_scenario and fto.sk_tempo = [audit].sk_time)
where DT.mes_retorno_afastado is not null and [audit].value = 2 and temp2.sk_tempo >= Temp.sk_tempo and temp2.sk_tempo <= temp3.sk_tempo)w