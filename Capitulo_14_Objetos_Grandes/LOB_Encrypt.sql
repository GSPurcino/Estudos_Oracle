--Criar diret�rio wallet na pasta oraclexe/admin/XE(Procurar o seu ORACLE SID para achar a pasta certa)
--Fazer esse comando com o usu�rio SYS ou SYSTEM

ALTER SYSTEM SET ENCRYPTION KEY IDENTIFIED BY "teste123";

--Com o comando um arquivo ewallet.p12 � criado no diret�rio wallet.
--A chave da criptografia � guardada nesse arquivo. Os dados s�o criptografados e descriptografados por debaixo dos panos 
--O banco de dados automaticamente abre a wallet.
--A carteira estar aberta significa que � poss�vel modificar e consultar os dados criptografados

--� poss�vel criptografar dados em colunas dos tipos BLOB, CLOB, NCLOB para prevenir acessos n�o autorizados.
--Os seguintes algoritmos de criptografia podem ser utilizados: 3DES168, AES128, AES192, AES256

--Exemplo
--N�o funciona com o Oracle Express Edition
CREATE TABLE clob_content_encrypt (
    id            INTEGER PRIMARY KEY,
    clob_column   CLOB ENCRYPT USING 'AES128'
)
    LOB ( clob_column ) STORE AS SECUREFILE (
        CACHE
    );

INSERT INTO clob_content_encrypt (
id, clob_column
) VALUES (
2, TO_CLOB(' from day to day')
);

SELECT * FROM clob_content_encrypt;
--Caso um algoritmo de criptografia n�o seja escolhido, o padr�o � AES192
--A op��o CACHE indica para o BD colocar os dados do clob_column no CACHE para acesso mais r�pido

--Fechando a carteira(sys ou system)
ALTER SYSTEM SET WALLET CLOSE;

--Quando a carteira est� fechada, n�o � poss�vel consultar nem alterar os dados criptografados.
--Mas isso n�o afeta colunas n�o criptografadas que podem ser consultadas e modificadas

SELECT id from clob_content_encrypt;

--Para abrir a carteira � necess�rio a chave de criptografia
ALTER SYSTEM SET WALLET OPEN IDENTIFIED BY "testpassword123";

--� poss�vel tamb�m criptografar dados de colunas que n�o s�o LOB
CREATE TABLE credit_cards (
    card_number   NUMBER(16,0) ENCRYPT,
    first_name    VARCHAR2(10),
    last_name     VARCHAR2(10),
    expiration    DATE
);

INSERT INTO credit_cards (
    card_number,
    first_name,
    last_name,
    expiration
) VALUES (
    1234,
    'Jason',
    'Bond',
    '03-FEV-2008'
);

INSERT INTO credit_cards (
    card_number,
    first_name,
    last_name,
    expiration
) VALUES (
    5768,
    'Steve',
    'Edwards',
    '07-MAR-2009'
);

--Para acessar uma coluna criptografada o Banco de dados leva mais tempo(precia criptografar e descriptografar). 
--Leva em m�dia 5% a mais de tempo por insert e SELECT. O tempo extra total depende do numero de colunas criptografadas 
--e a frequ�ncia de acesso a elas.
--Como boa pr�tica deve-se criptografar apenas colunas com dados sens�veis

--Compressao de LOB
--� poss�vel comprimir um LOB para ocupar menos espa�o

CREATE TABLE clob_content3 (
    id            INTEGER PRIMARY KEY,
    clob_column   CLOB
)
    LOB ( clob_column ) STORE AS SECUREFILE (
        COMPRESS
        CACHE
    );

--� poss�vel remover dados duplicados de um BLOB antes de serem colocados
CREATE TABLE clob_content2 (
id INTEGER PRIMARY KEY,
clob_column CLOB
) LOB(clob_column) STORE AS SECUREFILE (
DEDUPLICATE LOB
CACHE
);
