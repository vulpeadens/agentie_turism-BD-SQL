 -- INNER JOIN
 -- titlu carte, nume complet autor
 -- varianta 1
 SELECT titlu, COCNCAT(nume, ' ', prenume) nume_autor
 FROM carte, autor
 -- conditie join: tabela.pk = tabela.fk
 WHERE autor.id = carte.id_autor;
 
 -- varianta 2
  SELECT titlu, COCNCAT(nume, ' ', prenume) nume_autor
  FROM carte JOIN autor -- FROM autor JOIN carte// FROM autor INNER JOIN carte
  WHERE autor.id = carte.id_autor;
  
  -- varianta 3
  SELECT titlu, COCNCAT(nume, ' ', prenume) nume_autor
  FROM carte JOIN autor
  ON autr.id = carte.id_autor;
  -- nr conditii de join = numar tabele pe care se face join - 1
  
   -- titlu carte, nume complet autor, dar numai pt autorii din Marea Britanie
   -- varianta 1
     SELECT titlu, COCNCAT(nume, ' ', prenume) nume_autor
  FROM carte JOIN autor 
  WHERE autor.id = carte.id_autor AND tara_origine = 'Marea Britanie';
  
  -- varianta 2
       SELECT titlu, COCNCAT(nume, ' ', prenume) nume_autor
  FROM carte JOIN autor 
  ON autor.id = carte.id_autor
  WHERE tara_origine = 'Marea Britanie';
  
  -- nume client, titlu carti imprumutata
  SELECT CONCAT(nume, ' ', prenume) client, titlu  
  FROM client, carte, imprumut -- nu conteaza ordinea
  WHERE client.id = imprumut.id_client AND carte.id = imprumut.id_carte;
  
    SELECT CONCAT(nume, ' ', prenume) client, titlu  
  (din)FROM client, carte, imprumut -- nu conteaza ordinea
  (unde)WHERE client.id = imprumut.id_client AND carte.id = imprumut.id_carte
  (ordine)(de)ORDER BY client;
  
  
	SELECT CONCAT(nume, ' ', prenume) client, GROUP_CONCAT(titlu) 
	FROM client, carte, imprumut -- nu conteaza ordinea
	WHERE client.id = imprumut.id_client AND carte.id = imprumut.id_carte
	GROUP BY client
	ORDER BY client;
	
	SELECT CONCAT(nume, ' ', prenume) client, titlu
	FROM client JOIN imprumut ON client.id = imprumut.id_client
	JOIN carte ON carte.id = imprumut.id_carte;
	
	-- OUTER JOIN - LEFT/RIGHT
	-- toti autorii si titlu lor, unde este cazul
	SELECT CONCAT(nume, ' ',prenume) autor, titlu
	FROM autor LEFT JOIN carte
	ON autor.id = carte.id_autor;
	
		SELECT CONCAT(nume, ' ',prenume) autor, titlu
	FROM carte RIGHT JOIN autor
	ON autor.id = carte.id_autor;
	
	-- autorii de la care nu avem carti
	SELECT CONCAT(nume, ' ',prenume) autor, titlu
	FROM carte RIGHT JOIN autor
	ON autor.id = carte.id_autor
	WHERE titlu IS NULL;