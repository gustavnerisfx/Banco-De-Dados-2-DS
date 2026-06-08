CREATE TABLE filmes_dbo (
    ID_FILME  INT          NOT NULL IDENTITY(1,1),
    TITULO    VARCHAR(100) NOT NULL,
    GENERO    VARCHAR(50)      NULL,
    ANO       INT              NULL,
    STATUS    VARCHAR(10)  NOT NULL CONSTRAINT DF_filmes_status DEFAULT 'disponivel',
    CONSTRAINT PK_filmes        PRIMARY KEY (ID_FILME),
    CONSTRAINT CK_filmes_status CHECK (STATUS IN ('disponivel', 'alugado'))
)
GO

CREATE TABLE locacoes_dbo (
    COD_LOCACAO    INT          NOT NULL IDENTITY(1,1),
    COD_FILME      INT          NOT NULL,
    NOME_CLIENTE   VARCHAR(100) NOT NULL,
    DATA_LOCACAO   DATE         NOT NULL CONSTRAINT DF_locacoes_data DEFAULT GETDATE(),
    DATA_DEVOLUCAO DATE             NULL,
    CONSTRAINT PK_locacoes       PRIMARY KEY (COD_LOCACAO),
    CONSTRAINT FK_locacoes_filme FOREIGN KEY (COD_FILME)
        REFERENCES filmes_dbo (ID_FILME)
)
GO

--trigger de setar alugado

CREATE TRIGGER trg_locar_filme
ON locacoes_dbo
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON

    UPDATE filmes_dbo
        SET STATUS = 'alugado'
    FROM filmes_dbo f
    INNER JOIN inserted i ON f.ID_FILME = i.COD_FILME
END
GO

-- insert pra popular

INSERT INTO filmes_dbo (TITULO, GENERO, ANO)
VALUES ('O Poderoso Chefão', 'Crime', 1972),
       ('Interestelar', 'Ficção Científica', 2014),
       ('Parasita', 'Thriller', 2019)
GO

SELECT * FROM filmes_dbo

INSERT INTO locacoes_dbo (COD_FILME, NOME_CLIENTE, DATA_LOCACAO, DATA_DEVOLUCAO)
VALUES (3, 'Jose Silveira', GETDATE(), NULL)

SELECT * FROM filmes_dbo
SELECT * FROM locacoes_dbo

go

-- para devolver

CREATE TRIGGER trg_devolver_filme
ON locacoes_dbo
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON

    UPDATE filmes_dbo
        SET STATUS = 'disponivel'
    FROM filmes_dbo f
    INNER JOIN inserted i  ON f.ID_FILME = i.COD_FILME
    INNER JOIN deleted  d  ON d.COD_LOCACAO = i.COD_LOCACAO
    WHERE d.DATA_DEVOLUCAO IS NULL
      AND i.DATA_DEVOLUCAO IS NOT NULL
END
GO


UPDATE locacoes_dbo
    SET DATA_DEVOLUCAO = GETDATE()
WHERE COD_FILME = 3
  AND DATA_DEVOLUCAO IS NULL