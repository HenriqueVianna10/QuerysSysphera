	SELECT @token = accessToken
		FROM OPENJSON((
					SELECT jsnResponse
					FROM REP_DATALOAD_REST
					WHERE codDataLoadRest IN (
							SELECT max(codDataLoadRest)
							FROM REP_DATALOAD_REST
							WHERE dscName = 'Autenticação SAU'
								AND dscHttpResponseCode = 'OK'
							)
					)) WITH (accessToken NVARCHAR(max) '$.accessToken')