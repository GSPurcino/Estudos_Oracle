----------------------------------------CONSTRUTORES-----------------------------

--Assim como em outras linguagens orientadas a objeto, � poss�vel definir construtores para inicializar o objeto
--Por padr�o, toda vez que um objeto � criado, o sistema criar um construtor padr�o que DEVE receber todos os atributos do objeto para inicializar com sucesso.
--A dsevantagem disso � que nem sempre todos os atributos de um objeto devem ser inicializados
--O construtor deve ter o mesmo nome do tipo do objeto
--Por padr�o para ter multiplos construtores e necess�rio fazer sobrecarga. M�todos com o mesmo nome, por�m com os par�mteros diferentes
--A parte REFTURN SELF AS RESULT serve para garantir que o construtor retorne uma inst�ncia do tipo do objeto no qual ele foi chamado
--Um construtor n�o pode ser herdado

CREATE TYPE t_person2 AS OBJECT (
    id           INTEGER,
    first_name   VARCHAR2(10),
    last_name    VARCHAR2(10),
    dob          DATE,
    phone        VARCHAR2(12),

    CONSTRUCTOR FUNCTION t_person2 (
        p_id           INTEGER,
        p_first_name   VARCHAR2,
        p_last_name    VARCHAR2
    ) RETURN SELF AS RESULT,

    CONSTRUCTOR FUNCTION t_person2 (
        p_id           INTEGER,
        p_first_name   VARCHAR2,
        p_last_name    VARCHAR2,
        p_dob          DATE
    ) RETURN SELF AS RESULT
);

-- No cropo do construtor a palavra RETURN; sem express�es DEVE ESTAR PRESENTE para poder retornar inst�nicas dos objetos.
CREATE TYPE BODY t_person2 AS
    CONSTRUCTOR FUNCTION t_person2 (
        p_id           INTEGER,
        p_first_name   VARCHAR2,
        p_last_name    VARCHAR2
    ) RETURN SELF AS RESULT
        IS
    BEGIN
        self.id           := p_id;
        self.first_name   := p_first_name;
        self.last_name    := p_last_name;
        self.dob          := SYSDATE;
        self.phone        := '555-1212';
        return;
    END;

    CONSTRUCTOR FUNCTION t_person2 (
        p_id           INTEGER,
        p_first_name   VARCHAR2,
        p_last_name    VARCHAR2,
        p_dob          DATE
    ) RETURN SELF AS RESULT
        IS
    BEGIN
        self.id           := p_id;
        self.first_name   := p_first_name;
        self.last_name    := p_last_name;
        self.dob          := p_dob;
        self.phone        := '555-1213';
        return;
    END;

END;

--consultar os construtores

DESCRIBE t_person2;

CREATE TABLE object_customers2 OF t_person2;

--Usando o primeiro construtor
INSERT INTO object_customers2 VALUES ( t_person2(1,'Jeff','Jones') );

SELECT *
FROM object_customers2 WHERE id   = 1;

--Usando o segundo construtor
INSERT INTO object_customers2 VALUES ( t_person2(
    2,
    'Gregory',
    'Smith',
    '03-ABR-1965'
) );

SELECT *
FROM object_customers2 WHERE id   = 2;

--Usando o construtor padr�o
INSERT INTO object_customers2 VALUES ( t_person2(
    3,
    'Jeremy',
    'Hill',
    '05-JUN-1975',
    '555-1214'
) );

SELECT *
FROM object_customers2 WHERE id   = 3;

------------------------SOBREESCREVER M�TODOS-----------------

--Quando uma hierarquia de tipos � criada, � poss�vel sobreescrever no subtipo os m�todos herdados do supertipo

CREATE TYPE t_person3 AS OBJECT (
    id           INTEGER,
    first_name   VARCHAR2(10),
    last_name    VARCHAR2(10),

    MEMBER FUNCTION display_details RETURN VARCHAR2
) NOT FINAL;

CREATE TYPE BODY t_person3 AS
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

--Criando o subtipo para sobreescrever o m�todo display_details
CREATE TYPE t_business_person3 UNDER t_person3 (
    title     VARCHAR2(20),
    company   VARCHAR2(20),

    OVERRIDING MEMBER FUNCTION display_details RETURN VARCHAR2
);

CREATE TYPE BODY t_business_person3 AS OVERRIDING
    MEMBER FUNCTION display_details RETURN VARCHAR2
        IS
    BEGIN
        RETURN 'id='
         || id
         || ',name='
         || first_name
         || ' '
         || last_name
         || ',title='
         || title
         || ',company='
         || company;
    END;

END;

CREATE TABLE object_business_customers3 OF t_business_person3;

INSERT INTO object_business_customers3 VALUES ( t_business_person3(
    1,
    'John',
    'Brown',
    'Manager',
    'XYZ Corp'
) );

--Como business_person3 sobreescreveu o m�todo display_details de t_person3, o display_details do t_business_person3 que e chamado aqui
SELECT o.display_details()
FROM object_business_customers3 o
WHERE id = 1;

--Invoca��o generalizada
--Essa op��o foi disponibilizada a partir do oracle 11 e permite chamar um m�todo do supertipo num subtipo

CREATE TYPE t_person4 AS OBJECT (
    id           INTEGER,
    first_name   VARCHAR2(10),
    last_name    VARCHAR2(10),

    MEMBER FUNCTION display_details RETURN VARCHAR2
) NOT FINAL;

CREATE TYPE BODY t_person4 AS
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

--Criando o subtipo com a invoca��o generalizada

CREATE TYPE t_business_person4 UNDER t_person4 (
    title     VARCHAR2(20),
    company   VARCHAR2(20),

    OVERRIDING MEMBER FUNCTION display_details RETURN VARCHAR2
);

CREATE TYPE BODY t_business_person4 AS OVERRIDING
    MEMBER FUNCTION display_details RETURN VARCHAR2
        IS
    BEGIN
-- use generalized invocation to call display_details() in t_person
        RETURN ( self AS t_person ).display_details
         || ',title='
         || title
         || ',company='
         || company;
    END;

END;

CREATE TABLE object_business_customers4 OF t_business_person4;

INSERT INTO object_business_customers4 VALUES ( t_business_person4(
    1,
    'John',
    'Brown',
    'Manager',
    'XYZ Corp'
) );

--chamando o display_details
SELECT o.display_details()
FROM object_business_customers4 o;
