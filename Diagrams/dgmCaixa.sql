/*
   sexta-feira, 14 de dezembro de 201815:39:37
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
ALTER TABLE dbo.tblCaixa
	DROP CONSTRAINT FK_tblCaixa_tblContas
GO
ALTER TABLE dbo.tblEntradas
	DROP CONSTRAINT FK_tblPagamento_tblContas
GO
ALTER TABLE dbo.tblSaidas
	DROP CONSTRAINT FK_tblSaidas_tblContas
GO
ALTER TABLE dbo.tblContas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblEntradas
	DROP CONSTRAINT FK_tblEntradas_tblCaixa
GO
ALTER TABLE dbo.tblSaidas
	DROP CONSTRAINT FK_tblSaidas_tblCaixa
GO
ALTER TABLE dbo.tblCaixa SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblMovForma
	DROP CONSTRAINT FK_tblEntradaForma_tblMovOperadora
GO
ALTER TABLE dbo.tblCaixaSaldo
	DROP CONSTRAINT FK_tblCaixaSaldo_tblMovOperadora
GO
ALTER TABLE dbo.tblMovOperadora SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblCaixaSaldo
	DROP CONSTRAINT FK_tblCaixaSaldo_tblMovForma
GO
ALTER TABLE dbo.tblEntradas
	DROP CONSTRAINT FK_tblPagamento_tblPagForma
GO
ALTER TABLE dbo.tblSaidas
	DROP CONSTRAINT FK_tblSaidas_tblMovForma
GO
ALTER TABLE dbo.tblMovForma SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblSaidas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblEntradas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblCaixaSaldo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
