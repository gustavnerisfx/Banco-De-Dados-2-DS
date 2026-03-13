/*
	Procedures
*/

/*
	Procedure de incluir
*/

ALTER PROCEDURE IncluirCliente

	@RG VARCHAR(9),
	@NOME VARCHAR(50),
	@ENDERECO VARCHAR(50),
	@BAIRRO VARCHAR(30),
	@CIDADE VARCHAR(30),
	@ESTADO CHAR(2),
	@TELEFONE VARCHAR(15),
	@EMAIL VARCHAR(30),
	@DATANASCIMENTO DATETIME,
	@SEXO CHAR(1)

AS
BEGIN

	INSERT INTO CLIENTES
	(RG, NOME, ENDERECO, BAIRRO, CIDADE, ESTADO, TELEFONE, EMAIL, DATANASCIMENTO, SEXO)
	VALUES
	(@RG, @NOME, @ENDERECO, @BAIRRO, @CIDADE, @ESTADO, @TELEFONE, @EMAIL, @DATANASCIMENTO, @SEXO)

END
GO


/*
	Procedure de excluir
*/


CREATE PROCEDURE ExcluirCliente
	@COD_CLIENTE INT
AS
BEGIN
	DELETE FROM CLIENTES
    WHERE COD_CLIENTE = @COD_CLIENTE
END
GO

/*
	Procedure de listar
*/

CREATE PROCEDURE ListarClientes
AS
BEGIN
	SELECT *
	FROM CLIENTES
END
GO

/*
	Procedure de listar em especifico
*/

CREATE PROCEDURE ListarClientesEspecifico
	@COD_CLIENTE INT
AS
BEGIN
	SELECT *
	FROM CLIENTES
	WHERE COD_CLIENTE = @COD_CLIENTE
END
GO

/*
	Procedure de Atualizar
*/

CREATE PROCEDURE AtualizarClientes

	@COD_CLIENTE INT,
	@RG VARCHAR(9),
	@NOME VARCHAR(50),
	@ENDERECO VARCHAR(50),
	@BAIRRO VARCHAR(30),
	@CIDADE VARCHAR(30),
	@ESTADO CHAR(2),
	@TELEFONE VARCHAR(15),
	@EMAIL VARCHAR(30),
	@DATANASCIMENTO DATETIME,
	@SEXO CHAR(1)

AS
BEGIN
	UPDATE CLIENTES
	SET RG = @RG, NOME = @NOME, ENDERECO = @ENDERECO,
		BAIRRO = @BAIRRO, CIDADE = @CIDADE, ESTADO = @ESTADO,
		TELEFONE = @TELEFONE, EMAIL = @EMAIL, DATANASCIMENTO =
		@DATANASCIMENTO, SEXO = @SEXO
	WHERE COD_CLIENTE = @COD_CLIENTE
END
GO



EXEC ListarClientesEspecifico 14
EXEC ListarClientes
EXEC IncluirCliente '123456789', 'Pedro A Cabral', 'Rua xxxx, 145','Santa Marta', 'Sorocaba', 'São Paulo','15981205501', 
					'pedroalvares@uol.com', '2000-03-01', 'M';
EXEC AtualizarClientes 13, '987654321', 'Weimar', 'Rua xxxx, 629','Mitte', 'Berlim', 'Berlim','15981205501', 
						'weimar@yahoo.com', '2001-03-01', 'M';
EXEC ExcluirCliente 13