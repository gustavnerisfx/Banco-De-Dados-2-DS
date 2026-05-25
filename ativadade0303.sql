CREATE TABLE dbbPRODUTO (
    ID_Produto INT IDENTITY(1,1) PRIMARY KEY,
	Produto_Nome VARCHAR(40),
    Descricao VARCHAR(40),
    Unidade VARCHAR(2)
);

CREATE TABLE dbbVENDA (
	ID_Venda int,
	Data_Venda date,
    ID_Cliente int,
    ID_Produto int not null,
    QTD_Venda int,
    Valor_Total int,
    Numero_Parcelas int
	FOREIGN KEY (ID_Produto) REFERENCES dbbPRODUTO(ID_Produto)
);

CREATE TABLE dbbCOMPRA (
	ID_Compra int,
	Data_Compra date,
	ID_Cliente int,
	ID_Produto int,
	QTD_Compra int,
	Valor_Total int,
	Numero_Parcelas int
	FOREIGN KEY (ID_Produto) REFERENCES dbbPRODUTO(ID_Produto)
 );

CREATE TABLE dbbSALDO (
	ID_Saldo INT IDENTITY(0,1) PRIMARY KEY NOT NULL,
	ID_Produto INT NOT NULL,
	Caixa INT NOT NULL
	FOREIGN KEY (ID_Produto) REFERENCES dbbPRODUTO(ID_Produto)
);


GO

CREATE PROCEDURE ProdutoeSaldo 

	@Produto_Nome VARCHAR(40),
	@Descricao VARCHAR(40),
	@Unidade INT,
	@Caixa INT
	
AS
BEGIN

	INSERT INTO dbbPRODUTO
	(Produto_Nome, Descricao, Unidade)
	VALUES
	(@Produto_Nome, @Descricao, @unidade)

	INSERT INTO dbbSALDO
	(Caixa)
	VALUES
	(@Caixa)

END
GO



CREATE TABLE dbdbVENDA (
	ID_Venda INT NOT NULL,
	Data_Venda DATE NOT NULL,
	ID_Cliente INT NOT NULL,
	ID_Produto INT NOT NULL,
	QTD_Venda INT NOT NULL,
	Valor_Total INT NOT NULL,
	Numero_Parcelas INT NOT NULL
);

CREATE TABLE dbdbCOMPRA (
	ID_Produto int identity(1,1) primary key,
	Descricao nvarchar(40) NOT NULL,
	Unidade varchar(2) NOT NULL
);

CREATE TABLE dbdbSALDO (
	ID_Produto int NOT NULL,
    Saldo_produto decimal NOT NULL
);

CREATE TRIGGER exemplo_insert
ON dbdbVENDA
AFTER INSERT
AS
BEGIN

	DECLARE
	@QTD_Venda INT

	SELECT @QTD_Venda = @QTD

END
GO
