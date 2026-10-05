**free

// ============================================================
// LOOPS - Beispiel 1: FOR-Schleife
//
// Lernziel:
// - FOR / ENDFOR 
// - Schleifenvariable verwenden
// - numerischen Wert mit %CHAR() für Textausgabe umwandeln
//
// Python-Vergleich:
//   for i in range(1, 6):
//       print(f'Durchlauf: {i}')
//
// Wichtig:
// - RPG:    1 TO 5      -> 1, 2, 3, 4, 5
// - Python: range(1, 6) -> 1, 2, 3, 4, 5
//   Bei Python ist die obere Grenze von range() ausgeschlossen.
// ============================================================


// Schleifenvariable.
// INT(10) = Ganzzahl.
dcl-s i int(10);

// Wird am Ende nur benutzt, damit DSPLY auf Enter wartet.
dcl-s answer char(1);


dsply 'FOR-Schleife startet';

// FOR setzt i zunächst auf 1.
// Nach jedem Durchlauf wird i automatisch erhöht.
// Die Schleife endet nach dem Durchlauf mit i = 5.
//
// Anders als bei einer manuell gesteuerten Schleife müssen wir
// hier also NICHT selbst schreiben:
//     i = i + 1;
for i = 1 to 5;

    // i ist numerisch.
    // Für die Verkettung mit Text wird daraus mit %CHAR()
    // eine Zeichenfolge.
    dsply ('Durchlauf: ' + %char(i));

endfor;


dsply 'FOR-Schleife beendet';


// DSPLY mit Antwortvariable hält das Programm an.
// Dadurch bleibt die Ausgabe im 5250-Terminal stehen.
dsply 'Weiter mit Enter' '' answer;

return;
