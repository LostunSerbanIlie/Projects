-- vizualizam tabelele existente
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



-- la inceput inserez date pentru tabela cu FK catre sectie (child), info_sectie in cazul acesta (parent)
INSERT INTO info_sectie (id_info, id_sectie, etaj, nr_paturi, echipamente, nr_asistenti) 
    VALUES (145, 1, 2, 30, 'EKG', 10);

INSERT INTO info_sectie (id_info, id_sectie, etaj, nr_paturi, echipamente, nr_asistenti) 
    VALUES (125, 2, 3, 40, 'Ecografe, Ventilatoare', 15);

INSERT INTO info_sectie (id_info, id_sectie, etaj, nr_paturi, echipamente, nr_asistenti) 
    VALUES (114, 3, 1, 25, 'Lupa chirurgicala, Monitoare', 5);

INSERT INTO info_sectie (id_info, id_sectie, etaj, nr_paturi, echipamente, nr_asistenti) 
    VALUES (94, 4, 4, 35, 'RMN, EEG', 8);

INSERT INTO info_sectie (id_info, id_sectie, etaj, nr_paturi, echipamente, nr_asistenti) 
    VALUES (65, 5, 5, 50, 'CT Scan, Radioterapie', 20);
    
-- verificam valorile generate pentru info_sectie
SELECT * FROM info_sectie;



--------------------------------------------------------------------------------------------------

-- inserez 5 sectii, nu specific id_sectie pentru ca are auto-increment incepand cu 1
INSERT INTO sectie (nume, id_info) VALUES ('Cardiologie',
    (SELECT id_info 
        FROM info_sectie WHERE etaj = 2 AND nr_paturi = 30));
    
INSERT INTO sectie (nume, id_info) VALUES ('Pediatrie', 
    (SELECT id_info 
        FROM info_sectie WHERE etaj = 3 AND nr_paturi = 40));
    
INSERT INTO sectie (nume, id_info) VALUES ('Chirurgie',
    (SELECT id_info 
        FROM info_sectie WHERE etaj = 1 AND nr_paturi = 25));
    
INSERT INTO sectie (nume, id_info) VALUES ('Neurologie',
    (SELECT id_info 
        FROM info_sectie WHERE etaj = 4 AND nr_paturi = 35));
    
INSERT INTO sectie (nume, id_info) VALUES ('Oncologie',
    (SELECT id_info 
        FROM info_sectie WHERE etaj = 5 AND nr_paturi = 50));
        
-- verificam valorile generate pentru sectie
SELECT * FROM sectie;




--------------------------------------------------------------------------------------------------

-- inseram doctori, auto-increment incepand cu 25
INSERT INTO doctor (nume, prenume, specializare, id_sectie) VALUES ('Popescu', 'Ion', 'Cardiologie',
    (SELECT id_sectie 
        FROM sectie WHERE nume = 'Cardiologie' AND id_info = 
    (SELECT id_info 
        FROM info_sectie WHERE etaj = 2 AND nr_paturi = 30)));
        
INSERT INTO doctor (nume, prenume, specializare, id_sectie) VALUES ('Ionescu', 'Maria', 'Pediatrie',
    (SELECT id_sectie 
        FROM sectie WHERE nume = 'Pediatrie' AND id_info = 
    (SELECT id_info 
        FROM info_sectie WHERE etaj = 3 AND nr_paturi = 40)));
        
INSERT INTO doctor (nume, prenume, specializare, id_sectie) VALUES ('Georgescu', 'Andrei', 'Chirurgie',
    (SELECT id_sectie 
        FROM sectie WHERE nume = 'Chirurgie' AND id_info = 
    (SELECT id_info 
        FROM info_sectie WHERE etaj = 1 AND nr_paturi = 25)));
        
INSERT INTO doctor (nume, prenume, specializare, id_sectie) VALUES ('Vasile', 'Laura', 'Neurologie',
    (SELECT id_sectie 
        FROM sectie WHERE nume = 'Neurologie' AND id_info = 
    (SELECT id_info 
        FROM info_sectie WHERE etaj = 4 AND nr_paturi = 35)));

INSERT INTO doctor (nume, prenume, specializare, id_sectie) VALUES ('Mihaila', 'Ion', 'Oncologie',
    (SELECT id_sectie 
        FROM sectie WHERE nume = 'Oncologie' AND id_info = 
    (SELECT id_info 
        FROM info_sectie WHERE etaj = 5 AND nr_paturi = 50)));
        
        
-- inseram mai multi doctori in aceeasi sectie pentru a evidentia relatia one-to-many intre sectie si doctor
-- Doctori pentru Cardiologie
INSERT INTO doctor (nume, prenume, specializare, id_sectie) VALUES ('Gheorghiu', 'Raluca', 'Cardiologie', 
    (SELECT id_sectie 
        FROM sectie 
        WHERE nume = 'Cardiologie' AND id_info = 
    (SELECT id_info 
        FROM info_sectie 
        WHERE etaj = 2 AND nr_paturi = 30)));


-- Doctori pentru Pediatrie
INSERT INTO doctor (nume, prenume, specializare, id_sectie) VALUES ('Brânză', 'Maria', 'Pediatrie',
    (SELECT id_sectie 
        FROM sectie WHERE nume = 'Pediatrie' AND id_info = 
    (SELECT id_info 
        FROM info_sectie WHERE etaj = 3 AND nr_paturi = 40)));


-- Doctori pentru Chirurgie
INSERT INTO doctor (nume, prenume, specializare, id_sectie) VALUES ('Burnei', 'Gheorghe', 'Chirurgie',
    (SELECT id_sectie 
        FROM sectie WHERE nume = 'Chirurgie' AND id_info = 
    (SELECT id_info 
        FROM info_sectie WHERE etaj = 1 AND nr_paturi = 25)));


 -- Doctori pentru Neurologie       
INSERT INTO doctor (nume, prenume, specializare, id_sectie)  VALUES ('Dănăilă', 'Leon', 'Neurologie',
    (SELECT id_sectie 
        FROM sectie WHERE nume = 'Neurologie' AND id_info = 
    (SELECT id_info 
        FROM info_sectie WHERE etaj = 4 AND nr_paturi = 35)));

INSERT INTO doctor (nume, prenume, specializare, id_sectie) VALUES ('Ciurea', 'Constantin', 'Neurologie',
    (SELECT id_sectie 
        FROM sectie WHERE nume = 'Neurologie' AND id_info = 
    (SELECT id_info 
        FROM info_sectie WHERE etaj = 4 AND nr_paturi = 35)));
        
        
-- Doctori pentru Oncologie
INSERT INTO doctor (nume, prenume, specializare, id_sectie) VALUES ('Popa', 'Alexandru', 'Oncologie',
    (SELECT id_sectie 
        FROM sectie WHERE nume = 'Oncologie' AND id_info = 
    (SELECT id_info 
        FROM info_sectie WHERE etaj = 5 AND nr_paturi = 50)));

INSERT INTO doctor (nume, prenume, specializare, id_sectie) VALUES ('Constantinescu', 'Irina', 'Oncologie',
    (SELECT id_sectie 
        FROM sectie WHERE nume = 'Oncologie' AND id_info = 
    (SELECT id_info 
        FROM info_sectie WHERE etaj = 5 AND nr_paturi = 50)));
    
        

-- verificam valorile generate pentru doctori
SELECT * FROM doctor;




--------------------------------------------------------------------------------------------------

-- inserez 25 de pacienti, auto-increment incepand cu 125
INSERT INTO pacient (nume, prenume, cnp, seria_ci, numar_ci, asigurat_cnas) VALUES ('Constantinescu', 'Elena', 1234567890123, 'IF', 123456, 1);
INSERT INTO pacient (nume, prenume, cnp, seria_ci, numar_ci, asigurat_cnas) VALUES ('Mihaila', 'Andrei', 9876543210987, 'AB', 654321, 0);
INSERT INTO pacient (nume, prenume, cnp, seria_ci, numar_ci, asigurat_cnas) VALUES ('Popa', 'Ion', 1112233445566, 'BR', 123457, 1);
INSERT INTO pacient (nume, prenume, cnp, seria_ci, numar_ci, asigurat_cnas) VALUES ('Dobre', 'Maria', 5556667778889, 'CS', 654322, 1);
INSERT INTO pacient (nume, prenume, cnp, seria_ci, numar_ci, asigurat_cnas) VALUES ('Ionescu', 'Ion', 2233445566778, 'IF', 987654, 0);

INSERT INTO pacient (nume, prenume, cnp, seria_ci, numar_ci, asigurat_cnas) VALUES ('Neagu', 'Adrian', 3344556677889, 'GR', 234567, 1);
INSERT INTO pacient (nume, prenume, cnp, seria_ci, numar_ci, asigurat_cnas) VALUES ('Stoian', 'Carmen', 6677889900112, 'BR', 765432, 0);
INSERT INTO pacient (nume, prenume, cnp, seria_ci, numar_ci, asigurat_cnas) VALUES ('Nistor', 'Florin', 4455667788990, 'VS', 345678, 1);
INSERT INTO pacient (nume, prenume, cnp, seria_ci, numar_ci, asigurat_cnas) VALUES ('Popovici', 'Irina', 5566778899001, 'AG', 123458, 1);
INSERT INTO pacient (nume, prenume, cnp, seria_ci, numar_ci, asigurat_cnas) VALUES ('Dumitru', 'Sebastian', 6677889900113, 'CS', 234569, 0);

INSERT INTO pacient (nume, prenume, cnp, seria_ci, numar_ci, asigurat_cnas) VALUES ('Păun', 'Vasile', 3344556677887, 'SV', 123460, 1);
INSERT INTO pacient (nume, prenume, cnp, seria_ci, numar_ci, asigurat_cnas) VALUES ('Radu', 'Alexandru', 6677889900111, 'MS', 987655, 1);
INSERT INTO pacient (nume, prenume, cnp, seria_ci, numar_ci, asigurat_cnas) VALUES ('Ilie', 'Elena', 7788990011223, 'TR', 234570, 0);
INSERT INTO pacient (nume, prenume, cnp, seria_ci, numar_ci, asigurat_cnas) VALUES ('Marin', 'Gabriel', 8899001122334, 'B', 345679, 1);
INSERT INTO pacient (nume, prenume, cnp, seria_ci, numar_ci, asigurat_cnas) VALUES ('Bălan', 'Ioana', 9900112233445, 'B', 456780, 0);

INSERT INTO pacient (nume, prenume, cnp, seria_ci, numar_ci, asigurat_cnas) VALUES ('Vasilescu', 'Andrei', 1122334455667, 'DB', 678901, 1);
INSERT INTO pacient (nume, prenume, cnp, seria_ci, numar_ci, asigurat_cnas) VALUES ('Lupu', 'Ion', 2253445566778, 'BR', 789012, 0);
INSERT INTO pacient (nume, prenume, cnp, seria_ci, numar_ci, asigurat_cnas) VALUES ('Georgescu', 'Maria', 2344556677889, 'SM', 890123, 1);
INSERT INTO pacient (nume, prenume, cnp, seria_ci, numar_ci, asigurat_cnas) VALUES ('Rusu', 'Alexandru', 4457667788990, 'CS', 901234, 0);
INSERT INTO pacient (nume, prenume, cnp, seria_ci, numar_ci, asigurat_cnas) VALUES ('Cristea', 'Ionela', 5562778899001, 'IS', 123957, 1);

INSERT INTO pacient (nume, prenume, cnp, seria_ci, numar_ci, asigurat_cnas) VALUES ('Popescu', 'Florin', 6679889900112, 'IS', 234568, 1);
INSERT INTO pacient (nume, prenume, cnp, seria_ci, numar_ci, asigurat_cnas) VALUES ('Tudor', 'Mihai', 7788992011223, 'CT', 245679, 0);
INSERT INTO pacient (nume, prenume, cnp, seria_ci, numar_ci, asigurat_cnas) VALUES ('Kinga', 'Maria', 8819001122334, 'IS', 756780, 1);
INSERT INTO pacient (nume, prenume, cnp, seria_ci, numar_ci, asigurat_cnas) VALUES ('Stanescu', 'Vasile', 9900113233445, 'SV', 567891, 0);
INSERT INTO pacient (nume, prenume, cnp, seria_ci, numar_ci, asigurat_cnas) VALUES ('Balan', 'Gabriela', 1239879543210, 'SV', 678902, 1);

-- verificam valorile generate pentru pacienți
SELECT * FROM pacient;



--------------------------------------------------------------------------------------------------

-- inserez 25 de repartizari

-- Repartizare 1000 - Pacientul Constantinescu Elena la doctor Popescu Ion 
INSERT INTO repartizari (id_repartizare, tip_consult, id_pacient, id_doctor)
    VALUES (1000, 'internare',
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 1234567890123),
        (SELECT id_doctor 
            FROM doctor WHERE nume = 'Popescu' AND prenume = 'Ion'));

-- Repartizare 1001 - Pacientul Mihaila Andrei la doctor Ionescu Maria 
INSERT INTO repartizari (id_repartizare, tip_consult, id_pacient, id_doctor)
    VALUES (1001, 'internare',
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 9876543210987),
        (SELECT id_doctor 
            FROM doctor WHERE nume = 'Ionescu' AND prenume = 'Maria'));

-- Repartizare 1002 - Pacientul Popa Ion la doctor Georgescu Andrei 
INSERT INTO repartizari (id_repartizare, tip_consult, id_pacient, id_doctor)
    VALUES (1002, 'ambulatoriu',
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 1112233445566),
        (SELECT id_doctor 
            FROM doctor WHERE nume = 'Georgescu' AND prenume = 'Andrei'));

-- Repartizare 1003 - Pacientul Dobre Maria la doctor Vasile Laura 
INSERT INTO repartizari (id_repartizare, tip_consult, id_pacient, id_doctor)
    VALUES (1003, 'ambulatoriu',
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 5556667778889),
        (SELECT id_doctor 
            FROM doctor WHERE nume = 'Vasile' AND prenume = 'Laura'));

-- Repartizare 1004 - Pacientul Ionescu Ion la doctor Mihaila Ion 
INSERT INTO repartizari (id_repartizare, tip_consult, id_pacient, id_doctor)
    VALUES (1004, 'ambulatoriu',
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 2233445566778),
        (SELECT id_doctor 
            FROM doctor WHERE nume = 'Mihaila' AND prenume = 'Ion'));

-- Repartizare 1005 - Pacientul Neagu Adrian la doctor Gheorghiu Raluca 
INSERT INTO repartizari (id_repartizare, tip_consult, id_pacient, id_doctor)
    VALUES (1005, 'internare',
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 3344556677889),
        (SELECT id_doctor 
            FROM doctor WHERE nume = 'Gheorghiu' AND prenume = 'Raluca'));

-- Repartizare 1006 - Pacientul Stoian Carmen la doctor Brânză Maria 
INSERT INTO repartizari (id_repartizare, tip_consult, id_pacient, id_doctor)
    VALUES (1006, 'ambulatoriu',
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 6677889900112),
        (SELECT id_doctor 
            FROM doctor WHERE nume = 'Brânză' AND prenume = 'Maria'));

-- Repartizare 1007 - Pacientul Nistor Florin la doctor Burnei Gheorghe 
INSERT INTO repartizari (id_repartizare, tip_consult, id_pacient, id_doctor)
    VALUES (1007, 'internare',
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 4455667788990),
        (SELECT id_doctor 
            FROM doctor WHERE nume = 'Burnei' AND prenume = 'Gheorghe'));

-- Repartizare 1008 - Pacientul Popovici Irina la doctor Dănăilă Leon 
INSERT INTO repartizari (id_repartizare, tip_consult, id_pacient, id_doctor)
    VALUES (1008, 'ambulatoriu',
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 5566778899001),
        (SELECT id_doctor 
            FROM doctor WHERE nume = 'Dănăilă' AND prenume = 'Leon'));

-- Repartizare 1009 - Pacientul Dumitru Sebastian la doctor Ciurea Constantin 
INSERT INTO repartizari (id_repartizare, tip_consult, id_pacient, id_doctor)
    VALUES (1009, 'internare',
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 6677889900113),
        (SELECT id_doctor 
            FROM doctor WHERE nume = 'Ciurea' AND prenume = 'Constantin'));

-- Repartizare 1010 - Pacientul Păun Vasile la doctor Popa Alexandru 
INSERT INTO repartizari (id_repartizare, tip_consult, id_pacient, id_doctor)
    VALUES (1010, 'ambulatoriu',
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 3344556677887),
        (SELECT id_doctor 
            FROM doctor WHERE nume = 'Popa' AND prenume = 'Alexandru'));

-- Repartizare 1011 - Pacientul Radu Alexandru la doctor Constantinescu Irina 
INSERT INTO repartizari (id_repartizare, tip_consult, id_pacient, id_doctor)
    VALUES (1011, 'internare',
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 6677889900111),
        (SELECT id_doctor 
            FROM doctor WHERE nume = 'Constantinescu' AND prenume = 'Irina'));

-- Repartizare 1012 - Pacientul Ilie Elena la doctor Burnei Gheorghe 
INSERT INTO repartizari (id_repartizare, tip_consult, id_pacient, id_doctor)
    VALUES (1012, 'ambulatoriu',
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 7788990011223),
        (SELECT id_doctor 
            FROM doctor WHERE nume = 'Burnei' AND prenume = 'Gheorghe'));

-- Repartizare 1013 - Pacientul Marin Gabriel la doctor Popescu Ion 
INSERT INTO repartizari (id_repartizare, tip_consult, id_pacient, id_doctor)
    VALUES (1013, 'ambulatoriu',
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 8899001122334),
        (SELECT id_doctor 
            FROM doctor WHERE nume = 'Popescu' AND prenume = 'Ion'));

-- Repartizare 1014 - Pacientul Bălan Ioana la doctor Ionescu Maria 
INSERT INTO repartizari (id_repartizare, tip_consult, id_pacient, id_doctor)
    VALUES (1014, 'internare',
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 9900112233445),
        (SELECT id_doctor 
            FROM doctor WHERE nume = 'Ionescu' AND prenume = 'Maria'));

-- Repartizare 1015 - Pacientul Vasilescu Andrei la doctor Georgescu Andrei 
INSERT INTO repartizari (id_repartizare, tip_consult, id_pacient, id_doctor)
    VALUES (1015, 'ambulatoriu',
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 1122334455667),
        (SELECT id_doctor 
            FROM doctor WHERE nume = 'Georgescu' AND prenume = 'Andrei'));

-- Repartizare 1016 - Pacientul Lupu Ion la doctor Vasile Laura 
INSERT INTO repartizari (id_repartizare, tip_consult, id_pacient, id_doctor)
    VALUES (1016, 'internare',
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 2253445566778),
        (SELECT id_doctor 
            FROM doctor WHERE nume = 'Vasile' AND prenume = 'Laura'));

-- Repartizare 1017 - Pacientul Georgescu Maria la doctor Mihaila Ion 
INSERT INTO repartizari (id_repartizare, tip_consult, id_pacient, id_doctor)
    VALUES (1017, 'ambulatoriu',
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 2344556677889),
        (SELECT id_doctor 
            FROM doctor WHERE nume = 'Mihaila' AND prenume = 'Ion'));

-- Repartizare 1018 - Pacientul Rusu Alexandru la doctor Gheorghiu Raluca 
INSERT INTO repartizari (id_repartizare, tip_consult, id_pacient, id_doctor)
    VALUES (1018, 'internare',
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 4457667788990),
        (SELECT id_doctor 
            FROM doctor WHERE nume = 'Gheorghiu' AND prenume = 'Raluca'));

-- Repartizare 1019 - Pacientul Cristea Ionela la doctor Brânză Maria 
INSERT INTO repartizari (id_repartizare, tip_consult, id_pacient, id_doctor)
    VALUES (1019, 'ambulatoriu',
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 5562778899001),
        (SELECT id_doctor 
            FROM doctor WHERE nume = 'Brânză' AND prenume = 'Maria'));

-- Repartizare 1020 - Pacientul Popescu Florin la doctor Burnei Gheorghe 
INSERT INTO repartizari (id_repartizare, tip_consult, id_pacient, id_doctor)
    VALUES (1020, 'internare',
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 6679889900112),
        (SELECT id_doctor 
            FROM doctor WHERE nume = 'Burnei' AND prenume = 'Gheorghe'));

-- Repartizare 1021 - Pacientul Tudor Mihai la doctor Dănăilă Leon 
INSERT INTO repartizari (id_repartizare, tip_consult, id_pacient, id_doctor)
    VALUES (1021, 'ambulatoriu',
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 7788992011223),
        (SELECT id_doctor 
            FROM doctor WHERE nume = 'Dănăilă' AND prenume = 'Leon'));

-- Repartizare 1022 - Pacientul Kinga Maria la doctor Ciurea Constantin 
INSERT INTO repartizari (id_repartizare, tip_consult, id_pacient, id_doctor)
    VALUES (1022, 'internare',
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 8819001122334),
        (SELECT id_doctor 
            FROM doctor WHERE nume = 'Ciurea' AND prenume = 'Constantin'));

-- Repartizare 1023 - Pacientul Stanescu Vasile la doctor Popa Alexandru 
INSERT INTO repartizari (id_repartizare, tip_consult, id_pacient, id_doctor)
    VALUES (1023, 'ambulatoriu',
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 9900113233445),
        (SELECT id_doctor 
            FROM doctor WHERE nume = 'Popa' AND prenume = 'Alexandru'));

-- Repartizare 1024 - Pacientul Balan Gabriela la doctor Constantinescu Irina 
INSERT INTO repartizari (id_repartizare, tip_consult, id_pacient, id_doctor)
    VALUES (1024, 'internare',
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 1239879543210),
        (SELECT id_doctor 
            FROM doctor WHERE nume = 'Constantinescu' AND prenume = 'Irina'));

-- Repartizare 1025 - Pacientul Rusu Alexandru la doctor Gheorghiu Raluca 
INSERT INTO repartizari (id_repartizare, tip_consult, id_pacient, id_doctor)
    VALUES (1025, 'internare',
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 4457667788990),
        (SELECT id_doctor 
            FROM doctor WHERE nume = 'Gheorghiu' AND prenume = 'Raluca'));
            
-- Repartizare 1026 - Pacientul Dumitru Sebastian la doctor Ciurea Constantin 
INSERT INTO repartizari (id_repartizare, tip_consult, id_pacient, id_doctor)
    VALUES (1026, 'internare',
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 6677889900113),
        (SELECT id_doctor 
            FROM doctor WHERE nume = 'Ciurea' AND prenume = 'Constantin'));
            
-- Repartizare 1027 - Pacientul Radu Alexandru la doctor Constantinescu Irina 
INSERT INTO repartizari (id_repartizare, tip_consult, id_pacient, id_doctor)
    VALUES (1027, 'internare',
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 6677889900111),
        (SELECT id_doctor 
            FROM doctor WHERE nume = 'Constantinescu' AND prenume = 'Irina'));


-- Verificăm valorile inserate în tabelul internari
SELECT * FROM repartizari;




--------------------------------------------------------------------------------------------------

-- inserez internari
-- Internare 2000 - Pacientul Constantinescu Elena
INSERT INTO internari (id_internare, data_internarii, data_externarii, id_pacient, id_sectie)
    VALUES (2000, TO_DATE('2024-12-01', 'YYYY-MM-DD'), NULL,
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 1234567890123),
        (SELECT id_sectie 
            FROM sectie WHERE nume = 'Pediatrie'));

-- Internare 2001 - Pacientul Mihaila Andrei
INSERT INTO internari (id_internare, data_internarii, data_externarii, id_pacient, id_sectie)
    VALUES (2001, TO_DATE('2024-12-03', 'YYYY-MM-DD'), TO_DATE('2024-12-10', 'YYYY-MM-DD'),
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 9876543210987),
        (SELECT id_sectie 
            FROM sectie WHERE nume = 'Chirurgie'));

-- Internare 2002 - Pacientul Neagu Adrian
INSERT INTO internari (id_internare, data_internarii, data_externarii, id_pacient, id_sectie)
    VALUES (2002, TO_DATE('2024-12-05', 'YYYY-MM-DD'), NULL,
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 3344556677889),
        (SELECT id_sectie 
            FROM sectie WHERE nume = 'Neurologie'));

-- Internare 2003 - Pacientul Nistor Florin
INSERT INTO internari (id_internare, data_internarii, data_externarii, id_pacient, id_sectie)
    VALUES (2003, TO_DATE('2024-12-07', 'YYYY-MM-DD'), TO_DATE('2024-12-15', 'YYYY-MM-DD'),
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 4455667788990),
        (SELECT id_sectie 
            FROM sectie WHERE nume = 'Pediatrie'));

-- Internare 2004 - Pacientul Dumitru Sebastian
INSERT INTO internari (id_internare, data_internarii, data_externarii, id_pacient, id_sectie)
    VALUES (2004, TO_DATE('2024-12-08', 'YYYY-MM-DD'), TO_DATE('2024-12-11', 'YYYY-MM-DD'),
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 6677889900113),
        (SELECT id_sectie 
            FROM sectie WHERE nume = 'Cardiologie'));

-- Internare 2005 - Pacientul Radu Alexandru
INSERT INTO internari (id_internare, data_internarii, data_externarii, id_pacient, id_sectie)
    VALUES (2005, TO_DATE('2024-12-08', 'YYYY-MM-DD'), TO_DATE('2024-12-15', 'YYYY-MM-DD'),
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 6677889900111),
        (SELECT id_sectie 
            FROM sectie WHERE nume = 'Neurologie'));

-- Internare 2006 - Pacientul Lupu Ion
INSERT INTO internari (id_internare, data_internarii, data_externarii, id_pacient, id_sectie)
    VALUES (2006, TO_DATE('2024-12-13', 'YYYY-MM-DD'), TO_DATE('2024-12-20', 'YYYY-MM-DD'),
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 2253445566778),
        (SELECT id_sectie 
            FROM sectie WHERE nume = 'Chirurgie'));

-- Internare 2007 - Pacientul Rusu Alexandru
INSERT INTO internari (id_internare, data_internarii, data_externarii, id_pacient, id_sectie)
    VALUES (2007, TO_DATE('2024-12-15', 'YYYY-MM-DD'), NULL,
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 4457667788990),
        (SELECT id_sectie 
            FROM sectie WHERE nume = 'Neurologie'));

-- Internare 2008 - Pacientul Kinga Maria
INSERT INTO internari (id_internare, data_internarii, data_externarii, id_pacient, id_sectie)
    VALUES (2008, TO_DATE('2024-12-17', 'YYYY-MM-DD'), TO_DATE('2024-12-25', 'YYYY-MM-DD'),
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 8819001122334),
        (SELECT id_sectie 
            FROM sectie WHERE nume = 'Cardiologie'));

-- Internare 2009 - Pacientul Bălan Ioana
INSERT INTO internari (id_internare, data_internarii, data_externarii, id_pacient, id_sectie)
    VALUES (2009, TO_DATE('2024-12-19', 'YYYY-MM-DD'), NULL,
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 9900112233445),
        (SELECT id_sectie 
            FROM sectie WHERE nume = 'Chirurgie'));

-- Internare 2010 - Pacientul Balan Gabriela
INSERT INTO internari (id_internare, data_internarii, data_externarii, id_pacient, id_sectie)
    VALUES (2010,  TO_DATE('2024-01-05', 'YYYY-MM-DD'), TO_DATE('2024-01-20', 'YYYY-MM-DD') ,
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 1239879543210),
        (SELECT id_sectie 
            FROM sectie WHERE nume = 'Oncologie'));

-- Internare 2011 - Pacientul Popescu Florin  
INSERT INTO internari (id_internare, data_internarii, data_externarii, id_pacient, id_sectie)
    VALUES (2011, TO_DATE('2024-01-07', 'YYYY-MM-DD'), TO_DATE('2024-01-16', 'YYYY-MM-DD'),
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 6679889900112),
        (SELECT id_sectie 
            FROM sectie WHERE nume = 'Oncologie' ));
            
-- Internare 2012 - Pacientul Radu Alexandru
INSERT INTO internari (id_internare, data_internarii, data_externarii, id_pacient, id_sectie)
    VALUES (2012, TO_DATE('2024-01-10', 'YYYY-MM-DD'), NULL,
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 6677889900111),
        (SELECT id_sectie 
            FROM sectie WHERE nume = 'Neurologie'));
            
-- Internare 2013 - Pacientul Dumitru Sebastian
INSERT INTO internari (id_internare, data_internarii, data_externarii, id_pacient, id_sectie)
    VALUES (2013, TO_DATE('2024-01-13', 'YYYY-MM-DD'), NULL,
        (SELECT id_pacient 
            FROM pacient WHERE cnp = 6677889900113),
        (SELECT id_sectie 
            FROM sectie WHERE nume = 'Cardiologie'));



-- verificam valorile inserate în tabelul internari
SELECT * FROM internari;
