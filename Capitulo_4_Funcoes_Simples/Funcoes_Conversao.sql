-------------------------------FUNCOES RELACIONADAS A CONVERSAO-----------

--Converte o que foi passado em texto
--Pode receber par�metros opcionais para formatar o que vai ser convertido
SELECT TO_CHAR(275326.46) converte_numero_em_texto FROM dual;

--Para consultar os formatos, olhar no livro em pdf nas p�ginas 135 e 136

--Serve para converter o tipo do par�metro para outro tipo compat�vel.
--Para consultar as poss�veis convers�es do CAST olhar a tabela na p�gina 138 do livro em pdf
SELECT CAST(23782 AS CHAR(5)) cast_numero_char FROM dual;