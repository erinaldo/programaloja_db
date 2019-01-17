--


-- =============================================
-- Author:		Daniel
-- Create date: 15/01/2019
-- Alter date:	15/01/2019
-- Description:	qryTransacaoItemMovimentacao
-- =============================================

ALTER VIEW [dbo].[qryTransacaoItemMovimentacao]
AS
SELECT 
I.IDProduto
, I.Quantidade
, T.IDOperacao
, O.MovimentoEstoque
, CASE O.MovimentoEstoque 
	WHEN 'E' THEN (T.IDPessoaDestino) 
	WHEN 'S' THEN (T.IDPessoaOrigem) 
	END AS IDFilial
, CASE O.MovimentoEstoque 
	WHEN 'E' THEN (I.Quantidade) 
	WHEN 'S' THEN (I.Quantidade * -1) 
	END AS QReal
FROM tblTransacaoItens AS I
JOIN tblTransacao AS T ON T.IDTransacao = I.IDTransacao
JOIN tblOperacao AS O ON T.IDOperacao = O.IDOperacao
GO