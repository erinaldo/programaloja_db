USE [NovaSiao]
GO

/****** Object:  View [dbo].[qryMovForma]    Script Date: 15/12/2018 19:16:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** 
Object:
View [dbo].[qryMovForma]    
Script Date: 27/01/2018
Alter Date:  15/12/2018
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


