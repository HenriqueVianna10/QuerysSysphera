=SWITCH(Fields!IdConta.Value = 33, Sum(Fields!Valores.Value),
		Fields!IdConta.Value = 999999, RunningValue(Fields!Valores.Value,Sum,Nothing) - Sum(Fields!Valores.Value) + 20000,
		Sum(Fields!Valores.Value) > 0, RunningValue(Fields!Valores.Value, Sum, Nothing),
		True, RunningValue(Fields!Valores.Value, Sum, Nothing) - Sum(Fields!Valores.Value)
		)
