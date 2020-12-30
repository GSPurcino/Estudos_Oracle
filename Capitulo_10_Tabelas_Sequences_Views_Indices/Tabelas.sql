-----------------------------------------------TABELAS------------------------------------

--Sintaxe criação de tabela(mais detalhes na documentação da Oracle)

CREATE [GLOBAL TEMPORARY] TABLE table_name (
column_name type [CONSTRAINT constraint_def DEFAULT default_exp]
[, column_name type [CONSTRAINT constraint_def DEFAULT default_exp] ...]
)
[ON COMMIT {DELETE | PRESERVE} ROWS]
TABLESPACE tab_space;


--Exemplo de criação de tabela
CREATE TABLE order_status2 (
id INTEGER CONSTRAINT order_status2_pk PRIMARY KEY,
status VARCHAR2(10),
last_modified DATE DEFAULT SYSDATE
);

--Exemplo de criação de tabela temporaria(Preserva registros no commt)
CREATE GLOBAL TEMPORARY TABLE order_status_temp (
    id              INTEGER,
    status          VARCHAR2(10),
    last_modified   DATE DEFAULT SYSDATE
) ON COMMIT PRESERVE ROWS;

--Adicionar registro na tabela temporaria
INSERT INTO order_status_temp ( id,status ) VALUES ( 1,'New' );

--Disconectar e depois conectar de novo e consultar a tabela temporária para ver se os dados estão lá
--Como a tabela e temporaria os dados nao devem estar presentes(temporaria no sentido que os dados so existem para a sessão)
SELECT * FROM order_status_temp;

--Consultar dados de tabelas
SELECT table_name, tablespace_name, temporary
FROM user_tables
WHERE table_name IN ('EMPLOYEES', 'ORDER_STATUS_TEMP');

--Consultar dados das colunas das tabelas
SELECT column_name, data_type, data_length, data_precision, data_scale
FROM user_tab_columns
WHERE table_name = 'PRODUCTS';

--------------------------------------------Alterando a tabela---------------------------------------

-----------------------------Adicionar uma coluna-----------------------------------------------------

ALTER TABLE order_status2
ADD modified_by INTEGER;

ALTER TABLE order_status2
ADD initially_created DATE DEFAULT SYSDATE NOT NULL;

DESCRIBE order_status2;

------------------------------------------COLUNA VIRTUAL-------------------------------------------------

--Adicionar uma coluna virtual. A coluna virtual deve referenciar colunas já existentes na tabela
--Os dados da coluna virtual são preenchidos automaticamente
--Os resultados de colunas virtuais não são armazenados em disco

/*
Algumas observações e restrições sobre colunas virtuais:
 
Os índices definidos para colunas virtuais são equivalentes aos índices baseados em função.

Colunas virtuais podem ser referenciadas na cláusula WHERE para a execução de “updates” e “deletes”, 
mas eles não podem ser manipulados por comandos DML.

As tabelas com colunas virtuais podem ser ter seu conteúdo armazenado em “cache”.

Funções em expressões devem ser determinísticas, no momento da criação da tabela, mas, posteriormente, 
pode ser recompilados sem invalidar a coluna virtual. 
Nesses casos, devem ser tomadas as seguintes medidas depois que a função for recompilada:

Restrição na coluna virtual deve ser desativada e reativada.

Índices na coluna virtual devem ser reconstruídos.

Visões materializadas, baseadas em colunas virtuais devem ser totalmente atualizadas.

O resultado da tabela que está em “cache” deve ser liberado se as consultas em “cache” acessarem a coluna virtual envolvida.

As estatísticas da tabela devem ser recalculadas.

Colunas virtuais não são suportadas para índices organizados (organized-indexes), índices externos, índiceoobjeto, 
índices clusterizados ou para tabelas temporárias.

A expressão utilizada para a definição de uma coluna virtual tem as seguintes restrições:

O resultado de uma expressão deve ser um valor escalar. Ele não poderá retornar um tipo de dado definido pelo usuário ou LOB ou LONG RAW.

Uma grande desvantagem de colunas virtuais é que a performance é afetada em consultas, porque ela sempre deve ser gerada

*/

--É possível também adicionar a coluna virtual no CREATE TABLE, como no exemplo abaixo
create table <table_name>(
<column_name> <data_type>,
?
<column_name> [<data_type>] [generated always] as (<column_expression>) [virtual]
);

--Ou no ALTER TABLE
alter table <table_name>
add (<column_name> [<data_type>] [generated always] as (<column_expression>) [virtual]);

--Exemplo de coluna virtual
ALTER TABLE salary_grades
ADD (average_salary AS ((low_salary + high_salary)/2));

SELECT *
FROM user_tab_columns
WHERE table_name = 'SALARY_GRADES';

DESCRIBE salary_grades;

SELECT * FROM salary_grades;

-----------------------------------------Modificando uma coluna--------------------------

--Mudando o tamanho da coluna

ALTER TABLE order_status2
MODIFY status VARCHAR2(15);

--Mudando precisão de coluna numerica

ALTER TABLE order_status2
MODIFY id NUMBER(5);

--Observação: Só é possível diminuir o tamanho da coluna ou a precisão numerica 
--se a tabela não tem registros ou a coluna seja nula em todos os registros da tabela

--Mudando o tipo de dado da coluna

ALTER TABLE order_status2
MODIFY status CHAR(15);

--Mudando o valor padrão da coluna
ALTER TABLE order_status2
MODIFY last_modified DEFAULT SYSDATE - 1;

-----------------------------Remoção de coluna-------------------------

ALTER TABLE order_status2
DROP COLUMN initially_created;

DESCRIBE order_status2;

-------------------------------------CONSTRAINTS----------------------------------

--Para poder adicionar uma constraint os registros existentes na tabela DEVEM RESPEITÁ-LA por padrão.
--É possível adicionar uma constraint desabilitada e usar ENABLE NOVALIDATE de modo que ela seja aplicada somente em novos registros

--Adicionando uma CHECK CONSTRAINT
ALTER TABLE order_status2
    ADD CONSTRAINT order_status2_status_ck CHECK (
        status IN (
            'PLACED','PENDING','SHIPPED'
        )
    );

--teste da CHECK CONSTRAINT
INSERT INTO order_status2 (
    id,
    status,
    last_modified,
    modified_by
) VALUES (
    1,
    'TESTE',
    '01-JAN-2005',
    1
);

--Adicionando uma constraint NOT NULL
ALTER TABLE order_status2
MODIFY status CONSTRAINT order_status2_status_nn NOT NULL;

--Adicionando uma constraint FOREIGN KEY

ALTER TABLE order_status2
DROP COLUMN modified_by;

--Quando se adiciona chave estrangeira é possível que dê erro dizendo que 
ALTER TABLE order_status2
ADD CONSTRAINT order_status2_modified_by_fk
FOREIGN KEY (modified_by) REFERENCES employees(employee_id);

--Adicionando uma constraint UNIQUE
ALTER TABLE order_status2
ADD CONSTRAINT order_status2_status_uq UNIQUE (status);

--Adicionando uma constraint PRIMARY KEY(A tabela já tem chave primária, só um exemplo)
ALTER TABLE order_status2
ADD CONSTRAINT PK_status PRIMARY KEY(status);

--Eliminando uma constraint
ALTER TABLE order_status2 DROP CONSTRAINT SYS_C007058;

--Desabilitando uma constraint

--Criando a constraint desabilitada
ALTER TABLE order_status2
ADD CONSTRAINT order_status2_status_uq UNIQUE (status) DISABLE;

--Desabilitando constraint existente

ALTER TABLE order_status2
DISABLE CONSTRAINT order_status2_status_nn;

--Habilitando a constraint

ALTER TABLE order_status2
ENABLE CONSTRAINT order_status2_status_uq;

--Pode-se habilitar a constraint de modo que ela seja aplicada somente para dados novos
ALTER TABLE order_status2 ENABLE NOVALIDATE CONSTRAINT order_status2_status_uq;

--Deferred Constraints
--Esse tipo de constraint só é verificada quando é feito o COMMIT da tarnsação. É possível criar uma constraint assim com DEFERRABLE.
--Não é possível mudar uma constraint existente para isso, deve ser recriada
--Quando uma constraint é deferrable e possivel que ela seja INITIALLY IMMEDIATE(verifica a constraint no DML - igual a NOT DEFERRABLE nesse sentido)
--ou pode ser INITIALLY DEFERRED, ou seja, a constraint só é checada no COMMIT da transação

ALTER TABLE order_status2
DROP CONSTRAINT order_status2_status_uq;

--Exemplo deferred constraint
ALTER TABLE order_status2
ADD CONSTRAINT order_status2_status_uq UNIQUE (status)
DEFERRABLE INITIALLY DEFERRED;

--Consultar dados das constraints
SELECT constraint_name,
       constraint_type,
       status,
       deferrable,
       deferred
FROM user_constraints WHERE table_name   = 'ORDER_STATUS2';

--Consultar dados de constraints por coluna
SELECT constraint_name,
       column_name
FROM user_cons_columns
WHERE table_name   = 'ORDER_STATUS2'
ORDER BY constraint_name;

-------------------------------------------------Tabela-------------------------------------------

--Renomear tabela
RENAME order_status2 TO order_state;

RENAME order_state TO order_status2;

--Adicionar comentário na tabela
COMMENT ON TABLE order_status2 IS 'order_status2 stores the state of an order';

--Adicionar comentário na coluna da tabela
COMMENT ON COLUMN order_status2.last_modified IS 'last_modified stores the date and time the order was modified last';

--Consultando comentários de tabela
SELECT *
FROM user_tab_comments WHERE table_name   = 'ORDER_STATUS2';

--Consultando comentários de coluna
SELECT * FROM user_col_comments WHERE table_name = 'ORDER_STATUS2';

--Apgar todos os registros da tabela
TRUNCATE TABLE order_status2;

---------------------------------------------Eliminar tabela----------------------------------
DROP TABLE order_status2;