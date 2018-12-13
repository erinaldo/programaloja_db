CREATE TABLE [dbo].[tblCaixaContas](
	[IDConta] [smallint] IDENTITY(1,1) NOT NULL,
	[IDFilial] [int] NOT NULL,
	[Conta] [varchar](50) NOT NULL,
	[Bancaria] [bit] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[BloqueioData] [smalldatetime] NULL,
 CONSTRAINT [PK_tblCaixaContas] PRIMARY KEY CLUSTERED 
(
	[IDConta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_tblCaixaContas] UNIQUE NONCLUSTERED 
(
	[Conta] ASC,
	[IDFilial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].tblCaixaContas ADD  CONSTRAINT [DF_tblCaixaContas_Bancaria]  DEFAULT ((0)) FOR [Bancaria]
GO

ALTER TABLE [dbo].tblCaixaContas ADD  CONSTRAINT [DF_tblCaixaContas_Ativo]  DEFAULT ((-1)) FOR [Ativo]
GO


