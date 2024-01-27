CREATE DATABASE bd_curs3;
USE bd_curs3;

-- departament: id(pk), denumire, acronim
CREATE TABLE departament(
id TINYINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
denumire VARCHAR(50) NOT NULL,
acronim VARCHAR(4)
);

-- angajat: id(pk), nume, prenume, data_angajare, data_demisie, salariu, id_departament(fk)
CREATE TABLE angajat(
id SMALLINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
nume VARCHAR(50) NOT NULL,
prenume VARCHAR(50) NOT NULL,
data_angajare DATE NOT NULL,
data_demisie DATE NULL,
salariu INT(5) NOT NULL DEFAULT 3000,
id_departament TINYINT NOT NULL,
FOREIGN KEY(id_departament) REFERENCES departament(id)
);


-- adaugarea datelor (CREATE -> clauza: insert)
INSERT INTO departament
VALUE(NULL, 'Development', 'DEV');

-- preluarea datelor (READ -> clauza 
SELECT * FROM departament;
SELECT id, denumire, acronim FROM departament; 

INSERT INTO departament
VALUES 
(NULL, 'Human Resources', 'HR'),
(NULL, 'Quality Assurance', 'QA'),
(NULL, 'Accountting', NULL);

INSERT INTO departament(acronim, denumire)
VALUES
('R&B', 'Research&Dev'),
(NULL, 'Finance');

INSERT INTO departament 
SET denumire = 'Operations', acronim = 'OPS';

INSERT INTO departament VALUES(); -- adauga doar null sau valori default

-- sterge: delete
DELETE FROM departament; -- sterg toate inrefistrarile
ALTER TABLE departament AUTO_INCREMENT = 1;

TRUNCATE departament;

INSERT INTO angajat
VALUES
(NULL, 'Popa', 'Matei', 201903115, NULL, 4500, 3),
(NULL, 'Rusu', 'Dan', 20180523, NULL, 5000, 7),
(NULL, 'Popa', 'Tania', '2019-08-06', NULL, 4600, 3),
(NULL, 'Nistor', 'Andrei', '2019-07-14', NULL, 6000, 1),
(NULL, 'Voicu', 'Ana', '2018-04-12', NULL, 5000, 1),
(NULL, 'Dinu', 'Bogdan', '2019-08-02', NULL, 4600, 2),
(NULL, 'Florescu', 'Gina', 20181108, NULL, 4300, 5);


SELECT * FROM angajat;

-- update 
-- un angajat  si-a dat demisia azi 
UPDATE angajat
SET data_demisie = CURDATE()
WHERE nume = 'Popa' AND prenume = 'Matei';

UPDATE angajat
SET data_demisie = 20210627
WHERE id = 1;

UPDATE angajat
SET data_demisie = '2021-06-27'
WHERE id = 1;

-- salariile din dept 1 si 2 s-au majorat cu 10%
UPDATE angajat
SET salariu = salariu * 1.1
WHERE id_departament = 1 OR id_departament = 2;

UPDATE angajat
SET salariu = salariu * 1.1
WHERE id_departament = 1 OR id_departament = 2;

UPDATE angajat
SET salariu = salariu * 1.1
WHERE id_departament IN (1,2);

-- statistici: salariul min, mediu, maxim
SELECT 
MIN(salariu) AS minim,
MAX(salariu) maxim,
AVG(salariu) media
FROM angajat;

-- cati angajati si-au dat demisia
SELECT COUNT(*) nr_angajati
FROM angajat
WHERE data_demisie IS NOT NULL;

-- angajatii curenti, ordonati dupa salariu
SELECT *
FROM angajat
WHERE data_demisie IS NULL
ORDER BY salariu;

SELECT *
FROM angajat
WHERE data_demisie IS NULL
ORDER BY salariu DESC;

-- angajatul cu cel mai mare salariu
SELECT *
FROM angajat
ORDER BY salariu DESC
LIMIT 1;

SELECT * 
FROM angajat
ORDER BY salariu DESC
LIMIT 1, 1; -- limit m, n = sar peste m inregistrari si le afisez pe urmatoarele n