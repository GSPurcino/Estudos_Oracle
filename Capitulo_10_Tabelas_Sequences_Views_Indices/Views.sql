--VIEWS
--View basicamente e uma consulta predefinida que pode consultar tabelas ou outras views. 
--As tabelas consultadas pela view s�o chamadas de tabelas base. 
--Dependendo da view e poss�vel fazer DML pela view para atingir as tabelas base.
--Uma view pode ser usada como tabela em muitos casos, desde no select at� no PL/SQL.

--Algumas vantagens da view s�o:

--Pode guardar uma query complexa e � poss�vel dar permiss�o de consulta a ela de modo que a complexidade da estrutura seja escondida do usu�rio
--Outro ponto � que � poss�vel fazer os usu�rios verem os dados somente pela view, evitando assim que acessem as tabelas base diretamente

--Views simples s�o aquelas que retornam dados de apenas uma tabela base(� poss�vel fazer DML na tabela base usando esse tipo de view)
--Views complexas s�o aquelas que consultam dados de multiplas tabelas base, usa GROUP BY ou DISTINCT ou chama uma fun��o.
--N�o � poss�vel fazer DML com views complexas

--Sintaxe:
CREATE [OR REPLACE] VIEW [{FORCE | NOFORCE}] VIEW view_name
[(alias_name[, alias_name ...])] AS subquery
[WITH {CHECK OPTION | READ ONLY} CONSTRAINT constraint_name];

--Exemplo(deve ter o privil�gio CREATE VIEW)
CREATE VIEW cheap_products_view AS SELECT *
FROM products WHERE price < 15;

CREATE VIEW employees_view AS SELECT employee_id,
       manager_id,
       first_name,
       last_name,
       title
FROM employees;

--Consultando uma view
SELECT *
FROM cheap_products_view;

SELECT *
FROM employees_view;

--Fazendo um insert na tabela base pela view
INSERT INTO cheap_products_view (
    product_id,
    product_type_id,
    name,
    price
) VALUES (
    13,
    1,
    'Western Front',
    13.5
);

--Como a view n�o tem WITH CHECK OPTION, � poss�vel inserir registros que a view n�o retorna quando consultados

--Exemplo:
INSERT INTO cheap_products_view (
    product_id,
    product_type_id,
    name,
    price
) VALUES (
    14,
    1,
    'Eastern Front',
    16.50
);

--Cria��o de view WITH CHECK OPTION
CREATE VIEW cheap_products_view2 AS SELECT *
FROM products WHERE price < 15 WITH CHECK OPTION CONSTRAINT cheap_products_view2_price;

--Como a view foi criada WITH CHECK OPTION, n�o � poss�vel inserir um registro que a view n�o pode trazer na consulta
INSERT INTO cheap_products_view2 (
    product_id,
    product_type_id,
    name,
    price
) VALUES (
    15,
    1,
    'Southern Front',
    19.50
);

--Cria��o de view com READ ONLY
CREATE VIEW cheap_products_view3 AS SELECT *
FROM products WHERE price < 15 WITH READ ONLY CONSTRAINT cheap_products_view3_read_only;

--Como a view foi criada somente como READ ONLY, n�o � poss�vel fazer DML por ela
INSERT INTO cheap_products_view3 (
    product_id,
    product_type_id,
    name,
    price
) VALUES (
    16,
    1,
    'Northern Front',
    19.50
);

--Consultar dados das views
SELECT view_name, text_length, text
FROM user_views
ORDER BY view_name;


--Modificando a view
--� poss�vel mudar a view, substituindo ela por uma nova vers�o dela mesma ou usar o ALTER VIEW para mudar constraints
CREATE OR REPLACE VIEW product_average_view AS SELECT product_type_id,
       AVG(price) average_price
FROM products
WHERE price < 12
GROUP BY
    product_type_id
HAVING AVG(price) > 11
ORDER BY product_type_id;


--usando ALTER VIEW
ALTER VIEW cheap_products_view2
DROP CONSTRAINT cheap_products_view2_price;

--Eliminando uma view;
DROP VIEW cheap_products_view2;



