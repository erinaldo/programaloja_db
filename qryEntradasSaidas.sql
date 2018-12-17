
ALTER VIEW [dbo].[qryEntradasSaidas]

AS

SELECT        
IDMovimentacao
, Origem
, IDOrigem
, IDConta
, MovData
, MovValor
, CASE Movimento
	WHEN 1 THEN MovValor
	WHEN 2 THEN MovValor * (-1)
	END AS ValorReal
, IDMovForma
, Creditar
, IDCaixa
, Descricao
, Movimento
, CASE Movimento
	WHEN 1 THEN 'E'
	WHEN 2 THEN 'S'
	WHEN 3 THEN 'T'
	END AS Mov
FROM tblCaixaMovimentacao

GO