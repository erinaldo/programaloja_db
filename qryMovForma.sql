
/****** 
Object:
View [dbo].[qryMovForma]    
Script Date: 27/01/2018
Alter Date:  14/12/2018
******/

ALTER VIEW	[dbo].[qryMovForma]

AS
	SELECT
	F.IDMovForma
	, F.MovForma
	, F.IDMovTipo
	, T.MovTipo
	, F.IDCartaoTipo
	, C.Cartao
	, F.Parcelas
	, F.Comissao
	, F.NoDias
	, F.Ativo

	FROM
	tblCaixaMovForma AS F

	LEFT JOIN tblCaixaMovFormaTipo AS T
		ON F.IDMovTipo = T.IDMovTipo
	LEFT JOIN tblCaixaCartaoTipo C
		ON F.IDCartaoTipo = C.IDCartaoTipo

GO


