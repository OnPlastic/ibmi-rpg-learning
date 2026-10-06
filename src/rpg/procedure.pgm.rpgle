**free

ctl-opt dftactgrp(*no);

// ==================================================================
// PROCEDURE - Beispiel 1: interne Procedure ohne Parameter
//
// Aufbau:
// - Prototyp mit DCL-PR 
// - Procedure mit DCL-PROC definieren
// - Ablauf: Hauptprogramm -> Procedure -> zurück
//
// Python vergleich: 
//
//  def show_message():
//      print("Hallo aus der Funktion")
//
//  show_message()
// ==================================================================


// Prototype: 
// Sagt dem Compiler bereits vor dem Hauptprogramm: 
// "Es gibt eine Procedure namens ShowMessage."
dcl-pr ShowMessage;
end-pr;


dcl-s answer char(1);


// Hauptprogramm
dsply 'Hauptprogramm startet';

ShowMessage();

dsply 'Zurueck im Hauptprogramm';

dsply 'Weiter mit Enter' '' answer;


return;


// ==================================================================
// Implementierung der Procedure
// ==================================================================

dcl-proc ShowMessage;

    dsply 'Hallo aus der Procedure';

end-proc;


// ==================================================================
// Grundprinzip - Hauptprogramm
// -> callp ShowMessage()
// -> Procedure läuft
// -> end-proc
// -> Rückkehr ins Hauptprogramm
// 
// Python: 
// def func(a): 
//  ...print('Hello World')
//
// C#: 
// public int Func(int a)
// {
//  ...
// }
//
// RPG: 
// DCL-PR
// DCL-PI
// DCL-PROC
// ==================================================================
