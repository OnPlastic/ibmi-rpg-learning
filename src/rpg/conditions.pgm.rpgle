**free

dcl-s counter int(10) inz(1);
dcl-s answer char(1);

dsply ('Counter vorher: ' + %char(counter));
dsply counter;

counter = counter + 1;

if counter < 2;
    dsply 'Counter ist kleiner als 2';
elseif counter = 2;
    dsply 'Counter ist genau 2';
else;
    dsply 'Counter ist groesser als 2';
endif;

dsply ('Counter nachher: ' + %char(counter));

dsply 'Weiter mit Enter' '' answer;

return;