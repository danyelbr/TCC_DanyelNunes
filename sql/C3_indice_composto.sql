/*
===============================================================================
Cenário C3 - Índice composto
Objetivo:
    Avaliar o impacto da criação de um índice composto sobre as colunas
    utilizadas nos filtros e agrupamentos da consulta.

Técnica:
    Índice nonclustered composto.

Base:
    Ambiente corporativo do setor de seguros.

Período analisado:
    Ano de 2025.

ATENÇÃO:
    A criação de índices em tabelas de grande volumetria pode consumir CPU,
    memória, armazenamento e provocar bloqueios. Executar somente em ambiente
    autorizado.

Comparação principal:
    C2 x C3
===============================================================================
*/

CREATE NONCLUSTERED INDEX IX_TCC_C3_Estado_Data_Ramo
ON dbo.documento_tb
(
    estado_risco,
    dt_documento,
    cod_ramo
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