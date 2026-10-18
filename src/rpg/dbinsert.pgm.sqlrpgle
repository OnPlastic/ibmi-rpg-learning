**free

ctl-opt dftactgrp(*no);

// ==================================================================
// DBINSERT - Einen Kunden aus RPG in Db2 speichern
// 
// Neue Konzepte: 
// - Daten werden in einer RPG-Data-Structure erfasst
// - INSERT schreibt dies Daten dauerhaft nach Db2
// - RPG-Felder werden als Host Variablen an SQL uebergeben
// 
// Ablauf: 
//
// Eingabe
//  |
// customer Data Structure
//  |
//  | INSERT
//  |
// Db2 CUSTOMER
// ==================================================================


// Keine Transaktionssteuerung für nicht journalisierte PUB400-Table
exec sql 
    set option commit = *none;


// ==================================================================
// Bauplan fuer einen Kunden
// ==================================================================

dcl-ds Customer_t qualified template;

    id int(10);
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
// Programmzustand zuruecksetzen
// ==================================================================

clear customer;


// ==================================================================
// Kundendaten eingeben
// ==================================================================

dsply 'Kunden-ID: ' '' customer.id;
dsply 'Name: ' '' customer.name;
dsply 'Alter: ' '' customer.age;
dsply 'Ort: ' '' customer.city;


// ==================================================================
// Kunden in Db2 speichern
// ==================================================================

exec sql 

    insert into IBM4HUJER1.CUSTOMER (
        CUSTOMER_ID,
        NAME,
        AGE,
        CITY
        )
    
    values (
        :customer.id,
        :customer.name,
        :customer.age,
        :customer.city
        );


// ==================================================================
// SQL-Ergebnis pruefen
// ==================================================================

if sqlcod = 0;

    dsply 'Kunde wurde gespeichert';

else;

    dsply ('SQL-Fehler beim Seichern: ' + %char(sqlcod));

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
// ID (x) eingeben
//  |
// Name, Alter, Ort eingeben
//  |
// INSERT wird ausgefuehrt
//  |
// Db2 prueft PRIMARY KEY
//  |
// ID (x) exisitert bereits -> sqlcod = -803 -> Fehlermeldung
// ID (x) existiert nicht   -> sqlcod = 0    -> Kunde gespeichert
//
// ==================================================================