declare @paramFilial varchar(100) = 'São Paulo',
        @paramCanal varchar(100) = 'Retail'
SELECT DISTINCT
[tipo_de_gerencia] AS Value, [tipo_de_gerencia] AS Label
FROM [d_entidade_app1]
where [filial] IN (@paramFilial) 
and  [diretoria] IN (@paramCanal)
AND [sk_entidade] NOT IN (SELECT DISTINCT [sk_parent] FROM [dpc_entidade_app1])
AND flgBelongs = 1


declare @paramCanal varchar(100) = 'Retail'
SELECT DISTINCT
[filial] AS Value, [filial] AS Label     
FROM [d_entidade_app1]
where [diretoria] = @paramCanal
and flgBelongs = 1
AND [sk_entidade] NOT IN (SELECT DISTINCT [sk_parent] FROM [dpc_entidade_app1])

SELECT DISTINCT
[diretoria] AS Value, [diretoria] AS Label 
FROM [d_entidade_app1]
WHERE flgBelongs = 1
AND [sk_entidade] NOT IN (SELECT DISTINCT [sk_parent] FROM [dpc_entidade_app1])
AND [diretoria] NOT IN ('Gerencial', 'Transitória')


