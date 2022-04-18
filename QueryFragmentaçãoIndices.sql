SELECT '['+OBJECT_SCHEMA_NAME(a.object_id)+'].['+object_name(a.object_id)+']' AS TableName,
min(case when b.type_desc = 'HEAP' then 1 else 0 end) as Heap, a.partition_number as PartitionNumber, a.avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL , NULL, 'LIMITED') a
JOIN sys.indexes b on a.object_id = b.object_id and a.index_id = b.index_id
where OBJECT_SCHEMA_NAME(a.object_id) <> 'old' and a.avg_fragmentation_in_percent >= 1
group by '['+OBJECT_SCHEMA_NAME(a.object_id)+'].['+object_name(a.object_id)+']', a.partition_number, a.avg_fragmentation_in_percent
	order by a.avg_fragmentation_in_percent desc


	alter index all on [dbo].[REP_WORKFLOW_PROCESS_ITEM] reorganize
	UPDATE STATISTICS [dbo].[REP_WORKFLOW_PROCESS_ITEM]