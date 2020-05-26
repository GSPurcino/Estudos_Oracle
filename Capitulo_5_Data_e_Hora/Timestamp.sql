--A principal diferençao do TIMESTAMP para DATE é que TIMESTAMP pode ter fraçoes de segundos e pode ter um tempo local

--O tipo timestamp possui 3 variaçoes(olhar na tabela do livro na página 180).

--Para inserir dados numa coluna timestamp usar a sintaxe: TIMESTAMP 'YYYY-MM-DD HH24:MI:SS.SSSSSSSSS'.
INSERT INTO purchases_with_timestamp ( product_id,customer_id,made_on ) VALUES ( 1,1,TIMESTAMP '2005-05-13 07:15:31.1234'
);

SELECT *
FROM purchases_with_timestamp;

--Para inserir dados numa coluna timestamp com tempo local usar TIMESTAMP 'YYYY-MM-DD HH24:MI:SS.SSSSSSSSS TZ'. 
--O TZ pode der a diferença em horas e minutos ou o nome do local

INSERT INTO purchases_timestamp_with_tz ( product_id,customer_id,made_on ) VALUES ( 1,1,TIMESTAMP '2005-05-13 07:15:31.1234 -07:00'
);

INSERT INTO purchases_timestamp_with_tz ( product_id,customer_id,made_on ) VALUES ( 1,2,TIMESTAMP '2005-05-13 07:15:31.1234 PST'
);

SELECT *
FROM purchases_timestamp_with_tz;

--Para inserir dados numa coluna timestamp com tempo local do bd usar TIMESTAMP 'YYYY-MM-DD HH24:MI:SS.SSSSSSSSS TZ'.
--A diferença para o anterior que o usuario verá a coluna de acordo com o local da sua sessão,mas a coluna estará com o tempo local do banco de dados

INSERT INTO purchases_with_local_tz ( product_id,customer_id,made_on ) VALUES ( 1,1,TIMESTAMP '2005-05-13 07:15:30 EST' )
;

SELECT *
FROM purchases_with_local_tz;

--alterando o tempo local da sessão

ALTER SESSION SET time_zone = 'AMERICA/SAO_PAULO';

--Consultar as funcoes relacionadas a timestamp na tabela na página 185 do livro

SELECT current_timestamp timestamp_atual_tempo_local_ss,
       localtimestamp tempo_local_sessao,
       systimestamp tempo_local_bd
FROM dual;

--É possivel usar a função EXTRACT tanto com tipo DATE quanto com TIMESTAMP
--Para extrair com sucesso,o dado a ser extraído deve estar no retorno do tipo
--Extração de ano,mes e dia da data.

SELECT EXTRACT(YEAR FROM SYSDATE) ano,
       EXTRACT(MONTH FROM SYSDATE) mes,
       EXTRACT(DAY FROM SYSDATE) dia
FROM dual;

--Extração de hora,minuto e segundo

--to_timestamp converte texto para timestamp
SELECT EXTRACT(HOUR FROM to_timestamp('01-JUL-2009 10:00:00','DD-MON-YYYY HH24:MI:SS') ) hora,
       EXTRACT(MINUTE FROM to_timestamp('01-JUL-2009 10:00:00','DD-MON-YYYY HH24:MI:SS') ) minuto,
       EXTRACT(SECOND FROM to_timestamp('01-JUL-2009 10:00:00','DD-MON-YYYY HH24:MI:SS') ) segundo
FROM dual;

--funcao to_timestamp_tz converte texto para timestamp com tempo local
SELECT EXTRACT(TIMEZONE_HOUR FROM to_timestamp_tz('01-JUL-2009 10:00:00 -6:15','DD-MON-YYYY HH24:MI:SS TZH:TZM') ) hora_tempo_local
,
       EXTRACT(TIMEZONE_MINUTE FROM to_timestamp_tz('01-JUL-2009 10:00:00 -6:15','DD-MON-YYYY HH24:MI:SS TZH:TZM') ) minuto_tempo_local
,
       EXTRACT(TIMEZONE_REGION FROM to_timestamp_tz('01-JUL-2009 10:00:00 PST','DD-MON-YYYY HH24:MI:SS TZR') ) regiao_tempo_local
,
       EXTRACT(TIMEZONE_ABBR FROM to_timestamp_tz('01-JUL-2009 10:00:00 PST','DD-MON-YYYY HH24:MI:SS TZR') ) abreviacao_regiao_tempo_local
FROM dual;

--from_tz junta o timestamp com o tempo local
SELECT from_tz(TIMESTAMP '2000-03-28 08:00:00','3:00') junta_timestamp_tempo_local FROM dual;

--SYS_extract_UTC obtem o tempo local universal a partir do timestamp passado
SELECT sys_extract_utc(TIMESTAMP '2000-03-28 11:30:00.00 -08:00') conv_timestamp_tmp_local_unvsl FROM dual;

--Converte texto para timestamp com tempo local do bd com cast
SELECT CAST(to_timestamp_tz('2008-05-13 07:15:31.1234 PST','YYYY-MM-DD HH24:MI:SS.FF TZR') AS TIMESTAMP WITH LOCAL TIME
ZONE) converte_texto_timestamp_tz_bd
FROM dual;



