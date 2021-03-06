--

-- ===============================================================
-- Author:		Daniel
-- Create date: 24/01/2018
-- Alter Date:  18/12/2018
-- Description:	Devolve a Primeira e Ultima Data e o Saldo Final
--				dos movimentos de Entrada e Saida pelo IDConta
-- ================================================================

--
ALTER PROCEDURE [dbo].[uspCaixa_GetLastDados_IDConta]
	--
	-- PARAMETROS TBLCAIXA
	-- =============================================================================================
	@IDConta AS TINYINT
	--
AS
BEGIN
	DECLARE @dtInicial AS DATE
	DECLARE @dtFinal AS DATE
	DECLARE @LastIDCaixa AS INTEGER
	DECLARE @SaldoFinal AS MONEY = 0
	DECLARE @IDSituacao AS TINYINT
	--
	-- OBTEM AS DATAS DOS MOVIMENTOS
	SELECT @dtInicial = MIN(MovData) 
	, @dtFinal = MAX(MovData) 
	FROM qryMovimentacao
	WHERE IDConta = @IDConta AND IDCaixa IS NULL
	--
	-- OBTEM O ULTIMO SALDO FINAL E RETORNA A SITUACAO DO ULTIMO CAIXA
	SELECT TOP 1
	@IDSituacao = IDSituacao
	, @SaldoFinal = SaldoFinal
	, @LastIDCaixa = IDCaixa
	FROM tblCaixa
	WHERE IDConta = @IDConta
	ORDER BY IDCaixa DESC
	--
	-- RETORNA OS VALORES NECESSÁRIOS
	SELECT @dtInicial AS dtInicial
	, @dtFinal AS dtFinal
	, @SaldoFinal AS SaldoFinal
	, @IDSituacao AS IDSituacao
	, @LastIDCaixa AS LastIDCaixa
	---
END