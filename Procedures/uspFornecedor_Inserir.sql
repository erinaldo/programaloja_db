--

-- =============================================================
-- Author:			Daniel Ramos de Oliveira
-- Create date:		08/08/2017
-- Alteracao Data:	24/01/2019
-- Description:		FORNECEDOR INSERIR
-- =============================================================

 ALTER PROCEDURE [dbo].[uspFornecedor_Inserir]

-- tblPessoa
--================================================
@Cadastro as VARCHAR(50), 
@PessoaTipo as TINYINT = 1,

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
@EmailVendas AS VARCHAR(100) = NULL,

-- tblObservacao
--================================================
@Observacao as VARCHAR(MAX) = NULL

AS
BEGIN
	BEGIN TRY
		BEGIN TRAN

			DECLARE @IDPessoa as INT;
			SELECT @IDPessoa = IDPessoa FROM tblPessoaJuridica WHERE CNPJ = @CNPJ;

			-- PROCURA PELO CPF NO TBLPESSOAJURIDICA
			IF @IDPessoa IS NULL
				BEGIN
					-- SE NÃO ENCONTRA ENTÃO INSERE NOVO REGISTRO TBLPESSOAJURIDICA
					EXEC uspPessoaJuridica_Inserir @Cadastro, @CNPJ, @InscricaoEstadual,
					@NomeFantasia, @FundacaoData, @ContatoNome, 
					@Endereco, @Bairro, @Cidade, @UF, @CEP,
					@TelefoneA, @TelefoneB, @Email, @IDPessoa OUTPUT;
				END
			ELSE -- se encontrar PROCURA COMO FORNECEDOR altera o registro SE NÃO ENCONTRAR
				BEGIN
					-- SE O FORNECEDOR JÁ É CADASTRADO COMO FORNECEDOR
					IF(EXISTS(SELECT IDFornecedor FROM tblPessoaFornecedor WHERE IDFornecedor = @IDPessoa))
						BEGIN
							RAISERROR('Essa Pessoa Jurídica já é cadastrada como FORNECEDOR', 14, 1)
						END
					ELSE
						EXEC uspPessoaJuridica_Alterar @IDPessoa, @Cadastro, @CNPJ, @InscricaoEstadual,
						@NomeFantasia, @FundacaoData, @ContatoNome, 
						@Endereco, @Bairro, @Cidade, @UF, @CEP,
						@TelefoneA, @TelefoneB, @Email, @IDPessoa OUTPUT;
				END

			-- INSERT NO tblPessoaFORNECEDOR
			--======================================================
			INSERT INTO tblPessoaFornecedor
			(IDFornecedor, Ativo, Vendedor, EmailVendas)
			VALUES
			(@IDPessoa, @Ativo, @Vendedor, @EmailVendas);

			-- INSERT NO tblObservacao
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
