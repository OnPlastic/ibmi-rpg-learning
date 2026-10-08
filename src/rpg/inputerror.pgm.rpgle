**free

ctl-opt dftactgrp(*yes);

// ==================================================================
// INPUTERROR - Laufzeitfehler bei Eingabe abfangen
//
// Ablauf: 
// - MONITOR / ON-ERROR / ENDMON
// - Unterschied zwischen Validierung und Fehlerbehandlung
// - fehlerhafte Umwandlung mit %INT() kontrolliert behandeln
//
// Python-Vergleich: 
//
//  try: 
//      number = int(user_input)
//      print(f'Gueltige Zahl: {number}')
//  except ValueError: 
//      print('Fehler beim Umwandeln der Eingabe')
// ==================================================================


dcl-s input char(20);
dcl-s number int(10);
dcl-s answer char(1);

// Prompt anzeigen und Antwort in input speichern
dsply 'Positive ganze Zahl:' '' input;


// Diesen Code auf Laufzeitfehler ueberwachen.
monitor;

    number = %int(%trim(input));

    dsply ('Gueltige Zahl: ' + %char(number));


// Wird ausgefuehrt, wenn im MONITOR-Block ein Fehler auftritt
on-error;

    dsply 'Fehler beim Umwandeln der Eingabe';

endmon;


dsply 'Weiter mit Enter' '' answer;


return;


// ==================================================================
// Grundprinzip - Hauptprogramm
// 
// monitor;
//  number = %int(%trim(input));
// on-error;
//  dsply 'Fehler beim Umwandeln'
// endmon;
//
//
// Unterschied zu Inputvalidation: 
//
// INPUTVALID / INPUTRETRY
//
// "Kann ich vorher feststellen, dass die Eingabe faslch ist?"
//
// 234r5
// -> %CHECK erkennt das r
// -> %INT wird gar nicht ausgeführt
//
//
// INPUTERROR
//
// "Die Eingabe wird einfach durchgereicht und die Fehler,
//  welche möglicherweise entstehen behandelt."
//
// 234r5
// -> %INT versucht die Umwandlung zur Zahl
// -> Laufzeitfehler
// -> ON-ERROR übernimmt
// ==================================================================
