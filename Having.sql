SELECT S.zipcode,
AVG(UR.Amount) AS 'Average', SUM(UR.Amount) as 'Total'
from [Unified Receipts] AS UR JOIN Stores AS S
ON UR.[Store ID] = S.[ID]
GROUP BY S.zipcode
HAVING AVG(UR.Amount) >=60

