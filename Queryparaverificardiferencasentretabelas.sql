SELECT 
    A.id,  -- Assumindo que há uma coluna id para relacionar as tabelas
    A.pais AS novo_pais,
    B.pais AS pais_antigo,
    A.descricao AS nova_descricao,
    B.descricao AS descricao_antiga,
    CASE 
        WHEN A.pais <> B.pais OR (A.pais IS NULL AND B.pais IS NOT NULL) OR (A.pais IS NOT NULL AND B.pais IS NULL) THEN 'SIM'
        ELSE 'NÃO'
    END AS pais_alterado,
    CASE 
        WHEN A.descricao <> B.descricao OR (A.descricao IS NULL AND B.descricao IS NOT NULL) OR (A.descricao IS NOT NULL AND B.descricao IS NULL) THEN 'SIM'
        ELSE 'NÃO'
    END AS descricao_alterada
FROM 
    Tabela_A A
JOIN 
    Tabela_B B ON A.id = B.id  -- Assumindo que há uma chave de relacionamento
WHERE 
    A.pais <> B.pais 
    OR A.descricao <> B.descricao
    OR (A.pais IS NULL AND B.pais IS NOT NULL)
    OR (A.pais IS NOT NULL AND B.pais IS NULL)
    OR (A.descricao IS NULL AND B.descricao IS NOT NULL)
    OR (A.descricao IS NOT NULL AND B.descricao IS NULL);


UPDATE Tabela_B B
JOIN Tabela_A A ON B.id = A.id
SET 
    B.pais = A.pais,
    B.descricao = A.descricao
WHERE 
    A.pais <> B.pais 
    OR A.descricao <> B.descricao
    OR (A.pais IS NULL AND B.pais IS NOT NULL)
    OR (A.pais IS NOT NULL AND B.pais IS NULL)
    OR (A.descricao IS NULL AND B.descricao IS NOT NULL)
    OR (A.descricao IS NOT NULL AND B.descricao IS NULL);