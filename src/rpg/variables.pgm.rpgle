**free

dcl-s userName varchar(30) inz('IBM4HUJER');
dcl-s counter int(10) inz(1);
dcl-s answer char(1);

dsply ('Hallo ' + userName);
dsply ('Counter vorher: ' + %char(counter));

counter = counter +1;

if counter = 2;
    dsply 'Counter ist jetzt 2';
endif;

dsply ('Counter nachher: ' + %char(counter));

dsply 'Weiter mit Enter' '' answer;

return;

// ==================================================================
// .pgm Programme
// .rpgle Source ist ILE-RPG
// ILE Integrated Language Environment (IBMs Laufzeit-/Build-Modell)
// dcl-s Declare Standalone variable
// varchar(30) String mit 30 Zeichen
// int(10) Ganzzahl
// inz(...) Initialize mit Startwert
// %char(counter) RPG Funktion, Zahl in Text
// if ...; endif; RPG Bedingung. Ohne Klammern
// ; Anweisung Ende
// ==================================================================
