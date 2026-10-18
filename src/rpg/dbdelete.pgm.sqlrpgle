**free

ctl-opt dftactgrp(*no);

// ==================================================================
// DBDELETE - Einen Db2 Datensatz ueber RPG loeschen
// 
// Neue Konzepte: 
// - DELETE entfernt einen kompletten Datensatz aus Db2
// - WHERE bestimmt, welcher Datensatz geloescht wird
// - RPG-Variable wird als Host Variable fuer die ID verwendet
//
// Ablauf: 
//
// Kunden-ID
//  |
// DELETE
//  |
// Db2 CUSTOMER
// ==================================================================


// Keine Transaktionssteuerung für nicht journalisierte Tabelle
exec sql 
    set option commit = *none;


// ==================================================================
// Variablen
// ==================================================================

dcl-s customerId int(10);
dcl-s answer char(1);


// ==================================================================
// Programmzustand fuer diesen Aufruf zuruecksetzen
// ==================================================================

clear customerId;


// ==================================================================
// Kunden-ID eingeben
// ==================================================================

dsply 'Kunden-ID loeschen: ' '' customerId;


// ==================================================================
// Datensatz aus Db2 loeschen
// ==================================================================

exec sql 

    delete from IBM4HUJER1.CUSTOMER 

    where CUSTOMER_ID = :customerId;


// ==================================================================
// SQL-Ergebnis pruefen
// ==================================================================

if sqlcod = 0;

    dsply 'Kunde wurde geloescht!';

elseif sqlcod = 100;

    dsply 'Kunde wurde nicht gefunden!';

else;

    dsply ('SQL-Fehler beim loeschen: ' + %char(sqlcod));

endif;


// ==================================================================
// Programm beenden
// ==================================================================

dsply 'Weiter mit Enter!' '' answer;


return;


// ==================================================================
// Abauf: 
// ------------------------------------------------------------------
// 
// DELETE FROM CUSTOMER
// -> loesche Datensatz aus dieser Tabelle
// 
// WHERE CUSTOMER_ID = :customerId
// -> aber nur den Datensatz mit dieser ID
//
// !!! Wichtig !!!
// WHERE CUSTOMER_ID = :customer.id
// -> aber nur bei diesem Kunden
//
// !!!Sonst!!!
// DELETE FROM IBM4HUJER1.CUSTOMER
// -> loescht ALLE Kunden in der Tabelle
//
// set option commit = *none;
// -> Kein ROLLBACK / UNDO
// ==================================================================
