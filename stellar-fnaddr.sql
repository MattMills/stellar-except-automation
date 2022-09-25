--
-- PostgreSQL database dump
--

-- Dumped from database version 12.11 (Ubuntu 12.11-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 12.11 (Ubuntu 12.11-0ubuntu0.20.04.1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: fn2hash; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fn2hash (
    id integer NOT NULL,
    executable_md5 text NOT NULL,
    addr bigint NOT NULL,
    num_basic_blocks integer NOT NULL,
    num_basic_blocks_in_cfg integer NOT NULL,
    num_instructions integer NOT NULL,
    num_bytes integer NOT NULL,
    exact_hash text NOT NULL,
    pic_hash text NOT NULL,
    composite_pic_hash text NOT NULL,
    mnemonic_hash text NOT NULL,
    mnemonic_count_hash text NOT NULL,
    mnemonic_category_hash text NOT NULL,
    mnemonic_category_count_hash text NOT NULL,
    version_id integer
);


ALTER TABLE public.fn2hash OWNER TO postgres;

--
-- Name: fn2hash_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fn2hash_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fn2hash_id_seq OWNER TO postgres;

--
-- Name: fn2hash_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fn2hash_id_seq OWNED BY public.fn2hash.id;


--
-- Name: objdump_function; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.objdump_function (
    id integer NOT NULL,
    version_id integer NOT NULL,
    vma bigint NOT NULL,
    start_addr bigint NOT NULL,
    end_addr bigint NOT NULL,
    unwind bigint NOT NULL
);


ALTER TABLE public.objdump_function OWNER TO postgres;

--
-- Name: objdump_function_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.objdump_function_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.objdump_function_id_seq OWNER TO postgres;

--
-- Name: objdump_function_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.objdump_function_id_seq OWNED BY public.objdump_function.id;


--
-- Name: symbol_addr; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.symbol_addr (
    id integer NOT NULL,
    version_id integer NOT NULL,
    addr bigint NOT NULL,
    symbol_id integer NOT NULL
);


ALTER TABLE public.symbol_addr OWNER TO postgres;

--
-- Name: symbol_addr_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.symbol_addr_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.symbol_addr_id_seq OWNER TO postgres;

--
-- Name: symbol_addr_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.symbol_addr_id_seq OWNED BY public.symbol_addr.id;


--
-- Name: symbol_addr_symbol_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.symbol_addr_symbol_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.symbol_addr_symbol_seq OWNER TO postgres;

--
-- Name: symbol_addr_symbol_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.symbol_addr_symbol_seq OWNED BY public.symbol_addr.symbol_id;


--
-- Name: symbol_addr_version_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.symbol_addr_version_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.symbol_addr_version_seq OWNER TO postgres;

--
-- Name: symbol_addr_version_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.symbol_addr_version_seq OWNED BY public.symbol_addr.version_id;


--
-- Name: symbols; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.symbols (
    id integer NOT NULL,
    symbol text NOT NULL
);


ALTER TABLE public.symbols OWNER TO postgres;

--
-- Name: symbols_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.symbols_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.symbols_id_seq OWNER TO postgres;

--
-- Name: symbols_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.symbols_id_seq OWNED BY public.symbols.id;


--
-- Name: versions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.versions (
    id integer NOT NULL,
    version text NOT NULL,
    platform text NOT NULL,
    os text NOT NULL,
    md5 text
);


ALTER TABLE public.versions OWNER TO postgres;

--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.versions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.versions_id_seq OWNER TO postgres;

--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.versions_id_seq OWNED BY public.versions.id;


--
-- Name: fn2hash id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fn2hash ALTER COLUMN id SET DEFAULT nextval('public.fn2hash_id_seq'::regclass);


--
-- Name: objdump_function id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.objdump_function ALTER COLUMN id SET DEFAULT nextval('public.objdump_function_id_seq'::regclass);


--
-- Name: symbol_addr id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.symbol_addr ALTER COLUMN id SET DEFAULT nextval('public.symbol_addr_id_seq'::regclass);


--
-- Name: symbols id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.symbols ALTER COLUMN id SET DEFAULT nextval('public.symbols_id_seq'::regclass);


--
-- Name: versions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.versions ALTER COLUMN id SET DEFAULT nextval('public.versions_id_seq'::regclass);


--
-- Name: fn2hash fn2hash_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fn2hash
    ADD CONSTRAINT fn2hash_pkey PRIMARY KEY (id);


--
-- Name: objdump_function objdump_function_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.objdump_function
    ADD CONSTRAINT objdump_function_pkey PRIMARY KEY (id);


--
-- Name: symbol_addr symbol_addr_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.symbol_addr
    ADD CONSTRAINT symbol_addr_pkey PRIMARY KEY (id);


--
-- Name: symbols symbols_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.symbols
    ADD CONSTRAINT symbols_pkey PRIMARY KEY (id);


--
-- Name: symbols symbols_symbol_unique_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.symbols
    ADD CONSTRAINT symbols_symbol_unique_key UNIQUE (symbol);


--
-- Name: versions versions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: fn2_hash_composite_pic_hash_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fn2_hash_composite_pic_hash_idx ON public.fn2hash USING btree (composite_pic_hash);


--
-- Name: fn2hash_exact_hash_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fn2hash_exact_hash_idx ON public.fn2hash USING btree (exact_hash);


--
-- Name: fn2hash_executable_md5_addr_unique_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX fn2hash_executable_md5_addr_unique_key ON public.fn2hash USING btree (executable_md5, addr);


--
-- Name: fn2hash_executable_md5_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fn2hash_executable_md5_idx ON public.fn2hash USING btree (executable_md5);


--
-- Name: fn2hash_mnemonic_hash_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fn2hash_mnemonic_hash_idx ON public.fn2hash USING btree (mnemonic_hash);


--
-- Name: fn2hash_pic_hash_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fn2hash_pic_hash_idx ON public.fn2hash USING btree (pic_hash);


--
-- Name: fn2hash_version_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fn2hash_version_id_idx ON public.fn2hash USING btree (version_id);


--
-- Name: idx_objdump_function_addr; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_objdump_function_addr ON public.objdump_function USING btree (start_addr, end_addr);


--
-- Name: idx_objdump_function_id_start_end; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_objdump_function_id_start_end ON public.objdump_function USING btree (id, start_addr, end_addr);


--
-- Name: symbol_addr_addr_symbol_id_version_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX symbol_addr_addr_symbol_id_version_id_idx ON public.symbol_addr USING btree (addr, symbol_id, version_id);


--
-- Name: uniq_idx_symbol_addr_symbol_id_addr_version_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uniq_idx_symbol_addr_symbol_id_addr_version_id ON public.symbol_addr USING btree (symbol_id, addr, version_id);


--
-- Name: uniq_objdump_function; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uniq_objdump_function ON public.objdump_function USING btree (version_id, vma, start_addr, end_addr, unwind);


--
-- Name: versions_version_platform_os_unique_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX versions_version_platform_os_unique_key ON public.versions USING btree (version, platform, os);


--
-- PostgreSQL database dump complete
--

