
---MANIPULANDO VARRAYS COM PLSQL------------------------

CREATE PACKAGE varray_package AS
    TYPE t_ref_cursor IS REF CURSOR;
    FUNCTION get_customers RETURN t_ref_cursor;

    PROCEDURE insert_customer (
        p_id           IN customers_with_varray.id%TYPE,
        p_first_name   IN customers_with_varray.first_name%TYPE,
        p_last_name    IN customers_with_varray.last_name%TYPE,
        p_addresses    IN customers_with_varray.addresses%TYPE
    );

END varray_package;
/

CREATE PACKAGE BODY varray_package AS
-- get_customers() function returns a REF CURSOR
-- that points to the rows in customers_with_varray

    FUNCTION get_customers RETURN t_ref_cursor IS
--declare the REF CURSOR object
        v_customers_ref_cursor   t_ref_cursor;
    BEGIN
-- get the REF CURSOR
        OPEN v_customers_ref_cursor FOR SELECT *
        FROM customers_with_varray;
-- return the REF CURSOR

        RETURN v_customers_ref_cursor;
    END get_customers;
-- insert_customer() procedure adds a row to
-- customers_with_varray

    PROCEDURE insert_customer (
        p_id           IN customers_with_varray.id%TYPE,
        p_first_name   IN customers_with_varray.first_name%TYPE,
        p_last_name    IN customers_with_varray.last_name%TYPE,
        p_addresses    IN customers_with_varray.addresses%TYPE
    )
        IS
    BEGIN
        INSERT INTO customers_with_varray VALUES (
            p_id,
            p_first_name,
            p_last_name,
            p_addresses
        );

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END insert_customer;

END varray_package;
/

--TESTE da procedure para inserir clientes

BEGIN
    varray_package.insert_customer(
        3,
        'James',
        'Red',
        t_varray_address('10 Main Street,Green Town,CA,22212','20 State Street,Blue Town,FL,22213')
    );
END;

--Consulta os clientes
SELECT varray_package.get_customers FROM dual;

----------MANIPULANDO NESTED TABELS COM PL/SQL------------------------

CREATE PACKAGE nested_table_package AS
    TYPE t_ref_cursor IS REF CURSOR;
    FUNCTION get_customers RETURN t_ref_cursor;

    PROCEDURE insert_customer (
        p_id           IN customers_with_nested_table.id%TYPE,
        p_first_name   IN customers_with_nested_table.first_name%TYPE,
        p_last_name    IN customers_with_nested_table.last_name%TYPE,
        p_addresses    IN customers_with_nested_table.addresses%TYPE
    );

END nested_table_package;
/

CREATE PACKAGE BODY nested_table_package AS
-- get_customers() function returns a REF CURSOR
-- that points to the rows in customers_with_nested_table

    FUNCTION get_customers RETURN t_ref_cursor IS
-- declare the REF CURSOR object
        v_customers_ref_cursor   t_ref_cursor;
    BEGIN
-- get the REF CURSOR
        OPEN v_customers_ref_cursor FOR SELECT *
        FROM customers_with_nested_table;
-- return the REF CURSOR

        RETURN v_customers_ref_cursor;
    END get_customers;
-- insert_customer() procedure adds a row to
-- customers_with_nested_table

    PROCEDURE insert_customer (
        p_id           IN customers_with_nested_table.id%TYPE,
        p_first_name   IN customers_with_nested_table.first_name%TYPE,
        p_last_name    IN customers_with_nested_table.last_name%TYPE,
        p_addresses    IN customers_with_nested_table.addresses%TYPE
    )
        IS
    BEGIN
        INSERT INTO customers_with_nested_table VALUES (
            p_id,
            p_first_name,
            p_last_name,
            p_addresses
        );

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END insert_customer;

END nested_table_package;
/

--inserção do cliente

BEGIN
    nested_table_package.insert_customer(
        3,
        'James',
        'Red',
        t_nested_table_address(
            t_address(
                '10 Main Street',
                'Green Town',
                'CA',
                '22212'
            ),
            t_address(
                '20 State Street',
                'Blue Town',
                'FL',
                '22213'
            )
        )
    );
END;

--Consultando os clientes
SELECT nested_table_package.get_customers FROM dual;

--métodos de coleções

/*COUNT 
Returns the number of elements in a collection. Because a nested table
can have individual elements that are empty, COUNT returns the number
of non-empty elements in a nested table.

DELETE
DELETE(n)
DELETE(n, m)
Removes elements from a collection. There are three forms of DELETE:
1 DELETE removes all elements.
2 DELETE(n) removes element n.
3 DELETE(n, m) removes elements n through m.
Because varrays always have consecutive subscripts, you cannot delete
individual elements from a varray (except from the end by using TRIM).

EXISTS(n) Returns true if element n in a collection exists: EXISTS returns true for
non-empty elements and false for empty elements of nested tables or
elements beyond the range of a collection.

EXTEND
EXTEND(n)
EXTEND(n, m)
Adds elements to the end of a collection. There are three forms of
EXTEND:
1 EXTEND adds one element, which is set to null.
2 EXTEND(n) adds n elements, which are set to null.
3 EXTEND(n, m) adds n elements, which are set to a copy of the m
element.

FIRST Returns the index of the first element in a collection. If the collection is
completely empty, FIRST returns null. Because a nested table can have
individual elements that are empty, FIRST returns the lowest index of a
non-empty element in a nested table.

LAST Returns the index of the last element in a collection. If the collection is
completely empty, LAST returns null. Because a nested table can have
individual elements that are empty, LAST returns the highest index of a
non-empty element in a nested table.

LIMIT For nested tables, which have no declared size, LIMIT returns null. For
varrays, LIMIT returns the maximum number of elements that the varray
can contain. You specify the limit in the type definition. The limit is
changed when using TRIM and EXTEND, or when you use ALTER TYPE
to change the limit.

NEXT(n) Returns the index of the element after n. Because a nested table can have
individual elements that are empty, NEXT returns the index of a nonempty
element after n. If there are no elements after n, NEXT returns null.

PRIOR(n) Returns the index of the element before n. Because a nested table can have
individual elements that are empty, PRIOR returns the index of a non-empty
element before n. If there are no elements before n, PRIOR returns null.

TRIM
TRIM(n)
Removes elements from the end of a collection. There are two forms of
TRIM:
1 TRIM removes one element from the end.
2 TRIM(n) removes n elements from the end.*/
