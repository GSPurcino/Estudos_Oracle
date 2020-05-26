-------------------------Operadores de conjunto---------------

--UNION ALL
--Retorna todos os registros de ambas as queries incluindo os duplicados

SELECT product_id,
       product_type_id,
       name
FROM products
UNION ALL
SELECT prd_id,
       prd_type_id,
       name
FROM more_products
ORDER BY 1;

--UNION
--Retorna todos os registros de amabas as queries, excluindo os duplicados

SELECT product_id,
       product_type_id,
       name
FROM products
UNION
SELECT prd_id,
       prd_type_id,
       name
FROM more_products
ORDER BY 1;

--INTERSECT
--Retorna os registros comuns em ambas as queries

SELECT product_id,
       product_type_id,
       name
FROM products
INTERSECT
SELECT prd_id,
       prd_type_id,
       name
FROM more_products
ORDER BY 1;

--MINUS
--Retorna todos os registros que aparecem somente na primeira query. Retorna a diferença entre as duas queries

SELECT product_id,
       product_type_id,
       name
FROM products
MINUS
SELECT prd_id,
       prd_type_id,
       name
FROM more_products
ORDER BY 1;

-------------------------------Combinação multiplos operadores de conjunto---------------------------

--é possível combinar multiplas queries separadas por operadores de conjunto.
--A ordem de execução desses operadores pode ser definida por parenteses. Por padrão é de cima para baixo no 11g

--UNION e depois o INTESECT
( SELECT product_id,
       product_type_id,
       name
FROM products
UNION
SELECT prd_id,
       prd_type_id,
       name
FROM more_products
) INTERSECT SELECT product_id,
       product_type_id,
       name
FROM product_changes;

--INTERSECT e depois o UNION

SELECT product_id,
       product_type_id,
       name
FROM products
UNION ( SELECT prd_id,
       prd_type_id,
       name
FROM more_products
INTERSECT SELECT product_id,
       product_type_id,
       name
FROM product_changes
);


