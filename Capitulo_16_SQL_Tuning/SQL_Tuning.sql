----------------------------------------SQL Tuning----------------------

--Indices
--Indices em banco de dados no geral funcionam de maneira similar a indices em livros.
--Permitem uma consulta muito mais rapida quando usados corretamente, por�m sempre acarretam o custo adicional de mant�-los atualizados.

--Um boa regra para decidir adicionar indice ou n�o � a seguinte:

--CRIE UM INDICE QUANDO UMA CONSULTA AT� 10% DA QUANTIDADE TOTAL DE REGISTROS DA TABELA

--Na pr�tica isso significa que deve-se criar indices quando uma consulta retorna uma quantidade pequena de registros 
--de uma tabela com muitos registros.

--A volumetria da tabela � importante porque se ela for muito pequena o custo de ler ela por completo 
--pode ser menor do que usar o indice em certos casos. Nessa situa��o o indice � inutil

--Outro bom caso para criar indices � em colunas que s�o usadas no SART WITH e CONNECT BY de consultas hierarquicas.

--Um ultimo caso � quando uma coluna tem uma pequena quantidade de valores poss�veis, que � usada no WHERE
--Para esses casos pode-se usar um bitmap index

--Uso do WHERE para filtrar registros
SELECT *
FROM customers WHERE customer_id IN (
    1,2
);

--Uso de jun��es de tabelas em vez de multiplas consultas

--RUIM
SELECT name,
       product_type_id
FROM products WHERE product_id   = 1;

SELECT name FROM product_types WHERE product_type_id   = 1;

--BOM
SELECT p.name,
       pt.name pt_type_name
FROM products p,
     product_types pt
WHERE p.product_type_id   = pt.product_type_id
    AND
        p.product_id        = 1;
        
--Em jun��es de tabelas, � importante referenciar a coluna de maneira completa(alias.coluna)
--para garantir que o otimizador n�o perca tempo procurando de qual tabela � a coluna

--RUIM
--O exemplo funciona, por�m o banco deve procurar as duas tabelas para saber da onde s�o as colunas price e description
--O tempo que o banco faz essa procura n�o � gasto se antes do nome da coluna houver qual � o nome da tabela
SELECT p.name,
       pt.name,
       description,
       price
FROM products p,
     product_types pt
WHERE p.product_type_id   = pt.product_type_id
    AND
        p.product_id        = 1;

--BOM
SELECT p.name,
       pt.name,
       p.description,
       p.price
FROM products p,
     product_types pt
WHERE p.product_type_id   = pt.product_type_id
    AND
        p.product_id        = 1;

--Usar expressoes CASE em vez de multiplas consultas

--RUIM
SELECT COUNT(*)
FROM products
WHERE price < 13;

SELECT COUNT(*)
FROM products
WHERE price BETWEEN 13 AND 15;

SELECT COUNT(*)
FROM products
WHERE price > 15;

--BOM
SELECT COUNT(
        CASE
            WHEN price < 13 THEN 1
            ELSE NULL
        END
    ) low,
       COUNT(
        CASE
            WHEN price BETWEEN 13 AND 15 THEN 1
            ELSE NULL
        END
    ) med,
       COUNT(
        CASE
            WHEN price > 15 THEN 1
            ELSE NULL
        END
    ) high
FROM products;

--Usar WHERE em vez de HAVING

--RUIM
SELECT product_type_id,
       AVG(price)
FROM products GROUP BY
    product_type_id
HAVING product_type_id IN (
    1,2
);

--s� � poss�vel usar HAVING na fun��o de grupo diretamente ou em colunas retornadas na consulta

--BOM
SELECT product_type_id,
       AVG(price)
FROM products WHERE product_type_id IN (
    1,2
) GROUP BY
    product_type_id;

--Usar UNION ALL em vez de UNION
--Como UNION tem que remover os registros duplicados, ele leva mais tempo que o UNION ALL
--Remova o UNION apenas ap�s ter certeza que o retorno final da consulta n�o � alterado.
--Ou seja, sempre � seguro remover o UNION quando sabe-se que os mesmos registros ser�o retornados na consulta, pois naquela situa��o
--n�o existem registro duplicados

--RUIM
SELECT product_id,
       product_type_id,
       name
FROM products
WHERE product_id < 7
UNION
SELECT product_id,
       product_type_id,
       name
FROM products
WHERE product_id > 6;

--BOM
SELECT product_id,
       product_type_id,
       name
FROM products
WHERE product_id < 7
UNION ALL
SELECT product_id,
       product_type_id,
       name
FROM products
WHERE product_id > 6;


--COUNT x EXISTS
--Usar EXISTS em vez de COUNT sempre que poss�vel
SELECT
        CASE
            WHEN COUNT(*) > 0 THEN 'Existe'
            ELSE 'Nao existe'
        END
    teste
FROM all_sales WHERE month   = 1;

SELECT
        CASE
            WHEN EXISTS ( SELECT 1 FROM all_sales WHERE month   = 1) THEN 'Existe'
            ELSE 'Nao existe'
        END
    teste
FROM dual;

--USAR ROWNUM dentro da query do EXISTS pode deixar mais r�pido dependendo do caso
SELECT
        CASE
            WHEN EXISTS ( SELECT 1 FROM all_sales WHERE month   = 1 AND ROWNUM < 2) THEN 'Existe'
            ELSE 'Nao existe'
        END
    teste
FROM dual;

--Usar EXISTS em vez de IN sempre que poss�vel em subqueries
--IN olha para ver se um valor est� numa lista de valores, EXISTS verifica exist�ncia de registros

--RUIM
SELECT product_id,
       name
FROM products WHERE product_id IN ( SELECT product_id FROM purchases );

--BOM
SELECT product_id,
       name
       FROM products prd
       WHERE EXISTS(SELECT 1 FROM purchases pur WHERE pur.product_id = prd.product_id);
       
--REGRA DO EXISTS e IN
--Se a maioria dos crit�rios de filtragem estiverem na subquery, IN pode ser mais r�pido
--Se a maioria dos crit�rios de filtragem estiverem na consulta externa, EXISTS pode ser mais r�pido

--Usar EXISTS em vez de DISTINCT
--Antes de remover os registros duplicados DISTINCT ordena os registros, por isso � mais lento

--RUIM
SELECT DISTINCT pr.product_id,
       pr.name
FROM products pr,
     purchases pu
WHERE pr.product_id   = pu.product_id;

--BOM
SELECT product_id,
       name
       FROM products prd
       WHERE EXISTS(SELECT 1 FROM purchases pur WHERE pur.product_id = prd.product_id);
       
--Sempre que poss�vel usar GROUPING SETS em vez de CUBE

------------------------------------BIND VARIABLES----------------------------------------