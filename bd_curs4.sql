CREATE DATABASE IF NOT EXISTS bd_curs4;
USE bd_curs4;

CREATE TABLE IF NOT EXISTS film(
id TINYINT NOT NULL PRIMARY KEY AUTO_INCREMENT,
titlu VARCHAR(50) NOT NULL DEFAULT 'N/A',
regizor VARCHAR(50) NOT NULL DEFAULT 'N/A',
protagonist VARCHAR(50) NOT NULL DEFAULT 'N/A',
data_aparitie DATE NOT NULL DEFAULT '2018-01-01',
oscar ENUM('Da', 'Nu') NOT NULL DEFAULT 'Nu',
durata TINYINT UNSIGNED NOT NULL DEFAULT 120,
categorie ENUM('Drama', 'Dragoste', 'Actiune', 'Thriller', 'SF', 'Horror', 'Comedie', 'Aventura'),
rating DECIMAL(4, 2) NOT NULL DEFAULT  0,
tara_origine VARCHAR(30) NOT NULL DEFAULT 'USA'
);

INSERT INTO film
(titlu, protagonist, regizor, data_aparitie, rating, oscar, durata, categorie) VALUES
('Red Sparrow', 'Jennifer Lawrence', 'Francis Lawrence', '2018-03-02', 6.8, 'Nu', 140, 'Drama'),
('Wonder Woman', 'Gal Gadot', 'Patty Jenkins', 20170602, 7.5, 'Nu', 141, 'Actiune'),
('Iron Man', 'Robert Downey Jr', 'Jon Favreau', 20080502, 7.9, 'Nu', 126, 'Actiune'),
('The Conjuring', 'Patrick Wilson', 'James Wan', 20130719, 7.5, 'Nu', 112, 'Horror'),
('Interstellar', 'Matthew McConaughey', 'Christopher Nolan', 20141107, 8.6, 'Da', 168, 'SF'),
('Gravity', 'Sandra Bullock', 'Alfonso Cuaron', 20131004, 7.8, 'Da', 91, 'SF'),
('The shape of water', 'Sally Hawkins', 'Guillermo del Toro', 20171222, 7.5, 'Da', 123, 'Drama'),
('How to lose a guy in 10 days', 'Matthew McConaughey', 'Donald Petrie', 20030207, 6.4, 'Nu', 116, 'Comedie'),
('The notebook', '   Gena   Rowlands    ', 'Nick Cassavetes', 20040625, 7.9, 'Nu', 123, 'Dragoste');

INSERT INTO film VALUES(NULL, 'Toate panzele sus', 'Mircea Muresan', 'Ion Besoiu', 19760104, 'Nu', 568, 'Actiune', 8.9,'Romania'),
(NULL, 'Incendies', 'Denis Villeneuse', 'Luna Azabal', 20110623, 'Nu', 131, 'Drama', 8.2, 'Franta');

SELECT @@sql_mode;
#string SQL MODE - daca o valoare este mai mare decat cea admisa, da eroare
SET sql_mode = 'traditional';
#disabled - daca am o valoare mai mare decat cea admisa, se pune automat val maxima admisa si ne da un warning
SET sql_mode = '';

-- cate filme au/nu au oscar
SELECT oscar, COUNT(*) nr_filme
FROM film


SELECT oscar, COUNT(*) nr_filme
FROM film
GROUP BY oscar;

-- rating min, maxm, mediu pt fiecare categorie
SELECT
 categorie,
MIN(rating) minim,
MAX(rating) maxim,
AVG(rating) mediu
FROM film

SELECT
 categorie,
MIN(rating) minim,
MAX(rating) maxim,
AVG(rating) mediu
FROM film

SELECT
 categorie,
MIN(rating) minim,
MAX(rating) maxim,
AVG(rating) mediu
FROM film
GROUP BY categorie;

-- cate filme au aparut in fiecare an
SELECT YEAR(data_aparitie) an, COUNT(*)
FROM film
GROUP BY an;

-- cate filme au aparut in fiecare an, dupa 2000
SELECT YEAR(data_aparitie) an, COUNT(*)
FROM film
WHERE YEAR(data_aparitie) > 2000
GROUP BY an;

-- rating mediu per categorie, dar numai pt categoriile cu un rating mediu >= 8
SELECT categorie, AVG(rating) rating_mediu
FROM film
GROUP BY categorie;

SELECT categorie, AVG(rating) rating_mediu
FROM film
GROUP BY categorie
HAVING rating_mediu >= 8;

-- rating mediu pt categoriile drama, actiune, horror, Dar numai rez cu rating mediu >= 8
SELECT categorie, AVG(rating) rating_mediu
FROM film
WHERE categorie IN ('Drama', 'Actiune',  'Horror')
GROUP BY categorie
HAVING rating_mediu >= 7.6;

-- categoriile cu cel putin 2 filme, aparute dupa 2008
SELECT categorie, COUNT(*) nr_filme
FROM film
WHERE YEAR(data_aparitie) > 2008
GROUP BY categorie
HAVING nr_filme >= 2;

-- Oscar   Filme
-- da       f1, f2, ...
-- nu       f3, f4 ...

SELECT oscar, group_concat(titlu) filme
FROM film
GROUP BY oscar;

SELECT oscar, group_concat(titlu SEPARATOR '/') filme
FROM film
GROUP BY oscar;

-- cate filme au aparut in fiecare an, dupa 2000, dar adauga si lista de filme
SELECT YEAR(data_aparitie) an, COUNT(*), GROUP_CONCAT(titlu)
FROM film
WHERE YEAR(data_aparitie) > 2000
GROUP BY an;