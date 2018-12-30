--

-- =============================================================
-- Author:			Daniel Ramos de Oliveira
-- Create date:		27/01/2018
-- Alteracao Data:	15/12/2018
-- Description:		qryMovForma
-- =============================================================

--
ALTER VIEW	[dbo].[qryMovForma]

AS
	SELECT
	F.IDMovForma
	, F.MovForma
	, F.IDMovTipo
	, T.MovTipo
	, T.Meio
	, CASE T.Meio
		WHEN 1 THEN 'Moeda'
		WHEN 2 THEN 'Cheque'
		WHEN 3 THEN 'Cartão'
		END AS MeioDescricao
	, F.IDCartaoTipo
	, C.Cartao
	, F.Parcelas
	, F.Comissao
	, F.NoDias
	, F.Ativo
	, F.IDFilial
	, PF.ApelidoFilial
	, F.IDContaPadrao
	, CT.Conta AS ContaPadrao
	FROM
	tblCaixaMovForma AS F

	LEFT JOIN tblCaixaMovFormaTipo AS T
		ON F.IDMovTipo = T.IDMovTipo
	LEFT JOIN tblCaixaCartaoTipo C
		ON F.IDCartaoTipo = C.IDCartaoTipo
	LEFT JOIN tblPessoaFilial AS PF
		ON F.IDFilial = PF.IDFilial
	LEFT JOIN tblCaixaContas AS CT
		ON F.IDContaPadrao = CT.IDConta

GO


