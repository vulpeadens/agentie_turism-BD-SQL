DROP DATABASE IF EXISTS bd_curs9;
CREATE DATABASE IF NOT EXISTS bd_curs9;
USE bd_curs9;

CREATE TABLE IF NOT EXISTS angajat(
id TINYINT NOT NULL PRIMARY KEY AUTO_INCREMENT,
nume VARCHAR(50) NOT NULL,
prenume VARCHAR(50) NOT NULL,
data_angajare DATE NOT NULL,
salariu DECIMAL(7, 2)
);

CREATE TABLE IF NOT EXISTS audit_angajat(
id TINYINT NOT NULL PRIMARY KEY AUTO_INCREMENT,
id_angajat TINYINT NOT NULL,
user VARCHAR(50) NOT NULL,
data_ora_modificare DATETIME NOT NULL,
detalii MEDIUMTEXT,
FOREIGN KEY(id_angajat) REFERENCES angajat(id)
);

-- inainte de a adauga o inregistrare in tabela angajat, facem urmatoare prelucrari
-- nume, prenume - scrise cu majuscule
-- daca salariu < 2000, se pune automat 2000
-- daca data_angajare este in trecut, se pune automat data curenta

DELIMITER //
CREATE TRIGGER bi_angajat BEFORE INSERT
ON angajat FOR EACH ROW
BEGIN
	SET NEW.nume = UPPER(NEW.nume);
    SET NEW.prenume = UPPER(NEW.prenume);
    IF NEW.salariu < 2000 THEN
		SET NEW.salariu = 2000;
	END IF;
    IF NEW.data_angajare < CURDATE() THEN
		SET NEW.data_angajare = CURDATE();
	END IF;
END;
//
DELIMITER ;

INSERT INTO angajat 
VALUES
(NULL, 'Popescu', 'LauRa', '2021-05-06', 1800),
(NULL, 'Dinu', 'Bogdan', '2021-05-06', 2100);

SELECT * FROM angajat;

DROP TRIGGER bi_angajat;


-- daca la insert salariul este < 2000, dam eroare
-- SIGNAL SQLSTATE '<cod_eroare>' - definim o eroare custom
-- cod_eroare 45000 - eroare de utilizator - apare in action ouuput
DELIMITER //
CREATE TRIGGER bi_angajat2 BEFORE INSERT 
ON angajat FOR EACH ROW
BEGIN
	IF NEW.salariu < 2000 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Salariul minim trebuie sa fie 2000';
	END IF;
END;
//
DELIMITER  ;

-- la modificare salariala, facem insert in audit
-- modificare salariu: <salariu vechi> -> <salariu nou>
DELIMITER //
CREATE TRIGGER au_angajat AFTER UPDATE
ON angajat FOR EACH ROW
BEGIN 
	IF OLD.salariu != NEW.salariu THEN
		INSERT INTO audit_angajat
        VALUES(NULL, OLD.id, user(), NOW(), CONCAT('Modificare salariu  ', OLD.salariu, ' -> ', NEW.salariu));
	END IF;
END;

//
DELIMITER  ;

UPDATE angajat SET nume = 'Popescu' WHERE id = 3;
SELECT * FROM audit_angajat;

UPDATE angajat SET salariu = 4500 WHERE id = 3;