**free

// Variablen deklarieren
dcl-s number int(10) inz(7);
dcl-s answer char(1);

// Ausgangswert anzeigen
dsply ('Number: ' + %char(number));

// Logische Bedingungen pruefen
if number >= 2 and number <= 5;
    dsply 'Number liegt zwischen 2 und 5';

elseif number = 0 or number = 10;
    dsply 'Number ist 0 oder 10';

else;
    dsply 'Number liegt ausserhalb';

endif;

// Programm anhalten
dsply 'Weiter mit Enter' '' answer;

return;
