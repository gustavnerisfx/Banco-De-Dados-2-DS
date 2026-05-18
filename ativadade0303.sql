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
