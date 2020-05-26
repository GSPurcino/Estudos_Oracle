-----------------------------------------------SEQUENCES----------------------------------

--Serve para gerar uma sequencia de numeros inteiros.

--Sintaxe para criar a sequence
CREATE SEQUENCE sequence_name
[START WITH start_num]
[INCREMENT BY increment_num]
[ { MAXVALUE maximum_num | NOMAXVALUE } ]
[ { MINVALUE minimum_num | NOMINVALUE } ]
[ { CYCLE | NOCYCLE } ]
[ { CACHE cache_num | NOCACHE } ]
[ { ORDER | NOORDER } ];

--Exemplo
CREATE SEQUENCE s_test;

CREATE SEQUENCE s_test2 START WITH 10 INCREMENT BY 5 MINVALUE 10 MAXVALUE 20 CYCLE CACHE 2 ORDER;

CREATE SEQUENCE s_test3 START WITH 10 INCREMENT BY - 1 MINVALUE 1 MAXVALUE 10 CYCLE CACHE 5;

--Consultar dados da sequence
SELECT *
FROM user_sequences
ORDER BY sequence_name;

--Obtendo próximo vaor da sequence
SELECT s_test.NEXTVAL FROM dual;

--Obtendo valor atual da sequenc(só poder ser obtido depois de iniciada a sequence
SELECT s_test.CURRVAL FROM dual;

--A sequencia só é incrementada quanto o próximo valor é chamado(nextval)

SELECT s_test.NEXTVAL,
       s_test.CURRVAL
FROM dual;

---------------------------Modificando uma sequence--------------------------

ALTER SEQUENCE s_test
INCREMENT BY 2;

SELECT s_test.NEXTVAL,
       s_test.CURRVAL
FROM dual;

--Eliminando a sequence
DROP SEQUENCE s_test3;

