--

-- =============================================================
-- Author:		Daniel
-- Create date: 03/11/2017
-- Alter date:  20/12/2018
-- Description:	Inserir Nova Entrada
-- =============================================================

--

 ALTER PROCEDURE [dbo].[uspEntrada_Inserir]
 @Origem AS TINYINT -- 1:TRANSACAO | 2:ARECEBERPARCELA | 3:CREDITOS
 ,@IDOrigem AS INT
 ,@IDConta AS TINYINT
 ,@MovData AS DATE
 ,@MovValor AS MONEY
 ,@IDMovForma AS INT
 ,@Creditar AS BIT = 0
 ,@Observacao AS VARCHAR(100) = NULL
 ,@Descricao VARCHAR(100) = NULL
 AS
 BEGIN
	-- OBTEM A DESCRICAO SE FOR NULL
	IF @Descricao IS NULL
	BEGIN
		DECLARE @IDPessoa INT
		DECLARE @Cadastro VARCHAR(50)

		-- 1:TRANSACAO | 2:ARECEBERPARCELA | 3:CREDITOS
		IF @Origem = 1 -- TRANSACAO | VENDA
			BEGIN
				SET @Descricao = 'Venda à vista' + ' ' +  dbo.ID0000(@IDOrigem)
			END
		ELSE IF @Origem = 2  -- A RECEBER PARCELA
			BEGIN
				-- OBTER O IDPESSOA
				SELECT @IDPessoa = IDPessoa 
				FROM tblAReceber
				WHERE IDAReceber = (SELECT IDAReceber FROM tblAReceberParcela WHERE IDAReceberParcela = @IDOrigem)
						
				SELECT @Cadastro = Cadastro
				FROM tblPessoa
				WHERE IDPessoa = @IDPessoa

				SET @Descricao = 'PARC-' + dbo.ID0000(@IDOrigem) + ' - ' + @Cadastro
			END
		ELSE IF @Origem = 3
			BEGIN
				SET @Descricao = 'Créditos ID: ' + dbo.ID0000(@IDOrigem)
			END
	END
	
	-- INSERE O REGISTRO
	INSERT INTO tblCaixaMovimentacao
	(Origem
	,IDOrigem
	,IDConta
	,MovData
	,MovValor
	,IDMovForma
	,Creditar
	,Descricao
	,Movimento)
	VALUES
	(@Origem
	,@IDOrigem
	,@IDConta
	,@MovData
	,@MovValor
	,@IDMovForma
	,@Creditar
	,@Descricao
	,1)

	DECLARE @ID INT = @@IDENTITY

	-- INSERE A OBERVACAO SE NECESSARIO
	IF LEN(@Observacao) > 0 
		INSERT INTO tblObservacao
		(IDOrigem
		,Origem
		,Observacao)
		VALUES
		(@ID
		,3 -- origem TBLCAIXAMOVIMENTACAO
		,@Observacao);

	---RETORNO
	SELECT @ID AS RETORNO

 END