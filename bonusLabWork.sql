CREATE table customers(
    customer_id SERIAL primary key,
    iin varchar(12),
    full_name varchar,
    phone varchar,
    email varchar,
    status varchar,
    created_at  timestamp DEFAULT now(),
    daily_limit_kzt int
);
CREATE table accounts
(
    account_id  serial primary key,
    customer_id int REFERENCES customers(customer_id),
    account_number varchar unique not null,
    currency varchar,
    balance int,
    is_active bool,
    opened_at timestamp DEFAULT now(),
    closed_at timestamp
);
CREATE table transactions(
    transaction_id serial primary key ,
    from_account_id int REFERENCES accounts(account_id),
    to_account_id int REFERENCES accounts(account_id),
    amount int,
    currency varchar(3),
    exchange_rate int ,
    amount_kzt int,
    type varchar,
    status varchar,
    created_at timestamp default now(),
    completed_at timestamp,
    description text
);
CREATE table exchange_rates(
    rate_id serial primary key,
    from_currency varchar(3),
    to_currency varchar(3),
    rate int,
    valid_from timestamp,
    valid_to timestamp
);
CREATE table audit_log(
    log_id serial primary key ,
    table_name varchar,
    record_id int,
    action varchar,
    old_values jsonb,
    new_values jsonb,
    changed_by varchar,
    changed_at timestamp default  now(),
    ip_address varchar
);



INSERT INTO customers (iin, full_name, phone, email, status, daily_limit_kzt) VALUES
('123456789012', 'Artem Gushchin', '+77010000001', 'artem@example.com', 'active', 100000),
('123456789013', 'Elmira Sadykova', '+77010000002', 'elmira@example.com', 'active', 200000),
('123456789014', 'John Doe', '+77010000003', 'john@example.com', 'frozen', 150000),
('123456789015', 'Jane Smith', '+77010000004', 'jane@example.com', 'blocked', 120000),
('123456789016', 'Alice Johnson', '+77010000005', 'alice@example.com', 'active', 300000),
('123456789017', 'Bob Brown', '+77010000006', 'bob@example.com', 'active', 250000),
('123456789018', 'Charlie Lee', '+77010000007', 'charlie@example.com', 'active', 180000),
('123456789019', 'Diana King', '+77010000008', 'diana@example.com', 'frozen', 220000),
('123456789020', 'Evan White', '+77010000009', 'evan@example.com', 'active', 200000),
('123456789021', 'Fiona Green', '+77010000010', 'fiona@example.com', 'blocked', 160000);

INSERT INTO accounts (customer_id, account_number, currency, balance, is_active) VALUES
(1, 'KZ86125KZT000000001234', 'KZT', 5000000, TRUE),
(2, 'KZ86125KZT000000001235', 'USD', 10000, TRUE),
(3, 'KZ86125KZT000000001236', 'EUR', 8000, FALSE),
(4, 'KZ86125KZT000000001237', 'KZT', 1500000, FALSE),
(5, 'KZ86125KZT000000001238', 'RUB', 500000, TRUE),
(6, 'KZ86125KZT000000001239', 'KZT', 2000000, TRUE),
(7, 'KZ86125KZT000000001240', 'USD', 7000, TRUE),
(8, 'KZ86125KZT000000001241', 'EUR', 9000, FALSE),
(9, 'KZ86125KZT000000001242', 'KZT', 3000000, TRUE),
(10,'KZ86125KZT000000001243', 'USD', 12000, TRUE);



INSERT INTO transactions (from_account_id, to_account_id, amount, currency, exchange_rate, amount_kzt, type, status, description) VALUES
(1, 2, 50000, 'KZT', 0.0023, 50000, 'transfer', 'completed', 'Payment for services'),
(2, 3, 200, 'USD', 500, 100000, 'transfer', 'completed', 'USD transfer to EUR account'),
(4, 1, 30000, 'KZT', 1, 30000, 'deposit', 'completed', 'Deposit to account'),
(5, 6, 1000, 'RUB', 7.2, 7200, 'transfer', 'completed', 'RUB transfer to KZT'),
(7, 8, 500, 'USD', 450, 225000, 'transfer', 'pending', 'Pending transfer'),
(9, 10, 150000, 'KZT', 1, 150000, 'withdrawal', 'completed', 'Cash withdrawal'),
(1, 3, 70000, 'KZT', 0.0023, 70000, 'transfer', 'reversed', 'Reversed transaction'),
(2, 5, 300, 'USD', 420, 126000, 'transfer', 'failed', 'Failed transfer'),
(6, 7, 100000, 'KZT', 1, 100000, 'deposit', 'completed', 'Deposit from other source'),
(8, 9, 4000, 'EUR', 480, 1920000, 'transfer', 'completed', 'EUR transfer to KZT account');


INSERT INTO exchange_rates (from_currency, to_currency, rate, valid_from, valid_to) VALUES
('USD', 'KZT', 450, '2025-12-01', '2025-12-31'),
('EUR', 'KZT', 480, '2025-12-01', '2025-12-31'),
('RUB', 'KZT', 7.2, '2025-12-01', '2025-12-31'),
('KZT', 'USD', 0.0022, '2025-12-01', '2025-12-31'),
('KZT', 'EUR', 0.0021, '2025-12-01', '2025-12-31'),
('KZT', 'RUB', 0.14, '2025-12-01', '2025-12-31'),
('USD', 'EUR', 1.08, '2025-12-01', '2025-12-31'),
('EUR', 'USD', 0.93, '2025-12-01', '2025-12-31'),
('USD', 'RUB', 34, '2025-12-01', '2025-12-31'),
('RUB', 'USD', 0.029, '2025-12-01', '2025-12-31');

INSERT INTO audit_log (table_name, record_id, action, old_values, new_values, changed_by, ip_address) VALUES
('customers', 1, 'INSERT', NULL, '{"iin":"123456789012","full_name":"Artem Gushchin"}', 'admin', '127.0.0.1'),
('accounts', 2, 'INSERT', NULL, '{"account_number":"KZ86125KZT000000001235","balance":10000}', 'admin', '127.0.0.1'),
('transactions', 3, 'INSERT', NULL, '{"amount":30000,"type":"deposit"}', 'teller1', '127.0.0.2'),
('customers', 4, 'UPDATE', '{"status":"blocked"}', '{"status":"active"}', 'admin', '127.0.0.1'),
('accounts', 5, 'DELETE', '{"account_number":"KZ86125KZT000000001238"}', NULL, 'admin', '127.0.0.1'),
('transactions', 1, 'UPDATE', '{"status":"pending"}', '{"status":"completed"}', 'teller2', '127.0.0.3'),
('exchange_rates', 1, 'INSERT', NULL, '{"from_currency":"USD","to_currency":"KZT","rate":450}', 'finance1', '127.0.0.4'),
('customers', 3, 'UPDATE', '{"daily_limit_kzt":150000}', '{"daily_limit_kzt":200000}', 'admin', '127.0.0.1'),
('transactions', 2, 'UPDATE', '{"status":"pending"}', '{"status":"completed"}', 'teller3', '127.0.0.5'),
('accounts', 1, 'UPDATE', '{"balance":5000000}', '{"balance":4500000}', 'admin', '127.0.0.1');





/* Task 1 */


CREATE OR REPLACE PROCEDURE process_transfer(
    from_account_number varchar,
    to_account_number varchar,
    amount int,
    currency varchar(3),
    description text
)
LANGUAGE plpgsql
AS $$
DECLARE
    f_acc RECORD;
    t_acc RECORD;
    f_cust RECORD;
    daily_amount int;
    exch_row RECORD;
    mov_amount int;
    f_new_b int;
    t_new_b int;
BEGIN
    BEGIN
    SELECT * into f_acc FROM accounts where account_number = from_account_number FOR UPDATE ;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'From account does not exist';
    end if;

    SELECT * into t_acc from accounts where account_number = to_account_number FOR UPDATE ;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'To account does not exist';
    end if;

    SELECT * into f_cust from customers where customer_id = f_acc.customer_id;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'From customer does not exist';
    end if;

    SELECT sum(amount_kzt) into daily_amount from transactions where from_account_id = f_acc.account_id and created_at >= current_date and created_at < current_date + INTERVAL '1 day';

    IF f_acc.is_active != true or t_acc.is_active != true THEN
        RAISE EXCEPTION 'One of the accounts is not active';
    end if;

    IF f_cust.status != 'active' THEN
        RAISE EXCEPTION 'Customer''s status is not active';
    end if;

    IF  f_acc.balance - amount < 0 THEN
        RAISE EXCEPTION 'From account doesn''t have enough balance ';
    end if;
    IF f_cust.daily_limit_kzt < daily_amount + amount THEN
        RAISE EXCEPTION 'Daily limit is overloaded';
    end if;


    IF f_acc.currency != t_acc.currency THEN
        SELECT * into exch_row from exchange_rates where from_currency = f_acc.currency and to_currency = t_acc.currency;
        mov_amount = amount*exch_row.rate;
    ELSE
        mov_amount = amount;
    end if;


    f_new_b =: f_acc.balance - amount;
    t_new_b =: t_acc.balance + mov_amount;


    UPDATE accounts SET balance = balance - amount where account_number = from_account_number;
    UPDATE accounts SET balance = balance + mov_amount where account_number = to_account_number;

    INSERT INTO audit_log (table_name, record_id, action, old_values, new_values, changed_by, ip_address) VALUES
    ('Accounts',f_acc.account_id , 'UPDATE',to_jsonb(ROW ('balance' , f_acc.balance)) , to_jsonb(row ('balance'), f_new_b),'admin', '127.0.0.1'),
    ('Accounts',t_acc.account_id , 'UPDATE',to_jsonb(ROW ('balance' , t_acc.balance)) , to_jsonb(row ('balance') , t_new_b),'admin', '127.0.0.1');

    SAVEPOINT test;

    EXCEPTION WHEN OTHERS THEN
        INSERT INTO audit_log (table_name, record_id, action, old_values, new_values, changed_by, ip_address) VALUES
    ('Accounts',f_acc.account_id , 'UPDATE',to_jsonb(ROW ('balance' , f_acc.balance)) , to_jsonb(row ('balance'), f_new_b),'admin', '127.0.0.1'),
    ('Accounts',t_acc.account_id , 'UPDATE',to_jsonb(ROW ('balance' , t_acc.balance)) , to_jsonb(row ('balance') , t_new_b),'admin', '127.0.0.1');
        RAISE;
    END;
end;

$$;






/* Task 2 */

CREATE VIEW customer_balance_summary AS
with daily_totals as(SELECT
    a.customer_id,
    SUM(t.amount_kzt) AS total_balance_kzt
FROM accounts a
JOIN transactions t on t.from_account_id = a.account_id and t.created_at < current_date + interval '1 day' and t.created_at >= current_date
GROUP BY a.customer_id
),

total_balances as(SELECT
    a.customer_id,
    SUM(
        CASE
            WHEN a.currency = 'KZT' THEN a.balance
            ELSE a.balance * e.rate
        END
    ) AS total_balance_kzt
FROM accounts a
LEFT JOIN exchange_rates e
    ON a.currency = e.from_currency
   AND e.to_currency = 'KZT'
GROUP BY a.customer_id
)

SELECT c.full_name , a.customer_id,a.account_number ,a.currency, balance ,d.total_balance_kzt * 100 / c.daily_limit_kzt as daily_limit_percent,t.total_balance_kzt ,
       dense_rank() Over( ORDER BY t.total_balance_kzt DESC ) as rank FROM accounts a
JOIN customers c ON a.customer_id = c.customer_id
JOIN total_balances t on a.customer_id = t.customer_id
LEFT JOIN daily_totals d on a.customer_id = d.customer_id;



CREATE VIEW daily_transaction_report AS
WITH daily AS (
    SELECT
        DATE(created_at) AS day,
        type,
        SUM(amount_kzt) AS tot_volume_kzt,
        COUNT(*) AS t_count,
        AVG(amount_kzt) AS avg_amount_kzt
    FROM transactions
    GROUP BY DATE(created_at), type
)
SELECT
        day, type, tot_volume_kzt, t_count,avg_amount_kzt,
        SUM(tot_volume_kzt) OVER (
            PARTITION BY type
            ORDER BY day
        ) AS running_total_volume_kzt,
        SUM(t_count) OVER (
            PARTITION BY type
            ORDER BY day
        ) AS running_total_count,
        LAG(tot_volume_kzt) OVER (
            PARTITION BY type
            ORDER BY day
        ) AS prev_day_volume,
        CASE
            WHEN LAG(tot_volume_kzt) OVER (PARTITION BY type ORDER BY day) IS NULL
                THEN NULL
            WHEN LAG(tot_volume_kzt) OVER (PARTITION BY type ORDER BY day) = 0
                THEN NULL
            ELSE
                (tot_volume_kzt - LAG(tot_volume_kzt) OVER (PARTITION BY type ORDER BY day))/ LAG(tot_volume_kzt) OVER (PARTITION BY type ORDER BY day)* 100
        END AS growth_percent
    FROM daily ORDER BY day ,type;




CREATE VIEW suspicious_activity_view with (security_barrier)
 AS
with flagged as (
SELECT c.customer_id, transaction_id, amount_kzt
                 from transactions t
                    JOIN accounts a on a.account_id = t.from_account_id
                 JOIN customers c on c.customer_id = a.customer_id
                 where amount_kzt > 5000000
),

ten_plus_transactions AS (
    SELECT
        c.customer_id , DATE_TRUNC('hour' , t.created_at) as hour , count(*) as t_in_hour from transactions t
    JOIN accounts a on a.account_id = t.from_account_id
    JOIN customers c on a.customer_id = a.customer_id
        GROUP BY c.customer_id , DATE_TRUNC('hour' , t.created_at)
    HAVING COUNT(*) > 10
),


rapid_seq_trans AS(
    SELECT c.customer_id, t.transaction_id,t.amount_kzt,t.created_at,
    case
    WHEN t.created_at - LAG(t.created_at)    OVER (PARTITION BY c.customer_id ORDER BY t.created_at) < INTERVAL '1 minute' THEN TRUE
    ELSE FALSE
    END as does_rap from transactions t
    JOIN accounts a on a.account_id = t.from_account_id
                    JOIN customers c on c.customer_id = a.customer_id
)
SELECT * FROM customers c
LEFT JOIN flagged on c.customer_id = flagged.customer_id
LEFT JOIN ten_plus_transactions on    ten_plus_transactions.customer_id = c.customer_id
LEFT JOIN rapid_seq_trans on rapid_seq_trans.customer_id = c.customer_id WHERE   rapid_seq_trans.does_rap = true



/* Test cases */

/* test transfer from kzt to kzt account */
CALL process_transfer('KZ86125KZT000000001234', 'KZ86125KZT000000001237', 150000, 'KZT', 'test transfer');

/* test transfer from usd to kzt account */
CALL process_transfer('KZ86125KZT000000001235', 'KZ86125KZT000000001239', 150000, 'KZT', 'test transfer');


/* test transfer from non existing account */
CALL process_transfer('0','KZ86125KZT000000001242',1000,'KZT','test transfer');




/* test cases for views */
SELECT * FROM customer_balance_summary ORDER BY rank, customer_id LIMIT 20;


SELECT * FROM daily_transaction_report ORDER BY day DESC, type;

DO $$
DECLARE i int;
DECLARE acc int := (SELECT account_id FROM accounts WHERE account_number='KZ86125KZT000000001234' LIMIT 1);
BEGIN
  FOR i IN 1..11 LOOP
    INSERT INTO transactions (from_account_id, to_account_id, amount, currency, exchange_rate, amount_kzt, type, status, description, created_at)
    VALUES (acc, acc, 1, 'KZT', 1, 1, 'transfer','completed','flood test', now());
  END LOOP;
END$$;

SELECT * FROM suspicious_activity_view;