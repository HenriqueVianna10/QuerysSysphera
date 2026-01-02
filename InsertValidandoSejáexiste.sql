INSERT INTO DT_reldim_centro_de_custo_x_cargo (
		cod_user
		,dat_update
		,centro_de_custo
		,cargo
		)

		SELECT DISTINCT 
			@usuario,
			GETDATE(),
			t.sk_centro_de_custo,
			t.sk_cargo
		FROM DT_app09_tmp_etl_headcount t
		WHERE t.sk_cargo <> -2
			AND t.sk_centro_de_custo <> -2
			AND NOT EXISTS (
				SELECT 1
				FROM DT_reldim_centro_de_custo_x_cargo r
				WHERE r.centro_de_custo = t.sk_centro_de_custo
					AND r.cargo = t.sk_cargo
			)
