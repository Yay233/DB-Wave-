--question 1.
-- total wave users
SELECT COUNT(u_id)FROM users;

--question 2. number of transfers sent in CFA
SELECT COUNT(transfer_id) FROM transfers WHERE send_amount_currency = 'CFA';

--question 3. Number of different users who sent a transfer in CFA
SELECT COUNT(DISTINCT u_id)FROM transfers WHERE send_amount_currency = 'CFA';

--question 4. number of agent transactions had in the months of 2018
SELECT TO_CHAR(TO_DATE(EXTRACT(MONTH FROM when_created)::text,'MM'),'MONTH')AS months,
COUNT(atx_id) FROM agent_transactions
WHERE EXTRACT(YEAR FROM when_created)=2018
GROUP BY EXTRACT(MONTH FROM when_created);


--question 5. NUMBER OF WAVE AGENTS WHO WERE "NET DEPOSITORS" VRS "NET WITHDRAWERS" OVER THE COURSE OF LAST WEEK
WITH agent_withdrawers AS (SELECT COUNT(agent_id)AS net_withdrawers FROM agent_transactions
HAVING COUNT(amount)IN (SELECT COUNT(amount)FROM agent_transactions WHERE amount >-1
AND amount != 0 HAVING COUNT(amount)>(SELECT COUNT(amount)FROM agent_transactions
WHERE amount <1 AND amount !=0)))SELECT net_withdrawers FROM agent_withdrawers;

--QUESTION 6. BUILD AN ATX VOLUME CITY SUMMARY TABLE
CREATE VIEW atx_volume_city_summary AS SELECT COUNT(atx_id) AS volume,city
FROM public.agent_transactions, public.agents
WHERE agent_transactions.when_created BETWEEN '2018-11-23 23:59:59' AND '2018-12-30 23:59:59'
GROUP BY city;

--QUESTION 7 THE TABLE IN QUESTIONS6 SEPERATED BY COUNTRY
CREATE VIEW atx_volume_country_summary AS SELECT COUNT(atx_id) AS volume,city,country
FROM public.agent_transactions, public.agents
WHERE agent_transactions.when_created BETWEEN '2018-11-23 23:59:59' AND '2018-12-30 23:59:59'
GROUP BY city,country;

--QUESTION 8 
CREATE VIEW send_ne_volume2 AS SELECT COUNT(atx_id) AS volume,kind,country
FROM public.agent_transactions,public.transfers, public.agents
WHERE agent_transactions.when_created BETWEEN '2018-11-23' AND '2018-12-30'
agent_transactions.when_created>current_date -interval '7 days'
GROUP BY kind,country;

--QUESTION 9


SELECT count(transfers.source_wallet_id) AS Unique_Senders, count(transfer_id)
AS Transaction_count, transfers.kind AS Transfer_Kind, wallets.ledger_location 
AS Country, sum(transfers.send_amount_scalar) 
AS Volume FROM transfers INNER JOIN wallets ON transfers.source_wallet_id = wallets.wallet_id 
where (transfers.when_created > (NOW() - INTERVAL '1 week'))
GROUP BY wallets.ledger_location, transfers.kind;


--QUESTION 10
SELECT source_wallet_id, send_amount_scalar FROM transfers
WHERE send_amount_currency = 'CFA'
AND (send_amount_scalar>1000000) 
AND (transfers.when_created > (now() - INTERVAL '1 month'));




