--Indices
--Uma dica para quando criar indice é caso a consulta retorne 10% ou menos do total de registros da tabela

--Criação de um indice de arvore binária
--Para criar esse tipo de indice usar colunas que possuem uma grande variedade de valores, 
--como colunas que devem ser unicas para uma grande tabela

--Sintaxe:
CREATE [UNIQUE] INDEX index_name ON
table_name(column_name[, column_name ...])
TABLESPACE tab_space;

--Esse indice pode ser unico ou não. 

--UNIQUE CONSTRAINT X UNIQUE INDEX
--A constraint unique serve para manter a integridade dos dados.(Melhor que indice unico para isso)
--O indice unico é para melhorar a performance.
--Nem sempre quando uma unique constraint é criada, o indice é criado. 
--Se existe indice na coluna antes da criação da constraint, o Oracle pode usar o existente
--Caso a unique constraint seja DEFERRABLE e não exista indice na coluna, o Oracle criara um indice NÃO ÚNICO.
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

--É possível criar um indice unico aqui e fazer a constraint usá-lo
CREATE INDEX id_un_idx on test(id);

INSERT INTO TEST VALUES(5);

DROP INDEX id_un_idx;

--Quando uma constraint está usando um indice nao é possível eliminar o indice, deve-se eliminar a constraint

--Exemplo criação de index unico
CREATE UNIQUE INDEX i_customers_phone ON customers(phone);

--Exemplo criação de índice em multiplas colunas
CREATE INDEX i_employees_first_last_name ON
employees(first_name, last_name);

--Criação de um indice de função
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

--Criação de um indice bitmap
--é recomendado criar esse indice em colunas que possuam poucos valores distintos para a quantidade de registros da tabela.
--Outro ponto é que essa coluna deve sofrer poucas alterações por sistemas concorrentes

--Não funciona no express edition do oracle
CREATE BITMAP INDEX i_order_status ON order_status(status);

--Exemplo para mostrar como a ordem das colunas na criação do indice influencia o uso desse indice
--Olhar o plano de explicação da consulta.
--Na criação do índice first_name foi colocado primeiro, o índice foi usado somente com essa coluna no where
SELECT * FROM employees where first_name = 'James';

--Teste com last_name
--O índice não é usado.
SELECT * FROM employees where last_name = 'Brown';

--Isso mostra que na prática quando um indíce de multiplas colunas é criado, a ordem das colunas é muito importante. 
--O que acontece num indice composto é que o registro é procurado pela primeira coluna do índice, caso o valor daquela coluna se repita, 
--ai olha a proxima coluna do índice até achar o registro ou chegar na última coluna do índice.

--É ESSENCIAL quando um indice composto for criado ESCOLHER A ORDEM DAS COLUNAS DE MODO QUE O INDICE SEJA USADO O MAIOR NUMERO DE VEZES POSSIVEL

--É por isso que é possível usar o indice com cobinações diferentes da combinação completa(todas as colunas que formam o indice no WHERE)

--Por exemplo um indice de tres colunas pode ser usado somente quando a busca é feita pela primeira coluna 
--ou quando a busca é feita pela primeira e pela segunda coluna juntas
--Ou quando a busca é feita pela combinação dessas tres colunas

--Exemplo combinação completa
--Nem sempre o indice é usado porque o custo pode ser mais alto que ler toda a tabela
--Como a tabela tem poucos dados, ela foi lida por completo.
--Numa tabela com mais dados, o otimizador certamente usaria o indice
SELECT * FROM employees where first_name = 'James' AND last_name = 'Smith';




