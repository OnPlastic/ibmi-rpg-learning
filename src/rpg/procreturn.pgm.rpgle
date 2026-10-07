**free

ctl-opt dftactgrp(*no);

// ==================================================================
// PROCEDURE - Beispiel 3: Procedure mit Rueckgabewert
//
// Aufbau: 
// - Rueckgabetyp im Prototyp definieren
// - Rueckgabewert in einer Variable speichern
// - RETURN mit Wert verwenden
//
// Python-Vergleich: 
//
//  def add(a, b): 
//      return a + b
//
//  result = add(2, 3)
// ==================================================================


// Prototyp: 
// Die Procedure erwartet zwei Integer und gibt einen Integer zurueck.
dcl-pr AddNumbers int(10);
    // a u. b sind Parameter
    a int(10) const;
    b int(10) const;
end-pr;

// Variablendeklaration: 
dcl-s result int(10);
dcl-s answer char(1);


// Hauptprogramm
dsply 'Hauptprogramm startet';

// 2 u. 3 sind hart codierte Argumente (Literale)
// result = 5
result = AddNumbers(2 : 3);

dsply ('Ergebnis: ' + %char(result));

dsply 'Weiter mit Enter ' '' answer;

return;


// ==================================================================
// Procedure
// ==================================================================

dcl-proc AddNumbers;

    dcl-pi *n int(10);
        a int(10) const;
        b int(10) const;
    end-pi;

    return a + b;

end-proc;


// ==================================================================
// Erlaeuterungen: 
//
// dcl-pr AddNumbers int(10); int(10) = Rückgabetyp
// Innerhalb der Procedure muss auch der Rückgabetyp stehen
// dcl-pi *n int(10)
//
// return a + b; liefert den tatsaechlichen Wert
// Im Hauptprogramm bekommt result den Wert 5
// result = AddNumbers(2 : 3);
//
// Parametertrennung in RPG
// AddNumbers(2 : 3) : als Seperator, nicht mit Komma wie in Python
// ==================================================================
