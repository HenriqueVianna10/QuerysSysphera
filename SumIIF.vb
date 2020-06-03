Sum(IIF(Fields!Level_8.Value = "REPASSE À PARCEIROS - REPASSE À PARCEIROS", Cdec(Fields!ProjMesAtual.Value), Cdec(0) ))

=Sum(IIF(Fields!Conta___ID.Value = 155, Fields!Tempo_2_Cenário_1_Produto_1.Value, Cdec(0)), "dsPlanejadoGerencial")