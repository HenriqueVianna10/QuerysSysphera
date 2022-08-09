INSERT INTO REP_DATALOAD_REST (
			datCreated
			,dscName
			,jsnParameter
			)
		SELECT getdate()
			,'AquisicoesImobilizado'
			,N'{
										"Url" :  "https://api-homologacao.getnet.com.br/gf/v1/rl/AquisicoesImobilizado",
										"AuthenticateType" :  "None" ,
										"Header": "Authorization: Bearer ' + @Token + '",
										"UserName" :  "None" ,
										"Password" :  "None" ,
										"RequestMethod" :  "POST" ,
										"Body" : "{
										  \"ano\": \"' + @anoai + '\",
										  \"mes\": \"' + @mesai + '\",
										  \"empresa\": \"' + codigo + '\",
										  \"data_lancamento_ini\": \"' + @datainiai + '01'+ '\",
										  \"data_lancamento_fim\": \"' + @datafimai + '05'+ '\",
										  \"classe_imobilizado_ini\": \"' +'132140'+ '\",
										  \"classe_imobilizado_fim\": \"' +'132140'+ '\",
										  }"
									}'
		FROM DT_empresas