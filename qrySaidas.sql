
/****** 
Object:
View [dbo].[qrySaidas]    
Script Date:	04/01/2018
Alter Date:		14/12/2018 
******/

ALTER VIEW [dbo].[qrySaidas]
AS

	SELECT
	S.IDMovimentacao
	,S.Origem
	,S.IDOrigem
	,S.IDConta
	,C.Conta
	,S.IDMovForma
	,F.MovForma
	,S.MovValor
	,S.MovData
	,S.Creditar
	,C.IDFilial
	,PF.ApelidoFilial
	,O.Observacao
	,S.IDCaixa
	,S.Descricao
	FROM
	tblCaixaMovimentacao AS S
	LEFT JOIN
	tblCaixaMovForma AS F ON S.IDMovForma = F.IDMovForma
	LEFT JOIN
	tblCaixaContas AS C ON S.IDConta = C.IDConta
	LEFT JOIN
	tblObservacao AS O ON O.IDOrigem = S.IDMovimentacao AND O.Origem = 3
	LEFT JOIN 
	tblPessoaFilial AS PF ON C.IDFilial = PF.IDFilial
	WHERE Movimento = 2 -- MOV. DEBITO


GO


