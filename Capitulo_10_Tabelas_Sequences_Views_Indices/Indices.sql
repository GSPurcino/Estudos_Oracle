--Indices
--Uma dica para quando criar indice � caso a consulta retorne 10% ou menos do total de registros da tabela

--Cria��o de um indice de arvore bin�ria
--Para criar esse tipo de indice usar colunas que possuem uma grande variedade de valores, 
--como colunas que devem ser unicas para uma grande tabela

--Sintaxe:
CREATE [UNIQUE] INDEX index_name ON
table_name(column_name[, column_name ...])
TABLESPACE tab_space;

--Esse indice pode ser unico ou n�o. 

--UNIQUE CONSTRAINT X UNIQUE INDEX
--A constraint unique serve para manter a integridade dos dados.(Melhor que indice unico para isso)
--O indice unico � para melhorar a performance.
--Nem sempre quando uma unique constraint � criada, o indice � criado. 
--Se existe indice na coluna antes da cria��o da constraint, o Oracle pode usar o existente
--Caso a unique constraint seja DEFERRABLE e n�o exista indice na coluna, o Oracle criara um indice N�O �NICO.
--A constraint UNIQUE pode ser aplicada mesmo sem um indice unico correspondente

--Executar o codigo abaixo de maneira correta mostra esse fato

CREATE TABLE TEST (
    ID   NUMBER
)

DROP TABLE TEST;

ALTER TABLE TEST
ADD CONSTRAINT id_un UNIQUE(id);

ALTER TABLE TEST
DROP CONSTRAINT id_un;

--� poss�vel criar um indice unico aqui e fazer a constraint us�-lo
CREATE INDEX id_un_idx on test(id);

INSERT INTO TEST VALUES(5);

DROP INDEX id_un_idx;

--Quando uma constraint est� usando um indice nao � poss�vel eliminar o indice, deve-se eliminar a constraint

--Exemplo cria��o de index unico
CREATE UNIQUE INDEX i_customers_phone ON customers(phone);

--Exemplo cria��o de �ndice em multiplas colunas
CREATE INDEX i_employees_first_last_name ON
employees(first_name, last_name);

--Cria��o de um indice de fun��o
CREATE INDEX i_func_customers_last_name
ON customers(UPPER(last_name));

SELECT first_name, last_name
FROM customers
WHERE UPPER(last_name) = 'BROWN';

--Consultar dados dos indices na tabela
SELECT index_name,
       table_name,
       uniqueness,
       status
FROM user_indexes
WHERE table_name IN (
        'CUSTOMERS','EMPLOYEES'
    )
ORDER BY index_name;

--Consultar dados dos indices na coluna
SELECT index_name,
       table_name,
       column_name
FROM user_ind_columns
WHERE table_name IN (
        'CUSTOMERS','EMPLOYEES'
    )
ORDER BY index_name;

--Modificando um indice
ALTER INDEX i_customers_phone RENAME TO i_customers_phone_number;

--Cria��o de um indice bitmap
--� recomendado criar esse indice em colunas que possuam poucos valores distintos para a quantidade de registros da tabela.
--Outro ponto � que essa coluna deve sofrer poucas altera��es por sistemas concorrentes

--N�o funciona no express edition do oracle
CREATE BITMAP INDEX i_order_status ON order_status(status);

--Exemplo para mostrar como a ordem das colunas na cria��o do indice influencia o uso desse indice
--Olhar o plano de explica��o da consulta.
--Na cria��o do �ndice first_name foi colocado primeiro, o �ndice foi usado somente com essa coluna no where
SELECT * FROM employees where first_name = 'James';

--Teste com last_name
--O �ndice n�o � usado.
SELECT * FROM employees where last_name = 'Brown';

--Isso mostra que na pr�tica quando um ind�ce de multiplas colunas � criado, a ordem das colunas � muito importante. 
--O que acontece num indice composto � que o registro � procurado pela primeira coluna do �ndice, caso o valor daquela coluna se repita, 
--ai olha a proxima coluna do �ndice at� achar o registro ou chegar na �ltima coluna do �ndice.

--� ESSENCIAL quando um indice composto for criado ESCOLHER A ORDEM DAS COLUNAS DE MODO QUE O INDICE SEJA USADO O MAIOR NUMERO DE VEZES POSSIVEL

--� por isso que � poss�vel usar o indice com cobina��es diferentes da combina��o completa(todas as colunas que formam o indice no WHERE)

--Por exemplo um indice de tres colunas pode ser usado somente quando a busca � feita pela primeira coluna 
--ou quando a busca � feita pela primeira e pela segunda coluna juntas
--Ou quando a busca � feita pela combina��o dessas tres colunas

--Exemplo combina��o completa
--Nem sempre o indice � usado porque o custo pode ser mais alto que ler toda a tabela
--Como a tabela tem poucos dados, ela foi lida por completo.
--Numa tabela com mais dados, o otimizador certamente usaria o indice
SELECT * FROM employees where first_name = 'James' AND last_name = 'Smith';




