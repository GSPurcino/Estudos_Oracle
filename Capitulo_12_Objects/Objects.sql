--------------------------------------OBJETOS---------------------------------
--Cria��o de objeto

CREATE TYPE t_address AS OBJECT (
    street   VARCHAR2(15),
    city     VARCHAR2(15),
    state    CHAR(2),
    zip      VARCHAR2(5)
);

--� poss�vel usar um objeto como tipo para o atributo de um outro objeto

CREATE TYPE t_person AS OBJECT (
    id           INTEGER,
    first_name   VARCHAR2(10),
    last_name    VARCHAR2(10),
    dob          DATE,
    phone        VARCHAR2(12),
    address      t_address
);

--Cria��o de um objeto que possui m�todo. Como o objeto possui m�todo, � necess�rio criar um BODY para o TYPE

--Quando criar um tipo DEVE-SE PRIMEIRO EXECUTAR O CREATE TYPE E DEPOIS EXECUTAR O CREATE TYPE BODY COM OS DOIS END INCLUSOS

CREATE TYPE t_product AS OBJECT (
    id            INTEGER,
    name          VARCHAR2(15),
    description   VARCHAR2(22),
    price         NUMBER(5,2),
    days_valid    INTEGER,
-- get_sell_by_date() returns the date by which the
-- product must be sold

    MEMBER FUNCTION get_sell_by_date RETURN DATE
);

CREATE TYPE BODY t_product AS
-- get_sell_by_date() returns the date by which the
-- product must be sold
    MEMBER FUNCTION get_sell_by_date RETURN DATE IS
        v_sell_by_date   DATE;
    BEGIN
-- calculate the sell by date by adding the days_valid attribute
-- to the current date (SYSDATE)
        SELECT days_valid + SYSDATE INTO
            v_sell_by_date
        FROM dual;
-- return the sell by date

        RETURN v_sell_by_date;
    END;
END;

--Consultando dados dos objetos
DESCRIBE t_address;

DESCRIBE t_person;

--� poss�vel fazer uma descri��o mais detalhada de objetos. O atributo address de pessoa � do tipo do objeto address.
--Para ver como esse objeto � composto a partir de person, deve-se adicionar profundidade ao DESCRIBE
SET DESCRIBE DEPTH 2;
--Funciona s� no SQLPLUS

DESCRIBE t_product;

--------------------------Usando objetos em tabelas-------------------

--Criando uma tabela com uma coluna de tipo de objeto

CREATE TABLE products_object_column (
    product    t_product,
    quantity   INTEGER
);

--Para inserir nessa tabela a parte do objeto � necess�rio usar um construtor.
--Um construtor � um m�todo com o mesmo nome do objeto que � usado para passar valor para os atributos desse objeto.
--Esse m�todo � criado automaticamente toda vez que um objeto � criado

INSERT INTO products_object_column ( product,quantity ) VALUES (
    t_product(
        1,
        'pasta',
        '20 oz bag of pasta',
        3.95,
        10
    ),
    50
);

INSERT INTO products_object_column ( product,quantity ) VALUES (
    t_product(
        2,
        'sardines',
        '12 oz box of sardines',
        2.99,
        5
    ),
    25
);

--Usando nota��o nomeada com construtores
INSERT INTO products_object_column ( product,quantity ) VALUES (
    t_product(
        id => 3,
        name => 'Rice',
        description => '50g of rice',
        price => 2.99,
        days_valid => 7
    ),
    30
);

SELECT * FROM products_object_column;

--Para selecionar os atributos do objeto individualmente � necess�rio usar um ALIAS na tabela para poder fazer a nota��o com . completa
SELECT poc.product.id,
       poc.product.name,
       poc.product.description,
       poc.product.price,
       poc.product.days_valid,
       poc.quantity
FROM products_object_column poc;

--Chamando o m�todo do objeto
SELECT poc.product.get_sell_by_date()
FROM products_object_column poc;

--UPDATE

UPDATE products_object_column poc
    SET
        poc.product.description = '30 oz bag of pasta'
WHERE poc.product.id   = 1;

--DELETE

DELETE FROM products_object_column poc WHERE poc.product.id   = 2;

---------------------------------------------------TABELA DE OBJETOS------------------------------

--� poss�vel criar uma tabela definida a partir dos atributos de um objeto. Esse tipo de tabela � chamado de tabela de objetos

CREATE TABLE object_products OF t_product;

--Quando for inserir numa tabela assim, � poss�vel usar um construtor do objeto ou passar os valores diretamente

INSERT INTO object_products VALUES ( t_product(
    1,
    'pasta',
    '20 oz bag of pasta',
    3.95,
    10
) );

INSERT INTO object_products (
    id,
    name,
    description,
    price,
    days_valid
) VALUES (
    2,
    'sardines',
    '12 oz box of sardines',
    2.99,
    5
);

SELECT * FROM object_products;

--selecionando atributos individuais do objeto

SELECT id,
       name,
       price
FROM object_products op
WHERE id   = 1;

--� poss�vel usar a fun��o padr�o VALUE() para ver um registro de uma tabela de objetos

SELECT value(op) FROM object_products op;

--� poss�vel usar os atributos do objeto na fun��o value
SELECT VALUE(op).id, VALUE(op).name, VALUE(op).price
FROM object_products op;


--UPDATE E DELETE

UPDATE object_products
SET description = '25 oz bag of pasta'
WHERE id = 1;

DELETE FROM object_products
WHERE id = 2;

CREATE TABLE object_customers OF t_person;

INSERT INTO object_customers VALUES ( t_person(
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
) );

INSERT INTO object_customers (
    id,
    first_name,
    last_name,
    dob,
    phone,
    address
) VALUES (
    2,
    'Cynthia',
    'Green',
    '05-FEV-1968',
    '800-555-1212',
    t_address(
        '3 Free Street',
        'Middle Town',
        'CA',
        '12345'
    )
);

SELECT *
FROM object_customers oc
WHERE oc.id   = 1;

SELECT *
FROM object_customers oc
WHERE oc.address.state = 'MA';

--Como o address � um objeto, para ver seu atributos � necess�rio referencia-lo de forma diferente
SELECT oc.id,
       oc.first_name,
       oc.last_name,
       oc.address.street,
       oc.address.city,
       oc.address.state,
       oc.address.zip
FROM object_customers oc
WHERE oc.id   = 1;

--OBJECT ID e OBJECT REFERENCE

--Cada objeto em uma tabela objeto possui um identificador unico chamado OID(OBJECT ID). � poss�vel consultar esse OID usando a funcao REF()

--------------------------------------------------FAZER NO SQL PLUS--------------------------------------------------------------------
SELECT REF(oc) FROM object_customers oc
WHERE oc.id   = 1;

--O retorno dessa fun��o REF � o OID. � poss�vel guardar esse OID em uma REF para poder acessar o objeto referenciado posteriormente.
--Na pr�tica uma refer�ncia para um objeto � um ponteiro para ele.
--� poss�vel usar refer�ncias de objeto para modelar relacionamentos entre tabelas de objeto.

--O REF � usado para definir uma refer�ncia a um objeto
CREATE TABLE purchases_ref_objects (
    id             INTEGER PRIMARY KEY,
    customer_ref   REF t_person
        SCOPE IS object_customers,
    product_ref    REF t_product
        SCOPE IS object_products
);

--O SCOPE IS diz para qual tipo de objeto a referencia deve apontar

INSERT INTO purchases_ref_objects ( id,customer_ref,product_ref ) VALUES (
    1,
    ( SELECT REF(oc) FROM object_customers oc
    WHERE oc.id   = 1 ),
    ( SELECT REF(op) FROM object_products op
    WHERE op.id   = 1 )
);

SELECT *
FROM purchases_ref_objects;

--� possivel usar a fun��o de Dereferenciar para obter qual objeto a refer�ncia est� apontando

SELECT deref(customer_ref),
       deref(product_ref)
FROM purchases_ref_objects;

SELECT deref(customer_ref).first_name,
       deref(customer_ref).address.street,
       deref(product_ref).name
FROM purchases_ref_objects;

--Alterando a REF

UPDATE purchases_ref_objects
    SET
        product_ref = ( SELECT REF(op) FROM object_products op
        WHERE op.id   = 2 )
WHERE id   = 1;

----------------------COMPARA��O DE VALORES ENTRE OBJETOS--------------------------------------

--Pode-se comparar dois objetos usando a = no WHERE
--Importante lembrar que o objeto todo deve ser passado depois do operador
SELECT oc.id,
       oc.first_name,
       oc.last_name,
       oc.dob
FROM object_customers oc
WHERE value(oc) = t_person(
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

SELECT op.id,
       op.name,
       op.price,
       op.days_valid
FROM object_products op
WHERE value(op) = t_product(
        1,
        'pasta',
        '20 oz bag of pasta',
        3.95,
        10
    );
    
--� poss�vel usar o operador <> tamb�m  

SELECT oc.id,
       oc.first_name,
       oc.last_name,
       oc.dob
FROM object_customers oc
WHERE value(oc) <> t_person(
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
    
--Assim como o IN

SELECT op.id,
       op.name,
       op.price,
       op.days_valid
FROM object_products op
WHERE value(op) IN t_product(
        1,
        'pasta',
        '20 oz bag of pasta',
        3.95,
        10
    );    
    
--Usando outros operadores de compara��o(>, <, etc.)
--Para usar esses operadores com objetos � necess�rio usar uma map function(fun��o de mapeamneto). 
--A Map Function nada mais � do que uma forma para representar o valor d eum objeto. Ela deve retornar alguma coisa e essa coisa deve ser �nica para cada tipo de objeto.

--Exemplo 
CREATE TYPE t_person2 AS OBJECT (
    id           INTEGER,
    first_name   VARCHAR2(10),
    last_name    VARCHAR2(10),
    dob          DATE,
    phone        VARCHAR2(12),
    address      t_address,
-- declare the get_string() map function,
-- which returns a VARCHAR2 string

    MAP MEMBER FUNCTION get_string RETURN VARCHAR2
);

CREATE TYPE BODY t_person2 AS
-- define the get_string() map function
    MAP MEMBER FUNCTION get_string RETURN VARCHAR2
        IS
    BEGIN
-- return a concatenated string containing the
-- last_name and first_name attributes
        RETURN last_name || ' ' || first_name;
    END get_string;

END;
    
CREATE TABLE object_customers2 OF t_person2;

INSERT INTO object_customers2 VALUES ( t_person2(
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
) );

INSERT INTO object_customers2 VALUES ( t_person2(
    2,
    'Cynthia',
    'Green',
    '05-FEV-1968',
    '800-555-1212',
    t_address(
        '3 Free Street',
        'Middle Town',
        'CA',
        '12345'
    )
) );   

--Usando o operador >
SELECT oc2.id,
       oc2.first_name,
       oc2.last_name,
       oc2.dob
FROM object_customers2 oc2
WHERE value(oc2) > t_person2(
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
    
    
    