--GROUP BY serve para agrupar registros em blocos a partir de um valor em comum.
--No exemplo foi agrupado por product_type_id
--é possivel percber que o group by funciona como distinct para o dado que está no group by.
--IMPORTANTE: toda vez que uma coluna for retornada e não estiver sendo usada numa função agregada ela DEVE ser colocada no group by
--Também não é possível usar o retorno de uma função agregada para filtrar dados no WHERE.
--O WHERE só filtra registros individuais.
--Para filtrar grupos de registros usar HAVING
SELECT product_type_id from products GROUP BY product_type_id;

--é possível usar mais de uma coluna no group by.
SELECT product_id,
       customer_id
FROM purchases 
GROUP BY
    product_id,
    customer_id;

--é possível usar group by com funções agregadas para executar a função uma vez para cada bloco de registros agrupados pelo group by
SELECT product_type_id,
       COUNT(ROWID)
FROM products
GROUP BY
    product_type_id
ORDER BY product_type_id;

--Exemplo de Having para filtrar precos medios maiores que 20
SELECT product_type_id,
       AVG(price)
FROM products 
GROUP BY
    product_type_id
HAVING AVG(price) > 20;

--group by com having e where
SELECT product_type_id,
       AVG(price)
FROM products 
WHERE price < 15 
GROUP BY product_type_id
HAVING AVG(price) > 13
ORDER BY product_type_id;


