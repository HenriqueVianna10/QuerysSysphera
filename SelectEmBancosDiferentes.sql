insert into DT_wkf_responsaveis_recursos_humanos(cod_user, dat_update, unidade, responsavel, cargo, tarefa)
select 'admin', GETDATE(), unidade, responsavel, cargo, 64 from BRSPO1SSQL25.sysphera.dbo.DT_wkf_responsaveis_recursos_humanos
