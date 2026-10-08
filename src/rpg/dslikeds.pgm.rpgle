**free

ctl-opt dftactgrp(*yes);

// ==================================================================
// DSLIKEDS - Data Structure mehrfach verwenden
//
// Aufbau:
// - TEMPLATE fuer eine reine Strukturvorlage
// - LIKEDS fuer mehrere Data Structures gleicher Form
// - Werte der einzelnen Instanzen bleiben getrennt
//
// Python-Vergleich:
// - Mehrere Objekte mit demselben Aufbau
// ==================================================================


dcl-ds Customer_t qualified template;
    name varchar(30);
    age int(10);
    city varchar(30);
end-ds;


dcl-ds customer1 likeds(Customer_t);

dcl-ds customer2 likeds(Customer_t);

dcl-s answer char(1);


// Erster Kunde
customer1.name = 'Max Mustermann';
customer1.age = 42;
customer1.city = 'Nuernberg';

// Zweiter Kunde
customer2.name = 'Anna Beispiel';
customer2.age = 35;
customer2.city = 'Bayreuth';

// Beide Data Structures ausgeben
dsply ('Kunde 1: ' +customer1.name);
dsply ('Alter: ' + %char(customer1.age));
dsply ('Ort: ' + customer1.city);

dsply ('Kunde 2: ' + customer2.name);
dsply ('Alter: ' + %char(customer2.age));
dsply ('Ort: ' + customer2.city);

dsply 'Weiter mit Enter' '' answer;


return;


// ==================================================================
// Erklaerungen: 
//
// dcl-ds Customer_t qulified template;
// - _t = type/template
// - TEMPLATE = Diese Data Structure dient als Bauplan
// - Ein Kunde besteht aus: -> name/age/city
//
// dcl-ds customer1 likeds(customer_t);
// dcl-ds customer2 likeds(customer_t);
// -> customer1 / 2 soll genauso aufgabaut werden wie customer_t
//
// Wichtig: 
// Die Struktur ist gleich, die Daten sind getrennt.
// - customer1.age = 42
// - customer2.aGE = 35
//
// Also: 
// Customer_t   ->  Bauplan
// customer1    ->  konkrete Data Structure
// customer2    ->  konkrete Data Structure
// ==================================================================
