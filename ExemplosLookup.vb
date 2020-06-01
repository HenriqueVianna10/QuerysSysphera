=Code.Divisao(Lookup("DRE - REPASSE À PARCEIROS" & Parameters!paramMesAnoPassado.Label, Fields!Conta.Value & Fields!Tempo___UniqueID.Value, Fields!Produto_1.Value, "dsRealizadoReceitaLíquida"),
Lookup("DRE - RECEITA BRUTA" & Parameters!paramMesAnoPassado.Label, Fields!Conta.Value & Fields!Tempo___UniqueID.Value, Fields!Produto_1.Value, "dsRealizadoReceitaLíquida"))

=Code.Divisao(Sum(IIF(Fields!Level_8.Value = "REPASSE À PARCEIROS - REPASSE À PARCEIROS", Cdec(Fields!ProjMesAtual.Value), Cdec(0) ))
 ,Sum(IIF(Fields!Level_7.Value = "DRE - RECEITA BRUTA", Cdec(Fields!ProjMesAtual.Value), Cdec(0) )))
