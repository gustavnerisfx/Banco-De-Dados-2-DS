--Criação de uma estrutra de locações e etc--

--primeiro adicione isso na tabela FILME

ALTER TABLE dbo.FILME
ADD QTD_LOCACOES INT NOT NULL DEFAULT 0;

--crie a tabela locação

CREATE TABLE dbo.LOCACAO (
    COD_LOCACAO     NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    COD_FILME       NUMERIC(18,0) NOT NULL,
    DATA_LOCACAO    DATETIME NOT NULL DEFAULT GETDATE(),
    DATA_DEVOLUCAO  DATETIME NULL,
    CONSTRAINT FK_LOCACAO_FILME FOREIGN KEY (COD_FILME)
        REFERENCES dbo.FILME (COD_FILME)
);
go

--trigger para acumular pontos quando um filme for reservado

CREATE TRIGGER TRG_LOCACAO_INSERT
ON dbo.LOCACAO
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE F
    SET F.QTD_LOCACOES = F.QTD_LOCACOES + 1,
        F.RESERVADA = 'S'
    FROM dbo.FILME F
    INNER JOIN inserted I ON F.COD_FILME = I.COD_FILME;
END;

-- a cada vez q tu da um insert nisso, adiciona +1 na coluna QTD_LOCACOES da tabela FILME.
INSERT INTO dbo.LOCACAO (COD_FILME) VALUES (3);

--view da atividade

go

CREATE VIEW VW_QTD_ALUGADO AS
SELECT TOP 100 PERCENT *
FROM dbo.FILME
ORDER BY QTD_LOCACOES DESC;

go

SELECT * FROM VW_QTD_ALUGADO ORDER BY QTD_LOCACOES DESC;
