/*
===============================================================================
Cenário C5-B - CTE + JOIN
Objetivo:
    Avaliar o impacto da substituição das subconsultas correlacionadas por
    CTEs, agregações prévias e operações de JOIN.

Técnica:
    Common Table Expressions (CTEs) + JOIN.

Base:
    Ambiente corporativo do setor de seguros.

Período analisado:
    Ano de 2025.

Comparação principal:
    C5-A x C5-B
===============================================================================
*/

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

WITH DocumentosFiltrados AS
(
    SELECT
        documento_id,
        cod_ramo
    FROM dbo.documento_tb
    WHERE
        dt_documento >= '20250101'
        AND dt_documento < '20260101'
        AND estado_risco = 'MG'
),

DocumentosPorRamo AS
(
    SELECT
        cod_ramo,
        COUNT(*) AS qt_documentos
    FROM DocumentosFiltrados
    GROUP BY
        cod_ramo
),

PessoasPorRamo AS
(
    SELECT
        D.cod_ramo,
        COUNT(*) AS qt_pessoas
    FROM DocumentosFiltrados D
    INNER JOIN dbo.documento_pessoas_tb P
        ON P.DOCUMENTO_ID = D.documento_id
    GROUP BY
        D.cod_ramo
)

SELECT
    D.cod_ramo,
    D.qt_documentos,
    ISNULL(P.qt_pessoas, 0) AS qt_pessoas
FROM DocumentosPorRamo D
LEFT JOIN PessoasPorRamo P
    ON P.cod_ramo = D.cod_ramo
ORDER BY
    D.cod_ramo;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;