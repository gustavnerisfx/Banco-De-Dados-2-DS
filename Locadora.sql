CREATE TABLE dbo.CLIENTES (
    COD_CLIENTE NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    RG VARCHAR(9) NOT NULL,
    NOME VARCHAR(50) NOT NULL,
    ENDERECO VARCHAR(50) NULL,
    BAIRRO VARCHAR(30) NULL,
    CIDADE VARCHAR(30) NULL,
    ESTADO CHAR(2) NOT NULL,
    TELEFONE VARCHAR(15) NULL,
    EMAIL VARCHAR(30) NULL,
    DATANASCIMENTO DATETIME NULL,
    SEXO CHAR(1)
);

CREATE TABLE dbo.CATEGORIA (
    COD_CATEGORIA NUMERIC(10,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    NOME_CATEGORIA VARCHAR(20) NOT NULL
);

CREATE TABLE dbo.FILME (
    COD_FILME NUMERIC(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    FILME VARCHAR(30) NOT NULL,
    COD_CATEGORIA NUMERIC(10,0) NOT NULL,
    DIRETOR VARCHAR(50) NOT NULL,
    VALOR_LOCACAO FLOAT NOT NULL,
    RESERVADA CHAR(1) NOT NULL
);

CREATE TABLE dbo.LOCACOES (
    COD_LOCACAO NUMERIC(18,0) IDENTITY(1,1) NOT NULL,
    COD_CLIENTE NUMERIC(18,0) NOT NULL,
    COD_FILME NUMERIC(18,0) NOT NULL,
    DATA_LOCACAO DATETIME NOT NULL,
    DATA_EXPIRACAO DATETIME NULL,
    CONSTRAINT PK_LOCACAO_CLIENTE 
        PRIMARY KEY (COD_LOCACAO, COD_CLIENTE, COD_FILME)
);

ALTER TABLE dbo.LOCACOES
ADD CONSTRAINT FK_LOCACOES_CLIENTE
FOREIGN KEY (COD_CLIENTE)
REFERENCES dbo.CLIENTES (COD_CLIENTE);

ALTER TABLE dbo.LOCACOES
ADD CONSTRAINT FK_LOCACOES_FILME
FOREIGN KEY (COD_FILME)
REFERENCES dbo.FILME (COD_FILME);

ALTER TABLE dbo.FILME
ADD CONSTRAINT FK_CATEGORIA_FILME
FOREIGN KEY (COD_CATEGORIA)
REFERENCES dbo.CATEGORIA (COD_CATEGORIA);


INSERT INTO dbo.CATEGORIA VALUES ('Ação');
INSERT INTO dbo.CATEGORIA VALUES ('Romance');
INSERT INTO dbo.CATEGORIA VALUES ('Aventura');
INSERT INTO dbo.CATEGORIA VALUES ('Ficção');
INSERT INTO dbo.CATEGORIA VALUES ('Drama');
INSERT INTO dbo.CATEGORIA VALUES ('Terror');
INSERT INTO dbo.CATEGORIA VALUES ('Desenho');
INSERT INTO dbo.CATEGORIA VALUES ('Policial');
INSERT INTO dbo.CATEGORIA VALUES ('Comédia');


INSERT INTO dbo.CLIENTES VALUES
('321346530','Edson Martin Feitosa','Rua xxx Alvarenga, 1','Jd. Vera Cruz','Sorocaba','SP','32125809','edson.feitosa@ig.com.br',CONVERT(VARCHAR,'1985-04-01 00:00:00.000',102),'M'),

('421346111','Rafael Fernando de Moraes Moreno','Rua xxxx de xxxx, 123','Jd. Nova Esperança','São Roque','SP','32274567','rafael@terra.com.br',CONVERT(VARCHAR,'1985-04-01 00:00:00.000',102),'M'),

('324857670','João da Silva','Rua xxxx xxxx, 13','Av. Bartolomeu','Sorocaba','SP','32134098','joao@uol.com.br',CONVERT(VARCHAR,'1992-12-05 00:00:00.000',102),'M'),

('112345553','Maria Chiquinha','Rua xxxx, 55','Jd. Vera Cruz','Sorocaba','SP','23336684','maria@ig.com.br',CONVERT(VARCHAR,'1992-12-05 00:00:00.000',102),'F'),

('945848768','Rafael Nunes Sales','Rua xxx Alvarenga, 4','Jd. Vera Cruz','Sorocaba','SP','32124609','rafael.sales@terra.com.br',CONVERT(VARCHAR,'1992-12-05 00:00:00.000',102),'F'),

('676548499','Daniela Martin Feitosa','Rua xxxxx, 1','Jd. Vera das Acássicas','Votorantim','SP','32132109','daniela.martin@gmail.com',CONVERT(VARCHAR,'1992-12-05 00:00:00.000',102),'F'),

('321349999','Renata Cristina','Rua xxx Alvarenga, 1','Jd. Vera Cruz','Sorocaba','SP','32125809','renata@gmail',CONVERT(VARCHAR,'1970-09-01 00:00:00.000',102),'F'),

('335466531','Joaquim Ferreira de Souza Junior','Rua xxx xxxx, 65','Jd. Santa Rosália','Votorantim','SP','11125809','joaquim_junior@ig.com.br',CONVERT(VARCHAR,'1980-04-08 00:00:00.000',102),'M'),

('112233445','Ladislau Ferreira','Rua xxxx Alvarenga, 12345','Jd. Vera Cruz','Sorocaba','SP','32144409','ladislau@terra.com.br',CONVERT(VARCHAR,'1988-01-03 00:00:00.000',102),'M'),

('222222222','Vanessa Oliveira','Rua xxxxxx, 1','Jd. do Sol','Votorantim','SP','32122222','vanessa@ig.com.br',CONVERT(VARCHAR,'1998-08-08 00:00:00.000',102),'F');


INSERT INTO dbo.FILME VALUES
('300',1,'Richard Donner',3.5,'n'),
('Máquina Mortífera',1,'Richard Donner',3.6,'n'),
('A Mexicana',2,'Burr Steers',2,'s'),
('A Verdade Nua e Crua',2,'Robert Luketic',4,'n'),
('A vida é bela',2,'Roberto Benigni',3.5,'s'),
('Austrália',3,'Baz Luhrmann',4,'s'),
('Ultimato Bourn',3,'Paul Greengrass',3.5,'n'),
('Constantine',4,'Francis Lawrence',2.5,'s'),
('Os Irmãos Grimm',4,'Terry Gilliam',3.5,'n'),
('Os Doze Macacos',4,'Terry Gilliam',2.5,'n'),
('Amadeus',5,'Milos Forman',10,'n'),
('As Torres Gêmeas',5,'Oliver Stone',2.5,'s'),
('Platoon',1,'Oliver Stone',5.5,'s'),
('O Advogado do Diabo',6,'Taylor Hackford',1.5,'s'),
('Beowulf',7,'Robert Zemeckis',1,'n'),
('Bolt o super cão',7,'Byron Howard',1.5,'s'),
('Apertem o cinto o piloto sumiu',9,'Jim Abrahams',3.6,'s'),
('Doze é demais',9,'Shawn Levy',9.2,'s'),
('Uma noite no museu',9,'Shawn Levy',2.5,'n');


INSERT INTO LOCACOES VALUES
(1,1,CONVERT(DATETIME,'2010-03-20 19:05:43.887',121),CONVERT(DATETIME,'2010-03-23 00:00:00.000',121)),
(1,6,CONVERT(DATETIME,'2010-03-20 19:05:43.887',121),CONVERT(DATETIME,'2010-03-23 00:00:00.000',121)),
(1,8,CONVERT(DATETIME,'2010-03-20 19:05:43.887',121),CONVERT(DATETIME,'2010-03-23 00:00:00.000',121)),
(1,2,CONVERT(DATETIME,'2010-03-15 00:00:00.000',121),CONVERT(DATETIME,'2010-03-17 00:00:00.000',121)),
(1,13,CONVERT(DATETIME,'2010-03-15 00:00:00.000',121),CONVERT(DATETIME,'2010-03-17 00:00:00.000',121));