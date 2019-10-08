---------------------FUNÇÕES RELACIONADAS A NULOS--------------------------------------

SELECT NVL(1,2) AS TESTE_NVL FROM DUAL; --Retorna o primeiro valor caso ele não seja nulo

SELECT NVL(NULL, 1) AS TESTE_NVL FROM DUAL; --Substitui o primeiro valor pelo segundo quando o primeiro valor é nulo

SELECT NVL2(1,2,3) AS TESTE_NVL2 FROM DUAL; --Quando o valor do primeiro parâmetro NÃO é nulo, retorna o valor do segundo

SELECT NVL2(NULL,2,3) AS TESTE_NVL2 FROM DUAL; --Quando o valor do primeiro parâmetro É nulo, retorna o valor do terceiro

SELECT NVL2(1, '2', 3) AS TESTE_NVL2 FROM DUAL; --A função NVL2 assim como a NVL faz conversão implícita. 
--Nesse exemplo a segunda expressão é de tipo não numérico
---Mas como pode ser convertida para tipo numérico, isso foi feito

--As principais diferenças entre NVL e NVL2 é que a NVL2 aceita três argumentos e 
--SEMPRE transforma o valor do primeiro argumento

SELECT COALESCE(1,2,3) AS TESTE_COALESCE FROM DUAL; --A função COALESCE retorna o primeiro valor não NULO entre 
--os N(pelo menos 2 argumentos) argumentos passados

SELECT COALESCE(NULL,2,3) AS TESTE_COALESCE FROM DUAL; --Como o primeiro valor é nulo, retorna o segundo valor

SELECT COALESCE(NULL,NULL,3) AS TESTE_COALESCE FROM DUAL; --Dois primeiros argumentos são nulos, retorna o terceiro valor

SELECT COALESCE(1,'2',3) AS TESTE_COALESCE FROM DUAL; --Função coalesce não faz conversão implícita, 
--ou seja os parâmetros TEM que ser de tipos compatíveis
--A função COALESCE é parte do padrão SQL, enquanto que NVL e NVL2 são específicas do Oracle

SELECT COALESCE(1,2,3,4) AS TESTE_COALESCE FROM DUAL; --COALESCE com 4 argumentos

SELECT COALESCE (1,2) AS TESTE_COALESCE FROM DUAL; --COALESCE com 2 argumentos
--Uma diferença importante entre COALESCE e NVL, é que quando COALESCE acha um valor não nulo, 
--a função nem olha os valores seguintes, NVL sempre olha ambos
--os valores, mesmo quando o primeiro não é nulo
