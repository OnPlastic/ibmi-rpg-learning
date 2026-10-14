**free

ctl-opt dftactgrp(*yes);

// ==================================================================
// DSSORT - Data Structure-Array sortieren
//
// Neue Konzepte: 
// - SORTA = Array sortieren
// - SORTA(A) = aufsteigend(ascending)
// - SORTA(D) = absteigend(descending)
// - bei DS-Arrays wird das Sortierfeld angegeben
// ==================================================================


// Bauplan
dcl-ds Customer_t qualified template;
    name varchar(30);
    age int(10);
    city varchar(30);
end-ds;


// Kunden-Array
dcl-ds customers likeds(Customer_t) dim(3);


dcl-s i int(10);
dcl-s answer char(1);


// ==================================================================
// Beispieldaten bewusst unsortiert
// ==================================================================

customers(1).name = 'Peter';
customers(1).age = 51;
customers(1).city = 'Bamberg';

customers(2).name = 'Anna';
customers(2).age = 35;
customers(2).city = 'Bayreuth';

customers(3).name = 'Max';
customers(3).age = 42;
customers(3).city = 'Nuernberg';


// ==================================================================
// Vor dem Sortieren
// ==================================================================

dsply 'Vor dem Sortieren:';

for i = 1 to %elem(customers);

    dsply customers(i).name;

endfor;


// ==================================================================
// Nach Name aufsteigend sortieren
// ==================================================================

sorta(a) customers(*).name;


// ==================================================================
// Nach dem Sortieren
// ==================================================================

dsply 'Nach dem Sortieren:';

for i = 1 to %elem(customers);

    dsply customers(i).name;

endfor;


dsply 'Weiter mit Enter' '' answer;


return;