CREATE TABLE [dbo].[tblCaixaMovForma](
	[IDMovForma] [smallint] IDENTITY(1,1) NOT NULL,
	[MovForma] [varchar](30) NOT NULL,
	[IDMovTipo] [smallint] NOT NULL,
	[IDCartaoTipo] [tinyint] NULL,
	[Parcelas] [tinyint] NULL,
	[Comissao] [numeric](6, 2) NULL,
	[NoDias] [tinyint] NULL,
	[Ativo] [bit] NOT NULL,
	[IDFilial] [int] NOT NULL,
	[IDContaPadrao] [smallint] NULL,
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

ALTER TABLE [dbo].[tblCaixaMovForma] ADD  CONSTRAINT [DF_tblCaixaMovForma_Ativo]  DEFAULT ('TRUE') FOR [Ativo]
GO

ALTER TABLE [dbo].[tblCaixaMovForma]  WITH CHECK ADD  CONSTRAINT [FK_tblCaixaMovForma_tblCaixaCartaoTipo] FOREIGN KEY([IDCartaoTipo])
REFERENCES [dbo].[tblCaixaCartaoTipo] ([IDCartaoTipo])
GO

ALTER TABLE [dbo].[tblCaixaMovForma] CHECK CONSTRAINT [FK_tblCaixaMovForma_tblCaixaCartaoTipo]
GO

ALTER TABLE [dbo].[tblCaixaMovForma]  WITH CHECK ADD  CONSTRAINT [FK_tblCaixaMovForma_tblCaixaMovFormaTipo] FOREIGN KEY([IDMovTipo])
REFERENCES [dbo].[tblCaixaMovFormaTipo] ([IDMovTipo])
GO

ALTER TABLE [dbo].[tblCaixaMovForma] CHECK CONSTRAINT [FK_tblCaixaMovForma_tblCaixaMovFormaTipo]
GO


