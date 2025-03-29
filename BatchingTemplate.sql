DECLARE
	@BatchSize INT = 1000
	,@WaitForDelay VARCHAR(12) = '00:00:01.000' -- hh:mm:ss.mmm
	,@BatchCount INT = 1
	,@LoopBeginCount INT = 1
	,@LoopEndCount INT
	,@MaxCount INT


SET @LoopEndCount = @LoopBeginCount + @BatchSize
SET @MaxCount = 10000


WHILE @LoopBeginCount <= @MaxCount
BEGIN
	SELECT
		@BatchCount AS BatchCount
		,@LoopBeginCount AS LoopBeginCount
		,@LoopEndCount AS LoopEndCount
		,'>= ' + CAST(@LoopBeginCount AS VARCHAR(50)) + ' AND < ' + CAST(@LoopEndCount AS VARCHAR(50)) + ';';

	SET @BatchCount += 1;
	SET @LoopBeginCount = @LoopEndCount
	SET @LoopEndCount += @BatchSize

	WAITFOR DELAY @WaitForDelay;
END -- end while loop
