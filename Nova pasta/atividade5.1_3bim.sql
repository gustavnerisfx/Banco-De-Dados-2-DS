use banco_atividades;
go

CREATE FUNCTION dbo.VerificarIdade (@DataNascimento DATE)
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @Idade INT;

    SET @Idade = DATEDIFF(YEAR, @DataNascimento, GETDATE());

    IF DATEADD(YEAR, @Idade, @DataNascimento) > GETDATE()
        SET @Idade = @Idade - 1;

    IF @Idade >= 18
        RETURN 'Maior de idade';

    RETURN 'Menor de idade';
END;
GO

SELECT dbo.VerificarIdade('2009-05-10');