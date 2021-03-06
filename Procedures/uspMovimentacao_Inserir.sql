--

-- =============================================================
-- Author:		Daniel
-- Create date: 03/11/2017
-- Alter date:  05/02/2019
-- Description:	Inserir Nova Movimentação
-- =============================================================

--

/* ORIGENS DA MOVIMENTACAO
----------------------------------------------------
1	tblVenda				IDVenda
2	tblAReceberParcela		IDAReceberParcela
3	tblCreditos				IDCredito
4	tblDevolucaoSaida		IDDevolucao
10	tblAPagar				IDAPagar
11	tblCaixaTransferencia	IDTransferencia
----------------------------------------------------
*/

 ALTER PROCEDURE [dbo].[uspMovimentacao_Inserir]
 @Origem AS TINYINT -- VIDE TABELA
 ,@IDOrigem AS INT
 ,@IDConta AS SMALLINT
 ,@IDMeio AS TINYINT
 ,@MovData AS DATE
 ,@MovValor AS MONEY
 ,@IDMovForma AS SMALLINT = NULL
 ,@Creditar AS BIT = 0
 ,@Observacao AS VARCHAR(100) = NULL
 ,@Descricao VARCHAR(100) = NULL
 ,@Movimento AS TINYINT -- 1:Credito | 2:Debito | 3:Transferencia

 AS
 BEGIN
	-- OBTEM A DESCRICAO SE FOR NULL
	IF @Descricao IS NULL
	BEGIN
		DECLARE @IDPessoa INT
		DECLARE @Cadastro VARCHAR(50)

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
		ELSE IF @Origem = 3 -- CREDITOS
			BEGIN
				SET @Descricao = 'Créditos ID: ' + dbo.ID0000(@IDOrigem)
			END
		ELSE IF @Origem = 4 -- CREDITO DE DEVOLUCAO DE SAIDA
			BEGIN
				SET @Descricao = 'Crédito de Devolução: ' + dbo.ID0000(@IDOrigem)
			END
		ELSE IF @Origem = 10 -- PAGAMENTO/SAIDA
			BEGIN
				SET @Descricao = 'A Pagar / Despesa no.: ' + dbo.ID0000(@IDOrigem)
			END
	END
	
	-- INSERE O REGISTRO
	INSERT INTO tblCaixaMovimentacao
	(Origem
	,IDOrigem
	,IDConta
	,IDMeio
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
	,@IDMeio
	,@MovData
	,@MovValor
	,@IDMovForma
	,@Creditar
	,@Descricao
	,@Movimento)

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
	SELECT * from qryMovimentacao where IDMovimentacao = @ID

 END