-------------------------------FUNCOES_AGREGADAS-----------------------------

--retorna a media de um grupo de registros
SELECT AVG(price) media FROM products;

--é possível usar distinct com funcoes agregadas para excluir valores duplicados
SELECT avg(DISTINCT price) media_precos_diferentes FROM products;

--COUNT serve para contar quantos registros são retornados na consulta.
--Dicas: evitar usar count(*) pois é mais lento do que contar o ROWID ou por uma coluna da tabela
SELECT COUNT(product_id) qt_produtos FROM products;

--OU

SELECT COUNT(ROWID) qt_produtos FROM products;

--MAX serve para retornar o maior valor dentro de um grupo de registros e o MIN retorna o menor valor. 
SELECT MAX(price) mais_caro,
       MIN(price) mais_barato
FROM products;

--MAX e MIN também podem ser usadas com texto. 
--No caso, o texto é ordenado de forma alfabética, no qual menor vem primeiro e o maior vai por último
-- Z > A
SELECT MAX(name) maior_nome,
       MIN(name) menor_nome
FROM products;

--MAX e MIN também podem ser usadas com datas. 
--No caso, a maior data acontece no tempo mais recente e a menor no tempo mais antigo.
--01/01/2000 > 01/01/1980
SELECT MAX(dob) maior_data,
       MIN(dob) menor_data
FROM customers;

--SUM serve para obter a soma dos valores dentro de um grupo
SELECT SUM(price) soma_precos FROM products;

--STDDEV serve para obter o desvio padrão de um grupo de registros
SELECT STDDEV(price) desvio_padrao FROM products;

--VARIANCE serve para obter a variância dentro de um grupo de registros
SELECT VARIANCE(price) variancia FROM products;






