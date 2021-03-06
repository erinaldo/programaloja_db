--

-- =============================================================
-- Author:			Daniel
-- Create date:		14/01/2018
-- Alteracao Data:	21/12/2018
-- Description:		Estornar Quitação de APagar
-- =============================================================

ALTER PROCEDURE [dbo].[uspAPagar_Estornar]
@IDAPagar INT
,@IDMovimentacao INT

AS
BEGIN
	BEGIN TRAN
		BEGIN TRY

		DECLARE @IDCaixa INT;
		DECLARE @ValorEstornado MONEY;
		DECLARE @Desconto MONEY = 0;
		DECLARE @Acrescimo MONEY = 0;
		DECLARE @NovoAcrescimo MONEY = 0;
		DECLARE @ValorAPagar MONEY = 0;
		DECLARE @ValorPago MONEY = 0;
		DECLARE @NovoValorPago MONEY = 0;
		DECLARE @Origem INT;
		DECLARE @IDOrigem INT;

		/*===================================================================================
		GET VALOR DA SAIDA; VERIFICA CAIXA NULL; EXCLUI A SAIDA
		===================================================================================*/
		-- GET VALOR DA SAIDA
		SELECT @IDCaixa = IDCaixa, @ValorEstornado = MovValor 
		FROM qryMovimentacao 
		WHERE IDMovimentacao = @IDMovimentacao

		-- VERIFICA CAIXA NULL
		IF @IDCaixa IS NOT NULL
			RAISERROR('Esse APagar NÃO PODE ser Estornado, pois possui um caixa associado...', 14, 1)
		ELSE
			-- EXCLUI A MOVIMENTACAO
			DELETE tblCaixaMovimentacao WHERE IDMovimentacao = @IDMovimentacao

			-- EXCLUI A OBSERVACAO DA MOVIMENTACAO
			DELETE tblObservacao WHERE Origem = 3 AND IDOrigem = @IDMovimentacao

		--===================================================================================
		-- VERIFICA APAGAR; ATUALIZA tblAPagar
		--===================================================================================
		-- VERIFICA o ACRESCIMO E O DESCONTO PAGOS
		SELECT @ValorAPagar = APagarValor
		, @Acrescimo = Acrescimo
		, @Desconto = Desconto
		, @ValorPago = ValorPago
		, @Origem = Origem
		, @IDOrigem = IDOrigem
		FROM tblAPagar WHERE IDAPagar = @IDAPagar;

		IF @ValorEstornado >= @Acrescimo -- TENTA ESTORNAR DA DIFERENCA DO ACRESCIMO
			BEGIN
				SET @NovoValorPago = @ValorPago - @ValorEstornado + @Acrescimo
				SET @NovoAcrescimo = 0
			END
		ELSE
			BEGIN
				SET @NovoAcrescimo = @Acrescimo - @ValorEstornado
				SET @NovoValorPago = @ValorPago
			END

		-- Atualiza a tblAPagar
		UPDATE tblAPagar SET
		ValorPago = @NovoValorPago
		,Acrescimo = @NovoAcrescimo
		,Situacao = 0 --EmAberto
		,PagamentoData = NULL
		WHERE IDAPagar = @IDAPagar;

		--===================================================================================
		-- DESBLOQUEIA a TRANSAÇÃO OU A DESPESA se há PAGAMENTOS feitos
		--===================================================================================
		IF @NovoValorPago = 0 AND @Desconto = 0 
		BEGIN
			IF @Origem = 1 -- Desbloqueia a Transacao de Compra
				UPDATE tblTransacao SET
				IDSituacao = 2 -- situacao FINALIZADA
				WHERE IDTransacao = @IDOrigem
			ELSE IF @Origem = 2 -- Desbloqueia a Despesa
				UPDATE tblDespesa SET
				Bloqueada = 'FALSE' -- situacao FINALIZADA
				WHERE IDDespesa = @IDOrigem
		END

		--===================================================================================
		-- FINALIZA E RETORNA
		--===================================================================================
		COMMIT TRAN;
		
		--- Retorna o registro de parcela alterado
		SELECT * FROM qryAPagar WHERE IDAPagar = @IDAPagar

		END TRY

	BEGIN CATCH
		ROLLBACK TRAN;
		SELECT ERROR_MESSAGE() AS RETORNO;
	END CATCH
END