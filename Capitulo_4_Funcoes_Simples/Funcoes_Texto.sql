---------------------------------FUN�OES RELACIONADAS A TEXTO----------------------------------

SELECT ascii('A')
FROM dual;
--C�digo ascII do caractere

SELECT CHR(65)
FROM dual;
--Caractere a partir do c�digo ascII

SELECT upper('teste1') maiuscula
FROM dual;
--Mai�scula

SELECT lower('TESTE1') minuscula
FROM dual;
--Min�scula

SELECT concat('TESTE','TESTE2')
FROM dual;
--Concatena duas strings

SELECT initcap('geovanni souza purcino') nome
FROM dual;
--Primeira letra de cada palavra mai�scula

SELECT lpad('123456',10)
FROM dual;
--Preenche lado esquerdo do trecho com caractere espa�o at� completar o tamanho especificado

SELECT lpad('123456',10,'0')
FROM dual;
--Preenche lado esquerdo do trecho com caractere 0 at� completar o tamanho especificado

SELECT rpad('123456',10)
FROM dual;
--Preenche lado direito do trecho com caractere espa�o at� completar o tamanho especificado

SELECT rpad('123456',10,'0')
FROM dual;
--Preenche lado direito do trecho com caractere 0 at� completar o tamanho especificado

SELECT length('TESTE') tamanho
FROM dual;
--Quantidade de caracteres na cadeia(n�mero inteiro)

SELECT replace('TESTE1','TE1','TES2') substituicao
FROM dual;
--substitui um trecho de caracteres por outro em uma cadeia de caracteres previamente definida

SELECT translate('TESTES1','S1','2') traducao
FROM dual;
--substitui um trecho de caracteres por apenas um caractere. Opera em n�vel de Char.

SELECT substr('TESTE1',2,2) trecho
FROM dual;
--Retorna uma parte de uma cadeia,com uma posi��o de in�cio(come�o da parte que ser� retornada) e a 
--quantidade de caracteres que essa parte deve ter(tamanho)

SELECT instr(
        'ABCDEFabcdefABCDEFdfgfDEF',
        'DEF',
        5,
        2
    ) pos
FROM dual;
--INSTR par�metros(string que sofrer� pesquisa,o que vai ser procurado nessa string,em qual posi��o 
--a procura IR� COME�AR,n�mero da ocorr�ncia do trecho)

SELECT TRIM('  TESTE1  ') remove_espacos
FROM dual;
--Remove espa�os de ambos os lados da cadeia de caracteres

SELECT ltrim('  TESTE1') remove_espacos_esquerda
FROM dual;
--Remove espa�os do lado esquerdo da cadeia de caracteres

SELECT rtrim('TESTE1  ') remove_espacos_direita
FROM dual;
--Remove espa�os do lado direito da cadeia de caracteres

SELECT TRIM('1' FROM '1TESTE1') elimina_1
FROM dual;
--Remove caractere 1 de ambos os lados da cadeia de caracteres

--Retorna a representa��o fon�tica do texto
SELECT soundex(dummy)
FROM dual;