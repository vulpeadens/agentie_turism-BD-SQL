 -- INNER JOIN
 -- titlu carte, nume complet autor
 SELECT titlu, COCNCAT(nume, ' ', prenume) nume_autor
 FROM carte, autor
 -- conditie join: tabela.pk = tabela.fk
 WHERE 