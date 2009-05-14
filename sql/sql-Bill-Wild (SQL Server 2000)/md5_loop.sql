
/* The usuals */
SET NoCount ON

/* Declare and init if necessary */
DECLARE @ATTEMPT_COUNT BIGINT
SET @ATTEMPT_COUNT = 0

DECLARE @OVERALL_ATTEMPT_COUNT BIGINT
SET @OVERALL_ATTEMPT_COUNT = 0

DECLARE @RANDOM_NUMBER INTEGER
SET @RANDOM_NUMBER = 0

DECLARE @UPPER_LIMIT INTEGER
SET @UPPER_LIMIT = 16 

DECLARE @LOWER_LIMIT INTEGER
SET @LOWER_LIMIT = 1 

DECLARE @CHAR_SET VARCHAR(32)
SET @CHAR_SET = 'abcdef1234567890'

DECLARE @FOUND TINYINT
SET @FOUND = 0

DECLARE @TIMESTAMP_FOR_MINUTE_CALCULATION DATETIME
SET @TIMESTAMP_FOR_MINUTE_CALCULATION = GETDATE()

/* Working declares */
DECLARE @TARGET VARCHAR(32)
DECLARE @HEX_TARGET VARCHAR(34)
DECLARE @RESULT VARBINARY(50)
DECLARE @CHAR_RESULT VARCHAR(34)
DECLARE @COUNTER TINYINT
DECLARE @VERBIAGE VARCHAR(255)


/* Option Switches - 0 or 1 

   Default settings are to print the attempts per minute 
   and log the attempts per minute but NOT to log every
   attempt target and result

*/

/* Want to log every attempt? ** WARNING - A ton of data ** */
DECLARE @LOG TINYINT
SET @LOG = 0

/* Display number of attemps per minute ? */
DECLARE @DISPLAY_ATTEMPS_PER_MINUTE TINYINT
SET @DISPLAY_ATTEMPS_PER_MINUTE = 1

/* Log the number or attempts per minute? */
DECLARE @LOG_ATTEMPS_PER_MINUTE TINYINT
SET @LOG_ATTEMPS_PER_MINUTE = 1

/* Main Loop */
WHILE @FOUND = 0
BEGIN
	
	SET @ATTEMPT_COUNT = @ATTEMPT_COUNT + 1
	SET @OVERALL_ATTEMPT_COUNT = @OVERALL_ATTEMPT_COUNT + 1

	SET @HEX_TARGET = ''
	SET @CHAR_RESULT = ''
	SET @TARGET = ''
	SET @COUNTER = 0
	
	WHILE @COUNTER < 32
	BEGIN
		SET @COUNTER = @COUNTER + 1
		SELECT @RANDOM_NUMBER = ROUND(((@UPPER_LIMIT - @LOWER_LIMIT -1) * RAND() + @LOWER_LIMIT), 0)
		SET @TARGET = @TARGET + SUBSTRING(@CHAR_SET,@RANDOM_NUMBER,1) 
	END
	
	/* Add '0x' for comparison */
	SET @HEX_TARGET = '0x' + @TARGET
	
	/* Run the MD5 */ 
	SET @RESULT = dbo.MD5(CONVERT(VARBINARY(50), @TARGET) )
	
	/* Convert binary to char for comparison */
	SELECT @CHAR_RESULT = master.dbo.fn_varbintohexstr( @RESULT)
	
	/* Check the result MD5 */
	IF @CHAR_RESULT = @HEX_TARGET 
	BEGIN
		/* OMG We found it!! */
		SET @VERBIAGE = 'The MD5 hash of ' + @HEX_TARGET + ' is ' + @CHAR_RESULT 
		INSERT tabMD5(attempt_verbiage,attempt_timestamp)
		VALUES(@VERBIAGE,GETDATE())

		PRINT @VERBIAGE

		SET @VERBIAGE = 'We Found it in ' + CONVERT(VARCHAR(255),@OVERALL_ATTEMPT_COUNT) + ' tries! '
		INSERT tabMD5(attempt_verbiage,attempt_timestamp)
		VALUES(@VERBIAGE,GETDATE())
		
		PRINT @VERBIAGE

		SET @FOUND = 1
	END 
	ELSE 
	BEGIN
		SET @VERBIAGE = 'The MD5 hash of ' + @HEX_TARGET + ' is ' + @CHAR_RESULT 
	END

	
	IF @LOG = 1
	BEGIN
		INSERT tabMD5(attempt_verbiage,attempt_timestamp)
		VALUES(@VERBIAGE,GETDATE())
	END

	IF DATEDIFF(minute, @TIMESTAMP_FOR_MINUTE_CALCULATION, getdate()) = 1
	BEGIN
		IF @DISPLAY_ATTEMPS_PER_MINUTE = 1
		BEGIN
			PRINT 'Attempts per minute : ' + CONVERT(VARCHAR(255),@ATTEMPT_COUNT)
			
		END
		
		IF @LOG_ATTEMPS_PER_MINUTE = 1
		BEGIN
		
			SET @VERBIAGE = 'Attempts per minute : ' + CONVERT(VARCHAR(255),@ATTEMPT_COUNT)
			INSERT tabMD5(attempt_verbiage,attempt_timestamp)
			VALUES(@VERBIAGE,GETDATE())

		END

		/* Reset for next minute */
		SET @TIMESTAMP_FOR_MINUTE_CALCULATION = GETDATE()
		SET @ATTEMPT_COUNT = 0

	END

/* End of While */
END


