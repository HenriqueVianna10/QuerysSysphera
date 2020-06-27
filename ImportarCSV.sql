/*

-- Procedimento para exportar arquivo de dentro de DT

--

declare @id int;

declare @data varbinary(max);


 

select @id = max(identificador) 

from   DT_etl_orc_arquivos


 

select @data = arquivo

from   DT_etl_orc_arquivos

where  identificador = @id


SELECT value

FROM STRING_SPLIT(CAST(@data as VARCHAR(MAX)), char(10))


--Cia Gerencial;Pacote;SK_ENTIDADE;SK_CONTA;Jan;Fev;Mar;Abr;Mai;Jun;Jul;Ago;Set;Out;Nov;Dez;Total 
--001;301;94;16;-5.581.219,38 ;-6.323.879,67 ;-8.520.858,00 ;-6.041.368,00 ;-5.344.026,00 ;-4.930.039,79 ;-5.378.603,73 ;-6.271.250,24 ;-6.864.494,33 ;-8.038.559,37 ;-7.165.696,00 ;-6.737.117,60 ;-77.197.112,11 
--001;303;94;18;-3.239.091,77 ;-2.738.512,88 ;-4.696.702,26 ;-3.442.244,13 ;-4.675.349,71 ;-4.909.770,36 ;-3.602.224,21 ;-4.614.776,01 ;-4.400.753,93 ;-3.941.521,31 ;-4.515.168,26 ;-8.045.321,89 ;-52.821.436,72 
--001;304;94;19;-1.129.822,43 ;-308.881,81 ;-25.634,68 ; -   ;-18.335,00 ;-37.883,47 ;-3.025,56 ;-30.410,89 ;-53.999,07 ;-190.915,62 ;-465.885,57 ;-300.399,71 ;-2.565.193,82 


create table #teste2
(
	ID varchar(max) null
);


insert into #teste2(id)
Values
('001;301;94;16;-5.581.219,38 ;-6.323.879,67 ;-8.520.858,00 ;-6.041.368,00 ;-5.344.026,00 ;-4.930.039,79 ;-5.378.603,73 ;-6.271.250,24 ;-6.864.494,33 ;-8.038.559,37 ;-7.165.696,00 ;-6.737.117,60 ;-77.197.112,11'),
('001;303;94;18;-3.239.091,77 ;-2.738.512,88 ;-4.696.702,26 ;-3.442.244,13 ;-4.675.349,71 ;-4.909.770,36 ;-3.602.224,21 ;-4.614.776,01 ;-4.400.753,93 ;-3.941.521,31 ;-4.515.168,26 ;-8.045.321,89 ;-52.821.436,72'),
('001;304;94;19;-1.129.822,43 ;-308.881,81 ;-25.634,68 ; -   ;-18.335,00 ;-37.883,47 ;-3.025,56 ;-30.410,89 ;-53.999,07 ;-190.915,62 ;-465.885,57 ;-300.399,71 ;-2.565.193,82')


select id, value
from #teste2
	cross apply string_split(ID, ';') as bk

with C as(
select ID, value, ROW_NUMBER() over(partition by id order by (select null)) as rn
from #teste2
	cross apply string_split(ID, ';') as bk
)
select Id
	   ,[1] as CiaGerencial
	   ,[2] as Pacote
	   ,[3] as SK_ENTIDADE
	   ,[4] as SK_CONTA
	   ,[5] as Jan
	   ,[6] as Fev
	   ,[7] as Mar
	   ,[8] as Abr
	   ,[9] as Mai
	   ,[10] as Jun
	   ,[11] as Jul
	   ,[12] as Jul
	   ,[13] as Ago
	   ,[14] as Sete
	   ,[15] as Out
	   ,[16] as Nov
	   ,[17] as Dez
	   ,[18] as Total
from C
Pivot(
	max(Value)
	for RN IN([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20])
) as PVT
*/