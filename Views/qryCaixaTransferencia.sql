--

-- =============================================
-- Author:		Daniel
-- Create date: 04/02/2019
-- Alter date:	04/02/2019
-- Description:	qryCaixaTransferencia
-- =============================================

ALTER VIEW [dbo].[qryCaixaTransferencia]
AS
SELECT
T.IDTransferencia
, T.IDContaCredito
, CC.Conta AS ContaCredito
, T.IDContaDebito
, CD.Conta AS ContaDebito
, CD.IDFilial
, FIL.ApelidoFilial
, T.IDMovDebito
, T.IDMovCredito
, MovDeb.IDMovForma AS IDMovFormaDebito
, MFDeb.MovForma AS MovFormaDebito
, MovCred.IDMovForma AS IDMovFormaCredito
, MFCred.MovForma AS MovFormaCredito
, T.TransferenciaData
, T.TransferenciaValor
, T.ComissaoValor
, O.Observacao

FROM tblCaixaTransferencia AS T
LEFT JOIN tblCaixaContas AS CC
ON CC.IDConta = T.IDContaCredito
LEFT JOIN tblCaixaContas AS CD
ON CD.IDConta = T.IDContaDebito
LEFT JOIN tblPessoaFilial AS FIL
ON CD.IDFilial = FIL.IDFilial

LEFT JOIN tblCaixaMovimentacao AS MovDeb
ON MovDeb.IDMovimentacao = T.IDMovDebito
LEFT JOIN tblCaixaMovForma AS MFDeb
ON MovDeb.IDMovForma = MFDeb.IDMovForma

LEFT JOIN tblCaixaMovimentacao AS MovCred
ON MovCred.IDMovimentacao = T.IDMovCredito
LEFT JOIN tblCaixaMovForma AS MFCred
ON MovCred.IDMovForma = MFCred.IDMovForma

LEFT JOIN tblObservacao AS O
ON O.IDOrigem = T.IDTransferencia AND O.Origem = 13

GO