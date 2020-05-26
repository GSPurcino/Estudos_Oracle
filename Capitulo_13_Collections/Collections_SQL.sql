------------------------------------------COLLECTIONS-------------------------

--Varray guarda um conjunto de elementos ordenados. O Varray deve ter um tamanho m�ximo quando criado, porem isso pode ser mudado

--Cria��o de um tipo de varray

CREATE TYPE t_varray_address AS VARRAY(3) OF VARCHAR2(50);

--Mudando a quantidade m�xima de elementos do varray

ALTER TYPE t_varray_address MODIFY LIMIT 10 CASCADE;

--A op��o cascade propaga a mudan�a para objetos dependentes

--Nested table guarda conjunto de elementos n�o ordenados. � poss�vel inserir, alterar e deletar elementos de uma nested table.
--A nested table n�o possui tamanho m�ximo.

--Cria��o de uma nested table para guardar objetos address
CREATE TYPE t_nested_table_address AS TABLE OF t_address;

--� poss�vel criar tabelas com colunas que s�o cole��es

--Exemplo com coluna varray
CREATE TABLE customers_with_varray (
    id           INTEGER PRIMARY KEY,
    first_name   VARCHAR2(10),
    last_name    VARCHAR2(10),
    addresses    t_varray_address
);

--Exemplo com coluna nested table
CREATE TABLE customers_with_nested_table (
    id           INTEGER PRIMARY KEY,
    first_name   VARCHAR2(10),
    last_name    VARCHAR2(10),
    addresses    t_nested_table_address
)
    NESTED TABLE addresses STORE AS nested_addresses;

--A clausula NESTED TABLE diz qual � o nome da coluna do tipo nested table e a STORE AS diz qual � o nome da nested table
--Nao e possivel acessar a nested table sem liga-la com a tabela

--N�o � poss�vel criar uma tabela para uma cole��o dessa forma
--Para ter o mesmo efeito, pode criar a tabela com apenas uma coluna que � do tipo da cole��o
CREATE TABLE tb_addresses OF t_nested_table_address;

CREATE TABLE tb_addresses OF t_varray_address;

--Consultar dados sobre varray
DESCRIBE t_varray_address;

DESCRIBE customers_with_varray;

--S� mostra varrays que s�o colunas de tabelas, n�o os types que s�o varray
SELECT * FROM user_varrays;

--Consultar dados da nested table
DESCRIBE t_nested_table_address;

--Usar no sqlplus
SET DESCRIBE DEPTH 2;

DESCRIBE customers_with_nested_table;

--S� mostra nested_tables que s�o colunas de tabelas, n�o os types que s�o nested table
SELECT * FROM user_nested_tables;

--Consultar o que compoe as nested_tables existentes
SELECT * FROM user_nested_table_cols;
    
CREATE TYPE t_teste AS TABLE OF NUMBER;

CREATE TYPE t_teste2 AS VARRAY(5) OF NUMBER;

SELECT *
FROM user_types WHERE type_name LIKE 'T_TESTE%';

--------------------------------POPULANDO as cole�oes-----------------------------------

--Populando um varray
INSERT INTO customers_with_varray VALUES (
    1,
    'Steve',
    'Brown',
    t_varray_address('2 State Street,Beantown,MA,12345','4 Hill Street,Lost Town,CA,54321')
);

INSERT INTO customers_with_varray VALUES (
    2,
    'John',
    'Smith',
    t_varray_address('1 High Street,Newtown,CA,12347','3 New Street,Anytown,MI,54323','7 Market Street,Main Town,MA,54323'
)
);

--Populando uma nested_table
INSERT INTO customers_with_nested_table VALUES (
    1,
    'Steve',
    'Brown',
    t_nested_table_address(
        t_address(
            '2 State Street',
            'Beantown',
            'MA',
            '12345'
        ),
        t_address(
            '4 Hill Street',
            'Lost Town',
            'CA',
            '54321'
        )
    )
);

INSERT INTO customers_with_nested_table VALUES (
    2,
    'John',
    'Smith',
    t_nested_table_address(
        t_address(
            '1 High Street',
            'Newtown',
            'CA',
            '12347'
        ),
        t_address(
            '3 New Street',
            'Anytown',
            'MI',
            '54323'
        ),
        t_address(
            '7 Market Street',
            'Main Town',
            'MA',
            '54323'
        )
    )
);

--Consultando elementos da cole��o

--Varray
SELECT * FROM customers_with_varray;

--Nested table
SELECT * FROM customers_with_nested_table;

--Usando a fun��o TABLE() para tratar os elementos de uma cole��o como registros
--TABLE() com varray
SELECT a.*
FROM customers_with_varray c, TABLE(c.addresses) a;

--� poss�vel usar uma subquery com TABLE()
SELECT *
FROM TABLE (
-- get the addresses for customer #1
 SELECT addresses FROM customers_with_varray WHERE id   = 1 );
 
SELECT c.id,
       c.first_name,
       c.last_name,
       a.*
FROM customers_with_varray c,
     TABLE ( c.addresses ) a;

--TABLE() com nested table
SELECT a.*
FROM customers_with_nested_table c, TABLE(c.addresses) a;

--Como o Steve tem dois endere�os, a consulta retorna dois registros devido ao TABLE()
SELECT c.id,
       c.first_name,
       c.last_name,
       a.*
FROM customers_with_nested_table c,
     TABLE ( c.addresses ) a
WHERE c.id   = 1;

--------------MUDANDO OS ELEMENTOS DA COLE��O--------------------

--Mudando elementos de um varray
--S� � poss�vel mudar os elementos de um varray como um todo
UPDATE customers_with_varray
    SET
        addresses = t_varray_address('6 Any Street,Lost Town,GA,33347','3 New Street,Anytown,MI,54323','7 Market Street,Main Town,MA,54323'
)
WHERE id   = 2;

--Mudando elementos de uma nested table
--Numa nested table � poss�vel inserir, alterar e excluir elementos individualmente
INSERT INTO TABLE (
-- get the addresses for customer #2
 SELECT addresses FROM customers_with_nested_table WHERE id   = 2 ) VALUES ( t_address(
    '5 Main Street',
    'Uptown',
    'NY',
    '55512'
) );

--� poss�vel perceber que foi usado o table para filtrar em qual nested table deve ser inserido o valor
--na pr�tica � poss�vel usar um INSERT como se fosse um update que adiciona no nested table

--Alterando um endere�o
UPDATE TABLE (
-- get the addresses for customer #2
 SELECT addresses FROM customers_with_nested_table WHERE id   = 2 ) addr
    SET VALUE ( addr ) = t_address(
        '9 Any Street',
        'Lost Town',
        'VA',
        '74321'
    )
WHERE value(addr) = t_address(
        '1 High Street',
        'Newtown',
        'CA',
        '12347'
    );
    
--Eliminando um elemento da nested_table
DELETE FROM TABLE (
-- get the addresses for customer #2
 SELECT addresses FROM customers_with_nested_table WHERE id   = 2 ) addr WHERE value(addr) = t_address(
        '3 New Street',
        'Anytown',
        'MI',
        '54323'
    );

-------------------COMPARA��O NESTED TABLES COM METODOS DE MAPEAMENTO------------

--Duas nested tables s�o iguais somente se as seguintes condi��es forem verdadeiras:
--S�o do mesmo tipo
--Possuem a mesma quantidade de elementos
--Todos os elementos possuem os mesmos valores
--casos os elementos sejam de um tipo padr�o como VARCHAR2 ou NUMBER, o pr�prio Oracle faz a compara��o.
--Caso o elemento seja de um tipo definido pelo usu�rio, � necess�rio usar um m�todo de mapeamento

CREATE TYPE t_address2 AS OBJECT (
    street   VARCHAR2(15),
    city     VARCHAR2(15),
    state    CHAR(2),
    zip      VARCHAR2(5),
-- declare the get_string() map function,
-- which returns a VARCHAR2 string

    MAP MEMBER FUNCTION get_string RETURN VARCHAR2
);

CREATE TYPE BODY t_address2 AS
-- define the get_string() map function
    MAP MEMBER FUNCTION get_string RETURN VARCHAR2
        IS
    BEGIN
-- return a concatenated string containing the
-- zip,state,city,and street attributes
        RETURN zip
         || ' '
         || state
         || ' '
         || city
         || ' '
         || street;
    END get_string;

END;

CREATE TYPE t_nested_table_address2 AS TABLE OF t_address2;

CREATE TABLE customers_with_nested_table2 (
    id           INTEGER PRIMARY KEY,
    first_name   VARCHAR2(10),
    last_name    VARCHAR2(10),
    addresses    t_nested_table_address2
)
    NESTED TABLE addresses STORE AS nested_addresses2;
    
INSERT INTO customers_with_nested_table2 VALUES (
    1,
    'Steve',
    'Brown',
    t_nested_table_address2(
        t_address2(
            '2 State Street',
            'Beantown',
            'MA',
            '12345'
        ),
        t_address2(
            '4 Hill Street',
            'Lost Town',
            'CA',
            '54321'
        )
    )
);    

--Retorna porque a nested table no WHERE � IGUAL a nested table inserida na tabela
SELECT cn.id,
       cn.first_name,
       cn.last_name
FROM customers_with_nested_table2 cn
WHERE cn.addresses   = t_nested_table_address2(
        t_address2(
            '2 State Street',
            'Beantown',
            'MA',
            '12345'
        ),
        t_address2(
            '4 Hill Street',
            'Lost Town',
            'CA',
            '54321'
        )
    );

--N�o retorna nada porque a nested table no where s� tem um elemento
SELECT cn.id,
       cn.first_name,
       cn.last_name
FROM customers_with_nested_table2 cn
WHERE cn.addresses   = t_nested_table_address2(t_address2(
        '4 Hill Street',
        'Lost Town',
        'CA',
        '54321'
    ) );
    
--O oracle 10 incluiu um novo operador chamado SUBMULTISET OF que verifica se uma nested table faz parte de outra. 
--Ou seja verifica se a nested table � subconjunto da outra
SELECT cn.id,
       cn.first_name,
       cn.last_name
FROM customers_with_nested_table2 cn
WHERE t_nested_table_address2(t_address2(
        '4 Hill Street',
        'Lost Town',
        'CA',
        '54321'
    ) ) SUBMULTISET OF cn.addresses;
    
--Como o endere�o do where � um dos endere��s presentes no nested table da tabela, o SUBMULTISET retorna verdadeiro

--SUBMULTISET OF outro exemplo
SELECT cn.id,
       cn.first_name,
       cn.last_name
FROM customers_with_nested_table2 cn
WHERE cn.addresses SUBMULTISET OF t_nested_table_address2(
        t_address2(
            '2 State Street',
            'Beantown',
            'MA',
            '12345'
        ),
        t_address2(
            '4 Hill Street',
            'Lost Town',
            'CA',
            '54321'
        ),
        t_address2(
            '6 State Street',
            'Beantown',
            'MA',
            '12345'
        )
    );

--N�o h� como comparar VARRAYS diretamente

-----------------------------------------CONVERTER UMA COLE��O DE UM TIPO PARA OUTRO---------------------------

--CAST() para converter um varray em uma nested table
CREATE OR REPLACE TYPE t_varray_address2 AS
    VARRAY ( 3 ) OF t_address;

CREATE TABLE customers_with_varray2 (
    id           INTEGER PRIMARY KEY,
    first_name   VARCHAR2(10),
    last_name    VARCHAR2(10),
    addresses    t_varray_address2
);

INSERT INTO customers_with_varray2 VALUES (
    1,
    'Jason',
    'Bond',
    t_varray_address2(
        t_address(
            '9 Newton Drive',
            'Sometown',
            'WY',
            '22123'
        ),
        t_address(
            '6 Spring Street',
            'New City',
            'CA',
            '77712'
        )
    )
);

--CAST para converter o varray para nested table
SELECT CAST(cv.addresses AS t_nested_table_address) FROM customers_with_varray2 cv
WHERE cv.id   = 1;

--CAST para converter uma nested table em varray
SELECT CAST(cn.addresses AS t_varray_address2) FROM customers_with_nested_table cn
WHERE cn.id   = 1;