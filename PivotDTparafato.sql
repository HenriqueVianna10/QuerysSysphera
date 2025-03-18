ALTER view [dbo].[vw_dt_detalhamento_opex_pivot] as 
select fto.id_ano
	  ,fto.sk_entidade
	  ,fto.sk_cenario
	  ,dte.sk_tempo
	  ,fto.sk_conta
	  ,fto.nome_mes
	  ,dte.shortMonthName
	  ,fto.descricao
	  ,fto.fornecedor
	  ,fto.total
	  ,fto.valor
	  ,fto.cod_user
	  ,fto.dat_update
from  (select u.id_ano, u.sk_cenario, u.sk_entidade, u.sk_conta, u.descricao, u.fornecedor, u.total, u.valor, u.nome_mes, u.cod_user, u.dat_update
       from dt_detalhamento_opex as a
       unpivot (valor for nome_mes in (valor_jan, valor_fev, valor_mar, valor_abr, valor_mai, valor_jun, valor_jul, valor_ago, valor_set, valor_out, valor_nov, valor_dez)
      ) as u) as fto inner join
	  d_tempo_app1 as dt1 on (dt1.sk_tempo = fto.id_ano) inner join
	  d_tempo_app1 as dte on 	  (dte.id_tempo_l1 = dt1.id_tempo_l1 and 'valor_' + dte.shortMonthName = fto.nome_mes)
--where	fto.valor != 0
GO
