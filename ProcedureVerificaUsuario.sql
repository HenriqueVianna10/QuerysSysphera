/*
declare @valor2 int

 

select * from SP_Inativa_Usuario 'henrique'

 

*/
ALTER PROCEDURE SP_Inativa_Usuario
	--Variavel de Entrada
	(@codUser VARCHAR(50))
AS
BEGIN
	DECLARE @usuario VARCHAR(50)
		,@info VARCHAR(50)
		,@valor INT

	SET NOCOUNT ON
	SET @usuario = @codUser
	SET @valor = (
			SELECT count(*)
			FROM REP_USER
			WHERE codUser = @usuario
			)

	IF @valor <> 1
		SET @info = 'Usuário não possui acesso ao sistema Sysphera'
	ELSE
	BEGIN
		UPDATE REP_USER
		SET flgActive = 'N'
		WHERE @usuario = codUser

		UPDATE REP_USER
		SET dscLastName = dscLastName + '(Inativo)'
		WHERE @usuario = codUser

		SET @info = 'Usuário desativado com sucesso no sistema Sysphera'
	END

	SELECT @info AS Result
END

exec SP_Inativa_Usuario @codUser = 'henrique'

