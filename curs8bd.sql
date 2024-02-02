CREATE DATABASE bd_curs8;
USE bd_curs8;

CREATE TABLE IF NOT EXISTS bilet_avion(
id TINYINT NOT NULL PRIMARY KEY AUTO_INCREMENT,
oras_plecare VARCHAR(50),
oras_destinatie VARCHAR(50),
data_plecare DATE,
data_sosire DATE,
pret SMALLINT,
discount TINYINT,
clasa ENUM('Economic', 'Business', 'Comfort')
);


CREATE TABLE IF NOT EXISTS zbor_trecut(
id TINYINT NOT NULL PRIMARY KEY AUTO_INCREMENT,
oras_plecare VARCHAR(50),
oras_destinatie VARCHAR(50),
data_plecare DATE,
data_sosire DATE
);

INSERT INTO bilet_avion VALUES
(NULL, 'Amsterdam', 'Los Angeles', '2021-05-01', '2021-06-01', 1200, 10, 'Econimic'),
(NULL, 'Bucuresti', 'Malmo', '2021-04-25', '2021-05-06', 190, 5, 'Econimic'),
(NULL, 'Istanbul', 'New York', '2021-11-12', '2021-12-20', 1700, 15, 'Comfort'),
(NULL, 'Londra', 'Paris', '2021-12-05', '2021-12-19', 200, 10, 'Business'),
(NULL, 'Berlin', 'Madrid', '2021-02-01', '2021-02-28', 370, 10, 'Comfort');


INSERT INTO bilet_avion VALUES
(NULL, 'Bucuresti', 'Los Angeles', '2022-05-01', '2022-06-01', 1200, 10, 'Economic'),
(NULL, 'Bucuresti', 'New York', '2022-11-12', '2022-12-20', 1700, 15, 'Comfort'),
(NULL, 'Bucuresti', 'Madrid', '2022-12-05', '2022-12-19', 200, 10, 'Business');



DELIMITER //
CREATE PROCEDURE populeaza_zbor_trecut()
BEGIN
-- definim var pt a salva in ele pe rand datele din fiecar inregistrare din cursor
	DECLARE oras_p VARCHAR(50);
    DECLARE oras_d VARCHAR(50);
    DECLARE data_p DATE;
    DECLARE data_s DATE;
    
-- variabila de tip semafor pentru a indica cand avem/nu (mai) avem inregistrari cursor
-- initial prespune ca avem inregistrari => DEFAULT 1
	DECLARE exista_inregistrari_cursor TINYINT DEFAULT 1;
-- declaram cursor in care salvam result set-ul dintr-un select
	DECLARE cursor_zboruri CURSOR FOR
		SELECT oras_plecare, oras_destinatie, data_plecare, data_sosire
        FROM bilet_avion
        WHERE data_sosire < CURDATE();
-- declaram handler pentru a identifica cand nu mai avem inregistrari in cursor
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET exista_inregistrari_cursor = 0;
    OPEN cursor_zboruri;
    TRUNCATE zbor_trecut;
    zboruri: LOOP
		-- salvam valorile din inregistrarea curenta in variabile locale
		FETCH cursor_zboruri INTO oras_p, oras_d, data_p, data_s;
		-- daca nu am avem inregistrari in cursor, iesim den bucla
        IF exista_inregistrari_cursor = 0 THEN
			LEAVE zboruri;
		ELSE 
			INSERT INTO zbor_trecut VALUE(NULL, oras_p, oras_d, data_p, data_s);
		END IF;
	END LOOP zboruri;
    CLOSE cursor_zboruri;

END;
//
DELIMITER  ;


CALL populeaza_zbor_trecut();
SELECT * FROM zbor_trecut;



-- functie care primeste un oras de plecare
-- salveaza in cursor toate inregistrarile cu plecare din orasul primit ca parametru
-- pt fiecare zbor calculam un discount: daca pret < 800, discount = 10%, altfel discount = 15%
-- rezultat: Bucuresti -> Roma, pret cu discount: 170/Bucuresti -> New York, pret cu discount: 850

DELIMITER //
CREATE FUNCTION calculeaza_discount(plecare VARCHAR(59)) RETURNS TEXT
BEGIN
	DECLARE destinatie VARCHAR(50);
    DECLARE pret SMALLINT;
    DECLARE aplica_discount FLOAT;
    DECLARE detalii_zbor TEXT;
    DECLARE lista_zboruri TEXT;
    
    DECLARE ok TINYINT DEFAULT 1;
    
    DECLARE cursor_zboruri CURSOR FOR
		SELECT oras_destinatie, bilet_avion.pret
        FROM bilet_avion
        WHERE oras_plecare = plecare;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET ok = 0;
    
    OPEN cursor_zboruri;
    zboruri: LOOP
		FETCH cursor_zboruri INTO destinatie, pret;
        IF ok = 0 THEN 
			LEAVE zboruri;
		ELSE 
			IF pret <= 800 THEN
				SET aplica_discount = 0.9;
			ELSE 
				SET aplica_discount = 0.85;
			END IF;
            
            SET detalii_zbor = CONCAT(plecare, '->', destinatie, ' pret cu discount ', ceil(pret*aplica_discount));
            SET lista_zboruri = CONCAT_WS('/', lista_zboruri, detalii_zbor);
		END IF;
	END LOOP zboruri;
    CLOSE cursor_zboruri;
    
    RETURN lista_zboruri;
END;
//
DELIMITER  ;

SELECT calculeaza_discount('Bucuresti');

