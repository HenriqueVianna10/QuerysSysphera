SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
 * Remove os caracteres inválidos para o T6
 * Usar nas cargas de dimensão para o nome do membro e dos atributos
 *
 * select dbo.t6_caracteres_validos('Teste#Ááanµ¶TT·¸º»oTeste')
 * 
 */
ALTER FUNCTION [dbo].[t6_caracteres_validos] (@Texto NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @Permitidos NVARCHAR(255) = '-0123456789abcdefghijklmnopqrstuwvxyzABCDEFGHIJKLMNOPQRSTUWVXYZ ./%()$+,~&:_ÁÍÓÚÉÄÏÖÜËÀÌÒÙÈÃÕÂÎÔÛÊáíóúéäïöüëàìòùèãõâîôûêÇçºª'
    DECLARE @Posicao INT = PATINDEX('%[^' + @Permitidos + ']%', @Texto)

    WHILE @Posicao > 0
    BEGIN
        -- Remove o primeiro caractere inválido encontrado
        SET @Texto = STUFF(@Texto, @Posicao, 1, '')

        -- Verifica se ainda existem caracteres inválidos
        SET @Posicao = PATINDEX('%[^' + @Permitidos + ']%', @Texto)
    END

    RETURN @Texto
END
 