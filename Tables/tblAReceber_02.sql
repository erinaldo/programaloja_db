/*
   quinta-feira, 6 de dezembro de 201816:05:11
   Usuário: 
   Servidor: VTSERVER\SQLPADRAO
   Banco de Dados: NovaSiao
   Aplicativo: 
*/

/* Para impedir possíveis problemas de perda de dados, analise este script detalhadamente antes de executá-lo fora do contexto do designer de banco de dados.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblPessoaFilial SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblAReceber ADD CONSTRAINT
	FK_tblAReceber_tblPessoaFilial FOREIGN KEY
	(
	IDFilial
	) REFERENCES dbo.tblPessoaFilial
	(
	IDFilial
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblAReceber SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
