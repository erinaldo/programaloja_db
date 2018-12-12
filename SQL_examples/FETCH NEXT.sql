-- DECLARA E SELECIONA O CURSOR
DECLARE @IDEntrada INT
DECLARE @Origem INT
DECLARE @IDOrigem INT
DECLARE @Descricao VARCHAR(100)
DECLARE @IDPessoa int
DECLARE @Cadastro VARCHAR(50)

DECLARE Item_Cursor CURSOR FOR
SELECT IDEntrada, Origem, IDOrigem, Descricao FROM tblEntradas
OPEN Item_Cursor

-- SELECIONA O PRIMEIRO REGISTRO DO CURSOR
FETCH NEXT FROM Item_Cursor INTO
@IDEntrada, @Origem, @IDOrigem, @Descricao



-- NAVEGA ENTRE TODOS OS REGISTROS DO CURSOR
WHILE @@FETCH_STATUS = 0
BEGIN

		-- 1:TRANSACAO | 2:ARECEBERPARCELA | 3:CREDITOS
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

				
	-- NAVEGA PARA O PROXIMO REGISTRO
	FETCH NEXT FROM Item_Cursor INTO
	@IDEntrada, @Origem, @IDOrigem, @Descricao

END

-- FECHA O CURSOR
CLOSE Item_Cursor
DEALLOCATE Item_Cursor


