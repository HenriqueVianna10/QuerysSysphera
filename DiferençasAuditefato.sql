select
e.entidade as Area,
p.projeto,
c.consolidacao as coluna,
replace(a.value,'.',',') as ValorAtual,
replace(b.Value,'.',',') as Valor_Audit,
replace(a.value + b.value,'.',',') as ValorNovo



from f_app10 a inner join (



select
sk_conta,
sk_tempo,
sk_cenario,
sk_entidade,
sk_projeto,
sk_categoria,
sk_consolidacao,



sum(value) as Value--,
--cod_user
from f_app10_audit a
--where sk_cenario = 141 and sk_tempo = 152 and a.sk_projeto = 607
group by
sk_conta,
sk_tempo,
sk_cenario,
sk_entidade,
sk_projeto,
sk_categoria,
sk_consolidacao



) b on a.sk_entidade = b.sk_entidade and
a.sk_projeto = b.sk_projeto and
a.sk_consolidacao = b.sk_consolidacao and
a.sk_categoria = b.sk_categoria and
a.sk_cenario = b.sk_cenario and
a.sk_conta = b.sk_conta and
a.sk_tempo = b.sk_tempo
inner join d_entidade_app10 e on a.sk_entidade = e.sk_entidade
inner join d_consolidacao_app10 c on a.sk_consolidacao = c.sk_consolidacao
inner join d_projeto_app10 p on a.sk_projeto = p.sk_projeto
where a.sk_cenario = 143 and a.sk_tempo = 154