--

-- =============================================
-- Author:		Daniel
-- Create date: 21/02/2018
-- Alter date:  21/12/2018
-- Description:	Desbloqueia o Caixa e a Conta
-- =============================================

ALTER PROCEDURE [dbo].[uspCaixa_Desbloquear] 
	-- Add the parameters for the stored procedure here
	@IDCaixa INT
AS
BEGIN

	BEGIN TRAN
		BEGIN TRY

			-- SET NOCOUNT ON added to prevent extra result sets from
			-- interfering with SELECT statements.
			SET NOCOUNT ON;

			-- ================================================================
			-- DELETE TODOS OS SALDOS DO CAIXA ATUAL
			-- ================================================================
			DELETE FROM tblCaixaSaldo WHERE IDCaixa = @IDCaixa

			-- ================================================================
			-- GET IDCONTA DO CAIXA
			-- ================================================================
			DECLARE @IDConta AS TINYINT = NULL

			SELECT
			@IDConta = IDConta
			FROM tblCaixa
			WHERE IDCaixa = @IDCaixa
			
			-- ================================================================
			-- GET DATA FINAL DO CAIXA ANTERIOR DA MESMA CONTA
			-- ================================================================
			DECLARE @DtFinal SMALLDATETIME = NULL

			SELECT TOP 1 @DtFinal = DataFinal FROM tblCaixa
			WHERE IDConta = @IDConta AND IDCaixa != @IDCaixa
			ORDER BY IDCaixa DESC

			-- ================================================================
			-- DESBLOQUEIA A CONTA
			-- ================================================================
			IF @DtFinal IS NOT NULL
				UPDATE tblCaixaContas SET BloqueioData = @DtFinal WHERE IDConta = @IDConta
			ELSE
				UPDATE tblCaixaContas SET BloqueioData = NULL WHERE IDConta = @IDConta
			
			-- ================================================================
			-- SALVA E DESBLOQUEIA O tblCaixa
			-- ================================================================
			UPDATE tblCaixa 
			SET 
			IDSituacao = 1 -- DESBLOQUEADO
			, FechamentoData = NULL
			, SaldoAnterior = NULL
			, SaldoFinal = 0
			WHERE IDCaixa = @IDCaixa

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
