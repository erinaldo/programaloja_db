USE [NovaSiao]
GO

/****** Object:  View [dbo].[qryAPagar]    Script Date: 07/12/2018 15:21:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Daniel
-- Create date: 02/01/2018
-- Alter date:	07/12/2018
-- Description:	qryAPagar
-- =============================================

ALTER VIEW [dbo].[qryAPagar]

AS
SELECT
Pag.IDAPagar
,Pag.Origem
,CASE Origem
	WHEN 1 THEN 'Transacao Compra'
	WHEN 2 THEN 'Despesa'
	WHEN 3 THEN 'Despesa Periodica'
	WHEN 4 THEN 'Simples Entrada'
	END AS OrigemTexto
,Pag.IDOrigem
,Pag.IDFilial
,F.ApelidoFilial
,Pag.IDPessoa
,P.Cadastro
,Pag.IDCobrancaForma
,CF.CobrancaForma
,Pag.Identificador
,Pag.RGBanco
,B.BancoNome
,Pag.Vencimento
,Pag.APagarValor
,Pag.Situacao
,Pag.PagamentoData
,Pag.ValorPago
,Pag.Desconto
,Pag.Acrescimo
FROM
tblAPagar AS Pag
LEFT JOIN tblPessoaFilial AS F
ON F.IDFilial = Pag.IDFilial
LEFT JOIN tblPessoa AS P
ON P.IDPessoa = PAG.IDPessoa
LEFT JOIN tblCobrancaForma AS CF
ON CF.IDCobrancaForma = Pag.IDCobrancaForma
LEFT JOIN tblBancos AS B
ON B.RGBanco = Pag.RGBanco



GO


