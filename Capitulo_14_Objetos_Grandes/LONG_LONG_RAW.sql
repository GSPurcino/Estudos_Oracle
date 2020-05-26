-------------------LONG e LONG RAW-----------------

--Antes da introdução dos LOBs, para armazenar maiores quantidades de dados eram usados os seguintes tipos:

--LONG usado para guardar até 2 Gb de texto
--LONG RAW Usado para guardar até 2 GB de dados binários
--RAW Usado para guardar até 4 KB de dados binários

--Exemplo

--LONG
CREATE TABLE long_content (
    id            INTEGER PRIMARY KEY,
    long_column   LONG NOT NULL
);

INSERT INTO long_content ( id,long_column ) VALUES ( 1,'Creeps in this petty pace' );

INSERT INTO long_content ( id,long_column ) VALUES ( 2,' from day to day' );

SELECT * FROM long_content;

--é possível converter um LONG para CLOB com TO_LOB()

INSERT INTO clob_content SELECT 10 + id,
       to_lob(long_column)
FROM long_content;

ALTER TABLE long_content MODIFY (
    long_column CLOB
);

--LONG RAW
CREATE TABLE long_raw_content (
    id                INTEGER PRIMARY KEY,
    long_raw_column   LONG RAW NOT NULL
);

INSERT INTO long_raw_content ( id,long_raw_column ) VALUES ( 1,'100111010101011111' );

INSERT INTO long_raw_content ( id,long_raw_column ) VALUES ( 2,'A0FFB71CF90DE' );

SELECT * FROM long_raw_content;

--é possível converter um LONG RAW para BLOB com TO_LOB()
INSERT INTO blob_content SELECT 10 + id,
       to_lob(long_raw_column)
FROM long_raw_content;

ALTER TABLE long_raw_content MODIFY (
    long_raw_column BLOB
);

--No oracle 10 é possível converter implicitamente entre CLOB e NCLOB.
--Outra novidade é que é possível usar o :new com colunas LOB em BEFORE UPDATE ou BEFORE INSERT em gatilhos de nível registro.

CREATE TRIGGER before_clob_content_update BEFORE
    UPDATE ON clob_content
    FOR EACH ROW
BEGIN
    dbms_output.put_line('clob_content changed');
    dbms_output.put_line('Length = '
     || dbms_lob.getlength(:new.clob_column) );
END before_clob_content_update;

UPDATE clob_content
SET clob_column = 'Creeps in this petty pace'
WHERE id = 1;


