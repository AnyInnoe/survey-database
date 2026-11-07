-- ============================================================
-- SURVEY DATABASE
-- SURVEY ANALYSIS QUERIES
-- PostgreSQL
-- ============================================================

-- 1. HOUSEHOLD DISTRIBUTION BY DISTRICT
SELECT
    d.district_name,
    COUNT(h.household_id) AS total_households
FROM public.districts d
LEFT JOIN public.households h
    ON d.district_id = h.district_id
GROUP BY d.district_id, d.district_name
ORDER BY total_households DESC;


-- 2. INDIVIDUAL POPULATION BY DISTRICT
SELECT
    d.district_name,
    COUNT(p.person_id) AS total_persons
FROM public.districts d
LEFT JOIN public.households h
    ON d.district_id = h.district_id
LEFT JOIN public.persons p
    ON h.household_id = p.household_id
GROUP BY d.district_id, d.district_name
ORDER BY total_persons DESC;


-- 3. EDUCATION LEVEL DISTRIBUTION
SELECT
    e.education_level,
    COUNT(*) AS total_persons
FROM public.education e
GROUP BY e.education_level
ORDER BY total_persons DESC;


-- 4. EMPLOYMENT STATUS DISTRIBUTION
SELECT
    e.employment_status,
    COUNT(*) AS total_persons
FROM public.employment e
GROUP BY e.employment_status
ORDER BY total_persons DESC;


-- 5. AGE GROUP DISTRIBUTION
SELECT
    CASE
        WHEN age < 18 THEN 'Below 18'
        WHEN age BETWEEN 18 AND 30 THEN '18-30'
        WHEN age BETWEEN 31 AND 45 THEN '31-45'
        WHEN age BETWEEN 46 AND 60 THEN '46-60'
        ELSE 'Above 60'
    END AS age_group,
    COUNT(*) AS total_persons
FROM public.persons
WHERE age IS NOT NULL
GROUP BY age_group
ORDER BY MIN(age);


-- 6. SURVEY RESPONSES BY ROUND
SELECT
    survey_round,
    COUNT(*) AS total_responses
FROM public.survey_responses
GROUP BY survey_round
ORDER BY survey_round;


-- 7. SATISFACTION LEVEL BY SURVEY ROUND
SELECT
    survey_round,
    COUNT(*) AS total_responses,
    COUNT(*) FILTER (
        WHERE satisfied_with_services = TRUE
    ) AS satisfied_responses,
    COUNT(*) FILTER (
        WHERE satisfied_with_services = FALSE
    ) AS dissatisfied_responses,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE satisfied_with_services = TRUE
        ) / NULLIF(COUNT(satisfied_with_services), 0),
        2
    ) AS satisfaction_percentage
FROM public.survey_responses
GROUP BY survey_round
ORDER BY survey_round;


-- 8. AVERAGE HOUSEHOLD MONTHLY SPENDING BY DISTRICT
SELECT
    d.district_name,
    ROUND(AVG(sr.household_monthly_spend), 2)
        AS average_monthly_spending
FROM public.survey_responses sr
JOIN public.persons p
    ON sr.person_id = p.person_id
JOIN public.households h
    ON p.household_id = h.household_id
JOIN public.districts d
    ON h.district_id = d.district_id
GROUP BY d.district_id, d.district_name
ORDER BY average_monthly_spending DESC;


-- 9. SURVEY RESPONSE HISTORY
SELECT
    sr.response_date,
    sr.survey_round,
    COUNT(*) AS total_responses
FROM public.survey_responses sr
GROUP BY sr.response_date, sr.survey_round
ORDER BY sr.response_date, sr.survey_round;


-- 10. COMBINED PERSON AND SURVEY SUMMARY
SELECT
    person_code,
    given_name,
    age,
    district_name,
    education_level,
    employment_status,
    survey_round,
    satisfied_with_services
FROM public.person_survey_summary
ORDER BY district_name, person_code;


-- ============================================================
-- END OF SURVEY ANALYSIS QUERIES
-- ============================================================