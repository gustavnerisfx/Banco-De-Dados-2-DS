use banco_atividades;
go

CREATE FUNCTION dbo.MaiorNumero
(
    @Numero1 DECIMAL(10,2),
    @Numero2 DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    IF @Numero1 > @Numero2
        RETURN @Numero1;

    RETURN @Numero2;
END;
GO

SELECT dbo.MaiorNumero(50, 10);