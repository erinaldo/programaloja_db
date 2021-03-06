USE [NovaSiao]
GO


-- =============================================================
-- Author:			Daniel
-- Create date:		10/12/2018
-- Alteracao Data:	11/12/2018
-- Description:		Inserir Quitação de Simples Saida / Entrada
-- =============================================================

ALTER PROCEDURE [dbo].[uspSimplesSaida_AReceber_Quitar]
@IDFilialCreditada INT
,@IDContaCreditada INT
,@IDFilialDebitada INT
,@IDContaDebitada INT
,@ValorRecebido MONEY
,@EntradaData DATE
,@Observacao VARCHAR(MAX) = ''

AS
BEGIN

	DECLARE @ValorASerRecebido MONEY;
	DECLARE @IDAReceberParcela INT;
	DECLARE @IDAReceber INT;
	DECLARE @ParcelaValor MONEY;
	DECLARE @ValorPagoParcela MONEY;
	DECLARE @AReceberValor MONEY;
	DECLARE @ValorPagoTotal MONEY;
	DECLARE @IDOrigem INTEGER; -- o Registro da Origem

	DECLARE @NovaSituacaoParcela TINYINT = 0; -- Situacao EMABERTO
	DECLARE @NovaSituacaoAReceber TINYINT = 0; -- Situacao EMABERTO

	BEGIN TRAN
		BEGIN TRY

		DECLARE @ValorRecebidoRestante MONEY;
		SET @ValorRecebidoRestante = @ValorRecebido
			
		--===================================================================================
		-- GERA O RECEBIMENTO: TBLARECEBERPARCELA | TBLARECEBER
		--===================================================================================
		DECLARE Item_Cursor_CRED CURSOR FOR
		SELECT IDAReceberParcela
			, IDAReceber
			, ParcelaValor
			, ValorPagoParcela
			, AReceberValor
			, ValorPagoTotal 
			, IDOrigem
			FROM qryAReceberParcela 
			WHERE Origem = 3 AND SituacaoParcela = 0 
			AND IDFilial = @IDFilialCreditada 
			AND IDPessoa = @IDFilialDebitada
			ORDER BY Vencimento

		OPEN Item_Cursor_CRED

		-- SELECIONA O PRIMEIRO REGISTRO DO CURSOR
		FETCH NEXT FROM Item_Cursor_CRED INTO
			@IDAReceberParcela
			, @IDAReceber
			, @ParcelaValor
			, @ValorPagoParcela
			, @AReceberValor
			, @ValorPagoTotal
			, @IDOrigem
		
		-- NAVEGA ENTRE TODOS OS REGISTROS DO CURSOR
		WHILE @@FETCH_STATUS = 0
		BEGIN

			--==================================================================================
			-- ATUALIZA / QUITA A tblAReceberParcela
			--==================================================================================
			-- VERIFICA se toda a Parcela foi recebida quando entrar o @ValorRecebido
			IF @ValorRecebidoRestante >= @ParcelaValor - @ValorPagoParcela
			BEGIN
				SET @NovaSituacaoParcela = 1; -- Situacao QUITADA
				SET @ValorASerRecebido = @ParcelaValor - @ValorPagoParcela
			END
			ELSE
			BEGIN
				SET @NovaSituacaoParcela = 0; -- Situacao EMABERTO
				SET @ValorASerRecebido = @ValorRecebidoRestante
			END

			-- ATUALIZA O tblAReceberParcela
			UPDATE tblAReceberParcela SET
			ValorPagoParcela = COALESCE(ValorPagoParcela, 0) + @ValorASerRecebido
			,ValorJuros =  0
			,SituacaoParcela = @NovaSituacaoParcela
			,PagamentoData = @EntradaData
			WHERE IDAReceberParcela = @IDAReceberParcela;

			--==================================================================================
			-- ATUALIZA / QUITA A tblAReceber
			--==================================================================================
			-- VERIFICA se todo o AReceber foi recebido quando entrar o @ValorRecebidoParcela
			IF @ValorRecebidoRestante >= @AReceberValor - @ValorPagoTotal
				SET @NovaSituacaoAReceber = 1; -- Situacao QUITADA
			ELSE
				SET @NovaSituacaoAReceber = 0; -- Situacao EMABERTO

			-- Atualiza a tblAReceber
			UPDATE tblAReceber SET
			ValorPagoTotal = ValorPagoTotal + @ValorASerRecebido
			,SituacaoAReceber = @NovaSituacaoAReceber
			WHERE IDAReceber = @IDAReceber;

			--===================================================================================
			-- BLOQUEIA a SIMPLES se ha PARCELAS quitadas
			--===================================================================================
			UPDATE tblTransacao SET
			IDSituacao = 3 -- situacao BLOQUEADA
			WHERE IDTransacao = @IDOrigem

			--===================================================================================
			-- GERA A ENTRADA DO RECEBIMENTO NA CONTA INFORMADA
			--===================================================================================
			DECLARE @FilialDebitada VARCHAR(50)
			DECLARE @Descricao VARCHAR(100) = NULL

			-- OBTER O APELIDO DA FILIAL DEBITADA|ORIGEM
			SELECT @FilialDebitada = ApelidoFilial
			FROM tblPessoaFilial
			WHERE IDFilial = @IDFilialDebitada

			SET @Descricao = 'SIMPLES-' + dbo.ID0000(@IDOrigem) + ' - ' + @FilialDebitada
	
			-- INSERE O REGISTRO TBLENTRADA
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
			(4
			,@IDOrigem
			,@IDContaCreditada
			,@EntradaData
			,@ValorASerRecebido
			,1
			,'FALSE'
			,@Descricao)

			DECLARE @ID INT = @@IDENTITY

			--===================================================================================
			-- INSERE A OBERVACAO SE NECESSARIO
			--===================================================================================
			IF LEN(@Observacao) > 0 
				INSERT INTO tblObservacao
				(IDOrigem
				,Origem
				,Observacao)
				VALUES
				(@ID
				,3 -- origem TBLENTRADA
				,@Observacao);

			--===================================================================================
			-- CALCULA O VALOR RESTANTE A SER RECEBIDO
			--===================================================================================
			-- SUBTRAI O VALOR QUE JA FOI RECEBIDO: CALCULA O VALOR RESTANTE
			SET @ValorRecebidoRestante = @ValorRecebidoRestante - @ValorASerRecebido

			-- VERIFICA O VALOR RESTANTE A SER RECEBIDO
			IF @ValorRecebidoRestante <= 0
				BREAK
				
			--===================================================================================
			-- NAVEGA PARA O PROXIMO REGISTRO
			--===================================================================================
			FETCH NEXT FROM Item_Cursor_CRED INTO
			@IDAReceberParcela
			, @IDAReceber
			, @ParcelaValor
			, @ValorPagoParcela
			, @AReceberValor
			, @ValorPagoTotal
			, @IDOrigem
			
		END

		-- FECHA O CURSOR
		CLOSE Item_Cursor_CRED
		DEALLOCATE Item_Cursor_CRED


		--===================================================================================
		-- GERA O PAGAMENTO: TBLAPAGAR --> ATUALIZA / QUITA
		--===================================================================================
		DECLARE @ValorASerPago MONEY;
		DECLARE @ValorPagoRestante MONEY;
		SET @ValorPagoRestante = @ValorRecebido
		
		DECLARE @IDAPagar INT;
		DECLARE @APagarValor MONEY;
		DECLARE @ValorPago MONEY;
		DECLARE @IDOrigem_DEB AS INT;
		DECLARE @Cadastro AS VARCHAR(50);
		DECLARE @NovaSituacaoAPagar AS TINYINT;

		DECLARE Item_Cursor_DEB CURSOR FOR
		SELECT IDAPagar
			, APagarValor
			, ValorPago
			, IDOrigem
			, Cadastro
			FROM qryAPagar 
			WHERE Origem = 4 AND Situacao = 0 
			AND IDFilial = @IDFilialDebitada
			AND IDPessoa = @IDFilialCreditada 
			ORDER BY Vencimento

		OPEN Item_Cursor_DEB

		-- SELECIONA O PRIMEIRO REGISTRO DO CURSOR
		FETCH NEXT FROM Item_Cursor_DEB INTO
			@IDAPagar
			, @APagarValor
			, @ValorPago
			, @IDOrigem_DEB
			, @Cadastro
		
		-- NAVEGA ENTRE TODOS OS REGISTROS DO CURSOR
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- Verifica se o valor Pago é igual ao valor EmAberto
			IF @ValorPagoRestante >= @APagarValor - @ValorPago
				BEGIN
					SET @NovaSituacaoAPagar = 1; -- Situacao QUITADA
					SET @ValorASerPago = @APagarValor - @ValorPago
				END
			ELSE
				BEGIN
					SET @NovaSituacaoAPagar = 0; -- Situacao EMABERTO
					SET @ValorASerPago = @ValorPagoRestante
				END

			-- Atualiza a tblAPagar
			UPDATE tblAPagar SET
			ValorPago = COALESCE(ValorPago, 0) + @ValorASerPago
			,Acrescimo =  0
			,Situacao = @NovaSituacaoAPagar
			,PagamentoData = @EntradaData
			WHERE IDAPagar = @IDAPagar;

			--===================================================================================
			-- INSERE no tblSAIDA e no tblObservacao
	  		--===================================================================================
			SET @Descricao = 'PAG-' + dbo.id0000(@IDAPagar) + ' - ' + @Cadastro
		
			INSERT INTO tblSaidas
			(Origem
			,IDOrigem
			,IDConta
			,IDMovForma
			,SaidaData
			,SaidaValor
			,Creditar
			,Descricao)
			VALUES
			(1
			,@IDAPagar
			,@IDContaDebitada
			,1
			,@EntradaData
			,@ValorASerPago
			,'FALSE'
			,@Descricao)
		
			---RETORNO

			 DECLARE @IDSaida INT = @@IDENTITY

			 IF LEN(@Observacao) > 0 
		 		 INSERT INTO tblObservacao
				 (IDOrigem
				 ,Origem
				 ,Observacao)
				 VALUES
				 (@IDSaida
				 ,4 -- origem TBLSAIDA
				 ,@Observacao);

			--===================================================================================
			-- NAVEGA PARA O PROXIMO REGISTRO
			--===================================================================================
			FETCH NEXT FROM Item_Cursor_DEB INTO
			@IDAPagar
			, @APagarValor
			, @ValorPago
			, @IDOrigem_DEB
			, @Cadastro
			
		END

		-- FECHA O CURSOR
		CLOSE Item_Cursor_DEB
		DEALLOCATE Item_Cursor_DEB

		--===================================================================================
		-- FINALIZA
		--===================================================================================
		COMMIT TRAN;

		-- Retorna com o IDAReceberParcela SE HOUVER PARCELA		
		SELECT 'TRUE' AS RETORNO;
		
		END TRY

	BEGIN CATCH
		ROLLBACK TRAN;
		SELECT ERROR_MESSAGE() AS RETORNO;
	END CATCH

	--===================================================================================
	-- FECHA OS CURSORS CASO ABERTO
	--===================================================================================
	BEGIN TRY
        --CLOSE DEALOCATE CURSORS              
        CLOSE Item_Cursor_CRED
        DEALLOCATE Item_Cursor_CRED
		CLOSE Item_Cursor_DEB
        DEALLOCATE Item_Cursor_DEB                                  
    END TRY
    BEGIN CATCH
        --do nothing
    END CATCH


END