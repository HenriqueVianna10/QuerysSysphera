/*
declare @id int;
declare @data varbinary(max);

select @id = max(identificador)
from DT_importar_arquivo_plurianual

select @data = arquivo
from DT_importar_arquivo_plurianual
where identificador = @id

select value as id
into _teste1
from string_split(cast(@data as varchar(max)), char(10))

select * from _teste1

select id, value
from _teste1
	cross apply string_split(ID, ';') as bk



with C as(
select id, value, ROW_NUMBER() over(partition by id order by (select null)) as rn
from _teste1
	cross apply string_split(ID, ';') as bk
)
select Id
	   ,[1] as 'cod_empresa'
	   ,[2] as 'cod_pacote'
	   ,[3] as 'cod_conta'
	   ,[4] as 'sk_entidade'
	   ,[5] as 'sk_conta'
	   ,[6] as 'janeiro'
	   ,[7] as 'fevereiro'
	   ,[8] as 'marco'
	   ,[9] as 'abril'
	   ,[10] as 'maio'
	   ,[11] as 'junho'
	   ,[12] as 'julho'
	   ,[13] as 'agosto'
	   ,[14] as 'setembro'
	   ,[15] as 'outubro'
	   ,[16] as 'novembro'
	   ,[17] as 'dezembro'
	   ,[18] as Total
into tmp_etl_export_pluri
from C
Pivot(
	max(Value)
	for RN IN([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20])
) as PVT


--Criar uma tabela auxiliar pra carregar os dados e depois passar para a original

--truncate table tmp_etl_export_pluri
--alter table  tmp_etl_export_pluri add [identificador] [int] IDENTITY(1,1) NOT NULL
--select * from tmp_etl_export_pluri


insert into tmp_etl_export_pluri(cod_empresa, cod_pacote, cod_conta, sk_entidade, sk_conta, janeiro, fevereiro, marco, abril, maio, junho, julho, agosto, setembro, outubro, novembro, dezembro, Total)
select cod_empresa, cod_pacote, cod_conta, sk_entidade, sk_conta, janeiro, fevereiro, marco, abril, maio, junho, julho, agosto, setembro, outubro, novembro, dezembro, Total
from _teste2
where cod_pacote <> 'Pacote'
*/

--truncate table DT_etl_pluri_tmp
select * from DT_etl_pluri_tmp


insert into DT_etl_pluri_tmp(cod_user, dat_update, sk_entidade, sk_conta, janeiro, fevereiro, marco, abril, maio, junho, julho, agosto, setembro, outubro, novembro, dezembro,
cod_empresa, cod_pacote, cod_conta, sk_cenario, sk_tempo)
select
	LTRIM(RTRIM('etl')),
	LTRIM(RTRIM(getdate())),
	LTRIM(RTRIM(sk_entidade)),
	LTRIM(RTRIM(sk_conta)),
	cast(iif(ltrim(rtrim(replace(replace(janeiro,'.',''),',','.'))) not in ('','-'),ltrim(rtrim(replace(replace(janeiro,'.',''),',','.'))),'0') as decimal(23,4)) as janeiro,
	cast(iif(ltrim(rtrim(replace(replace(fevereiro,'.',''),',','.'))) not in ('','-'),ltrim(rtrim(replace(replace(fevereiro,'.',''),',','.'))),'0') as decimal(23,4)) as fevereiro,
	cast(iif(ltrim(rtrim(replace(replace(marco,'.',''),',','.'))) not in ('','-'),ltrim(rtrim(replace(replace(marco,'.',''),',','.'))),'0') as decimal(23,4)) as marco,
	cast(iif(ltrim(rtrim(replace(replace(abril,'.',''),',','.'))) not in ('','-'),ltrim(rtrim(replace(replace(abril,'.',''),',','.'))),'0') as decimal(23,4)) as abril,
	cast(iif(ltrim(rtrim(replace(replace(maio,'.',''),',','.'))) not in ('','-'),ltrim(rtrim(replace(replace(maio,'.',''),',','.'))),'0') as decimal(23,4)) as maio,
	cast(iif(ltrim(rtrim(replace(replace(junho,'.',''),',','.'))) not in ('','-'),ltrim(rtrim(replace(replace(junho,'.',''),',','.'))),'0') as decimal(23,4)) as junho,
	cast(iif(ltrim(rtrim(replace(replace(julho,'.',''),',','.'))) not in ('','-'),ltrim(rtrim(replace(replace(julho,'.',''),',','.'))),'0') as decimal(23,4)) as julho,
	cast(iif(ltrim(rtrim(replace(replace(agosto,'.',''),',','.'))) not in ('','-'),ltrim(rtrim(replace(replace(agosto,'.',''),',','.'))),'0') as decimal(23,4)) as agosto,
	cast(iif(ltrim(rtrim(replace(replace(setembro,'.',''),',','.'))) not in ('','-'),ltrim(rtrim(replace(replace(setembro,'.',''),',','.'))),'0') as decimal(23,4)) as setembro,
	cast(iif(ltrim(rtrim(replace(replace(outubro,'.',''),',','.'))) not in ('','-'),ltrim(rtrim(replace(replace(outubro,'.',''),',','.'))),'0') as decimal(23,4)) as outubro,
	cast(iif(ltrim(rtrim(replace(replace(novembro,'.',''),',','.'))) not in ('','-'),ltrim(rtrim(replace(replace(novembro,'.',''),',','.'))),'0') as decimal(23,4)) as novembro,
	cast(iif(ltrim(rtrim(replace(replace(dezembro,'.',''),',','.'))) not in ('','-'),ltrim(rtrim(replace(replace(dezembro,'.',''),',','.'))),'0') as decimal(23,4)) as dezembro,
	LTRIM(RTRIM(cod_empresa)),
	LTRIM(RTRIM(cod_pacote)),
	LTRIM(RTRIM(cod_conta)),
	LTRIM(RTRIM(3)),
	LTRIM(RTRIM(2020))
from tmp_etl_export_pluri

--tmp_etl_export_pluri_dados

select * from tmp_etl_export_pluri_dados

--drop table tmp_etl_export_pluri_dados
--drop table tmp_etl_export_pluri
--truncate table DT_etl_pluri_tmp