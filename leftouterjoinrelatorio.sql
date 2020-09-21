select vsl.NUM_LANCAMENTO
      ,vsl.COD_EMPRESA
      ,vsl.COD_FILIAL_RATEIO as FilialSapiens
      ,vsl.COD_CENTRO_CUSTO  as CC_Sapiens
      ,vsl.NOM_CENTRO_CUSTO
      ,vsl.COD_CONTA_REDUZIDA as CodContaSapiens
      ,vsl.NOM_CONTA as ContaSapiens
      ,vsl.NOM_CLASSIFICACAO_CONTA
      ,vsl.DAT_LANCAMENTO
      ,vsl.NUM_COMPETENCIA_LANCAMENTO
      ,vsl.VLR_LANCAMENTO
      ,vsl.VLR_LANCAMENTO * isNull(dco.aggregation_signal,1) as VLR_AGREGACAO
      ,vsl.VLR_LANCAMENTO * case when dpc.sinal = -1 then dpc.sinal else 1 end as VLR_LANCAMENTO_SINAL
      ,dpc.sk_conta
      ,DPC.filial
      ,DPC.sinal
      ,dco.conta as contaSapiens
      ,dte.sk_tempo
      ,dte.ano
      ,dte.mes
      ,-1 as sk_entidade
      ,-1 as sk_produto
      ,-1 as sk_tipo_contratacao
      ,-1 as sk_tipo_custo
      ,-1 as sk_semana
	  ,x.sk_conta_app4_ans
	  ,x.ansconta
	  ,x.contadre
	  ,x.sk_conta_app4_dre
from   VW_STAGE_LANCAMENTO_CONTABIL as vsl inner join
      (select dt.sk_tempo
             ,dt.tempo_l0 as ano
             ,dt.tempo_l3 as mes
             ,cast(year(dt.date) as varchar(4)) + '/' + right('00' + cast(month(dt.date) as varchar(2)),2) as competencia
       from   d_tempo_app1 as dt) as dte on (vsl.NUM_COMPETENCIA_LANCAMENTO = dte.competencia) left outer join
       DT_etl_depara_conta_receita_e_custo as dpc on (vsl.COD_CONTA_REDUZIDA = dpc.conta_sapiens
                                                 and (dpc.filial = 0 or dpc.filial = vsl.COD_FILIAL_RATEIO)) left outer join
												d_conta_app2 as dco on (dco.sk_conta = dpc.sk_conta) 
	left outer join
	(select	isNull(dre.sk_conta_app2,ans.sk_conta_app2) as sk_conta_app2,
		dre.sk_conta_app4_dre,
		contadre,
		ans.sk_conta_app4_ans,
		ansconta
from  (	select codMemberSource as sk_conta_app2, codMemberDestination as sk_conta_app4_dre, conta as contadre
		from	REP_DATALINK                  as dtk inner join
				REP_DATALINK_DIMENSION        as dtd on (dtd.codDataLink = dtk.codDataLink) inner join
				REP_DATALINK_DIMENSION_MEMBER as dtm on (dtm.codDataLinkDimension = dtd.codDataLinkDimension) inner join
				d_conta_app4 as dreconta on (codMemberDestination = dreconta.sk_conta)
		where  dtk.codDataLinkId = 347 -- DRE Gerencial
		and    dtd.dscDimensionDestination = 'conta') as dre full outer join
	  (	select codMemberSource as sk_conta_app2, codMemberDestination as sk_conta_app4_ans, conta as ansconta
		from	REP_DATALINK                  as dtk inner join
				REP_DATALINK_DIMENSION        as dtd on (dtd.codDataLink = dtk.codDataLink) inner join
				REP_DATALINK_DIMENSION_MEMBER as dtm on (dtm.codDataLinkDimension = dtd.codDataLinkDimension) inner join 
				d_conta_app4 as ansconta on (codMemberDestination = ansconta.sk_conta) 
		where  dtk.codDataLinkId = 794 -- DRE ANS
		and    dtd.dscDimensionDestination = 'conta') as ans on (dre.sk_conta_app2 = ans.sk_conta_app2)) as x on (dpc.sk_conta = x.sk_conta_app2)
where  left(vsl.NUM_COMPETENCIA_LANCAMENTO,4) = @ano
and    cast(right(vsl.NUM_COMPETENCIA_LANCAMENTO,2) as int) = @mes
and    vsl.COD_FILIAL_RATEIO in(@paramFilial)
and    vsl.COD_CONTA_REDUZIDA in (@paramConta)
and    vsl.COD_CENTRO_CUSTO in(@paramCentroCusto)