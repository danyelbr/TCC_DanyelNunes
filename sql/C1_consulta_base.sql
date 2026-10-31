/*
===============================================================================
Cenário C1 - Consulta-base na configuração original
Objetivo:
    Estabelecer o cenário inicial de referência para o experimento.

Técnica:
    Consulta com funções aplicadas diretamente às colunas utilizadas nos filtros.

Base:
    Ambiente corporativo do setor de seguros.

Período analisado:
    Ano de 2025.

Métricas coletadas:
    - Tempo de execução
    - Tempo de CPU
    - Leituras lógicas
    - Leituras físicas
    - Plano de execução real
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
    YEAR(D.dt_documento) = 2025
    AND UPPER(ISNULL(D.estado_risco, '')) = 'MG'
GROUP BY
    D.estado_risco,
    D.cod_ramo,
    P.tp_pessoa
ORDER BY
    qt_documentos DESC;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;