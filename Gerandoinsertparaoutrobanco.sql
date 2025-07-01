select 'insert into f_app2(sk_conta,sk_tempo,sk_cenario,sk_entidade,sk_funcao,sk_consolidacao,sk_processo,type_update,dat_update,value,cod_user)values('+cast(f.sk_conta as nvarchar(20))+','+cast(sk_tempo as nvarchar(20))+',80,'+cast(sk_entidade as nvarchar(20))+','+cast(sk_funcao as nvarchar(20))+','+cast(sk_consolidacao as nvarchar(20))+','+cast(sk_processo as nvarchar(20))+','+cast(type_update as nvarchar(20))+',getdate(),'+cast(value as nvarchar(20))+','''+cod_user+''')'
from f_app2 f
inner join d_conta_app2 d on f.sk_conta = d.sk_conta
where f.sk_tempo = 139
and f.sk_cenario = 80
and d.sk_conta_l1 = 425