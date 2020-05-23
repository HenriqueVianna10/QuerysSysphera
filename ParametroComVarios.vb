=Switch(Parameters!paramRegionalFilial.Count = Count(Fields!Value.Value, "dsRegionalFilial"), "Todos", 
	    Parameters!paramRegionalFilial.Count = 1, Trim(Parameters!paramRegionalFilial.Label(0)),
		Parameters!paramRegionalFilial.Count > 1 And Parameters!paramRegionalFilial.Count < 4, Join(Parameters!paramRegionalFilial.Label, ", "),
		Parameters!paramRegionalFilial.Count >= 4, Trim(Parameters!paramRegionalFilial.Label(0)) & ", " & Trim(Parameters!paramRegionalFilial.Label(1)) & ", " & Trim(Parameters!paramRegionalFilial.Label(2)) & " e Outros.",		
		true, "")