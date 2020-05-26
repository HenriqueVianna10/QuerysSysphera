=Trim(IIF(Parameters!paramRegionalFilial.Count = Count(Fields!Value.Value, "dsRegionalFilial"), "Todos", 
	 IIF(Parameters!paramRegionalFilial.Count <= 3, Join(Parameters!paramRegionalFilial.Label, " + "),
		IIF(Parameters!paramRegionalFilial.Count >3, "Diversos",1))))

