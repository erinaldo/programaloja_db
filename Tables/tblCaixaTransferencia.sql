/****** Object:  Table [dbo].[tblCaixaTransferencia]    Script Date: 03/02/2019 20:39:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblCaixaTransferencia](
	[IDTransferencia] [int] IDENTITY(1,1) NOT NULL,
	[IDContaDebito] [smallint] NOT NULL,
	[IDContaCredito] [smallint] NOT NULL,
	[TransferenciaData] [date] NOT NULL,
	[TransferenciaValor] [decimal](18, 2) NOT NULL,
	[ComissaoValor] [decimal](18, 2) NOT NULL,
	[IDMovDebito] [int] NOT NULL,
	[IDMovCredito] [int] NOT NULL,
 CONSTRAINT [PK_tblCaixaTransferencia] PRIMARY KEY CLUSTERED 
(
	[IDTransferencia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tblCaixaTransferencia] ADD  CONSTRAINT [DF_tblCaixaTransferencia_TransferenciaValor]  DEFAULT ((0)) FOR [TransferenciaValor]
GO

ALTER TABLE [dbo].[tblCaixaTransferencia] ADD  CONSTRAINT [DF_tblCaixaTransferencia_ComissaoValor]  DEFAULT ((0)) FOR [ComissaoValor]
GO

ALTER TABLE [dbo].[tblCaixaTransferencia]  WITH CHECK ADD  CONSTRAINT [FK_tblCaixaTransferencia_tblCaixaContas] FOREIGN KEY([IDContaDebito])
REFERENCES [dbo].[tblCaixaContas] ([IDConta])
GO

ALTER TABLE [dbo].[tblCaixaTransferencia] CHECK CONSTRAINT [FK_tblCaixaTransferencia_tblCaixaContas]
GO

ALTER TABLE [dbo].[tblCaixaTransferencia]  WITH CHECK ADD  CONSTRAINT [FK_tblCaixaTransferencia_tblCaixaContas1] FOREIGN KEY([IDContaCredito])
REFERENCES [dbo].[tblCaixaContas] ([IDConta])
GO

ALTER TABLE [dbo].[tblCaixaTransferencia] CHECK CONSTRAINT [FK_tblCaixaTransferencia_tblCaixaContas1]
GO

ALTER TABLE [dbo].[tblCaixaTransferencia]  WITH CHECK ADD  CONSTRAINT [FK_tblCaixaTransferencia_tblCaixaMovimentacao] FOREIGN KEY([IDMovDebito])
REFERENCES [dbo].[tblCaixaMovimentacao] ([IDMovimentacao])
GO

ALTER TABLE [dbo].[tblCaixaTransferencia] CHECK CONSTRAINT [FK_tblCaixaTransferencia_tblCaixaMovimentacao]
GO

ALTER TABLE [dbo].[tblCaixaTransferencia]  WITH CHECK ADD  CONSTRAINT [FK_tblCaixaTransferencia_tblCaixaMovimentacao1] FOREIGN KEY([IDMovCredito])
REFERENCES [dbo].[tblCaixaMovimentacao] ([IDMovimentacao])
GO

ALTER TABLE [dbo].[tblCaixaTransferencia] CHECK CONSTRAINT [FK_tblCaixaTransferencia_tblCaixaMovimentacao1]
GO


