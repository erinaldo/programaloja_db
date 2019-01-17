CREATE TABLE [dbo].[tblCaixaMovimentacao](
	[IDMovimentacao] [int] IDENTITY(1,1) NOT NULL,
	[Origem] [tinyint] NOT NULL,
	[IDOrigem] [int] NOT NULL,
	[IDConta] [tinyint] NOT NULL,
	[MovData] [date] NOT NULL,
	[MovValor] [money] NOT NULL,
	[IDMovForma] [smallint] NOT NULL,
	[Creditar] [bit] NOT NULL,
	[IDCaixa] [int] NULL,
	[Descricao] [varchar](100) NULL,
	[Movimento] [tinyint] NOT NULL,
 CONSTRAINT [PK_IDMov] PRIMARY KEY CLUSTERED 
(
	[IDMovimentacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1:Credito | 2:Debito | 3:Transferencia' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblCaixaMovimentacao', @level2type=N'COLUMN',@level2name=N'Movimento'
GO


