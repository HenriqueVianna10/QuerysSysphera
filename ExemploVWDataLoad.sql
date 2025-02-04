select	w.Sk_Conta,
		w.sk_tempo,
		w.sk_cenario,
		w.sk_entidade,
		w.sk_consolidacao,
		w.sk_auxiliar,
		w.sk_servico,
		w.sk_produto,
		w.[value],
		w.descricao
from 
(

select dpr.sk_conta_dre as Sk_Conta,
	   fto.sk_tempo,
	   fto.sk_cenario,
	   fto.sk_entidade,
	   fto.sk_consolidacao,
	   fto.sk_auxiliar,
	   fto.sk_servico,
	   fto.sk_produto,
	   fto.[value],
	   ent.entidade + ' | ' + con.conta as descricao
from f_app1 fto 
inner join d_conta_app1 con on fto.sk_conta = con.sk_conta
inner join d_entidade_app1 ent on fto.sk_entidade = ent.sk_entidade
inner join DT_depara_contas dpr on dpr.sk_conta = fto.sk_conta
where sk_conta_dre is not null
union all
select dpr.sk_conta_bp as Sk_conta,
	   fto.sk_tempo,
	   fto.sk_cenario,
	   fto.sk_entidade,
	   fto.sk_consolidacao,
	   fto.sk_auxiliar,
	   fto.sk_servico,
	   fto.sk_produto,
	   fto.[value],
	   ent.entidade + ' | ' + con.conta as descricao
from f_app1 fto 
inner join d_conta_app1 con on fto.sk_conta = con.sk_conta
inner join d_entidade_app1 ent on fto.sk_entidade = ent.sk_entidade
inner join DT_depara_contas dpr on dpr.sk_conta = fto.sk_conta
where sk_conta_bp is not null
) as w