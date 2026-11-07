--
-- PostgreSQL database dump
--

\restrict YqFYqmVQtQiEzN0EzS8e3lJzd9Tg1ZsceTVdS1XHVAhbdSzlwvLGyyQS5itQQP6

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: districts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.districts (
    district_id integer NOT NULL,
    district_name text NOT NULL
);


--
-- Name: districts_district_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.districts ALTER COLUMN district_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.districts_district_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: education; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.education (
    education_id integer NOT NULL,
    person_id integer NOT NULL,
    education_level text NOT NULL,
    currently_attending boolean DEFAULT false NOT NULL,
    CONSTRAINT education_education_level_check CHECK ((education_level = ANY (ARRAY['None'::text, 'Primary'::text, 'Secondary'::text, 'Certificate'::text, 'University'::text])))
);


--
-- Name: education_education_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.education ALTER COLUMN education_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.education_education_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: employment; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employment (
    employment_id integer NOT NULL,
    person_id integer NOT NULL,
    employment_status text NOT NULL,
    monthly_income numeric(12,2),
    occupation text,
    CONSTRAINT employment_employment_status_check CHECK ((employment_status = ANY (ARRAY['Employed'::text, 'Self-employed'::text, 'Unemployed'::text, 'Student'::text, 'Not in labor force'::text]))),
    CONSTRAINT employment_monthly_income_check CHECK (((monthly_income IS NULL) OR (monthly_income >= (0)::numeric)))
);


--
-- Name: employment_employment_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.employment ALTER COLUMN employment_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.employment_employment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: households; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.households (
    household_id integer NOT NULL,
    district_id integer NOT NULL,
    household_code text NOT NULL,
    community_name text NOT NULL,
    household_size integer NOT NULL,
    CONSTRAINT households_household_size_check CHECK ((household_size > 0))
);


--
-- Name: households_household_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.households ALTER COLUMN household_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.households_household_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: persons; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.persons (
    person_id integer NOT NULL,
    household_id integer NOT NULL,
    person_code text NOT NULL,
    given_name text NOT NULL,
    age integer NOT NULL,
    sex text NOT NULL,
    CONSTRAINT persons_age_check CHECK (((age >= 0) AND (age <= 120))),
    CONSTRAINT persons_sex_check CHECK ((sex = ANY (ARRAY['Female'::text, 'Male'::text, 'Other'::text, 'Prefer not to say'::text])))
);


--
-- Name: survey_responses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.survey_responses (
    response_id integer NOT NULL,
    person_id integer NOT NULL,
    survey_round integer NOT NULL,
    response_date date NOT NULL,
    satisfied_with_services boolean NOT NULL,
    household_monthly_spend numeric(12,2),
    CONSTRAINT survey_responses_household_monthly_spend_check CHECK (((household_monthly_spend IS NULL) OR (household_monthly_spend >= (0)::numeric))),
    CONSTRAINT survey_responses_survey_round_check CHECK ((survey_round > 0))
);


--
-- Name: person_survey_summary; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.person_survey_summary AS
 SELECT p.person_code,
    p.given_name,
    p.age,
    d.district_name,
    ed.education_level,
    em.employment_status,
    sr.survey_round,
    sr.satisfied_with_services
   FROM (((((public.persons p
     JOIN public.households h ON ((h.household_id = p.household_id)))
     JOIN public.districts d ON ((d.district_id = h.district_id)))
     LEFT JOIN public.education ed ON ((ed.person_id = p.person_id)))
     LEFT JOIN public.employment em ON ((em.person_id = p.person_id)))
     LEFT JOIN public.survey_responses sr ON ((sr.person_id = p.person_id)));


--
-- Name: persons_person_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.persons ALTER COLUMN person_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.persons_person_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: survey_responses_response_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.survey_responses ALTER COLUMN response_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.survey_responses_response_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: districts districts_district_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.districts
    ADD CONSTRAINT districts_district_name_key UNIQUE (district_name);


--
-- Name: districts districts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.districts
    ADD CONSTRAINT districts_pkey PRIMARY KEY (district_id);


--
-- Name: education education_person_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.education
    ADD CONSTRAINT education_person_id_key UNIQUE (person_id);


--
-- Name: education education_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.education
    ADD CONSTRAINT education_pkey PRIMARY KEY (education_id);


--
-- Name: employment employment_person_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employment
    ADD CONSTRAINT employment_person_id_key UNIQUE (person_id);


--
-- Name: employment employment_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employment
    ADD CONSTRAINT employment_pkey PRIMARY KEY (employment_id);


--
-- Name: households households_household_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.households
    ADD CONSTRAINT households_household_code_key UNIQUE (household_code);


--
-- Name: households households_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.households
    ADD CONSTRAINT households_pkey PRIMARY KEY (household_id);


--
-- Name: persons persons_person_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.persons
    ADD CONSTRAINT persons_person_code_key UNIQUE (person_code);


--
-- Name: persons persons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.persons
    ADD CONSTRAINT persons_pkey PRIMARY KEY (person_id);


--
-- Name: survey_responses survey_responses_person_id_survey_round_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.survey_responses
    ADD CONSTRAINT survey_responses_person_id_survey_round_key UNIQUE (person_id, survey_round);


--
-- Name: survey_responses survey_responses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.survey_responses
    ADD CONSTRAINT survey_responses_pkey PRIMARY KEY (response_id);


--
-- Name: idx_households_district_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_households_district_id ON public.households USING btree (district_id);


--
-- Name: idx_persons_household_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_persons_household_id ON public.persons USING btree (household_id);


--
-- Name: idx_responses_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_responses_date ON public.survey_responses USING btree (response_date);


--
-- Name: education education_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.education
    ADD CONSTRAINT education_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.persons(person_id);


--
-- Name: employment employment_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employment
    ADD CONSTRAINT employment_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.persons(person_id);


--
-- Name: households households_district_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.households
    ADD CONSTRAINT households_district_id_fkey FOREIGN KEY (district_id) REFERENCES public.districts(district_id);


--
-- Name: persons persons_household_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.persons
    ADD CONSTRAINT persons_household_id_fkey FOREIGN KEY (household_id) REFERENCES public.households(household_id);


--
-- Name: survey_responses survey_responses_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.survey_responses
    ADD CONSTRAINT survey_responses_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.persons(person_id);


--
-- PostgreSQL database dump complete
--

\unrestrict YqFYqmVQtQiEzN0EzS8e3lJzd9Tg1ZsceTVdS1XHVAhbdSzlwvLGyyQS5itQQP6

