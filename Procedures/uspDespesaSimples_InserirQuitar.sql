--

-- =============================================================
-- Author:		Daniel
-- Create date: 15/02/2018
-- Alter date:	03/02/2019
-- Description:	Inserir Novo Registro de Despesa Simples
-- =============================================================

ALTER PROCEDURE [dbo].[uspDespesaSimples_InserirQuitar]
	@IDCredor INTEGER
	,@IDFilial INTEGER
	,@IDDespesaTipo INTEGER
	,@Descricao VARCHAR(100)
	,@DespesaData DATE
	,@DespesaValor MONEY
	,@IDCobrancaForma SMALLINT
	,@Identificador VARCHAR(30)
	,@RGBanco SMALLINT = NULL
	,@Acrescimo MONEY = 0
	,@IDConta TINYINT
	,@Observacao VARCHAR(MAX) = NULL
	,@IDCaixa INT = NULL
AS
BEGIN
	BEGIN TRAN
		BEGIN TRY
			DECLARE @IDDespesa INT
			DECLARE @IDAPagar INT
			DECLARE @IDSaida INT
			DECLARE @Cadastro VARCHAR(50)

			-- =============================================================
			-- INSERE NA TBLDESPESA
			-- =============================================================
			INSERT INTO tblDespesa
			(IDCredor
			,IDFilial
			,IDDespesaTipo
			,Descricao
			,DespesaData
			,DespesaValor
			,Parcelado
			,Bloqueada
			,ValorPagoTotal)
			VALUES
			(@IDCredor
			,@IDFilial
			,@IDDespesaTipo
			,@Descricao
			,@DespesaData
			,@DespesaValor
			,'FALSE'
			,'TRUE'
			,@DespesaValor);

			-- Retorna com o IDDespesa		
			SET @IDDespesa = @@IDENTITY;

			-- =============================================================
			-- INSERE NA TBLAPAGAR
			-- =============================================================
			INSERT INTO tblAPagar
			(Origem
			,IDOrigem
			,IDPessoa
			,IDFilial
			,IDCobrancaForma
			,Identificador
			,RGBanco
			,Vencimento
			,APagarValor
			,ValorPago
			,Situacao
			,PagamentoData
			,Desconto
			,Acrescimo)
			VALUES
			(2 -- ORIGEM DESPESA
			,@IDDespesa
			,@IDCredor
			,@IDFilial
			,@IDCobrancaForma
			,@Identificador
			,@RGBanco
			,@DespesaData
			,@DespesaValor
			,@DespesaValor
			,1
			,@DespesaData
			,0
			,@Acrescimo); -- situacao QUITADA|PAGA

			-- Retorna com o IDAPagar	
			SET @IDAPagar = @@IDENTITY;

			--===================================================================================
			-- INSERE no tblSAIDA e no tblObservacao
			--===================================================================================

			-- OBTER O CADASTRO PELO IDPESSOA
			SELECT @Cadastro = Cadastro 
			FROM tblPessoa
			WHERE IDPessoa = @IDCredor
						
			DECLARE @DescSaida VARCHAR(100) = 'PAG-' + dbo.id0000(@IDAPagar) + ' - ' + @Cadastro
		
			INSERT INTO tblCaixaMovimentacao
			(Origem
			,IDOrigem
			,IDConta
			,IDMovForma
			,MovData
			,MovValor
			,Creditar
			,Descricao
			,IDCaixa
			,Movimento)
			VALUES
			(10 -- ORIGEM TBL APAGAR
			,@IDAPagar
			,@IDConta
			,1 -- FORMA DINHEIRO
			,@DespesaData
			,@DespesaValor + @Acrescimo
			,'FALSE'
			,@DescSaida
			,@IDCaixa
			,2) -- movimento de DEBITO
		
			SET @IDSaida = @@IDENTITY
			
			---INSERE NA TBLOBSERVACAO
			IF LEN(@Observacao) > 0 
				INSERT INTO tblObservacao
				(IDOrigem
				,Origem
				,Observacao)
				VALUES
				(@IDSaida
				,3 -- origem TBLMOVIMENTACAO
				,@Observacao);
		
		
			-- RETORNA O NOVO RESULTADO INSERIDO
			-----------------------------------------------------------------------------
			SELECT
			ES.IDMovimentacao AS ID
			,ES.Origem
			,ES.IDOrigem
			,ES.MovData
			,ES.MovValor
			,ES.IDConta
			,ES.IDCaixa
			,ES.Descricao
			,ES.IDMovForma
			,F.IDMovForma
			,F.MovForma
			,ES.Mov
			FROM qryMovimentacao AS ES
			JOIN tblCaixaMovForma AS F
			ON F.IDMovForma = ES.IDMovForma
			WHERE Origem = 10 AND IDOrigem = @IDAPagar
	
	COMMIT TRAN;
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() AS RETORNO; 
	END CATCH
END