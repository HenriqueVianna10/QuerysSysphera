--Insert por Página Empresa 0050 Getnet CC 0 até 111000000
						DECLARE @counter int
						DECLARE @TOTAL int 

						select @TOTAL = LEFT(replace(jsnResponse, '{"total_paginas":"',''),2)
								FROM REP_DATALOAD_REST
								WHERE codDataLoadRest = (
										SELECT max(codDataLoadRest)
										FROM REP_DATALOAD_REST
										WHERE dscName = 'PartidasIndividuais1110000000050' AND dscHttpResponseCode = 'OK' AND convert(VARCHAR(10), datCreated, 110) = convert(VARCHAR(10), getdate(), 110))


						set @counter = 1

						WHILE @counter <= @TOTAL

						BEGIN
			
			
						INSERT INTO REP_DATALOAD_REST (
							datCreated
							,dscName
							,jsnParameter
							)
						VALUES ( getdate()
							,'PartidasIndividuais'
							,N'{
														"Url" :  "https://api-backoffice.getnet.com.br/gf/v1/rl/PartidasIndividuais",
														"AuthenticateType" :  "None" ,
														"Header": "Authorization: Bearer ' + @Token + '",
														"UserName" :  "None" ,
														"Password" :  "None" ,
														"RequestMethod" :  "POST" ,
														"Body" : "{
										 
															\"empresa\": \"0050\",
															\"ano\": \"' + @anopi + '\",
															\"mes\": \"' + @mespi + '\",
															\"versao\": \"000\",
															\"centro_custo_ini\": \"0\",
															\"centro_custo_fim\": \"111000000\",
															\"categoria_valor\": \"03\",
															\"pagina\": \"'+ CAST(@counter as varchar(max)) +'\"

														  }"
													}'

				)

				set @counter = @counter + 1
				END