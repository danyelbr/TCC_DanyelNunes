/*
===============================================================================
Cenário C5-A - Subconsultas correlacionadas
Objetivo:
    Estabelecer a versão de referência do cenário C5 para comparação com uma
    abordagem baseada em CTE e JOIN.

Técnica:
    Subconsultas correlacionadas.

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

SELECT DISTINCT
    D.cod_ramo,

    (
        SELECT COUNT(*)
        FROM dbo.documento_tb D2
        WHERE
            D2.cod_ramo = D.cod_ramo
            AND D2.dt_documento >= '20250101'
            AND D2.dt_documento < '20260101'
            AND D2.estado_risco = 'MG'
    ) AS qt_documentos,

    (
        SELECT COUNT(*)
        FROM dbo.documento_tb D3
        INNER JOIN dbo.documento_pessoas_tb P3
            ON P3.DOCUMENTO_ID = D3.documento_id
        WHERE
            D3.cod_ramo = D.cod_ramo
            AND D3.dt_documento >= '20250101'
            AND D3.dt_documento < '20260101'
            AND D3.estado_risco = 'MG'
    ) AS qt_pessoas

FROM dbo.documento_tb D
WHERE
    D.dt_documento >= '20250101'
    AND D.dt_documento < '20260101'
    AND D.estado_risco = 'MG'
ORDER BY
    D.cod_ramo;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;