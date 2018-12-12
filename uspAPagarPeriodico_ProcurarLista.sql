USE [NovaSiao]
GO

-- =============================================
-- Author:		Daniel
-- Create date: 18/01/2018
-- Alter date:	03/12/2018
-- Description:	DEVOLVE UMA LISTA DE DESPESA PERIODICA PARA GERAR O APAGAR LISTA
--				SOMENTE RETORNA AS DESPESAS PERIODICAS ATIVAS
-- =============================================

ALTER PROCEDURE [dbo].[uspAPagarPeriodico_ProcurarLista]

@CredorCadastro VARCHAR(100) = ''
,@IDFilial INTEGER = NULL
,@IDCobrancaForma INTEGER = NULL

AS
BEGIN

DECLARE @SQLString AS NVARCHAR(MAX) = ''
DECLARE @SQLWhere AS NVARCHAR(MAX) = ''

SET @SQLString = N'SELECT
IDDespesaPeriodica
, IDCredor
, Cadastro
, IDFilial
, ApelidoFilial
, IDDespesaTipo
, DespesaTipo
, Descricao
, IniciarData
, DespesaValor
, Ativa
, Periodicidade
, DiaVencimento
, MesVencimento
, IDCobrancaForma
, CobrancaForma
, RGBanco
, BancoNome
FROM qryDespesaPeriodica
WHERE Ativa = ''TRUE'''

-- ADICIONA IDCOBRANCAFORMA
IF @IDCobrancaForma IS NOT NULL
	BEGIN
		SET @SQLWhere = N' AND IDCobrancaForma = ' + CONVERT(nvarchar(10), @IDCobrancaForma);
	END

-- ADICIONA IDFILIAL
IF @IDFilial IS NOT NULL
	BEGIN
		SET @SQLWhere = N' AND IDFilial = ' + CONVERT(nvarchar(10), @IDFilial);
	END

-- VERIFICA CREDOR CADASTRO
IF LEN(@CredorCadastro) > 0
	BEGIN
		SET @SQLWhere = @SQLWhere + N' AND Cadastro LIKE ' + '''%' + CAST(@CredorCadastro AS nvarchar(100)) + '%''';
	END

-- ADICIONA O WHERE A STRING
SET @SQLString = @SQLString + @SQLWhere

print @sqlstring

-- DEVOLVE O DATATABLE
EXEC sp_sqlexec @SQLString

END