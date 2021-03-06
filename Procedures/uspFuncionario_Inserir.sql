--

-- =============================================================
-- Author:			Daniel Ramos de Oliveira
-- Create date:		17/06/2017
-- Alteracao Data:	02/02/2019
-- Description:		INSERIR FUNCIONARIO
-- =============================================================

ALTER PROCEDURE [dbo].[uspFuncionario_Inserir]

-- tblPessoa
--================================================
@PessoaTipo as TINYINT = 1,

-- tblPessoaFisica
--================================================
@Cadastro as VARCHAR(50), 
@CPF as VARCHAR(14),
@Sexo as BIT,
@NascimentoData as DATE,
@Identidade as VARCHAR(20) = NULL, 
@IdentidadeOrgao as VARCHAR(10) = NULL, 
@IdentidadeData as DATE = NULL,

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

-- tblPessoaFuncionario
--================================================
@AdmissaoData as DATE = null, 
@Ativo as bit = 'TRUE',
@Vendedor as bit = 'FALSE',
@ApelidoFuncionario AS VARCHAR(30),
@IDFilial AS INT,

-- tblPessoaVendedor
--================================================
@ApelidoVenda as varchar(20) = NULL,
@Comissao as decimal(5,2) = NULL,
@VendaTipo as tinyint = NULL, -- 0:TODAS | 1:VAREJO | 2:ATACADO
@VendedorAtivo AS BIT = 'TRUE'

AS
BEGIN
	BEGIN TRY
		BEGIN TRAN

			DECLARE @IDPessoa as INT;
			SELECT @IDPessoa = IDPessoa FROM tblPessoaFisica WHERE CPF = @CPF

			-- PROCURA PELO CPF NO TBLPESSOAFISICA
			IF @IDPessoa IS NULL
				BEGIN
					-- SE NÃO ENCONTRA ENTÃO INSERE NOVO REGISTRO TBLPESSOAFISICA
					EXEC uspPessoaFisica_Inserir @Cadastro, @CPF, @Sexo, @NascimentoData,
					@Identidade, @IdentidadeOrgao, @IdentidadeData,
					@Endereco, @Bairro, @Cidade, @UF, @CEP,
					@TelefoneA, @TelefoneB, @Email, @IDPessoa OUTPUT;
				END
			ELSE -- se encontrar altera o registro SE NÃO É CADASTRADO COMO FUNCIONARIO
				BEGIN
					-- SE O FUNCIONARIO JÁ É CADASTRADO COMO FUNCIONARIO
					IF(EXISTS(SELECT IDFuncionario FROM tblPessoaFuncionario WHERE IDFuncionario = @IDPessoa))
						BEGIN
							RAISERROR('Essa Pessoa Física já é cadastrado como Funcionario', 14, 1)
						END
					ELSE
						EXEC uspPessoaFisica_Alterar @IDPessoa, @Cadastro, @CPF, @Sexo,
						@NascimentoData, @Identidade, @IdentidadeOrgao, @IdentidadeData,
						@Endereco, @Bairro, @Cidade, @UF, @CEP,
						@TelefoneA, @TelefoneB, @Email, @IDPessoa OUTPUT;
				END


			-- INSERT NO tblPessoaFuncionario
			--======================================================
			INSERT INTO tblPessoaFuncionario
			( IDFuncionario
			, AdmissaoData
			, Ativo
			, Vendedor
			, ApelidoFuncionario
			, IDFilial )
			VALUES
			( @IDPessoa
			, @AdmissaoData
			, @Ativo
			, @Vendedor
			, @ApelidoFuncionario
			, @IDFilial );

			-- INSERT NO tblPessoaVendedor
			--======================================================
			IF @Vendedor = 'TRUE'
			INSERT INTO tblPessoaVendedor
			(IDVendedor, ApelidoVenda, Comissao, VendaTipo, Ativo)
			VALUES
			(@IDPessoa, @ApelidoVenda, @Comissao, @VendaTipo, @VendedorAtivo);

			SELECT @IDPessoa AS RETORNO;

		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() AS Retorno;
	END CATCH

END
