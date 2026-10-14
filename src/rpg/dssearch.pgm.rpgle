**free

ctl-opt dftactgrp(*yes);

// ==================================================================
// DSSEARCH - Einen Datensatz in einem DS-Array suchen
//
// Neue Konzepte: 
// - Suchwert vom Benutzer einlesen
// - DS-Arryay durchsuchen
// - Treffer mit Indicator merken
// - Schleife mit LEAVE vorzeitig verlassen
// ==================================================================


// Bauplan
dcl-ds Customer_t qualified template;
    name varchar(30);
    age int(10);
    city varchar(30);
end-ds;


// Drei Kunden
dcl-ds customers likeds(Customer_t) dim(3);


// Suchvariable
dcl-s searchName varchar(30);
dcl-s found ind inz(*off);  
dcl-s i int(10);

dcl-s answer char(1);


// ==================================================================
// Beispieldaten
// ==================================================================

customers(1).name = 'Max';
customers(1).age = 42;
customers(1).city = 'Nuernberg';

customers(2).name = 'Anna';
customers(2).age = 35;
customers(2).city = 'Bayreuth';

customers(3).name = 'Peter';
customers(3).age = 51;
customers(3).city = 'Bamberg';


// ==================================================================
// Suchbegriff eingeben
// ==================================================================

found = *off;
clear searchName;

dsply 'Kundenname suchen: ' '' searchName;


// ==================================================================
// Array durchsuchen
// ==================================================================

for i = 1 to %elem(customers);

    if customers(i).name = searchName;

        found = *on;

        dsply ('Gefunden: ' + customers(i).name);
        dsply ('Alter: ' + %char(customers(i).age));
        dsply ('Ort: ' + customers(i).city);

        leave;
    
    endif;

endfor;


// ==================================================================
// Kein Treffer
// ==================================================================

if not found;

    dsply 'Kunde wurde nicht gefunden:';

endif;


dsply 'Weiter mit Enter!' '' answer;


return;


// ==================================================================
// Erklaerungen: 
//
// IND = Indicator, ein Wahr/Falsch-Wert 
// -> Python: found = False
// -> C#: bool found = false;
//
// Wenn ein Kunde gefunden wird, dann -> found = *on;
// 
// leave = verlasse die Schleife sofort
//
// Beispiel: 'Anna' wird gesucht
//  i = 1 -> Max -> nein
//  i = 2 -> Anna -> Treffer (found = *on)
//                      |-> LEAVE
//  FOR beendet
//
// Persistenter Programmspeicher:
// Variablen koennen ihren Wert zwischen mehreren CALL-Aufrufen
// behalten, solange das Programm in derselben Activation Group
// aktiviert bleibt.
//
// INZ(*off) bedeutet deshalb nicht automatisch:
// "Bei jedem CALL wieder auf *off setzen".
//
// Wurde bei einem vorherigen Programmlauf ein Kunde gefunden,
// kann found beim naechsten CALL noch auf *on stehen.
//
// Deshalb wird der Zustand vor jeder neuen Suche bewusst
// zurueck gesetzt:
//
//      found = *off;
//      clear searchName;
//
// Dadurch startet jede Suche mit einem definierten Zustand.
// ==================================================================
