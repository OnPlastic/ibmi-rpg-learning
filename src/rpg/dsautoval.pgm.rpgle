**free

ctl-opt dftactgrp(*no);

// ==================================================================
// DSAUTOVAL - Dynamisches DS-Array mit Eingabevalidierung
//
// Aufbau: 
// - Name darf nicht leer sein
// - Alter wird zuerst als Text eingelesen
// - Alter wird auf Ziffern und Wertbereich geprueft
// - Ort darf nicht leer sein
// - J/N-Eingabe wird validiert
// - erst danach wird der Kunde ins Array geschrieben
// ==================================================================


// Bauplan
dcl-ds Customer_t qualified template;
    name varchar(30);
    age int(10);
    city varchar(30);
end-ds;


// Procedure-Schnittstelle
dcl-pr ShowCustomer;
    customer likeds(Customer_t) const;
end-pr;


// Dynamisches Array, maximal 100 Kunden
dcl-ds customers likeds(Customer_t)
    dim(*auto : 100);


// Arbeitsbereich fuer einen neuen Kunden
dcl-ds newCustomer likeds(Customer_t);


// Alter zuerst als Text einlesen
dcl-s ageInput varchar(10);
dcl-s invalidPos int(10);


dcl-s another char(1) inz('J');
dcl-s i int(10);
dcl-s answer char(1);


// ==================================================================
// Programmzustand fuer diesen Aufruf zurücksetzen
// ==================================================================

%elem(customers) = 0;
another = 'J';


// ==================================================================
// Kunden erfassen
// ==================================================================

dou another = 'N';

    clear newCustomer;


    // ==============================================================
    // Name validieren
    // ==============================================================

    dou %len(%trim(newCustomer.name)) > 0;

        dsply 'Name: ' '' newCustomer.name;

        if %len(%trim(newCustomer.name)) = 0;

            dsply 'Name darf nicht leer sein!';

        endif;

    enddo;


    // ==============================================================
    // Alter validieren
    // ==============================================================

    clear ageInput;
    invalidPos = 0;

    dou %len(%trim(ageInput)) > 0
        and invalidPos = 0
        and %len(%trim(ageInput)) <= 3;

        dsply 'Alter: ' '' ageInput;

        invalidPos = %check('0123456789' : %trim(ageInput));
        
        if %len(%trim(ageInput)) = 0;

            dsply 'Alter darf nicht leer sein!';
        
        elseif invalidPos > 0;

            dsply ('Ungueltiges Zeichen an Stelle ' 
                + %char(invalidPos));
        
        elseif %len(%trim(ageInput)) > 3;

            dsply 'Alter darf maximal 3 Ziffern haben!';
        
        else;

            newCustomer.age = %int(%trim(ageInput));

            if newCustomer.age > 130;

                dsply 'Alter muss zwischen 0 und 130 liegen';
                clear ageInput;

            endif;

        endif;

    enddo;


    // ==============================================================
    // Ort Validieren
    // ==============================================================

    dou %len(%trim(newCustomer.city)) > 0;

        dsply 'Ort: ' '' newCustomer.city;

        if %len(%trim(newCustomer.city)) = 0;

            dsply 'Ort darf nicht leer sein!';
        
        endif;

    enddo;


    // ==============================================================
    // Erst jetzt ist der Kunde gueltig
    // ==============================================================

    customers(*next) = newCustomer;

    dsply ('Anzahl Kunden: ' + %char(%elem(customers)));


    // ==============================================================
    // J/N Validieren
    // ==============================================================

    dou another = 'J' or another = 'N';

        dsply 'Weiteren Kunden eingeben? J/N' '' another;

        another = %upper(another);

        if another <> 'J' and another <> 'N';

            dsply 'Bitte J oder N eingeben!';
        
        endif;
    
    enddo;

enddo;


// ==================================================================
// Alle Kunden ausgeben
// ==================================================================

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

    dsply ('Name: ' + customer.name);
    dsply ('Alter: ' + %char(customer.age));
    dsply ('Ort: ' + customer.city);

end-proc;