USE [NovaSiao]
GO


-- =============================================================
-- Author:			Daniel
-- Create date:		03/11/2017
-- Alteracao Data:	10/12/2018
-- Description:		Inserir Quitação de A Receber Parcela
-- =============================================================

 ALTER PROCEDURE [dbo].[uspEntrada_Inserir]
 @Origem AS TINYINT -- 1:TRANSACAO | 2:ARECEBERPARCELA | 3:CREDITOS | 4: SIMPES SAIDA
 ,@IDOrigem AS INT
 ,@IDConta AS TINYINT
 ,@EntradaData AS DATE
 ,@EntradaValor AS MONEY
 ,@IDMovForma AS INT
 ,@Observacao AS VARCHAR(100) = NULL
 ,@Creditar AS BIT = 0
 ,@Descricao VARCHAR(100) = NULL
 AS
 BEGIN

 	BEGIN TRAN
		BEGIN TRY

			-- OBTEM A DESCRICAO SE FOR NULL
			IF @Descricao IS NULL
			BEGIN
				DECLARE @IDPessoa INT
				DECLARE @Cadastro VARCHAR(50)

				-- 1:TRANSACAO | 2:ARECEBERPARCELA | 3:CREDITOS | 4: SIMPES SAIDA
				IF @Origem = 1 -- TRANSACAO | VENDA
					BEGIN
						SET @Descricao = 'Venda à vista' + ' ' +  dbo.ID0000(@IDOrigem)
					END
				ELSE IF @Origem = 2  -- A RECEBER PARCELA
					BEGIN
						-- OBTER O IDPESSOA
						SELECT @IDPessoa = IDPessoa 
						FROM tblAReceber
						WHERE IDAReceber = (SELECT IDAReceber FROM tblAReceberParcela WHERE IDAReceberParcela = @IDOrigem)
						
						SELECT @Cadastro = Cadastro
						FROM tblPessoa
						WHERE IDPessoa = @IDPessoa

						SET @Descricao = 'PARC-' + dbo.ID0000(@IDOrigem) + ' - ' + @Cadastro
					END
				ELSE IF @Origem = 3
					BEGIN
						SET @Descricao = 'Créditos ID: ' + dbo.ID0000(@IDOrigem)
					END
				ELSE IF @Origem = 4 --- SIMPLES SAIDA
					BEGIN
						-- OBTER O IDPESSOA ORIGEM
						SELECT @IDPessoa = IDPessoaDestino 
						FROM tblTransacao
						WHERE IDTransacao = @IDOrigem
						
						SELECT @Cadastro = ApelidoFilial
						FROM tblPessoaFilial
						WHERE IDFilial = @IDPessoa

						SET @Descricao = 'SIMPLES-' + dbo.ID0000(@IDOrigem) + ' - ' + @Cadastro
					END
			END
	
			-- INSERE O REGISTRO
			INSERT INTO tblEntradas
			(Origem
			,IDOrigem
			,IDConta
			,EntradaData
			,EntradaValor
			,IDMovForma
			,Creditar
			,Descricao)
			VALUES
			(@Origem
			,@IDOrigem
			,@IDConta
			,@EntradaData
			,@EntradaValor
			,@IDMovForma
			,@Creditar
			,@Descricao)

			DECLARE @ID INT = @@IDENTITY

			-- INSERE A OBERVACAO SE NECESSARIO
			IF LEN(@Observacao) > 0 
				INSERT INTO tblObservacao
				(IDOrigem
				,Origem
				,Observacao)
				VALUES
				(@ID
				,3 -- origem TBLENTRADA
				,@Observacao);

		COMMIT TRAN
			--- RETURN
			SELECT @ID AS RETORNO

	END TRY

	BEGIN CATCH
		ROLLBACK TRAN;
		SELECT ERROR_MESSAGE() AS RETORNO;
	END CATCH

 END