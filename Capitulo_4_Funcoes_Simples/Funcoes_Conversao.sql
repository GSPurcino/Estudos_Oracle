-------------------------------FUNCOES RELACIONADAS A CONVERSAO-----------

--Converte o que foi passado em texto
--Pode receber parâmetros opcionais para formatar o que vai ser convertido
SELECT TO_CHAR(275326.46) converte_numero_em_texto FROM dual;

--Para consultar os formatos, olhar no livro em pdf nas páginas 135 e 136

--Serve para converter o tipo do parâmetro para outro tipo compatível.
--Para consultar as possíveis conversões do CAST olhar a tabela na página 138 do livro em pdf
SELECT CAST(23782 AS CHAR(5)) cast_numero_char FROM dual;