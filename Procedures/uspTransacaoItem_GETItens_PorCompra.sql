USE [NovaSiao]
GO

-- =============================================
-- Author:		Daniel
-- Create date: 04/09/2017
-- Alteracao:   28/11/2018
-- Description:	GET TransacaoItem Por Compra
-- =============================================

ALTER PROCEDURE [dbo].[uspTransacaoItem_GETItens_PorCompra]
@IDTransacao AS INT
,@IDFilial AS INTEGER
AS
BEGIN 
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
	WHERE
	IDTransacao = @IDTransacao AND E.IDFilial = @IDFilial
END