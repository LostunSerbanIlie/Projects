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



--------------------------------------------------------------------------------------------------

-- evidentierea legaturii intre repartizari, doctor si sectii folosind join
-- selecteaza date despre medici, repartizari si sectii, folosind join-uri intre tabelele doctor, repartizari si sectie, ordonand rezultatele dupa numele sectiei in ordine alfabetica
SELECT DISTINCT d.id_doctor, d.nume, d.prenume, d.specializare, d.id_sectie, r.tip_consult, s.nume AS Nume_Sectie
    FROM doctor d, repartizari r, sectie s
        WHERE d.id_doctor=r.id_doctor AND d.id_sectie=s.id_sectie
        ORDER BY s.nume ASC;
        
        
-- evidentierea legaturii intre pacient, repartizare si medic folosind join
-- selecteaza date despre pacienti, repartizari si medici, folosind join-uri intre tabelele pacient, repartizari si doctor
SELECT p.nume, p.prenume, p.cnp, p.asigurat_cnas, r.tip_consult, d.nume as Nume_Medic, d.prenume AS Prenume_Medic, d.specializare
    FROM pacient p, repartizari r, doctor d
        WHERE p.id_pacient=r.id_pacient AND r.id_doctor=d.id_doctor;
    
    
-- evidentierea legaturii intre pacient, internare si sectie folosind join
-- selecteaza date despre pacienti, internari si sectii, folosind join-uri intre tabelele pacient, internari si sectie
SELECT p.nume, p.prenume, p.cnp, i.id_internare, i.data_internarii, i.data_externarii, s.nume AS nume_sectie
    FROM pacient p, internari i, sectie s
        WHERE p.id_pacient=i.id_pacient AND i.id_sectie=s.id_sectie;
        
        
-- evidentierea legaturii intre doctor si sectie
-- selecteaza date despre medici si sectii, folosind join-uri intre tabelele doctor si sectie pentru a evidentia sectia asociata fiecarui medic
SELECT d.id_doctor, d.nume, d.prenume, d.specializare, s.id_sectie, s.nume AS nume_sectie
    FROM doctor d, sectie s
        WHERE d.id_sectie=s.id_sectie;
        
        
-- evidentierea legaturii intre sectie si id_sectie
-- selecteaza informatii despre sectii si detalii aditionale din tabelul info_sectie, folosind join-uri intre tabelele sectie si info_sectie
SELECT s.nume, ifs.id_sectie, ifs.etaj, ifs.nr_paturi, ifs.echipamente, ifs.nr_asistenti
    FROM sectie s, info_sectie ifs
    WHERE s.id_info=ifs.id_info;
    
    
---------------------------------------------------------------------------------------------------------
-- testarea erorilor legate de constrangeri pentru inserari

-- testam constrangerea de tip PK: incercam sa inseram un id_repartizare duplicat in tabelul repartizari
INSERT INTO sectie (id_sectie, nume, id_info)
    VALUES (2, 'Nefrologie', 123);

-- mesaj de eroare: ORA-00001: unique constraint (BD027.SECTII_PK) violated

-- testam constrangerea de tip PK: incercam sa inseram un id_pacient duplicat in tabelul pacient
INSERT INTO pacient (id_pacient, nume, prenume, cnp, seria_ci, numar_ci, asigurat_cnas)
    VALUES (125, 'Ionescu', 'Vlad', 2223334445556, 'MN', 123450, 1);

-- mesaj de eroare: ORA-00001: unique constraint (BD027.PACIENT_PK) violated

-- testam constrangerea de tip PK: incercam sa inseram un id_doctor duplicat in tabelul doctor
INSERT INTO doctor (id_doctor, nume, prenume, specializare, id_sectie)
    VALUES (27, 'Popescu', 'Ion', 'Chirurgie', 2);

-- mesaj de eroare: ORA-00001: unique constraint (BD027.DOCTOR_PK) violated

-- testam constrangerea de tip PK: incercam sa inseram un id_internare duplicat in tabelul internari
INSERT INTO internari (id_internare, data_internarii, data_externarii, id_pacient, id_sectie)
    VALUES (2012, TO_DATE('2024-12-01', 'YYYY-MM-DD'), NULL, 125, 3);

-- mesaj de eroare: ORA-00001: unique constraint (BD027.INTERNARI_PK) violated

-- testam constrangerea de tip PK: incercam sa inseram un id_info duplicat in tabelul info_sectie
INSERT INTO info_sectie (id_info, id_sectie, etaj, nr_paturi, echipamente, nr_asistenti)
    VALUES (145, 3, 1, 20, 'EKG', 5);

-- mesaj de eroare: ORA-00001: unique constraint (BD027.INFO_SECTIE_PK) violated


-- testam constrangerea de tip PK: incercam sa inseram un id_repartizare duplicat in tabelul repartizari
INSERT INTO repartizari (id_repartizare, tip_consult, id_pacient, id_doctor)
    VALUES (1010, 'internare', 125, 1);

-- mesaj de eroare: ORA-00001: unique constraint (BD027.REPARTIZARI_PK) violated



-------------------------------------------------------------------------------------------------------------------------

-- testam constrangerea de tip CK: incercam sa inseram un tip_consult invalid in tabelul repartizari
INSERT INTO repartizari (id_repartizare, tip_consult, id_pacient, id_doctor)
    VALUES (1007, 'consultatie', 127, 27);

--Mesaj de eroare> ORA-02290: check constraint (BD027.REPARTIZARI_TIP_CONSULT_CK) violated

-- testam constrangerea de tip CK: incercam sa inseram o internare cu data externarii inaintea datei internarii
INSERT INTO internari (id_internare, data_internarii, data_externarii, id_pacient, id_sectie)
    VALUES (2002, TO_DATE('2024-12-10', 'YYYY-MM-DD'), TO_DATE('2024-12-01', 'YYYY-MM-DD'), 125, 3);

-- mesaj de eroare: ORA-02290: check constraint (BD027.INTERNARI_DATA_EXTERNARII_CK) violated


-- testam constrangerea de tip CHECK: incercam sa inseram o valoare invalida pentru asigurat_cnas
INSERT INTO pacient (id_pacient, nume, prenume, cnp, seria_ci, numar_ci, asigurat_cnas)
    VALUES (130, 'Georgescu', 'Ion', 1234567890123, 'AB', 123456, 3);

-- mesaj de eroare: ORA-02290: check constraint (BD027.PACIENT_ASIGURAT_CK) violated


-------------------------------------------------------------------------------------------------------------------------
-- testam constrangerea de tip NN: incercam sa inseram o valoare nula pentru tip_consult in tabelul repartizari
INSERT INTO info_sectie (id_info, id_sectie, etaj, nr_paturi, echipamente, nr_asistenti) 
    VALUES (159, 8, NULL, 35, 'EKG', 20);

-- mesaj de eroare: ORA-01400: cannot insert NULL into ("BD027"."INFO_SECTIE"."ETAJ")

-- testam constrangerea de tip NN: incercam sa inseram un doctor fara prenume
INSERT INTO doctor (id_doctor, nume, prenume, specializare, id_sectie)
    VALUES (10, 'Mihaila', NULL, 'Neurologie', 5);

-- mesaj de eroare: ORA-01400: cannot insert NULL into ("BD027"."DOCTOR"."PRENUME")

-- testam constrangerea NN: inseram un pacient fara nume
INSERT INTO pacient (id_pacient, prenume, cnp, seria_ci, numar_ci, asigurat_cnas)
    VALUES (137, 'Marin', 4567890123456, 'XV', 789012, 1);

-- Mesaj de eroare: ORA-01400: cannot insert NULL into ("BD027"."PACIENT"."NUME")


-- testam constrangerea NN: inseram o sectie fara nume
INSERT INTO sectie (id_sectie, id_info)
    VALUES (7, 123);

-- Mesaj de eroare: ORA-01400: cannot insert NULL into ("BD027"."SECTIE"."NUME")


-------------------------------------------------------------------------------------------------------------------------
-- testam constrangerea de tip FK: incercam sa inseram o valoare pentru id_doctor care nu exista in tabela doctor
INSERT INTO repartizari (id_repartizare, tip_consult, id_pacient, id_doctor)
    VALUES (1108, 'ambulatoriu', 128, 99);

-- mesaj de eroare: ORA-02291: integrity constraint (BD027.DOCTOR_REPARTIZARI_FK) violated - parent key not found

-- testam constrangerea de tip FK: incercam sa inseram un id_pacient inexistent in tabelul repartizari
INSERT INTO repartizari (id_repartizare, tip_consult, id_pacient, id_doctor)
    VALUES (1109, 'internare', 999, 10);

-- mesaj de eroare: ORA-02291: integrity constraint (BD027.PACIENT_REPARTIZARI_FK) violated - parent key not found


-- testam constrangerea de tip FK: incercam sa inseram un id_pacient inexistent in tabelul internari
INSERT INTO internari (id_internare, data_internarii, data_externarii, id_pacient, id_sectie)
    VALUES (2091, TO_DATE('2024-12-10', 'YYYY-MM-DD'), NULL, 999, 3);

-- mesaj de eroare: ORA-02291: integrity constraint (BD027.PACIENT_INTERNARI_FK) violated - parent key not found

-- testam constrangerea de tip FK: incercam sa inseram un id_info inexistent in tabelul sectie
INSERT INTO sectie (id_sectie, nume, id_info)
    VALUES (10, 'ORL', 999);

-- mesaj de eroare: ORA-02291: integrity constraint (BD027.INFO_SECTIE_SECTIE_FK) violated - parent key not found

-------------------------------------------------------------------------------------------------------------------------


-- testam constrangerea de tip UK: incercam sa inseram un pacient cu acelasi cnp in tabelul pacient
INSERT INTO pacient (nume, prenume, cnp, seria_ci, numar_ci, asigurat_cnas)
    VALUES ('Popescu', 'Ana', 1234567890123, 'BT', 789012, 1);

-- mesaj de eroare: ORA-00001: unique constraint (BD027.PACIENT_CNP_UK) violated

-- testam constrangerea de tip UK: incercam sa inseram o sectie cu acelasi nume
INSERT INTO sectie (id_sectie, nume, id_info)
    VALUES (8, 'Cardiologie', 145);

-- mesaj de eroare: ORA-00001: unique constraint (BD027.SECTIE__IDX) violated

-- testam constrangerea de tip UK: incercam sa inseram un pacient cu aceeasi serie CI si acelasi numar CI
INSERT INTO pacient (id_pacient, nume, prenume, cnp, seria_ci, numar_ci, asigurat_cnas)
    VALUES (190, 'Popa', 'Mihai', 2345678901234, 'SV', 123460, 1);

-- mesaj de eroare: ORA-00001: unique constraint (BD027.PACIENT_NUMAR_CI_UK) violated


-------------------------------------------------------------------------------------------------------------------------


-- testarea erorilor legate de constrangeri pentru stergere
-- incercam sa stergem un doctor care are repartizari
DELETE FROM doctor
    WHERE id_doctor = 27;

-- mesaj de eroare: ORA-02292: integrity constraint (BD027.DOCTOR_REPARTIZARI_FK) violated - child record found

-- incercam sa stergem o sectie care are un info_sectie asociat
DELETE FROM sectie
    WHERE id_sectie = 2;

-- mesaj de eroare: ORA-02292: integrity constraint (BD027.SECTII_DOCTOR_FK) violated - child record found

-- incercam sa stergem un pacient care are repartizari
DELETE FROM pacient
    WHERE id_pacient = 125;

-- mesaj de eroare: ORA-02292: integrity constraint (BD027.PACIENT_INTERNARI_FK) violated - child record found


-------------------------------------------------------------------------------------------------------------------------
-- testarea erorilor legate de constrangeri pentru update

-- incercam sa modificam id-ul unui pacient (primary key)
UPDATE pacient
    SET id_pacient = 126
    WHERE id_pacient = 125;

-- mesaj de eroare: ORA-00001: unique constraint (BD027.PACIENT_PK) violated


-- incercam sa modificam id_doctor pentru o repartizare cu un doctor inexistent
UPDATE repartizari
    SET id_doctor = 100
    WHERE id_repartizare = 1005;

-- mesaj de eroare: ORA-02291: integrity constraint (BD027.DOCTOR_REPARTIZARI_FK) violated - parent key not found

-- incercam sa modificam valoarea asigurat_cnas pentru un pacient in afara intervalului permis
UPDATE pacient
    SET asigurat_cnas = 2
    WHERE id_pacient = 125;

-- mesaj de eroare: ORA-02290: check constraint (BD027.PACIENT_ASIGURAT_CNAS_CK) violated

-- incercam sa modificam seria si numarul CI a unui pacient pentru a le face identice cu seria si numarul unui alt pacient
UPDATE pacient
    SET seria_ci = 'AB', numar_ci=654321 
        WHERE id_pacient = 130;

-- mesaj de eroare: ORA-00001: unique constraint (BD027.PACIENT_NUMAR_CI_UK) violated


-- incercam sa modificam prenumele unui doctor pentru a-l face NULL
UPDATE doctor
    SET prenume = NULL
    WHERE id_doctor = 27;

-- mesaj de eroare: ORA-01407: cannot update ("BD027"."DOCTOR"."PRENUME") to NULL

