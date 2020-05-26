--PIVOT
--� usado para transformar linhas em colunas usando uma fun��o agregada.
--Na pr�tica � como se a linha fosse rotacionada para virar uma coluna(pivot possui significado similar a girar em portugu�s)
--As linhas que v�o virar colunas est�o dentro do FOR.
--As outras linhas que n�o est�o na fun��o agregada s�o importantes 
--porque � por elas(incluindo a linha que vira coluna) que o retorno da fun��o agregada � agrupado


--A sintaxe padr�o �:
SELECT *
FROM (
inner_query
)
PIVOT (
aggregate_function FOR pivot_column IN (list_of_values)
);

--No exemplo abaixo a linha que vira coluna � o mes(month)
--A fun��o soma o amount e agrupa por mes e prd_type_id (as colunas restantes do SELECT que serve como base para o pivot
SELECT *
FROM ( SELECT month,
           prd_type_id,
           amount
    FROM all_sales WHERE prd_type_id IN (
        1,2,3
    ) )
        PIVOT ( SUM ( amount )
            FOR month
            IN ( 1 AS jan,2 AS feb,3 AS mar,4 AS apr )
        )
ORDER BY prd_type_id;

--� poss�vel fazer PIVOT com multiplas colunas
--o IN do FOR � afetado
--Exemplo abaixo:
SELECT *
FROM ( SELECT month,
           prd_type_id,
           amount
    FROM all_sales WHERE prd_type_id IN (
        1,2,3
    ) )
        PIVOT ( SUM ( amount )
            FOR ( month,prd_type_id )
            IN ( ( 1,2 ) AS jan_prdtype2,( 2,3 ) AS feb_prdtype3,( 3,1 ) AS mar_prdtype1,( 4,2 ) AS apr_prdtype2 )
        );


--Para se fazer subconsultas no IN do PIVOT, deve-se usar o PIVOT XML
SELECT *
FROM ( SELECT month,
           amount
    FROM all_sales )
        --PIVOT XML ( SUM ( amount )
        PIVOT ( SUM ( amount )
            FOR ( month )
            IN ( 1 AS jan,6 AS jun,7 AS jul )
            --IN ( SELECT DISTINCT month AS primeiro from all_sales where month = 1 )
        );

SELECT month,
       amount
FROM all_sales 
        PIVOT ( SUM ( amount )
            FOR ( month )
            IN ( 1 AS jan,6 AS jun,7 AS jul )
        );
        
--PIVOT com multiplas funcoes agregadas

SELECT *
FROM ( SELECT month,
           prd_type_id,
           amount
    FROM all_sales WHERE year   = 2003
        AND
            prd_type_id IN (
                1,2,3
            )
    )
        PIVOT ( SUM ( amount ) AS sum_amount,AVG ( amount ) AS avg_amount
            FOR ( month )
            IN ( 1 AS jan,2 AS feb )
        )
ORDER BY prd_type_id;

--UNPIVOT
--Essa fun��o faz o inverso de PIVOT, ou seja, transforma colunas em linhas

CREATE TABLE pivot_sales_data
    AS SELECT *
    FROM ( SELECT month,
               prd_type_id,
               amount
        FROM all_sales WHERE year   = 2003
            AND
                prd_type_id IN (
                    1,2,3
                )
        )
            PIVOT ( SUM ( amount )
                FOR month
                IN ( 1 AS jan,2 AS feb,3 AS mar,4 AS apr )
            )
    ORDER BY prd_type_id;

SELECT * FROM pivot_sales_data;

--As colunas que v�o virar linhas s�o colocadas no FOR
SELECT *
FROM pivot_sales_data UNPIVOT ( amount
        FOR month
    IN ( jan,feb,mar,apr ) )
ORDER BY prd_type_id;