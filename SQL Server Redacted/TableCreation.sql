-- Table Creation
CREATE TABLE subjects (
	id varchar(255) PRIMARY KEY, 
	isMale bit,
	age int,
	height int,
	weight int,
	restingHR int,
	maxHR int,
	isRightHand bit
	);

CREATE TABLE masterkey (
	compositekey varchar(255) PRIMARY KEY,
	id varchar(255) FOREIGN KEY REFERENCES subjects(id),
	timestamp_s float,
	activityid int
	);

CREATE TABLE imudata (
	compositekey varchar(255) PRIMARY KEY FOREIGN KEY REFERENCES masterkey(compositekey),
	handTemp_cel float,
	handAccelAxis1_16g_ms2 float,
	handAccelAxis2_16g_ms2 float,
	handAccelAxis3_16g_ms2 float,
	handAccelAxis1_6g_ms2 float,
	handAccelAxis2_6g_ms2 float,
	handAccelAxis3_6g_ms2 float,
	handGyroAxis1_rads float,
	handGyroAxis2_rads float,
	handGyroAxis3_rads float,
	handMagnoAxis1_ut float,
	handMagnoAxis2_ut float,
	handMagnoAxis3_ut float,
	handOrientation1 int,
	handOrientation2 int,
	handOrientation3 int,
	handOrientation4 int,
	chestTemp_cel float,
	chestAccelAxis1_16g_ms2 float,
	chestAccelAxis2_16g_ms2 float,
	chestAccelAxis3_16g_ms2 float,
	chestAccelAxis1_6g_ms2 float,
	chestAccelAxis2_6g_ms2 float,
	chestAccelAxis3_6g_ms2 float,
	chestGyroAxis1_rads float,
	chestGyroAxis2_rads float,
	chestGyroAxis3_rads float,
	chestMagnoAxis1_ut float,
	chestMagnoAxis2_ut float,
	chestMagnoAxis3_ut float,
	chestOrientation1 int,
	chestOrientation2 int,
	chestOrientation3 int,
	chestOrientation4 int,
	ankleTemp_cel float,
	ankleAccelAxis1_16g_ms2 float,
	ankleAccelAxis2_16g_ms2 float,
	ankleAccelAxis3_16g_ms2 float,
	ankleAccelAxis1_6g_ms2 float,
	ankleAccelAxis2_6g_ms2 float,
	ankleAccelAxis3_6g_ms2 float,
	ankleGyroAxis1_rads float,
	ankleGyroAxis2_rads float,
	ankleGyroAxis3_rads float,
	ankleMagnoAxis1_ut float,
	ankleMagnoAxis2_ut float,
	ankleMagnoAxis3_ut float,
	ankleOrientation1 float,
	ankleOrientation2 float,
	ankleOrientation3 float,
	ankleOrientation4 float
	);

CREATE TABLE hrdata (
	compositekey varchar(255) PRIMARY KEY FOREIGN KEY REFERENCES masterkey(compositekey),
	heartRate_bpm float
	);