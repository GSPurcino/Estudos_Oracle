-----------------------------FILES---------------------------

--Copiando dados de um arquivo para um CLOB
CREATE PROCEDURE copy_file_data_to_clob (
    p_clob_id     INTEGER,
    p_directory   VARCHAR2,
    p_file_name   VARCHAR2
) AS

    v_file          utl_file.file_type;
    v_chars_read    INTEGER;
    v_dest_clob     CLOB;
    v_amount        INTEGER := 32767;
    v_char_buffer   VARCHAR2(32767);
BEGIN
-- insert an empty CLOB
    INSERT INTO clob_content ( id,clob_column ) VALUES ( p_clob_id,empty_clob() );
-- get the LOB locator of the CLOB

    SELECT clob_column INTO
        v_dest_clob
    FROM clob_content WHERE id   = p_clob_id FOR UPDATE;
-- open the file for reading of text (up to v_amount characters per line)

    v_file         := utl_file.fopen(
        p_directory,
        p_file_name,
        'r',
        v_amount
    );
-- copy the data from the file into v_dest_clob one line at a time
    LOOP
        BEGIN
-- read a line from the file into v_char_buffer;
-- GET_LINE() does not copy the newline character into
-- v_char_buffer
            utl_file.get_line(v_file,v_char_buffer);
            v_chars_read   := length(v_char_buffer);
-- append the line to v_dest_clob
            dbms_lob.writeappend(v_dest_clob,v_chars_read,v_char_buffer);
-- append a newline to v_dest_clob because v_char_buffer;
-- the ASCII value for newline is 10,so CHR(10) returns newline
            dbms_lob.writeappend(
                v_dest_clob,
                1,
                chr(10)
            );
        EXCEPTION
-- when there is no more data in the file then exit
            WHEN no_data_found THEN
                EXIT;
        END;
    END LOOP;
-- close the file

    utl_file.fclose(v_file);
    dbms_output.put_line('Copy successfully completed.');
END copy_file_data_to_clob;

BEGIN
  copy_file_data_to_clob(4, 'SAMPLE_FILES', 'textContent.txt');
END;

SELECT * FROM clob_content;

--Copiando dados de um arquivo para BLOB
CREATE PROCEDURE copy_file_data_to_blob (
    p_blob_id     INTEGER,
    p_directory   VARCHAR2,
    p_file_name   VARCHAR2
) AS

    v_file            utl_file.file_type;
    v_bytes_read      INTEGER;
    v_dest_blob       BLOB;
    v_amount          INTEGER := 32767;
    v_binary_buffer   RAW(32767);
BEGIN
-- insert an empty BLOB
    INSERT INTO blob_content ( id,blob_column ) VALUES ( p_blob_id,empty_blob() );
-- get the LOB locator of the BLOB

    SELECT blob_column INTO
        v_dest_blob
    FROM blob_content WHERE id   = p_blob_id FOR UPDATE;
-- open the file for reading of bytes (up to v_amount bytes at a time)

    v_file         := utl_file.fopen(
        p_directory,
        p_file_name,
        'rb',
        v_amount
    );
-- copy the data from the file into v_dest_blob
    LOOP
        BEGIN
-- read binary data from the file into v_binary_buffer
            utl_file.get_raw(v_file,v_binary_buffer,v_amount);
            v_bytes_read   := length(v_binary_buffer);
-- append v_binary_buffer to v_dest_blob
            dbms_lob.writeappend(
                v_dest_blob,
                v_bytes_read / 2,
                v_binary_buffer
            );
        EXCEPTION
-- when there is no more data in the file then exit
            WHEN no_data_found THEN
                EXIT;
        END;
    END LOOP;
-- close the file

    utl_file.fclose(v_file);
    dbms_output.put_line('Copy successfully completed.');
END copy_file_data_to_blob;

BEGIN
  copy_file_data_to_blob(4, 'SAMPLE_FILES', 'binaryContent.doc');
END;

SELECT * FROM blob_content;

--Copiando dados de um CLOB para um arquivo
CREATE PROCEDURE copy_clob_data_to_file (
    p_clob_id     INTEGER,
    p_directory   VARCHAR2,
    p_file_name   VARCHAR2
) AS

    v_src_clob      CLOB;
    v_file          utl_file.file_type;
    v_offset        INTEGER := 1;
    v_amount        INTEGER := 32767;
    v_char_buffer   VARCHAR2(32767);
BEGIN
-- get the LOB locator of the CLOB
    SELECT clob_column INTO
        v_src_clob
    FROM clob_content WHERE id   = p_clob_id;
-- open the file for writing of text (up to v_amount characters at a time)

    v_file     := utl_file.fopen(
        p_directory,
        p_file_name,
        'w',
        v_amount
    );
-- copy the data from v_src_clob to the file
    LOOP
        BEGIN
-- read characters from v_src_clob into v_char_buffer
            dbms_lob.read(
                v_src_clob,
                v_amount,
                v_offset,
                v_char_buffer
            );
-- copy the characters from v_char_buffer to the file
            utl_file.put(v_file,v_char_buffer);
-- add v_amount to v_offset
            v_offset   := v_offset + v_amount;
        EXCEPTION
-- when there is no more data in the file then exit
            WHEN no_data_found THEN
                EXIT;
        END;
    END LOOP;
-- flush any remaining data to the file

    utl_file.fflush(v_file);
-- close the file
    utl_file.fclose(v_file);
    dbms_output.put_line('Copy successfully completed.');
END copy_clob_data_to_file;

BEGIN
  copy_clob_data_to_file(4, 'SAMPLE_FILES', 'textContent2.txt');
END;

--Copiando dados de um BLOB para um arquivo
CREATE PROCEDURE copy_blob_data_to_file (
    p_blob_id     INTEGER,
    p_directory   VARCHAR2,
    p_file_name   VARCHAR2
) AS

    v_src_blob        BLOB;
    v_file            utl_file.file_type;
    v_offset          INTEGER := 1;
    v_amount          INTEGER := 32767;
    v_binary_buffer   RAW(32767);
BEGIN
-- get the LOB locator of the BLOB
    SELECT blob_column INTO
        v_src_blob
    FROM blob_content WHERE id   = p_blob_id;
-- open the file for writing of bytes (up to v_amount bytes at a time)

    v_file     := utl_file.fopen(
        p_directory,
        p_file_name,
        'wb',
        v_amount
    );
-- copy the data from v_src_blob to the file
    LOOP
        BEGIN
-- read characters from v_src_blob into v_binary_buffer
            dbms_lob.read(
                v_src_blob,
                v_amount,
                v_offset,
                v_binary_buffer
            );
-- copy the binary data from v_binary_buffer to the file
            utl_file.put_raw(v_file,v_binary_buffer);
-- add v_amount to v_offset
            v_offset   := v_offset + v_amount;
        EXCEPTION
-- when there is no more data in the file then exit
            WHEN no_data_found THEN
                EXIT;
        END;
    END LOOP;
-- flush any remaining data to the file

    utl_file.fflush(v_file);
-- close the file
    utl_file.fclose(v_file);
    dbms_output.put_line('Copy successfully completed.');
END copy_blob_data_to_file;

BEGIN
  copy_blob_data_to_file(4, 'SAMPLE_FILES', 'binaryContent2.doc');
END;

--Copiando dados de um BFILE para CLOB
CREATE PROCEDURE copy_bfile_data_to_clob ( p_bfile_id INTEGER,p_clob_id INTEGER ) AS

    v_src_bfile      BFILE;
    v_directory      VARCHAR2(200);
    v_filename       VARCHAR2(200);
    v_length         INTEGER;
    v_dest_clob      CLOB;
    v_amount         INTEGER := dbms_lob.lobmaxsize;
    v_dest_offset    INTEGER := 1;
    v_src_offset     INTEGER := 1;
    v_src_csid       INTEGER := dbms_lob.default_csid;
    v_lang_context   INTEGER := dbms_lob.default_lang_ctx;
    v_warning        INTEGER;
BEGIN
-- get the locator of the BFILE
    SELECT bfile_column INTO
        v_src_bfile
    FROM bfile_content WHERE id   = p_bfile_id;
-- use FILEEXISTS() to check if the file exists
-- (FILEEXISTS() returns 1 if the file exists)

    IF
        ( dbms_lob.fileexists(v_src_bfile) = 1 )
    THEN
-- use OPEN() to open the file
        dbms_lob.open(v_src_bfile);
-- use FILEGETNAME() to get the name of the file and the directory
        dbms_lob.filegetname(v_src_bfile,v_directory,v_filename);
        dbms_output.put_line('Directory = ' || v_directory);
        dbms_output.put_line('Filename = ' || v_filename);
-- insert an empty CLOB
        INSERT INTO clob_content ( id,clob_column ) VALUES ( p_clob_id,empty_clob() );
-- get the LOB locator of the CLOB (for update)

        SELECT clob_column INTO
            v_dest_clob
        FROM clob_content WHERE id   = p_clob_id FOR UPDATE;
-- use LOADCLOBFROMFILE() to get up to v_amount characters
-- from v_src_bfile and store them in v_dest_clob,starting
-- at offset 1 in v_src_bfile and v_dest_clob

        dbms_lob.loadclobfromfile(
            v_dest_clob,
            v_src_bfile,
            v_amount,
            v_dest_offset,
            v_src_offset,
            v_src_csid,
            v_lang_context,
            v_warning
        );
-- check v_warning for an inconvertible character

        IF
            ( v_warning = dbms_lob.warn_inconvertible_char )
        THEN
            dbms_output.put_line('Warning! Inconvertible character.');
        END IF;
-- use CLOSE() to close v_src_bfile

        dbms_lob.close(v_src_bfile);
        dbms_output.put_line('Copy successfully completed.');
    ELSE
        dbms_output.put_line('File does not exist');
    END IF;

END copy_bfile_data_to_clob;

BEGIN
  copy_bfile_data_to_clob(1, 5);
END;

SELECT * FROM clob_content;

--Copiando dados de um BFILE para um BLOB
CREATE PROCEDURE copy_bfile_data_to_blob ( p_bfile_id INTEGER,p_blob_id INTEGER ) AS

    v_src_bfile     BFILE;
    v_directory     VARCHAR2(200);
    v_filename      VARCHAR2(200);
    v_length        INTEGER;
    v_dest_blob     BLOB;
    v_amount        INTEGER := dbms_lob.lobmaxsize;
    v_dest_offset   INTEGER := 1;
    v_src_offset    INTEGER := 1;
BEGIN
-- get the locator of the BFILE
    SELECT bfile_column INTO
        v_src_bfile
    FROM bfile_content WHERE id   = p_bfile_id;
-- use FILEEXISTS() to check if the file exists
-- (FILEEXISTS() returns 1 if the file exists)

    IF
        ( dbms_lob.fileexists(v_src_bfile) = 1 )
    THEN
-- use OPEN() to open the file
        dbms_lob.open(v_src_bfile);
-- use FILEGETNAME() to get the name of the file and
-- the directory
        dbms_lob.filegetname(v_src_bfile,v_directory,v_filename);
        dbms_output.put_line('Directory = ' || v_directory);
        dbms_output.put_line('Filename = ' || v_filename);
-- insert an empty BLOB
        INSERT INTO blob_content ( id,blob_column ) VALUES ( p_blob_id,empty_blob() );
-- get the LOB locator of the BLOB (for update)

        SELECT blob_column INTO
            v_dest_blob
        FROM blob_content WHERE id   = p_blob_id FOR UPDATE;
-- use LOADBLOBFROMFILE() to get up to v_amount bytes
-- from v_src_bfile and store them in v_dest_blob,starting
-- at offset 1 in v_src_bfile and v_dest_blob

        dbms_lob.loadblobfromfile(
            v_dest_blob,
            v_src_bfile,
            v_amount,
            v_dest_offset,
            v_src_offset
        );
-- use CLOSE() to close v_src_bfile
        dbms_lob.close(v_src_bfile);
        dbms_output.put_line('Copy successfully completed.');
    ELSE
        dbms_output.put_line('File does not exist');
    END IF;

END copy_bfile_data_to_blob;

BEGIN
  copy_bfile_data_to_blob(2, 5);
END;

SELECT * FROM blob_content;