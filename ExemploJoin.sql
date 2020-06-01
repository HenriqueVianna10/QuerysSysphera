select emp.EmployeeID, per.FirstName, per.LastName
from HumanResources.Employee as emp
JOIN
Person.Contact as per 
on emp.ContactId = perContactId

