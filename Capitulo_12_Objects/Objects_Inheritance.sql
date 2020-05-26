-----------------------------------------HERANÇA DE TIPOS---------------------------------

--A herança é útil para poder definir uma hierarquia de tipos.
--Para um tipo poder ser herdado, a clausula NOT FINAL deve estar na sua criação

CREATE OR REPLACE TYPE t_person AS OBJECT (
    id           INTEGER,
    first_name   VARCHAR2(10),
    last_name    VARCHAR2(10),
    dob          DATE,
    phone        VARCHAR2(12),
    address      t_address,

    MEMBER FUNCTION display_details RETURN VARCHAR2
) NOT FINAL;

CREATE TYPE BODY t_person AS
    MEMBER FUNCTION display_details RETURN VARCHAR2
        IS
    BEGIN
        RETURN 'id='
         || id
         || ',name='
         || first_name
         || ' '
         || last_name;
    END;

END;

--Para fazer um tipo herdar atributos e metodos de outro, e necessario usar a palavra UNDER

CREATE TYPE t_business_person UNDER t_person (
    title     VARCHAR2(20),
    company   VARCHAR2(20)
);

--No exemplo, o tipo t_person é o supertipo e o objeto t_business_person e o subtipo

CREATE TABLE object_business_customers OF t_business_person;

INSERT INTO object_business_customers VALUES ( t_business_person(
    1,
    'John',
    'Brown',
    '01-FEV-1955',
    '800-555-1211',
    t_address(
        '2 State Street',
        'Beantown',
        'MA',
        '12345'
    ),
    'Manager',
    'XYZ Corp'
) );

SELECT *
FROM object_business_customers WHERE id   = 1;

--Para usar metodos do objeto na consulta, é necessário apelidar a tabela
SELECT o.display_details() FROM object_business_customers o
WHERE id   = 1;

--Usando um subtipo no lugar de um supertipo.

INSERT INTO object_customers VALUES ( t_business_person(
    2,
    'Steve',
    'Edwards',
    '03-MAR-1955',
    '800-555-1212',
    t_address(
        '1 Market Street',
        'Anytown',
        'VA',
        '12345'
    ),
    'Manager',
    'XYZ Corp'
) );

--Não retorna os atributos específicos do subtipo. 
--Na pratica isso significa dizer que o subtipo é uma pessoa e uma pessoa de negocios ao mesmo tempo
--A dsevantagem de guardar um subtipo numa tabela objeto do supertipo é que toda a parte específica do subtipo(métodos e/ou atributos) não são
--visíveis para a tabela numa consulta a ela, que é uma tabela objeto so supertipo.
--Ainda assim é possível inserir na tabela um objeto do subtipo

SELECT *
FROM object_customers o;

--Para ver os atributos especificos do subtipo, deve-se usar a função VALUE()
--Usar no sqlplus
SELECT VALUE(o)
FROM object_customers o;

----------------------------------------------HERANÇA NO PLSQL-----------------------------

CREATE PROCEDURE subtypes_and_supertypes AS
-- create objects

    v_business_person    t_business_person := t_business_person(
        1,
        'John',
        'Brown',
        '01-FEV-1955',
        '800-555-1211',
        t_address(
            '2 State Street',
            'Beantown',
            'MA',
            '12345'
        ),
        'Manager',
        'XYZ Corp'
    );
    v_person             t_person := t_person(
        1,
        'John',
        'Brown',
        '01-FEV-1955',
        '800-555-1211',
        t_address(
            '2 State Street',
            'Beantown',
            'MA',
            '12345'
        )
    );
    v_business_person2   t_business_person;
    v_person2            t_person;
BEGIN
-- assign v_business_person to v_person2
    v_person2   := v_business_person;
    dbms_output.put_line('v_person2.id = ' || v_person2.id);
    dbms_output.put_line('v_person2.first_name = ' || v_person2.first_name);
    dbms_output.put_line('v_person2.last_name = ' || v_person2.last_name);
-- the following lines will not compile because v_person2
-- is of type t_person,and t_person does not know about the
-- additional title and company attributes
-- DBMS_OUTPUT.PUT_LINE('v_person2.title = ' ||
-- v_person2.title);
-- DBMS_OUTPUT.PUT_LINE('v_person2.company = ' ||
-- v_person2.company);
-- the following line will not compile because you cannot
-- directly assign a t_person object to a t_business_person
-- object
-- v_business_person2 := v_person;

--Como o código acima não compila, ISSO SIGNIFICA DIZER QUE NÃO É POSSÍVEL USAR UM SUPERTIPO NO LUGAR DE UM SUBTIPO.
--ISSO OCORRE PORQUE O SUPERTIPO NÃO RECONHECE AS DIFERENÇAS DO SUBTIPO(ATRIBUTOS E/OU METODOS DIFERENTES).
--O INVERSO É VERDADEIRO JÁ QUE O SUBTIPO TEM TUDO QUE O SUPERTIPO TEM E MAIS UM POUCO
END subtypes_and_supertypes;

--Testando a procedure
SET SERVEROUTPUT ON;
BEGIN
    subtypes_and_supertypes ();
END;

--É possível previnir que um subtipo seja usado no lugar do supertipo. Para isso usar a clausula NOT SUBSTITUTABLE

CREATE TABLE object_customers_not_subs OF t_person
NOT SUBSTITUTABLE AT ALL LEVELS;

--A clausula not substitutable não deixa colocar business_person na tabela só person
INSERT INTO object_customers_not_subs VALUES ( t_business_person(
    1,
    'Steve',
    'Edwards',
    '03-MAR-1955',
    '800-555-1212',
    t_address(
        '1 Market Street',
        'Anytown',
        'VA',
        '12345'
    ),
    'Manager',
    'XYZ Corp'
) );

--é possível usar essa clausula em colunas com tipo de objeto como no exemplo abaixo

CREATE TABLE products (
product t_product,
quantity_in_stock INTEGER
)
COLUMN product NOT SUBSTITUTABLE AT ALL LEVELS;

--Desse modo a coluna product só aceita objetos T_product

--Outras funções de objeto

--IS OF() verifica se o objeto é ou não do tipo passado
--sqlplus
SELECT VALUE(o)
FROM object_business_customers o
WHERE VALUE(o) IS OF (t_business_person);

--Como um subtipo pode ser usado como supertipo é possível usar o tipo t_person no IS OF e retornar um objeto que é uma business_person
--Substituir t_business_person por t_person e testar no sqlplus

--é possível usar mais de um tipo no IS OF
SELECT VALUE(o)
FROM object_business_customers o
WHERE VALUE(o) IS OF (t_business_person, t_person);

--Para fazer com que o IS OF verifique somente o tipo passado e não retorne verdadeiro quando um subtipo esta substituindo um supertipo, 
--deve-se usar o ONLY. No sqlplus
SELECT VALUE(o)
FROM object_customers o
WHERE VALUE(o) IS OF (ONLY t_person);

--é possível usar multiplos tipos de objeto com o ONLY
SELECT VALUE(o)
FROM object_customers o
WHERE VALUE(o) IS OF (ONLY t_person, t_business_person);

---------EXEMPLO IS OF COM PL/SQL---------------

CREATE PROCEDURE check_types AS
-- create objects

    v_business_person   t_business_person := t_business_person(
        1,
        'John',
        'Brown',
        '01-FEV-1955',
        '800-555-1211',
        t_address(
            '2 State Street',
            'Beantown',
            'MA',
            '12345'
        ),
        'Manager',
        'XYZ Corp'
    );
    v_person            t_person := t_person(
        1,
        'John',
        'Brown',
        '01-FEV-1955',
        '800-555-1211',
        t_address(
            '2 State Street',
            'Beantown',
            'MA',
            '12345'
        )
    );
BEGIN
-- check the types of the objects
    IF v_business_person IS OF ( t_business_person )
    THEN
        dbms_output.put_line('v_business_person is of type ' || 't_business_person');
    END IF;

    IF v_person IS OF ( t_person )
    THEN
        dbms_output.put_line('v_person is of type t_person');
    END IF;
    IF v_business_person IS OF ( t_person )
    THEN
        dbms_output.put_line('v_business_person is of type t_person');
    END IF;
    IF v_business_person IS OF ( t_business_person,t_person )
    THEN
        dbms_output.put_line('v_business_person is of ' || 'type t_business_person or t_person');
    END IF;

    IF v_business_person IS OF ( ONLY t_business_person )
    THEN
        dbms_output.put_line('v_business_person is of only ' || 'type t_business_person');
    END IF;

    IF v_business_person IS OF ( ONLY t_person )
    THEN
        dbms_output.put_line('v_business_person is of only ' || 'type t_person');
    ELSE
        dbms_output.put_line('v_business_person is not of only ' || 'type t_person');
    END IF;

END check_types;

BEGIN
   check_types();
END;

--TREAT pode ser usada para verificar se um tipo pode ser tratado como um tipo diferente em operações.
--Caso possa, o TREAT retorna um objeto, senão retorna nulo
--O TREAT DEVE RECEBER UM TIPO DEPOIS DO AS. 


--Como essa tabela tem duas pessoas
SELECT TREAT(value(o) AS t_business_person) treat_business_person
FROM object_customers o;

SELECT TREAT(value(o) AS t_person) treat_business_person
FROM object_customers o;

--COM O TREAT É POSSÍVEL ACESSAR AS PARTES ESPECÍFICAS DE UM SUBTIPO
--O titulo é somente um atributo para um tipo business_person
SELECT TREAT(value(o) AS t_business_person).title title
FROM object_customers o;

--TREAT com REF
--sqlplus
SELECT TREAT(REF(o) AS REF t_business_person) ref
FROM object_customers o;

--TREAT COM PL/SQL---------------------

CREATE OR REPLACE PROCEDURE treat_example AS
  -- create objects
  v_business_person t_business_person :=
  t_business_person(
    1, 'John', 'Brown',
    '01-FEV-1955', '800-555-1211',
    t_address('2 State Street', 'Beantown', 'MA', '12345'),
    'Manager', 'XYZ Corp'
  );
  v_person t_person :=
  t_person(1, 'John', 'Brown', '01-FEV-1955', '800-555-1211',
  t_address('2 State Street', 'Beantown', 'MA', '12345'));
  v_business_person2 t_business_person;
  v_person2 t_person;

BEGIN
  -- assign v_business_person to v_person2
  v_person2 := v_business_person;
  -- use TREAT when assigning v_business_person to v_person2
  DBMS_OUTPUT.PUT_LINE('Using TREAT');
  v_person2 := TREAT(v_business_person AS t_person);

  -- the following lines do compile because TREAT is used
  DBMS_OUTPUT.PUT_LINE('v_person2.title = ' ||
  TREAT(v_person2 AS t_business_person).title);
  DBMS_OUTPUT.PUT_LINE('v_person2.company = ' ||
  TREAT(v_person2 AS t_business_person).company);

  -- the following line throws a runtime error because you cannot
  -- assign a supertype object (v_person) to a subtype object
  -- (v_business_person2)
  --Em essencia isso da erro PORQUE NÃO É POSSÍVEL SUBSTITUIR UM SUBTIPO POR UM SUPERTIPO
  v_business_person2 := TREAT(v_person AS t_business_person);
END treat_example;

--TESTE DA PROCEDURE
BEGIN
    treat_example ();
END;

--SYS_TYPEID() serve para pegar o ID do tipo do objeto.
SELECT SYS_TYPEID(VALUE(o))
FROM object_business_customers o;

--Consultar dados sobre os tipos de objetos
SELECT * FROM user_types;

--NOT INSTANTIABLE
--É possível criar um super objeto que não pode ser instanciado. Como o propósito desse objeto é ser herdado, ele deve ser NOT FINAL
--Esse conceito simula classes abstrata em Java
--Exemplo
CREATE TYPE t_vehicle AS OBJECT (
    id      INTEGER,
    make    VARCHAR2(15),
    model   VARCHAR2(15)
) NOT FINAL NOT INSTANTIABLE;

--Criação do tipo car e motorcycle a partir do vehicle

CREATE TYPE t_car UNDER t_vehicle (
    convertible   CHAR(1)
);

CREATE TYPE t_motorcycle UNDER t_vehicle (
    sidecar   CHAR(1)
);

CREATE TABLE vehicles OF t_vehicle;
CREATE TABLE cars OF t_car;
CREATE TABLE motorcycles OF t_motorcycle;

INSERT INTO vehicles VALUES (
 t_vehicle(1, 'Toyota', 'MR2', '01-FEB-1955')
 );
--Como o objeto t_vehicle não pode ser instanciado, nao é possivel inserí-lo na tabela

--Inserção de carros e motocicletas
INSERT INTO cars VALUES ( t_car(
    1,
    'Toyota',
    'MR2',
    'Y'
) );

INSERT INTO motorcycles VALUES ( t_motorcycle(
    1,
    'Harley-Davidson',
    'V-Rod',
    'N'
) ); 

SELECT * FROM cars;

SELECT * FROM motorcycles;
 