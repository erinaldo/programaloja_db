USE [NovaSiao]
GO


--

-- =============================================
-- Author:		Daniel
-- Create date: 12/11/2018
-- Alter date:	06/12/2018
-- Description:	Inserir Simples Saida
-- =============================================

--
ALTER PROCEDURE [dbo].[uspSimplesSaida_Inserir] 
	--
	-- PARAMETROS TBLTRANSACAO
	-- =============================================================================================
	@IDPessoaDestino AS INT
	,@IDPessoaOrigem AS INT
	-- ,@IDOperacao AS TINYINT = 4 -- OPERACAO DE SIMPLES SAIDA
	-- ,@IDSituacao AS TINYINT = 1 -- SITUACAO INICIADA
	,@IDUser AS INT
	-- ,@CFOP AS SMALLINT -- 5152
	,@TransacaoData AS DATE
	--

AS
BEGIN
	BEGIN TRANSACTION t
		BEGIN TRY
			DECLARE @IDTransacao INT;

			-- ===================================================
			-- INSERIR NA TBLTRANSACAO
			-- ===================================================
			INSERT INTO tblTransacao
			(IDPessoaDestino
			,IDPessoaOrigem
			,IDOperacao
			,IDSituacao
			,IDUser
			,CFOP
			,TransacaoData)
			VALUES
			(@IDPessoaDestino
			,@IDPessoaOrigem
			,4
			,1
			,@IDUser
			,5152
			,@TransacaoData)
			-- Recebe o IDTransacao
			SET @IDTransacao = @@IDENTITY

			-- ===================================================
			-- INSERIR NA tblSimplesSaida
			-- ===================================================
			INSERT INTO tblSimplesSaida
			(IDSimples
			,ValorTotal)
			VALUES
			(@IDTransacao
			,0)

			-- ===================================================		
			-- INSERIR NA tblAReceber
			-- ===================================================
			INSERT INTO tblAReceber
			(Origem
			,IDOrigem
			,IDFilial
			,IDPessoa
			,AReceberValor
			,ValorPagoTotal
			,SituacaoAReceber
			,IDCobrancaForma
			,IDPlano)
			VALUES
			(3
			,@IDTransacao
			,@IDPessoaOrigem
			,@IDPessoaDestino
			,0 ,0 ,0
			,NULL
			,NULL)

			-- ===================================================
			-- CONCLUSAO
			-- ===================================================
			COMMIT TRANSACTION
			SELECT * FROM qrySimplesSaida WHERE IDTransacao = @IDTransacao
			--
		END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SELECT ERROR_MESSAGE()
	END CATCH	
END