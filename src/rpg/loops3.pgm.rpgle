**free

// ==================================================================
// Beispiel 3: DOU-Schleife
//
// DOU = Do Until
// Die Bedingung wird NACH jedem Durchlauf geprüft.
//
// Python hat keine direkte du-until-Schleife.
// Vergleichbare Logik:
//
//  coutner = 1
//  while True:
//      print(f'Durchlauf: {counter}')
//      counter += 1
//      if counter > 5:
//          break
// ==================================================================

dcl-s counter int(10);

dcl-s answer char(1);


counter = 1;

dsply 'DOU-Schleife startet';

dou counter > 5;
    dsply ('Durchlauf: ' + %char(counter));

    // Der Zaehler wird wie bei DOW selbst veraendert.
    counter = counter + 1;

enddo;


dsply 'DOU-Schleife beendet';

dsply 'Weiter mit enter ' '' answer;

return;

// ==================================================================
// Wichtige Bedingung:
// dou counter > 5; -> Wiederhole, BIS counter > 5 wahr wird.
// Bsp.: counter = 1
// 1
// 2
// 3
// 4
// 5
// counter = 6 -> counter > 5 true; Die Schleife endet
// ==================================================================