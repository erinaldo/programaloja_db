/*
   sexta-feira, 14 de dezembro de 201815:55:17
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
ALTER TABLE dbo.tblCaixaCartaoTipo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblCaixaMovFormaTipo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblCaixaSaldo
	DROP CONSTRAINT FK_tblCaixaSaldo_tblCaixa
GO
ALTER TABLE dbo.tblCaixa SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblCaixaSaldo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblCaixaMovForma ADD CONSTRAINT
	FK_tblCaixaMovForma_tblCaixaMovFormaTipo FOREIGN KEY
	(
	IDMovTipo
	) REFERENCES dbo.tblCaixaMovFormaTipo
	(
	IDMovTipo
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblCaixaMovForma ADD CONSTRAINT
	FK_tblCaixaMovForma_tblCaixaCartaoTipo FOREIGN KEY
	(
	IDCartaoTipo
	) REFERENCES dbo.tblCaixaCartaoTipo
	(
	IDCartaoTipo
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblCaixaMovForma SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tblCaixaMovimentacao
	(
	IDMovimentacao int NOT NULL IDENTITY (1, 1),
	Origem tinyint NOT NULL,
	IDOrigem int NOT NULL,
	IDConta smallint NOT NULL,
	MovData date NOT NULL,
	MovValor money NOT NULL,
	IDMovForma smallint NOT NULL,
	Creditar bit NOT NULL,
	IDCaixa int NULL,
	Descricao varchar(100) NULL,
	Movimento tinyint NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tblCaixaMovimentacao SET (LOCK_ESCALATION = TABLE)
GO
DECLARE @v sql_variant 
SET @v = N'1:Credito | 2:Debito | 3:Transferencia'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tblCaixaMovimentacao', N'COLUMN', N'Movimento'
GO
SET IDENTITY_INSERT dbo.Tmp_tblCaixaMovimentacao ON
GO
IF EXISTS(SELECT * FROM dbo.tblCaixaMovimentacao)
	 EXEC('INSERT INTO dbo.Tmp_tblCaixaMovimentacao (IDMovimentacao, Origem, IDOrigem, IDConta, MovData, MovValor, IDMovForma, Creditar, IDCaixa, Descricao, Movimento)
		SELECT IDMovimentacao, Origem, IDOrigem, CONVERT(smallint, IDConta), MovData, MovValor, IDMovForma, Creditar, IDCaixa, Descricao, Movimento FROM dbo.tblCaixaMovimentacao WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tblCaixaMovimentacao OFF
GO
DROP TABLE dbo.tblCaixaMovimentacao
GO
EXECUTE sp_rename N'dbo.Tmp_tblCaixaMovimentacao', N'tblCaixaMovimentacao', 'OBJECT' 
GO
ALTER TABLE dbo.tblCaixaMovimentacao ADD CONSTRAINT
	PK_IDMov PRIMARY KEY CLUSTERED 
	(
	IDMovimentacao
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tblCaixaMovimentacao ADD CONSTRAINT
	FK_tblCaixaMovimentacao_tblCaixaMovForma FOREIGN KEY
	(
	IDMovForma
	) REFERENCES dbo.tblCaixaMovForma
	(
	IDMovForma
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblCaixaMovimentacao ADD CONSTRAINT
	FK_tblCaixaMovimentacao_tblCaixa FOREIGN KEY
	(
	IDCaixa
	) REFERENCES dbo.tblCaixa
	(
	IDCaixa
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
