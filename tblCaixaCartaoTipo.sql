CREATE TABLE [dbo].[tblCaixaCartaoTipo](
	[IDCartaoTipo] [tinyint] IDENTITY(1,1) NOT NULL,
	[Cartao] [varchar](30) NOT NULL,
	[Ativo] [bit] NOT NULL,
 CONSTRAINT [PK_tblCaixaCartaoTipo] PRIMARY KEY CLUSTERED 
(
	[IDCartaoTipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tblCaixaCartaoTipo] ADD  CONSTRAINT [DF_tblCaixaCartaoTipo_Ativo]  DEFAULT ((1)) FOR [Ativo]
GO


