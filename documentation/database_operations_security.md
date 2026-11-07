# Database Operations and Security

## 1. Introduction

This document describes the operational and security considerations relevant to the Survey Database implemented using PostgreSQL.

It covers database access management, user privileges, transaction handling, backup and recovery, query performance, database maintenance, monitoring and data protection.

The procedures and SQL examples provide an operational reference for administering the database. They should be applied according to the actual database environment and its access requirements. Examples in this document are administrative guidance; their inclusion does not imply that every example configuration has been applied to the database.

## 2. Database Environment

| Property | Description |
|---|---|
| Database name | `survey_database` |
| DBMS | PostgreSQL |
| PostgreSQL version | 18.6 |
| Schema | `public` |
| Administration interface | pgAdmin 4 |
| Database definition file | `database/schema.sql` |

The database structure is defined through six relational tables, primary keys, foreign keys, integrity constraints, three additional indexes and one database view.

## 3. Database Access Management

Database access should be controlled through PostgreSQL roles and privileges.

PostgreSQL supports role-based access management, allowing database administrators to assign permissions according to operational responsibilities.

### 3.1 Role management

Database roles can be created to separate administrative access from ordinary database access.

Example:

```sql
CREATE ROLE survey_readonly
LOGIN
PASSWORD 'replace_with_a_secure_password';
```

The password shown above is a placeholder and must be replaced with a secure credential. It must not be reused as an actual database password or committed to source control.

### 3.2 Database connection privileges

A role must have permission to connect to the database.

```sql
GRANT CONNECT
ON DATABASE survey_database
TO survey_readonly;
```

### 3.3 Schema access privileges

To access objects in the `public` schema:

```sql
GRANT USAGE
ON SCHEMA public
TO survey_readonly;
```

### 3.4 Read-only table access

To grant read access to existing tables and views:

```sql
GRANT SELECT
ON ALL TABLES IN SCHEMA public
TO survey_readonly;
```

For future tables created by a specified owner, default privileges can be configured:

```sql
ALTER DEFAULT PRIVILEGES
IN SCHEMA public
GRANT SELECT ON TABLES
TO survey_readonly;
```

Default privileges apply to objects created by the role for which the default privileges are configured. They are not automatically global to every database owner. If multiple roles create objects, default privileges may need to be configured separately for each relevant owner.

### 3.5 Revoking privileges

Permissions can be withdrawn when they are no longer required.

```sql
REVOKE SELECT
ON ALL TABLES IN SCHEMA public
FROM survey_readonly;
```

Role privileges should follow the principle of least privilege: each database account should receive only the permissions necessary for its responsibilities. Effective permissions may also be inherited through role membership or granted at other levels, so access reviews should consider the role's complete privilege path.

## 4. Transaction Management

PostgreSQL supports transactions to group related database operations into a single logical unit of work.

Transactions help maintain database consistency when multiple changes must succeed or fail together.

### 4.1 Beginning a transaction

```sql
BEGIN;
```

### 4.2 Committing a transaction

```sql
COMMIT;
```

`COMMIT` makes the transaction's changes permanent.

### 4.3 Rolling back a transaction

```sql
ROLLBACK;
```

`ROLLBACK` cancels changes made within the current uncommitted transaction.

### 4.4 Transaction properties

PostgreSQL transactions support the ACID properties:

- **Atomicity:** A transaction is completed as a whole or rolled back.
- **Consistency:** Database constraints must remain satisfied.
- **Isolation:** Concurrent transactions are controlled according to the selected isolation level.
- **Durability:** Committed changes are preserved according to PostgreSQL's durability mechanisms.

Transactions are particularly important when an operation involves changes to multiple related records.

## 5. Database Backup

Backups provide a means of recovering database structures and information after accidental deletion, corruption, hardware failure or other incidents.

PostgreSQL provides backup utilities that support different backup formats. The `pg_dump` utility creates a logical backup of a single database. It does not include cluster-wide roles and other global objects.

### 5.1 Logical backup using pg_dump

A complete logical backup of the database, including its schema and records, can be created using:

```powershell
pg_dump -U postgres -F c -d survey_database -f survey_database_backup.dump
```

This command creates a custom-format backup file. The command assumes that the PostgreSQL command-line utilities are available in the Windows `PATH` and that the specified database role has the required access.

### 5.2 Schema-only backup

To export the database structure without its records:

```powershell
pg_dump -U postgres --schema-only -d survey_database -f schema_backup.sql
```

A schema-only backup preserves the database definition, including its tables, constraints, indexes and views. It does not contain the original table records.

### 5.3 Backing up global objects

Database roles and other cluster-wide objects are not included in an individual database's `pg_dump` backup. Where role definitions are required for recovery, they can be exported separately:

```powershell
pg_dumpall -U postgres --globals-only -f postgres_globals.sql
```

The resulting file may contain role definitions and password verifiers. It must be protected as sensitive administrative information.

### 5.4 Backup management considerations

A backup management procedure should include:

- Regular backup scheduling.
- Secure storage of backup files.
- Access restrictions on backup locations.
- Appropriate backup retention periods.
- Copies stored separately from the primary database environment.
- Periodic verification of backup integrity.
- Recovery testing.

Backup files may contain sensitive information. They should be protected accordingly.

## 6. Database Recovery

PostgreSQL provides restoration utilities for recovering databases from backup files.

### 6.1 Restoring a custom-format backup

Create the destination database if it does not already exist:

```sql
CREATE DATABASE survey_database_restore;
```

Restore the custom-format backup:

```powershell
pg_restore -U postgres -d survey_database_restore survey_database_backup.dump
```

If the backup was created with ownership information, the required roles should exist in the destination PostgreSQL environment, or the restore should be performed with appropriate ownership options.

### 6.2 Restoring a schema-only SQL backup

For the schema-only SQL backup created in Section 5.2:

```powershell
psql -U postgres -d survey_database_restore -f schema_backup.sql
```

This restores the database structure only. It does not restore the original records.

For a complete plain-format SQL backup containing both schema and records, use `pg_dump` without `--schema-only`, then restore the resulting SQL file with `psql`:

```powershell
pg_dump -U postgres -F p -d survey_database -f survey_database_full.sql
psql -U postgres -d survey_database_restore -f survey_database_full.sql
```

### 6.3 Recovery considerations

Before restoring a backup:

1. Confirm that the backup file is accessible.
2. Verify that the destination database is correct.
3. Confirm compatibility with the PostgreSQL environment.
4. Check required database roles and ownership.
5. Review restoration output for errors.
6. Verify restored tables, relationships, indexes and views.
7. Validate recovered data before returning the database to service.

Restoration should be tested in a separate environment before being used for production recovery.

## 7. Query Performance and Optimization

Query performance is important when retrieving information from relational tables, particularly when queries involve joins, filtering and aggregation.

### 7.1 Index utilization

The database includes additional indexes on:

- `households.district_id`
- `persons.household_id`
- `survey_responses.response_date`

These indexes support selected retrieval operations involving district associations, household membership and response dates.

### 7.2 Query execution plans

PostgreSQL provides `EXPLAIN` to display the execution plan selected for a query.

Example:

```sql
EXPLAIN
SELECT *
FROM survey_responses
WHERE response_date >= DATE '2026-01-01';
```

### 7.3 Execution analysis

`EXPLAIN ANALYZE` executes the query and reports actual execution information.

```sql
EXPLAIN ANALYZE
SELECT *
FROM survey_responses
WHERE response_date >= DATE '2026-01-01';
```

Execution plans can help identify inefficient scans, join operations and other performance issues. Because `EXPLAIN ANALYZE` executes the statement, it should be used carefully with statements that modify data.

### 7.4 Optimization considerations

Query optimization should consider:

- Appropriate indexing.
- Efficient join conditions.
- Filtering records as early as practical.
- Retrieving only required columns.
- Avoiding unnecessary repeated queries.
- Reviewing execution plans.
- Monitoring query execution time.

Indexes should be evaluated against actual query patterns because unnecessary indexes increase storage requirements and the cost of data modification.

## 8. Database Maintenance

PostgreSQL uses maintenance processes to manage storage, update query-planner statistics and support database performance.

### 8.1 VACUUM

`VACUUM` reclaims space occupied by obsolete row versions so that it can be reused.

```sql
VACUUM;
```

### 8.2 ANALYZE

`ANALYZE` collects statistics used by the PostgreSQL query planner.

```sql
ANALYZE;
```

### 8.3 VACUUM ANALYZE

Both operations can be performed together:

```sql
VACUUM ANALYZE;
```

PostgreSQL also provides automatic maintenance through autovacuum, which should normally remain appropriately configured. `VACUUM` and `VACUUM ANALYZE` should be run as standalone commands rather than inside an explicit transaction block.

### 8.4 Maintenance considerations

Database maintenance should include:

- Monitoring database storage.
- Reviewing autovacuum activity.
- Updating planner statistics.
- Monitoring long-running transactions.
- Reviewing connection usage.
- Checking database logs.
- Investigating recurring errors.
- Reviewing index usage and query performance.

## 9. Database Security

Survey information can contain personal and household-related details. Access to the database should therefore be controlled and sensitive information protected.

### 9.1 Authentication

Database users should authenticate through approved PostgreSQL authentication mechanisms.

Strong credentials should be used, and database access should not rely on shared accounts where individual accountability is required.

### 9.2 Authorization

Database privileges should be assigned according to defined responsibilities.

Administrative permissions should be restricted to authorized database administrators.

Read-only users should not receive unnecessary insert, update, delete or schema modification privileges.

### 9.3 Credential protection

Database passwords and other credentials should not be committed to public repositories.

Connection credentials should be stored outside source-controlled files and protected through appropriate environment-specific configuration.

### 9.4 Network security

Database connections should be restricted to trusted systems and authorized network locations.

Where connections pass through untrusted networks, encrypted connections using TLS should be configured appropriately.

### 9.5 Data protection

The following controls should be considered:

- Restrict access to identifiable household and individual information.
- Avoid publishing real survey respondent records in public repositories.
- Use synthetic or properly anonymized data for demonstrations.
- Protect database backups.
- Apply appropriate data retention requirements.
- Restrict access to exported reports and database dumps.
- Avoid exposing sensitive information through logs or error messages.

### 9.6 Least privilege

Database accounts should receive only the privileges required for their assigned tasks.

This reduces the risk of accidental modification, unauthorized disclosure and misuse of database records.

## 10. Database Monitoring and Troubleshooting

Database monitoring helps identify performance issues, connection problems and unexpected database activity.

### 10.1 Active connections

PostgreSQL provides the `pg_stat_activity` system view for inspecting database sessions.

```sql
SELECT
    pid,
    usename,
    datname,
    state,
    query_start,
    query
FROM pg_stat_activity
WHERE datname = 'survey_database';
```

Access to query details may depend on the privileges of the inspecting database role.

### 10.2 Database size

The database size can be checked using:

```sql
SELECT
    pg_size_pretty(
        pg_database_size('survey_database')
    ) AS database_size;
```

### 10.3 Common troubleshooting areas

Database troubleshooting should consider:

- Authentication failures.
- Insufficient database privileges.
- Missing or incorrect database objects.
- Foreign-key constraint violations.
- Unique constraint violations.
- Invalid values rejected by check constraints.
- Connection failures.
- Slow query execution.
- Storage limitations.
- Backup and restoration errors.

PostgreSQL server logs and administrative views provide useful information for investigating these issues.

## 11. Operational Recommendations

For reliable database operation, the following controls are recommended:

1. Maintain regular database backups.
2. Test recovery procedures periodically.
3. Apply least-privilege access control.
4. Protect database credentials.
5. Restrict access to sensitive records.
6. Monitor database activity and storage.
7. Review slow queries and execution plans.
8. Maintain PostgreSQL using appropriate maintenance procedures.
9. Verify database changes before applying them to important environments.
10. Keep the database schema documentation aligned with the actual implementation.

## 12. Conclusion

The Survey Database uses PostgreSQL relational structures and integrity constraints to organize household and individual survey information.

Effective operation requires appropriate access management, transaction control, backup and recovery procedures, query performance analysis, routine maintenance and security controls.

These operational considerations support the reliability, integrity and protection of the database throughout its lifecycle.
