**free

ctl-opt dftactgrp(*yes);

// ==================================================================
// DSNESTED - Verschachtelte Data Structures
//
// Aufbau: 
// - Eine Data Structure kann selbst wieder eine Data Structure als
//   Bestandteil enthalten.
//
// Beispiel: 
// - Bisher -> Name/Age/City
// - Jetzt  -> City -> Strasse/Postleitzahl/Ort
// ==================================================================

dcl-s answer char(1);

// Bauplan fuer eine Adresse
dcl-ds Address_t qualified template;
    street varchar(40);
    zip varchar(10);
    city varchar(30);
end-ds;


// Bauplan fuer einen Kunden
dcl-ds Customer_t qualified template;
    name varchar(30);
    age int(10);
    address likeds(Address_t);
end-ds;


// Konkreter Kunde
dcl-ds customer likeds(Customer_t);


// ==================================================================
// Daten setzen
// ==================================================================

customer.name = 'Max Mustermann';
customer.age = 42;

customer.address.street = 'Hauptstrasse 15';
customer.address.zip = '90402';
customer.address.city = 'Nuernberg';


// ==================================================================
// Daten ausgeben
// ==================================================================

dsply ('Name: ' + customer.name);
dsply ('Alter: ' + %char(customer.age));

dsply ('Strasse: ' + customer.address.street);
dsply ('PLZ: ' + customer.address.zip);
dsply ('Ort: ' + customer.address.city);


dsply 'Weiter mit Enter!' '' answer;


return;


// ==================================================================
// RPG - DS Structure
//
// customer
// |
// |--name
// |--age
// |
// |--adress
//    |
//    |--street
//    |--zip
//    |--city
//
// -> customer.name
// -> customer.adress.city
//
// Python-Vergleich
//  customer = {
//      "name": "Max Mustermann",
//      "age": 42,
//      "address": {
//          "street": "Hauptstrasse 15",
//          "zip": "90402",
//          "city": "Nuernberg"
//      }
//  }
//
// customer["name"]
// customer["address"]["city"]
// ==================================================================
