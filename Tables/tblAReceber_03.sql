/*
   quinta-feira, 6 de dezembro de 201816:07:34
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
ALTER TABLE dbo.tblAReceber
	DROP CONSTRAINT FK_tblAReceber_tblPessoaFilial
GO
ALTER TABLE dbo.tblPessoaFilial SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblAReceber
	DROP CONSTRAINT FK_tblAReceber_tblVendaCobranca
GO
ALTER TABLE dbo.tblCobrancaForma SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblAReceber
	DROP CONSTRAINT FK_tblAReceber_tblVendaPlanos
GO
ALTER TABLE dbo.tblVendaPlanos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblAReceber
	DROP CONSTRAINT FK_tblAReceber_tblPessoa
GO
ALTER TABLE dbo.tblPessoa SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblAReceber
	DROP CONSTRAINT DF_tblCobranca_CobrancaValor
GO
ALTER TABLE dbo.tblAReceber
	DROP CONSTRAINT DF_tblCobranca_ValorPago
GO
ALTER TABLE dbo.tblAReceber
	DROP CONSTRAINT DF_tblCobranca_Quitado
GO
CREATE TABLE dbo.Tmp_tblAReceber
	(
	IDAReceber int NOT NULL IDENTITY (1, 1),
	IDFilial int NOT NULL,
	Origem tinyint NOT NULL,
	IDOrigem int NOT NULL,
	IDPessoa int NOT NULL,
	AReceberValor money NOT NULL,
	ValorPagoTotal money NOT NULL,
	SituacaoAReceber tinyint NOT NULL,
	IDCobrancaForma smallint NULL,
	IDPlano smallint NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tblAReceber SET (LOCK_ESCALATION = TABLE)
GO
DECLARE @v sql_variant 
SET @v = N'1:TRANSACAO | 2:REFINANCIAMENTO | 3:TROCA'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tblAReceber', N'COLUMN', N'Origem'
GO
DECLARE @v sql_variant 
SET @v = N'0:EmAberto | 1:Pago | 2:Cancelada'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tblAReceber', N'COLUMN', N'SituacaoAReceber'
GO
ALTER TABLE dbo.Tmp_tblAReceber ADD CONSTRAINT
	DF_tblCobranca_CobrancaValor DEFAULT ((0)) FOR AReceberValor
GO
ALTER TABLE dbo.Tmp_tblAReceber ADD CONSTRAINT
	DF_tblCobranca_ValorPago DEFAULT ((0)) FOR ValorPagoTotal
GO
ALTER TABLE dbo.Tmp_tblAReceber ADD CONSTRAINT
	DF_tblCobranca_Quitado DEFAULT ((0)) FOR SituacaoAReceber
GO
SET IDENTITY_INSERT dbo.Tmp_tblAReceber ON
GO
IF EXISTS(SELECT * FROM dbo.tblAReceber)
	 EXEC('INSERT INTO dbo.Tmp_tblAReceber (IDAReceber, IDFilial, Origem, IDOrigem, IDPessoa, AReceberValor, ValorPagoTotal, SituacaoAReceber, IDCobrancaForma, IDPlano)
		SELECT IDAReceber, IDFilial, Origem, IDOrigem, IDPessoa, AReceberValor, ValorPagoTotal, SituacaoAReceber, IDCobrancaForma, IDPlano FROM dbo.tblAReceber WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tblAReceber OFF
GO
ALTER TABLE dbo.tblAReceberParcela
	DROP CONSTRAINT FK_tblAReceberParcela_tblAReceber
GO
DROP TABLE dbo.tblAReceber
GO
EXECUTE sp_rename N'dbo.Tmp_tblAReceber', N'tblAReceber', 'OBJECT' 
GO
ALTER TABLE dbo.tblAReceber ADD CONSTRAINT
	PK_tblAReceber PRIMARY KEY CLUSTERED 
	(
	IDAReceber
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tblAReceber ADD CONSTRAINT
	FK_tblAReceber_tblPessoa FOREIGN KEY
	(
	IDPessoa
	) REFERENCES dbo.tblPessoa
	(
	IDPessoa
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblAReceber ADD CONSTRAINT
	FK_tblAReceber_tblVendaPlanos FOREIGN KEY
	(
	IDPlano
	) REFERENCES dbo.tblVendaPlanos
	(
	IDPlano
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblAReceber ADD CONSTRAINT
	FK_tblAReceber_tblVendaCobranca FOREIGN KEY
	(
	IDCobrancaForma
	) REFERENCES dbo.tblCobrancaForma
	(
	IDCobrancaForma
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
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
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblAReceberParcela ADD CONSTRAINT
	FK_tblAReceberParcela_tblAReceber FOREIGN KEY
	(
	IDAReceber
	) REFERENCES dbo.tblAReceber
	(
	IDAReceber
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.tblAReceberParcela SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
