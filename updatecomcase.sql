update DT_tmp_razao_adm_part
set sk_centro_de_custo = 
 case 
 when codigo_cc is null or len(codigo_cc) <3 then -1
 else -2
 end
 from DT_tmp_razao_adm_part

--Atualiza Centro de Custos TMP
update DT_tmp_razao_adm_part set sk_centro_de_custo = e.sk_centro_de_custo
from DT_tmp_razao_adm_part a
inner join d_centro_de_custo_app1 e on (a.codigo_cc = e.codigo_cc)
where a.sk_centro_de_custo = -2

