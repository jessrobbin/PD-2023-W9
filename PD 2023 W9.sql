WITH outgoings AS (
    SELECT
        'Outgoing' AS in_out,
        td.transaction_date,
        td.value,
        ai.account_number
    FROM pd2023_wk07_transaction_detail AS td
    INNER JOIN pd2023_wk07_transaction_path AS tp ON td.transaction_id = tp.transaction_id
    INNER JOIN pd2023_wk07_account_information AS ai ON ai.account_number = tp.account_from
    WHERE cancelled_ = 'N'
),
incomings AS (
    SELECT
        'Ingoing' AS in_out,
        td.transaction_date,
        td.value,
        ai.account_number
    FROM pd2023_wk07_transaction_detail AS td
    INNER JOIN pd2023_wk07_transaction_path AS tp ON td.transaction_id = tp.transaction_id
    INNER JOIN pd2023_wk07_account_information AS ai ON ai.account_number = tp.account_to
    WHERE cancelled_ = 'N'
), 
initial AS (
    SELECT 
        'Initial' AS in_out,
        ai.balance_date AS transaction_date,
        ai.balance AS value,
        ai.account_number
    FROM pd2023_wk07_account_information AS ai
),
combined as (
-- Combining the CTEs and applying rank
SELECT 
    account_number,
    in_out,
    transaction_date,
    RANK() OVER(PARTITION BY account_number ORDER BY transaction_date ASC, value DESC) AS trans_order
    , CASE WHEN in_out = 'Outgoing' then (value * -1) else value end as value_new
FROM (
    SELECT in_out, transaction_date, value, account_number FROM outgoings
    UNION ALL
    SELECT in_out, transaction_date, value, account_number FROM incomings
    UNION ALL
    SELECT in_out, transaction_date, value, account_number FROM initial
) AS combined_data
order by account_number, trans_order
)
select
account_number
, transaction_date
, (CASE when trans_order = 1 then null else value_new end) as value
, sum(value_new) over (partition by account_number order by trans_order) as balance
from combined
order by account_number, transaction_date