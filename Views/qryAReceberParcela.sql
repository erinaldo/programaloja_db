--

--
-- =============================================
-- Author:		Daniel
-- Create date: 01/01/2018
-- Alteracao:   16/01/2019
-- Description:	qryAReceberParcela
-- =============================================

ALTER VIEW [dbo].[qryAReceberParcela]
AS

SELECT
-- tblPessoaFisica
Pe.Cadastro
,Pe.CNP
-- tblAReceber
,tR.IDAReceber
,tR.Origem
,tR.IDOrigem
,tR.IDFilial
,F.ApelidoFilial
,tR.IDPessoa
,tR.AReceberValor
,tR.ValorPagoTotal
,tR.SituacaoAReceber
,tR.IDCobrancaForma
,tR.IDPlano
-- tblAReceberParcela
,tP.IDAReceberParcela
,tP.Letra
,tP.Vencimento
,tP.ParcelaValor
,tP.PermanenciaTaxa
,tP.ValorPagoParcela
,tP.ValorJuros
,tP.SituacaoParcela
,tP.PagamentoData
FROM tblAReceber AS tR
JOIN
tblAReceberParcela AS tP ON tP.IDAReceber = tR.IDAReceber
LEFT JOIN
qryPessoaFisicaJuridica AS Pe ON tr.IDPessoa = Pe.IDPessoa
LEFT JOIN
tblPessoaFilial AS F ON tR.IDFilial = F.IDFilial


GO