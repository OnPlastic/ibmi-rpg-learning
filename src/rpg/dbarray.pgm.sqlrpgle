**free

ctl-opt dftactgrp(*no);

// ==================================================================
// DBARRAY - Db2-Daten in ein dynamisches DS-Array einlesen
//
// Neue Konzepte: 
// - Cursor liest mehrere Datensaetze aus Db2
// - FETCH schreibt jeweils einen Datensatz in eine Data Structure
// - Die Data Structure wird mit *NEXT in ein DS-Array uebernommen
// - Nach CLOSE stehen die geladenen Daten weiterhin im RPG-Speicher
//
// Ablauf: 
//
// Db2 CUSTOMER
//      |
//      | Cursor / FETCH
//      |
// customer Data Structure
//      |
//      | customers(*next) = customer
//      |
// customers DS-Array
// ==================================================================


// Keine Transaktionssteuerung fuer die nicht journalisierte
// PUB400-Lerntabelle verwenden
exec sql 
    set option commit = *none;


// ==================================================================
// Bauplan fuer einen Kunden
// ==================================================================

dcl-ds Customer_t qualified template;

    name varchar(30);
    age int(10);
    city varchar(30);

end-ds;


// ==================================================================
// Arbeitsbereich/Variable fuer den aktuell geladenen Kunden
// ==================================================================

dcl-ds customer likeds(Customer_t);         // !customer!


// ==================================================================
// Dynamisches Array fuer die geladenen Kunden - dim(...)
// ==================================================================

dcl-ds customers likeds(Customer_t)         // !customer(s)!
    dim(*auto : 100);


// ==================================================================
// Weitere Variablen
// ==================================================================

dcl-s i int(10);                            // Zaehler
dcl-s answer char(1);                       // Programm Pause/Ende


// ==================================================================
// Cursor definieren
// ==================================================================
// ->Beschreibt die SELECT-Abfrage
// ------------------------------------------------------------------

exec sql 

    declare CustomerCursor cursor for       // !CustomerCursor!

        select  NAME,
                AGE,
                CITY
        from IBM4HUJER1.CUSTOMER 

        order by CUSTOMER_ID;


// ==================================================================
// Programmzustand fuer diesen Aufruf zuruecksetzen
// ==================================================================

%elem(customers) = 0;


// ==================================================================
// Cursor oeffnen
// ==================================================================
// -> Db2 fuehrt die Abfrage aus, bereitet die Ergebnismenge vor
// ------------------------------------------------------------------

exec sql 

    open CustomerCursor;    // liefert aktuellen SQLCOD
                            // -> sollte SQLCOD = 0 sein


// ==================================================================
// OPEN pruefen
// ==================================================================

if sqlcod = 0;              // SQLCOD = 0 -> Anweisung erfolgreich

    // --------------------------------------------------------------
    // Ersten Datensatz lesen FETCH
    // --------------------------------------------------------------
    // -> holt jeweils die nächste Zeile aus der Ergebnismenge 
    // ..............................................................

    clear customer;         // falls Rueckstaende, diese loeschen

    exec sql

        fetch next from CustomerCursor  // liefert neuen SQLCOD
                                        // -> sollte SQLCOD = 0 sein
                                                         
        into    :customer.name,         // erste Werte in (customer)
                :customer.age,          // speichern
                :customer.city;
    

    // --------------------------------------------------------------
    // Datensaetze nacheinander ins Array uebernehmen
    // --------------------------------------------------------------

    dow sqlcod = 0;         // 0 = Zeile nach (customer) geladen

        //          Ziel = Quelle
        customers(*next) = customer;    // Uebergabe an DS-Array

        clear customer;     // temp. (customer)-Variable loeschen

        exec sql 

            fetch next from CustomerCursor  // liefert wieder SQLCOD
                                            
            into    :customer.name,         // naechste Werte 
                    :customer.age,          // eintragen
                    :customer.city;
    
    enddo;      // solange wiederholen bis SQLCOD = 100; 
                // -> keine weitere Zeile


    // --------------------------------------------------------------
    // FETCH-Ergebnis pruefen
    // --------------------------------------------------------------

    if sqlcod = 100;

        dsply 'Alle Kunden wurden geladen.';
    
    else;

        dsply ('SQL-Fehler beim lesen: ' + %char(sqlcod));
    
    endif;


    // --------------------------------------------------------------
    // Cursor schließen
    // --------------------------------------------------------------

    exec sql

        close CustomerCursor;


else;


    // --------------------------------------------------------------
    // Cursor konnte nicht geoeffnet werden
    // --------------------------------------------------------------

    dsply ('Fehler beim oeffnen des Cursors: ' + %char(sqlcod));


endif;


// ==================================================================
// Anzahl der geladenen Kunden ausgeben
// ==================================================================

dsply ('Kunden im Array: ' + %char(%elem(customers)));


// ==================================================================
// Kunden aus dem DS-Array ausgeben
// ==================================================================

for i = 1 to %elem(customers);

    dsply ('Name: ' + customers(i).name);
    dsply ('Alter: ' + %char(customers(i).age));
    dsply ('Ort: ' + customers(i).city);

endfor;


// ==================================================================
// Programm anhalten
// ==================================================================

dsply 'Weiter mit Enter!' '' answer;


return;


// ==================================================================
// Logik: 
// ------------------------------------------------------------------
//
// DECLARE
//  |
// OPEN
//  |
// OPEN erfolgreich?
//  |
// FETCH erster Kunde
//  |
// DOW solange FETCH = 0
//  |
// customer -> customers(*next)
//  |
// FETCH nächster Kunde
//  |
// 100 -> Ende
//  |
// CLOSE
//  |
// Array ausgeben
//  |
// Programm Ende
// ==================================================================