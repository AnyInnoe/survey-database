# Database Design Document

## 1. Introduction

This document describes the architecture and relational design of the Survey Database implemented using PostgreSQL.

The database is designed to organize household and individual survey information through related tables. It separates geographical, household, demographic, education, employment and survey response information into distinct entities.

The design uses primary keys, foreign keys, unique constraints, check constraints and indexes to support data integrity, consistency and efficient retrieval.

## 2. Database Overview

| Property | Description |
|---|---|
| Database name | `survey_database` |
| Database management system | PostgreSQL |
| PostgreSQL version | 18.6 |
| Schema | `public` |
| Number of tables | 6 |
| Number of foreign-key relationships | 5 |
| Number of additional indexes | 3 |
| Number of views | 1 |

## 3. Database Design Principles

The database follows these principles:

### 3.1 Relational organization

Information is separated into related tables according to its subject. This reduces unnecessary duplication and provides a consistent structure for storing related records.

### 3.2 Primary key identification

Each table has a primary key that uniquely identifies its records. The identifiers use PostgreSQL identity columns where applicable.

### 3.3 Referential integrity

Foreign keys establish relationships between dependent records and their referenced parent records.

### 3.4 Data validation

Not-null, unique and check constraints restrict invalid or duplicate values in selected columns.

### 3.5 Separation of information

Education, employment and survey responses are stored separately from the main person record. This allows these categories of information to be maintained independently.

### 3.6 Query efficiency

Additional indexes are defined on selected foreign-key and date columns to support common retrieval operations.

## 4. Database Entities

The database contains six tables.

### 4.1 Districts

The `districts` table stores district identification information.

**Primary key:** `district_id`

**Important attributes:**
- `district_id`
- `district_name`

District names are required and unique.

### 4.2 Households

The `households` table stores household records and associates each household with a district.

**Primary key:** `household_id`

**Foreign key:** `district_id` references `districts.district_id`.

**Important attributes:**
- `household_id`
- `district_id`
- `household_code`
- `community_name`
- `household_size`

Each household must be associated with a district. Household codes are unique, and household size must be greater than zero.

### 4.3 Persons

The `persons` table stores individual demographic information and associates each person with a household.

**Primary key:** `person_id`

**Foreign key:** `household_id` references `households.household_id`.

**Important attributes:**
- `person_id`
- `household_id`
- `person_code`
- `given_name`
- `age`
- `sex`

Each person must belong to a household. Person codes are unique, and age is restricted to the range of 0 to 120.

### 4.4 Education

The `education` table stores education information associated with individuals.

**Primary key:** `education_id`

**Foreign key:** `person_id` references `persons.person_id`.

The `person_id` column is unique, enforcing a maximum of one education record per person.

**Important attributes:**
- `education_id`
- `person_id`
- `education_level`
- `currently_attending`

Education level is restricted to the defined values in the database constraint.

### 4.5 Employment

The `employment` table stores employment-related information associated with individuals.

**Primary key:** `employment_id`

**Foreign key:** `person_id` references `persons.person_id`.

The `person_id` column is unique, enforcing a maximum of one employment record per person.

**Important attributes:**
- `employment_id`
- `person_id`
- `employment_status`
- `monthly_income`
- `occupation`

Monthly income is optional and, when supplied, must not be negative. Occupation is also optional.

### 4.6 Survey Responses

The `survey_responses` table stores individual survey responses across survey rounds.

**Primary key:** `response_id`

**Foreign key:** `person_id` references `persons.person_id`.

**Important attributes:**
- `response_id`
- `person_id`
- `survey_round`
- `response_date`
- `satisfied_with_services`
- `household_monthly_spend`

A person may have multiple responses across different survey rounds. However, the combination of `person_id` and `survey_round` must be unique.

## 5. Entity Relationships

The database implements five foreign-key relationships.

| Parent table | Referenced primary key | Child table | Foreign-key column | Relationship |
|---|---|---|---|---|
| `districts` | `district_id` | `households` | `district_id` | One-to-many |
| `households` | `household_id` | `persons` | `household_id` | One-to-many |
| `persons` | `person_id` | `education` | `person_id` | One-to-zero-or-one |
| `persons` | `person_id` | `employment` | `person_id` | One-to-zero-or-one |
| `persons` | `person_id` | `survey_responses` | `person_id` | One-to-many |

### 5.1 District-to-household relationship

A district can be associated with multiple households. Each household references one district.

### 5.2 Household-to-person relationship

A household can contain multiple persons. Each person references one household.

### 5.3 Person-to-education relationship

A person can have zero or one education record. The unique constraint on `education.person_id` prevents multiple education records for the same person.

### 5.4 Person-to-employment relationship

A person can have zero or one employment record. The unique constraint on `employment.person_id` prevents multiple employment records for the same person.

### 5.5 Person-to-survey-response relationship

A person can have multiple survey responses. The composite unique constraint on `person_id` and `survey_round` ensures that a person cannot have more than one response recorded for the same survey round.

## 6. Database Integrity Constraints

The following constraints are implemented in the database.

| Table | Column | Constraint |
|---|---|---|
| `districts` | `district_name` | NOT NULL, UNIQUE |
| `households` | `district_id` | NOT NULL, FOREIGN KEY |
| `households` | `household_code` | NOT NULL, UNIQUE |
| `households` | `community_name` | NOT NULL |
| `households` | `household_size` | NOT NULL, CHECK greater than 0 |
| `persons` | `household_id` | NOT NULL, FOREIGN KEY |
| `persons` | `person_code` | NOT NULL, UNIQUE |
| `persons` | `given_name` | NOT NULL |
| `persons` | `age` | NOT NULL, CHECK between 0 and 120 |
| `persons` | `sex` | NOT NULL, CHECK against permitted values |
| `education` | `person_id` | NOT NULL, UNIQUE, FOREIGN KEY |
| `education` | `education_level` | NOT NULL, CHECK against permitted values |
| `education` | `currently_attending` | NOT NULL, DEFAULT false |
| `employment` | `person_id` | NOT NULL, UNIQUE, FOREIGN KEY |
| `employment` | `employment_status` | NOT NULL, CHECK against permitted values |
| `employment` | `monthly_income` | CHECK non-negative when supplied |
| `survey_responses` | `person_id` | NOT NULL, FOREIGN KEY |
| `survey_responses` | `survey_round` | NOT NULL, CHECK greater than 0 |
| `survey_responses` | `response_date` | NOT NULL |
| `survey_responses` | `satisfied_with_services` | NOT NULL |
| `survey_responses` | `household_monthly_spend` | CHECK non-negative when supplied |
| `survey_responses` | `person_id`, `survey_round` | UNIQUE combination |

The permitted values are:

- `persons.sex`: `Female`, `Male`, `Other`, `Prefer not to say`.
- `education.education_level`: `None`, `Primary`, `Secondary`, `Certificate`, `University`.
- `employment.employment_status`: `Employed`, `Self-employed`, `Unemployed`, `Student`, `Not in labor force`.

## 7. Index Design

The database includes three additional indexes:

| Index | Table | Column | Purpose |
|---|---|---|---|
| `idx_households_district_id` | `households` | `district_id` | Supports queries filtering or joining households by district. |
| `idx_persons_household_id` | `persons` | `household_id` | Supports queries retrieving persons associated with households. |
| `idx_responses_date` | `survey_responses` | `response_date` | Supports queries filtering or ordering responses by date. |

Primary-key and unique constraints also provide their associated indexes where PostgreSQL requires them.

## 8. Database View

### 8.1 View name

`person_survey_summary`

### 8.2 Purpose

The view provides a consolidated query result containing selected individual, district, education, employment and survey response information.

It combines data from the following tables:

- `persons`
- `households`
- `districts`
- `education`
- `employment`
- `survey_responses`

The `households` table provides the relationship between persons and districts. Household-specific fields are not included in the view output.

### 8.3 Join structure

The view uses:

- `INNER JOIN` between `persons` and `households`.
- `INNER JOIN` between `households` and `districts`.
- `LEFT JOIN` between `persons` and `education`.
- `LEFT JOIN` between `persons` and `employment`.
- `LEFT JOIN` between `persons` and `survey_responses`.

The inner joins require each returned person to have an associated household and district. The left joins retain the person in the result when an associated education, employment or survey response record is absent.

### 8.4 Columns returned

The view returns the following eight columns:

| Column | Data type | Description |
|---|---|---|
| `person_code` | text | Unique identification code of the individual. |
| `given_name` | text | Given name of the individual. |
| `age` | integer | Age of the individual in years. |
| `district_name` | text | Name of the district associated with the individual's household. |
| `education_level` | text | Recorded education category, where available. |
| `employment_status` | text | Recorded employment status, where available. |
| `survey_round` | integer | Survey round associated with the response, where available. |
| `satisfied_with_services` | boolean | Recorded services satisfaction response, where available. |

The view does not expose `household_code`, `community_name`, `household_size`, `response_date` or `household_monthly_spend`.

Because a person may have multiple survey responses across different rounds, the view may return multiple rows for the same person. Each matching survey response can produce a separate result row.

## 9. Database Schema

The database objects are defined in:

```text
database/schema.sql
```

This file contains the SQL schema definition used to establish the database structure.

## 10. Design Considerations

The design separates the main subject areas into related tables, uses unique identifiers to maintain record identity and applies constraints to restrict invalid values.

Education and employment are modeled as separate optional one-to-one relationships with persons. Survey responses are modeled as a one-to-many relationship to support repeated survey rounds.

The summary view provides a convenient retrieval layer without duplicating the underlying information across the base tables.

## 11. Conclusion

The database design provides a relational structure for household and individual survey information. Its entities, relationships, integrity constraints, indexes and summary view support consistent storage and organized retrieval of survey-related records.