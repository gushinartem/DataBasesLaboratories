/* part 3 */

BEGIN;

UPDATE accounts SET balance = balance - 100.00
    WHERE name = 'Alice';
UPDATE accounts SET balance = balance +100.00
    WHERE name  = 'Bob';
COMMIT;
/* alice balance is -100 , bob + 100*/
/* bcs they are have the same structure and change the same column of same table mb*/
/* first update would commited but the second is not */




BEGIN;

UPDATE accounts SET balance = balance +500.00
    WHERE name = 'Alice';
SELECT * FROm accounts where name = 'Alice';
ROLLBACK;


SELECT * FROm accounts where name = 'Alice';

/* balance was 1400*/
/* it backed to initial value */
/* in bank applications while transaction of money between accounts */




BEGIN;
UPDATE accounts SET balance = balance - 100.00
    WHERE name = 'Alice';
SAVEPOINT my_savepoint;

UPDATE accounts SET balance = balance + 100.00
    WHERE name = 'Bob';
ROLLBACK TO my_savepoint;
UPDATE accounts SET balance  = balance + 100.00
    WHERE name = 'Wally';
COMMIT;

/* alice is - 100 , bob will be the same bcs we used rollback , wally will be + 100*/
/* it was credited in the memory not in the database , but after rollback is deleted from memory so
   these changes won't be in the database
 */
/* the advantage is that we can make parts of our transaction and commit only a few queries */


BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT * FROM products WHERE shop = 'Joe''s Shop';

SELECT * FROM products WHERE shop = 'Joe''s Shop';
COMMIT;

BEGIN;
DELETE FROM products WHERE shop ='Joe''s Shop';
INSERT INTO products(shop , product , price )
    VALUES('Joe''s Shop' , 'Fanta' , 3.50);
COMMIT;



BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT * FROM products WHERE shop = 'Joe''s Shop';

SELECT * FROM products WHERE shop = 'Joe''s Shop';
COMMIT;
/* bcs of read committed isolation level before it sees one data and after it sees different*/
/* it sees only one snapshot of database till the end of transaction */
/* read committed uses actual data in the database ( commited) while serializable make a snapshot of database
   at the start and use it snapshot until end of the transaction and transactions execute serially
 */





BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT MAX(price) , Min(price) from products
    WHERE shop = 'Joe''s Shop';

SELECT MAX(price) , Min(price) from products
    WHERE shop = 'Joe''s Shop';
COMMIT;
/* only if this transaction is executed again */
/* it's like the shadow of data (snapshot of database) that transaction use */
/* serializable */



BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ;
SELECT * From products where shop = 'Joe''s Shop';

SELECT * FROM products where shop = 'Joe''s Shop';

SELECT * FROm products where shop = 'Joe''s Shop';
COMMIT;

BEGIN;
UPDATE products SET price = 99.99
 WHERE product = 'Fanta';
-- Wait here (don't commit yet)
-- Then:
ROLLBACK;

/* because 99.99 data is not commited by transaction*/
/* uncontrollable read */
/* it can cause many errors related to un consistent of database */




BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ;
SELECT * From products where shop = 'Joe''s Shop';

SELECT * FROM products where shop = 'Joe''s Shop';

SELECT * FROm products where shop = 'Joe''s Shop';
COMMIT;

BEGIN;
UPDATE products SET price = 99.99
 WHERE product = 'Fanta';
-- Wait here (don't commit yet)
-- Then:
ROLLBACK;

/* because 99.99 data is not commited by transaction*/
/* uncontrollable read */
/* it can cause many errors related to un consistent of database */




/* part 4 */
BEGIN;
DO $$
BEGIN
    IF(select balance from accounts where name =  'Bob') < 200 THEN
        RAISE EXCEPTION 'Insufficient funds for Bob';
    end if;
end;
 $$;
UPDATE accounts SET balance = balance - 200
    WHERE name = 'Bob';

UPDATE accounts SET balance = balance + 200
    WHERE name = 'Wally';
COMMIT;






BEGIN;
INSERT INTO products VALUES
    (7,'John''s Shop' , 'Dada' , 20.00);
SAVEPOINT mySave;
UPDATE products SET price = 30 where product = 'Dada';
SAVEPOINT mySave2;
DELETE FROM products where product = 'Dada';
ROLLBACK TO mySave;
COMMIT;


/* will execute only the first query where inserting a new drink - dada */







BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

DO $$
DECLARE
    bal INT;
BEGIN
    SELECT balance into bal from accounts where id = 1;
    IF bal < 200 THEN
        RAISE exception 'not enough money';
    end if;
END;
$$;
UPDATE accounts SET balance = balance-200 where id = 1;
COMMIT;





/* exercise 4

   I don't know about this relation Sells(shop , product, price)
   but i can guess that they use read uncommitted transaction , they should use
   repeatable read and serializable, or read commited
 */

/* Part 5 */


/*
 1.
 Atomic
BEGIN;
UPDATE products SET price = 10;
UPDATE products SET price = 20;
COMMIT;
 in this code ALL query are done or not , thye considered as a one unit of work

 Consistent
when we add new rows in some table , it is guaranteed that database moves from one valid state
 to another.
 Isolated
when two or more user use the same table isolation helps prevent errors while processing this
 operations
 Durable
 even if database will crash or something happened , it is guaranteed that all changes will
 be stored forever
 2. Commit saves all changes in database , when rollback cancel them from saving
 3. When I need to save a part of some transaction instead of canceling all
 4. Read uncommited - the worst , don't use it
    Read committed - uses in not important changes
    Repeatable read - when you need the same data across all transaction
    Serializable - when you use money
 5. read uncommited  - read all data commited and uncommitted
 6. read committed - read all data that has been commited
 7. repeatable read - make a snapshot of database and use it across the transaction
 8. I would use it because it would help to optimize every query
 9. they set the isolation level on each transaction which helps maintain database consistency
 10. they will be canceled until they are commited

 */


