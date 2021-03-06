--


-- =============================================
-- Author:		Daniel
-- Create date: 10/07/2017
-- Alter date:	15/01/2019
-- Description:	Editar Item de Transacao
-- =============================================

ALTER PROCEDURE [dbo].[uspTransacaoItem_Editar]
	-- PARÂMENTROS LISTA
	@IDTransacaoItem AS INT
	--,@IDTransacao AS INT 
	,@IDProduto AS INT
	,@Quantidade AS INT
	,@Preco AS MONEY
	,@Desconto AS NUMERIC(5,2) = 0
	,@IDFilial AS INT
	,@Movimento AS CHAR(1)
	,@MovData AS DATE
	-- variavel que verifica se havera insercao no tblTransacaoItensCustos
	,@InsereCustos AS BIT
	-- itens do	tblTransacaoItensCustos
	,@FreteRateado AS MONEY = 0
	,@Substituicao AS MONEY = 0
	,@ICMS AS DECIMAL(5,2) = 0
	,@MVA AS DECIMAL(5,2) = 0
	,@IPI AS DECIMAL(5,2) = 0
AS
BEGIN
	BEGIN TRAN
		BEGIN TRY
			DECLARE @IDProdutoAnterior AS INT;
			DECLARE @QuantAnterior AS INT;

			-- VERIFICA O REGISTRO ANTERIOR (QUANTIDADE E PRODUTO)
			/**********************************************************/
			SELECT 
			@IDProdutoAnterior = IDProduto
			,@QuantAnterior = Quantidade
			FROM tblTransacaoItens
			WHERE IDTransacaoItem = @IDTransacaoItem

			-- RETORNA COM O ESTOQUE ANTERIOR (PRODUTO E QUANTIDADE ANTERIOR)
			/**********************************************************/
			UPDATE tblEstoque 
			SET Quantidade = CASE @Movimento 
							 WHEN 'E' THEN (Quantidade - @QuantAnterior) 
							 WHEN 'S' THEN (Quantidade + @QuantAnterior) 
							 END 

			-- UPDATE NA tblTransacaoItens
			/**********************************************************/
			UPDATE tblTransacaoItens SET
			IDProduto = @IDProduto
			,Quantidade = @Quantidade
			,Preco = @Preco
			,Desconto = @Desconto
			WHERE IDTransacaoItem = @IDTransacaoItem

			-- UPDATE NA tblTransacaoItensCustos
			/**********************************************************/
			IF @InsereCustos = 'TRUE'
				UPDATE tblTransacaoItensCustos SET
				FreteRateado = @FreteRateado
				,Substituicao = @Substituicao
				,ICMS = @ICMS
				,MVA = @MVA
				,IPI = @IPI
				WHERE IDTransacaoItem = @IDTransacaoItem
			
			-- Alterar a Quantidade no Estoque na tblEstoque
			/**********************************************************/
			UPDATE tblEstoque 
			SET Quantidade = CASE @Movimento 
							WHEN 'E' THEN (Quantidade + @Quantidade) 
							WHEN 'S' THEN (Quantidade - @Quantidade) 
							END 
			WHERE IDProduto = @IDProduto AND IDFilial = @IDFilial

			-- Insere o registro de tblEstoqueMovimento
			/**********************************************************/
			-- exclui o movimento anterior
			DELETE tblEstoqueMovimentado
			WHERE IDTransacaoItem = @IDTransacaoItem

			-- insere um novo movimento
			INSERT INTO tblEstoqueMovimentado
			(IDProduto
			,IDFilial
			,IDTransacaoItem
			,EstoqueData
			,Quantidade)
			VALUES
			(@IDProduto
			,@IDFilial
			,@IDTransacaoItem
			,@MovData
			,CASE @Movimento -- estoque reservado
				WHEN 'E' THEN @Quantidade
				WHEN 'S' THEN @Quantidade * -1
				ELSE 0 END);

			-- CONCLUSAO
			/**********************************************************/
			COMMIT TRAN;
			SELECT @IDTransacaoItem AS RETORNO;

		END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() AS RETORNO
	END CATCH	
END