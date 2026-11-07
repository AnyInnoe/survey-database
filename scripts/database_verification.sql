-- ============================================================
-- SURVEY DATABASE
-- DATABASE VERIFICATION SCRIPT
-- PostgreSQL
-- ============================================================

-- 1. VERIFY DATABASE TABLES
SELECT table_schema, table_name, table_type
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- 2. VERIFY FOREIGN-KEY RELATIONSHIPS
SELECT
    tc.constraint_name,
    tc.table_name AS referencing_table,
    kcu.column_name AS referencing_column,
    ccu.table_name AS referenced_table,
    ccu.column_name AS referenced_column
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
    ON tc.constraint_name = kcu.constraint_name
   AND tc.constraint_schema = kcu.constraint_schema
JOIN information_schema.constraint_column_usage ccu
    ON tc.constraint_name = ccu.constraint_name
   AND tc.constraint_schema = ccu.constraint_schema
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.constraint_schema = 'public'
ORDER BY tc.table_name, tc.constraint_name;

-- 3. VERIFY ADDITIONAL INDEXES
SELECT schemaname, tablename, indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'public'
  AND indexname IN (
      'idx_households_district_id',
      'idx_persons_household_id',
      'idx_responses_date'
  )
ORDER BY tablename, indexname;

-- 4. VERIFY SUMMARY VIEW
SELECT table_schema, table_name
FROM information_schema.views
WHERE table_schema = 'public'
  AND table_name = 'person_survey_summary';

-- 5. VERIFY VIEW COLUMNS
SELECT ordinal_position, column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'person_survey_summary'
ORDER BY ordinal_position;

-- 6. VERIFY RECORD COUNTS
SELECT 'districts' AS table_name, COUNT(*) AS total_records
FROM public.districts
UNION ALL
SELECT 'households', COUNT(*) FROM public.households
UNION ALL
SELECT 'persons', COUNT(*) FROM public.persons
UNION ALL
SELECT 'education', COUNT(*) FROM public.education
UNION ALL
SELECT 'employment', COUNT(*) FROM public.employment
UNION ALL
SELECT 'survey_responses', COUNT(*) FROM public.survey_responses
ORDER BY table_name;

-- 7. VERIFY SUMMARY VIEW DATA
SELECT *
FROM public.person_survey_summary
LIMIT 10;

-- END OF DATABASE VERIFICATION SCRIPT