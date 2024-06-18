# PD-2023-W9
Preppin Data 2023 Week 9 in SQL

link: https://preppindata.blogspot.com/2023/03/2023-week-9-customer-bank-statements.html

**Requirements**
- Input the data
- For the Transaction Path table:
- Make sure field naming convention matches the other tables
    - i.e. instead of Account_From it should be Account From
- Filter out the cancelled transactions
- Split the flow into incoming and outgoing transactions 
- Bring the data together with the Balance as of 31st Jan 
- Work out the order that transactions occur for each account
    - Hint: where multiple transactions happen on the same day, assume the highest value transactions happen first
- Use a running sum to calculate the Balance for each account on each day (hint)
- The Transaction Value should be null for 31st Jan, as this is the starting balance
- Output the data

Practices:
- CTE's
- Running Sum
- Ranks
- Unions
