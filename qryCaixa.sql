/****** 
Object:			qryCaixa
Script Date:	22/01/2018
Alter Date:		14/12/2018
******/


ALTER VIEW [dbo].[qryCaixa]
AS
SELECT
C.IDCaixa
, C.IDConta
, CT.Conta
, C.IDFilial
, P.ApelidoFilial
, C.FechamentoData
, C.IDSituacao
, CASE IDSituacao 
	WHEN 1 THEN 'INICIADO'
	WHEN 2 THEN 'FINALIZADO'
	WHEN 3 THEN 'BLOQUEADO'
	END AS Situacao
, C.DataInicial
, C.DataFinal
, C.SaldoFinal
, C.SaldoAnterior
, O.Observacao

FROM tblCaixa AS C
LEFT JOIN tblCaixaContas AS Ct
ON CT.IDConta = C.IDConta
LEFT JOIN tblPessoaFilial AS P
ON P.IDFilial = C.IDFilial
LEFT JOIN tblObservacao AS O
ON O.IDOrigem = C.IDCaixa AND O.Origem = 5




GO