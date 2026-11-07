# Sample Data

## 1. Overview

This directory contains fictional sample records exported from the `survey_database` PostgreSQL database.

The sample dataset is provided to demonstrate database population, data retrieval, relational integrity, reporting and restoration procedures.

**Important:** All records are fictional and are intended for demonstration and testing purposes only. They do not represent official statistics or actual survey respondents.

## 2. File Description

| File | Description |
|---|---|
| `sample_data.sql` | SQL data export containing records for the six database tables. |

## 3. Dataset Summary

The sample dataset contains 108 records distributed as follows:

| Table | Records |
|---|---:|
| districts | 10 |
| households | 20 |
| persons | 20 |
| education | 20 |
| employment | 18 |
| survey_responses | 20 |
| **Total** | **108** |

## 4. Restoration

Restore the sample records after creating the database structure using `database/schema.sql`.

Run the following command from PowerShell, replacing the project path if necessary:

```powershell
psql -U postgres -d survey_database_test -f "C:\Users\INNO\OneDrive\Desktop\WORKBOOK\survey_database\sample_data\sample_data.sql"
```

The target database must already contain the required tables and database objects.

## 5. Data Usage

The sample data supports:

- Testing primary and foreign key relationships.
- Validating database constraints.
- Demonstrating joins and views.
- Running demographic and employment queries.
- Generating survey response summaries.
- Testing backup and restoration procedures.

The sample dataset should not be interpreted as a source of official national survey findings.