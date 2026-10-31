# Dicionário de métricas

Este documento descreve as principais métricas utilizadas na avaliação dos cenários experimentais.

## Tempo de execução

Representa o tempo total decorrido entre o início e o término da execução da consulta.

No SQL Server, essa informação foi obtida com:

```sql
SET STATISTICS TIME ON;
```

Nos resultados do experimento, o tempo foi registrado em milissegundos na planilha de coleta e apresentado em segundos nos gráficos e no trabalho.

---

## Tempo de CPU

Representa o tempo total de processamento utilizado pela CPU durante a execução da consulta.

Essa métrica também foi obtida por meio do comando:

```sql
SET STATISTICS TIME ON;
```

O tempo de CPU pode ser maior que o tempo total de execução quando o SQL Server utiliza paralelismo, pois o processamento de diferentes threads pode ser somado.

---

## Leituras lógicas

Representam a quantidade de páginas de dados acessadas a partir da memória durante a execução da consulta.

Essa métrica foi obtida com:

```sql
SET STATISTICS IO ON;
```

Para este experimento, o valor consolidado de leituras lógicas considera a soma das leituras lógicas reportadas para as tabelas envolvidas na consulta.

Quando presentes, também foram consideradas as leituras lógicas de dados LOB.

As leituras antecipadas (`read-ahead reads`) não foram somadas ao total de leituras lógicas utilizado na comparação.

---

## Leituras físicas

Representam páginas que precisaram ser obtidas do armazenamento físico durante a execução.

Também foram coletadas com:

```sql
SET STATISTICS IO ON;
```

Quando presentes, as leituras físicas de dados LOB foram consideradas no valor consolidado.

Essa métrica foi utilizada como informação complementar, pois pode variar de acordo com o estado do cache do SQL Server.

---

## Plano de execução real

O plano de execução real mostra como o SQL Server executou a consulta.

Ele foi utilizado para apoiar a interpretação das métricas e observar aspectos como:

- índices utilizados;
- operações de `Scan` e `Seek`;
- operações de `JOIN`;
- agregações;
- paralelismo;
- utilização de estruturas temporárias;
- custo relativo dos operadores.

Os planos utilizados no experimento estão disponíveis na pasta `planos-execucao/`.

---

## Média das execuções

Cada cenário foi executado três vezes.

Para tempo de execução, tempo de CPU e leituras, foi utilizada a média aritmética das três execuções:

```text
média = (execução 1 + execução 2 + execução 3) / 3
```

Os valores médios foram utilizados na comparação geral entre os cenários.

---

## Observação sobre comparação

As métricas devem ser analisadas em conjunto.

Uma redução no tempo de execução não significa necessariamente redução proporcional de CPU ou de leituras. Por esse motivo, a avaliação dos cenários considerou simultaneamente:

- tempo de execução;
- tempo de CPU;
- leituras lógicas;
- leituras físicas;
- plano de execução real.