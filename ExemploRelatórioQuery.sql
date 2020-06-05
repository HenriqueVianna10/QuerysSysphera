Param Regional
select distinct L79_ds_regional from
VW_DT_wkf_aux_permissoes
where usuario in (@userId)

Param Filial
select distinct IIF(len(isnull(L79_ds_filial,'')) <=1,L79_ds_regional,L79_ds_filial) as ds_filial FROM VW_DT_wkf_aux_permissoes
WHERE L79_ds_regional IN (@paramRegional) and
usuario in (@userId)

Param Entidade
SELECT DISTINCT L79_sk_entidade AS Value,  L79_entidade AS Label
from VW_DT_wkf_aux_permissoes
WHERE
L79_ds_regional IN (@paramRegional) and
L79_ds_filial IN (@paramFilial) and 
L79_sk_entidade not IN (select sk_parent from d_entidade_app1 where sk_parent is not null) and
usuario in (@userId)

Param Cenario
select distinct sk_cenario as Value, cenario as Label
from d_cenario_app1

dsDados

select top 10000 
	   dat_update,
	   entidade,
	   conta,
	   servico,
	   auxiliar,
	   consolidacao,
	   mes,
	   cod_user,
	   type_update,
	   value_signed
from vw_app1 
where sk_entidade in (@paramEntidade) and
sk_cenario in (@paramCenario)
and dat_update between (@paramTempoInicial) and (@ParamTempoFinal) and
type_update in ('1', '6','7','9')
order by dat_update DESC

