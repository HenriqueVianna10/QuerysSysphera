

ALTER VIEW [dbo].[VW_VERIFICA_BEST_GUESS]
AS
SELECT w.Valor_Orçado
	,w.VALOR_BG
	,W.PRAZO_BG
	,W.Sk_Entidade
	,W.L174_entidade
	,W.SK_PARCEIRO
	,W.parceiro
	,CASE 
		WHEN w.Valor_BG < W.Valor_Orçado
			THEN 'Produção BG menor que a Orçada, Revisar!'
		WHEN w.VALOR_BG = '0'
			THEN 'Produção BG Não Informada!'
		WHEN w.VALOR_BG > '0'
			AND W.PRAZO_BG = '0'
			THEN 'Prazo Não Informado, Revisar!'
		WHEN w.VALOR_BG = '0'
			AND W.PRAZO_BG = '0'
			THEN 'Produção e Prazo Nulos, Justificar!'
		ELSE 'OK'
		END AS Verificação
	,CASE 
		WHEN w.Valor_BG < W.Valor_Orçado
			THEN 1
		WHEN w.VALOR_BG = '0'
			THEN 1
		WHEN w.VALOR_BG > '0'
			AND W.PRAZO_BG = '0'
			THEN 1
		WHEN w.VALOR_BG = '0'
			AND W.PRAZO_BG = '0'
			THEN 1
		ELSE 0
		END AS [Check]
FROM (
	SELECT pORC.valor AS Valor_Orçado
		,pBG.valor AS VALOR_BG
		,PRZBG.valor AS PRAZO_BG
		,pORC.sk_parceiro AS SK_PARCEIRO
		,pOrc.parceiro
		,pORC.Sk_Entidade
		,pORC.L174_entidade
	FROM (
		--Produção Orçada
		SELECT
			COALESCE(fto.sk_tempo, (SELECT TOP 1 dscValue FROM REP_LOADPARAMETER WHERE codLoadParameter = 22)) AS sk_tempo,
			vw.sk_entidade,
			vw.L174_entidade,
			ISNULL(fto.value, '0') AS valor,
			d.sk_parceiro,
			d.parceiro,
			-1 AS sk_consolidacao
		FROM d_parceiro_app7 d
		INNER JOIN VW_DT_app07_rel_dim_entidade_x_parceiro VW ON d.sk_parceiro = vw.Sk_Parceiro
		LEFT JOIN f_app7 fto ON d.sk_parceiro = fto.sk_parceiro
			AND fto.sk_conta = 12
			AND fto.sk_cenario IN (
				SELECT dscValue
				FROM REP_LOADPARAMETER
				WHERE codLoadParameter = 23
			)
			AND fto.sk_tempo IN (
				SELECT dscValue
				FROM REP_LOADPARAMETER
				WHERE codLoadParameter = 22
			)
		) AS pORC
	FULL OUTER JOIN (
		--Produção BG
		SELECT
			COALESCE(fto.sk_tempo, (SELECT TOP 1 dscValue FROM REP_LOADPARAMETER WHERE codLoadParameter = 22)) AS sk_tempo,
			vw.sk_entidade,
			vw.L174_entidade,
			ISNULL(fto.value, '0') AS valor,
			d.sk_parceiro,
			d.parceiro,
			-1 AS sk_consolidacao
		FROM d_parceiro_app7 d
		INNER JOIN VW_DT_app07_rel_dim_entidade_x_parceiro VW ON d.sk_parceiro = vw.Sk_Parceiro
		LEFT JOIN f_app7 fto ON d.sk_parceiro = fto.sk_parceiro
			AND fto.sk_conta = 12
			AND fto.sk_cenario IN (
				SELECT dscValue
				FROM REP_LOADPARAMETER
				WHERE codLoadParameter = 21
			)
			AND fto.sk_tempo IN (
				SELECT dscValue
				FROM REP_LOADPARAMETER
				WHERE codLoadParameter = 22
		)) AS pBG ON (
			pORC.sk_entidade = pbg.sk_entidade
			AND pORC.sk_consolidacao = pBG.sk_consolidacao
			AND pORC.sk_parceiro = pBG.sk_parceiro
			AND pORC.sk_tempo = pBG.sk_tempo
			)
	FULL OUTER JOIN (
		--Prazo
		SELECT
			COALESCE(fto.sk_tempo, (SELECT TOP 1 dscValue FROM REP_LOADPARAMETER WHERE codLoadParameter = 22)) AS sk_tempo,
			vw.sk_entidade,
			vw.L174_entidade,
			ISNULL(fto.value, '0') AS valor,
			d.sk_parceiro,
			d.parceiro,
			-1 AS sk_consolidacao
		FROM d_parceiro_app7 d
		INNER JOIN VW_DT_app07_rel_dim_entidade_x_parceiro VW ON d.sk_parceiro = vw.Sk_Parceiro
		LEFT JOIN f_app7 fto ON d.sk_parceiro = fto.sk_parceiro
			AND fto.sk_conta = 11
			AND fto.sk_cenario IN (
				SELECT dscValue
				FROM REP_LOADPARAMETER
				WHERE codLoadParameter = 21
			)
			AND fto.sk_tempo IN (
				SELECT dscValue
				FROM REP_LOADPARAMETER
				WHERE codLoadParameter = 22
		)) PRZBG ON (
			PRZBG.sk_entidade = pbg.sk_entidade
			AND PRZBG.sk_consolidacao = pBG.sk_consolidacao
			AND PRZBG.sk_parceiro = pBG.sk_parceiro
			AND PRZBG.sk_tempo = pBG.sk_tempo
			AND PRZBG.sk_parceiro = pORC.sk_parceiro
			)
	) AS w
GO


