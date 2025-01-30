Tema proiectului: 
Sistem de gestiune a datelor din cadrul unui spital.

Descriere (non-tehnică):

Proiectul își propune să implementeze o bază de dată în care să se stocheze numele și prenumele pacienților, codul numeric personal, seria și numărul cărții de identitate, dacă figurează drept asigurați CNAS sau nu, secția (de exemplu: pediatrie, O.R.L) și numele doctorului la care sunt repartizați. Datele personale ale pacientului și ale doctorului sunt unice, de asemenea un doctor are repartizată o singură secție, dar poate avea mai mulți pacienți. Pacienții sunt repartizați la o singură secție în același timp. 

Limitări:

Sistemul nu tratează programările realizate online.
Pacienții sunt repartizați doar unui singur doctor dintr-o secție, iar schimbarea doctorului nu este gestionată.
Fiecare doctor poate fi repartizat la o singură secție.
Sistemul nu gestionează internările simultane ale unui pacient la mai multe secții. Pacienții pot fi internați doar la o secție în același timp.
Nu se gestionează schimbările de secții în timpul internării.



Descriere tehnică:

Entitatea Pacient:
id pacient – numeric, obligatoriu
nume – șir de caractere, obligatoriu
prenume – șir de caractere, obligatoriu
CNP – numeric, unic, obligatoriu
seria CI – șir de caractere, obligatoriu
număr CI – numeric, unic, obligatoriu
asigurat CNAS – boolean (True/False), obligatoriu

Entitatea Doctor:
id doctor – numeric, obligatoriu
nume doctor – șir de caractere, obligatoriu
prenume doctor – șir de caractere, obligatoriu
specializare – șir de caractere, obligatoriu
id secție – cheie externă legată de entitatea Secții (fiecare doctor are o secție unică)

Entitatea Secții:
id secție – numeric, obligatoriu
nume secție – șir de caractere, obligatoriu, unic (ORL, Pediatrie etc.)

Entitatea Repartizări (relația dintre Pacienți și Secții)
id repartizare – numeric, pentru identificarea fiecărei înregistrări individuale
id pacient (cheie externă legată de entitatea Pacienți) - ce pacient este implicat
id secție (cheie externă legată de entitatea Secții) - pentru a specifica secția unde pacientul este repartizat
id doctor (cheie externă legată de entitatea Doctori) – pentru a ști cine este medicul responsabil pentru acea secție
tip consult - șir de caractere (ambulatoriu, internare)

Entitatea Internări:
id internare – numeric, obligatoriu
id pacient – cheie externă legată de entitatea Pacienți
id secție – cheie externă legată de entitatea Secții
id doctor – cheie externă legată de entitatea Doctori
data internării – dată, obligatorie
data externării – dată, opțională (poate fi null daca pacientul încă e internat)

Entitatea Info_secție:
id info_secție – numeric, obligatoriu, cheie primară.
id sectie – cheie externă legată de entitatea Secții.
capacitate – numeric, obligatoriu, indică numărul maxim de paturi dintr-o secție.
echipamente – text, obligatoriu, descrie echipamentul medical principal din dotarea secției.
nr asistenti – numeric, optional, indică numărul de angajați care lucrează în secție.



