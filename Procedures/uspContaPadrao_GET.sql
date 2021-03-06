USE [NovaSiao]
GO
/****** Object:  StoredProcedure [dbo].[uspContaPadrao_GET]    Script Date: 15/12/2018 17:33:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Daniel
-- Create date: 24/02/2018
-- Alter date:  15/12/2018
-- Description:	Obter os Dados Iniciais da Conta Padrão
-- =============================================
ALTER PROCEDURE [dbo].[uspContaPadrao_GET] 
	-- Add the parameters for the stored procedure here
	@IDConta TINYINT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF NOT EXISTS(SELECT * FROM tblCaixaContas)
		BEGIN
			RAISERROR('Não existe nenhuma CONTA inserida, comunique ao administrador do sistema', 14, 1)
			RETURN
		END

    -- Insert statements for procedure here
	SELECT 
	C.IDConta
	, C.Conta
	, C.BloqueioData
	, C.IDFilial
	, F.ApelidoFilial
	FROM tblCaixaContas AS C
	JOIN tblPessoaFilial AS F
	ON F.IDFilial = C.IDFilial
	WHERE IDConta = @IDConta
END
