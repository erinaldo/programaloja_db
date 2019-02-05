--

-- =============================================================
-- Author:		Daniel
-- Create date: 19/12/2018
-- Alter date:	04/02/2019
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
, M.IDMeio
, CASE M.IDMeio
	WHEN 1 THEN 'Moeda'
	WHEN 2 THEN 'Cheque'
	WHEN 3 THEN 'Cartao'
	END AS Meio
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


