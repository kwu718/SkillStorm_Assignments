DROP TABLE dbo.orders_parts
DROP PARTITION SCHEME myRangePS1
DROP PARTITION FUNCTION myRANGEPF1

-- Creates Partition Function
-- Got the min/max months for my lower and upper bounds
CREATE PARTITION FUNCTION myRangePF1 (datetime2)
    AS RANGE RIGHT FOR VALUES('2013-08-01', '2013-09-01', '2013-10-01',
    '2013-11-01','2013-12-01','2014-01-01','2014-02-01', '2014-03-01',
    '2014-04-01','2014-05-01','2014-06-01', '2014-07-01', '2014-08-01')

-- Creates Partition Scheme
CREATE PARTITION SCHEME myRangePS1
    AS PARTITION myRangePF1
    ALL TO ('PRIMARY');


-- Creates table orders_parts with partition on order_date column
CREATE TABLE orders_parts(
    order_id INT NOT NULL,
    order_date DATETIME2 NOT NULL,
    order_customer_id INT NOT NULL,
    order_astatus VARCHAR(45) NOT NULL
) ON myRangePS1(order_date)

-- Loads data into orders_parts
BULK INSERT dbo.orders_parts FROM '/media/orders.csv' WITH (FORMAT='CSV', ROWTERMINATOR = '0x0a', FIRSTROW=2);

-- Gets partition data and the number of rows in each partition
-- 14 Partitions, 14th is NULL
SELECT DISTINCT o.name as table_name, rv.value as partition_range, fg.name as file_groupName, p.partition_number, p.rows as number_of_rows
FROM sys.partitions p
INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id
INNER JOIN sys.objects o ON p.object_id = o.object_id
INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id
INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id
INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id
INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number
INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id 
LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id
WHERE o.object_id = OBJECT_ID('orders_parts');


