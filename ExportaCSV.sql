
ALTER PROCEDURE [dbo].[sp_gera_arquivos]
AS
BEGIN
declare @txtCSV as varchar(max);
declare @txtCSV2 as varchar(max);
declare @varCSV as varbinary(max);
declare @varCSV2 as varbinary(max);
declare @sk_cenario as int;
declare @cenario as varchar(max);
declare @data as varchar(max);
declare @sk_tempo as int;

truncate table DT_exporta_arquivos

select @data = format(dateadd(hour, -3, getdate()), 'dd/MM/yyyy HH:mm')

select @sk_cenario = cenario,
	   @sk_tempo = mes
from DT_configura_extracao_arquivos

select @cenario = cenario from d_cenario_app5
where sk_cenario = @sk_cenario


SELECT @txtCSV ='Data Documento;Tipo Documento;Empresa;Data Lançamento;Moeda;Referência;Texto Documento;BELNR (No documento);Chave Lançamento;Tipo de Movimento;Valor Montante em Moeda do Documento;Código da Moeda;Código do IVA;Montante Imposto Moeda do Doc;Centro de Custo;No. Atribuição;Texto do Item;Elemento PEP;Chave de Referência do Parceiro de Negócios;Chave de Referência do Parceiro de Negócios;Centro de Lucro;Domicilio Fiscal;No Documento de Compras;N Item do Documento de Compra;No do Material;Unidade de Medida Básica;Conta Contábil;No Pessoal;Tipo de Movimento2;Local do Negócio (Filial);Quantidade;Data Efetiva;Ledger2;Sociedade Parceira'+char(10)+
  STUFF(
    (select char(10)+
                cast(Data_Documento as nvarchar(250)) + ';' 
			  + cast(Tipo_Documento  as nvarchar(250)) + ';' 
			  + cast(Empresa  as nvarchar(250)) + ';'
			  + cast(Data_Lancamento  as nvarchar(250)) + ';'
			  + cast(Moeda  as nvarchar(250)) + ';'
			  + cast(Referencia   as nvarchar(250)) + ';'
			  + cast(texto_documento  as nvarchar(250)) + ';'
			  + cast(BELNR as nvarchar(250)) + ';'
			  + cast(Chave_Lancamento as nvarchar(250)) + ';'
			  + cast(Tipo_de_Movimento as nvarchar(250)) + ';'
			  + CAST(Valor as nvarchar(250)) + ';'
			  + cast(Codigo_da_Moeda as nvarchar(250)) + ';'
			  + cast(Codigo_do_IVA as nvarchar(250)) + ';'
			  + cast(Montante_Imposto_moeda_do_doc  as nvarchar(250)) + ';'
			  + cast(Centro_de_Custo  as nvarchar(250)) + ';'
			  + cast(No_Atribuicao  as nvarchar(250)) + ';'
			  + cast(Texto_do_Item  as nvarchar(250)) + ';'
			  + cast(elemento_pep  as nvarchar(250)) + ';'
			  + cast(Chave_de_referencia_do_parceiro_de_negocios  as nvarchar(250)) + ';'
			  + cast(Chave_de_referencia_do_parceiro_de_negocios2  as nvarchar(250)) + ';'
			  + cast(Centro_de_Lucro  as nvarchar(250)) + ';'
			  + cast(Domicilio_Fiscal  as nvarchar(250)) + ';'
			  + cast(No_Documento_de_Compras  as nvarchar(250)) + ';'
			  + cast(No_Item_do_documento_de_compras  as nvarchar(250)) + ';'
			  + cast(No_do_Material  as nvarchar(250)) + ';'
			  + cast(Unidade_de_Medida_Basica  as nvarchar(250)) + ';'
			  + cast(Conta_Contabil as nvarchar(250)) + ';'
			  + cast(No_Pessoal  as nvarchar(250)) + ';'
			  + cast(Tipo_de_Movimento2  as nvarchar(250)) + ';'
			  + cast(Local_de_Negocio  as nvarchar(250)) + ';'
			  + cast(Quantidade  as nvarchar(250)) + ';'
			  + cast(Data_Efetiva as nvarchar(250)) + ';'
			  + cast(Ledger2  as nvarchar(250)) + ';'
			  + cast(Sociedade_Parceira  as nvarchar(250)) + ';'
from VW_Visão_AIC
	FOR XML PATH('')), 1, 1, '') ;
	select @varCSV = cast(@txtCSV as varbinary(max))


SELECT @txtCSV2 =''+char(10)+
  STUFF(
    (select char(10)+
                cast(Data as nvarchar(250)) + '|' 
			  + cast(Resolucao  as nvarchar(250)) + '|' 
			  + cast(Soma_de_Juros_Efetivos  as nvarchar(250)) + '|'
			  + cast(Soma_de_Amortização  as nvarchar(250)) + '|'
			  + cast(Soma_de_LP_para_CP as nvarchar(250)) + '|'
from VW_Visão_AIS
	FOR XML PATH('')), 1, 1, '') ;
	select @varCSV2 = cast(@txtCSV2 as varbinary(max))


insert into DT_exporta_arquivos(cod_user, dat_update, arquivo_aic,cenario, arquivo_aic_fileName, arquivo_ais,arquivo_ais_fileName, data_geracao, mes)
values ('hvianna',getdate(), @varCSV,@sk_cenario,'AIC_Extração_SAP-'+@cenario+'.csv',@varCSV2,'AIS_Extração_SAP-'+@cenario+'.txt',@data, @sk_tempo)

											
END



							
