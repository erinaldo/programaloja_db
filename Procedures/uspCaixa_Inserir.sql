--

-- =============================================
-- Author:		Daniel
-- Create date: 22/01/2018
-- Alter Date:  02/02/2019
-- Description:	Inserir Novo Caixa
-- =============================================

--
ALTER PROCEDURE [dbo].[uspCaixa_Inserir]
	--
	-- PARAMETROS TBLCAIXA
	-- =============================================================================================
	@IDFilial AS INT
	,@IDConta AS TINYINT
	,@FechamentoData AS DATE
	,@IDSituacao AS TINYINT
	,@DataInicial AS SMALLDATETIME
	,@DataFinal AS SMALLDATETIME
	,@SaldoFinal AS MONEY
	,@SaldoAnterior AS MONEY = 0
	,@Observacao VARCHAR(MAX)
	,@CaixaFinalDia BIT
	,@IDFuncionario INT = NULL
	--
AS
BEGIN
	BEGIN TRANSACTION t
		BEGIN TRY
			DECLARE @IDCaixa INT;

			-- ===================================================
			-- INSERIR NA TBLCAIXA
			-- ===================================================
			INSERT INTO tblCaixa
			(IDFilial
			,IDConta
			,FechamentoData
			,IDSituacao
			,DataInicial
			,DataFinal
			,SaldoFinal
			,SaldoAnterior
			,CaixaFinalDia
			,IDFuncionario)
			VALUES
			(@IDFilial
			,@IDConta
			,@FechamentoData
			,@IDSituacao
			,@DataInicial
			,@DataFinal
			,@SaldoFinal
			,@SaldoAnterior
			,@CaixaFinalDia
			,@IDFuncionario)

			-- Recebe o IDTransacao
			SET @IDCaixa = @@IDENTITY

			-- ===================================================
			-- INSERIR NA TBLOBSERVACAO
			-- ===================================================
			IF LEN(@Observacao) > 0 
		 	INSERT INTO tblObservacao
			(IDOrigem
			,Origem
			,Observacao)
			VALUES
			(@IDCaixa
			,5 -- origem TBLSAIDA
			,@Observacao);
			
			-- ===================================================
			-- CONCLUSAO
			-- ===================================================
			COMMIT TRANSACTION
			SELECT * FROM qryCaixa WHERE IDCaixa = @IDCaixa
			--
		END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SELECT ERROR_MESSAGE()
	END CATCH	
END