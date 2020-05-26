---------------------------LARGE OBJECTS------------------

--Existem 4 tipos de objetos grandes:

--CLOB o tipo de texto LOB
--NCLOB O tipo de texto nacional LOB
--BLOB O tipo binario LOB
--BFILE O tipo de arquivo binario. É usado para guardar um ponteiro para um arquivo. 
--O arquivo pode ser qualquer coisa acessível ao file system do servidor de banco de dados.
--É importante lembrar que o arquivo em si NUNCA É ARMAZENADO no banco de dados, apenas um ponteiro para ele

--Antes do Oracle 8, só era possível guardr grandes quantidades de dados usando os tipos LONG e LONG RAW.
--Os tipos LOB tem as seguintes vantagens sobre esses anteriores:

--Um LOB pode guardar até 128 TB de dados enquanto um LONG ou LONG RAW podem guardar até 2 GB de dados
--Uma tabela pode ter multiplas colunas LOB, mas apenas uma coluna LONG ou LONG RAW
--LOB pode ser acessado em ordem aleatória, mas LONG e LONG RAW só podem ser acessados sequencialmente

--Um LOB é feito de duas partes:
--O locator. Esse locator é um ponteiro qeu indica onde estão os dados
--The data. Os dados que estão guardados no LOB

--Tabelas com LOBs

CREATE TABLE clob_content (
    id            INTEGER PRIMARY KEY,
    clob_column   CLOB NOT NULL
);

CREATE TABLE blob_content (
    id            INTEGER PRIMARY KEY,
    blob_column   BLOB NOT NULL
);

--Inserção de dados nos LOBs

INSERT INTO clob_content ( id,clob_column ) VALUES ( 1,to_clob('Creeps in this petty pace') );

INSERT INTO clob_content ( id,clob_column ) VALUES ( 2,to_clob(' from day to day') );

INSERT INTO blob_content ( id,blob_column ) VALUES ( 1,to_blob('100111010101011111') );

INSERT INTO blob_content ( id,blob_column ) VALUES ( 2,to_blob('A0FFB71CF90DE') );

--Consultando os dados

SELECT * FROM clob_content;

--Falaha porque não é possível mostrar dados de BLOB sem uso de PL/SQL
SELECT * FROM blob_content;

--Alterando os dados nos LOBs

UPDATE clob_content
SET clob_column = TO_CLOB('What light through yonder window breaks')
WHERE id = 1;

UPDATE blob_content
SET blob_column = TO_BLOB('1110011010101011111')
WHERE id = 1;

SELECT * FROM clob_content;

--é possível criar um LOB vazio(apenas o ponteiro, sem dados guardados)
INSERT INTO clob_content ( id,clob_column ) VALUES ( 3,empty_clob() );

INSERT INTO blob_content ( id,blob_column ) VALUES ( 3,empty_blob() );

--é possível também usar em UPDATE
UPDATE clob_content
SET clob_column = EMPTY_CLOB()
WHERE id = 1;

UPDATE blob_content
SET blob_column = EMPTY_BLOB()
WHERE id = 1;

-----------------------------------BFILE---------------------------------

--Antes de usar um BFILE, é necessário um objeto diretório no BD para dizer onde esse arquivo está.

CREATE DIRECTORY sample_files AS 'C:\Users\gsouzap\Desktop\Estudos\Oracle\Estudos_Oracle_11g_SQL_Jason_price\Capitulo_14_Objetos_Grandes\Arquivos'
;

CREATE TABLE bfile_content (
    id             INTEGER PRIMARY KEY,
    bfile_column   BFILE NOT NULL
);

INSERT INTO bfile_content ( id,bfile_column ) VALUES (
    1,
    bfilename('SAMPLE_FILES','textContent.txt')
);

INSERT INTO bfile_content ( id,bfile_column ) VALUES (
    2,
    bfilename('SAMPLE_FILES','binaryContent.doc')
);

--Não é possível ver o conteúdo do arquivo sem usar PL/SQL
SELECT * FROM bfile_content;