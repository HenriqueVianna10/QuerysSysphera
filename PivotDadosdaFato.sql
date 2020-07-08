use Sysphera


select * from f_app1
where sk_conta = 164

select * from d_tempo_app1
where tempo_l1 = 2020

select * from DT_detalhamento_de_contas


select f.sk_cenario, f.sk_entidade, f.sk_conta, f.sk_tempo, f.value, t.id_tempo_l1, t.monthName from f_app1 as f
inner join d_tempo_app1 as t
on f.sk_tempo = t.sk_tempo
where f.sk_conta = 164 and f.sk_tempo = 2020




select  p.sk_conta,
        p.sk_cenario,
        p.sk_entidade,
        sum(Janeiro) as Janeiro,
        sum(Fevereiro) as Fevereiro,
        sum(Março) as Março,
        sum(Abril) as Abril,
        sum(Maio) as Maio,
        sum(Junho) as Junho,
        sum(Julho) as Julho,
        sum(Agosto) as Agosto,
        sum(Setembro) as Setembro,
        sum(Outubro) as Outubro,
        sum(Novembro) as Novembro,
        sum(Dezembro) as Dezembro
from (
select  t.date,
		t.monthName,
        f.sk_conta,
        f.sk_tempo,
        f.sk_cenario,
        f.sk_entidade,
        sum(f.value) as value
from f_app1 f
inner join d_tempo_app1 t
        on t.sk_tempo = f.sk_tempo
where sk_conta = 164
and sk_cenario = 18
and year(t.date) = 2020
group by t.date,    
        f.sk_conta,
        f.sk_tempo,
        f.sk_cenario,
        f.sk_entidade,
        t.monthName
) p


pivot(sum(p.value) for p.monthName in ([Janeiro], [Fevereiro],[Março],[Abril],[Maio],[Junho],[Julho],[Agosto],[Setembro],[Outubro],[Novembro],[Dezembro])
) P

group by p.sk_conta, p.sk_cenario, p.sk_entidade


--- insert na dt


insert into DT_detalhamento_de_contas(cod_user, dat_update,cenario,entidade,conta, ano, fornecedor, janeiro, fevereiro, marco, abril, maio, junho, julho, agosto, setembro, outubro, novembro, dezembro)

select  
		'etl',
		getdate(),
		p.sk_cenario,
		p.sk_entidade,
		p.sk_conta,
		'2020',
		'FORNECEDOR GENERICO',
        sum(Janeiro) as Janeiro,
        sum(Fevereiro) as Fevereiro,
        sum(Março) as Março,
        sum(Abril) as Abril,
        sum(Maio) as Maio,
        sum(Junho) as Junho,
        sum(Julho) as Julho,
        sum(Agosto) as Agosto,
        sum(Setembro) as Setembro,
        sum(Outubro) as Outubro,
        sum(Novembro) as Novembro,
        sum(Dezembro) as Dezembro
from (

select  t.date,
		t.monthName,
        f.sk_conta,
        f.sk_tempo,
        f.sk_cenario,
        f.sk_entidade,
        sum(f.value) as value
from f_app1 f
inner join d_tempo_app1 t
        on t.sk_tempo = f.sk_tempo
where sk_conta = 164
and sk_cenario = 18
and year(t.date) = 2020
group by t.date,    
        f.sk_conta,
        f.sk_tempo,
        f.sk_cenario,
        f.sk_entidade,
        t.monthName
) p

pivot(sum(p.value) for p.monthName in ([Janeiro], [Fevereiro],[Março],[Abril],[Maio],[Junho],[Julho],[Agosto],[Setembro],[Outubro],[Novembro],[Dezembro])
) P

group by p.sk_conta, p.sk_cenario, p.sk_entidade


--select * from DT_detalhamento_de_contas

--truncate table DT_detalhamento_de_contas