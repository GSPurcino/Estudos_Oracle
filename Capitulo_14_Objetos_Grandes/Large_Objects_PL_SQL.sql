----------------------LOB PL/SQL-------------

--Principais métodos da package DBMS_LOB do Oracle

/*
APPEND(dest_lob, src_lob) Adds the data read from src_lob to the end of dest_lob.

CLOSE(lob) Closes a previously opened LOB.

COMPARE(lob1, lob2, amount, offset1, offset2)
Compares the data stored in lob1 and lob2, starting at offset1 in
lob1 and offset2 in lob2. Offsets always start at 1, which is the
position of the first character or byte in the data.
The data in the LOBs are compared over a maximum number of
characters or bytes (the maximum is specified in amount).

CONVERTTOBLOB(dest_blob, src_clob, amount, dest_offset, src_offset, blob_csid, lang_context, warning)
Converts the character data read from src_clob into binary data written to dest_blob.
The read begins at src_offset in src_clob, and the write begins at dest_offset in dest_blob.
blob_csid is the desired character set for the converted data written to dest_blob. 
You should typically use DBMS_LOB.DEFAULT_CSID, which is the default character set for the database.
lang_context is the language context to use when converting the characters read from src_clob. 
You should typically use DBMS_LOB.DEFAULT_LANG_CTX, which is the default language context for the database.
warning is set to DBMS_LOB.WARN_INCONVERTIBLE_CHAR if there was a character that could not be converted.

CONVERTTOCLOB(dest_clob, src_blob, amount, dest_offset, src_offset, blob_csid, lang_context, warning)
Converts the binary data read from src_blob into character data written to dest_clob.
blob_csid is the character set for the data read from dest_blob.
You should typically use DBMS_LOB.DEFAULT_CSID.
lang_context is the language context to use when writing the converted characters to dest_clob. 
You should typically use DBMS_LOB.DEFAULT_LANG_CTX.
warning is set to DBMS_LOB.WARN_INCONVERTIBLE_CHAR if there was a character that could not be converted.

COPY(dest_lob, src_lob, amount, dest_offset, src_offset)
Copies data from src_lob to dest_lob, starting at the offsets for a total amount of characters or bytes.

CREATETEMPORARY(lob, cache, duration)
Creates a temporary LOB in the user’s default temporary tablespace.

ERASE(lob, amount, offset) Erases data from a LOB, starting at the offset for a total amount of characters or bytes.

FILECLOSE(bfile) Closes bfile. You should use the newer CLOSE() method instead of

FILECLOSE().

FILECLOSEALL() Closes all previously opened BFILEs.

FILEEXISTS(bfile) Checks if the external file pointed to by bfile actually exists.

FILEGETNAME(bfile, directory, filename)
Returns the directory and filename of the external file pointed to by bfile.

FILEISOPEN(bfile) Checks if bfile is currently open. You should use the newer ISOPEN() method instead of FILEISOPEN().

FILEOPEN(bfile, open_mode) Opens bfile in the indicated mode, which can be set only to DBMS_LOB.FILE_READONLY, 
which indicates the file may only be read from (and never written to). You should use the newer OPEN() method instead of FILEOPEN(). 

FREETEMPORARY(lob) Frees a temporary LOB.

GETCHUNKSIZE(lob) Returns the chunk size used when reading and writing the data stored in the LOB. 
A chunk is a unit of data.

GET_STORAGE_LIMIT() Returns the maximum allowable size for a LOB.

GETLENGTH(lob) Gets the length of the data stored in the LOB.

INSTR(lob, pattern, offset, n) Returns the starting position of characters or bytes 
that match the nth occurrence of a pattern in the LOB data. 
The data is read from the LOB starting at the offset.

ISOPEN(lob) Checks if the LOB was already opened.

ISTEMPORARY(lob) Checks if the LOB is a temporary LOB.

LOADFROMFILE(dest_lob, src_bfile, amount, dest_offset, src_offset)
Loads the data retrieved via src_bfile to dest_lob, starting at the offsets for a total amount of characters or bytes; 
src_bfile is a BFILE that points to an external file.
LOADFROMFILE() is old, and you should use the higherperformance LOADBLOBFROMFILE() or LOADCLOBFROMFILE() methods.

LOADBLOBFROMFILE(dest_blob, src_bfile, amount, dest_offset, src_offset)
Loads the data retrieved via src_bfile to dest_blob, starting at the offsets for a total amount of bytes; src_bfile is a BFILE that
points to an external file.
LOADBLOBFROMFILE() offers improved performance over LOADFROMFILE() when using a BLOB.

LOADCLOBFROMFILE(dest_clob, src_bfile, amount, dest_offset, src_offset, src_csid, lang_context, warning)
Loads the data retrieved via src_bfile to dest_clob, starting at the offsets for a total amount of characters; 
src_bfile is a BFILE that points to an external file. 
LOADCLOBFROMFILE() offers improved performance over LOADFROMFILE() when using a CLOB/NCLOB.

LOBMAXSIZE Returns the maximum size for a LOB in bytes (currently 264).

OPEN(lob, open_mode) Opens the LOB in the indicated mode, which may be set to:
DBMS_LOB.FILE_READONLY, which indicates the LOB may only be read from
DBMS_LOB.FILE_READWRITE, which indicates the LOB may read from and written to

READ(lob, amount, offset, buffer) Reads the data from the LOB and stores them in the buffer variable,
starting at the offset in the LOB for a total amount of characters or bytes.

SUBSTR(lob, amount, offset) Returns part of the LOB data, starting at the offset in the LOB for a
total amount of characters or bytes.

TRIM(lob, newlen) Trims the LOB data to the specified shorter length.

WRITE(lob, amount, offset, buffer) Writes the data from the buffer variable to the LOB, starting at the
offset in the LOB for a total amount of characters or bytes.

WRITEAPPEND(lob, amount, buffer) Writes the data from the buffer variable to the end of the LOB,
starting at the offset in the LOB for a total amount of characters or bytes.

*/

--Procedures de exemplo com os métodos 

--Proceudures para obter o ponteiro dos LOBs
CREATE PROCEDURE get_clob_locator (
    p_clob IN OUT CLOB,
    p_id   IN INTEGER
)
    AS
BEGIN
-- get the LOB locator and store it in p_clob
    SELECT clob_column INTO
        p_clob
    FROM clob_content WHERE id   = p_id;

END get_clob_locator;

CREATE PROCEDURE get_blob_locator (
    p_blob IN OUT BLOB,
    p_id   IN INTEGER
)
    AS
BEGIN
-- get the LOB locator and store it in p_blob
    SELECT blob_column INTO
        p_blob
    FROM blob_content WHERE id   = p_id;

END get_blob_locator;

--Ler dados de CLOBs e BLOBs

CREATE PROCEDURE read_clob_example ( p_id IN INTEGER ) AS

    v_clob          CLOB;
    v_offset        INTEGER := 1;
    v_amount        INTEGER := 50;
    v_char_buffer   VARCHAR2(50);
BEGIN
-- get the LOB locator and store it in v_clob
    get_clob_locator(v_clob,p_id);
-- read the contents of v_clob into v_char_buffer,starting at
-- the v_offset position and read a total of v_amount characters
    dbms_lob.read(
        v_clob,
        v_amount,
        v_offset,
        v_char_buffer
    );
-- display the contents of v_char_buffer
    dbms_output.put_line('v_char_buffer = ' || v_char_buffer);
    dbms_output.put_line('v_amount = ' || v_amount);
END read_clob_example;

SET SERVEROUTPUT ON;

BEGIN
  read_clob_example(1);
END;

CREATE PROCEDURE read_blob_example ( p_id IN INTEGER ) AS

    v_blob            BLOB;
    v_offset          INTEGER := 1;
    v_amount          INTEGER := 25;
    v_binary_buffer   RAW(25);
BEGIN
-- get the LOB locator and store it in v_blob
    get_blob_locator(v_blob,p_id);
-- read the contents of v_blob into v_binary_buffer,starting at
-- the v_offset position and read a total of v_amount bytes
    dbms_lob.read(
        v_blob,
        v_amount,
        v_offset,
        v_binary_buffer
    );
-- display the contents of v_binary_buffer
    dbms_output.put_line('v_binary_buffer = ' || v_binary_buffer);
    dbms_output.put_line('v_amount = ' || v_amount);
END read_blob_example;

BEGIN
  read_blob_example(1);
END;

--Escrevendo em um CLOB
CREATE PROCEDURE write_example ( p_id IN INTEGER ) AS

    v_clob          CLOB;
    v_offset        INTEGER := 7;
    v_amount        INTEGER := 6;
    v_char_buffer   VARCHAR2(10) := 'pretty';
BEGIN
-- get the LOB locator into v_clob for update (for update
-- because the LOB is written to using WRITE() later)
    SELECT clob_column INTO
        v_clob
    FROM clob_content WHERE id   = p_id FOR UPDATE;
-- read and display the contents of the CLOB

    read_clob_example(p_id);
-- write the characters in v_char_buffer to v_clob,starting
-- at the v_offset position and write a total of v_amount characters
    dbms_lob.write(
        v_clob,
        v_amount,
        v_offset,
        v_char_buffer
    );
-- read and display the contents of the CLOB
-- and then rollback the write
    read_clob_example(p_id);
    ROLLBACK;
END write_example;

BEGIN
  write_example(1);
END;

--Adicionando dados a um CLOB

CREATE PROCEDURE append_example AS
    v_src_clob    CLOB;
    v_dest_clob   CLOB;
BEGIN
-- get the LOB locator for the CLOB in row #2 of
-- the clob_content table into v_src_clob
    get_clob_locator(v_src_clob,2);
-- get the LOB locator for the CLOB in row #1 of
-- the clob_content table into v_dest_clob for update
-- (for update because the CLOB will be added to using
-- APPEND() later)
    SELECT clob_column INTO
        v_dest_clob
    FROM clob_content WHERE id   = 1 FOR UPDATE;
-- read and display the contents of CLOB #1

    read_clob_example(1);
-- use APPEND() to copy the contents of v_src_clob to v_dest_clob
    dbms_lob.append(v_dest_clob,v_src_clob);
-- read and display the contents of CLOB #1
-- and then rollback the change
    read_clob_example(1);
    ROLLBACK;
END append_example;

BEGIN
  append_example();
END;

--Comparação entre dois CLOBs
CREATE PROCEDURE compare_example AS
    v_clob1    CLOB;
    v_clob2    CLOB;
    v_return   INTEGER;
BEGIN
-- get the LOB locators
    get_clob_locator(v_clob1,1);
    get_clob_locator(v_clob2,2);
-- compare v_clob1 with v_clob2 (COMPARE() returns 1
-- because the contents of v_clob1 and v_clob2 are different)
    dbms_output.put_line('Comparing v_clob1 with v_clob2');
    v_return   := dbms_lob.compare(v_clob1,v_clob2);
    dbms_output.put_line('v_return = ' || v_return);
-- compare v_clob1 with v_clob1 (COMPARE() returns 0
-- because the contents are the same)
    dbms_output.put_line('Comparing v_clob1 with v_clob1');
    v_return   := dbms_lob.compare(v_clob1,v_clob1);
    dbms_output.put_line('v_return = ' || v_return);
END compare_example;

BEGIN
  compare_example();
END;

--copia de dados de um CLOB para outro
CREATE PROCEDURE copy_example AS

    v_src_clob      CLOB;
    v_dest_clob     CLOB;
    v_src_offset    INTEGER := 1;
    v_dest_offset   INTEGER := 7;
    v_amount        INTEGER := 5;
BEGIN
-- get the LOB locator for the CLOB in row #2 of
-- the clob_content table into v_dest_clob
    get_clob_locator(v_src_clob,2);
-- get the LOB locator for the CLOB in row #1 of
-- the clob_content table into v_dest_clob for update
-- (for update because the CLOB will be added to using
-- COPY() later)
    SELECT clob_column INTO
        v_dest_clob
    FROM clob_content WHERE id   = 1 FOR UPDATE;
-- read and display the contents of CLOB #1

    read_clob_example(1);
-- copy characters to v_dest_clob from v_src_clob using COPY(),
-- starting at the offsets specified by v_dest_offset and
-- v_src_offset for a total of v_amount characters
    dbms_lob.copy(
        v_dest_clob,
        v_src_clob,
        v_amount,
        v_dest_offset,
        v_src_offset
    );
-- read and display the contents of CLOB #1
-- and then rollback the change
    read_clob_example(1);
    ROLLBACK;
END copy_example;

BEGIN
  copy_example();
END;

--Uso de CLOBS temporários
CREATE PROCEDURE temporary_lob_example AS

    v_clob          CLOB;
    v_amount        INTEGER;
    v_offset        INTEGER := 1;
    v_char_buffer   VARCHAR2(17) := 'Juliet is the sun';
BEGIN
-- use CREATETEMPORARY() to create a temporary CLOB named v_clob
    dbms_lob.createtemporary(v_clob,true);
-- use WRITE() to write the contents of v_char_buffer to v_clob
    v_amount   := length(v_char_buffer);
    dbms_lob.write(
        v_clob,
        v_amount,
        v_offset,
        v_char_buffer
    );
-- use ISTEMPORARY() to check if v_clob is temporary
    IF
        ( dbms_lob.istemporary(v_clob) = 1 )
    THEN
        dbms_output.put_line('v_clob is temporary');
    END IF;
-- use READ() to read the contents of v_clob into v_char_buffer

    dbms_lob.read(
        v_clob,
        v_amount,
        v_offset,
        v_char_buffer
    );
    dbms_output.put_line('v_char_buffer = ' || v_char_buffer);
-- use FREETEMPORARY() to free v_clob
    dbms_lob.freetemporary(v_clob);
END temporary_lob_example;

BEGIN
  temporary_lob_example();
END;

--Apagando dados de um CLOB
CREATE PROCEDURE erase_example IS
    v_clob     CLOB;
    v_offset   INTEGER := 2;
    v_amount   INTEGER := 5;
BEGIN
-- get the LOB locator for the CLOB in row #1 of
-- the clob_content table into v_dest_clob for update
-- (for update because the CLOB will be erased using
-- ERASE() later)
    SELECT clob_column INTO
        v_clob
    FROM clob_content WHERE id   = 1 FOR UPDATE;
-- read and display the contents of CLOB #1

    read_clob_example(1);
-- use ERASE() to erase a total of v_amount characters
-- from v_clob,starting at v_offset
    dbms_lob.erase(v_clob,v_amount,v_offset);
-- read and display the contents of CLOB #1
-- and then rollback the change
    read_clob_example(1);
    ROLLBACK;
END erase_example;

BEGIN
  erase_example();
END;

--Procurando Dados em um CLOB

CREATE PROCEDURE instr_example AS

    v_clob          CLOB;
    v_char_buffer   VARCHAR2(50) := 'It is the east and Juliet is the sun';
    v_pattern       VARCHAR2(5);
    v_offset        INTEGER := 1;
    v_amount        INTEGER;
    v_occurrence    INTEGER;
    v_return        INTEGER;
BEGIN
-- use CREATETEMPORARY() to create a temporary CLOB named v_clob
    dbms_lob.createtemporary(v_clob,true);
-- use WRITE() to write the contents of v_char_buffer to v_clob
    v_amount       := length(v_char_buffer);
    dbms_lob.write(
        v_clob,
        v_amount,
        v_offset,
        v_char_buffer
    );
-- use READ() to read the contents of v_clob into v_char_buffer
    dbms_lob.read(
        v_clob,
        v_amount,
        v_offset,
        v_char_buffer
    );
    dbms_output.put_line('v_char_buffer = ' || v_char_buffer);
-- use INSTR() to search v_clob for the second occurrence of is,
-- and INSTR() returns 27
    dbms_output.put_line('Searching for second ''is''');
    v_pattern      := 'is';
    v_occurrence   := 2;
    v_return       := dbms_lob.instr(
        v_clob,
        v_pattern,
        v_offset,
        v_occurrence
    );
    dbms_output.put_line('v_return = ' || v_return);
-- use INSTR() to search v_clob for the first occurrence of Moon,
-- and INSTR() returns 0 because Moon doesn't appear in v_clob
    dbms_output.put_line('Searching for ''Moon''');
    v_pattern      := 'Moon';
    v_occurrence   := 1;
    v_return       := dbms_lob.instr(
        v_clob,
        v_pattern,
        v_offset,
        v_occurrence
    );
    dbms_output.put_line('v_return = ' || v_return);
-- use FREETEMPORARY() to free v_clob
    dbms_lob.freetemporary(v_clob);
END instr_example;

BEGIN
  instr_example();
END;