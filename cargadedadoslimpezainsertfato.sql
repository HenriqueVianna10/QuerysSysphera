DECLARE @cenario INT;


select @cenario = dscValue from REP_LOADPARAMETER
where codLoadParameter = 6



delete fto 
from 
f_app1 fto
inner join f_app1_scenario sce on (sce.sk_cenario = @cenario and fto.sk_tempo = sce.sk_tempo)
where fto.sk_tempo in (select distinct sk_tempo from DT_etl_tmp_sysphera_faturamento) and sce.value <> 2
and hashData = 'CargaFaturamento'



--Insert Fato Carga Direct Charges
DECLARE @cenario INT;


select @cenario = dscValue from REP_LOADPARAMETER
where codLoadParameter = 6


insert into f_app1(sk_conta, sk_tempo, sk_cenario, sk_entidade, sk_empresa, sk_produto, sk_cliente, sk_consolidacao, sk_moeda, value, cod_user, dat_update, hashData)

select sk_conta, DT.sk_tempo, @cenario sk_cenario, sk_entidade, sk_empresa, sk_produto, sk_cliente, sk_consolidacao, sk_moeda, sum(units) as value, 'admin', GETDATE(), 'CargaFaturamento' 
from  DT_sysphera_faturamento dt
inner join f_app1_scenario sce on (sce.sk_cenario = @cenario and dt.sk_tempo = sce.sk_tempo)
where sce.value <> 2 --Insere os dados se o cenário não for do tipo fechado
group by sk_conta, DT.sk_tempo, sk_cenario, sk_entidade, sk_empresa, sk_produto, sk_cliente, sk_consolidacao, sk_moeda

