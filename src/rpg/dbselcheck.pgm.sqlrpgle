**free

ctl-opt dftactgrp(*no); // actgrp(*caller) bnddir('QC2LE');

// ==================================================================
// DBSELECTCHECK - Einen Kunden aus Db2 lesen und Ergebnis pruefen
//
// Neue Konzepte: 
// - Kunden ID wird vom Benutzer eingegeben
// - SELECT ... INTO liest einen Datensatz aus Db2
// - SQLCOD prueft, ob die SQL-Anweisung erfolgreich war
// - SQLCOD = 0 -> Datensatz gefunden
// - SQLCOD = 100 -> kein Datensatz gefunden
// - SQLCOD < 0 -> Fehler
// ==================================================================


// Keine Transaktionssteuerung fuer unsere nicht journalisierte
// PUB400-Lerntabelle vewenden
exec sql
    set option commit = *none;


// ==================================================================
// RPG-Variablen fuer die Spalten der Tabelle
// ==================================================================

dcl-s customerId int(10);

dcl-s customerName varchar(30);
dcl-s customerAge int(10);
dcl-s customerCity varchar(30);

dcl-s answer char(1);


// ==================================================================
// Kunden-ID eingeben
// ==================================================================

dsply 'Kunden-ID eingeben: ' '' customerId;


// ==================================================================
// Datensatz aus Db2 lesesn
// ==================================================================

exec sql
    select  NAME, 
            AGE, 
            CITY
    into    :customerName,
            :customerAge,
            :customerCity
    from    IBM4HUJER1.CUSTOMER
    where   CUSTOMER_ID = :customerId;


// ==================================================================
// SQLCOD pruefen
// ==================================================================

if sqlcod = 0;
    
    // --------------------------------------------------------------
    // Datensatz gefunden
    // --------------------------------------------------------------

    dsply ('Name: ' + customerName);
    dsply ('Alter: ' + %char(customerAge));
    dsply ('Ort: ' + customerCity);

elseif sqlcod = 100;

    // --------------------------------------------------------------
    // Keinen passenden Datensatz gefunden
    // --------------------------------------------------------------

    dsply ('Kein Kunde mit der ID ' + %char(customerId));

else;

    // --------------------------------------------------------------
    // Sonstiger SQL-Fehler
    // --------------------------------------------------------------

    dsply ('SQL-Fehler: ' + %char(sqlcod));

endif;


dsply 'Weiter mit Enter' '' answer;


return;