-- ============================================================
-- SURVEY DATABASE
-- DATABASE MAINTENANCE SCRIPT
-- PostgreSQL
-- ============================================================

-- 1. DATABASE INFORMATION
SELECT
    current_database() AS database_name,
    current_user AS connected_user,
    version() AS postgresql_version;


-- 2. DATABASE SIZE
SELECT
    current_database() AS database_name,
    pg_size_pretty(
        pg_database_size(current_database())
    ) AS database_size;


-- 3. TABLE SIZE AND STORAGE INFORMATION
SELECT
    schemaname,
    relname AS table_name,
    pg_size_pretty(
        pg_total_relation_size(relid)
    ) AS total_size
FROM pg_catalog.pg_statio_user_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(relid) DESC;


-- 4. TABLE ACTIVITY AND MAINTENANCE STATISTICS
SELECT
    schemaname,
    relname AS table_name,
    seq_scan,
    idx_scan,
    n_live_tup AS estimated_live_rows,
    n_dead_tup AS estimated_dead_rows,
    last_vacuum,
    last_autovacuum,
    last_analyze,
    last_autoanalyze
FROM pg_stat_user_tables
WHERE schemaname = 'public'
ORDER BY relname;


-- 5. INDEX USAGE STATISTICS
SELECT
    schemaname,
    relname AS table_name,
    indexrelname AS index_name,
    idx_scan AS index_scans,
    idx_tup_read AS index_entries_read,
    idx_tup_fetch AS table_rows_fetched
FROM pg_stat_user_indexes
WHERE schemaname = 'public'
ORDER BY relname, indexrelname;


-- 6. UPDATE QUERY PLANNER STATISTICS
ANALYZE VERBOSE public.districts;
ANALYZE VERBOSE public.households;
ANALYZE VERBOSE public.persons;
ANALYZE VERBOSE public.education;
ANALYZE VERBOSE public.employment;
ANALYZE VERBOSE public.survey_responses;


-- 7. VERIFY TABLE STATISTICS AFTER ANALYZE
SELECT
    schemaname,
    relname AS table_name,
    n_live_tup AS estimated_live_rows,
    last_analyze,
    last_autoanalyze
FROM pg_stat_user_tables
WHERE schemaname = 'public'
ORDER BY relname;


-- ============================================================
-- OPTIONAL MANUAL VACUUM MAINTENANCE
-- Run separately when required.
-- VACUUM cannot run inside a transaction block.
-- ============================================================

-- VACUUM (VERBOSE, ANALYZE) public.districts;
-- VACUUM (VERBOSE, ANALYZE) public.households;
-- VACUUM (VERBOSE, ANALYZE) public.persons;
-- VACUUM (VERBOSE, ANALYZE) public.education;
-- VACUUM (VERBOSE, ANALYZE) public.employment;
-- VACUUM (VERBOSE, ANALYZE) public.survey_responses;


-- ============================================================
-- END OF DATABASE MAINTENANCE SCRIPT
-- ============================================================