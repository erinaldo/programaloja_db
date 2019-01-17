--

-- =============================================
-- Author:		Daniel
-- Create date: 02/01/2019
-- Alter date:	02/01/2019
-- Description:	qryContas
-- =============================================

CREATE VIEW [dbo].[qryContas]

AS

SELECT
C.IDConta
,C.Conta
,C.IDFilial
,PF.ApelidoFilial
,C.ContaTipo
,C.Ativo
,C.BloqueioData
,C.SaldoAtual
,C.LastIDCaixa
FROM
tblCaixaContas AS C
LEFT JOIN tblPessoaFilial AS PF
ON C.IDFilial = PF.IDFilial

GO


