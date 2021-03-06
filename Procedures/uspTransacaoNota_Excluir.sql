--

-- =============================================
-- Author:		Daniel
-- Create date: 06/10/2017
-- Alteracao:   25/12/2018
-- Description:	NOTA FISCAL EXCLUIR
-- =============================================

--
ALTER PROCEDURE [dbo].[uspTransacaoNota_Excluir]
@IDNota AS INTEGER = NULL
,@IDTransacao AS INTEGER = NULL

AS
BEGIN
	BEGIN TRY
		BEGIN TRAN
		IF @IDNota IS NULL AND @IDTransacao IS NULL
			RAISERROR('É necessário informar ID da Nota ou da Transação', 14, 1)

		IF @IDNota IS NOT NULL
			DELETE FROM tblTransacaoNotaFiscal
			WHERE IDNota = @IDNota
		ELSE
			DELETE FROM tblTransacaoNotaFiscal
			WHERE IDTransacao = @IDTransacao

		COMMIT TRAN;

		IF @IDNota IS NOT NULL
			SELECT @IDNota AS RETORNO
		ELSE
			SELECT @IDTransacao AS RETORNO

	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() AS Retorno;
	END CATCH
END