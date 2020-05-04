declare @paramFilial varchar(100) = 'São Paulo'
SELECT DISTINCT
[tipo_de_gerencia] AS Value, [tipo_de_gerencia] AS Label 
FROM [d_entidade_app1]
where [filial] = @paramFilial