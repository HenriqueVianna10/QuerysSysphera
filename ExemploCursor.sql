
ALTER PROCEDURE [dbo].[sp_gera_arquivos]  
AS  
BEGIN  
    DECLARE @txtCSV AS VARCHAR(MAX);  
    DECLARE @txtCSV2 AS VARCHAR(MAX);  
    DECLARE @varCSV AS VARBINARY(MAX);  
    DECLARE @varCSV2 AS VARBINARY(MAX);  
    DECLARE @sk_cenario AS INT;  
    DECLARE @cenario AS VARCHAR(MAX);  
    DECLARE @data AS VARCHAR(MAX);  
    DECLARE @sk_tempo AS INT;  
  
    -- TRUNCATE TABLE DT_exporta_arquivos  
  
    SELECT @data = FORMAT(DATEADD(HOUR, -3, GETDATE()), 'dd/MM/yyyy HH:mm');  
  
    SELECT   
        @sk_cenario = cenario,  
        @sk_tempo = mes  
    FROM   
        DT_configura_extracao_arquivos;  
  
    DELETE DT_exporta_arquivos  
    FROM DT_exporta_arquivos  
    WHERE cenario = @sk_cenario  
      AND mes = @sk_tempo;  
  
    SELECT @cenario = cenario  
    FROM d_cenario_app5  
    WHERE sk_cenario = @sk_cenario;  
  
    SET NOCOUNT ON;  
  
    DECLARE @sk_entidade INT;  
 declare @cod_empresa varchar(100);  
  
    -- Cursor para entidades  
    DECLARE entidade_cursor CURSOR FOR  
    SELECT sk_entidade,  
   cod_empresa  
    FROM d_entidade_app5  
    WHERE sk_entidade_l1 = 2  
      AND sk_entidade NOT IN (SELECT ISNULL(sk_parent, 0) FROM d_entidade_app5)  
    ORDER BY sk_entidade;  
  
    OPEN entidade_cursor;  
  
    FETCH NEXT FROM entidade_cursor INTO @sk_entidade, @cod_empresa;  
  
    WHILE @@FETCH_STATUS = 0  
    BEGIN  
        SELECT @txtCSV = 'Data Documento;Tipo Documento;Empresa;Data Lançamento;Moeda;Referência;Texto Documento;BELNR (No documento);Chave Lançamento;Tipo de Movimento;Valor Montante em Moeda do Documento;Código da Moeda;Código do IVA;Montante Imposto Moeda do Documento;Centro de Custo;No. Atribuição;Texto do Item;Elemento PEP;Chave de Referência do Parceiro de Negócios;Chave de Referência do Parceiro de Negócios;Centro de Lucro;Domicilio Fiscal;No Documento de Compras;N Item do Documento de Compra;No do Material;Unidade de Medida Básica;Conta Contábil;No Pessoal;Tipo de Movimento2;Local do Negócio (Filial);Quantidade;Data Efetiva;Ledger2;Sociedade Parceira'  
            + CHAR(10)  
            + STUFF(  
                (SELECT CHAR(10) +  
                        CAST(Data_Documento AS NVARCHAR(250)) + ';' +  
                        CAST(Tipo_Documento AS NVARCHAR(250)) + ';' +  
                        CAST(Empresa AS NVARCHAR(250)) + ';' +  
                        CAST(Data_Lancamento AS NVARCHAR(250)) + ';' +  
                        CAST(Moeda AS NVARCHAR(250)) + ';' +  
                        CAST(Referencia AS NVARCHAR(250)) + ';' +  
                        CAST(texto_documento AS NVARCHAR(250)) + ';' +  
                        CAST(BELNR AS NVARCHAR(250)) + ';' +  
                        CAST(Chave_Lancamento AS NVARCHAR(250)) + ';' +  
                        CAST(Tipo_de_Movimento AS NVARCHAR(250)) + ';' +  
                        CAST(Valor AS NVARCHAR(250)) + ';' +  
                        CAST(Codigo_da_Moeda AS NVARCHAR(250)) + ';' +  
                        CAST(Codigo_do_IVA AS NVARCHAR(250)) + ';' +  
                        CAST(Montante_Imposto_moeda_do_doc AS NVARCHAR(250)) + ';' +  
                        CAST(Centro_de_Custo AS NVARCHAR(250)) + ';' +  
                        CAST(No_Atribuicao AS NVARCHAR(250)) + ';' +  
                        CAST(Texto_do_Item AS NVARCHAR(250)) + ';' +  
                        CAST(elemento_pep AS NVARCHAR(250)) + ';' +  
                        CAST(Chave_de_referencia_do_parceiro_de_negocios AS NVARCHAR(250)) + ';' +  
						CAST(Chave_de_referencia_do_parceiro_de_negocios AS NVARCHAR(250)) + ';' +  
                        CAST(Centro_de_Lucro AS NVARCHAR(250)) + ';' +  
                        CAST(Domicilio_Fiscal AS NVARCHAR(250)) + ';' +  
                        CAST(No_Documento_de_Compras AS NVARCHAR(250)) + ';' +  
                        CAST(No_Item_do_documento_de_compras AS NVARCHAR(250)) + ';' +  
                        CAST(No_do_Material AS NVARCHAR(250)) + ';' +  
                        CAST(Unidade_de_Medida_Basica AS NVARCHAR(250)) + ';' +  
                        CAST(Conta_Contabil AS NVARCHAR(250)) + ';' +  
                        CAST(No_Pessoal AS NVARCHAR(250)) + ';' +  
                        CAST(Tipo_de_Movimento2 AS NVARCHAR(250)) + ';' +  
                        CAST(Local_de_Negocio AS NVARCHAR(250)) + ';' +  
                        CAST(Quantidade AS NVARCHAR(250)) + ';' +  
                        CAST(Data_Efetiva AS NVARCHAR(250)) + ';' +  
                        CAST(Ledger2 AS NVARCHAR(250)) + ';' +  
                        CAST(Sociedade_Parceira AS NVARCHAR(250)) + ';'  
                 FROM VW_Visão_AIC  
                 WHERE sk_entidade = @sk_entidade  
                 FOR XML PATH('')), 1, 1, '');  
  
        SELECT @varCSV = CAST(@txtCSV AS VARBINARY(MAX));  
  
        SELECT @txtCSV2 = ''  
            + CHAR(10)  
            + STUFF(  
                (SELECT CHAR(10) +  
                        CAST(Data AS NVARCHAR(250)) + '|' +  
                        CAST(Resolucao AS NVARCHAR(250)) + '|' +  
                        CAST(Soma_de_Amortização AS NVARCHAR(250)) + '|' +  
                        CAST(Soma_de_Juros_Efetivos AS NVARCHAR(250)) + '|' +  
                        CAST(Soma_de_LP_para_CP AS NVARCHAR(250)) + '|'  
                 FROM VW_Visão_AIS  
                 WHERE sk_entidade = @sk_entidade  
                 FOR XML PATH('')), 1, 1, '');  
  
        SELECT @varCSV2 = CAST(@txtCSV2 AS VARBINARY(MAX));  
  
        INSERT INTO DT_exporta_arquivos(  
            cod_user,   
            dat_update,   
            arquivo_aic,  
            cenario,   
            arquivo_aic_fileName,   
            arquivo_ais,  
            arquivo_ais_fileName,   
            data_geracao,   
            mes  
        )  
        VALUES (  
            'hvianna',  
            GETDATE(),  
            @varCSV,  
            @sk_cenario,  
            'AIC_Extração_SAP_' + @cod_empresa + '_' + @cenario + '.csv',  
            @varCSV2,  
            'AIS_Extração_SAP_' + @cod_empresa + '_' + @cenario + '.txt',  
            @data,  
            @sk_tempo  
        );  
  
        FETCH NEXT FROM entidade_cursor INTO @sk_entidade, @cod_empresa;  
    END  
  
    CLOSE entidade_cursor;  
    DEALLOCATE entidade_cursor;  
END  