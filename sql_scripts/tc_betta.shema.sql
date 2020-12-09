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
-- Name: logs; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.logs (
    text character varying(2000)
);


ALTER TABLE public.logs OWNER TO tc_client;

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
-- Name: r_comps; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.r_comps (
    ch_id integer NOT NULL,
    comp_id integer NOT NULL,
    comp_name character varying(200) NOT NULL,
    comp_short character varying(200),
    address character varying(200),
    post_index character varying(10),
    city character varying(200) NOT NULL,
    region character varying(200),
    code character varying(20) NOT NULL,
    tax_reg_no character varying(50) NOT NULL,
    tax_code character varying(20) NOT NULL,
    tax_payer bit(1) NOT NULL,
    comp_desc character varying(200),
    contact character varying(200),
    phone1 character varying(50),
    phone2 character varying(50),
    phone3 character varying(50),
    fax character varying(20),
    email character varying(200),
    http character varying(200),
    notes character varying(200),
    code_id1 smallint NOT NULL,
    code_id2 smallint NOT NULL,
    code_id3 smallint NOT NULL,
    code_id4 smallint NOT NULL,
    code_id5 smallint NOT NULL,
    use_codes bit(1),
    plid smallint NOT NULL,
    use_pl bit(1),
    discount numeric(21,9) NOT NULL,
    use_discount bit(1),
    pay_delay smallint NOT NULL,
    use_pay_delay bit(1),
    max_credit numeric(21,9),
    calc_max_credit bit(1),
    emp_id integer NOT NULL,
    contract1 character varying(200),
    contract2 character varying(200),
    contract3 character varying(200),
    license1 character varying(200),
    license2 character varying(200),
    license3 character varying(200),
    job1 character varying(200),
    job2 character varying(200),
    job3 character varying(200),
    tran_prc numeric(21,9) NOT NULL,
    more_prc numeric(21,9) NOT NULL,
    first_event_mode smallint NOT NULL,
    comp_type smallint NOT NULL,
    sys_tax_type smallint NOT NULL,
    fix_tax_percent numeric(21,9) NOT NULL,
    in_stop_list bit(1) NOT NULL,
    value1 numeric(21,9),
    value2 numeric(21,9),
    value3 numeric(21,9),
    pass_no character varying(50),
    pass_ser character varying(50),
    pass_date timestamp with time zone,
    pass_dept character varying(200),
    comp_gr_id1 integer NOT NULL,
    comp_gr_id2 integer NOT NULL,
    comp_gr_id3 integer NOT NULL,
    comp_gr_id4 integer NOT NULL,
    comp_gr_id5 integer NOT NULL,
    comp_name_full character varying(250) NOT NULL
);


ALTER TABLE public.r_comps OWNER TO tc_client;

--
-- Name: r_crmp; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.r_crmp (
    crid smallint NOT NULL,
    prod_id integer NOT NULL,
    cr_prod_name character varying(200) NOT NULL,
    cr_prod_id smallint NOT NULL,
    tax_id smallint NOT NULL,
    sec_id smallint NOT NULL,
    fixed_price bit(1) NOT NULL,
    price_cc numeric(21,9) NOT NULL,
    decimal_qty bit(1) NOT NULL,
    bar_code character varying(250) NOT NULL
);


ALTER TABLE public.r_crmp OWNER TO tc_client;

--
-- Name: r_crpos_pays; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.r_crpos_pays (
    crid smallint NOT NULL,
    pos_pay_id integer NOT NULL,
    is_default bit(1) NOT NULL
);


ALTER TABLE public.r_crpos_pays OWNER TO tc_client;

--
-- Name: r_crs; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.r_crs (
    ch_id integer NOT NULL,
    crid smallint NOT NULL,
    cr_name character varying(200) NOT NULL,
    notes character varying(200),
    fin_id character varying(250),
    fac_id character varying(250),
    cr_port smallint NOT NULL,
    cr_code smallint NOT NULL,
    srv_id smallint NOT NULL,
    auto_create_new_cheque bit(1),
    stock_id integer NOT NULL,
    sec_id integer NOT NULL,
    cash_type smallint NOT NULL,
    use_prod_notes bit(1) NOT NULL,
    baud_rate smallint NOT NULL,
    led_type smallint NOT NULL,
    cred_card_mask character varying(50),
    max_change numeric(21,9) NOT NULL,
    can_edit_weight_qty bit(1) NOT NULL,
    can_edit_price bit(1) NOT NULL,
    can_edit_prod_id bit(1) NOT NULL,
    can_enter_pos_discount bit(1) NOT NULL,
    ask_pwd_cn bit(1) NOT NULL,
    print_text_anull bit(1) NOT NULL,
    ask_pwd_anull bit(1) NOT NULL,
    print_report character varying(250),
    use_dec_qty_bar_code bit(1) NOT NULL,
    paper_warning bit(1) NOT NULL,
    always_show_pos_editor bit(1) NOT NULL,
    ask_pwd_cn_cheque bit(1) NOT NULL,
    ask_pwd_suspend bit(1) NOT NULL,
    ask_pwd_balance bit(1) NOT NULL,
    ask_pwd_ret bit(1) NOT NULL,
    max_suspended smallint NOT NULL,
    ask_params_after_open bit(1) NOT NULL,
    ask_params_before_close bit(1) NOT NULL,
    show_pos_disc bit(1) NOT NULL,
    show_cheque_disc bit(1) NOT NULL,
    auto_sel_discs bit(1) NOT NULL,
    ask_dcards_after_open bit(1) NOT NULL,
    ask_dcards_before_close bit(1) NOT NULL,
    can_enter_dcard bit(1) NOT NULL,
    can_enter_code_id1 bit(1) NOT NULL,
    can_enter_code_id2 bit(1) NOT NULL,
    can_enter_code_id3 bit(1) NOT NULL,
    can_enter_code_id4 bit(1) NOT NULL,
    can_enter_code_id5 bit(1) NOT NULL,
    can_enter_notes bit(1) NOT NULL,
    no_manual_dcard_enter bit(1) NOT NULL,
    show_cancels bit(1) NOT NULL,
    preview_report bit(1) NOT NULL,
    dec_qty_from_ref bit(1) NOT NULL,
    ask_visitors_after_open bit(1) NOT NULL,
    ask_pwd_period_rep bit(1) NOT NULL,
    print_report_ret character varying(250),
    mixed_pays bit(1) NOT NULL,
    print_report_mon_rec character varying(250),
    print_report_mon_exp character varying(250),
    ask_pwd_find bit(1) NOT NULL,
    use_bar_code bit(1) NOT NULL,
    use_stock_pl bit(1) NOT NULL,
    open_money_box_on_deposit bit(1) NOT NULL,
    ask_pwd_money_box bit(1) NOT NULL,
    ask_pwdd_card_find bit(1) NOT NULL,
    auto_fill_pays bit(1) NOT NULL,
    show_pos_edit_on_cancel bit(1) NOT NULL,
    check_ret_sum bit(1) NOT NULL,
    allow_invalid_mon_exp bit(1) NOT NULL,
    cash_reg_mode integer NOT NULL,
    net_port integer NOT NULL,
    modem_id character varying(250) NOT NULL,
    modem_password integer NOT NULL,
    check_ret_pay_forms bit(1) NOT NULL,
    print_report_z character varying(250),
    print_report_x character varying(250),
    print_discs bit(1) NOT NULL,
    ask_pwd_deposit bit(1) NOT NULL,
    print_after_send_order bit(1) NOT NULL,
    scale_id integer NOT NULL,
    allow_qty_reduction bit(1) NOT NULL,
    z_report_warning bit(1) NOT NULL,
    pos_emp_id_type integer NOT NULL,
    use_emps bit(1) NOT NULL,
    pos_emp_id integer NOT NULL,
    cheque_emp bit(1) NOT NULL,
    ip character varying(250),
    print_copy_for_card bit(1) NOT NULL,
    group_prods bit(1) NOT NULL,
    z_rep_after_shift bit(1) NOT NULL,
    z_rep_exec_in_time bit(1) NOT NULL,
    z_rep_shift_end_time timestamp with time zone,
    z_rep_exec_time timestamp with time zone,
    z_rep_shift_time_check integer NOT NULL,
    processing_id integer NOT NULL,
    user_name character varying(250),
    user_password character varying(250),
    print_info_anull bit(1) NOT NULL,
    auto_update_taxes bit(1) NOT NULL,
    collect_metrics bit(1) NOT NULL,
    metric_max_days integer NOT NULL,
    backup_cr_journal_after_z_report bit(1),
    change_sum_warning bit(1) NOT NULL,
    ask_pwd_pos_re_pay bit(1) NOT NULL,
    cancel_m_discs_warning bit(1) NOT NULL,
    async_cheque_input bit(1) NOT NULL,
    backup_cr_journal_after_cheque_type smallint NOT NULL,
    backup_cr_journal_cheque_timeout integer NOT NULL,
    backup_cr_journal_in_time bit(1) NOT NULL,
    backup_cr_journal_exec_time timestamp with time zone NOT NULL,
    active bit(1) NOT NULL,
    day_sale_sumcc numeric(21,9) NOT NULL,
    shift_close_time timestamp with time zone,
    backup_cr_journal_text bit(1),
    backup_cr_journal_text_chequetype integer,
    backup_cr_journal_textstartdate timestamp with time zone NOT NULL
);


ALTER TABLE public.r_crs OWNER TO tc_client;

--
-- Name: r_comps pk_r_comps; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.r_comps
    ADD CONSTRAINT pk_r_comps PRIMARY KEY (comp_id);


--
-- Name: r_crmp pk_r_crmp; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.r_crmp
    ADD CONSTRAINT pk_r_crmp PRIMARY KEY (crid, cr_prod_id);


--
-- Name: r_crpos_pays pk_r_crpospays; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.r_crpos_pays
    ADD CONSTRAINT pk_r_crpospays PRIMARY KEY (crid, pos_pay_id);


--
-- Name: r_crs pk_r_crs; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.r_crs
    ADD CONSTRAINT pk_r_crs PRIMARY KEY (crid);


--
-- Name: ppos ppos_ppo_number_key; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.ppos
    ADD CONSTRAINT ppos_ppo_number_key UNIQUE (ppo_number);


--
-- PostgreSQL database dump complete
--

