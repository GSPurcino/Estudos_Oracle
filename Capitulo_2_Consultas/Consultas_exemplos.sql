--O identificador do registro serve para representar a localização física do registro
--No Oracle, o ROWID é conhecido como uma coluna falsa, porque é usado internamente pelo oracle e não faz parte de uma tabela específica
SELECT ROWID, customer_id FROM customers;

--O número do registro serve para retornar qual é o número do registro no resultado da consulta, começando de 1 e assim sucessivamente.
--Assim como o ROWID também é uma coluna falsa.
SELECT ROWNUM, customer_id, first_name, last_name FROM customers;

--A tabela dual é uma tabela que tem apenas uma registro. Ela é utilizada para fazer testes de consultas e funções PL/SQL principalmente.
DESCRIBE dual;

SELECT * FROM dual;

--É possível usar apelidos nas colunas retornadas por consultas para facilitar a leitura
SELECT price * 2 AS DOUBLE_PRICE FROM products;

--No LIKE: 
--o _ serve para indicar um caractere qualquer na posicao na posicao em que é colocado
--o % serve para indicar n caracteres a partir da posição em que é colocado

--No primeiro exemplo o _ é usado para pegar qualquer nome que tenha 4 caracteres de tamanho
SELECT first_name
FROM customers WHERE first_name LIKE '____';

--No segundo exemplo o % é usado com o n para pegar qualquer nome que termine com n
SELECT first_name
FROM customers
WHERE first_name LIKE '%n';

--Para procurar pelos caracteres usados como comandos no like(% por exemplo) é necessário usar um caractere de ESCAPE como no exemplo abaixo;
SELECT name
FROM promotions
WHERE name LIKE '%/%%' ESCAPE '/';
--No exemplo o caractere de escape é /. 
--Desse modo o % depois da / está sendo procurado no texto pela consulta de modo que em todo caso que um nome tenha o caractere %, 
--esse nome será retornado.

SELECT p.name,
       pt.name type
FROM products p,
     product_types pt
WHERE p.product_type_id = pt.product_type_id
ORDER BY pt.name;

--Exemplo de produto cartesiano. Ocorre quando todos os registros de uma tabela são combinados com todos os registros da outra tabela.
--Acontece porque na consulta não foi feita nenhuma forma específica de junção entre as tabelas.
--A quantidade de registros que serão retornados é a quantidade de registros de uma tabela X a quantidade de registros da outra tabela.
--Exemplo:
SELECT pt.product_type_id,
       p.product_id
FROM product_types pt,
     products p;

--Junção em uma tabela. Ocorre quando existe a junção entre duas colunas de uma mesma tabela.
SELECT e.first_name employee_name,
       m.first_name manager_name
FROM employees e,
     employees m
WHERE e.manager_id = m.employee_id(+);

--USING. Serve para simplificar a sintaxe do JOIN no padrão ANSI. Deve respeitar as seguintes regras:
--As colunas devem ter o mesmo nome
--A junção deve usar um sinal de igualdade(=)
SELECT p.name,
       pt.name AS type
FROM products p
    INNER JOIN product_types pt USING ( product_type_id );
