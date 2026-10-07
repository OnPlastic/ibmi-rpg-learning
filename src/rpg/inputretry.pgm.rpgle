**free

// Einfaches Hauptprogramm ohne eigene Procedures (*yes)
ctl-opt dftactgrp(*yes);

// ==================================================================
// INPUTRETRY - Eingabe wiederholen bis sie gueltig ist
//
// Aufbau: 
// - Validierung mit DOU verbinden
// - bei falscher Eingabe erneut fragen
// - erst nach erfolgreicher Pruefung in INT umwandeln
//
// Ablauf:
// Eingabe -> pruefen -> ungueltig? erneut fragen -> gueltig?
//  -> umwandeln und Schleife verlassen
// ==================================================================


dcl-s input char(20);
dcl-s number int(10);
dcl-s invalidPos int(10);
dcl-s answer char(1);


// DOU eignet sich hier gut: 
// Die Eingabe muss mindestens einmal abgefragt werden
dou %len(%trim(input)) > 0 and invalidPos = 0;

    // Prompt anzeigen und Antwort in input speichern
    dsply 'Positive ganze Zahl:' '' input;

    // Position des ersten ungueltigen Zeichens ermitteln
    invalidPos = %check('0123456789' : %trim(input));

    if %len(%trim(input)) = 0;

        dsply 'Keine Eingabe - bitte erneut versuchen';
    
    elseif invalidPos > 0;

        dsply ('Ungueltiges Zeichen an Stelle ' + %char(invalidPos));

    else;

        // Erst jetzt steht fest, dass nur Ziffern entahlten sind
        number = %int(%trim(input));
    
    endif;

enddo;


dsply ('Gueltige Zahl: ' + %char(number));

dsply 'Weiter mit Enter' '' answer;


return;


// ==================================================================
// Grundprinzip 
//
// dou %len(%trim(input)) > 0 and invalidPos = 0;
// Wiederhole Schleife bis
// 1. überhaupt etwas eingegeben wurde und
// 2. kein ungültiges Zeichen gefunden wurde
//
// Beispiele: 
//
// Eingabe: abc
// -> invalidPos = 1
// -> Bedingnung nicht erfüllt, nochmal fragen
//
// Eingabe: 23r5
// -> invalidPos = 3
// -> nochmal fragen
//
// Eingabe: 2345
// -> invalidPos = 0
// -> Länge > 0
// -> Zahl wird umgewandelt
// -> DOU endet
//
//
// Python-Vergleich
//
//  while True: 
//      user_input = input("Positive ganze Zahl: ").strip()
//
//      if len(user_input) == 0: 
//          print("Keine Eingabe - bitte erneut versuchen")
//
//      elif not user_input.isdigit(): 
//          print("Ungültige Eingabe")
//
//      else: 
//          number = int(user_input)
//          break
//
//  print(f"Gueltige Zahl: {number}")
// ==================================================================