# My-Encryption
IUGA FLORIN-EUGEN, 325CA



		Project 2 IOCLA


TASK1:
  -> Am aflat lungimea sirului encoded pentru a stii la ce adresa
     se afla cheia (initial i-am facut o copie sirului in ebx,
     astfel ca in ebx retin sirul encoded, iar cheia se va afla
     in ecx cand le dau ca parametrii functiei.
  -> In functia xor_strings fac xor efectiv intre fiecare byte
     din sirul encoded cu byte-ul corespunzator din cheie, iar
     rezultatul xor-ului va suprascrie fiecare byte din ecx,
     adica din sirul encoded initial.

TASK2:
   -> dau ca parametru stringul encoded
   -> in functia rolling_xor incep de la coada sirului si ma
      folosesc mereu de rezultatul xor-ului anterior la xor-ul
      curent si suprascriu fiecare byte din ecx

TASK3:
	OBSERVATIE: Din pacate acest task nu mi-a iesit, cumva imi
	decripteaza doar o parte din sir si nu mi-am dat seama
	unde este greseala.
	-> in task 3 am incercat sa transform cate 2 bytes
	intr-unul singur. Practic, am facut asta transformand in
	hexa atat sirul cat si cheia. Am observat ca imi face bine
	acest lucru intrucat am printat stringul si cheia dupa
	conversie si imi afiseaza ce trebuie. (pe exemplul
	"deadbeef" imi afiseaza 0xde 0xad 0xbe 0xef).
	-> in functia xor_hex_strings fac efectiv xor intre
	fiecare byte din sirul encoded si fiecare byte din cheie.
	Suprascriu ecx cu fiecare rezultat al xor-ului. La final,
	decripteaza ok primele caractere din sir, dar dupa se
	pierde cumva si nu am inteles de ce.

TASK5:
	->la acest task, am folosit inca 2 functii ajutatoare,
	make_xor, respectiv search_force. In functia bruteforce_
	singlebyte_xor fac un loop in care fac xor mai intai intre
	sirul initial si 0, apoi cu 1, pana la 255. Dupa ce am
	facut xor cu byte-ul curent, apelez functia search_force
	care va intoarce 1 daca gaseste substringul "force" in
	stringul decriptat si 0 altfel. Da rezultatul este 1, ies
	din loop pentru ca inseamna ca am gasit cheia potrivita, o
	plasez in registrul eax pentru a fi intoarsa de functie.
	Daca rezultatul intors de search_force este 0, apelez
	make_xor tot cu cheia anterioara pentru a aduce sirul la
	forma initiala. Fac aceiasi pasi pana dau de cheie corecta

TASK6:
	->in task6 nu am inteles initial de ce era pus codul acela
	acolo intrucat spune inainte "find the addresses for the
	input string and key" asa ca am facut acelasi lucru ca
	la celelalte task-uri pentru a afla adresa la care se
	gaseste cheia. (adica calculez lungimea string-ului,astfel
	ca cheia se va afla la string+lungime)
	-> in functia decode_vigenere fac loop-ul decrypt in care
	verific fiecare byte din string, daca nu este litera
	va face jump la next_char pentru a ignora numerele,spatiul
	sau alte caractere pe care nu trebuie algoritmul.
	-> dupa verific, daca scazand dintr-o litera din string
	litera corespunzatoare din cheie rezulta in ceva mai mic
	decat 'a', atunci merg pe lab-ul less_than_a in care se
	face diferenta dintre litera din string si litera din
	cheie si se aduna la rezultat 26. Astfel, litera rezultata
	va fi 'a' + rezultatul respectiv.
	-> daca rezulta ceva mai mare decat 'a' atunci este cazul
	favorabil in care aplic efectiv scaderea literelor si
	suprascriu stringul.
