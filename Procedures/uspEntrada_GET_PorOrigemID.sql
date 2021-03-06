--

-- =============================================================
-- Author:		Daniel
-- Create date: 24/12/2017
-- Alter date:	24/01/2018
-- Description:	Obter Entradas Pela OrigemID
-- =============================================================

ALTER PROCEDURE [dbo].[uspEntrada_GET_PorOrigemID]

/*
ORIGEM
1:Transacao | 2:AReceberParcela
*/

@Origem AS TINYINT
,@IDOrigem AS INTEGER
AS
BEGIN
	SELECT
	IDEntrada
	,IDConta
	,Origem
	,IDOrigem
	,OrigemTexto
	,Conta
	,EntradaValor
	,EntradaData
	,Observacao
	,IDMovForma
	,Creditar
	,IDCaixa
	,MovForma
	,IDOperadora
	,Operadora
	,Cartao
	,IDMovTipo
	,MovTipo
	FROM qryEntradas
	WHERE
	Origem = @Origem -- VIDE LISTA ACIMA
	AND IDOrigem = @IDOrigem
END