--
-- PostgreSQL database dump
--

-- Dumped from database version 12.5 (Ubuntu 12.5-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 12.5 (Ubuntu 12.5-0ubuntu0.20.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: tc_betta; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE tc_betta WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'ru_UA.UTF-8' LC_CTYPE = 'ru_UA.UTF-8';


ALTER DATABASE tc_betta OWNER TO postgres;

\connect tc_betta

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: app_func_get_ppo_id(integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.app_func_get_ppo_id(number_ppo integer, user_password character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
	declare
	ret_value int;
	temp_password varchar;
	begin
		
		select p.password into temp_password from public.ppos p
		where p.ppo_number = number_ppo limit 1;
	
	
		select p.ppos_id into ret_value from public.ppos p
		where p.password = public.crypt(user_password, temp_password)
		limit 1;
		
	
		if ret_value is NULL then
			ret_value = 0;
		end if;
	
		
		return ret_value;
	
	end;
	$$;


ALTER FUNCTION public.app_func_get_ppo_id(number_ppo integer, user_password character varying) OWNER TO postgres;

--
-- Name: app_proc_add_ppo(integer, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.app_proc_add_ppo(ppo_id integer, user_password character varying)
    LANGUAGE sql
    AS $$
	insert into public.ppos(ppo_number, password)
	values (ppo_id, crypt(user_password, gen_salt('md5')))
$$;


ALTER PROCEDURE public.app_proc_add_ppo(ppo_id integer, user_password character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ppos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ppos (
    ppos_id integer NOT NULL,
    ppo_number integer NOT NULL,
    password character varying(34) NOT NULL
);


ALTER TABLE public.ppos OWNER TO postgres;

--
-- Name: ppos_ppos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.ppos ALTER COLUMN ppos_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.ppos_ppos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ppos ppos_ppo_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ppos
    ADD CONSTRAINT ppos_ppo_number_key UNIQUE (ppo_number);


--
-- PostgreSQL database dump complete
--

