/*
   sexta-feira, 14 de dezembro de 201815:58:47
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
ALTER TABLE dbo.tblCaixaContas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblCaixa ADD CONSTRAINT
	FK_tblCaixa_tblCaixaContas FOREIGN KEY
	(
	IDConta
	) REFERENCES dbo.tblCaixaContas
	(
	IDConta
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblCaixa ADD CONSTRAINT
	FK_tblCaixa_tblPessoaFilial FOREIGN KEY
	(
	IDFilial
	) REFERENCES dbo.tblPessoaFilial
	(
	IDFilial
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblCaixa SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
