USE [PRJ_GRUPO_RBS]
GO

/****** Object:  StoredProcedure [dbo].[sp_etl_atualiza_DT_Pluri]    Script Date: 6/30/2020 6:09:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[sp_etl_atualiza_DT_Pluri]
as
begin

--
    -- Atualiza os dados do CSV 
    --
    -- Criado por: Henrique Vianna
    -- Data      : 2020-06-30


-- limpa a tabela de dados CSV
truncate table tmp_etl_export_pluri_dados

-- limpa a tabela com os dados pivotados
truncate table tmp_etl_export_pluri

-- limpa a dt que vai receber os dados
truncate table DT_etl_pluri_tmp

--traz os dados do arquivos CSV e insere na tabela de dados
declare @id int;
declare @data varbinary(max);

select @id = max(identificador)
from DT_importar_arquivo_plurianual

select @data = arquivo
from DT_importar_arquivo_plurianual
where identificador = @id

insert tmp_etl_export_pluri_dados(id)
select value as id
from string_split(cast(@data as varchar(max)), char(10));


-- Pivoteia os dados e insere na tabela 

with C as(
select id, value, ROW_NUMBER() over(partition by id order by (select null)) as rn
from tmp_etl_export_pluri_dados
	cross apply string_split(ID, ';') as bk
)
insert into tmp_etl_export_pluri(cod_empresa, cod_pacote, cod_conta, sk_entidade, sk_conta, janeiro, fevereiro, marco, abril, maio, junho, julho, agosto, setembro, outubro, novembro, dezembro, Total)
select --Id
	    [1] as 'cod_empresa'
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
from C
Pivot(
	max(Value)
	for RN IN([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20])
) as PVT


--insere os dados na DT

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
where cod_pacote <> 'Pacote'

end
GO


