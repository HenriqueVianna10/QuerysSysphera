
SELECT DISTINCT a.empresa, a.entidade
FROM DT_app02_admissoes a
LEFT JOIN DT_reldim_empresa_x_entidade b 
    ON a.empresa = b.sk_empresa 
    AND a.entidade = b.sk_entidade
WHERE a.cenario = 26
AND b.sk_empresa IS NULL