USE [cruzeirodosul_sysphera_prd]
GO
/****** Object:  StoredProcedure [dbo].[sp_rep_dataload_rest]    Script Date: 4/27/2022 8:17:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_rep_dataload_rest] (@Carga INT)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @jsonResponse AS NVARCHAR(max)

	IF @Carga = 1
	BEGIN
		SELECT @jsonResponse = (
				SELECT 
					 CAST([Período RM] AS INT) AS IDPERIODO
					,CAST([Código Natureza Orçamentária - Pacotes] AS VARCHAR(max)) AS CODTBORCAMENTO
					,CAST([Natureza Orçamentária - Pacotes] AS VARCHAR(max)) AS NATDESCRICAO
					,CAST([Conta Contabil RM - Cód] AS VARCHAR(max)) AS CODCONTA
					,CAST([Conta Contábil Sysphera] AS VARCHAR(max)) AS CCDESCRICAO
				FROM vw_natureza_conta
				FOR json auto
				)

		INSERT INTO REP_DATALOAD_REST (
			datCreated
			,dscName
			,jsnParameter
			)
		VALUES (
			getdate()
			,'CargaNaturezaConta'
			,N'{
										"Url" :  "http://10.10.1.117:8051/RMSRestDataServer/rest/RMSPRJ3614976Server" ,
										"AuthenticateType" :  "Basic" ,
										"UserName" :  "sysphera" ,
										"Password" :  "sysphera!@22" ,
										"RequestMethod" :  "POST" ,
										"Body" :   "{\"ZMDNATXCC\":'+ replace(replace(replace(@jsonResponse, '\', ''), '"', '\"'), '/', '') + '} "
									}'
			)
	END

	IF @Carga = 2
	BEGIN
		DECLARE @loteinit AS INT
		DECLARE @lotefim AS INT
		DECLARE @qtreglote AS INT
		DECLARE @qtEmpresa AS INT
		DECLARE @intnumrow AS INT
		DECLARE @codEmpresa AS INT
		DECLARE @qtregempresa AS INT
		DECLARE @identificador AS INT


		truncate table DT_execucoes_

		insert into DT_execucoes_ (cod_user, dat_update)
		select 'admin', GETDATE()

		select @identificador = max(identificador) from DT_execucoes_

		
		
		SELECT @qtreglote = dscvalue
		FROM REP_LOADPARAMETER
		WHERE codLoadParameter = 1030

		
		DECLARE @tableGMD TABLE (
			id INT identity
			,Pacote VARCHAR(50)
			)
		DECLARE @tmpEmpresa TABLE (
			id INT identity
			,codEmpresa INT
			)

		INSERT INTO @tmpEmpresa (codEmpresa)
		SELECT DISTINCT CAST(codigo_empresa AS INT)
		FROM aux_mov_orc
		ORDER BY CAST(codigo_empresa AS INT)

		SELECT @qtEmpresa = count(*)
		FROM @tmpEmpresa

		SET @intnumrow = 1

		WHILE @intnumrow <= @qtEmpresa
		BEGIN
			set @loteinit = 1
			set @lotefim = @loteinit + @qtreglote -1
			SELECT @codEmpresa = codEmpresa
			FROM @tmpEmpresa
			WHERE id = @intnumrow

			SELECT @qtregempresa = count(*)
			FROM aux_mov_orc
			WHERE CAST(codigo_empresa AS INT) = @codEmpresa

			
			WHILE @loteinit <= @qtregempresa
			BEGIN
				
				select @jsonResponse =
				 (
				
					SELECT CAST(codigo_empresa AS INT) AS CODCOLIGADA
						,CAST(codigo_unidade AS INT) AS CODFILIAL
						,CAST(LEFT(tipo_de_conta,1) AS VARCHAR(max)) AS TIPO
						,CAST(período_rm AS INT) AS IDPERIODO
						,CAST(codigo_natureza_orcamentária_pacotes AS VARCHAR(max)) AS CODTBORCAMENTO
						,CAST(centro_de_custo_cod AS VARCHAR(max)) AS CODCCUSTO
						,REPLACE(Jan,'.','') AS VJANEIRO
						,REPLACE(Fev,'.','') AS VFEVEREIRO
						,REPLACE(Mar,'.','') AS VMARCO
						,REPLACE(Abr,'.','') AS VABRIL
						,REPLACE(Mai,'.','') AS VMAIO
						,REPLACE(Jun,'.','') AS VJUNHO
						,REPLACE(Jul,'.','') AS VJULHO
						,REPLACE(Ago,'.','') AS VAGOSTO
						,REPLACE([Set],'.','') AS VSETEMBRO
						,REPLACE([Out],'.','') AS VOUTUBRO
						,REPLACE(Nov,'.','') AS VNOVEMBRO
						,REPLACE(Dez,'.','') AS VDEZEMBRO
					FROM aux_mov_orc
					WHERE codigo_empresa = @codEmpresa AND row_num BETWEEN @loteinit
						AND @lotefim for json auto)

					

						insert into DT_lotes(cod_user, dat_update, codigo_empresa, id_inicial, id_final, id_rest, id_execucao, tentativas)

						select 'admin', GETDATE(), @codEmpresa, @loteinit, @lotefim, 'Orçamento' + cast(@codEmpresa as varchar(10)) + '|' + cast(@loteinit  as varchar(10)) + '|' + cast(@lotefim as varchar(10)),
						@identificador, 1

					

				INSERT INTO REP_DATALOAD_REST (
					datCreated
					,dscName
					,jsnParameter
					)
				VALUES (
					getdate()
					,'Orçamento' + cast(@codEmpresa as varchar(10)) + '|' + cast(@loteinit  as varchar(10)) + '|' + cast(@lotefim as varchar(10)) 
					,N'{
										"Url" :  "http://10.10.1.117:8051/RMSRestDataServer/rest/RMSPRJ4257024Server" ,
										"AuthenticateType" :  "Basic" ,
										"UserName" :  "sysphera" ,
										"Password" :  "sysphera!@22" ,
										"RequestMethod" :  "POST" ,
										"Body" : "{\"ZMDINTEGRAORC\":'+ replace(replace(replace(@jsonResponse, '\', ''), '"', '\"'), '/', '') + '} "
									}'
					)
											--"Body" : "'+'{"ZMDINTEGRAORC":'+ replace(replace(replace(@jsonResponse, '\', ''), '"', '\"'), '/', '')+'}'+'"
										
				SET @loteinit = @lotefim + 1
				SET @lotefim = @loteinit + @qtreglote - 1
			END

			SET @intnumrow = @intnumrow + 1
		END
	END

	--UPDATE REP_DATALOAD_REST
	--SET dscHttpResponseCode = 'OK | OK'
	--WHERE convert(VARCHAR(10), datCreated, 110) <> convert(VARCHAR(10), getdate(), 110) AND dscName = 'authentication


	--UPDATE DT_lotes 
	--set status = 'OK'
	--from DT_lotes exe inner join
	--REP_DATALOAD_REST rst on rst.dscName = exe.id_rest
	--where dscHttpResponseCode = 'OK | OK'


END