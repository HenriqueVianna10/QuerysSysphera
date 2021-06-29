USE [gruporbs_sysphera_prd]
GO

/****** Object:  StoredProcedure [dbo].[sp_etl_carrega_csv_fato]    Script Date: 6/29/2021 1:41:30 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[sp_etl_carrega_csv_fato]
AS
BEGIN
declare @txtCSV as varchar(max)
declare @varCSV as varbinary(max)
declare @cenario as int
declare @cenarionome as varchar(max)

truncate table DT_etl_csv_dados_da_fato


select @cenario = (select cast(dscValue as int) from REP_LOADPARAMETER 
                    where codLoadParameter = 2)
select @cenarionome = (select cenario from d_cenario_app3 where sk_cenario = @cenario)


SELECT @txtCSV = 'Agrupamento Geral 2;Agrupamento Geral 3;Agrupamento Geral 4;Agrupamento Negócio;Agrupamento Negócio 2;Agrupamento Macro;Cia Gerencial;Cia Fiscal;Pacote;Rubrica;Ano;Valor;cenario'+char(10)+

  STUFF(
    (select char(10)+
                cast(ent.agrupamento_geral_2  as nvarchar(250)) + ';' 
			  + cast(ent.agrupamento_geral_3  as nvarchar(250)) + ';' 
			  + cast(ent.agrupamento_geral_4  as nvarchar(250)) + ';'
			  + cast(ent.agrupamento_negocio  as nvarchar(250)) + ';'
			  + cast(ent.agrupamento_negocio_2  as nvarchar(250)) + ';'
			  + cast(ent.agrupamento_macro   as nvarchar(250)) + ';'
			  + cast(ent.codigo + ' - ' + ent.nome  as nvarchar(250)) + ';'
			  + cast(ent.cia_fiscal + ' - ' + ent.cia_fiscal_nome  as nvarchar(250)) + ';'
			  + cast(con.codigo_pacote + ' - ' + con.nome_pacote  as nvarchar(250)) + ';'
			  + cast(con.conta as nvarchar(250)) + ';'
			  + cast(tem.id_tempo_l0  as nvarchar(250)) + ';'
			  + cast(replace(sum(fto.value), '.',',')  as nvarchar(250)) + ';'
			  + cast(@cenarionome as nvarchar(250)) + ';'
from f_app3 fto
inner join d_conta_app3 con on (fto.sk_conta = con.sk_conta)
inner join d_tempo_app3 tem on (fto.sk_tempo = tem.sk_tempo)
inner join d_cenario_app3 cen on (fto.sk_cenario = cen.sk_cenario)
inner join d_entidade_app3 ent on (fto.sk_entidade = ent.sk_entidade)
inner join d_consolidacao_app3 cons on (fto.sk_consolidacao = cons.sk_consolidacao)
where fto.sk_cenario = @cenario and fto.sk_consolidacao in (-1, 4, 5)
group by ent.agrupamento_geral_2, ent.agrupamento_geral_3, ent.agrupamento_geral_4, ent.agrupamento_negocio, ent.agrupamento_negocio,
		 ent.agrupamento_negocio_2, ent.agrupamento_negocio_3, ent.agrupamento_macro, ent.codigo, ent.nome, ent.cia_fiscal, ent.cia_fiscal_nome, 
		 con.codigo_pacote, con.nome_pacote, con.conta, tem.id_tempo_l0
order by id_tempo_l0 asc
	FOR XML PATH('')), 1, 1, '') ;
	select @varCSV = cast(@txtCSV as varbinary(max))


insert into DT_etl_csv_dados_da_fato(cod_user, dat_update, cenario, arquivo, arquivo_fileName, log)
								values ('admin',getdate(),@cenario, @varCSV,'DadosFatoSysphera.csv', 'ok')

	update DT_etl_csv_dados_da_fato set log = case when arquivo is not null then 'OK'
												   when arquivo is null then 'Não Existem dados nesse cenário'
												   end 
END



							
GO


