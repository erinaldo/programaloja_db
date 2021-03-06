USE [NovaSiao]
GO
/****** Object:  StoredProcedure [dbo].[uspSimplesSaida_Alterar]    Script Date: 06/12/2018 16:38:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--

-- =============================================
-- Author:		Daniel
-- Create date: 12/11/2018
-- Alter date:	06/12/2018
-- Description:	Alterar Simples Saida
-- =============================================

--
ALTER PROCEDURE [dbo].[uspSimplesSaida_Alterar] 
	--
	-- PARAMETROS TBLTRANSACAO
	@IDTransacao AS INTEGER
	,@IDPessoaDestino AS INT
	,@IDPessoaOrigem AS INT
	-- ,@IDOperacao AS TINYINT = 4 -- OPERACAO DE VENDA
	,@IDSituacao AS TINYINT
	,@IDUser AS INT
	-- ,@CFOP AS SMALLINT
	,@TransacaoData AS DATE
	--
	-- PARAMETROS TBLSIMPLESSAIDA
	-- ,@EntradaSaida AS BIT = FALSE
	,@ValorTotal AS MONEY
	,@ArquivoGerado AS BIT
	,@ArquivoRecebido AS BIT
	--
	-- PARAMETROS DA TBLOBSERVACAO
	,@Observacao AS VARCHAR(max) = null 
	--
	-- PARAMETROS DA TBLARECEBER
	-- ,@IDCobrancaForma AS SMALLINT = 1
	,@IDPlano SMALLINT = NULL
	--
AS
BEGIN
	BEGIN TRANSACTION t
		BEGIN TRY
		--======================================================================
		-- ALTERAR A TBLTRANSACAO
		--======================================================================
		UPDATE tblTransacao SET
		IDPessoaDestino= @IDPessoaDestino
		,IDPessoaOrigem = @IDPessoaOrigem
		,IDOperacao = 1 -- OPERACAO DE VENDA
		,IDSituacao = @IDSituacao
		,IDUser = @IDUser
		,TransacaoData = @TransacaoData
		WHERE
		IDTransacao = @IDTransacao

		--======================================================================
		-- ALTERAR A tblSimples
		--======================================================================
		UPDATE tblSimplesSaida SET
		ValorTotal = @ValorTotal
		,ArquivoGerado = @ArquivoGerado
		,ArquivoRecebido = @ArquivoRecebido
		WHERE
		IDSimples = @IDTransacao

		--======================================================================
		-- ALTERAR A tblAReceber (Verifica se nao existe entao cria)
		--======================================================================
		IF EXISTS(SELECT * FROM tblAReceber WHERE IDOrigem = @IDTransacao AND Origem = 3)
			UPDATE tblAReceber SET
			IDPessoa = @IDPessoaDestino
			,AReceberValor = @ValorTotal
			,IDCobrancaForma = 1 -- EM CARTEIRA
			,IDPlano = @IDPlano
			WHERE
			IDOrigem = @IDTransacao AND Origem = 3 -- (tblSimples)
		ELSE
			INSERT INTO tblAReceber (
			IDOrigem, Origem, IDFilial, IDPessoa, AReceberValor, IDCobrancaForma, IDPlano) 
			VALUES (
			@IDTransacao, 3, @IDPessoaOrigem, @IDPessoaDestino, @ValorTotal, 1, @IDPlano)

		-- ===================================================
		-- ALTERAR NA tblObservacao
		-- ===================================================
		DELETE tblObservacao
		WHERE Origem = 10 AND IDOrigem = @IDTransacao

		IF @Observacao IS NOT NULL AND LEN(@Observacao) > 0
			INSERT INTO tblObservacao
			(Origem
			,IDOrigem
			,Observacao)
			VALUES
			(10
			,@IDTransacao
			,@Observacao)

		--======================================================================
		-- CONCLUSAO
		--======================================================================
		COMMIT TRANSACTION
		SELECT @IDTransacao
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SELECT ERROR_MESSAGE()
	END CATCH
END