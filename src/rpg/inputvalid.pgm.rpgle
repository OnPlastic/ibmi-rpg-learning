**free

// ==================================================================
// INPUTVALID - einfache Eingabevalidierung
// 
// Aufbau: 
// - Benutzereingabe zuerst als Text einlesen
// - pruefen, ob nur Ziffern eingegeben wurden
// - gueltigen Text anschliessend in INT umwandeln
//
// Datenfluss:
// Eingabe -> CHAR -> Validierung -> %INT() -> Zahl
//
//
// Python-Vergleich:
// 
//  user_input = input("Positive ganze Zahl: ")
//  if user_input.isdigit():
//      number = int(user_input)
//      print(f"Gültige Zahl: {number}")
//  else: 
//      print("Ungültige Eingabe")
// ==================================================================


dcl-s input char(20);
dcl-s number int(10);
dcl-s answer char(1);


// DSPLY mit Eingabevariable: 
// Prompt anzeigen und Antwort ' ' in input speichern.
dsply 'Positive ganze Zahl:' '' input;


// %TRIM entfernt führende und nachgestellte Leerzeichen
// %len(...) zaehlt die verbleibenden Zeichen
// %CHECK sucht Zeichen, die NICHT in '0123456789' vorkommen
//
// Rueckgabe 0: 
// Alle Zeichen sind erlaubt
//
// Rueckgabe > 0: 
// An dieser Position wurde ein ungueltiges Zeichen gefunden.
if %len(%trim(input)) > 0
    and %check('0123456789' : %trim(input)) = 0;

    number = %int(%trim(input));

    dsply ('Gueltige Zahl: ' + %char(number));

else;

    dsply 'Ungueltige Eingabe';

endif;


dsply 'Weiter mit Enter' '' answer;


return;


// ==================================================================
// Beispiele: 
//
// input = '123    '
// -> %trim(input) = '123'
// -> %len(...)    =  3
//
// %trim(input) = '' keine Eingabe
// %len(...)    =     0
//
// Wir prüfen auf: 
// %len(%trim(input)) > 0
// ==================================================================
