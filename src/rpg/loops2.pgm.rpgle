**free

// ==================================================================
// Beispiel 2: DOW-Schleife
//
// DOW = Do While
// Die Bedingung wird VOR jedem Durchlauf geprüft.
//
// Python-Vergleich:
//  counter = 1
//  While counter <= 5
//      print(f'Durchlauf: {counter}')
//      counter +=1
// ==================================================================

dcl-s counter int(10) inz(1);

dcl-s answer char(1);


dsply 'DOW-Schleife startet';

dow counter <= 5;

    dsply ('Durchlauf: ' + %char(counter));

    // Bei DOW muessen wir den Zaehler selbst veraendern.
    counter = counter + 1;

enddo;


dsply 'DOW-Schleife beendet';

dsply 'Weiter mit enter ' '' answer;

return;

// ==================================================================
// Wichtigster Unterschied zu FOR ist:
//
// FOR -> Schleifenzähler wird automatisch verwaltet
// DOW -> du veränderst den counter selbst
// DOW -> prüft die Bedingung vor dem Schleifendurchlauf
// Bsp.: dcl-s counter int(10) inz(6);
// -> Schleifenrumpf wird kein einziges Mal ausgeführt.
// ==================================================================
