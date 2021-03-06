-- ==========================================================
-- Author:		Daniel Ramos de Oliveira
-- Create date: 08/02/2018
-- Alter date:  18/12/2018
-- Description:	Exclui Nivelamento do Caixa pelo IDCaixa
-- ==========================================================
ALTER PROCEDURE [dbo].[uspCaixa_ExcluirNivelamentos] 
	-- Add the parameters for the stored procedure here
	@IDCaixa INT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRAN
		BEGIN TRY
			-- DECLARACAO VARIAVEIS
			-----------------------------------------------------------------------------
			DECLARE @IDMov INT
			DECLARE @IDCredito INT
			DECLARE @CreditoTipo TINYINT

			DECLARE Item_Cursor CURSOR FOR
				-- SELECIONA TODAS AS MOVIMENTACOES DE ORIGEM CREDITO (tblCreditos)
				SELECT
				ES.IDMovimentacao AS ID
				,ES.IDOrigem
				FROM qryMovimentacao AS ES
				JOIN tblCaixaMovForma AS F
				ON F.IDMovForma = ES.IDMovForma
				WHERE IDCaixa = @IDCaixa AND Origem = 3 -- origem CREDITO
				ORDER BY MovData
			
			OPEN Item_Cursor

			-- SELECIONA O PRIMEIRO REGISTRO DO CURSOR
			FETCH NEXT FROM Item_Cursor INTO
			@IDMov, @IDCredito
			
			-- NAVEGA ENTRE TODOS OS REGISTROS DO CURSOR
			WHILE @@FETCH_STATUS = 0
			BEGIN
				SELECT @CreditoTipo = IDCreditoTipo FROM tblCaixaCreditos WHERE IDCredito = @IDCredito
				
				-- SE O TIPO DE CREDITO FOR NIVELAMENTO ENTAO
				IF @CreditoTipo = 1 -- NIVELAMENTO
				BEGIN
					-- SE FOR ENTRADA EXCLUI O REGISTRO
					DELETE tblCaixaMovimentacao WHERE IDMovimentacao = @IDMov
				
					-- EXCLUI O REGISTRO DE CREDITO
					DELETE tblCaixaCreditos WHERE IDCredito = @IDCredito
				END
								
				-- NAVEGA PARA O PROXIMO REGISTRO
				FETCH NEXT FROM Item_Cursor INTO
				@IDMov, @IDCredito

			END
	
		COMMIT TRAN

		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
			SELECT ERROR_MESSAGE() AS RETORNO
		END CATCH



	--

END
