----------------------------Single-Row subqueries-----------

--Subconsulta que retorna 1 registro no WHERE
SELECT first_name,
       last_name
FROM customers WHERE customer_id   = ( SELECT customer_id FROM customers WHERE last_name   = 'Brown' );


--Subconsulta escalar(retorna uma coluna e um registro)

SELECT product_id,
       name,
       price
FROM products WHERE price > ( SELECT AVG(price) FROM products );

--Subsconsulta com HAVING

SELECT product_type_id,
       AVG(price)
FROM products
GROUP BY
    product_type_id
HAVING AVG(price) < ( SELECT MAX(AVG(price) ) FROM products GROUP BY
        product_type_id
    )
ORDER BY product_type_id;

----------------------------------------Multi-row subqueries--------------------------

--Inline view(Ocorre quando a subquery e colocada no FROM do select)

SELECT product_id FROM ( SELECT product_id FROM products WHERE product_id < 3 );

--Multi-row subquery with IN

SELECT product_id,
       name
FROM products WHERE product_id IN ( SELECT product_id FROM products WHERE name LIKE '%e%' );

--Subconsulta de multiplos registros com NOT IN

SELECT product_id,
       name
FROM products WHERE product_id NOT IN ( SELECT product_id FROM purchases );

--Subconsulta com ANY
--O operador ANY serve para comparar um valor com qualquer valor da lista. A lista pode ser uma subconsulta

SELECT employee_id,
       last_name
FROM employees WHERE salary < ANY ( SELECT low_salary FROM salary_grades );

--Subconsulta com ALL
--O operador ALL serve para comparar um valor com todos os valores da lista. A lista pode ser uma subconsulta

SELECT employee_id,
       last_name
FROM employees WHERE salary > ALL ( SELECT high_salary FROM salary_grades );

--------------------------------------Possible errors----------------------------------

--Uma subconsulta de um registro(where ou having) só poder retornar no maximo um registro. Caso retorne mais ocorre erro
--Exemplo do erro abaixo:

SELECT product_id,
       name
FROM products WHERE product_id   = ( SELECT product_id FROM products WHERE name LIKE '%e%' );

--Subqueries nao podem ter ordenacao (ORDER BY)

-------------------------------------------Subconsulta com multiplas colunas-----------------

SELECT product_id,
       product_type_id,
       name,
       price
FROM products WHERE ( product_type_id,price ) IN ( SELECT product_type_id,
           MIN(price)
    FROM products GROUP BY
        product_type_id
    );

--------------------------------------Subconsulta correlacionada(Faz referencia a coluna da consulta externa)--------

--Exemplo subconsulta correlacionada
SELECT product_id, product_type_id, name, price
FROM products outer
WHERE price >
(SELECT AVG(price)
FROM products inner
WHERE inner.product_type_id = outer.product_type_id);

--Exemplo subconsulta com EXISTS
SELECT employee_id, last_name
FROM employees outer
WHERE EXISTS
(SELECT employee_id
FROM employees inner
WHERE inner.manager_id = outer.employee_id);

--Subconsulta com EXISTS
--Usa literal para aumentar a performance
SELECT employee_id, last_name
FROM employees outer
WHERE EXISTS
(SELECT 1
FROM employees inner
WHERE inner.manager_id = outer.employee_id);

--Subconsulta com NOT EXISTS
SELECT product_id, name
FROM products outer
WHERE NOT EXISTS
(SELECT 1
FROM purchases inner
WHERE inner.product_id = outer.product_id);

--Subconsulta dentro de uma subconsulta
SELECT product_type_id,
       AVG(price)
FROM products
GROUP BY
    product_type_id
HAVING AVG(price) < ( SELECT MAX(AVG(price) ) FROM products WHERE product_type_id IN ( SELECT product_id FROM purchases WHERE quantity
> 1 )
    GROUP BY
        product_type_id
    )
ORDER BY product_type_id;

------------------------Subconsultas em UPDATE e DELETE--------------------------------

--UPDATE
UPDATE employees
    SET
        salary = ( SELECT AVG(high_salary) FROM salary_grades )
WHERE employee_id   = 4;

--Uso de consulta escalar no SET do UPDATE

--DELETE
DELETE FROM employees WHERE salary > ( SELECT AVG(high_salary) FROM salary_grades );




