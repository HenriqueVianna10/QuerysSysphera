delete f_app1
from f_app1 f
inner join (
select x.conta, x.tempo, x.cenario, x.entidade, x.produto, x.sk_consolidacao, x.sk_moeda, x.sk_entidade_para, x.value, x.cod_user, x.dat_update, x.type_update, x.hashData
from (
select conta, tempo, cenario, entidade, produto, sk_consolidacao, sk_moeda, sk_entidade_para, sum(value) as value, max(cod_user) as cod_user, getdate() as dat_update, '6' as type_update, '01.3.Carga Despesas - Manual - PARCIAL (Ajuste Manual)' as hashData
from (select conta, tempo, cenario, entidade, produto, 6 as sk_consolidacao, -1 as sk_moeda, -1 as sk_entidade_para, valor_local as value, cod_user
from DT_etl_sap_despesas
where cenario in (select etl_cenario from DT_configuracoes_app1)
--and tempo in (select etl_competencia from DT_configuracoes_app1)
UNION ALL
select conta, tempo, cenario, entidade, produto, 6 as sk_consolidacao, 5 as sk_moeda, -1 as sk_entidade_para, valor_dolar as value, cod_user
from DT_etl_sap_despesas
where cenario in (select etl_cenario from DT_configuracoes_app1)
--and tempo in (select etl_competencia from DT_configuracoes_app1)
) as x
group by conta, tempo, cenario, entidade, produto, sk_consolidacao, sk_moeda, sk_entidade_para
)x
left join (
select sk_conta, sk_tempo, sk_cenario, sk_entidade, sk_produto, sk_consolidacao, sk_moeda, sk_entidade_para
from f_app1
where sk_cenario in (select etl_cenario from DT_configuracoes_app1)
--and sk_tempo in (select etl_competencia from DT_configuracoes_app1)
and sk_consolidacao = 6
) x2
on x2.sk_conta = x.conta
--and x2.sk_tempo = x.tempo
and x2.sk_cenario = x.cenario
and x2.sk_entidade = x.entidade
and x2.sk_produto = x.produto
and x2.sk_consolidacao = x.sk_consolidacao
and x2.sk_moeda = x.sk_moeda
and x2.sk_entidade_para = x.sk_entidade_para
where x2.sk_conta is null
) x
on x.conta = f.sk_conta and
   x.cenario = f.sk_cenario and
   x.tempo = f.sk_tempo and
   x.entidade = f.sk_entidade 