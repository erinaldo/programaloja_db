ALTER PROCEDURE [dbo].[uspContas_GET_PorIDFilial]
@IDFilial AS INTEGER = NULL
AS
BEGIN

IF @IDFilial IS NULL
	SELECT
	IDConta
	,IDFilial
	,Conta
	,ContaTipo
	,Ativo
	,BloqueioData
	,SaldoAtual
	,LastIDCaixa
	FROM
	tblCaixaContas
ELSE
	SELECT
	IDConta
	,IDFilial
	,Conta
	,ContaTipo
	,Ativo
	,BloqueioData
	,SaldoAtual
	,LastIDCaixa
	FROM
	tblCaixaContas
	WHERE
	IDFilial = @IDFilial
END