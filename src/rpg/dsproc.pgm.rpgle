**free

// Default Action Group hier jetzt *no, da eine Procedure vorhanden
ctl-opt dftactgrp(*no);

// ==================================================================
// DSPROC - Data Structure an eine Procedure uebergeben
//
// Aufbau:
// - Data Structure als Argument uebergeben
// - LIKEDS auch fuer Procedure-Parameter verwenden
// - zusammengehoerige Daten als Einheit behandeln
//
// Python-Vergleich: 
//
//  def show_customer(customer): 
//      print(customer.name)
//      print(customer.age)
//      print(customer.city)
//
//  show_customer(customer1)
// ==================================================================


// Bauplan fuer einen Kunden
dcl-ds Customer_t qualified template;
    name varchar(30);
    age int(10);
    city varchar(30);
end-ds;


// Portotype der Procedure
dcl-pr ShowCustomer;
    customer likeds(Customer_t) const;
end-pr;


// Konkrete Data Structures
dcl-ds customer1 likeds(Customer_t);
dcl-ds customer2 likeds(Customer_t);

dcl-s answer char(1);


// Daten fuellen
customer1.name = 'Max Mustermann';
customer1.age = 42;
customer1.city = 'Nuernberg';

customer2.name = 'Anna Beispiel';
customer2.age = 35;
customer2.city = 'Bayreuht';


// Ganze Data Structure uebergeben
ShowCustomer(customer1);
ShowCustomer(customer2);


dsply 'Weiter mit Enter' '' answer;


return;


// ==================================================================
// Procedure zur Ausgabe eines Kunden
// ==================================================================

dcl-proc ShowCustomer;

    dcl-pi *n;
        customer likeds(Customer_t) const;
    end-pi;

    dsply ('Name: ' + customer.name);
    dsply ('Alter: ' + %char(customer.age));
    dsply ('Ort: ' + customer.city);

end-proc;


//===================================================================
// Erklaerungen: 
//
// Vorher: 
//  ShowCustomer(customer1.name : customer1.age : customer1.city);
//
// Jetzt: 
//  ShowCustomer(customer1);
//
// Also: 
//  customer1
//  |-- name
//  |-- age
//  |-- city
// -> Wird als zusammenhängender Datensatz an die Procedure übergeben
//
// -> Die Procedure sagt in ihrer Schnittstelle
//  customer likeds(Customer_t) const;
//
// -> Mein Parameter 'customer' muss genauso aufgabaut sein wie unser
//  Customer_t -Template
//
//
// Argument-/Parameter-Modell: 
//
//  customer1
//      |
//      | = Argument
//      |
//  ShowCustomer(customer1)
//      |
//      |
//  customer
//      |
//      | = Parameter
//      |
//      |--name
//      |--age
//      |--city
//
// Desweiteren: 
// CONST -> Die Procedure soll die uebergebene Kundenstruktur nur 
//          lesen und nicht die Parameter verändern.
//
// Vorteile: 
// Wenn die Structure später erweitert wird um z.B.: 
// - email varchar(30);
// - phone varchar(30);
// - customerNumber int(10);
//
// -> Der Aufruf bleibt trotzdem: 
//  ShowCustomer(customer1);
// 
// -> nicht: ShowCustomer(name : age : city : email : phone : ...)
// ==================================================================