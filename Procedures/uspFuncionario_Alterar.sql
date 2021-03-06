--

-- =============================================================
-- Author:			Daniel Ramos de Oliveira
-- Create date:		17/06/2018
-- Alteracao Data:	02/02/2019
-- Description:		ALTERAR FUNCIONARIO
-- =============================================================

ALTER PROCEDURE [dbo].[uspFuncionario_Alterar]

-- tblPessoa
--================================================
@IDPessoa AS INT,
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
@Vendedor as bit,
@ApelidoFuncionario AS VARCHAR(30),
@IDFilial AS INT,

-- tblPessoaVendedor
--================================================
@ApelidoVenda as varchar(20) = NULL,
@Comissao as decimal(5,2) = NULL,
@VendaTipo as tinyint = NULL, -- 0:TODAS | 1:VAREJO | 2:ATACADO
@VendedorAtivo as BIT = 'TRUE'

AS
BEGIN
	BEGIN TRY
		BEGIN TRAN
			-- ALTERA NO tblPessoaFisica
			--======================================================
			EXEC uspPessoaFisica_Alterar @IDPessoa, @Cadastro, @CPF, @Sexo,
			@NascimentoData, @Identidade, @IdentidadeOrgao, @IdentidadeData,
			@Endereco, @Bairro, @Cidade, @UF, @CEP,
			@TelefoneA, @TelefoneB, @Email, @IDPessoa OUTPUT;
			
			-- ALTERA NO tblPessoaFuncionario
			--======================================================
			UPDATE tblPessoaFuncionario SET
			AdmissaoData = @AdmissaoData
			, Ativo = @Ativo
			, Vendedor = @Vendedor
			, ApelidoFuncionario = @ApelidoFuncionario
			, IDFilial = @IDFilial
			WHERE IDFuncionario = @IDPessoa;

			-- INSERT NO tblPessoaVendedor
			--======================================================
			-- verifica se existe alguma venda com esse vendedor
			IF @Vendedor = 'TRUE'
				IF EXISTS(SELECT IDVendedor FROM tblPessoaVendedor WHERE IDVendedor = @IDPessoa)
					UPDATE tblPessoaVendedor SET
					ApelidoVenda = @ApelidoVenda
					, Comissao = @Comissao
					, VendaTipo = @VendaTipo
					, Ativo = @VendedorAtivo
					WHERE IDVendedor = @IDPessoa;
				ELSE
					INSERT INTO tblPessoaVendedor
					(IDVendedor, ApelidoVenda, Comissao, VendaTipo, Ativo)
					VALUES
					(@IDPessoa, @ApelidoVenda, @Comissao, @VendaTipo, @Ativo);
			ELSE IF @Vendedor = 'FALSE'
				IF EXISTS(SELECT IDVendedor FROM tblVenda WHERE IDVendedor = @IDPessoa)
					UPDATE tblPessoaVendedor SET
					ApelidoVenda = @ApelidoVenda, Comissao = @Comissao,
					VendaTipo = @VendaTipo, Ativo = 'FALSE'
					WHERE IDVendedor = @IDPessoa;
				ELSE
					DELETE tblPessoaVendedor WHERE IDVendedor = @IDPessoa;

			SELECT @IDPessoa AS RETORNO;

		COMMIT TRAN;
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN;
		SELECT ERROR_MESSAGE() AS RETORNO;
	END CATCH

END
