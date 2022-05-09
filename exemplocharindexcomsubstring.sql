
					SELECT codDataLoadRest
						,replace(JsnResponse, '{"total":"@total","items":', '') AS JsnResponse,
						CHARINDEX('[',JsnResponse,1)
						,SUBSTRING(JsnResponse, CHARINDEX('[',JsnResponse,1),LEN(JsnResponse))
						,ROW_NUMBER() OVER (
							ORDER BY datExecuted DESC
							) AS Row#
					FROM REP_DATALOAD_REST
					WHERE codDataLoadRest = 5 AND dschttpresponsecode = 'OK'
