**free

ctl-opt dftactgrp(*yes);

// ==================================================================
// DATASTRUCT - erste Data Structure
//
// Aufbau: 
// - DCL-DS / END - DS
// - nehrere zusammengehoerige Werte gruppieren
// - QUALIFIED verwenden
// - Zugriff auf Unterfelder mit Punktnotation
//
// Python-Vergleich:
// - Ein Objekt bzw. einen strukturierte Sammlung zusammengehoeriger
//   Daten.
// ==================================================================


dcl-ds customer qualified;
    name varchar(30);
    age int(10);
    city varchar(30);
end-ds;

dcl-s answer char(1);


// Werte in die einzelnen Felder schreiben
customer.name = 'Max Mustermann';
customer.age = 42;
customer.city = 'Nuernberg';


// Werte aus der Data Structure lesen
dsply ('Name: ' + customer.name);
dsply ('Alter: ' + %char(customer.age));
dsply ('Ort: ' + customer.city);


dsply 'Weiter mit Enter' '' answer;


return;


// ==================================================================
// Erklaerungen: 
//
// - DCL-DS = Declare Data Structure
// - QUALIFIED = Auf die Unterfelder soll über den Namen der DS 
//               zugegriffen werden. Z.B. cusotmer.name
//
// Bisher: 
// name [Max Mustermann]
// age [42]
// city [Nuernberg]
//
// Jetzt: 
// Customer
//  |
//  |-- name [Max Mustermann]
//  |-- age [42]
//  |-- city [Nuernberg]
//
// Zugriff auf die Informationen mit:
// customer.name
// customer.age
// customer.city
//
// Vorteil: 
// - mehrere Strukturen können name verwenden
// * customer.name
// * supplier.name
// * employee.name
//
// Aber:
// Die RPG-Data-Structure ist zunächst nur ein Datencontainer, noch
// keine Klasse mit Methoden und Verhalten!
// ==================================================================
