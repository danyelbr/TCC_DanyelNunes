# Relatório do experimento

## 1. Objetivo

Este documento resume os experimentos realizados para avaliar técnicas de otimização de consultas no Microsoft SQL Server sobre uma base corporativa de grande volumetria do setor de seguros.

Os testes foram executados principalmente sobre as tabelas `documento_Tb` e `documento_pessoas_tb`, com aproximadamente 980 milhões e 1,5 bilhão de registros, respectivamente.

Por questões de confidencialidade, este repositório não contém dados reais da empresa.

---

## 2. Métricas coletadas

Em todos os cenários foram coletadas as seguintes métricas:

- tempo de execução;
- tempo de CPU;
- leituras lógicas;
- leituras físicas;
- plano de execução real.

Cada cenário foi executado três vezes e os valores médios foram utilizados para comparação.

Os comandos utilizados para coleta foram:

```sql
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
```

Os planos de execução estão disponíveis na pasta `planos-execucao/`.

---

## 3. Cenários experimentais

### C1 - Consulta-base

**Objetivo:** estabelecer o cenário inicial de referência.

A consulta utiliza funções diretamente nas colunas empregadas nos filtros, reduzindo a possibilidade de aproveitamento eficiente das estruturas de acesso disponíveis.

**Resultado médio:**

- Tempo: 200,84 s
- CPU: 553,72 s
- Leituras lógicas: 33.866.523
- Leituras físicas: 2.884

Arquivo SQL:

`sql/C1_consulta_base.sql`

---

### C2 - Reescrita para SARGabilidade

**Objetivo:** avaliar o impacto da reescrita dos filtros.

Foram removidas funções aplicadas diretamente às colunas utilizadas na cláusula `WHERE`, substituindo-as por predicados compatíveis com uma execução mais eficiente.

**Resultado médio:**

- Tempo: 170,34 s
- CPU: 322,83 s
- Leituras lógicas: 33.159.035
- Leituras físicas: 1.834

Em relação ao C1, houve redução aproximada de 15% no tempo de execução e de 42% no tempo de CPU.

Arquivo SQL:

`sql/C2_sargabilidade.sql`

---

### C3 - Índice composto

**Objetivo:** avaliar o efeito da criação de um índice composto voltado às colunas utilizadas nos filtros e agrupamentos.

Foi criado um índice sobre as colunas `estado_risco`, `dt_documento` e `cod_ramo`.

**Resultado médio:**

- Tempo: 170,60 s
- CPU: 329,98 s
- Leituras lógicas: 33.159.428
- Leituras físicas: 1.828

O desempenho permaneceu muito próximo ao cenário C2. A análise do plano mostrou que o índice criado não apresentou ganho relevante para essa consulta.

Arquivo SQL:

`sql/C3_indice_composto.sql`

---

### C4 - Índice de cobertura

**Objetivo:** avaliar se um índice de cobertura poderia reduzir as leituras realizadas na tabela de pessoas.

Foi criado um índice sobre `DOCUMENTO_ID` com inclusão da coluna `tp_pessoa`.

**Resultado médio:**

- Tempo: 23,66 s
- CPU: 148,06 s
- Leituras lógicas: 4.441.172

Este cenário apresentou uma redução expressiva nas leituras lógicas e no tempo de execução quando comparado aos cenários anteriores.

Arquivo SQL:

`sql/C4_indice_cobertura.sql`

---

### C5 - Subconsulta correlacionada versus CTE + JOIN

**Objetivo:** comparar duas formas de construção de uma consulta equivalente.

#### C5-A - Subconsulta correlacionada

A primeira versão utiliza subconsultas para obtenção das contagens.

Arquivo SQL:

`sql/C5A_subconsulta.sql`

#### C5-B - CTE + JOIN

A versão otimizada utiliza CTEs, agregações prévias e operações de `JOIN`.

**Resultado médio utilizado na comparação geral:**

- Tempo: 17,60 s
- CPU: 118,52 s
- Leituras lógicas: 3.224.531
- Leituras físicas: 0

O C5 apresentou o menor tempo médio, menor consumo de CPU e menor número de leituras lógicas entre os cenários consolidados.

Arquivo SQL:

`sql/C5B_cte_join.sql`

---

### C6 - Consulta direta versus tabela temporária indexada

**Objetivo:** avaliar se a materialização intermediária dos dados poderia melhorar o desempenho.

#### C6-A - Consulta direta

A consulta é executada diretamente sobre as tabelas permanentes.

Arquivo SQL:

`sql/C6A_consulta_direta.sql`

#### C6-B - Tabela temporária indexada

Os documentos filtrados são materializados em uma tabela temporária e posteriormente indexados.

O custo total considera:

1. criação e preenchimento da tabela temporária;
2. criação do índice;
3. execução da consulta final.

**Resultado médio utilizado na comparação geral:**

- Tempo: 27,00 s
- CPU: 165,88 s
- Leituras lógicas: 4.514.381

A estratégia apresentou melhora significativa em relação ao cenário inicial, porém o custo da materialização e da criação do índice fez com que o resultado ficasse abaixo dos obtidos em C4 e C5.

Arquivo SQL:

`sql/C6B_tabela_temporaria.sql`

---

## 4. Resumo dos resultados

| Cenário | Técnica | Tempo médio (s) | CPU média (s) | Leituras lógicas |
|---|---|---:|---:|---:|
| C1 | Consulta-base | 200,84 | 553,72 | 33.866.523 |
| C2 | SARGabilidade | 170,34 | 322,83 | 33.159.035 |
| C3 | Índice composto | 170,60 | 329,98 | 33.159.428 |
| C4 | Índice de cobertura | 23,66 | 148,06 | 4.441.172 |
| C5 | CTE + JOIN | 17,60 | 118,52 | 3.224.531 |
| C6 | Tabela temporária indexada | 27,00 | 165,88 | 4.514.381 |

Os resultados mostram que diferentes técnicas produzem efeitos distintos sobre o desempenho das consultas.

A reescrita para SARGabilidade apresentou ganho em relação à consulta inicial. O índice composto, por outro lado, não apresentou melhoria relevante nesse cenário. Os maiores ganhos foram observados após o uso do índice de cobertura e da reorganização da consulta com CTE e JOIN.

A utilização de tabela temporária também reduziu o tempo em relação ao cenário inicial, porém o custo adicional de materialização e indexação limitou o ganho obtido.

---

## 5. Arquivos complementares

Os artefatos do experimento estão organizados da seguinte forma:

- `sql/` - scripts utilizados nos testes;
- `planos-execucao/` - planos de execução reais;
- `resultados/` - planilha e resultados consolidados;
- `resultados/graficos/` - gráficos utilizados na análise.

---

## 6. Observações

Os resultados apresentados são específicos do ambiente, da volumetria e da distribuição dos dados utilizados no experimento.

As técnicas devem ser avaliadas de acordo com o contexto de cada consulta. A criação de índices ou a utilização de estruturas temporárias não deve ser considerada uma melhoria automática de desempenho.

Antes da aplicação de alterações em ambientes produtivos, recomenda-se avaliar os planos de execução e realizar testes controlados.