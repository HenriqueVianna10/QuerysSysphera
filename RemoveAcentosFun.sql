USE [ccee_sysphera_dev]
GO
/****** Object:  UserDefinedFunction [dbo].[RemoveAcentos]    Script Date: 11/14/2024 1:43:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[RemoveAcentos] (@texto NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @resultado NVARCHAR(MAX) = @texto;

    SET @resultado = REPLACE(@resultado, 'á', 'a');
    SET @resultado = REPLACE(@resultado, 'à', 'a');
    SET @resultado = REPLACE(@resultado, 'ã', 'a');
    SET @resultado = REPLACE(@resultado, 'â', 'a');
    SET @resultado = REPLACE(@resultado, 'ä', 'a');
    SET @resultado = REPLACE(@resultado, 'é', 'e');
    SET @resultado = REPLACE(@resultado, 'è', 'e');
    SET @resultado = REPLACE(@resultado, 'ê', 'e');
    SET @resultado = REPLACE(@resultado, 'ë', 'e');
    SET @resultado = REPLACE(@resultado, 'í', 'i');
    SET @resultado = REPLACE(@resultado, 'ì', 'i');
    SET @resultado = REPLACE(@resultado, 'î', 'i');
    SET @resultado = REPLACE(@resultado, 'ï', 'i');
    SET @resultado = REPLACE(@resultado, 'ó', 'o');
    SET @resultado = REPLACE(@resultado, 'ò', 'o');
    SET @resultado = REPLACE(@resultado, 'õ', 'o');
    SET @resultado = REPLACE(@resultado, 'ô', 'o');
    SET @resultado = REPLACE(@resultado, 'ö', 'o');
    SET @resultado = REPLACE(@resultado, 'ú', 'u');
    SET @resultado = REPLACE(@resultado, 'ù', 'u');
    SET @resultado = REPLACE(@resultado, 'û', 'u');
    SET @resultado = REPLACE(@resultado, 'ü', 'u');
    SET @resultado = REPLACE(@resultado, 'ç', 'c');
    SET @resultado = REPLACE(@resultado, 'Á', 'A');
    SET @resultado = REPLACE(@resultado, 'À', 'A');
    SET @resultado = REPLACE(@resultado, 'Ã', 'A');
    SET @resultado = REPLACE(@resultado, 'Â', 'A');
    SET @resultado = REPLACE(@resultado, 'Ä', 'A');
    SET @resultado = REPLACE(@resultado, 'É', 'E');
    SET @resultado = REPLACE(@resultado, 'È', 'E');
    SET @resultado = REPLACE(@resultado, 'Ê', 'E');
    SET @resultado = REPLACE(@resultado, 'Ë', 'E');
    SET @resultado = REPLACE(@resultado, 'Í', 'I');
    SET @resultado = REPLACE(@resultado, 'Ì', 'I');
    SET @resultado = REPLACE(@resultado, 'Î', 'I');
    SET @resultado = REPLACE(@resultado, 'Ï', 'I');
    SET @resultado = REPLACE(@resultado, 'Ó', 'O');
    SET @resultado = REPLACE(@resultado, 'Ò', 'O');
    SET @resultado = REPLACE(@resultado, 'Õ', 'O');
    SET @resultado = REPLACE(@resultado, 'Ô', 'O');
    SET @resultado = REPLACE(@resultado, 'Ö', 'O');
    SET @resultado = REPLACE(@resultado, 'Ú', 'U');
    SET @resultado = REPLACE(@resultado, 'Ù', 'U');
    SET @resultado = REPLACE(@resultado, 'Û', 'U');
    SET @resultado = REPLACE(@resultado, 'Ü', 'U');
    SET @resultado = REPLACE(@resultado, 'Ç', 'C');

    RETURN @resultado;
END;