let
    Source = Csv.Document(File.Contents("C:\Users\hvian\OneDrive\Documentos\Manuais Sysphera\Curso Power BI\Custos\Custos.csv"),[Delimiter=",", Columns=7, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"Data", type text}, {"Produto", type text}, {"Serial number", type text}, {"Valor de Venda", type number}, {"Preço Custo", type number}, {"Duração Venda Telefone (mins)", Int64.Type}, {"Tempo Preparação (mins)", Int64.Type}}),
    #"Added Custom" = Table.AddColumn(#"Changed Type", "Codigo_Exp", each [Produto] & [Serial number])
in
    #"Added Custom"