**free

ctl-opt dftactgrp(*no);

// ==================================================================
// DSARRPROC - Array-Element an Procedure uebergeben
//
// Ablauf: 
// - Array von Data Structure durchlaufen
// - einzelnes Array-Element als Argument uebergeben
// - Data Structure in einer Procedure verarbeiten
//
// Datenfluss: 
//
// customers(i) -> ShowCustomer(customers(i)) -> Parameter customer
// ( + name + age + city )
// ==================================================================


// Bauplan, Template für einen Kunden
dcl-ds Customer_t qualified template;
    name varchar(30);
    age int(10);
    city varchar(30);
end-ds;


// Procedure-Schnittstelle
dcl-pr Showcustomer;
    customer likeds(Customer_t) const;
end-pr;


// Array mit drei Kunden
dcl-ds customers likeds(Customer_t) dim(3);


dcl-s i int(10);
dcl-s answer char(1);


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


// Alle Array-Elemente vom ersten bis zum letzten durchlaufen
for i = 1 to %elem(customers);

    // Das aktuelle Array-Element als Argument uebergeben
    ShowCustomer(customers(i));

endfor;


dsply 'Weiter mit Enter' '' answer;

return;


// ==================================================================
// Einen Kunden ausgeben
// ==================================================================

dcl-proc Showcustomer;

    dcl-pi *n;
        customer likeds(Customer_t) const;
    end-pi;

    dsply ('Name: ' + customer.name);
    dsply ('Alter: ' + %char(customer.age));
    dsply ('Ort: ' + customer.city);

end-proc;


// ==================================================================
// Merksatz: 
//
// Parameter = Platzhalter in der Procedure (Fragebogenfeld)
// Argument = Wert an der Aufrufstelle (Wert im Feld)
//
//
//  ShowCustomer(customer(i));
//                  |
//               Argument
//
//  dcl-pi *n;
//      customer likeds(Customer_t) const;
//          |
//      Parameter
//  end-pi;
//
// ==================================================================

