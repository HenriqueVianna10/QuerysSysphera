	DECLARE @counter2 int;
	DECLARE @total2 int;
	DECLARE @cod2 int;


	DECLARE @table2 TABLE (
	id int identity,
	cod int)

	insert into @table2 (cod)
	select codDataLoadRest from
	REP_DATALOAD_REST
	where jsnResponse NOT LIKE '%""%' and dscName <> 'authentication'

	select @total2 = count(*) from
	REP_DATALOAD_REST
	where jsnResponse NOT LIKE '%""%' and dscName <> 'authentication'

	select @cod2 = cod
	from @table2

	set @counter2 = 1

	WHILE  @counter2 <= @total2 

	BEGIN

		select @cod2 = cod from @table2
		where id = @counter2

        /*INSTRUção SQL*/
        set @counter2 = @counter2 + 1
			END