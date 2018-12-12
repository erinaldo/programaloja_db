USE [NovaSiao]
GO


--

-- =============================================
-- Author:		Daniel
-- Create date: 11/04/2017
-- Alter date:	06/12/2018
-- Description:	Inserir Nova Venda
-- =============================================

--
ALTER PROCEDURE [dbo].[uspVenda_Inserir] 
	--
	-- PARAMETROS TBLTRANSACAO
	-- =============================================================================================
	@IDPessoaDestino AS INT
	,@IDPessoaOrigem AS INT
	,@IDOperacao AS TINYINT = 1 -- OPERACAO DE VENDA
	,@IDSituacao AS TINYINT = 1 -- SITUACAO INICIADA
	,@IDUser AS INT
	,@CFOP AS SMALLINT
	,@TransacaoData AS DATE
	--
	-- PARAMETROS TBLVENDA
	-- =============================================================================================
	,@IDDepartamento AS SMALLINT = 1
	,@IDVendedor AS INT 
	,@CobrancaTipo AS TINYINT
	,@JurosMes AS DECIMAL(6,2)
	,@IDVendaTipo AS TINYINT = 1 --1|VAREJO ; 2|ATACADO; 3|E-COMMERC
	,@ValorProdutos AS MONEY
	,@ValorFrete AS MONEY -- Frete INCLUIDO no Valor Total da Venda
	,@ValorImpostos AS MONEY -- Valor dos Impostos a ser cobrados
	,@ValorAcrescimos AS MONEY -- Valor dos outros acrescimos
	--
	-- PARAMETROS DA TBLARECEBER
	-- =============================================================================================
	,@IDPlano SMALLINT = NULL
	--
	-- PARAMETROS DA TBLOBSERVACAO
	-- =============================================================================================
	,@Observacao AS VARCHAR(max) = null 
	--
	-- PARAMETROS DA TBLVENDAFRETE
	-- =============================================================================================
	,@IDTransportadora AS INT = NULL
	,@FreteValor AS MONEY = 0
	,@FreteTipo AS TINYINT = 0 -- 1|EMITENTE; 2|DESTINATARIO
	,@Volumes AS SMALLINT = 1
	,@IDAPagar AS INT = NULL
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
			,@IDOperacao
			,@IDSituacao
			,@IDUser
			,@CFOP
			,@TransacaoData)
			-- Recebe o IDTransacao
			SET @IDTransacao = @@IDENTITY

			-- ===================================================
			-- INSERIR NA tblVenda
			-- ===================================================
			INSERT INTO tblVenda
			(IDVenda
			,IDDepartamento
			,IDVendedor
			,CobrancaTipo
			,TotalVenda
			,JurosMes
			,IDVendaTipo
			,AgregaDevolucao
			,ValorProdutos
			,ValorFrete
			,ValorImpostos
			,ValorAcrescimos
			,ValorDevolucao)
			VALUES
			(@IDTransacao
			,@IDDepartamento
			,@IDVendedor
			,@CobrancaTipo
			,0
			,@JurosMes
			,@IDVendaTipo
			,'FALSE'
			,@ValorProdutos
			,@ValorFrete
			,@ValorImpostos
			,@ValorAcrescimos
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
			(1
			,@IDTransacao
			,@IDPessoaOrigem
			,@IDPessoaDestino
			,0 ,0 ,0
			,NULL
			,NULL)

			-- ===================================================
			-- INSERIR NA tblFrete (caso necessidade)
			-- ===================================================
			IF @FreteTipo <> 0
			INSERT INTO tblFrete
			(IDTransacao
			,IDTransportadora
			,FreteTipo -- 1|EMITENTE; 2|DESTINATARIO
			,FreteValor
			,Volumes
			,IDAPagar)
			VALUES 
			(@IDTransacao
			,@IDTransportadora
			,@FreteTipo
			,@FreteValor
			,@Volumes
			,@IDAPagar) 

			-- ===================================================
			-- INSERIR NA tblObservacao (caso necessidade)
			-- ===================================================
			DELETE tblObservacao
			WHERE Origem = 9 AND IDOrigem = @IDTransacao

			IF @Observacao IS NOT NULL AND LEN(@Observacao) > 0
				INSERT INTO tblObservacao
				(Origem
				,IDOrigem
				,Observacao)
				VALUES
				(9
				,@IDTransacao
				,@Observacao)

			-- ===================================================
			-- CONCLUSAO
			-- ===================================================
			COMMIT TRANSACTION
			SELECT * FROM qryVenda WHERE IDVenda = @IDTransacao
			--
		END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SELECT ERROR_MESSAGE()
	END CATCH	
END