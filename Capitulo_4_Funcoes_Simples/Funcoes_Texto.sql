---------------------------------FUNÇOES RELACIONADAS A TEXTO----------------------------------

SELECT ascii('A')
FROM dual;
--Código ascII do caractere

SELECT CHR(65)
FROM dual;
--Caractere a partir do código ascII

SELECT upper('teste1') maiuscula
FROM dual;
--Maiúscula

SELECT lower('TESTE1') minuscula
FROM dual;
--Minúscula

SELECT concat('TESTE','TESTE2')
FROM dual;
--Concatena duas strings

SELECT initcap('geovanni souza purcino') nome
FROM dual;
--Primeira letra de cada palavra maiúscula

SELECT lpad('123456',10)
FROM dual;
--Preenche lado esquerdo do trecho com caractere espaço até completar o tamanho especificado

SELECT lpad('123456',10,'0')
FROM dual;
--Preenche lado esquerdo do trecho com caractere 0 até completar o tamanho especificado

SELECT rpad('123456',10)
FROM dual;
--Preenche lado direito do trecho com caractere espaço até completar o tamanho especificado

SELECT rpad('123456',10,'0')
FROM dual;
--Preenche lado direito do trecho com caractere 0 até completar o tamanho especificado

SELECT length('TESTE') tamanho
FROM dual;
--Quantidade de caracteres na cadeia(número inteiro)

SELECT replace('TESTE1','TE1','TES2') substituicao
FROM dual;
--substitui um trecho de caracteres por outro em uma cadeia de caracteres previamente definida

SELECT translate('TESTES1','S1','2') traducao
FROM dual;
--substitui um trecho de caracteres por apenas um caractere. Opera em nível de Char.

SELECT substr('TESTE1',2,2) trecho
FROM dual;
--Retorna uma parte de uma cadeia,com uma posição de início(começo da parte que será retornada) e a 
--quantidade de caracteres que essa parte deve ter(tamanho)

SELECT instr(
        'ABCDEFabcdefABCDEFdfgfDEF',
        'DEF',
        5,
        2
    ) pos
FROM dual;
--INSTR parâmetros(string que sofrerá pesquisa,o que vai ser procurado nessa string,em qual posição 
--a procura IRÁ COMEÇAR,número da ocorrência do trecho)

SELECT TRIM('  TESTE1  ') remove_espacos
FROM dual;
--Remove espaços de ambos os lados da cadeia de caracteres

SELECT ltrim('  TESTE1') remove_espacos_esquerda
FROM dual;
--Remove espaços do lado esquerdo da cadeia de caracteres

SELECT rtrim('TESTE1  ') remove_espacos_direita
FROM dual;
--Remove espaços do lado direito da cadeia de caracteres

SELECT TRIM('1' FROM '1TESTE1') elimina_1
FROM dual;
--Remove caractere 1 de ambos os lados da cadeia de caracteres

--Retorna a representação fonética do texto
SELECT soundex(dummy)
FROM dual;