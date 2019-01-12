--

-- =============================================================
-- Author:				Daniel
-- Create date:			09/01/2018
-- Alteracao Data:		12/01/2019
-- Description:			Inserir Quitação de APagar
-- =============================================================

ALTER PROCEDURE [dbo].[uspAPagar_Quitar]
@IDAPagar INT
,@ValorPago MONEY
,@Acrescimo MONEY = 0
,@SaidaData DATE
,@IDConta TINYINT
,@Observacao AS VARCHAR(MAX)

AS
BEGIN
	-- Valores da tblAPagar
	DECLARE @NovaSituacao TINYINT = 0; -- Situacao EMABERTO
	DECLARE @EmAberto MONEY; -- Valor EmAberto
	DECLARE @APagarOrigem TINYINT
	DECLARE @APagarOrigemID INT
	DECLARE @IDPessoa INT
	DECLARE @Cadastro VARCHAR(50)

	BEGIN TRAN
		BEGIN TRY

		--===================================================================================
		-- ATUALIZA / QUITA A tblAPagar
		--===================================================================================
		-- VERIFICA se toda o APAGAR foi recebido quando entrar o @ValorRecebido
		SELECT @EmAberto = APagarValor - ABS(@ValorPago)
		, @APagarOrigem = Origem
		, @APagarOrigemID = IDOrigem
		, @IDPessoa = IDPessoa
		FROM tblAPagar WHERE IDAPagar = @IDAPagar;

		-- Verifica se o valor Pago é igual ao valor EmAberto
		IF @ValorPago >= @EmAberto
			SET @NovaSituacao = 1; -- Situacao QUITADA

		-- Atualiza a tblAPagar
		UPDATE tblAPagar SET
		ValorPago = COALESCE(ValorPago, 0) + ABS(@ValorPago)
		,Acrescimo =  COALESCE(Acrescimo, 0) + @Acrescimo
		,Situacao = @NovaSituacao
		,PagamentoData = @SaidaData
		WHERE IDAPagar = @IDAPagar;

		--===================================================================================
		-- BLOQUEIA a ORIGEM DO APAGAR (DESPESA OU TRANSACAO OU DESPESA PERIODICA)
		--===================================================================================
		IF @APagarOrigem = 1 -- NESSE CASO ORIGEM DE TRANSACAO DE COMPRA
			UPDATE tblTransacao SET
			IDSituacao = 3 -- situacao BLOQUEADA
			WHERE IDTransacao = @APagarOrigemID;
		ELSE IF @APagarOrigem = 2 -- NESSE CASO ORIGEM DE DESPESA
			UPDATE tblDespesa SET
			Bloqueada = 'TRUE' -- situacao BLOQUEADA
			WHERE IDDespesa = @APagarOrigemID;

		--===================================================================================
		-- INSERE no tblCaixaMovimentacao e no tblObservacao
		--===================================================================================

		-- OBTER O CADASTRO PELO IDPESSOA
		SELECT @Cadastro = Cadastro 
		FROM tblPessoa
		WHERE IDPessoa = @IDPessoa
						
		DECLARE @Descricao VARCHAR(100) = 'PAG-' + dbo.id0000(@IDAPagar) + ' - ' + @Cadastro
		
		INSERT INTO tblCaixaMovimentacao
		(Origem
		,IDOrigem
		,IDConta
		,MovData
		,movValor
		,IDMovForma
		,Creditar
		,Descricao
		,Movimento)
		VALUES
		(1
		,@IDAPagar
		,@IDConta
		,@SaidaData
		,COALESCE(@ValorPago, 0) + @Acrescimo
		,1
	    ,'FALSE'
		,@Descricao, 
		2) -- mov. debito
		
		---RETORNO

		 DECLARE @IDSaida INT = @@IDENTITY

		 IF LEN(@Observacao) > 0 
		 	 INSERT INTO tblObservacao
			 (IDOrigem
			 ,Origem
			 ,Observacao)
			 VALUES
			 (@IDSaida
			 ,3 -- origem TBLCAIXAMOVIMENTACAO
			 ,@Observacao);


		--===================================================================================
		-- FINALIZA
		--===================================================================================
		COMMIT TRAN;
		-- Retorna com o IDAReceberParcela SE HOUVER PARCELA		
		SELECT @IDSaida AS RETORNO;
		
		END TRY
	BEGIN CATCH
		ROLLBACK TRAN;
		SELECT ERROR_MESSAGE() AS RETORNO;
	END CATCH
END