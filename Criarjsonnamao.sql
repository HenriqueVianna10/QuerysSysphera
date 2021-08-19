DECLARE @table AS TABLE (
    ID INT PRIMARY KEY identity
    ,Texto NVARCHAR(MAX)
    )
DECLARE @intQtRows AS INT
DECLARE @intRowum AS INT
DECLARE @json AS NVARCHAR(MAX)
DECLARE @text AS NVARCHAR(max)

INSERT INTO @table (Texto)
SELECT CASE 
        WHEN ROW_NUMBER() OVER (
                ORDER BY cCod
                ) = 1
            THEN '['
        ELSE ''
        END + '{"cCod":"' + cCod + '","cDescri":"' + cDescri + '","cTp":"' + CAST(cTp as varchar(2)) + '","cCta":"' + Cast(cCta as nvarchar(max)) + '"}' + CASE 
        WHEN ROW_NUMBER() OVER (
                ORDER BY cCod
                ) = sum(1) OVER ()
            THEN ']'
        ELSE ','
        END
FROM vw_json_catalogo

SET @json = ''

SELECT @intQtRows = count(*)
FROM @table

SET @intRowum = 1

WHILE (@intRowum <= @intQtRows)
BEGIN
    SELECT @text = texto
    FROM @table
    WHERE ID = @intRowum

    SET @json = @json + @text
    SET @intRowum = @intRowum + 1
END

@json

insert into REP_DATALOAD_REST(datCreated,dscName,jsnParameter)values(getdate(),'jsoncatalogo',
								N'{
										"Url" :  "http://187.94.60.35:10385/rest_tst/AKF?cToken=' + 'd46e3598126d0a8afb8a36f1e6d9d18d' + '"' + ' ,
										"AuthenticateType" :  "None" ,
										"UserName" :  "None" ,
										"Password" :  "None" ,
										"RequestMethod" :  "POST" ,
										"Body" :  "'+ replace(@json, '"','\"') + '"
									}')




--SELECT *
--FROM openjson(@json) WITH (
--        cCod VARCHAR(max) '$.cCod'
--        ,cDescri VARCHAR(max) '$.cDescri'
--		,cTp VARCHAR(max) '$.cTp'
--		,cCta VARCHAR(max) '$.cCta'
--        )



