select dt.responsavel, usr.codUser from DT_wkf_responsaveis_recursos_humanos as dt
inner join REP_USER as usr on dt.responsavel = usr.codUser

begin tran
update DT_wkf_responsaveis_recursos_humanos set responsavel =
usr.codUser from DT_wkf_responsaveis_recursos_humanos as dt
inner join REP_USER as usr on dt.responsavel = usr.codUser