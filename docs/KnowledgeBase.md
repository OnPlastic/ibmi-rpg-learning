# RPG Grundwissen & Plattform-Besonderheiten

## 1. Datentypen: CHAR vs. VARCHAR (Das Luftballon-Prinzip)

* **CHAR(X):** Fester Block. Füllt ungenutzten Platz mit Leerzeichen auf (`'Tom       '`).
* **VARCHAR(X):** Variabel (Luftballon). Speichert nur die tatsächliche Länge exakt ab (`'Tom'`).

## 2. Der DSPLY-Befehl
* **DSPLY** [*Nachricht*] [*Meldungsempfänger*] [*Antwort-Variable*];
* *Szenario A (reine Ausgabe):* `dsply 'Hallo';`
* *Szenario B (Ausgabe mit Eingabe):* `dsply 'Dein Name?' '' tempName;`
* **Limit:** Maximal 52 Zeichen (Nachricht + Eingabe).
* **Verhalten:** Akzeptiert *nur* feste `CHAR`-Felder. Füllt Zielvariablen bei kurzen Eingaben mit Leerzeichen auf.
* **Workaround:** Immer ein `tempCHAR`-Feld für die Eingabe nutzen und mit `%trim()` in `VARCHAR` überführen.

## 3. IBM i & RPG Abkürzungsverzeichnis (Glossar)

### Entwicklung & Architektur
* **RPG / RPGLE:** *Report Program Generator* (bzw. *ILE RPG*). Die primäre Geschäftsprogrammiersprache auf der Plattform. Das „LE“ steht für *Frist-class Language Extension* im Rahmen von ILE.
* **ILE:** *Integrated Language Environment*. Die moderne Laufzeitumgebung der IBM i, die es erlaubt, verschiedene Sprachen (RPG, COBOL, C) in einem einzigen Programm zu kombinieren.
* **TIMI:** *Technology Independent Machine Interface*. Die genialste Schicht der IBM i. Sie liegt zwischen der Hardware und dem Betriebssystem. Sie sorgt dafür, dass dein RPG-Code auch auf zukünftigen Prozessor-Generationen ohne Neukompilierung läuft.
* **PASE:** *Portable Application Solutions Environment*. Eine integrierte KIX-/Unix-Umgebung auf der IBM i, über die kostenloser Open-Source-Code (wie GCC, Python oder Node.js) nativ ausgeführt werden kann.

### Quellcode & Strukturen
* **CTL-OPT:** *Control Options* (früher H-Bestimmung/Header). Hier werden globale Programmeinstellungen definiert (z. B. `dftactgrp(*no)`).
* **DCL-DS / END-DS:** *Declare Data Structure*. Definiert einen zusammenhängenden Speicherblock (Struktur), der verschiedene Variablen bündelt.
* **DCL-PR / DCL-PI:** *Declare Prototype* / *Declare Procedure Interface*. 
  * **PR (Prototyp):** Sagt dem Programm, wie eine Prozedur von außen aufgerufen werden muss (die Schnittstellen-Definition).
  * **PI (Interface):** Steht innerhalb der Prozedur und nimmt die tatsächlichen Werte beim Aufruf entgegen.
* **LIKEDS:** *Like Data Structure*. Kopiert die Struktur einer bereits definierten Datenstruktur (wird oft für saubere Parameterübergaben genutzt).
* **INZ:** *Initialize*. Initialisiert eine Variable direkt bei der Definition mit einem Startwert (z. B. `inz('J')`).

### Datenbank & Systemobjekte (Wichtig für deinen nächsten Schritt!)
* **DB2 for i:** Die tief im Betriebssystem integrierte relationale Datenbank der IBM i.
* **DDS:** *Data Description Specifications*. Der klassische, spaltenbasierte Weg (vor SQL), um physische Dateien (Tabellen) und Bildschirme zu definieren.
* **PF / LF:** *Physical File* / *Logical File*.
  * **PF:** Die eigentliche Datenbanktabelle, die die Rohdaten enthält.
  * **LF:** Eine Sicht (View) oder ein Index auf die PF, um Daten anders zu sortieren oder zu filtern.
* **DDL:** *Data Definition Language*. Der moderne SQL-Weg, um Tabellen zu erstellen (`CREATE TABLE`), anstelle des alten DDS-Wegs.

## 4. Das IBM i Philosophie-Prinzip: *PROD vs *TEST
* **Optionen mit Sternchen (`*`):** Das sind sogenannte "System-Keywords" (vordefinierte Werte des Betriebssystems).
* **Der Zweck:** Die IBM i trennt strikt zwischen Live-Betrieb (`*PROD`) und Entwicklungs-/Testbetrieb (`*TEST`). 
* **Schutzmechanismus:** Das Betriebssystem verhindert im Debug-Modus automatisch den Schreibzugriff auf `*PROD`-Bibliotheken, um die echten Geschäftsdaten vor Programmierfehlern zu schützen.
