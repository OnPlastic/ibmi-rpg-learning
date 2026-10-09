**free

ctl-opt dftactgrp(*no);

// ==================================================================
// DSFILTER - Array von Data Structures filtern
//
// Aufbau: 
// - Array mit FOR durchlaufen
// - Feld einer Data Structure pruefen
// - nur passende Elemente weiterverarbeiten
// - bestehende Procedure wiederverwenden
//
//
// Python-Vergleich
//
//  for customer in customers: 
//      if customer.age > 40: 
//          show_customer(customer)
// ==================================================================


// Bauplan fuer einen Kunden
dcl-ds Customer_t qualified template;
    name varchar(30);
    age int(10);
    city varchar(30);
end-ds;

// Procedure-Schnittstelle
dcl-pr ShowCustomer;
    customer likeds(Customer_t) const;
end-pr;

// Array mit drei Kunden
dcl-ds customers likeds(Customer_t) dim(3);

dcl-s i int(10);
dcl-s answer char(10);

// Daten fuellen
customers(1).name = 'Max Mustermann';
customers(1).age = 42;
customers(1).city = 'Nuernberg';

customers(2).name = 'Anna Beispiel';
customers(2).age = 35;
customers(2).city = 'Bayreuth';

customers(3).name = 'Peter Muster';
customers(3).age = 51;
customers(3).city = 'Bamberg';

// Alle Array-Elemente durchlaufen
for i = 1 to %elem(customers);

    // Nur Kunden ausgeben, die älter als 40 sind
    if customers(i).age > 40;

        ShowCustomer(customers(i));
    
    endif;

endfor;

dsply 'Weiter mit Enter' '' answer;

return;


// ==================================================================
// Kunden ausgeben
// ==================================================================

dcl-proc ShowCustomer;

    dcl-pi *n;
        customer likeds(Customer_t) const;
    end-pi;

    dsply ('Name: ' + customer.name);
    dsply ('Alter: ' + %char(customer.age));
    dsply ('Ort: ' + customer.city);

end-proc;


// ==================================================================
// Erklaerungen:
//
// Kombination aus mehreren Konzepten ->
// Data Structure
// + Array
// + Index
// + FOR 
// + IF
// + Procedure
//
// Im obigen Beispiel -> Ergebnis:
// Name: Max
// Alter: 42
// Ort: Nuernberg
// Name: Peter
// Alter: 51
// Ort: Bamberg
// ==================================================================


