--


-- =============================================
-- Author:		Daniel Ramos de Oliveira
-- Create date: 08/02/2018
-- Alter date:	04/02/2019
-- Description:	Gerar Nivelamento de Caixa
-- =============================================

--
ALTER PROCEDURE [dbo].[uspCaixa_InserirNivelamento] 
	-- Add the parameters for the stored procedure here
	@IDCaixa INT,
	@IDMeio TINYINT,
	@Valor MONEY
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRAN
		BEGIN TRY

			-- DECLARACAO VARIAVEIS
			-----------------------------------------------------------------------------
			DECLARE @Descricao VARCHAR(100)
			DECLARE @CreditoData DATE
			DECLARE @IDConta TINYINT
			DECLARE @IDFilial INT
			DECLARE @Meio VARCHAR(10) -- 1:Dinheiro | 2:Cheque | 3:Cartao
			DECLARE @Movimento AS TINYINT
			DECLARE @IDCredito INT -- novo IDCredito inserido
			DECLARE @IDMovimentacao AS INT -- novo IDMovimentacao inserido

			-- VERIFICACAO DOS VALORES
			-----------------------------------------------------------------------------
			SELECT @CreditoData = DataFinal 
			, @IDConta = IDConta
			, @IDFilial = IDFilial
			FROM tblCaixa 
			WHERE IDCaixa = @IDCaixa
			--
			IF @IDMeio = 1
				SET @Meio = 'Dinheiro/Moeda'
			ELSE IF @IDMeio = 2
				SET @Meio = 'Cheque'
			ELSE IF @IDMeio = 3
				SET @Meio = 'Cartão'
			--
			IF @Valor >= 0
				SET @Descricao = 'Nivelamento de Caixa POSITIVO (' + @Meio + ')'
			ELSE
				SET @Descricao = 'Nivelamento de Caixa NEGATIVO (' + @Meio + ')'

			-- INSERT NO TBLCREDITOS
			-----------------------------------------------------------------------------
			INSERT INTO tblCaixaCreditos
			(Descricao
			, CreditoValor
			, CreditoData
			, IDCreditoTipo
			, IDConta
			, IDFilial
			, Origem
			, IDOrigem)
			VALUES
			(@Descricao
			, @Valor
			, @CreditoData
			, 1
			, @IDConta
			, @IDFilial
			, 1 -- ORIGEM: TBLCAIXA
			, @IDCaixa);

			SET @IDCredito = @@IDENTITY;

			-- INSERT NO TBLENTRADA OU TBLSAIDA
			-----------------------------------------------------------------------------
			IF @Valor >= 0
				SET @Movimento = 1 -- entrada
			ELSE IF @Valor < 0
				SET @Movimento = 2 -- saida

			-- INSERE TBLMOVIMENTACAO
			INSERT INTO tblCaixaMovimentacao
				(Origem
				,IDOrigem
				,IDConta
				,MovData
				,MovValor
				,IDMeio
				,Creditar
				,Descricao
				,IDCaixa
				,Movimento)
			VALUES
				(3
				,@IDCredito
				,@IDConta
				,@CreditoData
				,@Valor
				,@IDMeio
				,'FALSE'
				,@Descricao
				,@IDCaixa
				,@Movimento);
			
			SET @IDMovimentacao = @@IDENTITY;

			SELECT * FROM qryMovimentacao WHERE IDMovimentacao = @IDMovimentacao
		
	COMMIT TRAN

	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() AS RETORNO
	END CATCH



	--

END
