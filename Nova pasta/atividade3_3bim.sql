use banco_atividades;

go


CREATE FUNCTION AcrescimoPorcentagem (@Numero DECIMAL(10, 2))
RETURNS DECIMAL(10, 2)
AS 
BEGIN
	
RETURN @Numero * 1.10;
END;

go

SELECT dbo.AcrescimoPorcentagem(1800);