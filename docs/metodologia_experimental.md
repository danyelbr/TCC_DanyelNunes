# Metodologia experimental

## 1. Caracterização do experimento

O estudo possui abordagem quantitativa e caráter experimental, com foco na avaliação de técnicas de otimização de consultas no Microsoft SQL Server.

Os testes foram realizados sobre uma base corporativa de grande volumetria do setor de seguros.

Por questões de confidencialidade, o repositório não contém dados reais, informações pessoais, credenciais ou arquivos do banco de dados.

---

## 2. Ambiente

O ambiente utilizado nos experimentos possui as seguintes características:

- Microsoft SQL Server Enterprise Edition 64 bits;
- versão 15.0.4500.2;
- atualização CU32;
- 32 CPUs lógicas;
- aproximadamente 256 GB de memória RAM;
- nível de compatibilidade 150.

---

## 3. Base experimental

Os testes utilizaram principalmente as tabelas:

- `documento_Tb`;
- `documento_pessoas_tb`.

A tabela `documento_Tb` possui aproximadamente 980 milhões de registros.

A tabela `documento_pessoas_tb` possui aproximadamente 1,5 bilhão de registros.

As tabelas são relacionadas pelo campo `documento_id`.

Entre os atributos utilizados nas consultas estão:

- `dt_documento`;
- `estado_risco`;
- `cod_ramo`;
- `tp_pessoa`.

O período analisado nos experimentos corresponde ao ano de 2025.

---

## 4. Cenários avaliados

Foram definidos seis cenários principais:

- C1 - consulta-base na configuração original;
- C2 - reescrita para SARGabilidade;
- C3 - criação de índice composto;
- C4 - criação de índice de cobertura;
- C5 - comparação entre subconsulta correlacionada e CTE + JOIN;
- C6 - comparação entre consulta direta e tabela temporária indexada.

Os scripts utilizados estão disponíveis na pasta `sql/`.

---

## 5. Procedimento de execução

Os testes foram realizados no mesmo ambiente, mantendo o mesmo período de dados e o mesmo procedimento de coleta.

Cada cenário foi executado três vezes.

Para obtenção das métricas foram utilizados os comandos:

```sql id="bk0fwj"
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
```

Também foi utilizado o plano de execução real do SQL Server em cada cenário.

Os planos estão disponíveis na pasta `planos-execucao/`.

---

## 6. Métricas

Foram coletadas as seguintes informações:

- tempo de execução;
- tempo de CPU;
- leituras lógicas;
- leituras físicas;
- plano de execução real.

Os valores das três execuções foram registrados separadamente.

Para a comparação quantitativa entre os cenários, foi utilizada a média aritmética das execuções.

A definição e o critério de consolidação de cada métrica estão descritos no arquivo:

`docs/dicionario_metricas.md`

---

## 7. Estratégia de comparação

O cenário C1 foi utilizado como referência inicial.

Os cenários C2, C3 e C4 representam alterações progressivas sobre a consulta e sobre as estruturas de acesso utilizadas pelo SQL Server.

No cenário C5, a comparação foi realizada entre duas formas de implementação da mesma necessidade de consulta:

- C5-A - subconsultas correlacionadas;
- C5-B - CTE + JOIN.

No cenário C6, foram comparadas:

- C6-A - execução direta;
- C6-B - materialização intermediária em tabela temporária indexada.

A análise não considerou apenas o tempo total de execução. Também foram observados o consumo de CPU, a quantidade de leituras e as alterações identificadas nos planos de execução.

---

## 8. Resultados

Os resultados consolidados estão disponíveis na pasta `resultados/`.

A planilha contém os valores coletados durante as execuções e as médias utilizadas na análise.

Os gráficos apresentam a comparação dos principais indicadores:

- tempo médio de execução;
- tempo médio de CPU;
- leituras lógicas médias;
- redução do tempo de execução.

Uma descrição dos resultados de cada cenário está disponível em:

`docs/relatorio_experimento.md`

---

## 9. Limitações

Os resultados são específicos do ambiente e da base utilizados no experimento.

O comportamento das técnicas pode variar de acordo com fatores como:

- volume e distribuição dos dados;
- índices já existentes;
- configuração do SQL Server;
- recursos de hardware disponíveis;
- estado do cache;
- nível de concorrência;
- características da consulta analisada.

Por esse motivo, os resultados não devem ser interpretados como garantia de desempenho em outros ambientes.

As técnicas devem ser testadas e avaliadas de acordo com o contexto em que serão aplicadas.