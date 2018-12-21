USE [NovaSiao]
GO
/****** Object:  StoredProcedure [dbo].[uspMovimentacao_GET_PorOrigemID]    Script Date: 20/12/2018 17:30:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--

-- =============================================================
-- Author:		Daniel
-- Create date: 19/12/2018
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