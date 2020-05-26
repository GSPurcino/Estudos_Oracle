-----------------------------------PROCEDURES------------------------------------------
SELECT price
FROM products
WHERE product_id = 1;

--Antes de chamar a procedure que altera o preco do produto

--Chamada da procedure com o CALL
CALL update_product_price(1, 1.5);

--Depois de chamar a procedure que altera o preco do produto
SELECT price
FROM products
WHERE product_id = 1;

--Consultar informacoes das procedures
SELECT object_name,
       aggregate,
       parallel
FROM user_procedures WHERE object_name   = 'UPDATE_PRODUCT_PRICE';

--Eliminando uma procedure
DROP PROCEDURE update_product_price;

------------------------------------------------FUNCTIONS-----------------------------------------

--Chamando a função
SELECT circle_area(2)
FROM dual;

SELECT average_product_price(1)
FROM dual;

--Consultar dados sobre funcoes
SELECT object_name,
       aggregate,
       parallel
FROM user_procedures WHERE object_name IN (
    'CIRCLE_AREA','AVERAGE_PRODUCT_PRICE'
);

--Eliminando funcoes
DROP FUNCTION circle_area;

-------------------------------------PACKAGES-------------------------------

--Chamando procedures e functions na package

CALL product_package.update_product_price(3, 1.25);

SELECT product_package.get_products_ref_cursor
FROM dual;

--Consultar dados de procedures e functions da package

SELECT object_name,
       procedure_name
FROM user_procedures WHERE object_name   = 'PRODUCT_PACKAGE';

--Eliminando uma package

DROP PACKAGE product_package;

-------------------------------------TRIGGERS-------------------------------
--Disparando a trigger
SET SERVEROUTPUT ON;

UPDATE products
SET price = price * .7
WHERE product_id IN (5, 10);

--Verifica se a trigger inseriu os registros
SELECT *
FROM product_price_audit
ORDER BY product_id;

--Consultar dados da trigger
SELECT trigger_name,
       trigger_type,
       triggering_event,
       table_owner base_object_type,
       table_name,
       referencing_names,
       when_clause,
       status,
       description,
       action_type,
       trigger_body
FROM user_triggers WHERE trigger_name   = 'BEFORE_PRODUCT_PRICE_UPDATE';

--Desabilitando uma trigger
ALTER TRIGGER before_product_price_update DISABLE;

--Habilitando uma trigger
ALTER TRIGGER before_product_price_update ENABLE;

--Eliminando uma trigger
DROP TRIGGER before_product_price_update;
