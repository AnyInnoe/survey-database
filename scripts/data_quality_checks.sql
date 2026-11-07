-- ============================================================
-- SURVEY DATABASE
-- DATA QUALITY CHECKS
-- PostgreSQL
-- ============================================================

-- 1. CHECK MISSING OR BLANK PERSON DETAILS
SELECT
    person_id,
    person_code,
    given_name
FROM public.persons
WHERE person_code IS NULL
   OR BTRIM(person_code) = ''
   OR given_name IS NULL
   OR BTRIM(given_name) = '';


-- 2. CHECK DUPLICATE PERSON CODES
SELECT
    person_code,
    COUNT(*) AS occurrences
FROM public.persons
GROUP BY person_code
HAVING COUNT(*) > 1;


-- 3. CHECK INVALID OR MISSING AGES
SELECT
    person_id,
    person_code,
    age
FROM public.persons
WHERE age IS NULL
   OR age < 0
   OR age > 120
ORDER BY age;


-- 4. CHECK PERSONS WITHOUT HOUSEHOLD ASSOCIATIONS
SELECT
    p.person_id,
    p.person_code
FROM public.persons p
LEFT JOIN public.households h
    ON p.household_id = h.household_id
WHERE h.household_id IS NULL;


-- 5. CHECK HOUSEHOLDS WITHOUT A VALID DISTRICT
SELECT
    h.household_id,
    h.district_id
FROM public.households h
LEFT JOIN public.districts d
    ON h.district_id = d.district_id
WHERE d.district_id IS NULL;


-- 6. IDENTIFY PERSONS WITHOUT EDUCATION RECORDS
SELECT
    p.person_id,
    p.person_code,
    p.given_name
FROM public.persons p
LEFT JOIN public.education e
    ON p.person_id = e.person_id
WHERE e.person_id IS NULL;


-- 7. IDENTIFY PERSONS WITHOUT EMPLOYMENT RECORDS
SELECT
    p.person_id,
    p.person_code,
    p.given_name
FROM public.persons p
LEFT JOIN public.employment e
    ON p.person_id = e.person_id
WHERE e.person_id IS NULL;


-- 8. CHECK SURVEY RESPONSES WITHOUT VALID PERSON RECORDS
SELECT
    sr.person_id
FROM public.survey_responses sr
LEFT JOIN public.persons p
    ON sr.person_id = p.person_id
WHERE p.person_id IS NULL;


-- 9. CHECK MISSING SURVEY RESPONSE DATES
SELECT *
FROM public.survey_responses
WHERE response_date IS NULL;


-- 10. CHECK MISSING SATISFACTION VALUES
SELECT *
FROM public.survey_responses
WHERE satisfied_with_services IS NULL;


-- 11. SUMMARIZE SURVEY RESPONSES BY ROUND
SELECT
    survey_round,
    COUNT(*) AS total_responses
FROM public.survey_responses
GROUP BY survey_round
ORDER BY survey_round;


-- 12. SUMMARIZE INDIVIDUALS BY EDUCATION RECORD AVAILABILITY
SELECT
    COUNT(*) AS total_persons,
    COUNT(e.person_id) AS persons_with_education,
    COUNT(*) - COUNT(e.person_id) AS persons_without_education
FROM public.persons p
LEFT JOIN public.education e
    ON p.person_id = e.person_id;


-- 13. SUMMARIZE INDIVIDUALS BY EMPLOYMENT RECORD AVAILABILITY
SELECT
    COUNT(*) AS total_persons,
    COUNT(e.person_id) AS persons_with_employment_record,
    COUNT(*) - COUNT(e.person_id) AS persons_without_employment_record
FROM public.persons p
LEFT JOIN public.employment e
    ON p.person_id = e.person_id;


-- ============================================================
-- END OF DATA QUALITY CHECKS
-- ============================================================