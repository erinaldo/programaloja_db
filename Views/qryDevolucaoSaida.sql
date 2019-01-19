--

-- =============================================
-- Author:		Daniel
-- Create date: 19/01/2018
-- Alteracao:   19/01/2018
-- Description:	qryDevolucaoSaida
-- =============================================

CREATE VIEW qryDevolucaoSaida

AS
SELECT
-- tblDevolucaoSaida
D.IDDevolucao
,Filial.ApelidoFilial
,D.TotalDevolucao
,D.ValorProdutos
,D.ValorDescontos
,D.ValorAcrescimos
,D.IDAReceber
,D.Enviada
,D.Creditada
--
-- tblTransacao : O
,O.Observacao
--
-- tblTransacao : T
,T.IDPessoaDestino
,T.IDPessoaOrigem
,T.IDOperacao
,T.IDSituacao
,S.Situacao
,T.IDUser
,T.CFOP
,T.TransacaoData
--
-- tblAReceber : R
,R.SituacaoAReceber
,R.ValorPagoTotal
,R.IDCobrancaForma
,R.IDPlano
--
-- qryPessoaFisicaJuridica
,Fornecedor.Cadastro AS Cadastro
,Fornecedor.CNP
,Fornecedor.UF
,Fornecedor.Cidade
,Transportadora.Cadastro AS Transportadora
--
-- tblFrete: F
,F.IDTransportadora
,F.FreteTipo
,F.FreteValor
,F.Volumes
,F.IDAPagar
--
FROM tblDevolucaoSaida AS D
JOIN tblTransacao AS T
	ON D.IDDevolucao = T.IDTransacao
JOIN tblAReceber AS R
	ON D.IDAReceber = R.IDAReceber
LEFT JOIN tblFrete AS F
	ON D.IDDevolucao = F.IDTransacao
LEFT JOIN tblTransacaoSituacao AS S
	ON T.IDSituacao = S.IDSituacao
LEFT JOIN qryPessoaFisicaJuridica AS Fornecedor 
	ON T.IDPessoaDestino = Fornecedor.IDPessoa
LEFT JOIN qryPessoaFisicaJuridica AS Transportadora 
	ON F.IDTransportadora = Transportadora.IDPessoa
LEFT JOIN tblPessoaFilial AS Filial
	ON T.IDPessoaOrigem = Filial.IDFilial
LEFT JOIN tblObservacao AS O
	ON O.IDOrigem = D.IDDevolucao AND O.Origem = 12 --ORIGEM: tblDevolucaoSaida

GO


