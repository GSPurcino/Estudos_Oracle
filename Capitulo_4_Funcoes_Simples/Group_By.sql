--GROUP BY serve para agrupar registros em blocos a partir de um valor em comum.
--No exemplo foi agrupado por product_type_id
--� possivel percber que o group by funciona como distinct para o dado que est� no group by.
--IMPORTANTE: toda vez que uma coluna for retornada e n�o estiver sendo usada numa fun��o agregada ela DEVE ser colocada no group by
--Tamb�m n�o � poss�vel usar o retorno de uma fun��o agregada para filtrar dados no WHERE.
--O WHERE s� filtra registros individuais.
--Para filtrar grupos de registros usar HAVING
SELECT product_type_id from products GROUP BY product_type_id;

--� poss�vel usar mais de uma coluna no group by.
SELECT product_id,
       customer_id
FROM purchases 
GROUP BY
    product_id,
    customer_id;

--� poss�vel usar group by com fun��es agregadas para executar a fun��o uma vez para cada bloco de registros agrupados pelo group by
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


