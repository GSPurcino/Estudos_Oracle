---------------------------INTERVALS--------------------
--E possivel criar uma tabela com uma coluna do tipo interval para armazenar intervalos de tempo
--Os intervalos podem ser medidos por ano e mes ou por dias e segundos.
--Para o ano, dia e segundo é possível passar um numero de precisao(0 a 9) 
--para dizer qual sera a quantidade maxima de digitos usada para escrever o valor. 
--No caso de segundos, os digitos sao para a parte decimal depois do .

---------------INTERVAL YEAR TO MONTH--------------------------------

--Sintaxe para passagem de valor
INTERVAL '[+|-][y][-m]' [YEAR[(years_precision)])] [TO MONTH]

--O +(positivo) e o -(negativo)

--Exemplos de como passar o valor para colocar numa coluna de interval
INTERVAL '1' YEAR

INTERVAL '11' MONTH

INTERVAL '14' MONTH

INTERVAL '1-3' YEAR TO MONTH
--Quando um intervalo for representado em anos e meses, deve-se incluir YEAR TO MONTH

SELECT *
FROM coupons;

------------------------------INTERVAL DAY TO SECOND----------------------------

--Sintaxe para passagem de valor
INTERVAL '[+|-][d] [h[:m[:s]]]' [DAY[(days_precision)]])
[TO HOUR | MINUTE | SECOND[(seconds_precision)]]

--Exemplo de passagem de valor
INTERVAL '3' DAY 
INTERVAL '2' HOUR
INTERVAL '25' MINUTE
INTERVAL '45' SECOND
INTERVAL '3 2' DAY TO HOUR
INTERVAL '3 2:25' DAY TO MINUTE
INTERVAL '3 2:25:45' DAY TO SECOND

SELECT * FROM promotions;

----------------------------------------Funcoes em intervals--------------------------------

--NUMTODSINTERVAL converte um numero para um intervalo DAY TO SECOND
SELECT numtodsinterval(1.5,'DAY') numero_para_intervalo_dias,
       numtodsinterval(3.25,'HOUR') numero_para_intervalo_horas,
       numtodsinterval(5,'MINUTE') numero_para_intervalo_minutos,
       numtodsinterval(10.123456789,'SECOND') numero_para_intervalo_segundos
FROM dual;

--NUMTOYMINTERVAL converte um numero para um intervalo YEAR TO MONTH
SELECT numtoyminterval(1.5,'YEAR') numero_para_intervalo_anos,
       numtoyminterval(3,'MONTH') numero_para_intervalo_meses
       from dual;

