/*
   sexta-feira, 14 de dezembro de 201815:56:39
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
ALTER TABLE dbo.tblCaixaContas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblCaixaTransferencia ADD CONSTRAINT
	FK_tblCaixaTransferencia_tblCaixaContas FOREIGN KEY
	(
	IDContaCredito
	) REFERENCES dbo.tblCaixaContas
	(
	IDConta
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblCaixaTransferencia ADD CONSTRAINT
	FK_tblCaixaTransferencia_tblCaixaContas1 FOREIGN KEY
	(
	IDContaDebito
	) REFERENCES dbo.tblCaixaContas
	(
	IDConta
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblCaixaTransferencia SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblCaixa
	DROP CONSTRAINT FK_tblCaixa_tblTransacaoSituacao
GO
ALTER TABLE dbo.tblTransacaoSituacao SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblCaixa
	DROP CONSTRAINT DF_tblCaixa_Situacao
GO
CREATE TABLE dbo.Tmp_tblCaixa
	(
	IDCaixa int NOT NULL IDENTITY (1, 1),
	IDFilial int NOT NULL,
	IDConta smallint NOT NULL,
	FechamentoData date NOT NULL,
	IDSituacao tinyint NOT NULL,
	DataInicial smalldatetime NOT NULL,
	DataFinal smalldatetime NOT NULL,
	SaldoAnterior money NULL,
	SaldoFinal money NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tblCaixa SET (LOCK_ESCALATION = TABLE)
GO
ALTER TABLE dbo.Tmp_tblCaixa ADD CONSTRAINT
	DF_tblCaixa_Situacao DEFAULT ((0)) FOR IDSituacao
GO
SET IDENTITY_INSERT dbo.Tmp_tblCaixa ON
GO
IF EXISTS(SELECT * FROM dbo.tblCaixa)
	 EXEC('INSERT INTO dbo.Tmp_tblCaixa (IDCaixa, IDFilial, IDConta, FechamentoData, IDSituacao, DataInicial, DataFinal, SaldoAnterior, SaldoFinal)
		SELECT IDCaixa, IDFilial, CONVERT(smallint, IDConta), FechamentoData, IDSituacao, DataInicial, DataFinal, SaldoAnterior, SaldoFinal FROM dbo.tblCaixa WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tblCaixa OFF
GO
ALTER TABLE dbo.tblCaixaMovimentacao
	DROP CONSTRAINT FK_tblCaixaMovimentacao_tblCaixa
GO
DROP TABLE dbo.tblCaixa
GO
EXECUTE sp_rename N'dbo.Tmp_tblCaixa', N'tblCaixa', 'OBJECT' 
GO
ALTER TABLE dbo.tblCaixa ADD CONSTRAINT
	PK_tblCaixa PRIMARY KEY CLUSTERED 
	(
	IDCaixa
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tblCaixa ADD CONSTRAINT
	FK_tblCaixa_tblTransacaoSituacao FOREIGN KEY
	(
	IDSituacao
	) REFERENCES dbo.tblTransacaoSituacao
	(
	IDSituacao
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
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
ALTER TABLE dbo.tblCaixaMovimentacao ADD CONSTRAINT
	FK_tblCaixaMovimentacao_tblCaixaContas FOREIGN KEY
	(
	IDConta
	) REFERENCES dbo.tblCaixaContas
	(
	IDConta
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblCaixaMovimentacao SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
