-- ==================================================================
-- CUSTOMER TABLE
-- ==================================================================

CREATE TABLE IBM4HUJER1.CUSTOMER
(
    CUSTOMER_ID INT NOT NULL,
    NAME VARCHAR(30) NOT NULL,
    AGE INT NOT NULL,
    CITY VARCHAR(30) NOT NULL,

    PRIMARY KEY (CUSTOMER_ID)
);


-- ==================================================================
-- Gedanklich: 
--
-- RPG                  Db2
--
-- Customer_t           CUSTOMER
-- ----------------------------------------
-- customer_Id INT  <>  CUSTOMER_ID INTEGER
-- name VARCHAR(30) <>  NAME VARCHAR
-- age INT          <>  AGE INTEGER
-- city VARCHAR     <>  CITY VARCHAR
-- ==================================================================


-- ==================================================================
-- Wenn 'CREATE TABLE' erfolgreich war, dann Datensätze anlegen.
-- ==================================================================

INSERT INTO IBM4HUJER1.CUSTOMER
    (CUSTOMER_ID, NAME, AGE, CITY)
VALUES
    (1, 'Anna', 35, 'Bayreuth'),
    (2, 'Max', 42, 'Nuernberg'),
    (3, 'Peter', 51, 'Bamberg');


-- ==================================================================
-- Wenn 'INSERT' erfolgreich war, dann die Datenban abfragen.
-- ==================================================================

SELECT * FROM IBM4HUJER1.CUSTOMER;


-- ==================================================================
-- Erwartung:
--
-- CUSTOMER_ID  NAME  AGE  CITY
-- ---------------------------------
-- 1            Anna  35   Bayreuth
-- 2            Max   42   Nuernberg
-- 3            Peter 51   Bamberg
-- ==================================================================