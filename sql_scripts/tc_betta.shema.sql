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
-- Name: tc_main; Type: DATABASE; Schema: -; Owner: tc_client
--

CREATE DATABASE tc_main WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'ru_UA.UTF-8' LC_CTYPE = 'ru_UA.UTF-8';


ALTER DATABASE tc_main OWNER TO tc_client;

\connect tc_main

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
-- Name: app_func_get_ppo_id(integer, character varying); Type: FUNCTION; Schema: public; Owner: tc_client
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


ALTER FUNCTION public.app_func_get_ppo_id(number_ppo integer, user_password character varying) OWNER TO tc_client;

--
-- Name: app_proc_add_ppo(integer, character varying); Type: PROCEDURE; Schema: public; Owner: tc_client
--

CREATE PROCEDURE public.app_proc_add_ppo(ppo_id integer, user_password character varying)
    LANGUAGE sql
    AS $$
	insert into public.ppos(ppo_number, password)
	values (ppo_id, crypt(user_password, gen_salt('md5')))
$$;


ALTER PROCEDURE public.app_proc_add_ppo(ppo_id integer, user_password character varying) OWNER TO tc_client;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ppos; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.ppos (
    ppos_id integer NOT NULL,
    ppo_number integer NOT NULL,
    password character varying(34) NOT NULL
);


ALTER TABLE public.ppos OWNER TO tc_client;

--
-- Name: ppos_ppos_id_seq; Type: SEQUENCE; Schema: public; Owner: tc_client
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
-- Name: product_types; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.product_types (
    product_types_id integer NOT NULL,
    type_name character varying,
    type_description character varying
);


ALTER TABLE public.product_types OWNER TO tc_client;

--
-- Name: product_types_product_types_id_seq; Type: SEQUENCE; Schema: public; Owner: tc_client
--

ALTER TABLE public.product_types ALTER COLUMN product_types_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.product_types_product_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: products; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.products (
    products_id integer NOT NULL,
    product_types_id integer NOT NULL,
    product_name character varying,
    product_code numeric(13,0) NOT NULL,
    product_price money
);


ALTER TABLE public.products OWNER TO tc_client;

--
-- Name: products_products_id_seq; Type: SEQUENCE; Schema: public; Owner: tc_client
--

ALTER TABLE public.products ALTER COLUMN products_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.products_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: products pk_broducts_id; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT pk_broducts_id PRIMARY KEY (products_id);


--
-- Name: product_types pk_product_types_id; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.product_types
    ADD CONSTRAINT pk_product_types_id PRIMARY KEY (product_types_id);


--
-- Name: ppos ppos_ppo_number_key; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.ppos
    ADD CONSTRAINT ppos_ppo_number_key UNIQUE (ppo_number);


--
-- Name: product_types uq_product_types; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.product_types
    ADD CONSTRAINT uq_product_types UNIQUE (type_name);


--
-- Name: products fk_product_types_id; Type: FK CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT fk_product_types_id FOREIGN KEY (product_types_id) REFERENCES public.product_types(product_types_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

