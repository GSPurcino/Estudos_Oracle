-------------------------OBJETOS EM PL/SQL------------------------------------

CREATE OR REPLACE PACKAGE product_package_object AS
    TYPE t_ref_cursor IS REF CURSOR;
    FUNCTION get_products RETURN t_ref_cursor;

    PROCEDURE display_product ( p_id   IN object_products.id%TYPE );

    PROCEDURE insert_product (
        p_id            IN object_products.id%TYPE,
        p_name          IN object_products.name%TYPE,
        p_description   IN object_products.description%TYPE,
        p_price         IN object_products.price%TYPE,
        p_days_valid    IN object_products.days_valid%TYPE
    );

    PROCEDURE update_product_price (
        p_id       IN object_products.id%TYPE,
        p_factor   IN NUMBER
    );

    FUNCTION get_product ( p_id   IN object_products.id%TYPE ) RETURN t_product;

    PROCEDURE update_product ( p_product t_product );

    FUNCTION get_product_ref ( p_id   IN object_products.id%TYPE ) RETURN REF t_product;

    PROCEDURE delete_product ( p_id   IN object_products.id%TYPE );

END product_package_object;

CREATE OR REPLACE PACKAGE BODY product_package_object AS

    FUNCTION get_products RETURN t_ref_cursor IS
-- declare a t_ref_cursor object
        v_products_ref_cursor   t_ref_cursor;
    BEGIN
-- get the REF CURSOR
        OPEN v_products_ref_cursor FOR SELECT value(op)
        FROM object_products op
        ORDER BY op.id;
-- return the REF CURSOR

        RETURN v_products_ref_cursor;
    END get_products;
    
    PROCEDURE display_product ( p_id   IN object_products.id%TYPE ) AS
-- declare a t_product object named v_product
    v_product   t_product;
BEGIN
-- attempt to get the product and store it in v_product
    SELECT value(op) INTO
        v_product
    FROM object_products op
    WHERE id   = p_id;
-- display the attributes of v_product

    dbms_output.put_line('v_product.id=' || v_product.id);
    dbms_output.put_line('v_product.name=' || v_product.name);
    dbms_output.put_line('v_product.description=' || v_product.description);
    dbms_output.put_line('v_product.price=' || v_product.price);
    dbms_output.put_line('v_product.days_valid=' || v_product.days_valid);
-- call v_product.get_sell_by_date() and display the date
    dbms_output.put_line('Sell by date=' || v_product.get_sell_by_date() );
END display_product;

PROCEDURE insert_product (
    p_id            IN object_products.id%TYPE,
    p_name          IN object_products.name%TYPE,
    p_description   IN object_products.description%TYPE,
    p_price         IN object_products.price%TYPE,
    p_days_valid    IN object_products.days_valid%TYPE
) AS
-- create a t_product object named v_product
    v_product   t_product := t_product(
        p_id,
        p_name,
        p_description,
        p_price,
        p_days_valid
    );
BEGIN
-- add v_product to the object_products table
    INSERT INTO object_products VALUES ( v_product );

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
END insert_product;

PROCEDURE update_product_price (
    p_id       IN object_products.id%TYPE,
    p_factor   IN NUMBER
) AS
-- declare a t_product object named v_product
    v_product   t_product;
BEGIN
-- attempt to select the product for update and
-- store the product in v_product
    SELECT value(op) INTO
        v_product
    FROM object_products op
    WHERE id   = p_id FOR UPDATE;
-- display the current price of v_product

    dbms_output.put_line('v_product.price=' || v_product.price);
-- multiply v_product.price by p_factor
    v_product.price   := v_product.price * p_factor;
    dbms_output.put_line('New v_product.price=' || v_product.price);
-- update the product in the object_products table
    UPDATE object_products op
        SET
            op = v_product
    WHERE id   = p_id;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
END update_product_price;

FUNCTION get_product ( p_id   IN object_products.id%TYPE ) RETURN t_product IS
-- declare a t_product object named v_product
    v_product   t_product;
BEGIN
-- get the product and store it in v_product
    SELECT value(op) INTO
        v_product
    FROM object_products op
    WHERE op.id   = p_id;
-- return v_product

    RETURN v_product;
END get_product;

PROCEDURE update_product ( p_product IN t_product )
    AS
BEGIN
-- update the product in the object_products table
    UPDATE object_products op
        SET
            op = p_product
    WHERE id   = p_product.id;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
END update_product;

FUNCTION get_product_ref ( p_id   IN object_products.id%TYPE ) RETURN REF t_product IS
-- declare a reference to a t_product
    v_product_ref   REF t_product;
BEGIN
-- get the REF for the product and
-- store it in v_product_ref
    SELECT REF(op) INTO
        v_product_ref
    FROM object_products op
    WHERE op.id   = p_id;
-- return v_product_ref

    RETURN v_product_ref;
END get_product_ref;

PROCEDURE delete_product ( p_id   IN object_products.id%TYPE )
    AS
BEGIN
-- delete the product
    DELETE FROM object_products op WHERE op.id   = p_id;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
END delete_product;

END product_package_object;

-------------------------------------teste da package---------------------------

--É possível retornar um REF CURSOR para o cliente
SELECT product_package_object.get_products
FROM dual;

--Mostra os atributos de um objeto
SET SERVEROUTPUT ON;

BEGIN
    product_package_object.display_product(1);
END;

--Adicionar um produto na tabela
BEGIN
    product_package_object.insert_product(
        3,
        'salsa',
        '15 oz jar of salsa',
        1,
        20
    );
END;

--Alteração do preço do produto
BEGIN
    product_package_object.update_product_price(3,2.4);
END;

--Retorna um objeto produto
SELECT product_package_object.get_product(3) FROM dual;

--Alteração de todos os atributos de um produto
BEGIN
    product_package_object.update_product(t_product(
        3,
        'salsa',
        '25 oz jar of salsa',
        2,
        15
    ) );
END;

--Retorna a referencia para um produto
SELECT product_package_object.get_product_ref(3)
FROM dual;

--Elimina um produto
BEGIN
    product_package_object.delete_product(3);
END;

