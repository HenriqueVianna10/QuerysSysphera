create view [dbo].[VW_Rateio] as 

select r.entidade_origem as sk_origem, ft.entidade as entidade_origem, r.entidade_destino as sk_destino, en.entidade as entidade_destino, 
ft.sk_cenario, ft.cenario, ft.conta, ft.sk_conta, ft.mes, ft.sk_tempo, Sum(ft.value) as Valor, r.percentual_rateio as  Percentual_Rateio,
Sum(ft.value) * r.percentual_rateio as  Valor_Rateio
from DT_rateio_entidade as r
inner join 
vw_app1 as ft
on  r.entidade_origem = ft.sk_entidade 
inner join 
d_entidade_app1 as en
on r.entidade_destino = en.sk_entidade
inner join
d_conta_app1 as co
on ft.sk_conta = co.sk_conta
where ft.sk_consolidacao not in (24, 25) and co.sk_conta_l0 in (491, 2)
group by r.entidade_origem, ft.entidade, r.entidade_destino, en.entidade, ft.sk_cenario, ft.cenario, ft.conta, ft.sk_conta, ft.ano, ft.mes,  ft.sk_tempo, ft.value, r.percentual_rateio
GO

create view  [dbo].[VW_Rateio_LoadData] as 

select sk_origem, entidade_origem, sk_destino, entidade_destino, sk_cenario, cenario, conta, sk_conta, sk_tempo, Valor, Valor_Rateio, Percentual_Rateio, 24 as sk_consolidacao, sk_destino as sk_entidade
from VW_Rateio
union all 
select sk_origem, entidade_origem, sk_destino, entidade_destino, sk_cenario, cenario, conta, sk_conta,  sk_tempo, Valor, Valor_Rateio * -1 as Valor_Rateio, Percentual_Rateio, 25 as sk_consolidacao,
sk_origem as sk_entidade
from VW_Rateio