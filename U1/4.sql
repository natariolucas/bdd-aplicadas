/*

4. Cree un SP llamado �insertarLog� que reciba dos par�metros: modulo y texto. Si el 
modulo llega en blanco debe utilizar el texto �N/A�. Este SP insertar� registros en la 
tabla de bit�cora. A partir del siguiente punto, cada inserci�n, borrado, modificaci�n, 
debe crear un registro en la mencionada tabla. En ning�n caso debe realizar 
INSERTs por fuera del SP insertarLog. 

*/

CREATE OR ALTER PROCEDURE insertarLog @modulo varchar(10), @texto varchar(50)
AS
BEGIN
 IF @texto = ''
	SET @texto = 'N/A';

 INSERT INTO ddbba.registro(texto, modulo) VALUES(@texto, @modulo);

END;