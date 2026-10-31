/*
===============================================================================
Cenário C4 - Índice de cobertura
Objetivo:
    Avaliar se um índice de cobertura sobre a tabela de pessoas reduz as
    leituras necessárias para execução da consulta.

Técnica:
    Índice nonclustered com coluna INCLUDE.

Base:
    Ambiente corporativo do setor de seguros.

Período analisado:
    Ano de 2025.

ATENÇÃO:
    A criação de índices em tabelas de grande volumetria pode consumir CPU,
    memória, armazenamento e provocar bloqueios. Executar somente em ambiente
    autorizado.

Comparação principal:
    C3 x C4
===============================================================================
*/

CREATE NONCLUSTERED INDEX IX_TCC_C4_Pessoas_Documento_Cover
ON dbo.documento_pessoas_tb
(
    DOCUMENTO_ID
)
INCLUDE
(
    tp_pessoa
);

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT
    D.estado_risco,
    D.cod_ramo,
    P.tp_pessoa,
    COUNT(DISTINCT D.documento_id) AS qt_documentos,
    COUNT(*) AS qt_pessoas,
    AVG(CAST(D.dias_vigencia AS DECIMAL(18,2))) AS media_dias_vigencia
FROM dbo.documento_tb D
INNER JOIN dbo.documento_pessoas_tb P
    ON P.DOCUMENTO_ID = D.documento_id
WHERE
    D.dt_documento >= '20250101'
    AND D.dt_documento < '20260101'
    AND D.estado_risco = 'MG'
GROUP BY
    D.estado_risco,
    D.cod_ramo,
    P.tp_pessoa
ORDER BY
    qt_documentos DESC;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;