org 100h

bucla_meniu:
;Afisare meniu
mov dx, offset menu
mov ah, 9
int 21h

;Citirea optiunii de la tastatura
mov ah, 1
int 21h

;Compararea optiunii introduse pentru a determina operatia care trebuie efectuata
cmp al, '1'
je opt1
cmp al, '2'
je opt2
cmp al, '3'
je opt3
cmp al, '0'
je exit

;Afisare mesaj de eroare in cazul in care optiunea este invalida
mov dx, offset eroare
mov ah, 9
int 21h
jmp bucla_meniu
opt1:
mov dx, offset msg1
mov ah, 9
int 21h

;Verificare daca primul caracter introdus de la tastatura este negativ, daca da, se apeleaza o functie
pentru a citi inca un caracter si a-l memora in complement fata de 2
mov ah, 1
int 21h
cmp al, '-'
jne nr1_pozitiv
call citire_nr_negativ
jmp salvare_nr1

;Daca numarul este pozitiv se transforma in binar inainte sa fie salvat
nr1_pozitiv:
sub al, '0'

salvare_nr1:
mov [nr1], al
mov dx, offset msg7
mov ah, 9
int 21h

;Afisarea numarului introdus, trebuie mai intai transformat inapoi in ASCII prin adaugarea lui '0'
mov dl, [nr1]
cmp [nr1], 0
jge afisare_nr1

;Daca numarul este negativ trebuie mai intai afisat caracterul ‘-’
mov dl, '-'
mov ah, 2
int 21h
mov dl, [nr1]
neg dl

afisare_nr1:
add dl, '0'
mov ah, 2
int 21h

;Proces similar cu cel pentru citirea primului numar
mov dx, offset msg2
mov ah, 9
int 21h
mov ah, 1
int 21h
cmp al, '-'
jne nr2_pozitiv
call citire_nr_negativ
jmp salvare_nr2

nr2_pozitiv:
sub al, '0'

salvare_nr2:
mov [nr2], al
mov dx, offset msg7
mov ah, 9
int 21h
mov dl, [nr2]
cmp [nr2], 0
jge afisare_nr2
mov dl, '-'
mov ah, 2
int 21h
mov dl, [nr2]
neg dl

afisare_nr2:
add dl, '0'
mov ah, 2
int 21h

;Intoarcere inapoi la meniu
jmp bucla_meniu
opt2:

;Adunarea numerelor in registrul dl si pregatire registrii al si ah pentru impartire la 10
mov dl, [nr1]
add dl, [nr2]
mov [rezultat], dl
mov al, [rezultat]
mov ah, 0
cmp al, 0
jg suma_pozitiva

;Functia aam nu poate fi aplicata pe numere negative
neg al

;Functia aam imparte numarul din al la 10, in ah se memoreaza numarul zecilor iar in al numarul
unitatilor. Astfel programul poate calcula numere in intervalul [-18, 18]. Numerele zecilor si al
unitatilor trebuie retinute in format ASCII pentru afisare.
suma_pozitiva:
aam
mov [zeci], ah
add [zeci], '0'
mov [unitati], al
add [unitati], '0'

;Afisarea sumei numerelor citite de la tastatura
mov dx, offset msg3
mov ah, 9
int 21h
cmp [rezultat], 0
jge afisare_suma_pozitiva

;In cazul in care suma este negativa se afiseaza mai intai ‘-’
mov dl, '-'
mov ah, 2
int 21h

afisare_suma_pozitiva:
mov dl, [zeci]
mov ah, 2
int 21h
mov dl, [unitati]
mov ah, 2
int 21h
jmp bucla_meniu

opt3:
cmp [rezultat], 0
jg pozitiv
jl negativ
mov dx, offset msg6
mov ah, 9
int 21h
jmp bucla_meniu

pozitiv:
mov dx, offset msg5
mov ah, 9
int 21h
jmp bucla_meniu

negativ:
mov dx, offset msg4
mov ah, 9
int 21h
jmp bucla_meniu

;In cazul in care primul caracter introdus de la tastatura este ‘-’, se apeleaza functia urmatoare, care
citeste inca un caracter de la tastatura, il transforma in binar din ASCII si apoi il reprezinta in
complement fata de 2 si se intoarce la instructiunea care urmeaza dupa apelul functiei.
citire_nr_negativ:
mov ah, 1
int 21h
sub al, '0'
neg al
ret

exit:
int 20h

;Declarare mesaje pentru afisare
menu db 10,13,"Meniu",10,13,"1.Introdu doua numere",10,13,"2.Adunare
numere",10,13,"3.Verificare semn",10,13,"0.Iesire",10,13,"Alege: $"
msg1 db 10,13,"Introdu primul numar: $"
msg2 db 10,13,"Introdu al doilea numar: $"
msg3 db 10,13,"Suma este: ",10,13,"$"
msg4 db 10,13,"Numarul este negativ", 10,13,"$"
msg5 db 10,13,"Numarul este pozitiv",10,13,"$"
msg6 db 10,13,"Numarul este 0",10,13,"$"
msg7 db 10,13,"Ati introdus: $"
eroare db 10,13, "Optiune invalida",10,13,"$"

;Declarare variabile de memorie noi, ‘db’ reprezinta spatiul de stocare al variabilei, adica 8 biti,
iar 0 inseamna ca variabila este initializata cu valoarea 0
nr1 db 0
nr2 db 0
rezultat db 0
zeci db 0
unitati db 0