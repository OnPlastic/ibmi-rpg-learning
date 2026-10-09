**free

ctl-opt dftactgrp(*yes);

//===================================================================
// DSARRAY - Array von Data Structures
//
// Aufbau: 
// - DIM() fuer Arrays
// - mehrere Data Structures gleichen Typs speichern
// - Zugriff per Index
// - Array mit FOR durchlaufen
// - %ELEM() verwenden
//
// Python-Vergleich: 
//  costomers = [
//      Customer(...),
//      Customer(...),
//      Customer(...)
//  ]
// ==================================================================


// Bauplan der ds Data Structure
dcl-ds Customer_t qualified template;
    name varchar(30);
    age int(10);
    city varchar(30);
end-ds;


// Array mit drei Kunden
//
// Fuer dieses Beispiel ist die Groesse fest auf 3 gesetzt.
// RPG-Arrays benoetigen immer eine definierte Obergrenze.
//
// Mit DIM(*AUTO : max) kann die aktuelle Anzahl der Elemente
// flexibel anwachsen, die maximale Groesse wird aber weiterhin
// vorher festgelegt.
dcl-ds customers likeds(Customers_t) dim(3);


dcl-s i input(10);
dcl-s answer char(1);


// Erster Kunde
customers(1).name = 'Max Mustermann';
customers(1).age = 42;
customers(1).city = 'Nuernberg';

// Zweiter Kunde
customers(2).name = 'Anna Beispiel';
customers(2).age = 35;
customers(2).city = 'Bayreuth';

// Dritter Kunde
customers(3).name = 'Peter Muster';
customers(3).age = 51;
customers(3).city = 'Bamberg';


// Alle Kunden durchlaufen
for i = 1 to %elem(customers);

    dsply ('Kunde: ' + customers(i).name);
    dsply ('Alter: ' + %char(customers(i).age));
    dsply ('Ort: ' + customers(i).city);

endfor;


dsply 'Weiter mit Enter' '' answer;


return;


//===================================================================
// Erklaerungen: 
//
//  dcl-ds customers likeds(Customer_t) dim(3);
// -> Erzeuge ein Array namens 'customers' mit 3 Elementen, wobei
//    die Elemente so aufgebaut sind wie im Template 'Customer_t'.
//
// customers(i).name;
// -> Zugriff kombiniert jetzt Array-Index + Punktnotation
// -> Array Name (customers) -> Element i (i) -> Feld name (.name)
//
// WICHtIG!
// In einem RPG-Array beginnt die Indizierung bei "1" nicht bei 0.
//
// %ELEM() = liefert die Anzahl der Elemente des Arrays zurück
//
//  for i = 1 to %elem(customers);
// -> Setze i auf 1 und wiederhole die Schleife, bis i die Anzahl der
//    Elemente von 'customers' erreicht hat.
//
//
// Python-Vergleich: 
//
//  customers = [
//      {"name": "Max Mustermann", "age": 42, "city": "Nuernberg"},
//      {"name": "Anna Beispiel", "age": 35, "city": "Bayreuth"},
//      {"name": "Peter Muster", "age": 51, "city": "Bamberg"}
//  ]
//
//  for customers in customers:
//      print(customer["name"])
//      print(customer["age"])
//      print(customer["city"])
//
// Oder:
//
//  for customer in customers: 
//      print(customer.name)
//
// -> Python Listen koennen flexibel wachsen.
// -> RPG benoetigt dagegen immer eine maximale Array-Groesse
// -> Mit *AUTO kann die tatsächlich genutzte Groesse variabel sein
//
// ==================================================================