delete f_app1
from f_app f
inner join 
(select * from teresa
) as dte on dte.a = f.a