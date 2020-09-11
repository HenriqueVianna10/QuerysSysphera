use sysphera

Select sk_empresa, sk_cenario, Sum(validacao) as validacao from (
select sk_tempo,
sk_cenario,
sk_entidade,
sk_tabela_salarial,
sk_cargo,
sk_vinculo,
sk_faixa, sk_conta, sk_empresa,  case when Sum(case when sk_conta = 66 then value else 0 end)  > Sum( case when sk_conta = 17 then value else 0 end) then 1 else 0 end as validacao,
Sum(case when sk_conta = 66 then value else 0 end)  as valora, Sum(case when sk_conta = 17 then value else 0 end) as valorb from f_app14
where sk_conta in (66, 17) and sk_empresa = 45 and sk_cenario = 6
group by sk_conta, sk_empresa, sk_tempo,
sk_cenario,
sk_entidade,
sk_tabela_salarial,
sk_cargo,
sk_vinculo,
sk_faixa
) as tab
group by sk_empresa, sk_cenario


select Sum(value) from f_app14
where sk_tempo = 31 and
sk_cenario = 6 and sk_entidade = 185 and sk_tabela_salarial = 8
and sk_cargo = 33 and sk_vinculo = 3 and sk_faixa = 5
and sk_conta in (66,17) and sk_empresa in( 45, 47)
group by sk_conta,
sk_tempo,
sk_cenario,
sk_entidade,
sk_empresa,
sk_tabela_salarial,
sk_cargo,
sk_vinculo,
sk_faixa