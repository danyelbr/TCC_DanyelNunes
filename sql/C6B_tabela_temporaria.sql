/*
===============================================================================
Cenário C6-B - Tabela temporária indexada
Objetivo:
    Avaliar se a materialização intermediária dos documentos filtrados e a
    criação de um índice sobre a tabela temporária melhoram o desempenho total.

Técnica:
    Tabela temporária + índice clustered.

Base:
    Ambiente corporativo do setor de seguros.

Período analisado:
    Ano de 2025.

Observação:
    O custo total do cenário considera:
    1. criação e preenchimento da tabela temporária;
    2. criação do índice;
    3. execução da consulta final.

Comparação principal:
    C6-A x C6-B
===============================================================================
*/

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

DROP TABLE IF EXISTS #DocumentosFiltrados;

SELECT
    D.documento_id,
    D.estado_risco,
    D.cod_ramo,
    D.dias_vigencia
INTO #DocumentosFiltrados
FROM dbo.documento_tb D
WHERE
    D.dt_documento >= '20250101'
    AND D.dt_documento < '20260101'
    AND D.estado_risco = 'MG';

CREATE CLUSTERED INDEX IX_TCC_C6_Documento
ON #DocumentosFiltrados
(
    documento_id
);

SELECT
    D.estado_risco,
    D.cod_ramo,
    P.tp_pessoa,
    COUNT(DISTINCT D.documento_id) AS qt_documentos,
    COUNT(*) AS qt_pessoas,
    AVG(CAST(D.dias_vigencia AS DECIMAL(18,2))) AS media_dias_vigencia
FROM #DocumentosFiltrados D
INNER JOIN dbo.documento_pessoas_tb P
    ON P.DOCUMENTO_ID = D.documento_id
GROUP BY
    D.estado_risco,
    D.cod_ramo,
    P.tp_pessoa
ORDER BY
    qt_documentos DESC;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;

DROP TABLE IF EXISTS #DocumentosFiltrados;