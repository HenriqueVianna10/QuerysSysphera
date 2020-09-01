CREATE PROCEDURE [dbo].[SP_DT_investimento_Validainvestimento]  
(
  @ID_Investimento int
)
AS  
BEGIN  
 SET NOCOUNT ON;  
 DECLARE   
  @l_i_investimento INT,  
  @l_i_cenario INT,  
  @l_i_sk_investimento INT, 
  @l_n_valor numeric(28, 14),  
  @l_i_qtd INT,  
  @l_i_sk_tempo INT; 
  
 
 -- Carrega variáveis  
 set @l_i_investimento = @ID_Investimento
SELECT @l_i_cenario = cast(dscValue as int) from REP_LOADPARAMETER where codLoadParameter = 11  
 SELECT @l_i_sk_investimento = dimensao_projeto FROM dbo.DT_investimento WITH(NOLOCK) WHERE identificador=@l_i_investimento
SELECT @l_i_sk_tempo = MIN(sk_tempo) FROM dbo.d_tempo_app10 WITH(NOLOCK) WHERE yearunique= YEAR(GETDATE())

     
 -- Testa se o valor postergado soma zero  
 SELECT @l_n_valor=SUM(value) FROM F_APP10 WHERE sk_cenario = @l_i_cenario and sk_projeto = @l_i_sk_investimento and sk_conta = 1 and sk_tempo>=@l_i_sk_tempo and sk_consolidacao = 6 ; --Postergado  
   
 IF @l_n_valor IS NOT NULL AND @l_n_valor <> 0  
 BEGIN  
    
  update DT_investimento set ERRO = 'SOMA DO VALOR POSTERGADO DIFERENTE DE ZERO' where cenario = @l_i_cenario and dimensao_projeto = @l_i_sk_investimento;  
    
 END ELSE BEGIN  
  -- Testa se o valor antecipado soma zero  
  SET @l_n_valor=0  
  SELECT @l_n_valor = SUM(value) FROM F_APP10 WHERE sk_cenario = @l_i_cenario and sk_projeto = @l_i_sk_investimento and sk_conta = 1 and sk_tempo>=@l_i_sk_tempo and sk_consolidacao = 11; --Antecipado  
  IF @l_n_valor IS NOT NULL AND @l_n_valor <> 0  
  BEGIN  
    
    update DT_investimento set ERRO = 'SOMA DO VALOR ANTECIPADO DIFERENTE DE ZERO' where cenario = @l_i_cenario and dimensao_projeto = @l_i_sk_investimento;  
    
  END ELSE BEGIN  
    
   SELECT  
    @l_n_valor = SUM(ISNULL(c.Projetado,0)) + SUM(ISNULL(f.Cancelados,0)) + SUM(ISNULL(b.Real,0)) + SUM(ISNULL(g.Concluidos,0))  - SUM(ISNULL(d.Ajustes,0)) - SUM(ISNULL(e.Reclassificacao,0)) - SUM(ISNULL(a.Capex_Conselho,0))
   FROM   
    (SELECT sk_projeto,SUM(value) AS Capex_Conselho FROM dbo.f_app10 WITH(NOLOCK)  
    WHERE sk_conta=1 AND sk_projeto=@l_i_sk_investimento AND sk_cenario=@l_i_cenario AND sk_consolidacao=9 AND sk_tempo>=@l_i_sk_tempo 
    GROUP BY sk_projeto) a LEFT JOIN  
    (SELECT sk_projeto,SUM(value) AS Real FROM dbo.f_app10 WITH(NOLOCK)  
    WHERE sk_conta=1 AND sk_projeto=@l_i_sk_investimento AND sk_cenario=@l_i_cenario AND sk_consolidacao=2 AND sk_tempo>=@l_i_sk_tempo
    GROUP BY sk_projeto) b ON(a.sk_projeto=b.sk_projeto) LEFT JOIN  
    (SELECT sk_projeto,SUM(value) AS Projetado FROM dbo.f_app10 WITH(NOLOCK)  
    WHERE sk_conta=1 AND sk_projeto=@l_i_sk_investimento AND sk_cenario=@l_i_cenario AND sk_consolidacao=4 AND sk_tempo>=@l_i_sk_tempo
    GROUP BY sk_projeto) c ON(a.sk_projeto=c.sk_projeto) LEFT JOIN  
    (SELECT sk_projeto,SUM(value) AS Ajustes FROM dbo.f_app10 WITH(NOLOCK)  
    WHERE sk_conta=1 AND sk_projeto=@l_i_sk_investimento AND sk_cenario=@l_i_cenario AND sk_consolidacao=5  AND sk_tempo>=@l_i_sk_tempo
    GROUP BY sk_projeto) d ON(a.sk_projeto=d.sk_projeto) LEFT JOIN
    (SELECT sk_projeto,SUM(value) AS Reclassificacao FROM dbo.f_app10 WITH(NOLOCK)  
    WHERE sk_conta=1 AND sk_projeto=@l_i_sk_investimento AND sk_cenario=@l_i_cenario AND sk_consolidacao=12 AND sk_tempo>=@l_i_sk_tempo
    GROUP BY sk_projeto) e ON(a.sk_projeto=e.sk_projeto) LEFT JOIN 
       (SELECT sk_projeto,SUM(value) AS Cancelados FROM dbo.f_app10 WITH(NOLOCK)  
    WHERE sk_conta=1 AND sk_projeto=@l_i_sk_investimento AND sk_cenario=@l_i_cenario AND sk_consolidacao=8  AND sk_tempo>=@l_i_sk_tempo
    GROUP BY sk_projeto) f ON(a.sk_projeto=f.sk_projeto) LEFT JOIN 
       (SELECT sk_projeto,SUM(value) AS Concluidos FROM dbo.f_app10 WITH(NOLOCK)  
    WHERE sk_conta=1 AND sk_projeto=@l_i_sk_investimento AND sk_cenario=@l_i_cenario AND sk_consolidacao=19  AND sk_tempo>=@l_i_sk_tempo
    GROUP BY sk_projeto) g ON(a.sk_projeto=g.sk_projeto)
    
      
    IF @l_n_valor IS NOT NULL AND @l_n_valor <> 0  
             update DT_investimento set ERRO = 'A DIFERENÇA ENTRE CAPEX CONSELHO E CAPEX FORECAST ESTÁ DIFERENTE DE ZERO' where cenario = @l_i_cenario and dimensao_projeto = @l_i_sk_investimento;  
       ELSE 
       BEGIN 
             -- Verifica se há algum mês onde o valor projetado(Forecast) é menor que zero(0).
             IF EXISTS(SELECT    sk_tempo,
                                        SUM(value) as valor
                                  FROM dbo.f_app10 WITH(NOLOCK)
                                  WHERE sk_conta=1 
                                  AND sk_projeto=@l_i_sk_investimento 
                                  AND sk_cenario=@l_i_cenario 
                                  AND sk_consolidacao=4 -- Projetado
                                  GROUP BY sk_tempo
                                  HAVING SUM(value)<0)
             BEGIN
                    update DT_investimento set ERRO = 'EXITE VALOR NEGATIVO EM ALGUM MÊS NA COLUNA FORECAST' where cenario = @l_i_cenario and dimensao_projeto = @l_i_sk_investimento;  
             END
             ELSE 
             BEGIN -- Verifica se o saldo da coluna antecipação é negativo
                    DECLARE @Saldo_Antecipacao DECIMAL(15,2), @Valor_Antecipacao DECIMAL(15,2)
                    SET @Saldo_Antecipacao=0
                    
                    DECLARE CUR_Antecipacao CURSOR FOR 
                    SELECT SUM(VALUE)AS Valor
                    FROM dbo.f_app10 WITH(NOLOCK)
                    WHERE sk_conta=1 
                    AND sk_projeto=@l_i_sk_investimento 
                    AND sk_cenario=@l_i_cenario 
                    AND sk_consolidacao=11 -- Antecipação
                    and sk_tempo>=@l_i_sk_tempo
                    GROUP BY sk_tempo
                    ORDER BY sk_tempo
                    
                    OPEN CUR_Antecipacao

                    FETCH NEXT FROM CUR_Antecipacao 
                    INTO @Valor_Antecipacao
                    
                    WHILE @@FETCH_STATUS = 0 AND @Saldo_Antecipacao>=0
                    BEGIN

                           SET @Saldo_Antecipacao=@Saldo_Antecipacao + @Valor_Antecipacao

                           FETCH NEXT FROM CUR_Antecipacao 
                           INTO @Valor_Antecipacao
                    END 
                    CLOSE CUR_Antecipacao;
                    DEALLOCATE CUR_Antecipacao;

                    IF @Saldo_Antecipacao<0
                    BEGIN
                           update DT_investimento set ERRO = 'HÁ UMA INCONSISTÊNCIA NA COLUNA ANTECIPAÇÃO' where cenario = @l_i_cenario and dimensao_projeto = @l_i_sk_investimento;  
                    END
                    ELSE
                    BEGIN -- Verifica se o saldo da coluna postergação é positivo
                           DECLARE @Saldo_Postergado DECIMAL(15,2), @Valor_Postergado DECIMAL(15,2)
                           SET @Saldo_Postergado=0
                           
                           DECLARE CUR_Postergacao CURSOR FOR 
                           SELECT SUM(VALUE)AS Valor
                           FROM dbo.f_app10 WITH(NOLOCK)
                           WHERE sk_conta=1 
                           AND sk_projeto=@l_i_sk_investimento 
                           AND sk_cenario=@l_i_cenario 
                           AND sk_consolidacao=6 -- Postergação
                           and sk_tempo>=@l_i_sk_tempo
                           GROUP BY sk_tempo
                           ORDER BY sk_tempo
                           
                           OPEN CUR_Postergacao

                           FETCH NEXT FROM CUR_Postergacao 
                           INTO @Valor_Postergado
                           
                           WHILE @@FETCH_STATUS = 0 AND @Saldo_Postergado<=0
                           BEGIN

                                  SET @Saldo_Postergado=@Saldo_Postergado + @Valor_Postergado

                                  FETCH NEXT FROM CUR_Postergacao 
                                  INTO @Valor_Postergado
                           END 
                           CLOSE CUR_Postergacao;
                           DEALLOCATE CUR_Postergacao;

                           IF @Saldo_Postergado>0
                           BEGIN
                                  PRINT @Saldo_Postergado
                                  update DT_investimento set ERRO = 'HÁ UMA INCONSISTÊNCIA NA COLUNA POSTERGAÇÂO' where cenario = @l_i_cenario and dimensao_projeto = @l_i_sk_investimento;  
                           END
                           ELSE
                           BEGIN
                                  -- Testa se a PI foi anexada e se há valor projeto a partir de Dez/2013
                                  IF EXISTS(
                                               SELECT p.pi_fileName
                                               FROM dbo.DT_investimento p WITH(NOLOCK) INNER JOIN
                                                      dbo.f_app10 f WITH(NOLOCK) ON(p.dimensao_projeto=f.sk_projeto AND p.cenario=f.sk_cenario)
                                               WHERE p.identificador= @l_i_investimento
                                               AND p.cenario= @l_i_cenario
                                               AND f.sk_consolidacao=4 -- Projetado
                                               AND f.sk_tempo>=60 -- Dezembro/2013
                                               AND f.value<>0
                                               AND p.pi_fileName IS NULL) 
                                  BEGIN
                                        update DT_investimento set ERRO = 'É NECESSÁRIO ANEXAR A PI' where identificador = @l_i_investimento;  
                                  END
                                  ELSE
                                  BEGIN
                                        update DT_investimento set ERRO = 'VÁLIDO' where cenario = @l_i_cenario and dimensao_projeto = @l_i_sk_investimento;  
                                  END
                           END
                    END
             END
      
    END;
  END;  
 END;  
END  

GO