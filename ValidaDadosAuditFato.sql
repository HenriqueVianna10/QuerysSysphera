INSERT INTO f_app1 (
    sk_conta, sk_tempo, sk_cenario, sk_entidade, value,
    cod_user, dat_update, type_update, hashData, 
    sk_servico, sk_empresa, sk_cliente_projeto, sk_entidade_para, sk_consolidacao
)
SELECT 
    a.sk_conta, a.sk_tempo, a.sk_cenario, a.sk_entidade, SUM(a.value),
    a.cod_user, GETDATE(), a.type_update, a.hashData,
    a.sk_servico, a.sk_empresa, a.sk_cliente_projeto, a.sk_entidade_para, a.sk_consolidacao
FROM f_app1_audit a
LEFT JOIN f_app1 f ON 
    f.sk_cenario = a.sk_cenario
    AND f.sk_conta = a.sk_conta
    AND f.sk_tempo = a.sk_tempo
    AND f.sk_entidade = a.sk_entidade
    AND f.sk_cliente_projeto = a.sk_cliente_projeto
    AND f.sk_entidade_para = a.sk_entidade_para
    AND f.sk_empresa = a.sk_empresa
    AND f.sk_consolidacao = a.sk_consolidacao
    
    -- Adicione outras chaves de junção conforme necessário
WHERE 
    a.sk_cenario = 76 
    AND a.type_update = '1'
    AND a.sk_conta IN (156,157,158,159,160,193,66,67,68,69,70)
    AND f.sk_conta IS NULL  -- Garante que não existe na f_app1
GROUP BY 
    a.sk_conta, a.sk_tempo, a.sk_cenario, a.sk_entidade, a.sk_servico, 
    a.sk_empresa, a.sk_cliente_projeto, a.sk_entidade_para, a.sk_consolidacao, 
    a.cod_user, a.type_update, a.hashData;