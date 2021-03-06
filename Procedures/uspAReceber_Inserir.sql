USE [NovaSiao]
GO
/****** Object:  StoredProcedure [dbo].[uspAReceber_Inserir]    Script Date: 06/12/2018 16:26:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--
-- ======================================================================================
-- Author:		Daniel
-- Create date: 17/07/2017
-- Alter date:  06/12/2018
-- Description:	Inserir Novo Registro de A Receber Transação | Financiamento
-- ======================================================================================

ALTER PROCEDURE [dbo].[uspAReceber_Inserir]
-- para tblAReceber
@IDOrigem AS INTEGER
,@Origem TINYINT
,@IDPessoa AS INTEGER = NULL
,@AReceberValor AS MONEY
,@IDFilial AS INTEGER

AS
BEGIN
	DECLARE @Situacao TINYINT = 0; -- Situacao EMABERTO
	DECLARE @Valor AS MONEY = 0; -- ValorPago inicial

	BEGIN TRAN
		BEGIN TRY
			-- Insert tblAReceber
			INSERT INTO tblAReceber
			(IDOrigem
			,Origem
			,IDFilial
			,IDPessoa
			,AReceberValor
			,ValorPagoTotal
			,SituacaoAReceber)
			VALUES
			(@IDOrigem
			,@Origem -- 1:Transacao 2:Refinanciamento
			,@IDFilial
			,@IDPessoa
			,@AReceberValor
			,@Valor
			,@Situacao);

			-- Retorna com o IDAReceberParcela SE HOUVER PARCELA		
			SELECT @@IDENTITY AS RETORNO;
		COMMIT TRAN;
		END TRY
	BEGIN CATCH
		ROLLBACK TRAN;
		SELECT ERROR_MESSAGE() AS RETORNO;
	END CATCH
END