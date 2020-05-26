------------------------------Funcao TRANSLATE----------------------

--Essa funcao serve para substituir um caractere por outro em um texto passado.

SELECT translate('TESTE','E','I') teste_translate FROM dual;

--Substituindo mais de um caractere no texto
SELECT translate('TESTE','ET','IV') teste_translate FROM dual;

--Exemplo com coluna de tabela
SELECT product_id,
       translate(name,'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz','EFGHIJKLMNOPQRSTUVWXYZABCDefghijklmnopqrstuvwxyzabcd'
) teste_translate_coluna
FROM products;

--TRANSLATE COM NUMEROS
SELECT translate(12345,54321,67890) teste_translate_numeros FROM dual;

---------------------------------------Funcao DECODE--------------------------------------

--Essa funcao compara o valor com outro, caso sejam iguais retorna valor de resultado, senão o outro valor

--Valores iguais
SELECT DECODE(
        1,
        1,
        2,
        3
    ) 
FROM dual;

--Valores diferentes
SELECT DECODE(
        1,
        2,
        1,
        3
    )
FROM dual;

--Exemplo com coluna da tabela
SELECT prd_id,
       available,
       DECODE(
        available,
        'Y',
        'Product is available',
        'Product is not available'
    )
FROM more_products;

--Exemplo decode com multiplas comparacoes
SELECT product_id,
       product_type_id,
       DECODE(
        product_type_id,
        1,
        'Book',
        2,
        'Video',
        3,
        'DVD',
        4,
        'CD',
        'Magazine'
    ) decode_multiplos_testes
FROM products;

------------------------------------Funcao CASE-----------------------------------

--CASE simples. usa o valor para determinar o retorno

SELECT product_id,
       product_type_id,
       CASE product_type_id
        WHEN 1   THEN 'Book'
        WHEN 2   THEN 'Video'
        WHEN 3   THEN 'DVD'
        WHEN 4   THEN 'CD'
        ELSE 'Magazine'
    END teste_simple_case
FROM products;

--CASE searched. Usa condições para determinar o resultado

SELECT product_id,
       product_type_id,
           CASE
            WHEN product_type_id = 1 THEN 'Book'
            WHEN product_type_id = 2 THEN 'Video'
            WHEN product_type_id = 3 THEN 'DVD'
            WHEN product_type_id = 4 THEN 'CD'
            ELSE 'Magazine'
        END
    teste_searched_case
FROM products;
