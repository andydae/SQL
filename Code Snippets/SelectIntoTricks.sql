--Some ways to manipulate the result table in a SELECT INTO statement:



/*
The first way you can manipulate the target table is to set a column name. 
You can achieve this by aliasing a column in the query as shown below.
*/

SELECT  [RecordID]
	,[CustomerID] as CustomerKey        -- alias to another name
	,[OrderID] as OrderKey              -- alias to another name
	,[OrderDetailID] as OrderDetailKey  -- alias to another name
	,[CreatedDateTime]
	,[ModifiedDateTime]
INTO dbo.OrderDetail_Temp
FROM dbo.OrderDetail_Source s


/*
Another simple way you can manipulate the target table is to cast or convert to another data type. 
You can achieve this by casting/converting a column in the query, as shown below.
*/

SELECT   [RecordID]
	,cast([CustomerID] as varchar(255)) as CustomerKey 
	,cast([OrderID] as bigint) as OrderKey
     	,[OrderDetailID] as OrderDetailKey
	,cast([CreatedDateTime] as datetime2(0)) as CreatedDateTime 
	,[ModifiedDateTime]
INTO dbo.OrderDetail_Temp
FROM dbo.OrderDetail_Source s

/*
You can use the NULLIF statement to create a nullable column, 
while you use an ISNULL statement to create a non-nullable column, as shown below.
*/

SELECT  [RecordID]
	,NULLIF(cast([CustomerID] as varchar(255)),-1) as CustomerKey 
	,cast([OrderID] as bigint) as OrderKey
	,[OrderDetailID] as OrderDetailKey
	,cast([CreatedDateTime] as datetime2(0)) as CreatedDateTime 
	,ISNULL([ModifiedDateTime],'1/1/1900') as ModifiedDateTime
INTO dbo.OrderDetail_Temp
FROM dbo.OrderDetail_Source s


/*
A common hack to avoid bringing an identity property over to the target table is to do a dummy join or union. 
The dummy join or union causes the identity property to not be carried over.
This statement will create an identity on the RecordID column in the target table:
*/

SELECT   [RecordID]
	,NULLIF(cast([CustomerID] as varchar(255)),-1) as CustomerKey 
	,cast([OrderID] as bigint) as OrderKey
	,[OrderDetailID] as OrderDetailKey
	,cast([CreatedDateTime] as datetime2(0)) as CreatedDateTime 
	,ISNULL([ModifiedDateTime],'1/1/1900') as ModifiedDateTime
INTO dbo.OrderDetail_Temp
FROM dbo.OrderDetail_Source s

/*
While this statement will NOT create the identity because there is a join:
*/

SELECT   [RecordID]
	,NULLIF(cast([CustomerID] as varchar(255)),-1) as CustomerKey 
	,cast([OrderID] as bigint) as OrderKey
	,[OrderDetailID] as OrderDetailKey
	,cast([CreatedDateTime] as datetime2(0)) as CreatedDateTime 
	,ISNULL([ModifiedDateTime],'1/1/1900') as ModifiedDateTime
INTO dbo.OrderDetail_Temp
FROM dbo.OrderDetail_Source s
	 INNER JOIN dbo.DummyTable dt
		on 1 = 0  -- condition never true



/*
Let’s say we want to add a new identity column in the target table. We can do it like this:
*/

SELECT  IDENTITY (INT, 1, 1) AS NewIdentityColumn 
	,[RecordID]
	,NULLIF(cast([CustomerID] as varchar(255)),-1) as CustomerKey 
	,cast([OrderID] as bigint) as OrderKey
	,[OrderDetailID] as OrderDetailKey
	,cast([CreatedDateTime] as datetime2(0)) as CreatedDateTime 
	,ISNULL([ModifiedDateTime],'1/1/1900') as ModifiedDateTime
INTO dbo.OrderDetail_Temp
FROM dbo.OrderDetail_Source s
	 INNER JOIN dbo.DummyTable dt
		on 1 = 0  -- condition never true

/*
With SQL Server 2017, you can now also use the ON clause to direct the target table 
to be created on a specific file group other than the default.
*/

SELECT   IDENTITY (INT, 1, 1) AS NewIdentityColumn 
	,[RecordID]
	,NULLIF(cast([CustomerID] as varchar(255)),-1) as CustomerKey 
	,cast([OrderID] as bigint) as OrderKey
	,[OrderDetailID] as OrderDetailKey
	,cast([CreatedDateTime] as datetime2(0)) as CreatedDateTime 
	,ISNULL([ModifiedDateTime],'1/1/1900') as ModifiedDateTime
INTO dbo.OrderDetail_Temp ON [AnotherFileGroup]
FROM dbo.OrderDetail_Source s
	 INNER JOIN dbo.DummyTable dt
		on 1 = 0  -- condition never true