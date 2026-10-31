/*
===============================================================================
Cenário C6-A - Consulta direta
Objetivo:
    Estabelecer a versão de referência do cenário C6 antes da materialização
    intermediária dos dados.

Técnica:
    Execução direta da consulta.

Base:
    Ambiente corporativo do setor de seguros.

Período analisado:
    Ano de 2025.

Comparação principal:
    C6-A x C6-B
===============================================================================
*/

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