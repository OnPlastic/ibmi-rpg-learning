**free

ctl-opt dftactgrp(*no);

// ==================================================================
// DBCURSOR - Mehrere Datensätze aus Db2 lesen
// 
// Neue Konzepte: 
// - DECLARE CURSOR = Ergebnismenge vorbereiten
// - OPEN = Cursor oeffnen
// - FETCH = naechste Zeile lesen
// - CLOSE = Cursor schliessen
// - SQLCOD = 100 -> keine weitere Zeile vorhanden
// 
// Ablauf: 
// 
// Db2 CUSTOMER
//      |
//      | SELECT
//      |
//    Cursor
//      |
//      | FETCH
//      |
// customer Data Structure
// ==================================================================


// Keine Transaktionssteuerung fuer unsere nicht journalisierte
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
// Konkreter Kunde
// ==================================================================

dcl-ds customer likeds(Customer_t);


// ==================================================================
// Weitere Variablen
// ==================================================================

dcl-s answer char(1);


// ==================================================================
// Cursor definieren
// ==================================================================

exec sql 

    declare CustomerCursor cursor for 

        select  NAME,
                AGE,
                CITY
        from    IBM4HUJER1.CUSTOMER

        order by CUSTOMER_ID;


// ==================================================================
// Cursor oeffnen
// ==================================================================

exec sql 

    open CustomerCursor;
    dsply ('SQLCOD nach OPEN:' + %char(sqlcod));


// ==================================================================
// OPEN pruefen
// ==================================================================

if sqlcod = 0;

    // --------------------------------------------------------------
    // Ersten Datensaetze lesen
    // --------------------------------------------------------------

    clear customer;

    exec sql 

        fetch next from CustomerCursor

            into    :customer.name,
                    :customer.age,
                    :customer.city;
    
    // --------------------------------------------------------------
    // Datensaetze nacheinander verarbeiten
    // --------------------------------------------------------------

    dow sqlcod = 0;

        dsply ('Name: ' + customer.name);
        dsply ('Alter: ' + %char(customer.age));
        dsply ('Ort: ' + customer.city);
    
        // ----------------------------------------------------------
        // Naechsten Datensatz lesen
        // ----------------------------------------------------------

        clear customer;

        exec sql 

            fetch next from CustomerCursor

                into    :customer.name,
                        :customer.age,
                        :customer.city;
    enddo;

    // --------------------------------------------------------------
    // FETCH-Ergebnis pruefen
    // --------------------------------------------------------------

    if sqlcod = 100;

        dsply 'Keine weiteren Kunden';
    
    else;

        dsply ('SQL-Fehler beim Lesen: ' + %char(sqlcod));
    
    endif;


    // --------------------------------------------------------------
    // Cursor schliessen
    // --------------------------------------------------------------

    exec sql 

        close CustomerCursor;


else;

    // --------------------------------------------------------------
    // Cursor konnte nicht geoeffnet werden
    // --------------------------------------------------------------

    dsply ('Fehler beim Oeffnen des Cursors: ' + %char(sqlcod));

endif;


// ==================================================================
// Programm anhalten
// ==================================================================

dsply 'Weiter mit Enter ' '' answer;


return;


// ==================================================================
// Erklaerungen 
// ------------------------------------------------------------------
// Ablauf:
//  -> OPEN -> SQLCOD pruefen
// Fehler: 
//  -> Fehlermeldung
//  -> kein FETCH
//
// Erfolg: 
//  -> erstes FECTCH
//  -> solange SQLCOD = 0
//      Datensatz ausgeben
//      nächstes FETCH
//
// FETCH = 100
//  -> keine weiteren Kunden
//
// FETCH < 0
//  -> SQL-Fehler beim lesen
//
//
// ------------------------------------------------------------------
// Wichtige SQLCOD-Werte
// ------------------------------------------------------------------
//
// SQLCOD = 0
// -> SQL-Anweisung erfolgreich ausgefuehrt
// SQLCOD = 100
// -> Kein Datensatz gefunden bzw. bei einem Cursor: 
//    keine weitere Zeile vorhanden
// SQLCOD = -104
// -> Syntaxfehler in der SQL-Anweisung
// SQLCOD = -204
// -> Datenbankobjekt nicht gefunden
//    Beispiel: Tabelle oder View existiert unter diesem Namen nicht
// SQLCOD = -206
// -> Spalte bzw. Spaltennamme nicht gefunden
// SQLCOD = -305
// -> NULL-Wert soll in eine Host-Variable geschrieben werden, aber
//    es wurde keine Indicator-Variable fuer NULL angegeben
// SQLCOD = -407
// -> NULL-Wert soll in eine NOT-NULL-Spalte geschrieben werden
// SQLCOD = -501
// -> FETCH oder CLOSE auf einen Cursor, der nicht geöffnet ist
// SQLCOD = -502
// -> Versuch einen bereits geoeffneten Cursor erneut zu oeffnen
// SQLCOD = -530
// -> Fremdschluessel-Verletzung: 
//    Der referenzierte Datensatz existiert nicht
// SQLCOD = -803
// -> Doppelter Wert fuer PRIMARY KEY / UNIQUE-Schluessel
// SQLCOD = -811
// -> SELECT ... INTO hat mehr als eine Zeile geliefert,
//    obwohl genau eine erwartet wurde
// SQLCOD = -911
// -> Deadlock / Timeout; Transaktion wurde zurueckgerollt
// SQLCOD = -913
// -> Deadlock / Timeout; Anweisung konnte nicht ausgefuehrt werden
//
// ------------------------------------------------------------------
// Grundregel: 
// ------------------------------------------------------------------
//
// SQLCOD = 0       -> Erfolg
// SQLCOD > 0       -> Warnung / besonderer Zustand
// SQLCOD < 0       -> Fehler
//
// Hinweis: 
// - SQLSTATE ist der standardisierte Rueckgabecode
// - SQLCOD ist fuer RPG-Lernprogramme aber sehr praktisch und auf 
//   IBM i weiterhin haeufig anzutreffen
// - SQLCOD wird nach jeder SQL-Anweisung neu gesetzt, deshalb moegl.
//   nach jeder wichtigen Anweisung pruefen
// ==================================================================