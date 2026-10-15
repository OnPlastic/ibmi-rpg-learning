-- ==================================================================
-- CUSTOMER CRUD OPERATIONS
--
-- Create ->INSERT
-- Read   ->SELECT
-- Update ->UPDATE
-- Delete ->DELETE
-- ==================================================================


-- READ
SELECT *
FROM IBM4HUJER1.CUSTOMER


-- CREATE
INSERT INTO IBM4HUJER1.CUSTOMER
    (CUSTOMER_ID, NAME, AGE, CITY)
VALUES
    (4, 'Lisa', 29, 'Hof');


-- READ: nur einen Kunden
SELECT *
FROM IBM4HUJER1.CUSTOMER
WHERE CUSTOMER_ID = 4;

-- ==================================================================
-- SQL Syntax: 
--
-- WHERE
-- -> filtert die Datensätze, die im Ergebnis enthalten sein sollen
-- -> kann mit logischen Operatoren kombiniert werden
-- 
-- SELECT * FROM ...
--        |-> welche Spalten sollen im Ergebnis enthalten sein
--
-- (DELETE FROM)! ... WHERE ...
--        |-> ganze Zeilen löschen
--
-- UPDATE(ohne FROM)! ... SET ... WHERE ...
--        |-> wenn einzelne Feldinhalte geändert werden sollen
--
-- INSERT INTO ... (Spalten, ,) VALUES (Werte, ,)
--        |-> neue Zeilen einfügen
--
--
-- Beispiele:
-- ------------------------------------------------------------------
-- UPDATE IBM4HUJER1.CUSTOMER
-- SET AGE = 30
-- SET CITY = 'Coburg'
-- WHERE CUSTOMER_ID = 4;
--
-- Ändere den Datensatz mit der CUSTOMER_ID = 4, -> setzte das Alter
-- auf 30 und die Stadt auf Coburg.
-- ------------------------------------------------------------------
-- UPDATE IBM4HUJER1.CUSTOMER
-- SET CITY = 'Coburg';
-- -> setzte bei allen Datensätzen die Stadt auf Coburg
--
-- SET CITY = ''; (NULL)
-- -> setzte bei allen Datensätzen die Stadt auf 'Leerstring'
-- -> oder wenn die Spalte NULL erlaubt, auf NULL
-- ==================================================================