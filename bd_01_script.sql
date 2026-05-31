-- ============================================================
--  BANCO DE DADOS: bd_01
--  DESCRICAO: Script completo e organizado
--  ORDEM DE EXECUCAO: Seguir exatamente a sequencia abaixo
-- ============================================================


-- ============================================================
-- PASSO 1 — SELECIONAR O BANCO DE DADOS
-- ============================================================

USE bd_01
GO


-- ============================================================
-- PASSO 2 — REMOVER OBJETOS EXISTENTES (SE HOUVER)
--           Ordem inversa das dependencias
-- ============================================================

-- Triggers
DROP TRIGGER IF EXISTS trg_AO_Inserir_Venda
DROP TRIGGER IF EXISTS trg_SubtrairSaldo
DROP TRIGGER IF EXISTS trg_SomarSaldo
DROP TRIGGER IF EXISTS trg_AO_Inserir_Compra
DROP TRIGGER IF EXISTS trg_Financeiro_Venda

-- Procedures
DROP PROCEDURE IF EXISTS sp_InserirProdutos

-- Functions
DROP FUNCTION IF EXISTS dbo.fn_ProximoDiaUtil

-- Dados (ordem importa por causa das FKs)
DELETE FROM Contas_A_Receber
DELETE FROM Venda
DELETE FROM Compra
DELETE FROM Saldo
DELETE FROM Produto
DELETE FROM Cliente
DELETE FROM Feriados_Fixos
DELETE FROM Feriados_Do_Ano

-- Tabelas (ordem inversa das dependencias)
DROP TABLE IF EXISTS Contas_A_Receber
DROP TABLE IF EXISTS Venda
DROP TABLE IF EXISTS Compra
DROP TABLE IF EXISTS Saldo
DROP TABLE IF EXISTS Produto
DROP TABLE IF EXISTS Cliente
DROP TABLE IF EXISTS Feriados_Fixos
DROP TABLE IF EXISTS Feriados_Do_Ano

GO


-- ============================================================
-- PASSO 3 — CRIAR TABELAS
--           Ordem: tabelas sem dependencia primeiro
-- ============================================================

-- 3.1 Cliente (sem dependencias)
CREATE TABLE Cliente (
    ID_CLIENTE INT IDENTITY(1,1) PRIMARY KEY,
    NOME       NVARCHAR(100)
)

-- 3.2 Produto (sem dependencias)
CREATE TABLE Produto (
    ID_PRODUTO INT IDENTITY(1,1) PRIMARY KEY,
    DESCRICAO  NVARCHAR(40),
    UNIDADE    VARCHAR(2)
)

-- 3.3 Saldo (depende de Produto)
CREATE TABLE Saldo (
    ID_PRODUTO    INT PRIMARY KEY,
    SALDO_PRODUTO DECIMAL(10,2),
    CONSTRAINT FK_SALDO_PRODUTO FOREIGN KEY (ID_PRODUTO)
        REFERENCES Produto(ID_PRODUTO)
)

-- 3.4 Venda (depende de Produto e Cliente)
CREATE TABLE Venda (
    ID_VENDA        INT IDENTITY(1,1) PRIMARY KEY,
    DATA_VENDA      DATE,
    ID_CLIENTE      INT,
    ID_PRODUTO      INT,
    QTD_VENDA       INT,
    VALOR_TOTAL     DECIMAL(10,2),
    NUMERO_PARCELAS INT,
    CONSTRAINT FK_VENDA_PRODUTO FOREIGN KEY (ID_PRODUTO)
        REFERENCES Produto(ID_PRODUTO),
    CONSTRAINT FK_VENDA_CLIENTE FOREIGN KEY (ID_CLIENTE)
        REFERENCES Cliente(ID_CLIENTE)
)

-- 3.5 Compra (depende de Produto e Cliente)
CREATE TABLE Compra (
    ID_COMPRA       INT IDENTITY(1,1) PRIMARY KEY,
    DATA_COMPRA     DATE,
    ID_FORNECEDOR   INT,
    ID_PRODUTO      INT,
    QTD_COMPRA      INT,
    VALOR_TOTAL     DECIMAL(10,2),
    NUMERO_PARCELAS INT,
    CONSTRAINT FK_COMPRA_PRODUTO FOREIGN KEY (ID_PRODUTO)
        REFERENCES Produto(ID_PRODUTO)
)

-- 3.6 Feriados Fixos (sem dependencias) — verifica apenas DIA e MES
CREATE TABLE Feriados_Fixos (
    ID_FERIADO INT IDENTITY(1,1) PRIMARY KEY,
    DIA        INT,
    MES        INT,
    DESCRICAO  NVARCHAR(50)
)

-- 3.7 Feriados do Ano (sem dependencias) — verifica a DATA completa
CREATE TABLE Feriados_Do_Ano (
    ID_FERIADO   INT IDENTITY(1,1) PRIMARY KEY,
    DATA_FERIADO DATE,
    DESCRICAO    NVARCHAR(50)
)

-- 3.8 Contas a Receber (depende de Venda)
CREATE TABLE Contas_A_Receber (
    ID_PARCELA      INT IDENTITY(1,1) PRIMARY KEY,
    ID_VENDA        INT,
    NUM_PARCELA     INT,
    DATA_VENCIMENTO DATE,
    VALOR_PARCELA   MONEY,
    DATA_PAGAMENTO  DATE,
    CONSTRAINT FK_CAR_VENDA FOREIGN KEY (ID_VENDA)
        REFERENCES Venda(ID_VENDA)
)

GO


-- ============================================================
-- PASSO 4 — INSERIR DADOS INICIAIS
-- ============================================================

-- 4.1 Feriados Fixos (nacionais — verificados por DIA e MES)
INSERT INTO Feriados_Fixos (DIA, MES, DESCRICAO) VALUES
(1,  1,  'Ano Novo'),
(21, 4,  'Tiradentes'),
(1,  5,  'Dia do Trabalho'),
(7,  9,  'Independencia do Brasil'),
(12, 10, 'Nossa Senhora Aparecida'),
(2,  11, 'Finados'),
(15, 11, 'Proclamacao da Republica'),
(25, 12, 'Natal')

-- 4.2 Feriados do Ano (moveis — verificados pela DATA completa)
INSERT INTO Feriados_Do_Ano (DATA_FERIADO, DESCRICAO) VALUES
('2025-03-03', 'Carnaval'),
('2025-03-04', 'Carnaval'),
('2025-04-18', 'Sexta-feira Santa'),
('2025-06-19', 'Corpus Christi'),
('2026-02-16', 'Carnaval'),
('2026-02-17', 'Carnaval'),
('2026-04-03', 'Sexta-feira Santa'),
('2026-05-14', 'Corpus Christi')

GO


-- ============================================================
-- PASSO 5 — CRIAR FUNCTION
-- ============================================================

-- Recebe uma data e retorna o proximo dia util
-- Pula: sabado, domingo, feriados fixos e feriados do ano

CREATE FUNCTION fn_ProximoDiaUtil (@DATA DATE)
RETURNS DATE
AS
BEGIN
    DECLARE @DATA_UTIL DATE = @DATA

    WHILE (
        -- Sabado = 7, Domingo = 1
        DATEPART(WEEKDAY, @DATA_UTIL) IN (1, 7)

        OR

        -- Feriado fixo: compara apenas DIA e MES
        EXISTS (
            SELECT 1 FROM Feriados_Fixos
            WHERE DIA = DAY(@DATA_UTIL)
            AND   MES = MONTH(@DATA_UTIL)
        )

        OR

        -- Feriado do ano: compara a data completa
        EXISTS (
            SELECT 1 FROM Feriados_Do_Ano
            WHERE DATA_FERIADO = @DATA_UTIL
        )
    )
    BEGIN
        SET @DATA_UTIL = DATEADD(DAY, 1, @DATA_UTIL)
    END

    RETURN @DATA_UTIL
END

GO


-- ============================================================
-- PASSO 6 — CRIAR PROCEDURES
-- ============================================================

-- Insere 2 produtos e seus respectivos saldos iniciais
-- Usa SCOPE_IDENTITY() para pegar o ID gerado automaticamente

CREATE PROCEDURE sp_InserirProdutos
AS
BEGIN
    DECLARE @ID INT

    -- Produto 1
    INSERT INTO Produto (DESCRICAO, UNIDADE)
    VALUES ('Notebook Dell', 'pc')

    SET @ID = SCOPE_IDENTITY()

    INSERT INTO Saldo (ID_PRODUTO, SALDO_PRODUTO)
    VALUES (@ID, 5000)

    -- Produto 2
    INSERT INTO Produto (DESCRICAO, UNIDADE)
    VALUES ('Mouse Logitech', 'pc')

    SET @ID = SCOPE_IDENTITY()

    INSERT INTO Saldo (ID_PRODUTO, SALDO_PRODUTO)
    VALUES (@ID, 100)

    -- Exibe resultado
    SELECT p.ID_PRODUTO, p.DESCRICAO, p.UNIDADE, s.SALDO_PRODUTO
    FROM Produto p
    INNER JOIN Saldo s ON p.ID_PRODUTO = s.ID_PRODUTO
END

GO


-- ============================================================
-- PASSO 7 — CRIAR TRIGGERS
-- ============================================================

-- TRIGGER 1: Ao inserir uma Venda
--   - Subtrai QTD_VENDA do Saldo do Produto

CREATE TRIGGER trg_SubtrairSaldo
ON Venda
AFTER INSERT
AS
BEGIN
    UPDATE S
        SET S.SALDO_PRODUTO = S.SALDO_PRODUTO - I.QTD_VENDA
    FROM Saldo S
    INNER JOIN inserted I ON S.ID_PRODUTO = I.ID_PRODUTO
END

GO

-- TRIGGER 2: Ao inserir uma Compra
--   - Soma QTD_COMPRA ao Saldo do Produto

CREATE TRIGGER trg_SomarSaldo
ON Compra
AFTER INSERT
AS
BEGIN
    UPDATE S
        SET S.SALDO_PRODUTO = S.SALDO_PRODUTO + I.QTD_COMPRA
    FROM Saldo S
    INNER JOIN inserted I ON S.ID_PRODUTO = I.ID_PRODUTO
END

GO

-- TRIGGER 3: Ao inserir uma Venda (Financeiro)
--   - Divide Valor_Total por Numero_Parcelas
--   - Gera uma linha por parcela em Contas_A_Receber
--   - Cada vencimento cai em um dia util (pula sabado, domingo e feriados)

CREATE TRIGGER trg_Financeiro_Venda
ON Venda
AFTER INSERT
AS
BEGIN
    DECLARE
        @ID_VENDA      INT,
        @VALOR_TOTAL   MONEY,
        @N_PARCELAS    INT,
        @VALOR_PARCELA MONEY,
        @DATA_VENDA    DATE,
        @DATA_VENC     DATE,
        @CONTADOR      INT

    SELECT
        @ID_VENDA    = ID_VENDA,
        @VALOR_TOTAL = VALOR_TOTAL,
        @N_PARCELAS  = NUMERO_PARCELAS,
        @DATA_VENDA  = DATA_VENDA
    FROM inserted

    -- Calcula o valor de cada parcela
    SET @VALOR_PARCELA = @VALOR_TOTAL / @N_PARCELAS
    SET @CONTADOR = 1

    -- Gera uma linha por parcela
    WHILE @CONTADOR <= @N_PARCELAS
    BEGIN
        -- Data base: 1 mes por parcela a partir da data da venda
        SET @DATA_VENC = DATEADD(MONTH, @CONTADOR, @DATA_VENDA)

        -- Ajusta para o proximo dia util (pula sabado, domingo e feriados)
        SET @DATA_VENC = dbo.fn_ProximoDiaUtil(@DATA_VENC)

        INSERT INTO Contas_A_Receber
            (ID_VENDA, NUM_PARCELA, DATA_VENCIMENTO, VALOR_PARCELA, DATA_PAGAMENTO)
        VALUES
            (@ID_VENDA, @CONTADOR, @DATA_VENC, @VALOR_PARCELA, NULL)

        SET @CONTADOR = @CONTADOR + 1
    END
END

GO


-- ============================================================
-- PASSO 8 — POPULAR DADOS DE TESTE
-- ============================================================

-- 8.1 Inserir cliente
INSERT INTO Cliente (NOME)
VALUES ('Joao Silva')

-- 8.2 Inserir produtos e saldos via procedure
EXEC sp_InserirProdutos

GO


-- ============================================================
-- PASSO 9 — TESTES
-- ============================================================

-- TESTE 1 e 3: Inserir uma venda
--   Dispara trg_SubtrairSaldo  → saldo reduzido
--   Dispara trg_Financeiro_Venda → parcelas geradas em Contas_A_Receber

INSERT INTO Venda (DATA_VENDA, ID_CLIENTE, ID_PRODUTO, QTD_VENDA, VALOR_TOTAL, NUMERO_PARCELAS)
VALUES (GETDATE(), 1, 1, 2, 1200.00, 3)

SELECT * FROM Contas_A_Receber  -- deve ter 3 parcelas de 400.00 com datas uteis
SELECT * FROM Saldo              -- saldo do produto 1 deve ter reduzido 2

GO

-- TESTE 2: Inserir uma compra
--   Dispara trg_SomarSaldo → saldo aumentado

INSERT INTO Compra (DATA_COMPRA, ID_FORNECEDOR, ID_PRODUTO, QTD_COMPRA, VALOR_TOTAL, NUMERO_PARCELAS)
VALUES (GETDATE(), NULL, 1, 10, 8000.00, 1)

SELECT * FROM Saldo  -- saldo do produto 1 deve ter aumentado 10

GO
