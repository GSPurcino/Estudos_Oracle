--retorna o tempo de acordo com o local do banco de dados(00:00 significa que o banco de dados est� usando o local e tempo do sistema operacional)
SELECT dbtimezone tempo_local_bd from dual;

--Retorna a data atual para a sess�o.
SELECT current_date hora_data_sessao FROM dual;

--retorna o tempo de acordo com o local de quem abriu a sess�o
SELECT sessiontimezone local_sessao FROM dual;

--A diferen�a em horas e minutos do tempo de determinado local
SELECT tz_offset('PST') diferenca_hora_min_tempo_local FROM dual;

--Nome dos locais e abrevia��o para usar o tempo daquele local
SELECT * FROM v$timezone_names;

--A fun��o new_time serve para converter uma data com tempo de local espec�fico para a data com tempo de outro local
SELECT TO_CHAR(
        new_time(SYSDATE,'PST','EST'),
        'DD-MON-YYYY HH24:MI'
    ) tempo_pst_para_est
FROM dual;