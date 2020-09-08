--Inserir no grupo

insert into REP_USER_GROUP(codGroup, codUser)

select '2393', repusr.codUser from REP_USER_APPLICATION as repapp
inner join REP_USER as repusr on repapp.codUser = repusr.codUser
where codApplication = 2 and repusr.flgActive = 'S' and repusr.codUser NOT in(select codUser from REP_USER_APPLICATION where codApplication = 13) 


--Inserir na Aplicação

insert into REP_USER_APPLICATION(codApplication, codUser, flgProfile)

select '13', repusr.codUser, 'N' from REP_USER_APPLICATION as repapp
inner join REP_USER as repusr on repapp.codUser = repusr.codUser
where codApplication = 2 and repusr.flgActive = 'S' and repusr.codUser NOT in(select codUser from REP_USER_APPLICATION where codApplication = 13) 

