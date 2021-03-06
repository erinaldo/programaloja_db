--

-- =====================================================
-- Author:		Daniel
-- Create date: 22/02/2018
-- Alter date:  21/12/2018
-- Description:	Exclui o Caixa e desbloqueia a Conta
-- =====================================================

ALTER PROCEDURE [dbo].[uspCaixa_Excluir] 
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
			-- LIMPA TODOS ENTRADAS E SAIDAS LIGADAS AO CAIXA
			-- ================================================================
			-- LIMPA MOVS
			UPDATE tblCaixaMovimentacao SET
			IDCaixa = NULL
			WHERE IDCaixa = @IDCaixa
			
			-- ================================================================
			-- EXCLUI TODOS OS SALDOS ANTERIORES LIGADOS AO CAIXA
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
			-- GET SALDO ANTERIOR DA MESMA CONTA CAIXA ANTERIOR
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
			-- EXCLUI O tblCaixa
			-- ================================================================
			DELETE tblCaixa 
			WHERE IDCaixa = @IDCaixa
			
			--===================================================================================
			-- FINALIZA
			--===================================================================================
			COMMIT TRAN;
			
			-- RETORNO
			SELECT 'TRUE' AS RETORNO

			END TRY
			
		BEGIN CATCH
			ROLLBACK TRAN;
			SELECT ERROR_MESSAGE() AS RETORNO;
		END CATCH
END
