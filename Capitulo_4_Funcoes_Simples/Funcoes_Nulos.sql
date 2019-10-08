---------------------FUN��ES RELACIONADAS A NULOS--------------------------------------

SELECT NVL(1,2) AS TESTE_NVL FROM DUAL; --Retorna o primeiro valor caso ele n�o seja nulo

SELECT NVL(NULL, 1) AS TESTE_NVL FROM DUAL; --Substitui o primeiro valor pelo segundo quando o primeiro valor � nulo

SELECT NVL2(1,2,3) AS TESTE_NVL2 FROM DUAL; --Quando o valor do primeiro par�metro N�O � nulo, retorna o valor do segundo

SELECT NVL2(NULL,2,3) AS TESTE_NVL2 FROM DUAL; --Quando o valor do primeiro par�metro � nulo, retorna o valor do terceiro

SELECT NVL2(1, '2', 3) AS TESTE_NVL2 FROM DUAL; --A fun��o NVL2 assim como a NVL faz convers�o impl�cita. 
--Nesse exemplo a segunda express�o � de tipo n�o num�rico
---Mas como pode ser convertida para tipo num�rico, isso foi feito

--As principais diferen�as entre NVL e NVL2 � que a NVL2 aceita tr�s argumentos e 
--SEMPRE transforma o valor do primeiro argumento

SELECT COALESCE(1,2,3) AS TESTE_COALESCE FROM DUAL; --A fun��o COALESCE retorna o primeiro valor n�o NULO entre 
--os N(pelo menos 2 argumentos) argumentos passados

SELECT COALESCE(NULL,2,3) AS TESTE_COALESCE FROM DUAL; --Como o primeiro valor � nulo, retorna o segundo valor

SELECT COALESCE(NULL,NULL,3) AS TESTE_COALESCE FROM DUAL; --Dois primeiros argumentos s�o nulos, retorna o terceiro valor

SELECT COALESCE(1,'2',3) AS TESTE_COALESCE FROM DUAL; --Fun��o coalesce n�o faz convers�o impl�cita, 
--ou seja os par�metros TEM que ser de tipos compat�veis
--A fun��o COALESCE � parte do padr�o SQL, enquanto que NVL e NVL2 s�o espec�ficas do Oracle

SELECT COALESCE(1,2,3,4) AS TESTE_COALESCE FROM DUAL; --COALESCE com 4 argumentos

SELECT COALESCE (1,2) AS TESTE_COALESCE FROM DUAL; --COALESCE com 2 argumentos
--Uma diferen�a importante entre COALESCE e NVL, � que quando COALESCE acha um valor n�o nulo, 
--a fun��o nem olha os valores seguintes, NVL sempre olha ambos
--os valores, mesmo quando o primeiro n�o � nulo
