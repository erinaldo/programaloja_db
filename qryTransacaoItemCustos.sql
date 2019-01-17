--

-- =============================================
-- Author:		Daniel
-- Create date: 15/01/2019
-- Alter date:	15/01/2019
-- Description:	qryTransacaoItemCustos
-- =============================================

CREATE VIEW [dbo].[qryTransacaoItemCustos]

AS

SELECT
I.IDTransacaoItem
,I.IDTransacao
,I.Desconto
,I.Preco
,I.IDProduto
,I.Quantidade
,P.Produto
,P.RGProduto
,P.CodBarrasA
,P.PCompra
,P.DescontoCompra
,P.PVenda
,P.ProdutoAtivo
,E.Quantidade AS Estoque
,E.Reservado
,E.IDFilial
,Custos.FreteRateado
,Custos.Substituicao
,Custos.ICMS
,Custos.MVA
,Custos.IPI
FROM
tblTransacaoItens AS I
JOIN
tblProduto AS P ON P.IDProduto = I.IDProduto
JOIN
tblEstoque AS E ON E.IDProduto = I.IDProduto
LEFT JOIN
tblTransacaoItensCustos AS Custos ON Custos.IDTransacaoItem = I.IDTransacaoItem
GO