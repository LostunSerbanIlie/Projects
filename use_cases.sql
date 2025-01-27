--vizualizam tabelele existente
SELECT * FROM user_tables;  


-- succesiunea prin care putem sterge tabelele fara a avea erori
--DROP TABLE internari;
--DROP TABLE repartizari;
--DROP TABLE pacient;
--DROP TABLE doctor;
--DROP TABLE sectie;
--DROP TABLE info_sectie;

-- succesiunea prin care putem sterge datele din tabele fara a avea erori
--DELETE FROM repartizari WHERE id_repartizare IS NOT NULL;
--DELETE FROM internari WHERE id_internare IS NOT NULL;
--DELETE FROM pacient WHERE id_pacient IS NOT NULL;
--DELETE FROM doctor WHERE id_doctor IS NOT NULL;
--DELETE FROM sectie WHERE id_sectie IS NOT NULL;
--DELETE FROM info_sectie WHERE id_info IS NOT NULL;


-- use-case: adaugarea unui pacient nou.
-- constrangeri testate: unicitatea cnp-ului si a numarului ci (seria se poate repeta).
INSERT INTO pacient (id_pacient, nume, prenume, cnp, seria_ci, numar_ci, asigurat_cnas)
VALUES (1, 'Popescu', 'Ion', '1990505123456', 'AB', 123456, 1);

-- ORA-00001: unique constraint (BD027.PACIENT_NUMAR_CI_UK) violated
-- daca punem cnp de exemplu: 113456 merge



-- use-case: repartizarea unui pacient unui medic.
-- constrangeri testate: pacientul trebuie sa existe, iar medicul trebuie sa fie asociat unei sectii compatibile.
-- id repartizare trebuie sa nu existe deja - primary key

INSERT INTO repartizari (id_repartizare, tip_consult, id_pacient, id_doctor)
VALUES (1,'ambulatoriu', 1, 3);

-- ORA-02291: integrity constraint (BD027.PACIENT_REPARTIZARI_FK) violated - parent key not found
--- dar daca punem de exemplu pacientul 125 si medicul 25, atunci va functiona deoarece ambii exista


-- use-case: internarea unui pacient intr-o sectie.
-- constrangeri testate: pacientul nu poate fi internat in mai multe sectii simultan.
INSERT INTO internari (id_internare, data_internarii, id_pacient, id_sectie)
VALUES (1, TO_DATE('2025-01-02', 'YYYY-MM-DD'), 125, 3);


-- use-case: externarea unui pacient.
-- constrangeri testate: data externarii trebuie sa fie ulterioara datei internarii.
UPDATE internari
SET data_externarii = TO_DATE('2024-12-15', 'YYYY-MM-DD')
WHERE id_internare = 2000;

-- verificam daca a avut loc actualizarea:
SELECT * FROM internari;


-- use-case: afisarea pacientilor internati intr-o sectie.
-- descriere: se vor afisa pacientii internati intr-o sectie anume care nu au fost externati.
SELECT DISTINCT p.nume, p.prenume, i.data_internarii, s.nume AS "Nume sectie"
FROM pacient p, internari i, sectie s
WHERE p.id_pacient = i.id_pacient
  AND i.id_sectie = s.id_sectie
  AND i.id_sectie = 4
  AND i.data_externarii IS NULL;
  
-- verificare date din internari
SELECT * FROM internari;


-- use-case: adaugarea unui medic nou.
-- constrangeri testate: specializarea trebuie sa fie valida, sectia trebuie sa existe iar id_doctor sa nu existe deja.
INSERT INTO doctor (id_doctor, nume, prenume, specializare, id_sectie)
VALUES (41, 'Ionescu', 'Maria', 'Cardiologie', 3);

--verificam inserarea
SELECT * FROM doctor;


-- use-case: afisarea istoricului internarilor unui pacient.
-- descriere: se vor afisa istoricul internarilor unui pacient specificat.
SELECT i.id_internare, s.nume AS sectie, i.data_internarii, i.data_externarii
FROM internari i, sectie s
WHERE i.id_sectie = s.id_sectie
  AND i.id_pacient = 136;
  

-- use-case: verificarea capacitatii unei sectii.
-- descriere: se verifica numarul de paturi disponibile intr-o sectie.
SELECT s.nume, ifs.nr_paturi - COUNT(i.id_internare) AS paturi_disponibile
    FROM info_sectie ifs, internari i, sectie s
    WHERE s.id_sectie = i.id_sectie
        AND i.data_externarii IS NULL
        AND ifs.id_sectie=s.id_sectie
        AND s.id_sectie = 4
    GROUP BY s.nume, ifs.nr_paturi;


-- verificam datele din info_sectie si sectie
SELECT * FROM info_sectie;
SELECT * FROM sectie;


-- use-case: vizualizarea istoricului repartizarilor unui pacient la un medic
-- constrangeri testate: pacientul trebuie sa aiba repartizari la medicul respectiv, iar tipul de consultatie trebuie sa fie valid (ambulatoriu sau internare)
-- Selecteaza istoricul repartizarilor pentru pacientul cu id 125, la medicul cu id 3
SELECT r.id_repartizare, p.nume AS nume_pacient, p.prenume AS prenume_pacient, m.nume AS nume_medic, m.prenume AS prenume_medic, r.tip_consult, r.id_pacient, r.id_doctor
    FROM repartizari r, pacient p, doctor m
    WHERE r.id_pacient = p.id_pacient
        AND r.id_doctor = m.id_doctor
        AND r.id_pacient = 134  -- id-ul pacientului (mai este si 136)
        AND r.id_doctor = 34     -- id-ul medicului (mai este si 36)
        AND r.tip_consult IN ('ambulatoriu', 'internare');



-- use-case: afisarea medicilor disponibili intr-o sectie.
-- descriere: se vor afisa medicii care sunt disponibili in sectia specificata, incluzand numarul de pacienti pe care i-au consultat.
SELECT d.nume, d.prenume, d.specializare, COUNT(r.id_repartizare) AS nr_pacienti
    FROM doctor d, repartizari r
    WHERE d.id_doctor = r.id_doctor(+)
        AND d.id_sectie = 4
    GROUP BY d.nume, d.prenume, d.specializare;






--------------------------------------------------------------------------------------------------

-- Use-case: Externarea unui pacient si stergerea ulterioars a acestuia din istoric

BEGIN
    -- Pas 1: setam data externarii
    UPDATE internari
    SET data_externarii = SYSDATE
    WHERE id_pacient = 130
      AND data_externarii IS NULL;

    -- Pas 2: stergem pacientul daca nu are repartizare cu tipul de consult internare si nici o alta internare activa
    DELETE FROM pacient
    WHERE id_pacient = 130
      AND NOT EXISTS (
          SELECT 1
          FROM repartizari
          WHERE id_pacient = 130
            AND tip_consult = 'internare')
      AND NOT EXISTS (
          SELECT 1
          FROM internari
          WHERE id_pacient = 130
            AND data_externarii IS NULL);

    -- confirmam tranzactia daca nu apar erori
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- anulam toate modificarile daca apare o eroare
        ROLLBACK;
        -- Optional: afisam un mesaj pentru debugging
        DBMS_OUTPUT.PUT_LINE('A aparut o eroare: ' || SQLERRM);
END;
/

SELECT * FROM pacient p, internari i
    WHERE p.id_pacient=i.id_pacient
    AND p.id_pacient=130;


-- Use-case: Gestionarea unei internari noi pentru un pacient
BEGIN
    DECLARE
        v_id_pacient NUMBER(3); -- declaram variabila pentru a retine id-ul pacientului

    BEGIN
        -- pas 1: cautam id-ul pacientului folosind cnp-ul acestuia
        -- presupunem ca cnp-ul este unic si identifica pacientul
        
        INSERT INTO pacient (nume, prenume, cnp, seria_ci, numar_ci, asigurat_cnas)
            VALUES('Markovich', 'Igor', '2991230123456', 'AB', 111222, 0)
            RETURNING id_pacient INTO v_id_pacient;

        -- pas 2: adaugam o noua repartizare pentru pacient
        -- asociem pacientul cu un medic specific pentru un tip de consult (internare)
        INSERT INTO repartizari (id_repartizare, tip_consult, id_pacient, id_doctor)
        VALUES (1028, 'internare', v_id_pacient, 33);

        -- pas 3: internam pacientul intr-o sectie specificata
        -- stabilim data internarii ca fiind data curenta
        INSERT INTO internari (id_internare, data_internarii, id_pacient, id_sectie)
        VALUES (2014, SYSDATE, v_id_pacient, 2);

        -- pas 4: daca toate operatiile au reusit, facem commit pentru a salva modificarile
        COMMIT;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- daca pacientul nu exista in baza de date, anulam tranzactia si afisam un mesaj
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('eroare: pacientul cu cnp-ul specificat nu exista');
        WHEN OTHERS THEN
            -- daca apare orice alta eroare, anulam tranzactia si aruncam eroarea
            ROLLBACK;
            RAISE;
    END;
END;
/

----------------------------------------------------------
SELECT * FROM pacient;
SELECT * FROM repartizari;
SELECT * FROM internari;

DELETE FROM pacient WHERE id_pacient =158;













