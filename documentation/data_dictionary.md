# Data Dictionary

## 1. Introduction

This document defines the tables, columns, data types, keys and constraints used in the Survey Database.

The data dictionary serves as a technical reference for understanding the structure and purpose of each database field.

The database contains six tables:

1. `districts`
2. `households`
3. `persons`
4. `education`
5. `employment`
6. `survey_responses`

It also contains the `person_survey_summary` view.

## 2. Districts Table

**Purpose:** Stores district identification information.

| Column | Data type | Key | Constraints | Description |
|---|---|---|---|---|
| `district_id` | integer | PK | Identity | Unique identifier for each district. |
| `district_name` | text | — | NOT NULL, UNIQUE | Name of the district. |

## 3. Households Table

**Purpose:** Stores household information and its association with a district.

| Column | Data type | Key | Constraints | Description |
|---|---|---|---|---|
| `household_id` | integer | PK | Identity | Unique identifier for each household. |
| `district_id` | integer | FK | NOT NULL | References `districts.district_id`. |
| `household_code` | text | — | NOT NULL, UNIQUE | Unique household identification code. |
| `community_name` | text | — | NOT NULL | Name of the community associated with the household. |
| `household_size` | integer | — | NOT NULL, CHECK greater than 0 | Number of persons in the household. |

## 4. Persons Table

**Purpose:** Stores individual demographic information and household membership.

| Column | Data type | Key | Constraints | Description |
|---|---|---|---|---|
| `person_id` | integer | PK | Identity | Unique identifier for each person. |
| `household_id` | integer | FK | NOT NULL | References `households.household_id`. |
| `person_code` | text | — | NOT NULL, UNIQUE | Unique identification code for the person. |
| `given_name` | text | — | NOT NULL | Given name of the individual. |
| `age` | integer | — | NOT NULL, CHECK 0–120 | Age of the individual in years. |
| `sex` | text | — | NOT NULL, CHECK permitted values | Recorded sex category. |

**Permitted values for `sex`:**

- `Female`
- `Male`
- `Other`
- `Prefer not to say`

## 5. Education Table

**Purpose:** Stores education information associated with individuals.

| Column | Data type