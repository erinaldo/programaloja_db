--

--

-- ===============================================================
-- Author:		Daniel
-- Create date: 06/02/2018
-- Alter Date:  21/12/2018
-- Description:	Retorna os Saldos Anteriores das Contas
-- ================================================================

--
ALTER PROCEDURE [dbo].[uspCaixa_GetSaldoContaFormas]
	--
	-- PARAMETROS 
	-- =============================================================================================
	@IDCaixa INT
	--
AS
BEGIN
	-- GET ULTIMO CAIXA DA CONTA
	DECLARE @IDConta AS TINYINT = NULL
	DECLARE @IDCaixaAnterior INT

	-- GET IDConta do Caixa Atual
	SELECT @IDConta = IDConta FROM tblCaixa WHERE IDCaixa = @IDCaixa

	-- GET IDCaixaAnterior
	SELECT TOP 1 @IDCaixaAnterior = IDCaixa FROM tblCaixa
	WHERE IDConta = @IDConta AND IDCaixa != @IDCaixa
	ORDER BY IDCaixa DESC

	-- RETURN SALDO ANTERIOR
	SELECT
	C.IDCaixa
	, C.IDConta
	, Ct.Conta
	, C.IDMovForma
	, M.MovForma
	, C.SaldoFinal 
	FROM tblCaixaSaldo AS C
	LEFT JOIN tblCaixaContas AS Ct
	ON Ct.IDConta = C.IDConta
	LEFT JOIN tblCaixaMovForma AS M
	ON M.IDMovForma = C.IDMovForma
	WHERE IDCaixa = @IDCaixaAnterior

END