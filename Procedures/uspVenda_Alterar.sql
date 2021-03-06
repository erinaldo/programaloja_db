--

-- =============================================
-- Author:		Daniel
-- Create date: 11/04/2017
-- Alteracao:   24/12/2018
-- Description:	Alterar Venda
-- =============================================

ALTER PROCEDURE [dbo].[uspVenda_Alterar]
	--
	-- PARAMETROS TBLTRANSACAO
	@IDVenda AS INTEGER
	,@IDPessoaDestino AS INT
	,@IDPessoaOrigem AS INT
	,@IDOperacao AS TINYINT = 1 -- OPERACAO DE VENDA
	,@IDSituacao AS TINYINT
	,@IDUser AS INT
	,@CFOP AS SMALLINT
	,@TransacaoData AS DATE
	--
	-- PARAMETROS TBLVENDA
	,@IDDepartamento AS SMALLINT = 1
	,@IDVendedor AS INT 
	,@AgregaDevolucao AS BIT
	,@CobrancaTipo AS TINYINT
	,@ValorProdutos MONEY = 0
	,@ValorFrete MONEY = 0
	,@ValorImpostos MONEY = 0
	,@ValorAcrescimos MONEY = 0
	,@ValorDevolucao MONEY = 0
	,@TotalVenda MONEY = 0
	,@JurosMes AS DECIMAL(6,2)
	,@IDVendaTipo AS TINYINT --1|VAREJO ; 2|ATACADO; 3|E-COMMERC
	--
	-- PARAMETROS DA TBLOBSERVACAO
	,@Observacao AS VARCHAR(max) = null 
	--
	-- PARAMETROS DA TBLARECEBER
	,@IDCobrancaForma AS SMALLINT = NULL
	,@IDPlano SMALLINT = NULL
	--
	-- PARAMETROS DA TBLVENDAFRETE
	,@IDTransportadora AS INT = NULL
	,@FreteTipo AS TINYINT = 0 -- 1|EMITENTE; 2|DESTINATARIO
	,@FreteValor AS MONEY = 0
	,@Volumes AS SMALLINT = 1
	,@IDAPagar AS INT = NULL
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
		,CFOP =  @CFOP 
		,TransacaoData = @TransacaoData
		WHERE
		IDTransacao = @IDVenda

		--======================================================================
		-- ALTERAR A tblVenda
		--======================================================================
		UPDATE tblVenda SET
		IDDepartamento = @IDDepartamento
		,IDVendedor = @IDVendedor
		,CobrancaTipo = @CobrancaTipo
		,AgregaDevolucao = @AgregaDevolucao
		,TotalVenda = @TotalVenda
		,ValorProdutos = @ValorProdutos
		,ValorFrete = @ValorFrete
		,ValorImpostos = @ValorImpostos
		,ValorAcrescimos = @ValorAcrescimos
		,ValorDevolucao = @ValorDevolucao	
		,JurosMes = @JurosMes
		,IDVendaTipo = @IDVendaTipo --1|VAREJO ; 2|ATACADO; 3|ECOMMERC
		WHERE
		IDVenda = @IDVenda

		--======================================================================
		-- ALTERAR A tblAReceber
		--======================================================================
		UPDATE tblAReceber SET
		IDPessoa = @IDPessoaDestino
		,AReceberValor = @ValorProdutos + @ValorFrete + @ValorImpostos + @ValorAcrescimos - @ValorDevolucao
		,IDCobrancaForma =@IDCobrancaForma
		,IDPlano = @IDPlano
		WHERE
		IDOrigem = @IDVenda AND Origem = 1

		--======================================================================
		-- EXCLUIR e INSERIR NA tblFrete (caso necessidade)
		--======================================================================
		IF @IDAPagar IS NULL -- SOMENTE SE NAO HA APAGAR DO FRETE
		BEGIN
			-- EXCLUIR
			DELETE tblFrete WHERE IDTransacao = @IDVenda

			-- INSERIR
			IF @IDTransportadora IS NOT NULL
			BEGIN
				INSERT INTO tblFrete(
					IDTransacao
					,IDTransportadora
					,FreteTipo -- 1|EMITENTE; 2|DESTINATARIO
					,FreteValor
					,Volumes
					,IDAPagar)
				VALUES (
					@IDVenda
					,@IDTransportadora
					,@FreteTipo
					,@FreteValor
					,@Volumes
					,@IDAPagar) 
			END
		END

		-- ===================================================
		-- ALTERAR NA tblObservacao
		-- ===================================================
		DELETE tblObservacao
		WHERE Origem = 9 AND IDOrigem = @IDVenda

		IF @Observacao IS NOT NULL AND LEN(@Observacao) > 0
			INSERT INTO tblObservacao
			(Origem
			,IDOrigem
			,Observacao)
			VALUES
			(9
			,@IDVenda
			,@Observacao)

		--======================================================================
		-- CONCLUSAO
		--======================================================================
		COMMIT TRANSACTION
		SELECT @IDVenda
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SELECT ERROR_MESSAGE()
	END CATCH
END