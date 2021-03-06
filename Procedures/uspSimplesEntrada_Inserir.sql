USE [NovaSiao]
GO
/****** Object:  StoredProcedure [dbo].[uspSimplesEntrada_Inserir]    Script Date: 30/11/2018 09:49:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--

-- =============================================
-- Author:		Daniel
-- Create date: 21/11/2018
-- Alter date:	30/11/2018
-- Description:	Inserir Simples Entrada
-- =============================================

--
ALTER PROCEDURE [dbo].[uspSimplesEntrada_Inserir] 
	--
	-- PARAMETROS TBLTRANSACAO
	-- =============================================================================================
	@IDPessoaDestino AS INT
	,@IDPessoaOrigem AS INT
	-- ,@IDOperacao AS TINYINT = 3 -- OPERACAO DE SIMPLES ENTRADA
	-- ,@IDSituacao AS TINYINT = 3 -- SITUACAO BLOQUEADA
	,@IDUser AS INT
	-- ,@CFOP AS SMALLINT -- 1152
	,@TransacaoData AS DATE
	--
	-- PARAMETROS TBLSIMPLESENTRADA
	-- =============================================================================================
	,@IDTransacaoOrigem AS INT
	,@EntradaData AS DATE
	,@ValorTotal AS MONEY
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
			,3
			,3
			,@IDUser
			,1152
			,@TransacaoData)
			-- Recebe o IDTransacao
			SET @IDTransacao = @@IDENTITY

			-- ===================================================
			-- INSERIR NA tblSimplesEntrada
			-- ===================================================
			INSERT INTO tblSimplesEntrada
			(IDSimples
			,IDTransacaoOrigem
			,ValorTotal
			,EntradaData)
			VALUES
			(@IDTransacao
			,@IDTransacaoOrigem
			,@ValorTotal
			,@EntradaData)

			-- ===================================================
			-- CONCLUSAO
			-- ===================================================
			COMMIT TRANSACTION
			SELECT * FROM qrySimplesEntrada WHERE IDTransacao = @IDTransacao
			--
		END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SELECT ERROR_MESSAGE()
	END CATCH	
END