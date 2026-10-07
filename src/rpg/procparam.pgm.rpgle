**free

// Hauptprogramm mit Procedure-Aufrufen (*no)
ctl-opt dftactgrp(*no);

// ==================================================================
// PROCEDURE - Beispiel 2: Procedure mit Parameter
//
// Aufbau: 
// - Wert vom Hauptprogramm an eine Procedure uebergeben
// - DCL-PR und DCL-PI mit Parameter verstehen
//
// Python-Vergleich: 
//
//  def show_message(name): 
//      print(f'Hallo {name}')
//
//  show_message('IBM4HUJER')
// ==================================================================


// Prototyp: 
// Die Procedure erwartet einen VARCHAR-Parameter.
dcl-pr ShowMessage;
    name varchar(30) const;
end-pr;


dcl-s answer char(1);


// Hauptprogramm
dsply 'Hauptprogramm startet';

ShowMessage('IBM4HUJER');

dsply 'Zurueck im Hauptprogramm';

dsply 'Weiter mit Enter' '' answer;


return;


// ==================================================================
// Procedure
// ==================================================================

dcl-proc ShowMessage;

    // Procedure Interface: 
    // Hier kommt der Parameter tatsächlich in der Procedure an.
    // dcl-pi = declare Procedure Interface
    // *n (*N) = no name; kein erneut angegebener Procdurename
    // -> dcl-pi ShowMessage;
    dcl-pi *n;
        // const = Schreibschutz
        name varchar(30) const;
    end-pi;

    dsply ('Hallo ' + name);

end-proc;


// ==================================================================
// Grundprinzip - Hauptprogramm
//
// DCL-PR
// = Procedure Prototype
// = Schnittstelle aus Sicht des Aufrufers
//
// DCL-PI
// = Procedure Interface
// = Schnittstelle innerhalb der Procedure
// ==================================================================