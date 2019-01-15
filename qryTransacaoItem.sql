--

-- =============================================
-- Author:		Daniel
-- Create date: 15/01/2019
-- Alter date:	15/01/2019
-- Description:	qryTransacaoItem
-- =============================================

ALTER VIEW [dbo].[qryTransacaoItem]

AS

SELECT
I.IDTransacaoItem
,I.IDTransacao
,I.IDProduto
,P.Produto
,P.PCompra
,P.PVenda
,P.RGProduto
,I.Quantidade
,I.Preco
,I.Desconto
,P.CodBarrasA
,P.DescontoCompra
,P.ProdutoAtivo
,E.IDFilial
,E.Quantidade AS Estoque
,E.Reservado
FROM
tblTransacaoItens AS I
JOIN
tblProduto AS P ON P.IDProduto = I.IDProduto
LEFT JOIN
tblEstoque AS E ON E.IDProduto = I.IDProduto