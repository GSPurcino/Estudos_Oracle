------------------------------------------------------USERS--------------------------------------------------------

--Tablespace são usados para armazenar os objetos do banco de dados. Geralmente objetos relacionados são colocados no mesmo tablespace.

--Sintaxe para criação de usuário.
CREATE USER user_name IDENTIFIED BY password
[DEFAULT TABLESPACE default_tablespace]
[TEMPORARY TABLESPACE temporary_tablespace];

--Exemplo abaixo sem tablespace
CREATE USER jason IDENTIFIED BY price;

--Exemplo abaixo com tablespace
CREATE USER henry IDENTIFIED BY hooray
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp;

--Alterar a senha do usuário
ALTER USER jason IDENTIFIED BY marcus;

--Exclusão do usuário
DROP USER jason;

----------------------------------------------PRIVILÉGIOS DE SISTEMA------------------------------------------------

--GRANT
--Serve para dar privilégios(sistema ou objeto)
--Para um usuario poder se conectar, ele ter ter o seguinte privilegio
GRANT CREATE SESSION TO jason;

--Esses privilégios servem para permitir a um usuário fazer certas ações no banco de dados. 
--Exemplos são privilégios como CREATE SESSION e CREATE TABLE. Como no exemplo abaixo:
GRANT CREATE SESSION, CREATE USER, CREATE TABLE TO steve;

--É possível usar a opção de administrador quando um privilégio de sistema é concedido. 
--Essa opção permite que o privilégio seja concedido a outros usuários por quem recebeu o privilégio dessa forma.
--Exemplo abaixo:

GRANT EXECUTE ANY PROCEDURE TO steve WITH ADMIN OPTION;

--Isso significa que o usuário steve pode conceder a outros usuários o privilégio EXECUTE ANY PORCEDURE.

--é possível garantir um privilégio para todos os usuários. Para isso o privilégio deve ser concedido para PUBLIC.
GRANT EXECUTE ANY PROCEDURE TO PUBLIC;

--Desse modo todos os usuários podem executar qualquer procedure e function
--(no contexto de privilégio function é um tipo especial de procedure)

--Consultar privilegios de sistema concedidos ao usuário

SELECT * FROM user_sys_privs;

--Para remover privilégios, usa-se o REVOKE
REVOKE EXECUTE ANY PROCEDURE FROM steve;

--Caso o usuário tenha concedido esse privilégio para outro(recebeu WITH ADMIN OPTION), remover o privilégio dele não removerá o privilégio para quem foi dado.
--No exemplo steve não pode mais executar procedures, isso não significa que outros usuários que receberam essa permissão do steve não podem mais executar procedures.
--Uma dica sobre privilégios é olhar para o objeto individualmente, 
--sobre quais privilégios ele tem, quais ele pode conceder, quais ele não precisa e quais ele precisa.


------------------------------------------PRIVILÉGIOS DE OBJETO----------------------------------------------------

--Um privilégio de objeto permite ao usuário realizar uma ação sobre um certo objeto.
--Exemplo
GRANT SELECT, INSERT, UPDATE ON store.products TO steve;
GRANT SELECT ON store.employees TO steve;

--Concedendo privilégios em duas tabelas, para realizar ações específicas ao tipo de objeto 

--Exemplo de UPDATE somente em certas colunas
GRANT UPDATE (last_name, salary) ON store.employees TO steve;

--Assim como com privilégios de sistema é possível conceder privilégios de objeto de modo que quem tenha recebido o privilégio possa concedê-lo.
--Isso é feito WITH GRANT OPTION
--Exemplo
GRANT SELECT ON store.customers TO steve WITH GRANT OPTION;

--Consultar privilegios de objeto
SELECT *
FROM user_tab_privs;

--Consultar privilégios de objetos feitos
SELECT * FROM user_tab_privs_made;

--Consultar privilégios de objetos recebidos
SELECT * FROM user_tab_privs_recd;

--Consultar privilégios garantidos por colunas
SELECT *
FROM user_col_privs_made;
------------------------------------------------------SYNONYMS-------------------------------------------------------------

--Sinonimos servem para poder se referir a um objeto de outra maneira. 
--São uteis por exemplo quando um owner precisa usar um objeto de outro owner. 
--Em vez de ter que referenciar o owner todo objeto, pode-se criar um sinonimo como abaixo:
CREATE SYNONYM customers FOR store.customers;

--Para criar um sinonimo public é necessário ter o privilégio CREATE PUBLIC SYNONYM. Quando um sinonimo é publico, ele e visto por todos os usuários
CREATE PUBLIC SYNONYM products FOR store.products;

-----------------------------------------------PAPEIS---------------------------------------------------------------

--Um papel é um grupo de privilegios que podem ser concedidos para usuarios ou para outro papel.
--Papel possui os seguintes beneficios

--Permite assinalar privilegios para o papel e depois conceder esse papel para multiplos usuarios.
--Ou seja e uma maneira mais facil de conceder os mesmos privilegios para multiplos usuarios.

--Quando um privilegio e adicionado ou removido do papel, todos os usuarios e papeis que receberam o papel perdem ou ganham o privilégio

--é possível assinalar multiplos papeis para usuarios e outros papeis

--É possível ter senhas em papeis.

--Exemplo

CREATE ROLE product_manager;

CREATE ROLE hr_manager;

CREATE ROLE overall_manager IDENTIFIED by manager_password;

--Concessão de privilégios para os papéis

GRANT SELECT, INSERT, UPDATE, DELETE ON product_types TO product_manager;

GRANT SELECT, INSERT, UPDATE, DELETE ON products to product_manager;

GRANT SELECT, INSERT, UPDATE, DELETE ON salary_grades TO hr_manager;

GRANT SELECT, INSERT, UPDATE, DELETE ON employees to hr_manager;

GRANT CREATE USER TO hr_manager;

GRANT product_manager, hr_manager TO overall_manager;

--Exemplo. Concedendo papel para usuário

GRANT overall_manager TO steve;

--Consultar papeis concedidos para os usuarios

SELECT * FROM user_role_privs;

--Consultar privilegios de sistema concedidos ao papel

SELECT *
FROM role_sys_privs
ORDER BY privilege;

--Consultar privilegios de objeto concedidos ao papel
SELECT * FROM role_tab_privs ORDER BY privilege;

--Por padrão quando um papel e concedido para um usuario, o papel é habilitado. 
--Isso significa que os privilégios ligados a esse papel já podem ser usados.

--É possível mudar esse comportamento para que o papel deva ser habilitado toda vez que o usuário se conecta.
--Exemplo
ALTER USER steve DEFAULT ROLE ALL EXCEPT overall_manager;

-- Caso o papel tenha uma senha, para poder ser habilitado, a senha deve ser passada.
SET ROLE overall_manager IDENTIFIED BY manager_password;

--É possível definir que o usuário não tem papel
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


