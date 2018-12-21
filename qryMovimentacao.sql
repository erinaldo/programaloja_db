USE [NovaSiao]
GO

/****** Object:  View [dbo].[qryMovimentacao]    Script Date: 20/12/2018 16:47:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--

-- =============================================================
-- Author:		Daniel
-- Create date: 19/12/2018
-- Alter date:	20/12/2018
-- Description:	Consulta Movimentacao
-- =============================================================

ALTER VIEW [dbo].[qryMovimentacao]

/*
ORIGEM
=============================================
ENTRADAS
1:Venda | 2:AReceberParcela | 3:tblCreditos
SAIDAS
10:tblAPagar | 3:tblCreditos
*/

AS

SELECT        
IDMovimentacao
, M.IDOrigem
, M.Origem
,CASE M.Origem
	WHEN 1 THEN 'Transacao'
	WHEN 2 THEN 'AReceberParcela'
	WHEN 3 THEN 'Creditos' 
	WHEN 10 THEN 'APagar'  
	END AS OrigemTexto
, M.IDConta
, C.Conta
, M.IDMovForma
, F.MovForma
, F.IDMovTipo
, T.MovTipo
, F.IDCartaoTipo
, Ct.Cartao
, MovData
, MovValor
, Creditar
, Descricao
, Movimento
, CASE Movimento
	WHEN 1 THEN 'E'
	WHEN 2 THEN 'S'
	WHEN 3 THEN 'T'
	END AS Mov
, IDCaixa
,O.Observacao
,Fil.IDFilial
,Fil.ApelidoFilial

FROM
tblCaixaMovimentacao AS M
LEFT JOIN
tblCaixaMovForma AS F ON M.IDMovForma = F.IDMovForma
LEFT JOIN
tblCaixaContas AS C ON M.IDConta = C.IDConta
LEFT JOIN
tblObservacao AS O ON O.IDOrigem = M.IDMovimentacao AND O.Origem = 3
LEFT JOIN
tblCaixaCartaoTipo AS Ct ON F.IDCartaoTipo = Ct.IDCartaoTipo
LEFT JOIN
tblCaixaMovFormaTipo AS T ON F.IDMovTipo = T.IDMovTipo
LEFT JOIN
tblPessoaFilial AS Fil ON C.IDFilial = Fil.IDFilial

GO


