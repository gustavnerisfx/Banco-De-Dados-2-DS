use banco_atividades;

CREATE TABLE dbo.FILME (
	COD_FILME NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL, 
	FILME VARCHAR(30) NOT NULL, 
	COD_CATEGORIA NUMERIC(10,0) NOT NULL, 
	DIRETOR VARCHAR(50) NOT NULL, 
	VALOR_LOCACAO FLOAT NOT NULL, 
	RESERVADA CHAR(1) NOT NULL 
);

INSERT INTO dbo.FILME (FILME, COD_CATEGORIA, DIRETOR, VALOR_LOCACAO, RESERVADA)
VALUES
('Matrix',                1, 'Wachowski',        9.90,  'N'),
('Interestelar',          2, 'Christopher Nolan', 12.50, 'N'),
('O Poderoso Chefão',     3, 'Coppola',           8.00,  'S'),
('Pulp Fiction',          3, 'Tarantino',         7.50,  'N'),
('Toy Story',             4, 'John Lasseter',     6.90,  'N'),
('O Senhor dos Anéis',    2, 'Peter Jackson',     11.00, 'S'),
('Clube da Luta',         3, 'David Fincher',     8.50,  'N'),
('Cidade de Deus',        5, 'Fernando Meirelles',7.00,  'N'),
('Vingadores: Ultimato',  1, 'Russo Brothers',    13.00, 'S'),
('Coringa',               3, 'Todd Phillips',     10.00, 'N');

ALTER TABLE dbo.FILME
ADD CONSTRAINT CK_FILME_RESERVADA CHECK (RESERVADA IN ('S', 'N'));

ALTER TABLE dbo.FILME
ADD CONSTRAINT DF_FILME_RESERVADA DEFAULT 'N' FOR RESERVADA;

CREATE VIEW VisualizarFilmeDisponivel AS
SELECT
	COD_FILME,
	FILME,
	COD_CATEGORIA,
	DIRETOR,
	VALOR_LOCACAO,
	RESERVADA
	QTD_LOCACOES
FROM dbo.FILME
WHERE RESERVADA = 'N';

go

SELECT * FROM VisualizarFilmeDisponivel


SELECT * FROM dbo.FILME