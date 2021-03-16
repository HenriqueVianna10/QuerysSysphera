select Empresa, Conta, count(*) from 
[dbo].[DT_DE_PARA_BALANÇO]
group by Empresa, Conta
having count(*) > 1