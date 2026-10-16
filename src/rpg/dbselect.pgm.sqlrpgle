**free

ctl-opt dftactgrp(*no); // actgrp(*caller) bnddir('QC2LE');

// ==================================================================
// DBSELECT - Einen Kunden aus Db2 lesen
//
// Neue Konzepte: 
// - SQL-Statements in RPGLE -> SQLRPGLE
// - EXEC SQL
// - SQL-Cursor -> SELECT ... INTO
// - RPG-Variablen als SQL-Host-Variablen
// ==================================================================


// Keine Transaktionssteuerung fuer unsere nicht journalisierte
// PUB400-Lerntabelle vewenden
exec sql
    set option commit = *none;


// RPG-Variablen fuer die Spalten der Tabelle
dcl-s customerId int(10) inz(2); // Kunde mit der ID 2 lesen
dcl-s customerName varchar(30);
dcl-s customerAge int(10);
dcl-s customerCity varchar(30);

dcl-s answer char(1);


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
// Ausgabe der Daten
// ==================================================================

dsply ('Name: ' + customerName);
dsply ('Alter: ' + %char(customerAge));
dsply ('Ort: ' + customerCity);

dsply 'Weiter mit Enter' '' answer;


return;


// ==================================================================
// Erklaerungen: 
//
// Host-Variablen = Variablen, die in RPGLE definiert sind 
//                  und in SQL-Statements verwendet werden koennen.
//
// Db2-Spalte       RPG-Variable
// -------------------------------------
// NAME            (:)customerName
// AGE             (:)customerAge
// CITY            (:)customerCity
//
// Sobald SQL innerhalb eines RPG-Programms auf eine RPG-Variable
// zugreifen soll, wird sie zur sogenannten Host-Variable und bekommt
// ein vorangestelltes Doppelpunkt-Zeichen (:).
// 
// Im RPG-Code heißt sie:   customerId
// Innerhalb von SQL:       :customerId
//
// Zuweisung: 
// SELECT NAME -> customerName
// SELECT AGE  -> customerAge
// SELECT CITY -> customerCity
//
// Für 'customerId = 2' wird erwartet:
// Name:  Max
// Alter:  42
// Ort:   Nuernberg
//
// Besonderheiten:
//  exec sql
//      set option commit = *none;
//  - keine Transaktionssteuerung, da die Tabelle nicht journalisiert
//    ist. (PUB400-Lerntabelle)
// 
// ==================================================================