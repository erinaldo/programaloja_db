/*
   sexta-feira, 14 de dezembro de 201820:27:57
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
ALTER TABLE dbo.tblCaixaMovForma SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblCaixaMovimentacao SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblCaixaTransferencia SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblCaixaCartaoPrevisao ADD CONSTRAINT
	FK_tblCaixaCartaoPrevisao_tblCaixaMovimentacao FOREIGN KEY
	(
	IDMovimentacao
	) REFERENCES dbo.tblCaixaMovimentacao
	(
	IDMovimentacao
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblCaixaCartaoPrevisao ADD CONSTRAINT
	FK_tblCaixaCartaoPrevisao_tblCaixaMovForma FOREIGN KEY
	(
	IDMovForma
	) REFERENCES dbo.tblCaixaMovForma
	(
	IDMovForma
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblCaixaCartaoPrevisao ADD CONSTRAINT
	FK_tblCaixaCartaoPrevisao_tblCaixaTransferencia FOREIGN KEY
	(
	IDTransferencia
	) REFERENCES dbo.tblCaixaTransferencia
	(
	IDTransferencia
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblCaixaCartaoPrevisao SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
