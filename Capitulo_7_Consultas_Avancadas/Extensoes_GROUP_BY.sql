------------------------------------------------GROUP BY Extensões----------------------------

--Para retornar mais colunas numa consulta que o que se pretende agrupar pode-se usar um valor constante ou null
--não é tao util em group by individuais, mas pode ser usado com group by em queries juntadas por operadores de conjunto(UNON, etc)
SELECT job_id,
       '1' constante,
       SUM(salary)
FROM employees2 GROUP BY
    job_id;

SELECT division_id, SUM(salary)
FROM employees2
GROUP BY division_id
ORDER BY division_id;

--ROLLUP
--contem total dos grupos registros, assim como o total de todos os grupos(total geral)
SELECT division_id, SUM(salary)
FROM employees2
GROUP BY ROLLUP(division_id)
ORDER BY division_id;

--ROLLUP com multiplas colunas
--Traz o total de cada grupo pelas colunas passadas, 
--e o total pelas colunas anteriores somente(desconsiderando a ultima - no exemplo traz o total de cada division_id) e o total geral.

SELECT division_id,
       job_id,
       SUM(salary)
FROM employees2
GROUP BY
    ROLLUP(division_id,job_id)
ORDER BY division_id,job_id;

--Invertendo a ordem das colunas no ROLLUP para alterar o retorno
SELECT job_id,
       division_id,
       SUM(salary)
FROM employees2
GROUP BY
    ROLLUP(job_id,division_id)
ORDER BY job_id,division_id;

--CUBE
--Contem totais para todas as combinacoes de colunas assim como um total geral
SELECT division_id,
       job_id,
       SUM(salary)
FROM employees2
GROUP BY
    CUBE(division_id,job_id)
ORDER BY division_id,job_id;

SELECT job_id,
       division_id,
       SUM(salary)
FROM employees2
GROUP BY
    CUBE(job_id,division_id)
ORDER BY job_id,division_id;

--GROUPING
--A funcao GROUPING só pode ser usada em queries que tenham ROLLUP e CUBE. 
--Essa funcao retorna 1 para valores agregados(usando GROUP BY comum)
--Caso o valor seja superagregado(obtido pela extensão do GROUP BY ROLLUP ou CUBE) será retornado 0.
SELECT GROUPING(division_id),
       division_id,
       SUM(salary)
FROM employees2
GROUP BY
    ROLLUP(division_id)
ORDER BY division_id;

--CASE para usar o valor da funcao GROUPING para alterar o retorno
SELECT
        CASE GROUPING(division_id)
            WHEN 1   THEN 'All divisions'
            ELSE division_id
        END
    AS div,
       SUM(salary)
FROM employees2
GROUP BY
    ROLLUP(division_id)
ORDER BY division_id;

--CASE com GROUPING para multiplas colunas
SELECT
        CASE GROUPING(division_id)
            WHEN 1   THEN 'All divisions'
            ELSE division_id
        END
    AS div,
           CASE GROUPING(job_id)
            WHEN 1   THEN 'All jobs'
            ELSE job_id
        END
    AS job,
       SUM(salary)
FROM employees2
GROUP BY
    ROLLUP(division_id,job_id)
ORDER BY division_id,job_id;

--GROUPING com CUBE
SELECT
        CASE GROUPING(division_id)
            WHEN 1   THEN 'All divisions'
            ELSE division_id
        END
    AS div,
           CASE GROUPING(job_id)
            WHEN 1   THEN 'All jobs'
            ELSE job_id
        END
    AS job,
       SUM(salary)
FROM employees2
GROUP BY
    CUBE(division_id,job_id)
ORDER BY division_id,job_id;

--GROUPING SETS
--Essa função serve para dizer quais totais devem ser retornados. 
--No exemplo foram retornados os totais das colunas division_id, job_id e o total geral
SELECT division_id,
       job_id,
       SUM(salary)
FROM employees2
GROUP BY
    GROUPING SETS ( division_id,job_id,NULL )
ORDER BY division_id,job_id;

--NULL na funcao grouping set significa o total geral para todas as colunas envolvidas no group by
--No exemplo foi retornado o total para as colunas division_id e job_id

--GROUPING_ID
--Essa funcao serve para retornar um ID numerico de acordo com o retorno da funcao GROUPING das colunas passadas. 
--O retorno dessa funcao é obtido a partir de conversão do numero binário por todos os retornos da função grouping para aquele registro.


SELECT division_id,
       job_id,
       GROUPING(division_id) AS div_grp,
       GROUPING(job_id) AS job_grp,
       GROUPING_ID(division_id,job_id) AS grp_id,
       SUM(salary)
FROM employees2
GROUP BY
    CUBE(division_id,job_id)
ORDER BY division_id,job_id;

--Usando grouping id para trazer colunas que são subtotais de uma das colunas ou o total geral

SELECT division_id,
       job_id,
       GROUPING_ID(division_id,job_id) AS grp_id,
       SUM(salary)
FROM employees2
GROUP BY
    CUBE(division_id,job_id)
HAVING GROUPING_ID(division_id,job_id) > 0
ORDER BY division_id,job_id;

--Usando a mesma coluna mais de uma vez no group by
SELECT division_id, job_id, SUM(salary)
FROM employees2
GROUP BY division_id, ROLLUP(division_id, job_id)
ORDER BY division_id,job_id;

--é possível eliminar os registros duplicados com a função GROUP_ID

--A funcao group id é feita para cada registro e começa de 0. 
--Quando o mesmo registro aparece novamente, ela e incrementada em 1

SELECT division_id,
       job_id,
       group_id(),
       SUM(salary)
FROM employees2 GROUP BY
    division_id,
    ROLLUP(division_id,job_id);

--Removendo registros duplicados usando HAVING com group_id

SELECT division_id,
       job_id,
       group_id(),
       SUM(salary)
FROM employees2 GROUP BY
    division_id,
    ROLLUP(division_id,job_id)
HAVING group_id() = 0;

