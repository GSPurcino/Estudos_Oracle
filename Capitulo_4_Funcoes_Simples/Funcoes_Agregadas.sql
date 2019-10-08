-------------------------------FUNCOES_AGREGADAS-----------------------------

--retorna a media de um grupo de registros
SELECT AVG(price) media FROM products;

--� poss�vel usar distinct com funcoes agregadas para excluir valores duplicados
SELECT avg(DISTINCT price) media_precos_diferentes FROM products;

--COUNT serve para contar quantos registros s�o retornados na consulta.
--Dicas: evitar usar count(*) pois � mais lento do que contar o ROWID ou por uma coluna da tabela
SELECT COUNT(product_id) qt_produtos FROM products;

--OU

SELECT COUNT(ROWID) qt_produtos FROM products;

--MAX serve para retornar o maior valor dentro de um grupo de registros e o MIN retorna o menor valor. 
SELECT MAX(price) mais_caro,
       MIN(price) mais_barato
FROM products;

--MAX e MIN tamb�m podem ser usadas com texto. 
--No caso, o texto � ordenado de forma alfab�tica, no qual menor vem primeiro e o maior vai por �ltimo
-- Z > A
SELECT MAX(name) maior_nome,
       MIN(name) menor_nome
FROM products;

--MAX e MIN tamb�m podem ser usadas com datas. 
--No caso, a maior data acontece no tempo mais recente e a menor no tempo mais antigo.
--01/01/2000 > 01/01/1980
SELECT MAX(dob) maior_data,
       MIN(dob) menor_data
FROM customers;

--SUM serve para obter a soma dos valores dentro de um grupo
SELECT SUM(price) soma_precos FROM products;

--STDDEV serve para obter o desvio padr�o de um grupo de registros
SELECT STDDEV(price) desvio_padrao FROM products;

--VARIANCE serve para obter a vari�ncia dentro de um grupo de registros
SELECT VARIANCE(price) variancia FROM products;






