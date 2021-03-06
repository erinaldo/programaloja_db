--

-- =============================================================
-- Author:			Daniel Ramos de Oliveira
-- Create date:		08/08/2017
-- Alteracao Data:	24/01/2019
-- Description:		FORNECEDOR ALTERAR
-- =============================================================

 ALTER PROCEDURE [dbo].[uspFornecedor_Alterar]

-- tblPessoa
--================================================
@IDPessoa AS INT,
@PessoaTipo as TINYINT = 1,
@Cadastro as VARCHAR(50), 

-- tblPessoaJuridica
--================================================
@CNPJ as VARCHAR(20),
@InscricaoEstadual as VARCHAR(20) = NULL,
@NomeFantasia as VARCHAR(50),
@FundacaoData as DATE = NULL,
@ContatoNome as VARCHAR(50) = NULL, 

-- tblPessoaEndereço
--================================================
@Endereco as varchar(50), 
@Bairro as varchar(30), 
@Cidade as varchar(50), 
@UF as char(2), 
@CEP as char(9), 

-- tblPessoaTelefone & tblPessoaEmail
--================================================
@TelefoneA as VARCHAR(15) = NULL, 
@TelefoneB as VARCHAR(15) = NULL, 
@Email as VARCHAR(100) = NULL,

-- tblPessoaFornecedor
--================================================
@Ativo as bit = 'TRUE',
@Vendedor AS VARCHAR(50),
@EmailVendas AS VARCHAR(100),
@Observacao as VARCHAR(MAX) = NULL

AS
BEGIN
	BEGIN TRY
		BEGIN TRAN
			-- ALTERA NO tblPessoaJuridica
			--======================================================
			EXEC uspPessoaJuridica_Alterar @IDPessoa, @Cadastro, @CNPJ, @InscricaoEstadual,
			@NomeFantasia, @FundacaoData, @ContatoNome, 
			@Endereco, @Bairro, @Cidade, @UF, @CEP,
			@TelefoneA, @TelefoneB, @Email, @IDPessoa OUTPUT;

			-- ALTERA NO tblPessoaFuncionario
			--======================================================
			UPDATE tblPessoaFornecedor SET
			Ativo = @Ativo
			, Vendedor = @Vendedor
			, EmailVendas = @EmailVendas
			WHERE IDFornecedor = @IDPessoa;

			-- ALTERA NO tblObservacao
			--======================================================
			DELETE tblObservacao
			WHERE Origem = 2 AND IDOrigem = @IDPessoa

			IF @Observacao IS NOT NULL AND LEN(@Observacao) > 0
				INSERT INTO tblObservacao
				(Origem
				,IDOrigem
				,Observacao)
				VALUES
				(2
				,@IDPessoa
				,@Observacao)

			-- RETORNO E COMMIT
			--======================================================
			SELECT @IDPessoa AS RETORNO;

		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() AS Retorno;
	END CATCH

END
