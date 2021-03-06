--


-- =============================================================
-- Author:			Daniel
-- Create date:		07/11/2017
-- Alteracao Data:	21/12/2018
-- Description:		Estornar Quitação de A Receber Parcela
-- =============================================================

ALTER PROCEDURE [dbo].[uspAReceberParcela_Estornar]
@IDAReceberParcela INT
,@IDMovimentacao INT

AS
BEGIN
	BEGIN TRAN
		BEGIN TRY

		DECLARE @IDCaixa INT;
		DECLARE @IDAReceber INT;
		DECLARE @ValorEstornado MONEY;
		DECLARE @JurosPago MONEY;
		DECLARE @TotalPago MONEY;
		DECLARE @IDOrigem INT;
		DECLARE @Origem TINYINT;
		DECLARE @ValorPagoTotal MONEY;

		--===================================================================================
		-- VERIFICA CAIXA NULL E EXCLUI A ENTRADA
		--===================================================================================
		SELECT @IDCaixa = IDCaixa, @ValorEstornado = MovValor 
		FROM tblCaixaMovimentacao
		WHERE IDMovimentacao = @IDMovimentacao
		
		IF @IDCaixa IS NOT NULL
			RAISERROR('Essa Parcela/Entrada NÃO PODE ser Estornada, pois possui um caixa associado...', 14, 1)
		ELSE
			DELETE tblCaixaMovimentacao WHERE IDMovimentacao = @IDMovimentacao

		--===================================================================================
		-- ATUALIZA tblAReceberParcela
		--===================================================================================
		-- VERIFICA o JUROS PAGO DA PARCELA E O IDAReceber
		SELECT @IDAReceber = IDAReceber
		,@JurosPago = ValorJuros
		,@TotalPago = ValorPagoParcela
		FROM tblAReceberParcela WHERE IDAReceberParcela = @IDAReceberParcela;

		IF @ValorEstornado >= COALESCE(@JurosPago, 0)
			BEGIN
				SET @TotalPago = @TotalPago - @ValorEstornado - COALESCE(@JurosPago, 0)
				SET @JurosPago = 0
			END
		ELSE
			BEGIN
				SET @JurosPago = @JurosPago - @ValorEstornado
			END

		-- Atualiza a tblAReceberParcela
		UPDATE tblAReceberParcela SET
		ValorPagoParcela = @TotalPago
		,ValorJuros = @JurosPago
		,SituacaoParcela = 0
		,PagamentoData = NULL
		WHERE IDAReceberParcela = @IDAReceberParcela;

		--===================================================================================
		-- ATUALIZA tblAReceber
		--===================================================================================
		-- VERIFICA se todo o AReceber foi recebido quando entrar o @ValorRecebidoParcela
		SELECT @IDOrigem = IDOrigem, @Origem = Origem
		, @ValorPagoTotal = ValorPagoTotal
		FROM tblAReceber
		WHERE IDAReceber = @IDAReceber;

		-- Atualiza a tblAReceber
		UPDATE tblAReceber SET
		ValorPagoTotal = ValorPagoTotal - @TotalPago
		,SituacaoAReceber = 0
		WHERE IDAReceber = @IDAReceber;

		--===================================================================================
		-- BLOQUEIA a TRANSAÇÃO se ha PARCELAS quitadas
		--===================================================================================
		IF @Origem = 1 AND @ValorPagoTotal - @TotalPago = 0
			UPDATE tblTransacao SET
			IDSituacao = 2 -- situacao FINALIZADA
			WHERE IDTransacao = @IDOrigem

		--===================================================================================
		-- FINALIZA E RETORNA
		--===================================================================================
		COMMIT TRAN;
		
		--- Retorna o registro de parcela alterado
		SELECT * FROM qryAReceberParcela WHERE IDAReceberParcela = @IDAReceberParcela

		END TRY
	BEGIN CATCH
		ROLLBACK TRAN;
		SELECT ERROR_MESSAGE() AS RETORNO;
	END CATCH
END