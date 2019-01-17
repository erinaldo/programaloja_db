CREATE TABLE [dbo].[tblCaixaMovForma](
	[IDMovForma] [smallint] IDENTITY(1,1) NOT NULL,
	[MovForma] [varchar](30) NOT NULL,
	[IDMovTipo] [smallint] NOT NULL,
	[IDOperadora] [smallint] NOT NULL,
	[IDCartao] [smallint] NULL,
	[Parcelas] [tinyint] NULL,
	[Comissao] [numeric](6, 2) NULL,
	[NoDias] [tinyint] NULL,
	[Ativo] [bit] NULL,
 CONSTRAINT [PK_tblCaixaMovForma] PRIMARY KEY CLUSTERED 
(
	[IDMovForma] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_tblCaixaMovForma] UNIQUE NONCLUSTERED 
(
	[MovForma] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


