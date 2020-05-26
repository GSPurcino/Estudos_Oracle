-- product_cursor3.sql displays the product_id,name,
-- and price columns from the products table using a cursor
-- variable and the OPEN-FOR statement
SET SERVEROUTPUT ON;

DECLARE
-- declare a REF CURSOR type named t_product_cursor
    TYPE t_product_cursor IS REF CURSOR RETURN products%rowtype;
-- declare a t_product_cursor object named v_product_cursor
    v_product_cursor   t_product_cursor;
-- declare an object to store columns from the products table
-- named v_product (of type products%ROWTYPE)
    v_product          products%rowtype;
BEGIN
-- assign a query to v_product_cursor and open it using OPEN-FOR
    OPEN v_product_cursor FOR SELECT *
    FROM products WHERE product_id < 5;
-- use a loop to fetch the rows from v_product_cursor into v_product

    LOOP
        FETCH v_product_cursor INTO v_product;
        EXIT WHEN v_product_cursor%notfound;
        dbms_output.put_line('product_id = '
         || v_product.product_id
         || ',name = '
         || v_product.name
         || ',price = '
         || v_product.price);

    END LOOP;
-- close v_product_cursor

    CLOSE v_product_cursor;
END;
/