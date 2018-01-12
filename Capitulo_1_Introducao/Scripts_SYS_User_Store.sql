CREATE USER store IDENTIFIED BY store_password;

GRANT CONNECT, RESOURCE TO store; 
--CONNECT e RESOURCE S�O ROLES PADR�ES DO SISTEMAS ORACLE

DROP USER store CASCADE; --O comando drop user com op��o CASCADE � usado para excluir usu�rios que possuem objetos

--Para consultar privil�gios desses pap�is, deve-se ser feito assim:
SELECT privilege
       FROM dba_sys_privs
       WHERE grantee = 'RESOURCE';
/*O papel RESOURCE permite a cria��o dos seguintes objetos:
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
--O papel CONNECT permite a cria��o de uma sess�o, o que permite a quem possui esse privil�gio se conectar no banco de dados 

