--Inserção com campo data
INSERT INTO customers(customer_id, first_name, last_name, dob, phone) VALUES (6, 'Fred', 'Brown', '05-FEV-1968', '800-555-1215');

--Inserção com data no formato ANSI(YYYY-MM-DD)
INSERT INTO customers(customer_id, first_name, last_name, dob, phone) VALUES (7, 'Steve', 'Purple', DATE '1972-10-25', '800-555-1215');

--Conversão de um DATE para texto com o formato passado
SELECT customer_id, TO_CHAR(dob, 'MONTH DD, YYYY') data_convertida_texto from customers;

--Conversão da data e hora atuais com o formato passado
SELECT TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS') data_hora_atual_convertida from dual;

--Consultar tabelas com dados sobre os formatos no livro em pdf nas páginas 163,164 e 165

SELECT TO_DATE('04/07/2007') texto_convertido_data FROM dual;

--Conversão de texto em data com formato. O formato se aplica ao que vai ser convertido e não na data depois de convertida
SELECT TO_DATE('04-06-2007','DD/MM/YYYY') texto_convertido_data FROM dual;

--TO_CHAR usado para poder ver a hora, minuto e segundo também
SELECT TO_CHAR(
        TO_DATE('04-06-2007 13:06:08','DD-MM-YYYY HH24:MI:SS'),
        'DD-MM-YYYY HH24:MI:SS'
    ) texto_convertido_data_hora
FROM dual;

--Mudando o formato padrao da data para a sessao
ALTER SESSION SET NLS_DATE_FORMAT = 'MM/DD/YYYY';

--------------------------------------FUNCOES DATA E HORA----------------------------------

--SYSDATE data e hora atuais
--ADD_MONTHS adiciona mes se numero for positivo, subtrai se o numero for negativo

SELECT add_months(SYSDATE,2) adiciona_meses,
       add_months(SYSDATE,-2) subtrai_meses
FROM dual;

--Retorna a data do ultimo dia do mes
SELECT last_day(SYSDATE) ultimo_dia_do_mes from dual;

--Retorna a quantidade de meses entre as datas passadas.
--Para retornar positivo a primeira data passada deve ser maior que a segunda, caso contrário retornará negativo
SELECT months_between('15-05-2008','04-01-2008') meses_entre_positivo,
       months_between('04-01-2008','15-05-2008') meses_entre_negativo
FROM dual;

--arrendonda por padrao para o dia mais proximo levando em consideração o tempo
--é possível arredondar também para o dia mais proximo a partir do mes ou ano mais próximo
SELECT round(SYSDATE) dia_mais_proximo FROM dual;

SELECT round(SYSDATE,'MM') mes_mais_proximo FROM dual;

SELECT round(SYSDATE,'RRRR') ano_mais_proximo FROM dual;

--trunca por padrao para o o começo do dia
--é possível truncar também para o o começo do mes ou para o começo do do ano
SELECT trunc(SYSDATE) dia_mais_proximo FROM dual;

SELECT trunc(SYSDATE,'MM') mes_mais_proximo FROM dual;

SELECT trunc(SYSDATE,'RRRR') ano_mais_proximo FROM dual;






