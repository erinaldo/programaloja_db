USE [NovaSiao]
GO

/****** Object:  View [dbo].[qryEntradas]    Script Date: 14/12/2018 21:19:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/****** 
Object:
View [dbo].[qryEntradas]    
Script Date: 22/01/2018
Alter Date:  14/12/2018
******/

ALTER VIEW	[dbo].[qryEntradas]

/*
ORIGEM
1:Transacao | 2:AReceberParcela
*/

AS
	SELECT
	E.IDMovimentacao
	,E.IDConta
	,E.Origem
	,CASE E.Origem
		WHEN 1 THEN 'Transacao'
		WHEN 2 THEN 'AReceberParcela' END AS OrigemTexto
	,E.IDOrigem
	,C.Conta
	,E.MovValor
	,E.MovData
	,O.Observacao
	,E.IDMovForma
	,E.Creditar
	,E.IDCaixa
	,E.Descricao
	,F.MovForma
	,F.IDCartaoTipo
	,Ct.Cartao
	,F.IDMovTipo
	,M.MovTipo
	FROM
	tblCaixaMovimentacao AS E
	LEFT JOIN
	tblCaixaMovForma AS F ON E.IDMovForma = F.IDMovForma
	LEFT JOIN
	tblCaixaContas AS C ON E.IDConta = C.IDConta
	LEFT JOIN
	tblObservacao AS O ON O.IDOrigem = E.IDMovimentacao AND O.Origem = 3
	LEFT JOIN
	tblCaixaCartaoTipo AS Ct ON F.IDCartaoTipo = Ct.IDCartaoTipo
	LEFT JOIN
	tblCaixaMovFormaTipo AS M ON F.IDMovTipo = M.IDMovTipo 
	WHERE Movimento = 1 -- MOV. CREDITO

GO