**free

ctl-opt dftactgrp(*no);

// ==================================================================
// CUSTCRUD - Einfaches CRUD-Programm fuer Kundendaten
//
// Funktionen: 
// 1 = Kunden anzeigen
// 2 = Kunden anlegen
// 3 = Kunde aendern
// 4 = Kunde loeschen
// 5 = Programm beenden
//
// In diesem Programm werden kombiniert: 
// - Data Structures
// - Procedures
// - Eingabevalidierung
// - Embedded SQL
// - Cursor / FETCH
// - SQLCOD
// - INSERT / SELECT / UPDATE / DELETE
// ==================================================================


// Keine Transaktionssteuerung für die nicht journalisierte Tabelle
exec sql 
    set option commit = *none;


// ==================================================================
// Bauplan fuer einen Kunden
// ==================================================================

dcl-ds Customer_t qualified template;

    id int(10);
    name varchar(30);
    age int(10);
    city varchar(30);

end-ds;


// ==================================================================
// Procedure-Schnittstellen
// ==================================================================

dcl-pr ListCustomers;
end-pr;

dcl-pr AddCustomer;
end-pr;

dcl-pr UpdateCustomer;
end-pr;

dcl-pr DeleteCustomer;
end-pr;


// ==================================================================
// Variablen fuer das Hauptprogramm
// ==================================================================

dcl-s choice char(1);


// ==================================================================
// Hauptmenue
// ==================================================================

dou choice = '5';

    clear choice;

    dsply '==========================================';
    dsply '           KUNDENVERWALTUNG';
    dsply '==========================================';
    dsply ' 1 = Kunden anzeigen';
    dsply ' 2 = Kunde anlegen';
    dsply ' 3 = Kunde aendern';
    dsply ' 4 = Kunde loeschen';
    dsply ' 5 = Programm beenden';
    dsply '------------------------------------------';
    dsply ' Auswahl: ' '' choice;


    // --------------------------------------------------------------
    // Menue-Auswahl auswerten
    // --------------------------------------------------------------

    select;

        when choice = '1';
            ListCustomers();
        
        when choice = '2';
            AddCustomer();
        
        when choice = '3';
            UpdateCustomer();
        
        when choice = '4';
            DeleteCustomer();
        
        when choice = '5';
            dsply 'Programm wird beendet.';
        
        other;
            dsply 'Ungueltige Auswahl';
    
    endsl;

enddo;


return;


// ==================================================================
// Kunden anzeigen
// ==================================================================

dcl-proc ListCustomers;

    dcl-pi *n;
    end-pi;

    // dsply 'Kunden anzeigen:'; (Zwischenstand: I)

    // Zwischenstand: II
    // --------------------------------------------------------------
    // Lokaler Arbeitsbereich fuer einen Kunden
    // --------------------------------------------------------------

    dcl-ds customer likeds(Customer_t);


    // --------------------------------------------------------------
    // Dynamisches Array fuer alle geladenen Kunden
    // --------------------------------------------------------------

    dcl-ds customers likeds(Customer_t) dim(*auto : 100);


    // --------------------------------------------------------------
    // Lokale Variablen
    // --------------------------------------------------------------

    dcl-s i int(10);
    dcl-s answer char(1);


    // --------------------------------------------------------------
    // Cursor definieren
    // --------------------------------------------------------------

    exec sql 

        declare ListCursor cursor for 

            select  CUSTOMER_ID,
                    NAME,
                    AGE,
                    CITY
            from IBM4HUJER1.CUSTOMER 

            order by CUSTOMER_ID;
    

    // --------------------------------------------------------------
    // Array fuer diesen Aufruf zuruecksetzen
    // --------------------------------------------------------------

    %elem(customers) = 0;


    // --------------------------------------------------------------
    // Cursor oeffnen
    // --------------------------------------------------------------

    exec sql 

        open ListCursor;
    

    // --------------------------------------------------------------
    // OPEN pruefen
    // --------------------------------------------------------------

    if sqlcod = 0; 

        clear customer;


        // ..........................................................
        // Ersten Datensatz lesen
        // ..........................................................

        exec sql 

            fetch next from ListCursor

            into    :customer.id,
                    :customer.name,
                    :customer.age,
                    :customer.city;


        // ..........................................................
        // Datensatz ins DS-Array uebernehmen
        // ..........................................................

        dow sqlcod = 0;

            // RPG-Syntax: 
            // Ziel = Quelle
            customers(*next) = customer;

            clear customer;

            exec sql 

                fetch next from ListCursor

                into    :customer.id,
                        :customer.name,
                        :customer.age,
                        :customer.city;
        
        enddo;


        // ..........................................................
        // FETCH-Ergebnis pruefen
        // ..........................................................

        if sqlcod < 0;

            dsply ('SQL-Fehler beim Lesen: ' + %char(sqlcod));
        
        endif;


        // ..........................................................
        // Cursor schliessen
        // ..........................................................

        exec sql 

            close ListCursor;

        
        // ..........................................................
        // Geladene Kunden ausgeben
        // ..........................................................

        if %elem(customers) = 0;

            dsply 'Keine Kunden vorhanden.';

        else;

            dsply '==========================================';
            dsply '               Kundenliste';
            dsply '==========================================';

            for i = 1 to %elem(customers);

                dsply ('ID: ' + %char(customers(i).id));
                dsply ('Name: ' + customers(i).name);
                dsply ('Alter: ' + %char(customers(i).age));
                dsply ('Ort: ' + customers(i).city);
                dsply '------------------------------------------';
            
            endfor;
        
        endif;

    else;

        dsply ('Fehler beim Oeffnen des Cursors: ' + %char(sqlcod));

    endif;


    // --------------------------------------------------------------
    // Zurueck zum Hauptmenue
    // --------------------------------------------------------------

    dsply 'Weiter mit Enter!' '' answer;

end-proc;


// ==================================================================
// Kunde anlegen
// ==================================================================

dcl-proc AddCustomer;

    dcl-pi *n;
    end-pi;

    // dsply 'Kunde anlegen:'; (Zwischenstand: I)

    // Zwischenstand: II 
    // --------------------------------------------------------------
    // Arbeitsbereich fuer den neuen Kunden
    // --------------------------------------------------------------

    dcl-ds customer likeds(Customer_t);


    // --------------------------------------------------------------
    // Lokale Variablen
    // --------------------------------------------------------------

    dcl-s idInput varchar(10);
    dcl-s ageInput varchar(10);

    dcl-s existingId int(10);
    dcl-s invalidPos int(10);

    dcl-s validId ind inz(*off);
    dcl-s answer char(1);


    // --------------------------------------------------------------
    // Programmzustand zuruecksetzen
    // --------------------------------------------------------------

    clear customer;
    clear idInput;
    clear ageInput;

    validId = *off;


    // --------------------------------------------------------------
    // Kunden-ID eingeben und pruefen
    // --------------------------------------------------------------

    dou validId = *on;

        clear idInput;

        dsply 'Kunden-ID: ' '' idInput;

    
        // ..........................................................
        // Eingabe muss aus Ziffern bestehen
        // ..........................................................

        invalidPos = %check('0123456789' : %trim(idInput));

        if %len(%trim(idInput)) = 0;

            dsply 'ID darf nicht leer sein!';
        
        elseif invalidPos > 0;

            dsply 'ID darf nur Ziffern enthalten';
        
        else;

            customer.id = %int(%trim(idInput));


            // ......................................................
            // Pruefen, ob die ID bereits in Db2 vorhanden ist
            // ......................................................

            exec sql 

                select CUSTOMER_ID

                    into :existingId

                    from IBM4HUJER1.CUSTOMER 

                    where CUSTOMER_ID = :customer.id;
            

            if sqlcod = 100;

                // ID wurde nicht gefunden -> sie ist frei
                validId = *on;
            
            elseif sqlcod = 0;

                dsply 'Diese Kunden-ID existiert bereits!';
            

            else;

                dsply (
                    'SQL-Fehler bei der ID-Pruefung: '
                    + %char(sqlcod)
                );
            
            endif;
        
        endif;

    enddo;


    // --------------------------------------------------------------
    // Name eingeben und validieren
    // --------------------------------------------------------------

    dou %len(%trim(customer.name)) > 0;

        dsply 'Name: ' '' customer.name;

        if %len(%trim(customer.name)) = 0;

            dsply 'Name darf nicht leer sein!';
        
        endif;
    
    enddo;


    // --------------------------------------------------------------
    // Alter eingeben und validieren
    // --------------------------------------------------------------

    dou customer.age >= 0 and customer.age <= 130

        and %len(%trim(ageInput)) > 0;

        clear ageInput;

        dsply 'Alter: ' '' ageInput;

        invalidPos = %check('0123456789' : %trim(ageInput));

        
        if %len(%trim(ageInput)) = 0;

            dsply 'Alter darf nicht leer sein!';
        

        elseif invalidPos > 0;

            dsply 'Alter darf nur Ziffern enthalten!';
        

        else;

            customer.age = %int(%trim(ageInput));
        
            if customer.age < 0 or customer.age > 130;

                dsply 'Alter muss zwischen 0 und 130 liegen!';
            
            endif;
        
        endif;
    
    enddo;


    // --------------------------------------------------------------
    // Ort eingeben und validieren
    // --------------------------------------------------------------

    dou %len(%trim(customer.city)) > 0;

        dsply 'Ort: ' '' customer.city;
    
        if %len(%trim(customer.city)) = 0;

            dsply 'Ort darf nicht leer sein!';
        
        endif;
    
    enddo;


    // --------------------------------------------------------------
    // Gueltigen Kunden in Db2 speichern
    // --------------------------------------------------------------

    exec sql 

        insert into IBM4HUJER1.CUSTOMER (
            CUSTOMER_ID,
            NAME,
            AGE,
            CITY
        )

        values (
            :customer.id,
            :customer.name,
            :customer.age,
            :customer.city
        );
    
    // --------------------------------------------------------------
    // INSERT-Ergebnis pruefen
    // --------------------------------------------------------------

    if sqlcod = 0;

        dsply 'Kunde wurde gespeichert.';
    
    elseif sqlcod = -803;

        // Kann trotz vorheriger ID-Pruefung bei gleichzeitigem
        // Zugriff eines anderen Benutzers auftreten.
        dsply 'Kunden-ID existiert bereits!';
    
    else;

        dsply ('SQL-Fehler beim Speichern: ' + %char(sqlcod));
    
    endif;


    // --------------------------------------------------------------
    // Zurueck zum Hauptmenue
    // --------------------------------------------------------------

    dsply 'Weiter mit Enter!' '' answer;


end-proc;


// ==================================================================
// Kunde aendern
// ==================================================================

dcl-proc UpdateCustomer;

    dcl-pi *n;
    end-pi;

    // dsply 'Kunde aendern:'; (Zwischenstand: I)
    // --------------------------------------------------------------
    // Arbeitsbereich fuer den Kunden
    // --------------------------------------------------------------

    dcl-ds customer likeds(Customer_t);


    // --------------------------------------------------------------
    // Lokale Variablen
    // --------------------------------------------------------------

    dcl-s idInput varchar(10);
    dcl-s ageInput varchar(10);

    dcl-s invalidPos int(10);

    dcl-s validId ind inz(*off);
    dcl-s answer char(1);

    dcl-s confirm char(1);


    // --------------------------------------------------------------
    // Programmzustand zuruecksetzen
    // --------------------------------------------------------------

    clear customer;
    clear idInput;
    clear ageInput;

    validId = *off;


    // --------------------------------------------------------------
    // Kunden-ID eingeben und vorhandenen Kunden suchen
    // --------------------------------------------------------------

    dou validId = *on;

        clear idInput;

        dsply 'Kunden-ID: ' '' idInput;

        invalidPos = %check('0123456789' : %trim(idInput));


        if %len(%trim(idInput)) = 0;

            dsply 'ID darf nicht leer sein!';
        

        elseif invalidPos > 0;

            dsply 'ID darf nur Ziffern enthalten!';
        

        else;

            customer.id = %int(%trim(idInput));


            // ......................................................
            // Kundendaten aus Db2 laden
            // ......................................................

            exec sql 

                select  NAME,
                        AGE,
                        CITY
                
                into   :customer.name,
                        :customer.age,
                        :customer.city
                
                from IBM4HUJER1.CUSTOMER 

                where CUSTOMER_ID = :customer.id;
            

            if sqlcod = 0;

                validId = *on;
            
            elseif sqlcod = 100;

                dsply 'Kunde wurde nicht gefunden!';
            
            endif;

        endif;

    enddo;


    // --------------------------------------------------------------
    // Aktuelle Kundendaten anzeigen
    // --------------------------------------------------------------

    dsply '------------------------------------------';
    dsply 'Aktuelle Kundendaten:';
    dsply ('ID: ' + %char(customer.id));
    dsply ('Name: ' + customer.name);
    dsply ('Alter: ' + %char(customer.age));
    dsply ('Ort: ' + customer.city);
    dsply '------------------------------------------';


    // --------------------------------------------------------------
    // Abfrage Aenderungen vornehmen oder abbrechen
    // --------------------------------------------------------------

    clear confirm;

    dou confirm = 'J' or confirm = 'N';

        dsply 'Kunden aendern? J/N' '' confirm;

        confirm = %upper(confirm);

        if confirm <> 'J' and confirm <> 'N';

            dsply 'Bitte J oder N eingeben!';
        
        endif;
    
    enddo;

    if confirm = 'N';

        dsply 'Aenderung abgebrochen.';
        return;
    
    endif;


    // --------------------------------------------------------------
    // Neuen Namen eingeben
    // --------------------------------------------------------------

    clear customer.name;

    dou %len(%trim(customer.name)) > 0;

        dsply 'Neuer Name: ' '' customer.name;

        if %len(%trim(customer.name)) = 0;

            dsply 'Name darf nicht leer sein!';
        
        endif;

    enddo;


    // --------------------------------------------------------------
    // Neues Alter eingeben
    // --------------------------------------------------------------

    clear ageInput;

    dou %len(%trim(ageInput)) > 0
        and invalidPos = 0
        and customer.age >= 0
        and customer.age <= 130;

        clear ageInput;
        invalidPos = 0;

        dsply 'Neues Alter: ' '' ageInput;

        invalidPos = %check('0123456789' : %trim(ageInput));


        if %len(%trim(ageInput)) = 0;

            dsply 'Alter darf nicht leer sein!';
        
        elseif invalidPos > 0;

            dsply 'Alter darf nur Ziffern enthalten!';
        
        else;

            customer.age = %int(%trim(ageInput));

            if customer.age < 0 or customer.age > 130;

                dsply 'Alter muss zwischen 0 und 130 liegen!';
            
            endif;
        
        endif;
    
    enddo;


    // --------------------------------------------------------------
    // Neuen Ort eingeben
    // --------------------------------------------------------------

    clear customer.city;

    dou %len(%trim(customer.city)) > 0;

        dsply 'Neuer Ort: ' '' customer.city;

        if %len(%trim(customer.city)) = 0;

            dsply 'Ort darf nicht leer sein!';
        
        endif;
    
    enddo;


    // --------------------------------------------------------------
    // Datensatz in Db2 aktualisieren
    // --------------------------------------------------------------

    exec sql 

        update IBM4HUJER1.CUSTOMER 

            set NAME =  :customer.name,
                AGE =   :customer.age,
                CITY =  :customer.city

        where CUSTOMER_ID = :customer.id;
    

    // --------------------------------------------------------------
    // UPDATE-Ergebnis pruefen
    // --------------------------------------------------------------

    if sqlcod = 0;

        dsply 'Kunde wurde aktualisiert!';
    
    elseif sqlcod = 100;

        dsply 'Kunde wurde nicht gefunden.';
    
    else;

        dsply ('SQL-Fehler beim Update: ' + %char(sqlcod));
    
    endif;


    // --------------------------------------------------------------
    // Zurueck zum Hauptprogramm
    // --------------------------------------------------------------

    dsply 'Weiter mit Enter!' '' answer;


end-proc;


// ==================================================================
// Kunde loeschen
// ==================================================================

dcl-proc DeleteCustomer;

    dcl-pi *n;
    end-pi;

    // dsply 'Kunde loeschen:'; (Zwischenstand: I)
    // --------------------------------------------------------------
    // Arbeitsbereich fuer den Kunden
    // --------------------------------------------------------------

    dcl-ds customer likeds(Customer_t);


    // --------------------------------------------------------------
    // Lokale Variablen
    // --------------------------------------------------------------

    dcl-s idInput varchar(10);
    dcl-s invalidPos int(10);

    dcl-s validId ind inz(*off);
    dcl-s confirm char(1);
    dcl-s answer char(1);


    // --------------------------------------------------------------
    // Programmzustand zuruecksetzen
    // --------------------------------------------------------------

    clear customer;
    clear idInput;
    clear confirm;

    validId = *off;


    // --------------------------------------------------------------
    // Kunden-ID eingeben und vorhandenen Kunden suchen
    // --------------------------------------------------------------

    dou validId = *on;

        clear idInput;

        dsply 'Kunden-ID: ' '' idInput;

        invalidPos = %check('0123456789' : %trim(idInput));


        if %len(%trim(idInput)) = 0;

            dsply 'ID darf nicht leer sein!';
        
        elseif invalidPos > 0;

            dsply 'ID darf nur Ziffern enthalten!';
        
        else;

            customer.id = %int(%trim(idInput));


            // ......................................................
            // Kundendaten aus Db2 laden
            // ......................................................

            exec sql 

                select  NAME,
                        AGE,
                        CITY
                
                into    :customer.name,
                        :customer.age,
                        :customer.city
                
                from IBM4HUJER1.CUSTOMER 

                where CUSTOMER_ID = :customer.id;
            

            if sqlcod = 0;

                validId = *on;
            
            elseif sqlcod = 100;

                dsply 'Kunde wurde nicht gefunden!';
            
            else;

                dsply (
                    'SQL-Fehler bei Kundensuche: ' 
                    + %char(sqlcod)
                );

                return;
            
            endif;
        
        endif;
    
    enddo;


    // --------------------------------------------------------------
    // Kundendaten vor dem Loeschen anzeigen
    // --------------------------------------------------------------

    dsply '------------------------------------------';
    dsply 'Kunde wird zum Loeschen ausgewaehlt:';
    dsply ('ID: ' + %char(customer.id));
    dsply ('Name: ' + customer.name);
    dsply ('Alter: ' + %char(customer.age));
    dsply ('Ort: ' + customer.city);
    dsply '------------------------------------------';


    // --------------------------------------------------------------
    // Loeschen bestaetigen oder abbrechen
    // --------------------------------------------------------------

    clear confirm;

    dou confirm = 'J' or confirm = 'N';

        dsply 'Kunde wirklich loeschen? J/N' '' confirm;

        confirm = %upper(confirm);

        if confirm <> 'J' and confirm <> 'N';

            dsply 'Bitte J oder N eingeben!';

        endif;

    enddo;


    // --------------------------------------------------------------
    // Loeschen abbrechen
    // --------------------------------------------------------------

    if confirm = 'N';

        dsply 'Loeschen abgebrochen.';

        return;

    endif;


    // --------------------------------------------------------------
    // Datensatz aus Db2 loeschen
    // --------------------------------------------------------------

    exec sql 

        delete from IBM4HUJER1.CUSTOMER 

        where CUSTOMER_ID = :customer.id;


    // --------------------------------------------------------------
    // DELETE-Ergebnis pruefen
    // --------------------------------------------------------------

    if sqlcod = 0;

        dsply 'Kunde wurde geloescht.';

    elseif sqlcod = 100;

        dsply 'Kunde wurde nicht gefunden.';

    else;

        dsply ('SQL-Fehler beim Loeschen: ' + %char(sqlcod));

    endif;


    // --------------------------------------------------------------
    // Zurueck ins Hauptprogramm
    // --------------------------------------------------------------

    dsply 'Weiter mit Enter!' '' answer;


end-proc;


// ==================================================================
// Zwischenstand: I
// ------------------------------------------------------------------
//
// Neu, Anwendungsmenue mit RPG-Baustein
//  select;
//      when choice = '1';
//          ListCustomers();
//      when choice = '2';
//          AddCustomer();
//
//      other;
//          dsply 'Ungueltige Auswahl!'
//  endsl;
//
// Gesamtstruktur:
//
//              CUSTCRUD
//                  |
//              Hauptmenue
//                  |
//  +---------------+-----------+
//  |               |           |
// Anzeigen     Anlegen     Aendern     Loeschen
//  |               |           |           |
// Procedure    Procedure   Procedure   Procedure
//  |               |           |           |
//  Db2             Db2         Db2         Db2
//
// ==================================================================
// Zwischenstand: II
// ------------------------------------------------------------------
//  
// Menuepunkt 1 - ListCustomers()
//  
// Db2 CUSTOMER
//  |
//  | Cursor/FETCH
//  |
// customer DS
//  |
//  | Ziel = Quelle
//  |
// customers(*next)
//  |
//  |
//  dynamisches DS-Array
//  | 
//  | FOR - Schleife durchlaufen
//  |
// Ausgabe im Terminal
//
// Nach ENTER Zurück ins Hauptmenue.
// ==================================================================
// Zwischenstand: III
// ------------------------------------------------------------------
// 
// Menuepunkt 2 - AddCustomer()
//
// Neuer Kunde wird ueber RPG erfasst und nach Db2 geschrieben.
//
// Ablauf: 
//
// Kunden-ID eingeben
//  |
//  | Eingabe pruefen
//  |
// SELECT CUSTOMER_ID
//  |
//  | SQLCOD auswerten
//  |
//  +-- SQLCOD = 0
//  |       |
//  |       +-> ID existiert bereits
//  |           -> neue ID eingeben
//  |
//  +-- SQLCOD = 100
//          |
//          +-> ID ist frei
//              |
//          Name/Alter/City
//              |
//              | Eingaben validieren
//              |
//          customer DS
//              |
//              | INSERT
//              |
//          Db2 CUSTOMER-Tabelle
//              |
//              | SQLCOD pruefen
//              |
//          Kunde wurde gespeichert
//              |
//          Zurueck zum Hauptmenue
//
//
// Wichtige Punkte:
// 
// - Die Kunden-ID dient als eindeutiger PRIMARY KEY.
// - Vor der weiteren Eingabe wird geprueft, ob die ID vorhanden ist.
//
// - SQLCOD = 0 bei der ID-Pruefung: 
//      Datensatz gefunden -> ID bereits vergeben.
//
// - SQLCOD = 100 bei der ID-Pruefung: 
//      Kein Datensatz gefunden -> ID ist noch frei.
//
// - Name und Ort duerfen nicht leer sein.
// - Alter muss aus Ziffern bestehen und zwischen 0 und 130 liegen.
// - Erst wenn alle Eingaben gueltig sind, wird INSERT ausgefuehrt.
//
// - SQLCOD = -803 beim INSERT: 
//      PRIMARY KEY bereits vorhanden.
//      Diese Pruefung bleibt als letzte Sicherung bestehen,
//      auch wenn die ID vorher bereits geprueft wurde.
//
//
// Datenfluss: 
//
// Benutzereingabe
//  |
// customer Data Structure
//  |
//  | Host Variables
//  |
// INSERT INTO CUSTOMER
//  |
// Db2
// ==================================================================
// Zwischenstand: IV
// ------------------------------------------------------------------
//
// Menuepunkt 3 - UpdateCustomer()
//
// Ein bestehender Kunde wird über seine ID aus Db2 geladen,
// angezeigt und kann anschliessend geaendert werden.
//
// Ablauf: 
//
// Kunden-ID eingeben
//      |
//      | Eingabe pruefen
//      |
// SELECT Kundendaten
//      |
//      | SQLCOD auswerten
//      |
//      +-- SQLCOD = 100
//      |       |
//      |       -> Kunde nicht gefunden
//      |          -> neue ID eingeben
//      |
//      +-- SQLCOD = 0
//              |
//              -> Kunde gefunden
//                   |
//          aktuelle Daten anzeigen
//                   |
//          Aendern? J/N
//              /         \
//             N           J
//             |           |
//          Abbruch    neue Daten eingeben
//                         |
//                         | Eingaben validieren
//                         |
//                    customer DS
//                         |
//                         | UPDATE
//                         |
//                Db2 CUSTOMER-Tabelle
//                         |
//                         | SQLCOD pruefen
//                         |
//                Kunde wurde aktualisiert
//                         |
//                Zurueck zum Hauptmenue
//
// Wichtige Punkte: 
// - Der bestehende Kunde wird zuerst ueber SELECT aus Db2 gelesen.
//
// - SQLCOD = 0: 
//      -> Kunde wurde gefunden.
//
// - SQLCOD = 100: 
//      -> Kein Kunde mit dieser ID vorhanden.
//
// - Die aktuellen Kundendaten werden vor der Aenderung angezeigt.
// 
// - Mit J/N kann der Benutzer entscheiden, ob eine Aenderung 
//   durchgefuehrt werden soll.
// 
// - Bei N wird die Procedure mit RETURN verlassen.
//   Danach geht es zurueck zum Hauptmenue.
//
// - Bei J muessen Name, Alter und Ort neu eingegeben werden.
//
// - Name und Ort duerfen nicht leer sein.
// - Alter muss aus Ziffern bestehen und zwischen 0 und 130 liegen.
// 
// - Erst nach erfolgreicher Validierung wird UPDATE ausgefuehrt.
//
//
// Datenfluss: 
//
// Db2 CUSTOMER
//      |
//      | SELECT
//      |
// customer Data Structure
//      |
//      | Benutzer aendert Werte
//      |
// customer Data Structure
//      |
//      | Host Variables / UPDATE
//      |
// Db2 CUSTOMER
//
// ==================================================================
// Zwischenstand: V
// ------------------------------------------------------------------
//
// Menuepunkt 4 - DeleteCustomer()
//
// Ein bestehender Kunde wird ueber seine ID aus Db2 geladen, 
// angezeigt und nach ausdrücklicher Bestaetigung geloescht.
//
// Ablauf: 
// 
// Kunden-ID eingeben
//      |
//      | Eingabe pruefen
//      |
// SELECT Kundendaten
//      |
//      | SQLCOD auswerten
//      |
//      +-- SQLCOD = 100
//      |       |
//      |       -> Kunde nicht gefunden
//      |          -> neue ID eingeben
//      |
//      +-- SQLCOD = 0
//              |
//              -> Kunde gefunden
//                   |
//          aktuelle Daten anzeigen
//                   |
//        Wirklich loeschen? J/N
//              /         \
//             N           J
//             |           |
//          Abbruch      DELETE
//                         |
//                Db2 CUSTOMER-Tabelle
//                         |
//                         | SQLCOD pruefen
//                         |
//                Kunde wurde geloescht
//                         |
//                Zurueck zum Hauptmenue
//
// Wichtige Punkte: 
// - Der Kunde wird vor dem Loeschen ueber SELECT geladen.
//
// - SQLCOD = 0: 
//      Kunde wurde gefunden.
//
// - SQLCOD = 100: 
//      Kein Kunde mit dieser ID vorhanden.
//
// - Die aktuellen Kundendaten werden vor dem Loeschen angezeigt.
//
// - Mit J/N muss das Loeschen bestaetigt werden.
//
// - Bei N wird die Procedure mit RETURN verlassen.
//   Der Datensatz bleibt unverändert.
//
// - Bei J wird DELETE ausgeführt.
//
// - WHERE CUSTOMER_ID = :customer.id stellt sicher,
//   dass nur der ausgewählte Datensatz geloescht wird.
//
// Datenfluss: 
//
// Db2 CUSTOMER
//      |
//      | SELECT
//      |
// customer Data Structure
//      |
//      | Benutzer bestaetigt Loeschen
//      |
// DELETE FROM CUSTOMER
//      |
//     Db2
//
// ==================================================================