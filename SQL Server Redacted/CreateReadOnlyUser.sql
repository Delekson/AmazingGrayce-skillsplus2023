-- =======================================================================================
-- Create User as DBO template for Azure SQL Database and Azure Synapse Analytics Database
-- =======================================================================================
-- For login login_name, create a user in the database
CREATE LOGIN <redacted>
	WITH PASSWORD = '<redacted>';
GO	

CREATE USER read_only_user FOR LOGIN <redacted>;
GO

GRANT SELECT TO <redacted>  --grant select on whole database
GRANT SELECT ON schema::dbo to <redacted>;  --grant select on one schema
GO