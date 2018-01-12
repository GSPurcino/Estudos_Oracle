CREATE USER store IDENTIFIED BY store_password;

GRANT CONNECT, RESOURCE TO store; 
--CONNECT e RESOURCE SÃO ROLES PADRÕES DO SISTEMAS ORACLE

DROP USER store CASCADE; --O comando drop user com opção CASCADE é usado para excluir usuários que possuem objetos

--Para consultar privilégios desses papéis, deve-se ser feito assim:
SELECT privilege
       FROM dba_sys_privs
       WHERE grantee = 'RESOURCE';
/*O papel RESOURCE permite a criação dos seguintes objetos:
Trigger
Sequence
Type
Procedure
Cluster
Operator
Indextype
Table
*/

SELECT privilege
       FROM dba_sys_privs
       WHERE grantee = 'CONNECT';
--O papel CONNECT permite a criação de uma sessão, o que permite a quem possui esse privilégio se conectar no banco de dados 

