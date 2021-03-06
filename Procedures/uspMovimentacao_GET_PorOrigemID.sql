--

-- =============================================================
-- Author:		Daniel
-- Create date: 30/12/2018
-- Alter date:  20/12/2018
-- Description:	Obter Movimentacao Pela OrigemID
-- =============================================================

ALTER PROCEDURE [dbo].[uspMovimentacao_GET_PorOrigemID]

/*

ORIGENS CODIGOS
=============================================
ENTRADAS
1:Venda | 2:AReceberParcela | 3:tblCreditos
SAIDAS
10:tblAPagar | 3:tblCreditos

*/

@Origem AS TINYINT
,@IDOrigem AS INTEGER
AS
BEGIN
	SELECT
	IDMovimentacao
	,IDOrigem
	,Origem
	,OrigemTexto
	,IDConta
	,IDFilial
	,ApelidoFilial
	,Conta
	,IDMovForma
	,MovForma
	,IDMovTipo
	,MovTipo
	,IDCartaoTipo
	,Cartao
	,MovData
	,MovValor
	,Creditar
	,Descricao
	,Movimento
	,Mov
	,Observacao
	,IDCaixa
	FROM qryMovimentacao
	WHERE
	Origem = @Origem -- VIDE LISTA ACIMA
	AND 
	IDOrigem = @IDOrigem
END