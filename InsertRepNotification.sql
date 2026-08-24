--Erro Não Existe Headcount Na Origem
INSERT INTO REP_NOTIFICATION 
    (codNotificationType, flgState, codUser, dscObjectID, dscObjectName, dscTitle, dscMessage, dscDetails, datStart, datEnd)
VALUES 
    (2, 4, 167, NULL, 
    'Erro Ao Executar Transferência', 
    'Erro ao Transferir Colaborador!', 
    'Transferência Não Efetivada', 
    'Não Existe Headcount Na Origem.', GETUTCDATE(), GETUTCDATE());

