**free

ctl-opt dftactgrp(*no);

// ==================================================================
// PROCINPUT - Benutzereingabe an Procedure uebergeben
//
// Ablauf: 
// Eingabe -> Variable -> Argument -> Parameter
//         -> Berechnung -> RETURN -> Ergebnisvariable
//
// Python-Vergleich: 
//
//  first_number = int(input('Erste Zahl: '))
//  second_number = int(input('Zweite Zahl: '))
//
//  result = add_numbers(fist_number, second_number)
// ==================================================================


// Prototype
dcl-pr AddNumbers int(10);
    a int(10) const;
    b int(10) const;
end-pr;


// Variablen des Hauptprogramms
dcl-s firstNumber int(10);
dcl-s secondNumber int(10);
dcl-s result int(20);
dcl-s answer char(1);


// Benutereingabe
dsply 'Erste Zahl eingeben:' '' firstNumber;
dsply 'Zweite Zahl eingeben:' '' secondNumber;


// Die Variablen sind hier die ARGUMENTE
// Ihre Werte werden an die Parameter a und b uebergeben.
result = AddNumbers(firstNumber : secondNumber);


// Rueckgabewert anzeigen
dsply ('Ergebnis: ' + %char(result));

dsply 'Weiter mit Enter' '' answer;


return;


// ==================================================================
// Procedure
// ==================================================================

dcl-proc AddNumbers;

    dcl-pi *n int(10);

        // a und b sind die PARAMETER der Procedure.
        a int(10) const;
        b int(10) const;

    end-pi;

    return a + b;

end-proc;


// ==================================================================
// Grundprinzip - Hauptprogramm
//
// Benutzereingabe -> firstNumber; secondNumber;
//
// AddNumbers(firstNumber : secondNumber)
//             Argument   :  Argument
//             a = 7         b = 4
//                       a+b
//                       =11
//                    return 11
//                  ->result = 11
//                  ->Ausgabe: 11
// ==================================================================