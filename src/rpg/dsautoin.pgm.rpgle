**free

ctl-opt dftactgrp(*no);

// ==================================================================
// DSAUTOIN - Dynamisches DS-Array mit Benutzereingabe
//
// Aufbau: 
// - Array startet mit 0 Elementen
// - Benutzer gibt Kundendaten ein
// - Kunde wird mit *NEXT an das Array angehängt
// - am Ende werden alle Kunden ausgegeben
//
// Noch keine Eingabevalidierung!
// - Diese wird nach erfolgreichem Grundtest nachgeruestet
//
// Python-Vergleich: 
//
//  customers = []
//  customer.append(new_customer)
// ==================================================================


// Bauplan für einen Kunden
dcl-ds Customer_t qualified template;
    name varchar(30);
    age int(10);
    city varchar(30);
end-ds;


// Procedure-Schnittstelle
dcl-pr ShowCustomer;
    customer likeds(Customer_t) const;
end-pr;


// Dynamisches Array
// - Aktuelle Groesse startet bei 0
// - Das Array kann automatisch wachsen
// - 100 ist die maximale Anzahl von Elementen
dcl-ds customers likeds(Customer_t) dim(*auto : 100);


// Zwischenspeicher fuer einen neu eingegebenen Kunden
dcl-ds newCustomer likeds(Customer_t);


dcl-s another char(1) inz('J');
dcl-s i int(10);
dcl-s answer char(1);


// ==================================================================
// Kunden erfassen
// ==================================================================

dou another <> 'J';

    // Zwischenspeicher vor jeder neuen Eingabe leeren
    clear newCustomer;

    dsply 'Name: ' '' newCustomer.name;
    dsply 'Alter: ' '' newCustomer.age;
    dsply 'Ort: ' '' newCustomer.city;

    // Neuen Kunden an das Array anhaengen
    customers(*next) = newCustomer;

    dsply ('Anzahl Kunden: ' + %char(%elem(customers)));

    dsply 'Weiteren Kunden eingeben? J/N' '' another;

endou;


// ==================================================================
// Alle gespeicherten Kunden ausgeben
// ==================================================================

dsply '---KUNDENLISTE---';

for i = 1 to %elem(customers);

    ShowCustomer(customers(i));

endfor;


dsply 'Weiter mit Enter' '' answer;


return;


// ==================================================================
// Einen Kunden ausgeben
// ==================================================================

dcl-proc ShowCustomer;

    dcl-pi *n;
        customer likeds(Customer_t) const;
    end-pi;

    dsply ('Name: ' +customer.name);
    dsply ('Alter: ' + %char(customer.age));
    dsply ('Ort: ' + customer.city);

end-proc;
 