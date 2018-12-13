CREATE TABLE [dbo].[tblCaixaTransferencia](
	[IDTransferencia] [int] IDENTITY(1,1) NOT NULL,
	[IDContaCredito] [smallint] NOT NULL,
	[IDContaDebito] [smallint] NOT NULL,
	[TransferenciaData] [smalldatetime] NOT NULL,
	[ValorTransferencia] [money] NOT NULL,
	[ValorDespesa] [money] NOT NULL,
 CONSTRAINT [PK_tblCaixaTransferencia] PRIMARY KEY CLUSTERED 
(
	[IDTransferencia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tblCaixaTransferencia] ADD  CONSTRAINT [DF_tblCaixaTransferencia_ValorTransferencia]  DEFAULT ((0)) FOR [ValorTransferencia]
GO

ALTER TABLE [dbo].[tblCaixaTransferencia] ADD  CONSTRAINT [DF_tblCaixaTransferencia_ValorDespesa]  DEFAULT ((0)) FOR [ValorDespesa]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transferencia entre Contas' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblCaixaTransferencia'
GO


