USE [NovaSiao]
GO
/****** Object:  StoredProcedure [dbo].[uspCaixa_InserirNivelamento]    Script Date: 21/12/2018 20:51:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--


-- =============================================
-- Author:		Daniel Ramos de Oliveira
-- Create date: 08/02/2018
-- Alter date:	21/12/2018
-- Description:	Gerar Nivelamento de Caixa
-- =============================================

--
ALTER PROCEDURE [dbo].[uspCaixa_InserirNivelamento] 
	-- Add the parameters for the stored procedure here
	@IDCaixa INT,
	@IDMovForma SMALLINT,
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
			DECLARE @MovForma VARCHAR(30)
			DECLARE @IDCredito INT 

			-- VERIFICACAO DOS VALORES
			-----------------------------------------------------------------------------
			SELECT @CreditoData = DataFinal 
			, @IDConta = IDConta
			, @IDFilial = IDFilial
			FROM tblCaixa 
			WHERE IDCaixa = @IDCaixa
			--
			SELECT @MovForma = MovForma FROM tblCaixaMovForma WHERE IDMovForma = @IDMovForma
			--
			IF @Valor >= 0
				SET @Descricao = 'Nivelamento de Caixa POSITIVO (' + @MovForma + ')'
			ELSE
				SET @Descricao = 'Nivelamento de Caixa NEGATIVO (' + @MovForma + ')'

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
			IF @Valor > 0
				-- CASO POSITIVO INSERE TBLMOVIMENTACAO
				INSERT INTO tblCaixaMovimentacao
					(Origem
					,IDOrigem
					,IDConta
					,MovData
					,MovValor
					,IDMovForma
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
					,@IDMovForma
					,'FALSE'
					,@Descricao
					,@IDCaixa
					,1);
			ELSE
				-- CASO NEGATIVO INSERE TBLSAIDA
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
					(3
					,@IDCredito
					,@IDConta
					,@IDMovForma
					,@CreditoData
					,@Valor
					,'FALSE'
					,@Descricao
					,@IDCaixa
					,2);
		
			-- RETORNA O NOVO RESULTADO INSERIDO
			-----------------------------------------------------------------------------
			SELECT
			ES.IDMovimentacao
			,ES.Origem
			,ES.IDOrigem
			,ES.MovData
			,ES.MovValor
			,ES.IDConta
			,Ct.Conta
			,ES.IDCaixa
			,ES.Descricao
			,ES.IDMovForma
			,F.IDMovForma
			,F.MovForma
			,ES.Movimento
			,ES.Mov
			FROM qryMovimentacao AS ES
			JOIN tblCaixaMovForma AS F
			ON F.IDMovForma = ES.IDMovForma
			JOIN tblCaixaContas AS Ct
			ON Ct.IDConta = ES.IDConta
			WHERE Origem = 3 AND IDOrigem = @IDCredito
		
	COMMIT TRAN

	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() AS RETORNO
	END CATCH



	--

END
