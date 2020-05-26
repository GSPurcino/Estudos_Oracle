------------------------------------------------------USERS--------------------------------------------------------

--Tablespace s�o usados para armazenar os objetos do banco de dados. Geralmente objetos relacionados s�o colocados no mesmo tablespace.

--Sintaxe para cria��o de usu�rio.
CREATE USER user_name IDENTIFIED BY password
[DEFAULT TABLESPACE default_tablespace]
[TEMPORARY TABLESPACE temporary_tablespace];

--Exemplo abaixo sem tablespace
CREATE USER jason IDENTIFIED BY price;

--Exemplo abaixo com tablespace
CREATE USER henry IDENTIFIED BY hooray
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp;

--Alterar a senha do usu�rio
ALTER USER jason IDENTIFIED BY marcus;

--Exclus�o do usu�rio
DROP USER jason;

----------------------------------------------PRIVIL�GIOS DE SISTEMA------------------------------------------------

--GRANT
--Serve para dar privil�gios(sistema ou objeto)
--Para um usuario poder se conectar, ele ter ter o seguinte privilegio
GRANT CREATE SESSION TO jason;

--Esses privil�gios servem para permitir a um usu�rio fazer certas a��es no banco de dados. 
--Exemplos s�o privil�gios como CREATE SESSION e CREATE TABLE. Como no exemplo abaixo:
GRANT CREATE SESSION, CREATE USER, CREATE TABLE TO steve;

--� poss�vel usar a op��o de administrador quando um privil�gio de sistema � concedido. 
--Essa op��o permite que o privil�gio seja concedido a outros usu�rios por quem recebeu o privil�gio dessa forma.
--Exemplo abaixo:

GRANT EXECUTE ANY PROCEDURE TO steve WITH ADMIN OPTION;

--Isso significa que o usu�rio steve pode conceder a outros usu�rios o privil�gio EXECUTE ANY PORCEDURE.

--� poss�vel garantir um privil�gio para todos os usu�rios. Para isso o privil�gio deve ser concedido para PUBLIC.
GRANT EXECUTE ANY PROCEDURE TO PUBLIC;

--Desse modo todos os usu�rios podem executar qualquer procedure e function
--(no contexto de privil�gio function � um tipo especial de procedure)

--Consultar privilegios de sistema concedidos ao usu�rio

SELECT * FROM user_sys_privs;

--Para remover privil�gios, usa-se o REVOKE
REVOKE EXECUTE ANY PROCEDURE FROM steve;

--Caso o usu�rio tenha concedido esse privil�gio para outro(recebeu WITH ADMIN OPTION), remover o privil�gio dele n�o remover� o privil�gio para quem foi dado.
--No exemplo steve n�o pode mais executar procedures, isso n�o significa que outros usu�rios que receberam essa permiss�o do steve n�o podem mais executar procedures.
--Uma dica sobre privil�gios � olhar para o objeto individualmente, 
--sobre quais privil�gios ele tem, quais ele pode conceder, quais ele n�o precisa e quais ele precisa.


------------------------------------------PRIVIL�GIOS DE OBJETO----------------------------------------------------

--Um privil�gio de objeto permite ao usu�rio realizar uma a��o sobre um certo objeto.
--Exemplo
GRANT SELECT, INSERT, UPDATE ON store.products TO steve;
GRANT SELECT ON store.employees TO steve;

--Concedendo privil�gios em duas tabelas, para realizar a��es espec�ficas ao tipo de objeto 

--Exemplo de UPDATE somente em certas colunas
GRANT UPDATE (last_name, salary) ON store.employees TO steve;

--Assim como com privil�gios de sistema � poss�vel conceder privil�gios de objeto de modo que quem tenha recebido o privil�gio possa conced�-lo.
--Isso � feito WITH GRANT OPTION
--Exemplo
GRANT SELECT ON store.customers TO steve WITH GRANT OPTION;

--Consultar privilegios de objeto
SELECT *
FROM user_tab_privs;

--Consultar privil�gios de objetos feitos
SELECT * FROM user_tab_privs_made;

--Consultar privil�gios de objetos recebidos
SELECT * FROM user_tab_privs_recd;

--Consultar privil�gios garantidos por colunas
SELECT *
FROM user_col_privs_made;
------------------------------------------------------SYNONYMS-------------------------------------------------------------

--Sinonimos servem para poder se referir a um objeto de outra maneira. 
--S�o uteis por exemplo quando um owner precisa usar um objeto de outro owner. 
--Em vez de ter que referenciar o owner todo objeto, pode-se criar um sinonimo como abaixo:
CREATE SYNONYM customers FOR store.customers;

--Para criar um sinonimo public � necess�rio ter o privil�gio CREATE PUBLIC SYNONYM. Quando um sinonimo � publico, ele e visto por todos os usu�rios
CREATE PUBLIC SYNONYM products FOR store.products;

-----------------------------------------------PAPEIS---------------------------------------------------------------

--Um papel � um grupo de privilegios que podem ser concedidos para usuarios ou para outro papel.
--Papel possui os seguintes beneficios

--Permite assinalar privilegios para o papel e depois conceder esse papel para multiplos usuarios.
--Ou seja e uma maneira mais facil de conceder os mesmos privilegios para multiplos usuarios.

--Quando um privilegio e adicionado ou removido do papel, todos os usuarios e papeis que receberam o papel perdem ou ganham o privil�gio

--� poss�vel assinalar multiplos papeis para usuarios e outros papeis

--� poss�vel ter senhas em papeis.

--Exemplo

CREATE ROLE product_manager;

CREATE ROLE hr_manager;

CREATE ROLE overall_manager IDENTIFIED by manager_password;

--Concess�o de privil�gios para os pap�is

GRANT SELECT, INSERT, UPDATE, DELETE ON product_types TO product_manager;

GRANT SELECT, INSERT, UPDATE, DELETE ON products to product_manager;

GRANT SELECT, INSERT, UPDATE, DELETE ON salary_grades TO hr_manager;

GRANT SELECT, INSERT, UPDATE, DELETE ON employees to hr_manager;

GRANT CREATE USER TO hr_manager;

GRANT product_manager, hr_manager TO overall_manager;

--Exemplo. Concedendo papel para usu�rio

GRANT overall_manager TO steve;

--Consultar papeis concedidos para os usuarios

SELECT * FROM user_role_privs;

--Consultar privilegios de sistema concedidos ao papel

SELECT *
FROM role_sys_privs
ORDER BY privilege;

--Consultar privilegios de objeto concedidos ao papel
SELECT * FROM role_tab_privs ORDER BY privilege;

--Por padr�o quando um papel e concedido para um usuario, o papel � habilitado. 
--Isso significa que os privil�gios ligados a esse papel j� podem ser usados.

--� poss�vel mudar esse comportamento para que o papel deva ser habilitado toda vez que o usu�rio se conecta.
--Exemplo
ALTER USER steve DEFAULT ROLE ALL EXCEPT overall_manager;

-- Caso o papel tenha uma senha, para poder ser habilitado, a senha deve ser passada.
SET ROLE overall_manager IDENTIFIED BY manager_password;

--� poss�vel definir que o usu�rio n�o tem papel
SET ROLE NONE;

SET ROLE ALL EXCEPT overall_manager;

--Removendo um papel do usuario
REVOKE overall_manager FROM steve;

--Removendo privilegios do papel
REVOKE ALL ON products FROM product_manager;

--Excluindo um papel
DROP ROLE overall_manager;
DROP ROLE product_manager;
DROP ROLE hr_manager;


