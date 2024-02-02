 -- variabile globale
 SET @numar = 10;
 SELECT @numar;
 
 
 SELECT @numar := 20;
 
  SELECT @numar = 10; -- verifica daca @numar este 10
 SELECT @numar = 20;
 -- 1 se verifica daca este egal cu 20
 
 --variabila globala acsinarea o variabila
 SELECT 15 INTO @numar;
 
 SELECT @nume_complet := CONCAT(nume, ' ',prenume) FROM absolvent WHERE id = 7;
 SELECT @nume_complet;
 
 SELECT CONCAT(nume, ' ', prenume) INTO @nume_complet FROM absolvent WHERE id = 3;
 SELECT @nume_complet;
 
 SELECT @nume := nume, @prenume := prenume FROM absolvent WHERE id = 3;
 
 SELECT nume, prenume INTO @nume, @prenume FROM absolvent WHERE id = 1;
 SELECT @nume, @prenume;
 
 --rutine
 -- snake_case
 -- camelCase
 
 -- sa se creeze o rutina care primeste id-ul unui absolvent si ofera detalii despre acesta (nume, medie, etc)
 DELIMITER :-)
 CREATE FUNCTION detalii_absolvent(id TINYINT) RETURN VARCHAR(500)
 BEGIN
	DECLARE nume_complet VARCHAR(500);
	DECLARE nume VARCHAR(50);
	DECLARE prenume VARCHAR(50);
	
	SELECT absolvent.nume, absolvent.prenume INTO nume, prenume
	FROM absolvent
	WHERE absolvent.id = id;
	SET nume_complet = CONCAT(nume, ' ', prenume);
 
	RETURN nume_complet;
END;
:-)
DELIMITER ;
 
 SELECT detalii_absolvent(1);
 
 SELECT detalii_absolvent(id) FROM absolvent WHERE id IN (1, 2, 3);
 
 SELECT detalii_absolvent(id), medie_absolvent FROM absolvent;
 
 
 DELIMITER //
 CREATE PROCEDURE detalii_absolvent(IN id TINYINT)
 BEGIN
	SELECT CONCAT(nume, ' ', prenume)
	FROM absolvent
	WHERE absolvent.id = id;
END;
//
DELIMITER ;

CALL detalii_absolvent(1);
 
 
 
  DELIMITER //
 CREATE PROCEDURE detalii_absolvent(IN id TINYINT, OUT nume_complet VARCHAR(100))
 BEGIN
	SELECT CONCAT(nume, ' ', prenume) INTO nume_complet
	FROM absolvent
	WHERE absolvent.id = id;
END;
//
DELIMITER ;
 
 CALL detalii_absolvent_v2(1, @nume_absolvent);
 SELECT @nume_absolvent;
 
  CALL detalii_absolvent_v2(1, @nume_absolvent);
 SELECT @nume_absolvent;
 
   CALL detalii_absolvent_v2(3, @nume_absolvent);
 SELECT @nume_absolvent;
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 