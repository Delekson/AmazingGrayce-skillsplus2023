-- Data extraction and loading from blob storage account
CREATE PROCEDURE nan_to_null @table varchar(255)
AS
	IF OBJECT_ID('tempdb..' + @table) IS NOT NULL
		BEGIN
			DECLARE col_cursor CURSOR FOR (
				SELECT name
				FROM Tempdb.Sys.Columns
				WHERE Object_ID = Object_ID('tempdb..' + @table)
				)

			DECLARE @col VARCHAR(255)

			OPEN col_cursor  
			FETCH NEXT FROM col_cursor INTO @col

			WHILE @@FETCH_STATUS = 0  
			BEGIN  
				DECLARE @sqlchangenan varchar(max); 
				SET @sqlchangenan = N'UPDATE ' + @table + ' SET ' + @col + ' = NULL WHERE ' + @col + ' = ''NaN'''
				EXECUTE (@sqlchangenan)
				FETCH NEXT FROM col_cursor INTO @col
			END

			CLOSE col_cursor
			DEALLOCATE col_cursor
		END
	ELSE
		PRINT @table + ' is not an existing table';
GO

CREATE PROCEDURE extract_data_from_file @datasource varchar(max), @subjectid varchar(max), @container varchar(max)
AS
	CREATE TABLE #staging (
		timestamp_s varchar(255),
		activityid varchar(255),
		heartRate_bpm varchar(255),
		handTemp_cel varchar(255),
		handAccelAxis1_16g_ms2 varchar(255),
		handAccelAxis2_16g_ms2 varchar(255),
		handAccelAxis3_16g_ms2 varchar(255),
		handAccelAxis1_6g_ms2 varchar(255),
		handAccelAxis2_6g_ms2 varchar(255),
		handAccelAxis3_6g_ms2 varchar(255),
		handGyroAxis1_rads varchar(255),
		handGyroAxis2_rads varchar(255),
		handGyroAxis3_rads varchar(255),
		handMagnoAxis1_ut varchar(255),
		handMagnoAxis2_ut varchar(255),
		handMagnoAxis3_ut varchar(255),
		handOrientation1 varchar(255),
		handOrientation2 varchar(255),
		handOrientation3 varchar(255),
		handOrientation4 varchar(255),
		chestTemp_cel varchar(255),
		chestAccelAxis1_16g_ms2 varchar(255),
		chestAccelAxis2_16g_ms2 varchar(255),
		chestAccelAxis3_16g_ms2 varchar(255),
		chestAccelAxis1_6g_ms2 varchar(255),
		chestAccelAxis2_6g_ms2 varchar(255),
		chestAccelAxis3_6g_ms2 varchar(255),
		chestGyroAxis1_rads varchar(255),
		chestGyroAxis2_rads varchar(255),
		chestGyroAxis3_rads varchar(255),
		chestMagnoAxis1_ut varchar(255),
		chestMagnoAxis2_ut varchar(255),
		chestMagnoAxis3_ut varchar(255),
		chestOrientation1 varchar(255),
		chestOrientation2 varchar(255),
		chestOrientation3 varchar(255),
		chestOrientation4 varchar(255),
		ankleTemp_cel varchar(255),
		ankleAccelAxis1_16g_ms2 varchar(255),
		ankleAccelAxis2_16g_ms2 varchar(255),
		ankleAccelAxis3_16g_ms2 varchar(255),
		ankleAccelAxis1_6g_ms2 varchar(255),
		ankleAccelAxis2_6g_ms2 varchar(255),
		ankleAccelAxis3_6g_ms2 varchar(255),
		ankleGyroAxis1_rads varchar(255),
		ankleGyroAxis2_rads varchar(255),
		ankleGyroAxis3_rads varchar(255),
		ankleMagnoAxis1_ut varchar(255),
		ankleMagnoAxis2_ut varchar(255),
		ankleMagnoAxis3_ut varchar(255),
		ankleOrientation1 varchar(255),
		ankleOrientation2 varchar(255),
		ankleOrientation3 varchar(255),
		ankleOrientation4 varchar(255)
	);

	DECLARE @sqlstagedata varchar(max);
	DECLARE @blobpath varchar(max);

	SET @blobpath = @container + '/subject' + @subjectid + '.dat'

	SET @sqlstagedata = '
	BULK INSERT #staging
	FROM ''' + @blobpath +'''
	WITH (
		DATA_SOURCE = ''' + @datasource + ''', 
		ROWTERMINATOR=''0x0a'',
		FIELDTERMINATOR='' ''
		);
	'

	EXECUTE (@sqlstagedata);
	EXECUTE nan_to_null @table = '#staging';

	INSERT INTO masterkey
	SELECT 
			@subjectid + ' ' + CONVERT(varchar(255), timestamp_s) as compositekey,
			@subjectid as id,
			timestamp_s, 
			activityid 
	FROM #staging;

	INSERT INTO imudata
	SELECT 
			@subjectid + ' ' + CONVERT(varchar(255), timestamp_s) as compositekey,
			handTemp_cel,
			CONVERT(float, handAccelAxis1_16g_ms2),
			CONVERT(float, handAccelAxis2_16g_ms2),
			CONVERT(float, handAccelAxis3_16g_ms2),
			CONVERT(float, handAccelAxis1_6g_ms2),
			CONVERT(float, handAccelAxis2_6g_ms2),
			CONVERT(float, handAccelAxis3_6g_ms2),
			CONVERT(float, handGyroAxis1_rads),
			CONVERT(float, handGyroAxis2_rads),
			CONVERT(float, handGyroAxis3_rads),
			CONVERT(float, handMagnoAxis1_ut),
			CONVERT(float, handMagnoAxis2_ut),
			CONVERT(float, handMagnoAxis3_ut),
			CONVERT(float, handOrientation1),
			CONVERT(float, handOrientation2),
			CONVERT(float, handOrientation3),
			CONVERT(float, handOrientation4),
			CONVERT(float, chestTemp_cel),
			CONVERT(float, chestAccelAxis1_16g_ms2),
			CONVERT(float, chestAccelAxis2_16g_ms2),
			CONVERT(float, chestAccelAxis3_16g_ms2),
			CONVERT(float, chestAccelAxis1_6g_ms2),
			CONVERT(float, chestAccelAxis2_6g_ms2),
			CONVERT(float, chestAccelAxis3_6g_ms2),
			CONVERT(float, chestGyroAxis1_rads),
			CONVERT(float, chestGyroAxis2_rads),
			CONVERT(float, chestGyroAxis3_rads),
			CONVERT(float, chestMagnoAxis1_ut),
			CONVERT(float, chestMagnoAxis2_ut),
			CONVERT(float, chestMagnoAxis3_ut),
			CONVERT(float, chestOrientation1),
			CONVERT(float, chestOrientation2),
			CONVERT(float, chestOrientation3),
			CONVERT(float, chestOrientation4),
			CONVERT(float, ankleTemp_cel),
			CONVERT(float, ankleAccelAxis1_16g_ms2),
			CONVERT(float, ankleAccelAxis2_16g_ms2),
			CONVERT(float, ankleAccelAxis3_16g_ms2),
			CONVERT(float, ankleAccelAxis1_6g_ms2),
			CONVERT(float, ankleAccelAxis2_6g_ms2),
			CONVERT(float, ankleAccelAxis3_6g_ms2),
			CONVERT(float, ankleGyroAxis1_rads),
			CONVERT(float, ankleGyroAxis2_rads),
			CONVERT(float, ankleGyroAxis3_rads),
			CONVERT(float, ankleMagnoAxis1_ut),
			CONVERT(float, ankleMagnoAxis2_ut),
			CONVERT(float, ankleMagnoAxis3_ut),
			CONVERT(float, ankleOrientation1),
			CONVERT(float, ankleOrientation2),
			CONVERT(float, ankleOrientation3),
			CONVERT(float, ankleOrientation4)
	FROM #staging;

	INSERT INTO hrdata
	SELECT 
		@subjectid + ' ' + CONVERT(varchar(255), timestamp_s) as compositekey,
		heartRate_bpm
	FROM #staging 
	WHERE heartRate_bpm IS NOT NULL;

	DROP TABLE #staging;
GO

-- Connecting to blob storage account
CREATE MASTER KEY 
ENCRYPTION BY PASSWORD='<redacted>';

CREATE DATABASE SCOPED CREDENTIAL azurecred  WITH IDENTITY = 'SHARED ACCESS SIGNATURE',
	SECRET = '<redacted>';

CREATE EXTERNAL DATA SOURCE amazingGrayceRaw
    WITH (
        TYPE = BLOB_STORAGE,
        LOCATION = '<redacted>',
		CREDENTIAL = azurecred
    );
GO

-- Loading subject info data into subjects table
BULK INSERT subjects
FROM 'subjectinfo/SubjectInfoSQL.csv'
WITH (
	DATA_SOURCE = 'amazingGrayceRaw',
	FORMAT = 'CSV'
	);
GO
-- Loading IMU and HR data into masterkey, imudata and hrdata
DECLARE @subjectid varchar(Max);

DECLARE subjectid_cursor CURSOR FOR (
	SELECT s.id
	FROM subjects as s
	);

OPEN subjectid_cursor 
FETCH NEXT FROM subjectid_cursor INTO @subjectid
-- Iterate through files in blob storage and insert data into respective tables
WHILE @@FETCH_STATUS = 0  
	BEGIN
		EXECUTE extract_data_from_file @datasource = 'amazingGrayceRaw', @subjectid = @subjectid, @container = 'dataprotocol'
		PRINT 'subject' + @subjectid + ' is loaded.'
		FETCH NEXT FROM subjectid_cursor INTO @subjectid
	END

CLOSE subjectid_cursor;
DEALLOCATE subjectid_cursor;
GO

SELECT * FROM masterkey;