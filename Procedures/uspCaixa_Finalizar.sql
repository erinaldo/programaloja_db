--

-- =============================================
-- Author:		Daniel
-- Create date: 19/02/2018
-- Alter date:	08/02/2019
-- Description:	Finaliza o Caixa
-- =============================================

--
ALTER PROCEDURE [dbo].[uspCaixa_Finalizar] 
	-- Add the parameters for the stored procedure here
	@IDCaixa INT
	,@CaixaFinalDia BIT
	,@IDFuncionario INT = NULL
	,@Observacao VARCHAR(MAX) = NULL
AS
BEGIN

	BEGIN TRAN
		BEGIN TRY

			-- SET NOCOUNT ON added to prevent extra result sets from
			-- interfering with SELECT statements.
			SET NOCOUNT ON;

			-- ================================================================
			-- OBTEM O SALDO ANTERIOR E SALVA O SALDO ATUAL
			-- ================================================================

			-- DELETE TODOS OS SALDOS DO CAIXA ATUAL
			DELETE FROM tblCaixaSaldo WHERE IDCaixa = @IDCaixa

			-- GET SALDO ANTERIOR DA MESMA CONTA
			-- ================================================================
			DECLARE @IDConta AS TINYINT = NULL
			DECLARE @IDCaixaAnterior INT
			DECLARE @DataFinal DATE -- data do fechamento do caixa para bloqueio da conta

			-- GET IDConta do Caixa Atual
			SELECT
			@IDConta = IDConta
			, @DataFinal = DataFinal
			FROM tblCaixa
			WHERE IDCaixa = @IDCaixa

			-- GET IDCaixaAnterior
			SELECT TOP 1 @IDCaixaAnterior = IDCaixa FROM tblCaixa
			WHERE IDConta = @IDConta AND IDCaixa != @IDCaixa
			ORDER BY IDCaixa DESC

			-- CURSOR SALDO ANTERIOR TO GET SALDO ANTERIOR
			DECLARE @IDMeio TINYINT
			DECLARE @SaldoItem MONEY = 0
			DECLARE @SaldoAnterior MONEY = 0 -- SOMATORIO DOS SALDOS DOS ITENS
			DECLARE @SaldoAtual MONEY = 0

			DECLARE Item_Cursor CURSOR FOR
				SELECT
				C.IDMeio
				, C.SaldoFinal 
				FROM tblCaixaSaldo AS C
				WHERE IDCaixa = @IDCaixaAnterior
			OPEN Item_Cursor
	
			-- SELECIONA O PRIMEIRO REGISTRO DO CURSOR
			FETCH NEXT FROM Item_Cursor INTO
			@IDMeio, @SaldoItem
			
			-- NAVEGA ENTRE TODOS OS REGISTROS DO CURSOR
			WHILE @@FETCH_STATUS = 0
			BEGIN
		
				INSERT INTO tblCaixaSaldo
				(IDCaixa, IDMeio, IDConta, SaldoFinal)
				VALUES
				(@IDCaixa, @IDMeio, @IDConta, @SaldoItem)
				
				-- CALCULA O SALDO ANTERIOR
				SET @SaldoAnterior = @SaldoAnterior + @SaldoItem

				-- NAVEGA PARA O PROXIMO REGISTRO
				FETCH NEXT FROM Item_Cursor INTO
				@IDMeio, @SaldoItem
			END

			-- FECHA O CURSOR
			CLOSE Item_Cursor
			DEALLOCATE Item_Cursor

			-- VERIFICA AS MOVIMENTACOES DO CAIXA
			-- ================================================================
			DECLARE ItemCursor_Movs CURSOR FOR
			SELECT 
			T.IDMeio
			,SUM(T.MovValor) AS Total
			FROM tblCaixaMovimentacao AS T
			WHERE IDCaixa = @IDCaixa
			GROUP BY T.IDMeio
	
			OPEN ItemCursor_Movs

			SET @SaldoAtual = @SaldoAnterior

			-- SELECIONA O PRIMEIRO REGISTRO DO CURSOR
			FETCH NEXT FROM ItemCursor_Movs INTO
			@IDMeio, @SaldoItem
	
			-- NAVEGA ENTRE TODOS OS REGISTROS DO CURSOR
			WHILE @@FETCH_STATUS = 0
			BEGIN
				-- VERIFICA SE EXISTE O REGISTRO
				IF EXISTS (SELECT * FROM tblCaixaSaldo 
							WHERE IDCaixa = @IDCaixa 
							AND IDMeio = @IDMeio)

					-- ADICIONA O SALDO
					UPDATE tblCaixaSaldo SET
					SaldoFinal = SaldoFinal + @SaldoItem
					WHERE IDCaixa = @IDCaixa 
					AND IDMeio = @IDMeio

				ELSE -- INSERE O SALDO
					INSERT INTO tblCaixaSaldo
					(IDCaixa, IDMeio, IDConta,SaldoFinal)
					VALUES
					(@IDCaixa, @IDMeio, @IDConta, @SaldoItem)

				-- CALCULA O SALDO ATUAL
				SET @SaldoAtual = @SaldoAtual + @SaldoItem

				-- NAVEGA PARA O PROXIMO REGISTRO
				FETCH NEXT FROM ItemCursor_Movs INTO
				@IDMeio, @SaldoItem
			END

			-- FECHA O CURSOR
			CLOSE ItemCursor_Movs
			DEALLOCATE ItemCursor_Movs

			-- ================================================================
			-- SALVA E BLOQUEIA O tblCaixa
			-- ================================================================
			DECLARE @FechamentoData AS DATE = GETDATE()

			UPDATE tblCaixa 
			SET 
			IDSituacao = 2
			, FechamentoData = @FechamentoData
			, SaldoAnterior = @SaldoAnterior
			, SaldoFinal = @SaldoAtual
			, CaixaFinalDia = @CaixaFinalDia
			, IDFuncionario = @IDFuncionario
			WHERE IDCaixa = @IDCaixa

			-- SALVA A OBSERVACAO
			DELETE tblObservacao WHERE IDOrigem = @IDCaixa AND Origem = 5

			IF LEN(@Observacao) > 0 
				INSERT INTO tblObservacao
				(IDOrigem
				,Origem
				,Observacao)
				VALUES
				(@IDCaixa
				,5 -- origem TBLCAIXA
				,@Observacao);
			
			-- ================================================================
			-- BLOQUEIA A CONTA
			-- ================================================================
			
			-- VERIFY BLOQUEIODATA WITH @CAIXAFINALDIA
			IF @CaixaFinalDia = 1
				SELECT @DataFinal = DATEADD(day,1,@DataFinal)

			UPDATE tblCaixaContas 
			SET BloqueioData = @DataFinal, 
			SaldoAtual = @SaldoAtual, 
			LastIDCaixa = @IDCaixa
			WHERE IDConta = @IDConta

			--===================================================================================
			-- FINALIZA
			--===================================================================================
			COMMIT TRAN;
			
			-- RETORNO
			SELECT @IDCaixa AS RETORNO

			END TRY
			
		BEGIN CATCH
			ROLLBACK TRAN;
			SELECT ERROR_MESSAGE() AS RETORNO;
		END CATCH
END
