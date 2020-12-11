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
    tax_payer boolean NOT NULL,
    comp_desc character varying(200),
    contact character varying(200),
    phone1 character varying(50),
    phone2 character varying(50),
    phone3 character varying(50),
    fax character varying(20),
    e_mail character varying(200),
    http character varying(200),
    notes character varying(200),
    code_id1 smallint NOT NULL,
    code_id2 smallint NOT NULL,
    code_id3 smallint NOT NULL,
    code_id4 smallint NOT NULL,
    code_id5 smallint NOT NULL,
    use_codes boolean,
    plid smallint NOT NULL,
    use_pl boolean,
    discount numeric(21,9) NOT NULL,
    use_discount boolean,
    pay_delay smallint NOT NULL,
    use_pay_delay boolean,
    max_credit numeric(21,9),
    calc_max_credit boolean,
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
    in_stop_list boolean NOT NULL,
    value1 numeric(21,9),
    value2 numeric(21,9),
    value3 numeric(21,9),
    pass_no character varying(50),
    pass_ser character varying(50),
    pass_date timestamp with time zone,
    pass_dept character varying(200),
    comp_gr_id1 integer DEFAULT 0 NOT NULL,
    comp_gr_id2 integer DEFAULT 0 NOT NULL,
    comp_gr_id3 integer DEFAULT 0 NOT NULL,
    comp_gr_id4 integer DEFAULT 0 NOT NULL,
    comp_gr_id5 integer DEFAULT 0 NOT NULL,
    comp_name_full character varying(250) NOT NULL
);


ALTER TABLE public.r_comps OWNER TO tc_client;

--
-- Name: r_cr_uni_input; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.r_cr_uni_input (
    ch_id integer NOT NULL,
    uni_input_code integer NOT NULL,
    uni_input_action integer DEFAULT 0 NOT NULL,
    uni_input_mask character varying(250),
    notes character varying(250),
    uni_input boolean NOT NULL
);


ALTER TABLE public.r_cr_uni_input OWNER TO tc_client;

--
-- Name: r_crmp; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.r_crmp (
    cr_id smallint NOT NULL,
    prod_id integer NOT NULL,
    cr_prod_name character varying(200) NOT NULL,
    cr_prod_id smallint NOT NULL,
    tax_id smallint NOT NULL,
    sec_id integer NOT NULL,
    fixed_price boolean NOT NULL,
    price_cc numeric(21,9) NOT NULL,
    decimal_qty boolean NOT NULL,
    bar_code character varying(250) NOT NULL
);


ALTER TABLE public.r_crmp OWNER TO tc_client;

--
-- Name: r_crpos_pays; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.r_crpos_pays (
    cr_id smallint NOT NULL,
    pos_pay_id integer NOT NULL,
    is_default boolean NOT NULL
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
    auto_create_new_cheque boolean,
    stock_id integer NOT NULL,
    sec_id integer NOT NULL,
    cash_type smallint NOT NULL,
    use_prod_notes boolean NOT NULL,
    baud_rate smallint NOT NULL,
    led_type smallint NOT NULL,
    cred_card_mask character varying(50),
    max_change numeric(21,9) NOT NULL,
    can_edit_weight_qty boolean NOT NULL,
    can_edit_price boolean NOT NULL,
    can_edit_prod_id boolean NOT NULL,
    can_enter_pos_discount boolean NOT NULL,
    ask_pwd_cn boolean NOT NULL,
    print_text_anull boolean NOT NULL,
    ask_pwd_anull boolean NOT NULL,
    print_report character varying(250) DEFAULT ''::character varying,
    use_dec_qty_bar_code boolean DEFAULT false NOT NULL,
    paper_warning boolean DEFAULT false NOT NULL,
    always_show_pos_editor boolean DEFAULT false NOT NULL,
    ask_pwd_cn_cheque boolean DEFAULT false NOT NULL,
    ask_pwd_suspend boolean DEFAULT false NOT NULL,
    ask_pwd_balance boolean DEFAULT false NOT NULL,
    ask_pwd_ret boolean DEFAULT false NOT NULL,
    max_suspended smallint DEFAULT 3 NOT NULL,
    ask_params_after_open boolean DEFAULT false NOT NULL,
    ask_params_before_close boolean DEFAULT true NOT NULL,
    show_pos_disc boolean DEFAULT true NOT NULL,
    show_cheque_disc boolean DEFAULT true NOT NULL,
    auto_sel_discs boolean DEFAULT true NOT NULL,
    ask_d_cards_after_open boolean DEFAULT false NOT NULL,
    ask_d_cards_before_close boolean DEFAULT true NOT NULL,
    can_enter_d_card boolean DEFAULT true NOT NULL,
    can_enter_code_id1 boolean DEFAULT true NOT NULL,
    can_enter_code_id2 boolean DEFAULT true NOT NULL,
    can_enter_code_id3 boolean DEFAULT true NOT NULL,
    can_enter_code_id4 boolean DEFAULT true NOT NULL,
    can_enter_code_id5 boolean DEFAULT true NOT NULL,
    can_enter_notes boolean DEFAULT true NOT NULL,
    no_manual_d_card_enter boolean DEFAULT true NOT NULL,
    show_cancels boolean DEFAULT true NOT NULL,
    preview_report boolean DEFAULT false NOT NULL,
    dec_qty_from_ref boolean NOT NULL,
    ask_visitors_after_open boolean NOT NULL,
    ask_pwd_period_rep boolean NOT NULL,
    print_report_ret character varying(250) DEFAULT ''::character varying,
    mixed_pays boolean DEFAULT true NOT NULL,
    print_report_mon_rec character varying(250) DEFAULT ''::character varying,
    print_report_mon_exp character varying(250) DEFAULT ''::character varying,
    ask_pwd_find boolean DEFAULT false NOT NULL,
    use_bar_code boolean DEFAULT true NOT NULL,
    use_stock_pl boolean DEFAULT false NOT NULL,
    open_money_box_on_deposit boolean DEFAULT false NOT NULL,
    ask_pwd_money_box boolean DEFAULT false NOT NULL,
    ask_pwd_d_card_find boolean DEFAULT true NOT NULL,
    auto_fill_pays boolean DEFAULT false NOT NULL,
    show_pos_edit_on_cancel boolean DEFAULT true NOT NULL,
    check_ret_sum boolean DEFAULT false NOT NULL,
    allow_invalid_mon_exp boolean DEFAULT false NOT NULL,
    cash_reg_mode integer DEFAULT 0 NOT NULL,
    net_port integer DEFAULT 0 NOT NULL,
    modem_id character varying(250) DEFAULT false NOT NULL,
    modem_password integer DEFAULT 0 NOT NULL,
    check_ret_pay_forms boolean DEFAULT false NOT NULL,
    print_report_z character varying(250),
    print_report_x character varying(250),
    print_discs boolean DEFAULT false NOT NULL,
    ask_pwd_deposit boolean DEFAULT false NOT NULL,
    print_after_send_order boolean DEFAULT true NOT NULL,
    scale_id integer DEFAULT 0 NOT NULL,
    allow_qty_reduction boolean DEFAULT false NOT NULL,
    z_report_warning boolean DEFAULT false NOT NULL,
    pos_emp_id_type integer DEFAULT 0 NOT NULL,
    use_emps boolean DEFAULT false NOT NULL,
    pos_emp_id integer DEFAULT 0 NOT NULL,
    cheque_emp boolean DEFAULT true NOT NULL,
    ip character varying(250),
    print_copy_for_card boolean DEFAULT false NOT NULL,
    group_prods boolean DEFAULT true NOT NULL,
    z_rep_after_shift boolean DEFAULT false NOT NULL,
    z_rep_exec_in_time boolean DEFAULT false NOT NULL,
    z_rep_shift_end_time timestamp with time zone DEFAULT '1900-01-01 08:00:00+02:20'::timestamp with time zone,
    z_rep_exec_time timestamp with time zone DEFAULT '1900-01-01 08:00:00+02:20'::timestamp with time zone,
    z_rep_shift_time_check integer DEFAULT 0 NOT NULL,
    processing_id integer DEFAULT 0 NOT NULL,
    user_name character varying(250),
    user_password character varying(250),
    print_info_anull boolean DEFAULT false NOT NULL,
    auto_update_taxes boolean DEFAULT false NOT NULL,
    collect_metrics boolean DEFAULT false NOT NULL,
    metric_max_days integer DEFAULT 20 NOT NULL,
    backup_cr_journal_after_z_report boolean DEFAULT false,
    change_sum_warning boolean DEFAULT true NOT NULL,
    ask_pwd_pos_re_pay boolean DEFAULT false NOT NULL,
    cancel_m_discs_warning boolean DEFAULT true NOT NULL,
    async_cheque_input boolean DEFAULT false NOT NULL,
    backup_cr_journal_after_cheque_type smallint DEFAULT 0 NOT NULL,
    backup_cr_journal_cheque_timeout integer DEFAULT 0 NOT NULL,
    backup_cr_journal_in_time boolean DEFAULT false NOT NULL,
    backup_cr_journal_exec_time timestamp with time zone DEFAULT '1900-01-01 08:00:00+02:20'::timestamp with time zone NOT NULL,
    active boolean DEFAULT true NOT NULL,
    day_sale_sum_cc numeric(21,9) DEFAULT 0 NOT NULL,
    shift_close_time timestamp with time zone,
    backup_cr_journal_text boolean,
    backup_cr_journal_text_cheque_type integer,
    backup_cr_journal_text_start_date timestamp with time zone DEFAULT '1900-01-01 08:00:00+02:20'::timestamp with time zone NOT NULL
);


ALTER TABLE public.r_crs OWNER TO tc_client;

--
-- Name: r_d_cards; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.r_d_cards (
    ch_id integer NOT NULL,
    comp_id integer NOT NULL,
    d_card_id character varying(250) NOT NULL,
    discount numeric(21,9) NOT NULL,
    sum_cc numeric(21,9),
    in_use boolean NOT NULL,
    notes character varying(200),
    value1 numeric(21,9) NOT NULL,
    value2 numeric(21,9) NOT NULL,
    value3 numeric(21,9) NOT NULL,
    is_crd_card boolean NOT NULL,
    note1 character varying(200),
    e_date timestamp with time zone,
    client_name character varying(4000),
    dc_type_code integer NOT NULL,
    birth_date timestamp with time zone,
    fact_region character varying(250),
    fact_district character varying(250),
    fact_city character varying(250),
    fact_street character varying(250),
    fact_house character varying(250),
    fact_block character varying(250),
    fact_apt_no character varying(250),
    fact_post_index character varying(50),
    phone_mob character varying(1000),
    phone_home character varying(20),
    phone_work character varying(20),
    e_mail character varying(250),
    sum_bonus numeric(21,9) NOT NULL,
    status integer NOT NULL,
    b_date timestamp with time zone,
    is_pay_card boolean DEFAULT false NOT NULL,
    auto_save_odd_money_to_processing boolean DEFAULT false NOT NULL
);


ALTER TABLE public.r_d_cards OWNER TO tc_client;

--
-- Name: r_dc_group; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.r_dc_group (
    ch_id integer NOT NULL,
    dc_group_code integer NOT NULL,
    dc_group_name character varying(500) NOT NULL,
    date_create timestamp with time zone NOT NULL,
    user_create character varying(150) NOT NULL,
    date_change timestamp with time zone NOT NULL,
    user_change character varying(150) NOT NULL,
    date_begin timestamp with time zone,
    date_end timestamp with time zone
);


ALTER TABLE public.r_dc_group OWNER TO tc_client;

--
-- Name: r_dc_group_ch_id_seq; Type: SEQUENCE; Schema: public; Owner: tc_client
--

ALTER TABLE public.r_dc_group ALTER COLUMN ch_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.r_dc_group_ch_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: r_dc_type_g; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.r_dc_type_g (
    ch_id integer NOT NULL,
    dc_type_gcode integer NOT NULL,
    dc_type_gname character varying(250) NOT NULL,
    notes character varying(250),
    main_dialog boolean NOT NULL,
    close_dialog_after_enter boolean NOT NULL,
    processing_id integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.r_dc_type_g OWNER TO tc_client;

--
-- Name: r_dc_types; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.r_dc_types (
    ch_id integer NOT NULL,
    dc_type_code integer NOT NULL,
    dc_type_name character varying(200) NOT NULL,
    value1 numeric(21,9) NOT NULL,
    value2 numeric(21,9) NOT NULL,
    value3 numeric(21,9) NOT NULL,
    init_sum numeric(21,9) NOT NULL,
    prod_id integer NOT NULL,
    notes character varying(1000),
    max_qty integer DEFAULT 1 NOT NULL,
    dc_type_gcode integer NOT NULL,
    deactivate_after_use boolean NOT NULL,
    no_manual_dcard_enter boolean DEFAULT false NOT NULL
);


ALTER TABLE public.r_dc_types OWNER TO tc_client;

--
-- Name: r_disc_dc; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.r_disc_dc (
    disc_code integer NOT NULL,
    dc_type_code integer NOT NULL,
    for_rec boolean NOT NULL,
    for_exp boolean NOT NULL
);


ALTER TABLE public.r_disc_dc OWNER TO tc_client;

--
-- Name: r_discs; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.r_discs (
    ch_id integer NOT NULL,
    disc_code integer NOT NULL,
    disc_name character varying(200) NOT NULL,
    this_charge_only boolean NOT NULL,
    this_doc_bonus boolean NOT NULL,
    other_docs_bonus boolean NOT NULL,
    charge_dcard boolean NOT NULL,
    disc_only_with_dcard boolean NOT NULL,
    charge_after_close boolean NOT NULL,
    priority integer NOT NULL,
    allow_discs character varying(250),
    shed1 character varying(2000),
    shed2 character varying(2000),
    shed3 character varying(2000),
    b_date timestamp with time zone NOT NULL,
    e_date timestamp with time zone NOT NULL,
    gen_procs boolean DEFAULT true NOT NULL,
    in_use boolean DEFAULT true NOT NULL,
    doc_code integer DEFAULT 1011 NOT NULL,
    simple_disc boolean DEFAULT true NOT NULL,
    save_disc_to_dcard boolean DEFAULT true NOT NULL,
    save_bonus_to_dcard boolean DEFAULT true NOT NULL,
    disc_from_dcard boolean DEFAULT true NOT NULL,
    re_process_pos_discs boolean DEFAULT true NOT NULL,
    valid_ours character varying(250),
    valid_stocks character varying(250),
    auto_sel_discs boolean DEFAULT true NOT NULL,
    short_cut character varying(250),
    notes character varying(250),
    group_disc boolean NOT NULL,
    print_in_cheque boolean DEFAULT true NOT NULL,
    allow_zero_price boolean DEFAULT true NOT NULL,
    redistribute_disc_sum_in_busket boolean DEFAULT true NOT NULL,
    disc_ext_code integer,
    allow_edit_qty boolean DEFAULT true NOT NULL
);


ALTER TABLE public.r_discs OWNER TO tc_client;

--
-- Name: r_emps; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.r_emps (
    ch_id integer NOT NULL,
    emp_id integer NOT NULL,
    emp_name character varying(200) NOT NULL,
    ua_emp_name character varying(200) NOT NULL,
    emp_last_name character varying(200),
    emp_first_name character varying(200),
    emp_par_name character varying(200),
    ua_emp_last_name character varying(200),
    ua_emp_first_name character varying(200),
    ua_emp_par_name character varying(200),
    emp_initials character varying(200),
    ua_emp_initials character varying(200),
    tax_code character varying(50),
    emp_sex smallint NOT NULL,
    birth_day timestamp with time zone,
    file1 character varying(200),
    file2 character varying(200),
    file3 character varying(200),
    education smallint,
    family_status smallint NOT NULL,
    birth_place character varying(200),
    phone character varying(20),
    in_phone character varying(20),
    mobile character varying(200),
    e_mail character varying(200),
    percent1 numeric(21,9) NOT NULL,
    percent2 numeric(21,9) NOT NULL,
    percent3 numeric(21,9) NOT NULL,
    notes character varying(200),
    mil_status smallint NOT NULL,
    mil_fitness smallint NOT NULL,
    mil_rank character varying(200),
    mil_special_calc character varying(200),
    mil_profes character varying(200),
    mil_calc_grp character varying(200),
    mil_calc_cat character varying(200),
    mil_staff character varying(200),
    mil_reg_office character varying(200),
    mil_num character varying(20),
    pass_no character varying(50),
    pass_ser character varying(50),
    pass_date timestamp with time zone,
    pass_dept character varying(200),
    dis_num character varying(20),
    pens_num character varying(20),
    work_book_no character varying(50),
    work_book_ser character varying(50),
    per_file_no character varying(50),
    in_stop_list boolean NOT NULL,
    bar_code character varying(250),
    shift_post_id integer DEFAULT 0 NOT NULL,
    is_citizen boolean DEFAULT true NOT NULL,
    cert_insur_ser character varying(250),
    cert_insur_num character varying(250)
);


ALTER TABLE public.r_emps OWNER TO tc_client;

--
-- Name: r_oper_crs; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.r_oper_crs (
    cr_id smallint NOT NULL,
    oper_id integer NOT NULL,
    cr_oper_id smallint NOT NULL,
    oper_max_qty numeric(21,9) NOT NULL,
    can_edit_discount boolean,
    cr_visible boolean NOT NULL,
    oper_pwd integer NOT NULL,
    allow_cheque_close boolean DEFAULT true NOT NULL,
    allow_add_to_cheque_from_cat boolean DEFAULT true NOT NULL
);


ALTER TABLE public.r_oper_crs OWNER TO tc_client;

--
-- Name: r_opers; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.r_opers (
    ch_id integer NOT NULL,
    oper_id integer NOT NULL,
    oper_name character varying(10) NOT NULL,
    oper_pwd integer NOT NULL,
    emp_id integer NOT NULL,
    cr_admin boolean,
    oper_lock_pwd character varying(200) NOT NULL
);


ALTER TABLE public.r_opers OWNER TO tc_client;

--
-- Name: r_pay_forms; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.r_pay_forms (
    ch_id integer NOT NULL,
    pay_form_code integer NOT NULL,
    pay_form_name character varying(200) NOT NULL,
    notes character varying(200),
    sumlabel character varying(50),
    notes_label character varying(50),
    can_enter_notes boolean NOT NULL,
    notes_mask character varying(250),
    can_enter_sum boolean NOT NULL,
    max_qty integer NOT NULL,
    is_default boolean NOT NULL,
    for_sale boolean NOT NULL,
    for_ret boolean NOT NULL,
    auto_calc_sum integer DEFAULT 0 NOT NULL,
    dc_type_gcode integer DEFAULT 0 NOT NULL,
    group_pays integer NOT NULL
);


ALTER TABLE public.r_pay_forms OWNER TO tc_client;

--
-- Name: r_pls; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.r_pls (
    ch_id integer NOT NULL,
    pl_id smallint NOT NULL,
    pl_name character varying(200) NOT NULL,
    notes character varying(200)
);


ALTER TABLE public.r_pls OWNER TO tc_client;

--
-- Name: r_pos_pays; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.r_pos_pays (
    ch_id integer NOT NULL,
    pos_pay_id integer NOT NULL,
    pos_pay_name character varying(250) NOT NULL,
    pos_pay_class character varying(250) NOT NULL,
    pos_pay_port integer NOT NULL,
    pos_pay_timeout integer NOT NULL,
    notes character varying(250),
    use_grp_card_for_discs boolean DEFAULT false NOT NULL,
    use_union_cheque boolean DEFAULT false NOT NULL,
    print_tran_info_in_cheque boolean DEFAULT false NOT NULL,
    ip character varying(250),
    net_port integer
);


ALTER TABLE public.r_pos_pays OWNER TO tc_client;

--
-- Name: r_processings; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.r_processings (
    ch_id integer NOT NULL,
    processing_id integer NOT NULL,
    processing_name character varying(250) NOT NULL,
    processing_type integer DEFAULT 0,
    ip character varying(20) NOT NULL,
    net_port integer DEFAULT 0 NOT NULL,
    path character varying(250),
    max_difference integer DEFAULT 0 NOT NULL,
    multiplicity integer DEFAULT 0 NOT NULL,
    retry_time timestamp with time zone DEFAULT '2020-01-01 00:00:00+02'::timestamp with time zone NOT NULL,
    retry_period integer NOT NULL,
    extra_info character varying(8000)
);


ALTER TABLE public.r_processings OWNER TO tc_client;

--
-- Name: r_prod_a; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.r_prod_a (
    ch_id integer NOT NULL,
    p_gr_a_id smallint NOT NULL,
    p_gr_a_name character varying(200) NOT NULL,
    notes character varying(200)
);


ALTER TABLE public.r_prod_a OWNER TO tc_client;

--
-- Name: r_prod_c; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.r_prod_c (
    ch_id integer NOT NULL,
    p_cat_id integer NOT NULL,
    p_cat_name character varying(200) NOT NULL,
    notes character varying(200)
);


ALTER TABLE public.r_prod_c OWNER TO tc_client;

--
-- Name: r_prod_g; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.r_prod_g (
    ch_id integer NOT NULL,
    p_gr_id integer NOT NULL,
    p_gr_name character varying(200) NOT NULL,
    notes character varying(200)
);


ALTER TABLE public.r_prod_g OWNER TO tc_client;

--
-- Name: r_prod_g1; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.r_prod_g1 (
    ch_id integer NOT NULL,
    p_gr_id1 integer NOT NULL,
    p_gr_name1 character varying(200) NOT NULL,
    notes character varying(200)
);


ALTER TABLE public.r_prod_g1 OWNER TO tc_client;

--
-- Name: r_prod_g2; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.r_prod_g2 (
    ch_id integer NOT NULL,
    p_gr_id2 integer NOT NULL,
    p_gr_name2 character varying(200) NOT NULL,
    notes character varying(200)
);


ALTER TABLE public.r_prod_g2 OWNER TO tc_client;

--
-- Name: r_prod_g3; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.r_prod_g3 (
    ch_id integer NOT NULL,
    p_gr_id3 integer NOT NULL,
    p_gr_name3 character varying(200) NOT NULL,
    notes character varying(200)
);


ALTER TABLE public.r_prod_g3 OWNER TO tc_client;

--
-- Name: r_prod_mp; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.r_prod_mp (
    prod_id integer NOT NULL,
    pl_id smallint NOT NULL,
    price_mc numeric(21,9) NOT NULL,
    notes character varying(200),
    curr_id smallint NOT NULL
);


ALTER TABLE public.r_prod_mp OWNER TO tc_client;

--
-- Name: r_prod_mq; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.r_prod_mq (
    prod_id integer NOT NULL,
    um character varying(50) NOT NULL,
    qty numeric(21,9) NOT NULL,
    weight numeric(21,9),
    notes character varying(200),
    bar_code character varying(42) NOT NULL,
    prod_bar_code character varying(42),
    pl_id smallint NOT NULL,
    state smallint DEFAULT 1
);


ALTER TABLE public.r_prod_mq OWNER TO tc_client;

--
-- Name: r_prods; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.r_prods (
    ch_id integer NOT NULL,
    prod_id integer NOT NULL,
    prod_name character varying(200) NOT NULL,
    um character varying(10) NOT NULL,
    country character varying(200),
    notes character varying(200),
    p_cat_id integer NOT NULL,
    p_gr_id integer NOT NULL,
    article1 character varying(200),
    article2 character varying(200),
    article3 character varying(200),
    weight numeric(21,9),
    age numeric(21,9),
    price_with_tax boolean NOT NULL,
    note1 character varying(200),
    note2 character varying(200),
    note3 character varying(200),
    min_price_mc numeric(21,9) NOT NULL,
    max_price_mc numeric(21,9) NOT NULL,
    min_rem numeric(21,9) NOT NULL,
    cst_dty numeric(21,9) NOT NULL,
    cst_prc numeric(21,9) NOT NULL,
    cst_exc numeric(21,9) NOT NULL,
    std_extra_r character varying(255) DEFAULT 0 NOT NULL,
    std_extra_e character varying(255) DEFAULT 0 NOT NULL,
    max_extra numeric(21,9) NOT NULL,
    min_extra numeric(21,9) NOT NULL,
    use_alts boolean NOT NULL,
    use_crts boolean NOT NULL,
    p_gr_id1 integer NOT NULL,
    p_gr_id2 integer NOT NULL,
    p_gr_id3 integer NOT NULL,
    p_gr_a_id smallint NOT NULL,
    p_b_gr_id smallint NOT NULL,
    l_exp_set character varying(255),
    e_exp_set character varying(255),
    in_rems boolean NOT NULL,
    is_dec_qty boolean NOT NULL,
    file1 character varying(200),
    file2 character varying(200),
    file3 character varying(200),
    auto_set boolean NOT NULL,
    extra1 numeric(21,9) NOT NULL,
    extra2 numeric(21,9) NOT NULL,
    extra3 numeric(21,9) NOT NULL,
    extra4 numeric(21,9) NOT NULL,
    extra5 numeric(21,9) NOT NULL,
    norma1 numeric(21,9) NOT NULL,
    norma2 numeric(21,9) NOT NULL,
    norma3 numeric(21,9) NOT NULL,
    norma4 numeric(21,9) NOT NULL,
    norma5 numeric(21,9) NOT NULL,
    rec_min_price_cc numeric(21,9) NOT NULL,
    rec_max_price_cc numeric(21,9) NOT NULL,
    rec_std_price_cc numeric(21,9) NOT NULL,
    rec_rem_qty numeric(21,9) NOT NULL,
    in_stop_list boolean NOT NULL,
    prepare_time integer DEFAULT 0,
    scale_gr_id integer DEFAULT 0 NOT NULL,
    scale_standard character varying(250),
    scale_conditions character varying(250),
    scale_components character varying(250),
    tax_free_reason character varying(250),
    cst_prod_code character varying(250),
    tax_type_id integer DEFAULT 0 NOT NULL,
    cst_dty2 numeric(21,9) DEFAULT 0 NOT NULL
);


ALTER TABLE public.r_prods OWNER TO tc_client;

--
-- Name: r_states; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.r_states (
    ch_id integer NOT NULL,
    state_code integer NOT NULL,
    state_name character varying(250) NOT NULL,
    state_info character varying(250),
    can_change_doc boolean NOT NULL
);


ALTER TABLE public.r_states OWNER TO tc_client;

--
-- Name: r_stocks; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.r_stocks (
    ch_id integer NOT NULL,
    stock_id integer NOT NULL,
    stock_name character varying(200) NOT NULL,
    stock_g_id smallint NOT NULL,
    notes character varying(200),
    pl_id smallint NOT NULL,
    emp_id integer NOT NULL,
    is_wholesale boolean NOT NULL,
    address character varying(250),
    stock_tax_id integer
);


ALTER TABLE public.r_stocks OWNER TO tc_client;

--
-- Name: r_tax_rates; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.r_tax_rates (
    tax_type_id integer NOT NULL,
    ch_date timestamp with time zone NOT NULL,
    tax_percent numeric(21,9) NOT NULL
);


ALTER TABLE public.r_tax_rates OWNER TO tc_client;

--
-- Name: r_taxes; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.r_taxes (
    tax_type_id integer NOT NULL,
    tax_name character varying(250) NOT NULL,
    tax_desc character varying(200),
    tax_id smallint,
    notes character varying(250)
);


ALTER TABLE public.r_taxes OWNER TO tc_client;

--
-- Name: r_users; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.r_users (
    ch_id integer NOT NULL,
    user_id smallint NOT NULL,
    user_name character varying(250) NOT NULL,
    emp_id integer NOT NULL,
    admin boolean NOT NULL,
    active boolean NOT NULL,
    emps boolean,
    s_pp_acc boolean NOT NULL,
    s_cost boolean NOT NULL,
    s_cc_pl boolean NOT NULL,
    s_cc_price boolean NOT NULL,
    s_cc_discount boolean NOT NULL,
    valid_ours character varying(200),
    valid_stocks character varying(200),
    valid_pls character varying(200),
    valid_prods character varying(200),
    can_copy_rems boolean NOT NULL,
    b_date timestamp with time zone NOT NULL,
    e_date timestamp with time zone NOT NULL,
    use_open_age boolean NOT NULL,
    can_init_alts_pl boolean NOT NULL,
    show_pl_cange boolean,
    can_change_status boolean NOT NULL,
    can_change_discount boolean NOT NULL,
    can_print_doc boolean NOT NULL,
    can_buff_doc boolean NOT NULL,
    can_change_doc_id boolean NOT NULL,
    can_change_kurs_mc boolean NOT NULL,
    allow_rest_edit_desk boolean DEFAULT true NOT NULL,
    allow_rest_reserve boolean NOT NULL,
    allow_rest_move boolean NOT NULL,
    can_export_print boolean NOT NULL,
    p_salary_acc boolean NOT NULL,
    allow_rest_cheque_unite boolean DEFAULT true NOT NULL,
    allow_rest_cheque_del boolean DEFAULT true NOT NULL,
    open_age_b_type smallint DEFAULT 0 NOT NULL,
    open_age_b_qty smallint DEFAULT 0 NOT NULL,
    open_age_e_type smallint DEFAULT 0 NOT NULL,
    open_age_e_qty smallint DEFAULT 0 NOT NULL,
    allow_rest_view_desk boolean NOT NULL
);


ALTER TABLE public.r_users OWNER TO tc_client;

--
-- Name: t_cr_journal; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.t_cr_journal (
    ch_id integer NOT NULL,
    cr_id smallint,
    serial_id character varying(250),
    fiscal_id character varying(250),
    data bytea[],
    doc_type_id integer,
    doc_subtype_id integer,
    xml_doc_id integer DEFAULT 0 NOT NULL,
    doc_code integer,
    doc_ch_id integer,
    doc_time timestamp with time zone,
    is_finished boolean DEFAULT false NOT NULL
);


ALTER TABLE public.t_cr_journal OWNER TO tc_client;

--
-- Name: t_cr_journal_doc_subtypes; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.t_cr_journal_doc_subtypes (
    doc_subtype_id integer NOT NULL,
    doc_subtype_name character varying(100)
);


ALTER TABLE public.t_cr_journal_doc_subtypes OWNER TO tc_client;

--
-- Name: t_cr_journal_doc_types; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.t_cr_journal_doc_types (
    doc_type_id integer NOT NULL,
    doc_type_name character varying(100)
);


ALTER TABLE public.t_cr_journal_doc_types OWNER TO tc_client;

--
-- Name: t_cr_journal_text; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.t_cr_journal_text (
    ch_id integer NOT NULL,
    cr_id smallint,
    serial_id character varying(250),
    fiscal_id character varying(250),
    text_data character varying(8000),
    doc_type_id integer,
    doc_subtype_id integer,
    cr_doc_id integer NOT NULL,
    doc_code integer,
    doc_ch_id integer,
    doc_time timestamp with time zone,
    is_finished boolean NOT NULL
);


ALTER TABLE public.t_cr_journal_text OWNER TO tc_client;

--
-- Name: t_prods_complex_mechanics; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.t_prods_complex_mechanics (
    prod_id integer NOT NULL
);


ALTER TABLE public.t_prods_complex_mechanics OWNER TO tc_client;

--
-- Name: t_prods_reg_discount; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.t_prods_reg_discount (
    prod_id integer NOT NULL,
    new_price numeric(21,9),
    type_action integer DEFAULT 1,
    is_qty_action boolean DEFAULT false,
    qty_action integer DEFAULT 0
);


ALTER TABLE public.t_prods_reg_discount OWNER TO tc_client;

--
-- Name: t_sale; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.t_sale (
    ch_id integer NOT NULL,
    doc_id integer NOT NULL,
    doc_date timestamp with time zone NOT NULL,
    kurs_mc numeric(21,9) NOT NULL,
    our_id integer NOT NULL,
    stock_id integer NOT NULL,
    comp_id integer NOT NULL,
    code_id1 smallint NOT NULL,
    code_id2 smallint NOT NULL,
    code_id3 smallint NOT NULL,
    code_id4 smallint NOT NULL,
    code_id5 smallint NOT NULL,
    discount numeric(21,9) NOT NULL,
    notes character varying(200),
    cr_id smallint NOT NULL,
    oper_id integer NOT NULL,
    credit_id character varying(50),
    doc_time timestamp with time zone NOT NULL,
    tax_doc_id integer NOT NULL,
    tax_doc_date timestamp with time zone,
    d_card_id character varying(250) NOT NULL,
    emp_id integer DEFAULT 0 NOT NULL,
    int_doc_id character varying(50),
    cash_sum_cc numeric(21,9) DEFAULT 0 NOT NULL,
    change_sum_cc numeric(21,9) DEFAULT 0 NOT NULL,
    curr_id smallint DEFAULT 0 NOT NULL,
    t_sum_cc_nt numeric(21,9) DEFAULT 0 NOT NULL,
    t_tax_sum numeric(21,9) DEFAULT 0 NOT NULL,
    t_sum_cc_wt numeric(21,9) DEFAULT 0 NOT NULL,
    state_code integer DEFAULT 0 NOT NULL,
    desk_code integer DEFAULT 0 NOT NULL,
    visitors integer DEFAULT 0,
    t_pur_sum_cc_nt numeric(21,9) DEFAULT 0 NOT NULL,
    t_pur_tax_sum numeric(21,9) DEFAULT 0 NOT NULL,
    t_pur_sum_cc_wt numeric(21,9) DEFAULT 0 NOT NULL,
    doc_create_time timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    t_real_sum numeric(21,9) DEFAULT 0 NOT NULL,
    t_levy_sum numeric(21,9) DEFAULT 0 NOT NULL,
    extra_info character varying(8000),
    cheque_type_id integer DEFAULT 1 NOT NULL,
    inet_order_num character varying(50),
    extra_info2 character varying(3000)
);


ALTER TABLE public.t_sale OWNER TO tc_client;

--
-- Name: t_sale_c; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.t_sale_c (
    ch_id integer NOT NULL,
    src_pos_id integer NOT NULL,
    prod_id integer NOT NULL,
    um character varying(10) NOT NULL,
    qty numeric(21,9) NOT NULL,
    price_cc_nt numeric(21,9) NOT NULL,
    sum_cc_nt numeric(21,9) NOT NULL,
    tax numeric(21,9) NOT NULL,
    tax_sum numeric(21,9) NOT NULL,
    price_cc_wt numeric(21,9) NOT NULL,
    sum_cc_wt numeric(21,9) NOT NULL,
    bar_code character varying(42) NOT NULL,
    c_reason_id integer DEFAULT 0 NOT NULL,
    emp_id integer DEFAULT 0 NOT NULL,
    create_time timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modify_time timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.t_sale_c OWNER TO tc_client;

--
-- Name: t_sale_d; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.t_sale_d (
    ch_id integer NOT NULL,
    src_pos_id integer NOT NULL,
    prod_id integer NOT NULL,
    pp_id integer NOT NULL,
    um character varying(10) NOT NULL,
    qty numeric(21,9) NOT NULL,
    price_cc_nt numeric(21,9) NOT NULL,
    sum_cc_nt numeric(21,9) NOT NULL,
    tax numeric(21,9) NOT NULL,
    tax_sum numeric(21,9) NOT NULL,
    price_cc_wt numeric(21,9) NOT NULL,
    sum_cc_wt numeric(21,9) NOT NULL,
    bar_code character varying(42) NOT NULL,
    sec_id integer NOT NULL,
    pur_price_cc_nt numeric(21,9) NOT NULL,
    pur_tax numeric(21,9) NOT NULL,
    pur_price_cc_wt numeric(21,9) NOT NULL,
    pl_id smallint NOT NULL,
    discount numeric(21,9) DEFAULT 0 NOT NULL,
    emp_id integer DEFAULT 0 NOT NULL,
    create_time timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modify_time timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    tax_type_id integer DEFAULT 0 NOT NULL,
    cr_price_cc_wt numeric(21,9) DEFAULT 0 NOT NULL,
    cr_tax numeric(21,9) DEFAULT 0 NOT NULL,
    cr_price_cc_nt numeric(21,9) DEFAULT 0 NOT NULL,
    cr_sum_cc_wt numeric(21,9) DEFAULT 0 NOT NULL,
    cr_tax_sum numeric(21,9) DEFAULT 0 NOT NULL,
    cr_sum_cc_nt numeric(21,9) DEFAULT 0 NOT NULL,
    real_price numeric(21,9) NOT NULL,
    real_sum numeric(21,9) NOT NULL
);


ALTER TABLE public.t_sale_d OWNER TO tc_client;

--
-- Name: t_sale_pays; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.t_sale_pays (
    ch_id integer NOT NULL,
    src_pos_id integer NOT NULL,
    pay_form_code integer NOT NULL,
    sum_cc_wt numeric(21,9) NOT NULL,
    notes character varying(200),
    pos_pay_id integer DEFAULT 0 NOT NULL,
    pos_pay_doc_id integer,
    pos_pay_rrn character varying(250),
    cheque_text character varying(8000),
    pos_pay_text character varying(8000)
);


ALTER TABLE public.t_sale_pays OWNER TO tc_client;

--
-- Name: t_sale_temp; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.t_sale_temp (
    ch_id integer NOT NULL,
    cr_id smallint NOT NULL,
    doc_date timestamp with time zone NOT NULL,
    doc_time timestamp with time zone NOT NULL,
    doc_state integer NOT NULL,
    rate_mc numeric(21,9) NOT NULL,
    code_id1 smallint NOT NULL,
    code_id2 smallint NOT NULL,
    code_id3 smallint NOT NULL,
    code_id4 smallint NOT NULL,
    code_id5 smallint NOT NULL,
    credit_id character varying(50),
    d_card_id character varying(250),
    discount numeric(21,9) NOT NULL,
    notes character varying(250),
    desk_code integer DEFAULT 0 NOT NULL,
    oper_id integer DEFAULT 0 NOT NULL,
    visitors integer DEFAULT 0,
    cash_sum_cc numeric(21,9),
    change_sum_cc numeric(21,9),
    sale_doc_id integer,
    emp_id integer NOT NULL,
    is_printed boolean DEFAULT false NOT NULL,
    our_id integer NOT NULL,
    stock_id integer NOT NULL,
    extra_info character varying(8000),
    cheque_type_id integer DEFAULT 0 NOT NULL,
    inet_order_num character varying(50),
    extra_info2 character varying(3000)
);


ALTER TABLE public.t_sale_temp OWNER TO tc_client;

--
-- Name: t_sale_temp_d; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.t_sale_temp_d (
    ch_id integer NOT NULL,
    src_pos_id integer NOT NULL,
    prod_id integer NOT NULL,
    um character varying(50),
    qty numeric(21,9),
    real_qty numeric(21,9),
    price_cc_wt numeric(21,9),
    sum_cc_wt numeric(21,9),
    pur_pricecc_wt numeric(21,9),
    pur_sumcc_wt numeric(21,9),
    bar_code character varying(42),
    real_bar_code character varying(42) NOT NULL,
    pl_id smallint NOT NULL,
    use_to_bar_qty integer,
    pos_status integer NOT NULL,
    serving_time timestamp with time zone,
    c_src_pos_id integer NOT NULL,
    serving_id integer DEFAULT 0 NOT NULL,
    c_reason_id integer DEFAULT 0 NOT NULL,
    print_time timestamp with time zone,
    can_edit_qty boolean DEFAULT true NOT NULL,
    emp_id integer DEFAULT 0 NOT NULL,
    emp_name character varying(250),
    create_time timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modify_time timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    tax_type_id integer DEFAULT 0 NOT NULL,
    cr_price_cc_wt numeric(21,9) DEFAULT 0 NOT NULL,
    allow_zero_price boolean DEFAULT false NOT NULL
);


ALTER TABLE public.t_sale_temp_d OWNER TO tc_client;

--
-- Name: t_sale_temp_pays; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.t_sale_temp_pays (
    ch_id integer NOT NULL,
    src_pos_id integer NOT NULL,
    pay_form_code integer NOT NULL,
    sum_cc_wt numeric(21,9) NOT NULL,
    notes character varying(200),
    pos_pay_id integer DEFAULT 0 NOT NULL,
    pos_pay_doc_id integer,
    pos_pay_rrn character varying(250),
    print_state smallint,
    cheque_text character varying(8000),
    pos_pay_text character varying(8000)
);


ALTER TABLE public.t_sale_temp_pays OWNER TO tc_client;

--
-- Name: t_z_rep; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.t_z_rep (
    ch_id integer NOT NULL,
    doc_date timestamp with time zone NOT NULL,
    doc_time timestamp with time zone,
    cr_id smallint NOT NULL,
    oper_id integer NOT NULL,
    our_id integer NOT NULL,
    doc_id integer NOT NULL,
    fac_id character varying(250) NOT NULL,
    fin_id character varying(250) NOT NULL,
    z_rep_num integer DEFAULT 0 NOT NULL,
    sum_cc_wt numeric(21,9) DEFAULT 0 NOT NULL,
    sum_a numeric(21,9) DEFAULT 0 NOT NULL,
    sum_b numeric(21,9) DEFAULT 0 NOT NULL,
    sum_c numeric(21,9) DEFAULT 0 NOT NULL,
    sum_d numeric(21,9) DEFAULT 0 NOT NULL,
    ret_sum_a numeric(21,9) DEFAULT 0 NOT NULL,
    ret_sum_b numeric(21,9) DEFAULT 0 NOT NULL,
    ret_sum_c numeric(21,9) DEFAULT 0 NOT NULL,
    ret_sum_d numeric(21,9) DEFAULT 0 NOT NULL,
    sum_cash numeric(21,9) DEFAULT 0 NOT NULL,
    sum_card numeric(21,9) DEFAULT 0 NOT NULL,
    sum_credit numeric(21,9) DEFAULT 0 NOT NULL,
    sum_cheque numeric(21,9) DEFAULT 0 NOT NULL,
    sum_other numeric(21,9) DEFAULT 0 NOT NULL,
    ret_sum_cash numeric(21,9) DEFAULT 0 NOT NULL,
    ret_sum_card numeric(21,9) DEFAULT 0 NOT NULL,
    ret_sum_credit numeric(21,9) DEFAULT 0 NOT NULL,
    ret_sum_cheque numeric(21,9) DEFAULT 0 NOT NULL,
    ret_sum_other numeric(21,9) DEFAULT 0 NOT NULL,
    sum_mon_rec numeric(21,9) DEFAULT 0 NOT NULL,
    sum_mon_exp numeric(21,9) DEFAULT 0 NOT NULL,
    sum_rem numeric(21,9) DEFAULT 0,
    notes character varying(250),
    sum_e numeric(21,9) DEFAULT 0 NOT NULL,
    sum_f numeric(21,9) DEFAULT 0 NOT NULL,
    ret_sum_e numeric(21,9) DEFAULT 0 NOT NULL,
    ret_sum_f numeric(21,9) DEFAULT 0 NOT NULL,
    tax_a numeric(21,9) DEFAULT 0,
    tax_b numeric(21,9) DEFAULT 0,
    tax_c numeric(21,9) DEFAULT 0,
    tax_d numeric(21,9) DEFAULT 0,
    tax_e numeric(21,9) DEFAULT 0,
    tax_f numeric(21,9) DEFAULT 0,
    ret_tax_a numeric(21,9) DEFAULT 0,
    ret_tax_b numeric(21,9) DEFAULT 0,
    ret_tax_c numeric(21,9) DEFAULT 0,
    ret_tax_d numeric(21,9) DEFAULT 0,
    ret_tax_e numeric(21,9) DEFAULT 0,
    ret_tax_f numeric(21,9) DEFAULT 0
);


ALTER TABLE public.t_z_rep OWNER TO tc_client;

--
-- Name: t_z_rep_t; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.t_z_rep_t (
    ch_id integer NOT NULL,
    doc_date timestamp with time zone NOT NULL,
    doc_time timestamp with time zone NOT NULL,
    doc_id integer NOT NULL,
    our_id integer NOT NULL,
    cr_id integer NOT NULL,
    oper_id integer NOT NULL,
    pos_pay_id integer NOT NULL,
    cheques_count integer DEFAULT 0 NOT NULL,
    cheques_count_sale integer DEFAULT 0 NOT NULL,
    sum_card numeric(21,9) DEFAULT 0 NOT NULL,
    cheques_count_ret integer DEFAULT 0 NOT NULL,
    ret_sum_card numeric(21,9) DEFAULT 0 NOT NULL
);


ALTER TABLE public.t_z_rep_t OWNER TO tc_client;

--
-- Name: z_doc_dc; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.z_doc_dc (
    doc_code integer NOT NULL,
    ch_id integer NOT NULL,
    d_card_id character varying(250) NOT NULL
);


ALTER TABLE public.z_doc_dc OWNER TO tc_client;

--
-- Name: z_log_disc_exp; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.z_log_disc_exp (
    log_id integer NOT NULL,
    d_card_id character varying(250) NOT NULL,
    temp_bonus boolean NOT NULL,
    doc_code integer NOT NULL,
    ch_id integer NOT NULL,
    src_pos_id integer,
    disc_code integer NOT NULL,
    sum_bonus numeric(21,9),
    discount numeric(21,9),
    log_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    bonus_type integer DEFAULT 0 NOT NULL,
    group_sum_bonus numeric(21,9),
    group_discount numeric(21,9),
    d_bi_id integer NOT NULL
);


ALTER TABLE public.z_log_disc_exp OWNER TO tc_client;

--
-- Name: z_log_disc_exp_p; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.z_log_disc_exp_p (
    d_bi_id integer NOT NULL,
    log_id integer NOT NULL,
    doc_code integer NOT NULL,
    ch_id integer NOT NULL,
    src_pos_id integer,
    disc_code integer NOT NULL,
    d_card_id character varying(250) NOT NULL,
    sum_bonus numeric(21,9),
    log_date timestamp with time zone NOT NULL
);


ALTER TABLE public.z_log_disc_exp_p OWNER TO tc_client;

--
-- Name: z_log_disc_rec; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.z_log_disc_rec (
    log_id integer NOT NULL,
    d_card_id character varying(250) NOT NULL,
    temp_bonus boolean NOT NULL,
    doc_code integer NOT NULL,
    ch_id integer NOT NULL,
    src_pos_id integer,
    disc_code integer NOT NULL,
    sum_bonus numeric(21,9),
    log_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    bonus_type integer DEFAULT 0 NOT NULL,
    sale_src_pos_id integer,
    d_bi_id integer NOT NULL
);


ALTER TABLE public.z_log_disc_rec OWNER TO tc_client;

--
-- Name: z_log_metrics; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.z_log_metrics (
    d_bi_id integer NOT NULL,
    log_id_ex bigint NOT NULL,
    doc_code integer NOT NULL,
    ch_id integer NOT NULL,
    cr_id smallint NOT NULL,
    event_id integer NOT NULL,
    create_time timestamp with time zone NOT NULL,
    is_finished boolean NOT NULL,
    notes character varying(2000)
);


ALTER TABLE public.z_log_metrics OWNER TO tc_client;

--
-- Name: z_log_processings; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.z_log_processings (
    ch_id integer NOT NULL,
    doc_code integer NOT NULL,
    card_info character varying(2000),
    rrn character varying(250),
    status integer NOT NULL,
    msg character varying(250)
);


ALTER TABLE public.z_log_processings OWNER TO tc_client;

--
-- Name: z_log_tools; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.z_log_tools (
    log_id integer NOT NULL,
    doc_date timestamp with time zone NOT NULL,
    rep_tool_code integer NOT NULL,
    note1 character varying(200),
    note2 character varying(200),
    note3 character varying(200),
    user_code smallint NOT NULL
);


ALTER TABLE public.z_log_tools OWNER TO tc_client;

--
-- Name: z_log_tools_log_id_seq; Type: SEQUENCE; Schema: public; Owner: tc_client
--

ALTER TABLE public.z_log_tools ALTER COLUMN log_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.z_log_tools_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: z_metrica_events; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.z_metrica_events (
    event_id integer NOT NULL,
    event_name character varying(250) NOT NULL,
    enabled boolean NOT NULL
);


ALTER TABLE public.z_metrica_events OWNER TO tc_client;

--
-- Name: z_vars; Type: TABLE; Schema: public; Owner: tc_client
--

CREATE TABLE public.z_vars (
    var_name character varying(250) NOT NULL,
    var_desc character varying(250) NOT NULL,
    var_value character varying(4000),
    var_info character varying(250),
    var_type integer DEFAULT 0 NOT NULL,
    var_page_code integer DEFAULT 0 NOT NULL,
    var_group character varying(250),
    var_pos_id integer DEFAULT 0 NOT NULL,
    label_pos integer DEFAULT 0 NOT NULL,
    var_ext_info character varying(2000),
    var_sel_type integer DEFAULT 0 NOT NULL,
    app_code integer DEFAULT 0 NOT NULL,
    object_def text
);


ALTER TABLE public.z_vars OWNER TO tc_client;

--
-- Data for Name: logs; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.logs (text) FROM stdin;
\.


--
-- Data for Name: ppos; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.ppos (ppos_id, ppo_number, password) FROM stdin;
1	123	$1$KLOl7i7z$cArfYmtxZhNOEN6qbny/T0
2	456	$1$IKEd5N2N$Ofjomx3qSSRKuY420LLDP0
3	789	$1$1C48tNhn$emicSrLI5OiPAbg1yAEbE0
\.


--
-- Data for Name: r_comps; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.r_comps (ch_id, comp_id, comp_name, comp_short, address, post_index, city, region, code, tax_reg_no, tax_code, tax_payer, comp_desc, contact, phone1, phone2, phone3, fax, e_mail, http, notes, code_id1, code_id2, code_id3, code_id4, code_id5, use_codes, plid, use_pl, discount, use_discount, pay_delay, use_pay_delay, max_credit, calc_max_credit, emp_id, contract1, contract2, contract3, license1, license2, license3, job1, job2, job3, tran_prc, more_prc, first_event_mode, comp_type, sys_tax_type, fix_tax_percent, in_stop_list, value1, value2, value3, pass_no, pass_ser, pass_date, pass_dept, comp_gr_id1, comp_gr_id2, comp_gr_id3, comp_gr_id4, comp_gr_id5, comp_name_full) FROM stdin;
\.


--
-- Data for Name: r_cr_uni_input; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.r_cr_uni_input (ch_id, uni_input_code, uni_input_action, uni_input_mask, notes, uni_input) FROM stdin;
\.


--
-- Data for Name: r_crmp; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.r_crmp (cr_id, prod_id, cr_prod_name, cr_prod_id, tax_id, sec_id, fixed_price, price_cc, decimal_qty, bar_code) FROM stdin;
\.


--
-- Data for Name: r_crpos_pays; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.r_crpos_pays (cr_id, pos_pay_id, is_default) FROM stdin;
\.


--
-- Data for Name: r_crs; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.r_crs (ch_id, crid, cr_name, notes, fin_id, fac_id, cr_port, cr_code, srv_id, auto_create_new_cheque, stock_id, sec_id, cash_type, use_prod_notes, baud_rate, led_type, cred_card_mask, max_change, can_edit_weight_qty, can_edit_price, can_edit_prod_id, can_enter_pos_discount, ask_pwd_cn, print_text_anull, ask_pwd_anull, print_report, use_dec_qty_bar_code, paper_warning, always_show_pos_editor, ask_pwd_cn_cheque, ask_pwd_suspend, ask_pwd_balance, ask_pwd_ret, max_suspended, ask_params_after_open, ask_params_before_close, show_pos_disc, show_cheque_disc, auto_sel_discs, ask_d_cards_after_open, ask_d_cards_before_close, can_enter_d_card, can_enter_code_id1, can_enter_code_id2, can_enter_code_id3, can_enter_code_id4, can_enter_code_id5, can_enter_notes, no_manual_d_card_enter, show_cancels, preview_report, dec_qty_from_ref, ask_visitors_after_open, ask_pwd_period_rep, print_report_ret, mixed_pays, print_report_mon_rec, print_report_mon_exp, ask_pwd_find, use_bar_code, use_stock_pl, open_money_box_on_deposit, ask_pwd_money_box, ask_pwd_d_card_find, auto_fill_pays, show_pos_edit_on_cancel, check_ret_sum, allow_invalid_mon_exp, cash_reg_mode, net_port, modem_id, modem_password, check_ret_pay_forms, print_report_z, print_report_x, print_discs, ask_pwd_deposit, print_after_send_order, scale_id, allow_qty_reduction, z_report_warning, pos_emp_id_type, use_emps, pos_emp_id, cheque_emp, ip, print_copy_for_card, group_prods, z_rep_after_shift, z_rep_exec_in_time, z_rep_shift_end_time, z_rep_exec_time, z_rep_shift_time_check, processing_id, user_name, user_password, print_info_anull, auto_update_taxes, collect_metrics, metric_max_days, backup_cr_journal_after_z_report, change_sum_warning, ask_pwd_pos_re_pay, cancel_m_discs_warning, async_cheque_input, backup_cr_journal_after_cheque_type, backup_cr_journal_cheque_timeout, backup_cr_journal_in_time, backup_cr_journal_exec_time, active, day_sale_sum_cc, shift_close_time, backup_cr_journal_text, backup_cr_journal_text_cheque_type, backup_cr_journal_text_start_date) FROM stdin;
\.


--
-- Data for Name: r_d_cards; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.r_d_cards (ch_id, comp_id, d_card_id, discount, sum_cc, in_use, notes, value1, value2, value3, is_crd_card, note1, e_date, client_name, dc_type_code, birth_date, fact_region, fact_district, fact_city, fact_street, fact_house, fact_block, fact_apt_no, fact_post_index, phone_mob, phone_home, phone_work, e_mail, sum_bonus, status, b_date, is_pay_card, auto_save_odd_money_to_processing) FROM stdin;
\.


--
-- Data for Name: r_dc_group; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.r_dc_group (ch_id, dc_group_code, dc_group_name, date_create, user_create, date_change, user_change, date_begin, date_end) FROM stdin;
\.


--
-- Data for Name: r_dc_type_g; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.r_dc_type_g (ch_id, dc_type_gcode, dc_type_gname, notes, main_dialog, close_dialog_after_enter, processing_id) FROM stdin;
\.


--
-- Data for Name: r_dc_types; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.r_dc_types (ch_id, dc_type_code, dc_type_name, value1, value2, value3, init_sum, prod_id, notes, max_qty, dc_type_gcode, deactivate_after_use, no_manual_dcard_enter) FROM stdin;
\.


--
-- Data for Name: r_disc_dc; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.r_disc_dc (disc_code, dc_type_code, for_rec, for_exp) FROM stdin;
\.


--
-- Data for Name: r_discs; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.r_discs (ch_id, disc_code, disc_name, this_charge_only, this_doc_bonus, other_docs_bonus, charge_dcard, disc_only_with_dcard, charge_after_close, priority, allow_discs, shed1, shed2, shed3, b_date, e_date, gen_procs, in_use, doc_code, simple_disc, save_disc_to_dcard, save_bonus_to_dcard, disc_from_dcard, re_process_pos_discs, valid_ours, valid_stocks, auto_sel_discs, short_cut, notes, group_disc, print_in_cheque, allow_zero_price, redistribute_disc_sum_in_busket, disc_ext_code, allow_edit_qty) FROM stdin;
\.


--
-- Data for Name: r_emps; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.r_emps (ch_id, emp_id, emp_name, ua_emp_name, emp_last_name, emp_first_name, emp_par_name, ua_emp_last_name, ua_emp_first_name, ua_emp_par_name, emp_initials, ua_emp_initials, tax_code, emp_sex, birth_day, file1, file2, file3, education, family_status, birth_place, phone, in_phone, mobile, e_mail, percent1, percent2, percent3, notes, mil_status, mil_fitness, mil_rank, mil_special_calc, mil_profes, mil_calc_grp, mil_calc_cat, mil_staff, mil_reg_office, mil_num, pass_no, pass_ser, pass_date, pass_dept, dis_num, pens_num, work_book_no, work_book_ser, per_file_no, in_stop_list, bar_code, shift_post_id, is_citizen, cert_insur_ser, cert_insur_num) FROM stdin;
\.


--
-- Data for Name: r_oper_crs; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.r_oper_crs (cr_id, oper_id, cr_oper_id, oper_max_qty, can_edit_discount, cr_visible, oper_pwd, allow_cheque_close, allow_add_to_cheque_from_cat) FROM stdin;
\.


--
-- Data for Name: r_opers; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.r_opers (ch_id, oper_id, oper_name, oper_pwd, emp_id, cr_admin, oper_lock_pwd) FROM stdin;
\.


--
-- Data for Name: r_pay_forms; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.r_pay_forms (ch_id, pay_form_code, pay_form_name, notes, sumlabel, notes_label, can_enter_notes, notes_mask, can_enter_sum, max_qty, is_default, for_sale, for_ret, auto_calc_sum, dc_type_gcode, group_pays) FROM stdin;
\.


--
-- Data for Name: r_pls; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.r_pls (ch_id, pl_id, pl_name, notes) FROM stdin;
\.


--
-- Data for Name: r_pos_pays; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.r_pos_pays (ch_id, pos_pay_id, pos_pay_name, pos_pay_class, pos_pay_port, pos_pay_timeout, notes, use_grp_card_for_discs, use_union_cheque, print_tran_info_in_cheque, ip, net_port) FROM stdin;
\.


--
-- Data for Name: r_processings; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.r_processings (ch_id, processing_id, processing_name, processing_type, ip, net_port, path, max_difference, multiplicity, retry_time, retry_period, extra_info) FROM stdin;
\.


--
-- Data for Name: r_prod_a; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.r_prod_a (ch_id, p_gr_a_id, p_gr_a_name, notes) FROM stdin;
\.


--
-- Data for Name: r_prod_c; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.r_prod_c (ch_id, p_cat_id, p_cat_name, notes) FROM stdin;
\.


--
-- Data for Name: r_prod_g; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.r_prod_g (ch_id, p_gr_id, p_gr_name, notes) FROM stdin;
\.


--
-- Data for Name: r_prod_g1; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.r_prod_g1 (ch_id, p_gr_id1, p_gr_name1, notes) FROM stdin;
\.


--
-- Data for Name: r_prod_g2; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.r_prod_g2 (ch_id, p_gr_id2, p_gr_name2, notes) FROM stdin;
\.


--
-- Data for Name: r_prod_g3; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.r_prod_g3 (ch_id, p_gr_id3, p_gr_name3, notes) FROM stdin;
\.


--
-- Data for Name: r_prod_mp; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.r_prod_mp (prod_id, pl_id, price_mc, notes, curr_id) FROM stdin;
\.


--
-- Data for Name: r_prod_mq; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.r_prod_mq (prod_id, um, qty, weight, notes, bar_code, prod_bar_code, pl_id, state) FROM stdin;
\.


--
-- Data for Name: r_prods; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.r_prods (ch_id, prod_id, prod_name, um, country, notes, p_cat_id, p_gr_id, article1, article2, article3, weight, age, price_with_tax, note1, note2, note3, min_price_mc, max_price_mc, min_rem, cst_dty, cst_prc, cst_exc, std_extra_r, std_extra_e, max_extra, min_extra, use_alts, use_crts, p_gr_id1, p_gr_id2, p_gr_id3, p_gr_a_id, p_b_gr_id, l_exp_set, e_exp_set, in_rems, is_dec_qty, file1, file2, file3, auto_set, extra1, extra2, extra3, extra4, extra5, norma1, norma2, norma3, norma4, norma5, rec_min_price_cc, rec_max_price_cc, rec_std_price_cc, rec_rem_qty, in_stop_list, prepare_time, scale_gr_id, scale_standard, scale_conditions, scale_components, tax_free_reason, cst_prod_code, tax_type_id, cst_dty2) FROM stdin;
\.


--
-- Data for Name: r_states; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.r_states (ch_id, state_code, state_name, state_info, can_change_doc) FROM stdin;
\.


--
-- Data for Name: r_stocks; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.r_stocks (ch_id, stock_id, stock_name, stock_g_id, notes, pl_id, emp_id, is_wholesale, address, stock_tax_id) FROM stdin;
\.


--
-- Data for Name: r_tax_rates; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.r_tax_rates (tax_type_id, ch_date, tax_percent) FROM stdin;
\.


--
-- Data for Name: r_taxes; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.r_taxes (tax_type_id, tax_name, tax_desc, tax_id, notes) FROM stdin;
\.


--
-- Data for Name: r_users; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.r_users (ch_id, user_id, user_name, emp_id, admin, active, emps, s_pp_acc, s_cost, s_cc_pl, s_cc_price, s_cc_discount, valid_ours, valid_stocks, valid_pls, valid_prods, can_copy_rems, b_date, e_date, use_open_age, can_init_alts_pl, show_pl_cange, can_change_status, can_change_discount, can_print_doc, can_buff_doc, can_change_doc_id, can_change_kurs_mc, allow_rest_edit_desk, allow_rest_reserve, allow_rest_move, can_export_print, p_salary_acc, allow_rest_cheque_unite, allow_rest_cheque_del, open_age_b_type, open_age_b_qty, open_age_e_type, open_age_e_qty, allow_rest_view_desk) FROM stdin;
\.


--
-- Data for Name: t_cr_journal; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.t_cr_journal (ch_id, cr_id, serial_id, fiscal_id, data, doc_type_id, doc_subtype_id, xml_doc_id, doc_code, doc_ch_id, doc_time, is_finished) FROM stdin;
\.


--
-- Data for Name: t_cr_journal_doc_subtypes; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.t_cr_journal_doc_subtypes (doc_subtype_id, doc_subtype_name) FROM stdin;
\.


--
-- Data for Name: t_cr_journal_doc_types; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.t_cr_journal_doc_types (doc_type_id, doc_type_name) FROM stdin;
\.


--
-- Data for Name: t_cr_journal_text; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.t_cr_journal_text (ch_id, cr_id, serial_id, fiscal_id, text_data, doc_type_id, doc_subtype_id, cr_doc_id, doc_code, doc_ch_id, doc_time, is_finished) FROM stdin;
\.


--
-- Data for Name: t_prods_complex_mechanics; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.t_prods_complex_mechanics (prod_id) FROM stdin;
\.


--
-- Data for Name: t_prods_reg_discount; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.t_prods_reg_discount (prod_id, new_price, type_action, is_qty_action, qty_action) FROM stdin;
\.


--
-- Data for Name: t_sale; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.t_sale (ch_id, doc_id, doc_date, kurs_mc, our_id, stock_id, comp_id, code_id1, code_id2, code_id3, code_id4, code_id5, discount, notes, cr_id, oper_id, credit_id, doc_time, tax_doc_id, tax_doc_date, d_card_id, emp_id, int_doc_id, cash_sum_cc, change_sum_cc, curr_id, t_sum_cc_nt, t_tax_sum, t_sum_cc_wt, state_code, desk_code, visitors, t_pur_sum_cc_nt, t_pur_tax_sum, t_pur_sum_cc_wt, doc_create_time, t_real_sum, t_levy_sum, extra_info, cheque_type_id, inet_order_num, extra_info2) FROM stdin;
\.


--
-- Data for Name: t_sale_c; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.t_sale_c (ch_id, src_pos_id, prod_id, um, qty, price_cc_nt, sum_cc_nt, tax, tax_sum, price_cc_wt, sum_cc_wt, bar_code, c_reason_id, emp_id, create_time, modify_time) FROM stdin;
\.


--
-- Data for Name: t_sale_d; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.t_sale_d (ch_id, src_pos_id, prod_id, pp_id, um, qty, price_cc_nt, sum_cc_nt, tax, tax_sum, price_cc_wt, sum_cc_wt, bar_code, sec_id, pur_price_cc_nt, pur_tax, pur_price_cc_wt, pl_id, discount, emp_id, create_time, modify_time, tax_type_id, cr_price_cc_wt, cr_tax, cr_price_cc_nt, cr_sum_cc_wt, cr_tax_sum, cr_sum_cc_nt, real_price, real_sum) FROM stdin;
\.


--
-- Data for Name: t_sale_pays; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.t_sale_pays (ch_id, src_pos_id, pay_form_code, sum_cc_wt, notes, pos_pay_id, pos_pay_doc_id, pos_pay_rrn, cheque_text, pos_pay_text) FROM stdin;
\.


--
-- Data for Name: t_sale_temp; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.t_sale_temp (ch_id, cr_id, doc_date, doc_time, doc_state, rate_mc, code_id1, code_id2, code_id3, code_id4, code_id5, credit_id, d_card_id, discount, notes, desk_code, oper_id, visitors, cash_sum_cc, change_sum_cc, sale_doc_id, emp_id, is_printed, our_id, stock_id, extra_info, cheque_type_id, inet_order_num, extra_info2) FROM stdin;
\.


--
-- Data for Name: t_sale_temp_d; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.t_sale_temp_d (ch_id, src_pos_id, prod_id, um, qty, real_qty, price_cc_wt, sum_cc_wt, pur_pricecc_wt, pur_sumcc_wt, bar_code, real_bar_code, pl_id, use_to_bar_qty, pos_status, serving_time, c_src_pos_id, serving_id, c_reason_id, print_time, can_edit_qty, emp_id, emp_name, create_time, modify_time, tax_type_id, cr_price_cc_wt, allow_zero_price) FROM stdin;
\.


--
-- Data for Name: t_sale_temp_pays; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.t_sale_temp_pays (ch_id, src_pos_id, pay_form_code, sum_cc_wt, notes, pos_pay_id, pos_pay_doc_id, pos_pay_rrn, print_state, cheque_text, pos_pay_text) FROM stdin;
\.


--
-- Data for Name: t_z_rep; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.t_z_rep (ch_id, doc_date, doc_time, cr_id, oper_id, our_id, doc_id, fac_id, fin_id, z_rep_num, sum_cc_wt, sum_a, sum_b, sum_c, sum_d, ret_sum_a, ret_sum_b, ret_sum_c, ret_sum_d, sum_cash, sum_card, sum_credit, sum_cheque, sum_other, ret_sum_cash, ret_sum_card, ret_sum_credit, ret_sum_cheque, ret_sum_other, sum_mon_rec, sum_mon_exp, sum_rem, notes, sum_e, sum_f, ret_sum_e, ret_sum_f, tax_a, tax_b, tax_c, tax_d, tax_e, tax_f, ret_tax_a, ret_tax_b, ret_tax_c, ret_tax_d, ret_tax_e, ret_tax_f) FROM stdin;
\.


--
-- Data for Name: t_z_rep_t; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.t_z_rep_t (ch_id, doc_date, doc_time, doc_id, our_id, cr_id, oper_id, pos_pay_id, cheques_count, cheques_count_sale, sum_card, cheques_count_ret, ret_sum_card) FROM stdin;
\.


--
-- Data for Name: z_doc_dc; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.z_doc_dc (doc_code, ch_id, d_card_id) FROM stdin;
\.


--
-- Data for Name: z_log_disc_exp; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.z_log_disc_exp (log_id, d_card_id, temp_bonus, doc_code, ch_id, src_pos_id, disc_code, sum_bonus, discount, log_date, bonus_type, group_sum_bonus, group_discount, d_bi_id) FROM stdin;
\.


--
-- Data for Name: z_log_disc_exp_p; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.z_log_disc_exp_p (d_bi_id, log_id, doc_code, ch_id, src_pos_id, disc_code, d_card_id, sum_bonus, log_date) FROM stdin;
\.


--
-- Data for Name: z_log_disc_rec; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.z_log_disc_rec (log_id, d_card_id, temp_bonus, doc_code, ch_id, src_pos_id, disc_code, sum_bonus, log_date, bonus_type, sale_src_pos_id, d_bi_id) FROM stdin;
\.


--
-- Data for Name: z_log_metrics; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.z_log_metrics (d_bi_id, log_id_ex, doc_code, ch_id, cr_id, event_id, create_time, is_finished, notes) FROM stdin;
\.


--
-- Data for Name: z_log_processings; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.z_log_processings (ch_id, doc_code, card_info, rrn, status, msg) FROM stdin;
\.


--
-- Data for Name: z_log_tools; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.z_log_tools (log_id, doc_date, rep_tool_code, note1, note2, note3, user_code) FROM stdin;
\.


--
-- Data for Name: z_metrica_events; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.z_metrica_events (event_id, event_name, enabled) FROM stdin;
\.


--
-- Data for Name: z_vars; Type: TABLE DATA; Schema: public; Owner: tc_client
--

COPY public.z_vars (var_name, var_desc, var_value, var_info, var_type, var_page_code, var_group, var_pos_id, label_pos, var_ext_info, var_sel_type, app_code, object_def) FROM stdin;
\.


--
-- Name: ppos_ppos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tc_client
--

SELECT pg_catalog.setval('public.ppos_ppos_id_seq', 3, true);


--
-- Name: r_dc_group_ch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tc_client
--

SELECT pg_catalog.setval('public.r_dc_group_ch_id_seq', 1, false);


--
-- Name: z_log_tools_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tc_client
--

SELECT pg_catalog.setval('public.z_log_tools_log_id_seq', 1, false);


--
-- Name: r_oper_crs _pk_r_crmo; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.r_oper_crs
    ADD CONSTRAINT _pk_r_crmo PRIMARY KEY (cr_id, oper_id);


--
-- Name: r_crmp _pk_r_crmp; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.r_crmp
    ADD CONSTRAINT _pk_r_crmp PRIMARY KEY (cr_id, cr_prod_id);


--
-- Name: r_prod_mp _pk_r_prodmp; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.r_prod_mp
    ADD CONSTRAINT _pk_r_prodmp PRIMARY KEY (prod_id, pl_id);


--
-- Name: r_prod_mq _pk_r_prodmq; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.r_prod_mq
    ADD CONSTRAINT _pk_r_prodmq PRIMARY KEY (prod_id, um);


--
-- Name: t_sale_c _pk_t_salec; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.t_sale_c
    ADD CONSTRAINT _pk_t_salec PRIMARY KEY (ch_id, src_pos_id);


--
-- Name: t_sale_d _pk_t_saled; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.t_sale_d
    ADD CONSTRAINT _pk_t_saled PRIMARY KEY (ch_id, src_pos_id);


--
-- Name: z_vars _pk_z_vars; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.z_vars
    ADD CONSTRAINT _pk_z_vars PRIMARY KEY (var_name);


--
-- Name: r_d_cards pk_r_compmdc; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.r_d_cards
    ADD CONSTRAINT pk_r_compmdc PRIMARY KEY (d_card_id);


--
-- Name: r_comps pk_r_comps; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.r_comps
    ADD CONSTRAINT pk_r_comps PRIMARY KEY (comp_id);


--
-- Name: r_crpos_pays pk_r_crpospays; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.r_crpos_pays
    ADD CONSTRAINT pk_r_crpospays PRIMARY KEY (cr_id, pos_pay_id);


--
-- Name: r_crs pk_r_crs; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.r_crs
    ADD CONSTRAINT pk_r_crs PRIMARY KEY (crid);


--
-- Name: r_cr_uni_input pk_r_cruniinput; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.r_cr_uni_input
    ADD CONSTRAINT pk_r_cruniinput PRIMARY KEY (uni_input_code);


--
-- Name: r_dc_group pk_r_dcgroup; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.r_dc_group
    ADD CONSTRAINT pk_r_dcgroup PRIMARY KEY (ch_id, dc_group_code);


--
-- Name: r_dc_type_g pk_r_dctypeg; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.r_dc_type_g
    ADD CONSTRAINT pk_r_dctypeg PRIMARY KEY (dc_type_gcode);


--
-- Name: r_dc_types pk_r_dctypes; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.r_dc_types
    ADD CONSTRAINT pk_r_dctypes PRIMARY KEY (dc_type_code);


--
-- Name: r_disc_dc pk_r_discdc; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.r_disc_dc
    ADD CONSTRAINT pk_r_discdc PRIMARY KEY (disc_code, dc_type_code);


--
-- Name: r_discs pk_r_discs; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.r_discs
    ADD CONSTRAINT pk_r_discs PRIMARY KEY (disc_code);


--
-- Name: r_emps pk_r_emps; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.r_emps
    ADD CONSTRAINT pk_r_emps PRIMARY KEY (emp_id);


--
-- Name: r_opers pk_r_opers; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.r_opers
    ADD CONSTRAINT pk_r_opers PRIMARY KEY (oper_id);


--
-- Name: r_pay_forms pk_r_payforms; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.r_pay_forms
    ADD CONSTRAINT pk_r_payforms PRIMARY KEY (pay_form_code);


--
-- Name: r_pls pk_r_pls; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.r_pls
    ADD CONSTRAINT pk_r_pls PRIMARY KEY (pl_id);


--
-- Name: r_pos_pays pk_r_pospays; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.r_pos_pays
    ADD CONSTRAINT pk_r_pospays PRIMARY KEY (pos_pay_id);


--
-- Name: r_processings pk_r_processings; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.r_processings
    ADD CONSTRAINT pk_r_processings PRIMARY KEY (processing_id);


--
-- Name: r_prod_a pk_r_proda; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.r_prod_a
    ADD CONSTRAINT pk_r_proda PRIMARY KEY (p_gr_a_id);


--
-- Name: r_prod_c pk_r_prodc; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.r_prod_c
    ADD CONSTRAINT pk_r_prodc PRIMARY KEY (p_cat_id);


--
-- Name: r_prod_g pk_r_prodg; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.r_prod_g
    ADD CONSTRAINT pk_r_prodg PRIMARY KEY (p_gr_id);


--
-- Name: r_prod_g1 pk_r_prodg1; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.r_prod_g1
    ADD CONSTRAINT pk_r_prodg1 PRIMARY KEY (p_gr_id1);


--
-- Name: r_prod_g2 pk_r_prodg2; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.r_prod_g2
    ADD CONSTRAINT pk_r_prodg2 PRIMARY KEY (p_gr_id2);


--
-- Name: r_prod_g3 pk_r_prodg3; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.r_prod_g3
    ADD CONSTRAINT pk_r_prodg3 PRIMARY KEY (p_gr_id3);


--
-- Name: r_prods pk_r_prods; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.r_prods
    ADD CONSTRAINT pk_r_prods PRIMARY KEY (prod_id);


--
-- Name: r_states pk_r_states; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.r_states
    ADD CONSTRAINT pk_r_states PRIMARY KEY (state_code);


--
-- Name: r_stocks pk_r_stocks; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.r_stocks
    ADD CONSTRAINT pk_r_stocks PRIMARY KEY (stock_id);


--
-- Name: r_taxes pk_r_taxes; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.r_taxes
    ADD CONSTRAINT pk_r_taxes PRIMARY KEY (tax_type_id);


--
-- Name: r_tax_rates pk_r_taxrates; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.r_tax_rates
    ADD CONSTRAINT pk_r_taxrates PRIMARY KEY (tax_type_id, ch_date);


--
-- Name: r_users pk_r_users; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.r_users
    ADD CONSTRAINT pk_r_users PRIMARY KEY (user_id);


--
-- Name: t_cr_journal pk_t_crjournal; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.t_cr_journal
    ADD CONSTRAINT pk_t_crjournal PRIMARY KEY (ch_id);


--
-- Name: t_cr_journal_text pk_t_crjournaltext; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.t_cr_journal_text
    ADD CONSTRAINT pk_t_crjournaltext PRIMARY KEY (ch_id);


--
-- Name: t_prods_complex_mechanics pk_t_prodscomplexmechanics; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.t_prods_complex_mechanics
    ADD CONSTRAINT pk_t_prodscomplexmechanics PRIMARY KEY (prod_id);


--
-- Name: t_prods_reg_discount pk_t_prodsregdiscount; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.t_prods_reg_discount
    ADD CONSTRAINT pk_t_prodsregdiscount PRIMARY KEY (prod_id);


--
-- Name: t_sale pk_t_sale; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.t_sale
    ADD CONSTRAINT pk_t_sale PRIMARY KEY (ch_id);


--
-- Name: t_sale_pays pk_t_salepays; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.t_sale_pays
    ADD CONSTRAINT pk_t_salepays PRIMARY KEY (ch_id, src_pos_id);


--
-- Name: t_sale_temp pk_t_saletemp; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.t_sale_temp
    ADD CONSTRAINT pk_t_saletemp PRIMARY KEY (ch_id);


--
-- Name: t_sale_temp_d pk_t_saletempd; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.t_sale_temp_d
    ADD CONSTRAINT pk_t_saletempd PRIMARY KEY (ch_id, src_pos_id);


--
-- Name: t_sale_temp_pays pk_t_saletemppays; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.t_sale_temp_pays
    ADD CONSTRAINT pk_t_saletemppays PRIMARY KEY (ch_id, src_pos_id);


--
-- Name: t_z_rep pk_t_zrep; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.t_z_rep
    ADD CONSTRAINT pk_t_zrep PRIMARY KEY (ch_id);


--
-- Name: t_z_rep_t pk_t_zrept; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.t_z_rep_t
    ADD CONSTRAINT pk_t_zrept PRIMARY KEY (ch_id);


--
-- Name: z_doc_dc pk_z_docdc; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.z_doc_dc
    ADD CONSTRAINT pk_z_docdc PRIMARY KEY (doc_code, ch_id, d_card_id);


--
-- Name: z_log_disc_exp pk_z_logdiscexp; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.z_log_disc_exp
    ADD CONSTRAINT pk_z_logdiscexp PRIMARY KEY (d_bi_id, log_id);


--
-- Name: z_log_disc_exp_p pk_z_logdiscexpp; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.z_log_disc_exp_p
    ADD CONSTRAINT pk_z_logdiscexpp PRIMARY KEY (d_bi_id, log_id);


--
-- Name: z_log_disc_rec pk_z_logdiscrec; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.z_log_disc_rec
    ADD CONSTRAINT pk_z_logdiscrec PRIMARY KEY (d_bi_id, log_id);


--
-- Name: z_log_metrics pk_z_logmetrics; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.z_log_metrics
    ADD CONSTRAINT pk_z_logmetrics PRIMARY KEY (d_bi_id, log_id_ex);


--
-- Name: z_log_processings pk_z_logprocessings; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.z_log_processings
    ADD CONSTRAINT pk_z_logprocessings PRIMARY KEY (doc_code, ch_id);


--
-- Name: z_log_tools pk_z_logtools; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.z_log_tools
    ADD CONSTRAINT pk_z_logtools PRIMARY KEY (log_id);


--
-- Name: z_metrica_events pk_z_metricaevents; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.z_metrica_events
    ADD CONSTRAINT pk_z_metricaevents PRIMARY KEY (event_id);


--
-- Name: ppos ppos_ppo_number_key; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.ppos
    ADD CONSTRAINT ppos_ppo_number_key UNIQUE (ppo_number);


--
-- Name: t_cr_journal_doc_subtypes t_cr_journal_doc_subtypes_pkey; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.t_cr_journal_doc_subtypes
    ADD CONSTRAINT t_cr_journal_doc_subtypes_pkey PRIMARY KEY (doc_subtype_id);


--
-- Name: t_cr_journal_doc_types t_cr_journal_doc_types_pkey; Type: CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.t_cr_journal_doc_types
    ADD CONSTRAINT t_cr_journal_doc_types_pkey PRIMARY KEY (doc_type_id);


--
-- Name: r_disc_dc fk_r_discdc_r_dctypes; Type: FK CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.r_disc_dc
    ADD CONSTRAINT fk_r_discdc_r_dctypes FOREIGN KEY (dc_type_code) REFERENCES public.r_dc_types(dc_type_code) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: r_disc_dc fk_r_discdc_r_discs; Type: FK CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.r_disc_dc
    ADD CONSTRAINT fk_r_discdc_r_discs FOREIGN KEY (disc_code) REFERENCES public.r_discs(disc_code) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: t_cr_journal_text fk_t_crjournaltext_t_crjournaldocsubtypes; Type: FK CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.t_cr_journal_text
    ADD CONSTRAINT fk_t_crjournaltext_t_crjournaldocsubtypes FOREIGN KEY (doc_subtype_id) REFERENCES public.t_cr_journal_doc_subtypes(doc_subtype_id) ON UPDATE CASCADE;


--
-- Name: t_cr_journal_text fk_t_crjournaltext_t_crjournaldoctypes; Type: FK CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.t_cr_journal_text
    ADD CONSTRAINT fk_t_crjournaltext_t_crjournaldoctypes FOREIGN KEY (doc_type_id) REFERENCES public.t_cr_journal_doc_types(doc_type_id) ON UPDATE CASCADE;


--
-- Name: z_log_disc_exp fk_z_logdiscexp_r_discs; Type: FK CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.z_log_disc_exp
    ADD CONSTRAINT fk_z_logdiscexp_r_discs FOREIGN KEY (disc_code) REFERENCES public.r_discs(disc_code);


--
-- Name: z_log_disc_rec fk_z_logdiscrec_r_discs; Type: FK CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.z_log_disc_rec
    ADD CONSTRAINT fk_z_logdiscrec_r_discs FOREIGN KEY (disc_code) REFERENCES public.r_discs(disc_code);


--
-- Name: z_log_metrics fk_z_logmetrics_z_metricaevents; Type: FK CONSTRAINT; Schema: public; Owner: tc_client
--

ALTER TABLE ONLY public.z_log_metrics
    ADD CONSTRAINT fk_z_logmetrics_z_metricaevents FOREIGN KEY (event_id) REFERENCES public.z_metrica_events(event_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

