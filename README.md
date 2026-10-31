# TCC_DanyelNunes
Experimentos de otimização de consultas SQL em base de grande volumetria

# TCC - Otimização de consultas SQL em base de grande volumetria

Este repositório reúne os objetos de banco utilizados no experimento do Trabalho de Conclusão de Curso sobre técnicas de otimização de consultas no Microsoft SQL Server.

O estudo foi realizado sobre uma base corporativa de grande volumetria do setor de seguros. Por questões de confidencialidade, nenhum dado empresarial ou informação pessoal é disponibilizado neste repositório.

## Objetivo

Avaliar o impacto de diferentes técnicas de otimização de consultas SQL utilizando métricas de desempenho coletadas diretamente no Microsoft SQL Server.

## Ambiente experimental

- Microsoft SQL Server Enterprise Edition 64 bits
- Versão 15.0.4500.2
- CU32
- 32 CPUs lógicas
- Aproximadamente 256 GB de memória RAM
- Compatibility Level 150

A base utilizada possui aproximadamente:

- 980 milhões de registros na tabela `documento_Tb`
- 1,5 bilhão de registros na tabela `documento_pessoas_tb`

## Cenários avaliados

- C1 - Consulta-base na configuração original
- C2 - Reescrita para SARGabilidade
- C3 - Índice composto
- C4 - Índice de cobertura
- C5 - Subconsulta correlacionada versus CTE + JOIN
- C6 - Consulta direta versus tabela temporária indexada

## Métricas coletadas

Foram analisadas as seguintes métricas:

- tempo de execução
- tempo de CPU
- leituras lógicas
- leituras físicas
- plano de execução real

Cada cenário foi executado três vezes e os valores médios foram utilizados para comparação.

## Estrutura do repositório

`sql/`  
Contém os scripts utilizados nos cenários experimentais.

`planos-execucao/`  
Contém os planos de execução gerados pelo SQL Server.

`resultados/`  
Contém a planilha de coleta, os resultados consolidados e os gráficos.

`docs/`  
Contém documentação complementar sobre o experimento e as métricas utilizadas.

## Confidencialidade

Este repositório não contém dados reais da empresa, informações pessoais, credenciais, backups ou arquivos de banco de dados.

Os artefatos disponibilizados têm finalidade exclusivamente acadêmica e de documentação do experimento.
