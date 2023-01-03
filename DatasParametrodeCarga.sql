        DECLARE @Token AS NVARCHAR(500)
		DECLARE @mesai AS VARCHAR(2)
		DECLARE @anoai AS VARCHAR(4)
		DECLARE @datainiai AS VARCHAR(12)
		DECLARE @datafimai AS VARCHAR(12)
		

		

		SELECT @mesai = SUBSTRING(CONVERT(VARCHAR(12), DATE, 102), 6, 2)
		FROM d_tempo_app1
		WHERE sk_tempo = (
				SELECT dscValue
				FROM REP_LOADPARAMETER
				WHERE codLoadParameter = 6
				)

		SELECT @anoai = LEFT(CONVERT(VARCHAR(12), DATE, 102), 4)
		FROM d_tempo_app1
		WHERE sk_tempo = (
				SELECT dscValue
				FROM REP_LOADPARAMETER
				WHERE codLoadParameter = 6
				)

		SELECT @datainiai = REPLACE(CONVERT(VARCHAR(12), DATE, 102), '.', '')
		FROM d_tempo_app1
		WHERE sk_tempo = (
				SELECT dscValue
				FROM REP_LOADPARAMETER
				WHERE codLoadParameter = 6
				)

		SELECT @datafimai = REPLACE(CONVERT(VARCHAR(12), endDate, 102), '.', '')
		FROM d_tempo_app1
		WHERE sk_tempo = (
				SELECT dscValue
				FROM REP_LOADPARAMETER
				WHERE codLoadParameter = 6)