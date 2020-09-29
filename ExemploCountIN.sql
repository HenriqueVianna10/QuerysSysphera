select 1 as identificador, count(*) as quantidade
from(
select e.entidade,codigo,nome from DT_investimento i
inner join d_entidade_app10 e on i.entidade = e.sk_entidade
where codigo in (
select codigo
as valores
from DT_investimento
group by codigo
having count(*) > 1)
union 
select e.entidade,codigo,nome from DT_investimento i
inner join d_entidade_app10 e on i.entidade = e.sk_entidade
where codigo = '' and i.status = 7
union 
select e.entidade,codigo,nome from DT_investimento i
inner join d_entidade_app10 e on i.entidade = e.sk_entidade
where categoria IS NULL and i.status = 7) as tab