--

-- ===============================================================
-- Author:		Daniel
-- Create date: 22/01/2018
-- Alter Date:  01/02/2019
-- Description:	Retorna os movimentos de Caixa de uma IDCaixa
-- ================================================================

--
ALTER PROCEDURE [dbo].[uspCaixa_GetMovimentos_IDCaixa]
	--
	-- PARAMETROS TBLCAIXA
	-- =============================================================================================
	@IDCaixa AS INT = NULL
	--
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @dtInicial DATE
	DECLARE @dtFinal DATE
	DECLARE @Situacao TINYINT -- 1:INICIADA | 2:CONCLUIDA | 3:BLOQUEADA
	DECLARE @IDConta TINYINT 
	--
	SELECT @dtInicial = DataInicial
		  ,@dtFinal = DataFinal
		  ,@Situacao = IDSituacao
		  ,@IDConta = IDConta FROM tblCaixa WHERE IDCaixa = @IDCaixa
	--
	IF @Situacao = 1 -- INICIADA (LIBERADA PARA EDICAO)
		BEGIN
			-- LIMPA MOVS DE ENTRADA ANTERIORES
			UPDATE tblCaixaMovimentacao SET
			IDCaixa = NULL
			WHERE IDCaixa = @IDCaixa
			
			-- ADICIONA MOVS DE ENTRADA NOVOS					
			UPDATE tblCaixaMovimentacao SET
			IDCaixa = @IDCaixa
			WHERE IDConta = @IDConta 
			AND MovData <= @dtFinal
			AND MovData >= @dtInicial

		END

	-- RETORNA A LISTAGEM
	SELECT *
	FROM qryMovimentacao AS ES
	WHERE IDCaixa = @IDCaixa
	ORDER BY MovData

END