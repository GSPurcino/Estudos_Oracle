--Coleções de coleções
--Com o Oracle 9 é possível criar coleções nas quais os elementos também são coleções
--As seguintes combinações são possíveis
--A nested table of nested tables
--A nested table of varrays
--A varray of varrays
--A varray of nested tables

--Exemplo de insert com coleção de multiplos niveis
INSERT INTO customers_with_nested_table VALUES (
    1,
    'Steve',
    'Brown',
    t_nested_table_address(
        t_address(
            '2 State Street',
            'Beantown',
            'MA',
            '12345',
            t_varray_phone('(800)-555-1211','(800)-555-1212','(800)-555-1213')
        ),
        t_address(
            '4 Hill Street',
            'Lost Town',
            'CA',
            '54321',
            t_varray_phone('(800)-555-1211','(800)-555-1212')
        )
    )
);

--ASSCOIATIVE ARRAYS
--São coleções de pares chave-valor, na qual a chave é o índice para acessar os elementos da coleção

CREATE PROCEDURE customers_associative_array AS
-- define an associative array type named t_assoc_array;
-- the value stored in each array element is a NUMBER,
-- and the index key to access each element is a VARCHAR2
    TYPE t_assoc_array IS
        TABLE OF NUMBER INDEX BY VARCHAR2(15);
-- declare an object named v_customer_array of type t_assoc_array;
-- v_customer_array will be used to store the ages of customers
    v_customer_array   t_assoc_array;
BEGIN
-- assign the values to v_customer_array; the VARCHAR2 key is the
-- customer name and the NUMBER value is the age of the customer
    v_customer_array('Jason')     := 32;
    v_customer_array('Steve')     := 28;
    v_customer_array('Fred')      := 43;
    v_customer_array('Cynthia')   := 27;
-- display the values stored in v_customer_array
    dbms_output.put_line('v_customer_array[''Jason''] = ' || v_customer_array('Jason') );
    dbms_output.put_line('v_customer_array[''Steve''] = ' || v_customer_array('Steve') );
    dbms_output.put_line('v_customer_array[''Fred''] = ' || v_customer_array('Fred') );
    dbms_output.put_line('v_customer_array[''Cynthia''] = ' || v_customer_array('Cynthia') );
END customers_associative_array;

SET SERVEROUTPUT ON;

BEGIN
  customers_associative_array();
END;

--Mudando tamanho do elemento da coleção
ALTER TYPE t_varray_address
MODIFY ELEMENT TYPE VARCHAR2(60) CASCADE;

--Em vez de CASCADE, é possível usar a opção INVALIDATE para invalidar objetos dependentes.

--Aumentando a quantidade de elementos que um varray pode armazenar
--só é possível aumentar o limite do varray. 
--Ou seja se você quer diminuir a quantidade máxima de elementos, é melhor deletear e criar o tipo de novo
ALTER TYPE t_varray_address
MODIFY LIMIT 20 CASCADE;

--Usando varrays com tabelas temporarias
CREATE GLOBAL TEMPORARY TABLE cust_with_varray_temp_table (
    id           INTEGER PRIMARY KEY,
    first_name   VARCHAR2(10),
    last_name    VARCHAR2(10),
    addresses    t_varray_address
);

--Operadores ANSI para nested tables

-- = e <>

CREATE PROCEDURE equal_example AS
-- declare a type named t_nested_table

    TYPE t_nested_table IS
        TABLE OF VARCHAR2(10);
-- create t_nested_table objects named v_customer_nested_table1,
-- v_customer_nested_table2,and v_customer_nested_table3;
-- these objects are used to store the names of customers
    v_customer_nested_table1   t_nested_table := t_nested_table('Fred','George','Susan');
    v_customer_nested_table2   t_nested_table := t_nested_table('Fred','George','Susan');
    v_customer_nested_table3   t_nested_table := t_nested_table('John','George','Susan');
    v_result                   BOOLEAN;
BEGIN
-- use = operator to compare v_customer_nested_table1 with
-- v_customer_nested_table2 (they contain the same names,so
-- v_result is set to true)
    v_result   := v_customer_nested_table1 = v_customer_nested_table2;
    IF
        v_result
    THEN
        dbms_output.put_line('v_customer_nested_table1 equal to v_customer_nested_table2');
    END IF;
-- use <> operator to compare v_customer_nested_table1 with
-- v_customer_nested_table3 (they are not equal because the first
-- names,'Fred' and 'John',are different and v_result is set
-- to true)
    v_result   := v_customer_nested_table1 <> v_customer_nested_table3;
    IF
        v_result
    THEN
        dbms_output.put_line('v_customer_nested_table1 not equal to v_customer_nested_table3');
    END IF;
END equal_example;

--Quando se compara uma nested table desde que elas sejam do mesmo tipo, 
--tenham a mesma quantidade de elementos e os elementos tenham os mesmos valores, elas são iguais
--A ordem dos elementos não importa
BEGIN
 equal_example();
END;

--IN e NOT IN com nested tables

-- IN verifica se uma nested table está ou não numa lista de nested tables
--Para o IN retornar verdadeiro a nested table DEVE SER IGUAL A OUTRA

CREATE PROCEDURE in_example AS

    TYPE t_nested_table IS
        TABLE OF VARCHAR2(10);
    v_customer_nested_table1   t_nested_table := t_nested_table('Fred','George','Susan');
    v_customer_nested_table2   t_nested_table := t_nested_table('John','George','Susan');
    v_customer_nested_table3   t_nested_table := t_nested_table('Fred','George','Susan');
    v_result                   BOOLEAN;
BEGIN
-- use IN operator to check if elements of v_customer_nested_table3
-- are in v_customer_nested_table1 (they are,so v_result is
-- set to true)
    v_result   :=
        v_customer_nested_table3 IN (
            v_customer_nested_table1
        );
    IF
        v_result
    THEN
        dbms_output.put_line('v_customer_nested_table3 in v_customer_nested_table1');
    END IF;
-- use NOT IN operator to check if the elements of
-- v_customer_nested_table3 are not in v_customer_nested_table2
-- (they are not,so v_result is set to true)
    v_result   :=
        v_customer_nested_table3 NOT IN (
            v_customer_nested_table2
        );
    IF
        v_result
    THEN
        dbms_output.put_line('v_customer_nested_table3 not in v_customer_nested_table2');
    END IF;
END in_example;

BEGIN
 in_example();
END;

--SUBMULTISET
--Esse operador serve para dizer se uma nested table está contida(subconjunto) de outra nested table. 
--Ou seja, serve para dizer se os elementos de uma nested table estão na outra

CREATE PROCEDURE submultiset_example AS

    TYPE t_nested_table IS
        TABLE OF VARCHAR2(10);
    v_customer_nested_table1   t_nested_table := t_nested_table('Fred','George','Susan');
    v_customer_nested_table2   t_nested_table := t_nested_table(
        'George',
        'Fred',
        'Susan',
        'John',
        'Steve'
    );
    v_result                   BOOLEAN;
BEGIN
-- use SUBMULTISET operator to check if elements of
-- v_customer_nested_table1 are a subset of v_customer_nested_table2
-- (they are,so v_result is set to true)
    v_result   :=
        v_customer_nested_table1 SUBMULTISET OF v_customer_nested_table2;
    IF
        v_result
    THEN
        dbms_output.put_line('v_customer_nested_table1 subset of v_customer_nested_table2');
    END IF;
END submultiset_example;

BEGIN
 submultiset_example();
END;

--MULTISET
--esse operador permite realizar operações de conjunto(união, intersecção) com nested tables.
--O comando aceita ainda opção para decidir se filtra ou não elementos duplicados no retorno

CREATE PROCEDURE multiset_example AS

    TYPE t_nested_table IS
        TABLE OF VARCHAR2(10);
    v_customer_nested_table1   t_nested_table := t_nested_table('Fred','George','Susan');
    v_customer_nested_table2   t_nested_table := t_nested_table('George','Steve','Rob');
    v_customer_nested_table3   t_nested_table;
    v_count                    INTEGER;
BEGIN
-- use MULTISET UNION (returns a nested table whose elements
-- are set to the sum of the two supplied nested tables)
    v_customer_nested_table3   := v_customer_nested_table1 MULTISET UNION v_customer_nested_table2;
    dbms_output.put('UNION: ');
    FOR v_count IN 1..v_customer_nested_table3.count LOOP
        dbms_output.put(v_customer_nested_table3(v_count) || ' ');
    END LOOP;

    dbms_output.put_line(' ');
-- use MULTISET UNION DISTINCT (DISTINCT indicates that only
-- the non-duplicate elements of the two supplied nested tables
-- are set in the returned nested table)
    v_customer_nested_table3   := v_customer_nested_table1 MULTISET UNION DISTINCT v_customer_nested_table2;
    dbms_output.put('UNION DISTINCT: ');
    FOR v_count IN 1..v_customer_nested_table3.count LOOP
        dbms_output.put(v_customer_nested_table3(v_count) || ' ');
    END LOOP;

    dbms_output.put_line(' ');
-- use MULTISET INTERSECT (returns a nested table whose elements
-- are set to the elements that are common to the two supplied
-- nested tables)
    v_customer_nested_table3   := v_customer_nested_table1 MULTISET INTERSECT v_customer_nested_table2;
    dbms_output.put('INTERSECT: ');
    FOR v_count IN 1..v_customer_nested_table3.count LOOP
        dbms_output.put(v_customer_nested_table3(v_count) || ' ');
    END LOOP;

    dbms_output.put_line(' ');
-- use MULTISET EXCEPT (returns a nested table whose
-- elements are in the first nested table but not in
-- the second)
    v_customer_nested_table3   := v_customer_nested_table1 MULTISET EXCEPT v_customer_nested_table2;
    dbms_output.put_line('EXCEPT: ');
    FOR v_count IN 1..v_customer_nested_table3.count LOOP
        dbms_output.put(v_customer_nested_table3(v_count) || ' ');
    END LOOP;

END multiset_example;

BEGIN
  multiset_example();
END;

--Exemplo do MULTISET EXCEPT, não funciona o do livro
DECLARE
    TYPE t_nested_table IS
        TABLE OF NUMBER;
    v_tb_1   t_nested_table := t_nested_table(232,47);
    v_tb_2   t_nested_table := t_nested_table(32574,437);
    v_tb_3   t_nested_table;
BEGIN
    v_tb_3   := v_tb_1 MULTISET EXCEPT v_tb_2;
    dbms_output.put_line(v_tb_3(1));
    dbms_output.put_line(v_tb_3(2));
END;

--Função CARDINALITY
--Diferente da função COUNT é possível usar a função cardinality com SQL
--Só funciona com nested tables
SELECT CARDINALITY(addresses) FROM customers_with_nested_table;

CREATE PROCEDURE cardinality_example AS

    TYPE t_nested_table IS
        TABLE OF VARCHAR2(10);
    v_customer_nested_table1   t_nested_table := t_nested_table('Fred','George','Susan');
    v_cardinality              INTEGER;
BEGIN
-- call CARDINALITY() to get the number of elements in
-- v_customer_nested_table1
    v_cardinality   := cardinality(v_customer_nested_table1);
    dbms_output.put_line('v_cardinality = ' || v_cardinality);
END cardinality_example;

BEGIN
  cardinality_example();
END;

--MEMBER OF
--Verifica se um elemento está na nested table
CREATE PROCEDURE member_of_example AS

    TYPE t_nested_table IS
        TABLE OF VARCHAR2(10);
    v_customer_nested_table1   t_nested_table := t_nested_table('Fred','George','Susan');
    v_result                   BOOLEAN;
BEGIN
-- use MEMBER OF to check if 'George' is in
-- v_customer_nested_table1 (he is,so v_result is set
-- to true)
    v_result   :=
        'George' MEMBER OF v_customer_nested_table1;
    IF
        v_result
    THEN
        dbms_output.put_line('''George'' is a member');
    END IF;
END member_of_example;

BEGIN
  member_of_example();
END;

--Função SET
--Converte uma nested table para set(remove elementos duplicados) e depois converte de volta para nested table e retorna 

CREATE PROCEDURE set_example AS

    TYPE t_nested_table IS
        TABLE OF VARCHAR2(10);
    v_customer_nested_table1   t_nested_table := t_nested_table(
        'Fred',
        'George',
        'Susan',
        'George'
    );
    v_customer_nested_table2   t_nested_table;
    v_count                    INTEGER;
BEGIN
-- call SET() to convert a nested table into a set,
-- remove duplicate elements from the set,and get the set
-- as a nested table
    v_customer_nested_table2   := set(v_customer_nested_table1);
    dbms_output.put('v_customer_nested_table2: ');
    FOR v_count IN 1..v_customer_nested_table2.count LOOP
        dbms_output.put(v_customer_nested_table2(v_count) || ' ');
    END LOOP;

    dbms_output.put_line(' ');
END set_example;

BEGIN
  set_example();
END;

--IS A SET
--Verifica se os elementos de uma nested table são distintos. Verifica se a nested table é um SET
CREATE PROCEDURE is_a_set_example AS

    TYPE t_nested_table IS
        TABLE OF VARCHAR2(10);
    v_customer_nested_table1   t_nested_table := t_nested_table(
        'Fred',
        'George',
        'Susan',
        'George'
    );
    v_result                   BOOLEAN;
BEGIN
-- use IS A SET operator to check if the elements in
-- v_customer_nested_table1 are distinct (they are not,so
-- v_result is set to false)
    v_result   :=
        v_customer_nested_table1 IS A SET;
    IF
        v_result
    THEN
        dbms_output.put_line('Elements are all unique');
    ELSE
        dbms_output.put_line('Elements contain duplicates');
    END IF;

END is_a_set_example;

BEGIN
  is_a_set_example();
END;

--IS EMPTY
--Serve para verificar se uma nested table está vazia(não tem elementos).

CREATE PROCEDURE is_empty_example AS

    TYPE t_nested_table IS
        TABLE OF VARCHAR2(10);
    v_customer_nested_table1   t_nested_table := t_nested_table('Fred','George','Susan');
    v_result                   BOOLEAN;
BEGIN
-- use IS EMPTY operator to check if
-- v_customer_nested_table1 is empty (it is not,so
-- v_result is set to false)
    v_result   :=
        v_customer_nested_table1 IS EMPTY;
    IF
        v_result
    THEN
        dbms_output.put_line('Nested table is empty');
    ELSE
        dbms_output.put_line('Nested table contains elements');
    END IF;

END is_empty_example;

BEGIN
  is_empty_example();
END;

--COLLECT()
--Retorna uma nested table a partir de um conjunto de elementos
--deve ser usada com CAST para poder funcionar
--Funciona com outros tipos de coleção sem ser nested table

SELECT CAST(COLLECT(first_name) AS t_varray_address)
FROM customers_with_varray;

--POWERMULTISET
--Só funciona com nested table
--Retorna todas as combinações entre os elementos de uma nested table
CREATE TYPE t_table AS TABLE OF VARCHAR2(10);

SELECT *
FROM TABLE ( powermultiset(t_table('This','is','a','test') ) );

--POWERMULTISET_BY_CARDINALITY
--Retorna as combinações entre elementos de uma nested table que possuem a quantidade de elementos passada
SELECT *
FROM TABLE ( powermultiset_by_cardinality(
        t_table(
            'This',
            'is',
            'a',
            'test'
        ),
        3
    ) );
