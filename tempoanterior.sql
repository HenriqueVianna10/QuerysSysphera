select '[Tempo].[Tempo].[Todos].[' + tempo_l0 + '].[' + tempo_l1 + '].[' + tempo_l2 + '].[' + tempo_l3 + ']' as [Value] from d_tempo_app1 
where left(convert(varchar(10),date,121),7) =  left(convert(varchar(10),dateadd(mm,-1, getdate()),121),7)
