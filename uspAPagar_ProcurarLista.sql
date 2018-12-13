-- =============================================
-- Author:		Daniel
-- Create date: 02/01/2018
-- Alter date:	03/15/2018
-- Description:	DEVOLVE UMA LISTA DE APAGAR SEGUNDO FILTRO
-- =============================================

ALTER PROCEDURE [dbo].[uspAPagar_ProcurarLista]

@CredorCadastro VARCHAR(50) = ''
,@IDCobrancaForma SMALLINT = NULL
,@IDFilial INT = NULL
,@DataInicial AS DATE = NULL
,@DataFinal AS DATE = NULL
,@APagarExterno AS BIT = 'TRUE' -- TRUE: APAGAR WITHOUT SIMPLES | FALSE: APAGAR ONLY SIMPLES 

AS
BEGIN

DECLARE @SQLString AS NVARCHAR(MAX) = ''
DECLARE @SQLWhere AS NVARCHAR(MAX) = ''
--DECLARE @useWhere AS BIT = 'TRUE'

SET @SQLString = N'SELECT
IDAPagar
, Origem
, OrigemTexto
, IDOrigem
, IDFilial
, ApelidoFilial
, IDPessoa
, Cadastro
, IDCobrancaForma
, CobrancaForma
, Identificador
, RGBanco
, BancoNome
, Vencimento
, APagarValor
, Situacao
, PagamentoData
, Desconto
, Acrescimo
FROM qryAPagar'

-- ADICIONA APagarExterno --> TRUE: APAGAR WITHOUT SIMPLES | FALSE: APAGAR ONLY SIMPLES 
IF @APagarExterno = 'TRUE'
	SET @SQLWhere = N' WHERE Origem <> 4 '; --> WITHOUT SIMPLES (APAGAR)
ELSE
	SET @SQLWhere = N' WHERE Origem = 4 '; --> ONLY SIMPLES (APAGAR)

-- ADICIONA IDCredor
IF @IDCobrancaForma IS NOT NULL
	SET @SQLWhere = N' AND IDCobrancaForma = ' + CONVERT(nvarchar(10), @IDCobrancaForma);

-- VERIFICA IDFILIAL
IF @IDFilial IS NOT NULL
	SET @SQLWhere = @SQLWhere + N' AND IDFilial = ' + CONVERT(nvarchar(10), @IDFilial);

-- VERIFICA DESCRICAO
IF LEN(@CredorCadastro) > 0
	SET @SQLWhere = @SQLWhere + N' AND Cadastro LIKE ' + '''%' + CAST(@CredorCadastro AS nvarchar(100)) + '%''';

-- VERIFICA DATA INICIAL
IF @DataInicial IS NOT NULL
	SET @SQLWhere = @SQLWhere + N' AND Vencimento >= ' + '''' + CAST(@DataInicial AS nvarchar(20)) + '''';

-- VERIFICA DATA FINAL
IF @DataFinal IS NOT NULL
	SET @SQLWhere = @SQLWhere + N' AND Vencimento <= ' + '''' + CAST(@DataFinal AS nvarchar(20)) + '''';

-- ADICIONA O WHERE A STRING
SET @SQLString = @SQLString + @SQLWhere

-- DEVOLVE O DATATABLE
EXEC sp_sqlexec @SQLString

END