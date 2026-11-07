--
-- PostgreSQL database dump
--

\restrict 5tb22Tv3UthvHU2fkyEQSjPivLTfnSxPFrgjEaPM2o1aURdBWrs4SiaowTbuLbp

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: districts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.districts (district_id, district_name) FROM stdin;
1	North District
2	South District
3	East District
4	West District
5	Central District
6	Lake District
7	Hill District
8	River District
9	Forest District
10	Valley District
\.


--
-- Data for Name: households; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.households (household_id, district_id, household_code, community_name, household_size) FROM stdin;
1	1	HH-001	Kijani	4
2	1	HH-002	Kijani	3
3	2	HH-003	Mirembe	5
4	2	HH-004	Mirembe	2
5	3	HH-005	Bukasa	6
6	3	HH-006	Bukasa	4
7	4	HH-007	Kasana	3
8	4	HH-008	Kasana	5
9	5	HH-009	Luwero	4
10	5	HH-010	Luwero	2
11	6	HH-011	Nabirye	5
12	6	HH-012	Nabirye	3
13	7	HH-013	Kato	4
14	7	HH-014	Kato	6
15	8	HH-015	Buwama	3
16	8	HH-016	Buwama	5
17	9	HH-017	Nansana	4
18	9	HH-018	Nansana	2
19	10	HH-019	Kawempe	5
20	10	HH-020	Kawempe	3
\.


--
-- Data for Name: persons; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.persons (person_id, household_id, person_code, given_name, age, sex) FROM stdin;
1	1	P-001	Amina	34	Female
2	2	P-002	Peter	39	Male
3	3	P-003	Grace	22	Female
4	4	P-004	Daniel	24	Male
5	5	P-005	Sarah	17	Female
6	6	P-006	Joseph	45	Male
7	7	P-007	Esther	29	Female
8	8	P-008	David	31	Male
9	9	P-009	Mariam	52	Female
10	10	P-010	Paul	55	Male
11	11	P-011	Ruth	19	Female
12	12	P-012	John	21	Male
13	13	P-013	Lydia	40	Female
14	14	P-014	Moses	43	Male
15	15	P-015	Joy	27	Female
16	16	P-016	Isaac	30	Male
17	17	P-017	Faith	15	Female
18	18	P-018	Mark	16	Male
19	19	P-019	Hannah	63	Female
20	20	P-020	Samuel	67	Male
\.


--
-- Data for Name: education; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.education (education_id, person_id, education_level, currently_attending) FROM stdin;
1	1	Secondary	f
2	2	Primary	f
3	3	University	f
4	4	Certificate	f
5	5	Secondary	t
6	6	Primary	f
7	7	University	f
8	8	Secondary	f
9	9	None	f
10	10	Certificate	f
11	11	Secondary	t
12	12	Primary	t
13	13	University	f
14	14	Certificate	f
15	15	Secondary	f
16	16	Primary	f
17	17	University	t
18	18	Secondary	t
19	19	None	f
20	20	Certificate	f
\.


--
-- Data for Name: employment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employment (employment_id, person_id, employment_status, monthly_income, occupation) FROM stdin;
1	1	Employed	327500.00	Services
2	2	Employed	355000.00	Agriculture
3	3	Student	382500.00	Small business
4	4	Unemployed	410000.00	Agriculture
5	5	Student	\N	Student
6	6	Self-employed	465000.00	Small business
7	7	Employed	492500.00	Services
8	8	Unemployed	520000.00	Agriculture
9	9	Not in labor force	\N	Small business
10	10	Employed	575000.00	Agriculture
11	11	Student	602500.00	Services
12	12	Self-employed	630000.00	Small business
13	13	Employed	657500.00	Services
14	14	Employed	685000.00	Agriculture
15	15	Self-employed	712500.00	Small business
16	16	Unemployed	740000.00	Agriculture
17	17	Student	\N	Student
18	18	Student	\N	Student
\.


--
-- Data for Name: survey_responses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.survey_responses (response_id, person_id, survey_round, response_date, satisfied_with_services, household_monthly_spend) FROM stdin;
1	1	1	2026-09-02	t	290000.00
2	2	1	2026-09-03	t	330000.00
3	3	1	2026-09-04	f	370000.00
4	4	1	2026-09-05	t	410000.00
5	5	1	2026-09-06	t	450000.00
6	6	1	2026-09-07	f	490000.00
7	7	1	2026-09-08	t	530000.00
8	8	1	2026-09-09	t	570000.00
9	9	1	2026-09-10	f	610000.00
10	10	1	2026-09-11	t	650000.00
11	11	1	2026-09-12	t	690000.00
12	12	1	2026-09-13	f	730000.00
13	13	1	2026-09-14	t	770000.00
14	14	1	2026-09-15	t	810000.00
15	15	1	2026-09-16	f	850000.00
16	16	1	2026-09-17	t	890000.00
17	17	1	2026-09-18	t	930000.00
18	18	1	2026-09-19	f	970000.00
19	19	1	2026-09-20	t	1010000.00
20	20	1	2026-09-21	t	1050000.00
\.


--
-- Name: districts_district_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.districts_district_id_seq', 11, true);


--
-- Name: education_education_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.education_education_id_seq', 20, true);


--
-- Name: employment_employment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employment_employment_id_seq', 18, true);


--
-- Name: households_household_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.households_household_id_seq', 21, true);


--
-- Name: persons_person_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.persons_person_id_seq', 20, true);


--
-- Name: survey_responses_response_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.survey_responses_response_id_seq', 20, true);


--
-- PostgreSQL database dump complete
--

\unrestrict 5tb22Tv3UthvHU2fkyEQSjPivLTfnSxPFrgjEaPM2o1aURdBWrs4SiaowTbuLbp

