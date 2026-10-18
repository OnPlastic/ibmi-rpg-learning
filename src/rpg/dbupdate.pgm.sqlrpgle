**free

ctl-opt dftactgrp(*no);

// ==================================================================
// DBUPDATE - Einen bestehenden Db2-Datensatz aus RPG aendern
//
// Neue Konzepte: 
// - UPDATE veraendert einen vorhandenen Datensatz
// - SET legt den neuen Wert fest
// - WHERE bestimmt, welcher Datensatz geaendert wird
// - RPG-Variablen werden wieder als Host Variables verwendet
// 
// Ablauf: 
//
// Kunden-ID + neuer Ort
//  |
// customer Data Structure
//  |
//  | UPDATE
//  |
// Db2 CUSTOMER
// ==================================================================


// Keine Transaktionssteuerung fuer die nicht journalisierte Tabelle
exec sql 
    set option commit = *none;


// ==================================================================
// Arbeitsbereich fuer die Anderung
// ==================================================================

dcl-ds customer qualified;

    id int(10);
    city varchar(30);

end-ds;


// ==================================================================
// Weitere Variablen
// ==================================================================

dcl-s answer char(1);


// ==================================================================
// Programmzustand fuer diesen Aufruf zuruecksetzen
// ==================================================================

clear customer;


// ==================================================================
// Aenderungen eingeben
// ==================================================================

dsply 'Kunden-ID: ' '' customer.id;
dsply 'Neuer Ort: ' '' customer.city;


// ==================================================================
// Datensatz in Db2 aendern
// ==================================================================

exec sql 

    update IBM4HUJER1.CUSTOMER 

        set CITY = :customer.city
    
    where CUSTOMER_ID = :customer.id;


// ==================================================================
// SQL-Ergebnis pruefen
// ==================================================================

if sqlcod = 0;

    dsply 'Kunde wurde aktualisiert!';

elseif sqlcod = 100;

    dsply 'Kunde nicht gefunden!';

else;

    dsply ('SQL-Fehler beim Update: ' + %char(sqlcod));

endif;


// ==================================================================
// Programm anhalten
// ==================================================================

dsply 'Weiter mit Enter!' '' answer;


return;


// ==================================================================
// Ablauf: 
// ------------------------------------------------------------------
//
// UPDATE CUSTOMER
// -> in dieser Tabelle etwas aendern
//
// SET CITY = :customer.city
// -> CITY bekommt den Wert aus der RPG-Variable
//
// !!! Wichtig !!!
// WHERE CUSTOMER_ID = :customer.id
// -> aber nur bei diesem Kunden
//
// !!!Sonst!!!
// SET CITY = :customer.city
// -> aendert den Ort bei ALLEN Kunden in der Tabelle
//
// ------------------------------------------------------------------
// vorhandene ID
// -> UPDATE erfolgreich
// -> SQLCOD = 0 (SQL-Anweisung erfolgreich)
// 
// nicht vorhandene ID
// -> keine Zeile geändert
// -> SQLCOD = 100 (Kein Datensatz gefunden)
// -> "Kunde wurde nicht gefunden"
// ==================================================================