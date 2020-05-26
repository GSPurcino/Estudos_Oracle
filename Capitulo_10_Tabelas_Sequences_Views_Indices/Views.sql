--VIEWS
--View basicamente e uma consulta predefinida que pode consultar tabelas ou outras views. 
--As tabelas consultadas pela view são chamadas de tabelas base. 
--Dependendo da view e possível fazer DML pela view para atingir as tabelas base.
--Uma view pode ser usada como tabela em muitos casos, desde no select até no PL/SQL.

--Algumas vantagens da view são:

--Pode guardar uma query complexa e é possível dar permissão de consulta a ela de modo que a complexidade da estrutura seja escondida do usuário
--Outro ponto é que é possível fazer os usuários verem os dados somente pela view, evitando assim que acessem as tabelas base diretamente

--Views simples são aquelas que retornam dados de apenas uma tabela base(é possível fazer DML na tabela base usando esse tipo de view)
--Views complexas são aquelas que consultam dados de multiplas tabelas base, usa GROUP BY ou DISTINCT ou chama uma função.
--Não é possível fazer DML com views complexas

--Sintaxe:
CREATE [OR REPLACE] VIEW [{FORCE | NOFORCE}] VIEW view_name
[(alias_name[, alias_name ...])] AS subquery
[WITH {CHECK OPTION | READ ONLY} CONSTRAINT constraint_name];

--Exemplo(deve ter o privilégio CREATE VIEW)
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

--Como a view não tem WITH CHECK OPTION, é possível inserir registros que a view não retorna quando consultados

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

--Criação de view WITH CHECK OPTION
CREATE VIEW cheap_products_view2 AS SELECT *
FROM products WHERE price < 15 WITH CHECK OPTION CONSTRAINT cheap_products_view2_price;

--Como a view foi criada WITH CHECK OPTION, não é possível inserir um registro que a view não pode trazer na consulta
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

--Criação de view com READ ONLY
CREATE VIEW cheap_products_view3 AS SELECT *
FROM products WHERE price < 15 WITH READ ONLY CONSTRAINT cheap_products_view3_read_only;

--Como a view foi criada somente como READ ONLY, não é possível fazer DML por ela
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
--é possível mudar a view, substituindo ela por uma nova versão dela mesma ou usar o ALTER VIEW para mudar constraints
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



