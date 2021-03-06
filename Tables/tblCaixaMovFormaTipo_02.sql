/*
   quarta-feira, 26 de dezembro de 201823:11:14
   Usuário: 
   Servidor: SERVERNOTE\SQLPADRAO
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
ALTER TABLE dbo.tblCaixaMovFormaTipo ADD
	Meio tinyint NULL
GO
DECLARE @v sql_variant 
SET @v = N'1:Moeda | 2:Cheque | 3:Cartao'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'tblCaixaMovFormaTipo', N'COLUMN', N'Meio'
GO
ALTER TABLE dbo.tblCaixaMovFormaTipo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
