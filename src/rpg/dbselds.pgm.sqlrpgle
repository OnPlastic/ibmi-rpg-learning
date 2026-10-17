**free

ctl-opt dftactgrp(*no);

// ==================================================================
// DBSELDS - Db2-Datensatz in eine Data Structure einlesen
//
// Neue Konzepte: 
// - Db2-Daten werden direkt in Felder einer Data Structure gelesen
// - Die DS bildet den Kunden im Arbeitsspeicher ab
// - CLEAR verhindert alte Daten bei einem erfolgosen SELECT
//
// Ablauf: 
//
// Db2 Customer
//      |
//      | SELECT
//      |
// customer Data Structure
//      |
//      | READ
//      |
// RPG arbeitet mit customer.name, customer.address, customer.city
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

dcl-s customerId int(10);
dcl-s answer char(1);


// ==================================================================
// Kunden-ID einlesen
// ==================================================================

dsply 'Bitte Kunden-ID eingeben: ' '' customerId;


// ==================================================================
// Kundenstruktur vor dem SELECT leeren
// ==================================================================

clear customer;     // Wichtig wegen persistentem Programmspeicher


// ==================================================================
// Datensatz aus der Datenbank in die Data Structure einlesen
// ==================================================================

exec sql

    select  NAME,
            AGE,
            CITY
    
    into    :customer.name,         // vorher customerName!,
            :customer.age,          // separate Variablen
            :customer.city          // JETZT wird Template benutzt,
                                    // cusomter(.)name
    from    IBM4HUJER1.CUSTOMER

    where   CUSTOMER_ID = :customerId;


// ==================================================================
// SQL-Ergebnis pruefen
// ==================================================================

if sqlcod = 0;

    // --------------------------------------------------------------
    // Datensatz/Kunde wurde gefunden
    // --------------------------------------------------------------

    dsply ('Name: ' + customer.name);
    dsply ('Alter: ' + %char(customer.age));
    dsply ('Ort: ' + customer.city);

elseif sqlcod = 100;

    // --------------------------------------------------------------
    // Kein Datensatz/Kunde gefunden
    // --------------------------------------------------------------

    dsply 'Kein Kunde mit dieser ID gefunden.';

else;

    // --------------------------------------------------------------
    // Sonstiger SQL-Fehler
    // --------------------------------------------------------------

    dsply ('SQL-Fehler: ' + %char(sqlcod));

endif;


// ==================================================================
// Programm anhalten
// ==================================================================

dsply 'Weiter mit ENTER' '' answer;

// Erläuterung wegen Tippfehler:  dsply 'Weiter mit Enter ''' answer; 
// ------------------------------------------------------------------
// Bei DSPLY muessen die Operanden eindeutig getrennt sein:
//
// dsply 'Weiter mit Enter' '' answer;
//
// 'Weiter mit Enter' = Nachricht
// ''                 = keine explizite Message Queue
// answer             = Response-Variable
//
// Zwischen dem Ende des Nachrichten-Strings und dem leeren
// zweiten String muss eine Trennung stehen.
//
// Ohne diese Trennung koennen aufeinanderfolgende Hochkommas
// als Teil desselben String-Literals interpretiert werden.


return;