# SQL Scripts Documentation

## Overview

This directory contains SQL scripts for verifying, validating, analysing, and maintaining the Survey Database PostgreSQL database.

The scripts support database integrity checks, data quality assessment, survey reporting, and routine database maintenance.

## Available Scripts

### 1. `database_verification.sql`

**Purpose:** Verifies the database structure and confirms that the required database objects exist.

The script checks:

- Database tables.
- Foreign key relationships.
- Indexes.
- Database views.
- Columns exposed by the `person_survey_summary` view.
- Sample records and summary information.

**Expected outcome:** Confirmation that the six tables, five foreign key relationships, required indexes, and summary view are present.

### 2. `data_quality_checks.sql`

**Purpose:** Evaluates the consistency and completeness of records stored in the database.

The script checks:

- Missing or blank person details.
- Duplicate person codes.
- Invalid or missing ages.
- Household and district relationship validity.
- Missing education records.
- Missing employment records.
- Survey responses without valid persons.
- Missing response dates and satisfaction values.
- Survey response distribution.

**Expected outcome:** Identification of potential data quality issues requiring review. Missing employment records are not necessarily errors because employment information may be optional.

### 3. `survey_analysis_queries.sql`

**Purpose:** Provides SQL queries for extracting descriptive statistics and summaries from the survey data.

The script analyses:

- Household distribution by district.
- Population distribution by district.
- Education levels.
- Employment status.
- Age groups.
- Survey responses by round.
- Satisfaction with services.
- Average household monthly spending by district.
- Survey response history.
- The `person_survey_summary` view.

**Expected outcome:** Structured query results that demonstrate how PostgreSQL can support survey data analysis and reporting.

All results from the supplied sample dataset are illustrative and should not be interpreted as official national statistics.

### 4. `database_maintenance.sql`

**Purpose:** Provides database monitoring and maintenance queries.

The script checks:

- Database name, connected user, and PostgreSQL version.
- Database size.
- Individual table storage sizes.
- Table activity and estimated live and dead rows.
- Index usage statistics.
- Query planner statistics.

It also runs `ANALYZE` on the six database tables to update statistics used by PostgreSQL's query planner.

Optional manual `VACUUM` commands are included as commented examples and must be run separately when required.

**Expected outcome:** Database storage and activity information, together with confirmation that table statistics have been updated.

## Running the Scripts

### Requirements

- PostgreSQL installed and running.
- A database containing the Survey Database schema and sample records.
- PostgreSQL command-line utilities, including `psql`.
- A database user with sufficient privileges to execute the scripts.

### Execution

Open PowerShell and navigate to the project directory:

```powershell
cd "C:\Users\INNO\OneDrive\Desktop\WORKBOOK\survey_database"
```

Run each script separately:

```powershell
psql -U postgres -d survey_database_test -f "scripts\database_verification.sql"
```

```powershell
psql -U postgres -d survey_database_test -f "scripts\data_quality_checks.sql"
```

```powershell
psql -U postgres -d survey_database_test -f "scripts\survey_analysis_queries.sql"
```

```powershell
psql -U postgres -d survey_database_test -f "scripts\database_maintenance.sql"
```

The commands above target `survey_database_test`, the separate database used for restoration and verification testing. To run them against the original database, intentionally replace `survey_database_test` with `survey_database`.

## Execution Notes

- Execute the scripts from PowerShell or another PostgreSQL command-line environment using `psql`.
- SQL statements can also be executed in pgAdmin's Query Tool.
- Commands beginning with `psql` are operating-system commands and must not be entered into the pgAdmin Query Tool.
- The verification, quality, and analysis scripts retrieve information without intentionally modifying survey records.
- The maintenance script updates PostgreSQL planner statistics through `ANALYZE`; it does not change the survey records.
- Run maintenance operations with appropriate database permissions.

## Project Scope

These scripts are designed for the Survey Database portfolio project. They demonstrate practical SQL capabilities in database verification, relational data quality assessment, descriptive analysis, monitoring, and maintenance.

The scripts operate on the project's existing database structure and sample records.