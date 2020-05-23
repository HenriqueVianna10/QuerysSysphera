'id Conta
=SWITCH(Fields!Conta.Value = "OUTROS", 999998,
		Fields!Conta.Value = "EBITDA_REAL", 999999,
		True, CInt(Fields!Conta___ID.Value)
		)

'Nome
=SWITCH(Fields!IdConta.Value = 157, "Ebitda" & vbcrlf & "YTD-" & Left(Fields!Tempo.Value, 3) &  vbcrlf &" Orçado",
		Fields!IdConta.Value = 155, "Receita" & vbcrlf & "Líquida",
		Fields!IdConta.Value = 160, "Pessoal" & vbcrlf & "Próprio",
		Fields!IdConta.Value = 199, "Localização e" & vbcrlf & "Funcionamento",
		Fields!IdConta.Value = 209, "Tecnologia da" & vbcrlf & "Informação",
		Fields!IdConta.Value = 246, "Serviços de" & vbcrlf & "Terceiros",
		Fields!IdConta.Value = 999998, "Outros",
		Fields!IdConta.Value = 269, "Apoio Interno",
		Fields!IdConta.Value = 158, "Aloc" & vbcrlf & "Administração",
		Fields!IdConta.Value = 999999, "Ebitda" & vbcrlf & "YTD-" & Left(Fields!Tempo.Value, 3) & vbcrlf & "Realizado",
		True, Fields!Conta.Value
		)

'Valores
=CDbl(SWITCH(Fields!IdConta.Value =    157, Fields!YTD_Orçado.Value,
			 Fields!IdConta.Value = 999999, Fields!YTD_Realizado.Value,
			 True, Fields!Diferença.Value
			 ) )

'Filtra Linha

=IIF(InStr("|215|195|230|256|", "|" & CStr(Fields!IdConta.Value) & "|") > 0,
	 "Filtra",
	 "Mantém"
	 )

'Top Value

=IIF(Fields!IdConta.Value = 999999,
	 Fields!Valores.Value,
	 RunningValue(Fields!Valores.Value, Sum, Nothing)
	 )

'Bottom Value

=IIF(Fields!IdConta.Value = 999999,
	 0,
	 RunningValue(Fields!Valores.Value, Sum, Nothing) - Fields!Valores.Value
	 )


'Labels

=SWITCH(Fields!IdConta.Value = 999999, Sum(Fields!Valores.Value),
		Sum(Fields!Valores.Value) > 0, RunningValue(Fields!Valores.Value, Sum, Nothing),
		True, RunningValue(Fields!Valores.Value, Sum, Nothing) - Sum(Fields!Valores.Value)
		)


'Cor das Colunas

=SWITCH(Fields!IdConta.Value = 999999, "#548235",
		Fields!IdConta.Value =    157, "#c00000",
		Sum(Fields!Valores.Value) > 0, "#2f5597",
		True, "#ff0000"
		)

'Cor dos Labels
=SWITCH(Fields!IdConta.Value = 999999, "#548235",
		Fields!IdConta.Value =    157, "#c00000",
		Sum(Fields!Valores.Value) > 0, "#2f5597",
		True, "#ff0000"
		)


