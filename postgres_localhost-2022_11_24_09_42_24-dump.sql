--
-- PostgreSQL database dump
--

-- Dumped from database version 13.3
-- Dumped by pg_dump version 13.3

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
-- Name: jenis_kelamin; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.jenis_kelamin AS ENUM (
    'L',
    'P'
);


ALTER TYPE public.jenis_kelamin OWNER TO postgres;

--
-- Name: status_ambulance; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.status_ambulance AS ENUM (
    'R',
    'N'
);


ALTER TYPE public.status_ambulance OWNER TO postgres;

--
-- Name: status_supir; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.status_supir AS ENUM (
    'R',
    'N'
);


ALTER TYPE public.status_supir OWNER TO postgres;

--
-- Name: create_ambulance(character varying, character varying, character varying, character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_ambulance(p_nama_ambulance character varying, p_no_plat character varying, p_id_jenis_kendaraan character varying, p_id_kategori_ambulance character varying, p_status_ambulance character varying, p_kilometer integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

    			p_id_ambulance varchar ;

				BEGIN

				p_id_ambulance = uuid_in(md5(random()::text || random()::text)::cstring)::varchar;


				INSERT INTO ambulance(id_ambulance, nama_ambulance, no_plat, id_jenis_kendaraan, id_kategori_ambulance, status_ambulance, kilometer)
				VALUES(p_id_ambulance, p_nama_ambulance, p_no_plat, p_id_jenis_kendaraan, p_id_kategori_ambulance, CAST(p_status_ambulance AS status_ambulance),p_kilometer );

				END;

$$;


ALTER FUNCTION public.create_ambulance(p_nama_ambulance character varying, p_no_plat character varying, p_id_jenis_kendaraan character varying, p_id_kategori_ambulance character varying, p_status_ambulance character varying, p_kilometer integer) OWNER TO postgres;

--
-- Name: create_supir_detail(character varying, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_supir_detail(p_nama character varying, p_nomor_hp character varying, p_foto_supir character varying, p_jenis_kelamin character varying, p_nip character varying, p_status_supir character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

    			p_id_supir_detail varchar ;

				BEGIN

				p_id_supir_detail = uuid_in(md5(random()::text || random()::text)::cstring)::varchar;


				INSERT INTO supir_detail(id_supir_detail, nama, nomor_hp, foto_supir, jenis_kelamin, nip, "status_supir ")
				VALUES(p_id_supir_detail,p_nama ,p_nomor_hp ,p_foto_supir ,CAST(p_jenis_kelamin AS jenis_kelamin), p_nip,  CAST(p_status_supir AS status_supir));

				END;

$$;


ALTER FUNCTION public.create_supir_detail(p_nama character varying, p_nomor_hp character varying, p_foto_supir character varying, p_jenis_kelamin character varying, p_nip character varying, p_status_supir character varying) OWNER TO postgres;

--
-- Name: create_user_level(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_user_level(p_user_level character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

    			p_id_user_level varchar ;

				BEGIN

				p_id_user_level = uuid_in(md5(random()::text || random()::text)::cstring)::varchar;


				INSERT INTO user_level(id_user_level, user_level)
				VALUES(p_id_user_level, p_user_level);

				END;

$$;


ALTER FUNCTION public.create_user_level(p_user_level character varying) OWNER TO postgres;

--
-- Name: login(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.login(param_username character varying, param_password character varying) RETURNS TABLE(p_id_user character varying, p_username character varying, id_user_level character varying, status_user character varying)
    LANGUAGE plpgsql
    AS $$
    DECLARE

        v_user users;

BEGIN
 select * into v_user from users where users.username = param_username;

 IF v_user is not null THEN
     IF (param_password LIKE v_user.password) THEN
        RETURN QUERY SELECT v_user.id_user,
                                v_user.username,
                                v_user.id_user_level,
                                CAST('2' AS varchar);
        ELSE
            RETURN QUERY SELECT CAST(null AS varchar),
                                CAST(null AS varchar),
                                CAST(null AS varchar),
                                CAST('1' AS varchar);
            END IF;
    ELSE
        RETURN QUERY SELECT CAST(null AS varchar),
                                CAST(null AS varchar),
                                CAST(null AS varchar),
                                CAST('0' AS varchar);


END IF;
END;
$$;


ALTER FUNCTION public.login(param_username character varying, param_password character varying) OWNER TO postgres;

--
-- Name: read_all_ambulance(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.read_all_ambulance() RETURNS TABLE(p_id_ambulance character varying, p_nama_ambulance character varying, p_no_plat character varying, p_kilometer integer, p_id_jenis_kendaraa character varying, p_jenis_kendaraan character varying, p_id_kategori_ambulance character varying, p_kategori_ambulance character varying, status_ambulance public.status_ambulance)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
    SELECT
           id_ambulance,
           nama_ambulance,
           no_plat,
           kilometer,
           ambulance.id_jenis_kendaraan,
           jk.jenis_kendaraan,
           ambulance.id_kategori_ambulance,
           ka.kategori_ambulance,
           ambulance.status_ambulance
	FROM "ambulance"
	    JOIN jenis_kendaraan jk on ambulance.id_jenis_kendaraan = jk.id_jenis_kendaraan
	    JOIN kategori_ambulance ka on ambulance.id_kategori_ambulance = ka.id_kategori_ambulance
    ORDER BY id_ambulance asc;
END;
$$;


ALTER FUNCTION public.read_all_ambulance() OWNER TO postgres;

--
-- Name: read_all_jenis_kendaraan(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.read_all_jenis_kendaraan() RETURNS TABLE(p_id_jenis_kendaraan character varying, p_jenis_kendaraan character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
    SELECT id_jenis_kendaraan, jenis_kendaraan
	FROM "jenis_kendaraan"
    ORDER BY id_jenis_kendaraan asc;
END;
$$;


ALTER FUNCTION public.read_all_jenis_kendaraan() OWNER TO postgres;

--
-- Name: read_all_kategori_ambulance(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.read_all_kategori_ambulance() RETURNS TABLE(p_id_kategori_ambulance character varying, p_kategori_ambulance character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
    SELECT id_kategori_ambulance, kategori_ambulance
	FROM "kategori_ambulance"
    ORDER BY id_kategori_ambulance asc;
END;
$$;


ALTER FUNCTION public.read_all_kategori_ambulance() OWNER TO postgres;

--
-- Name: read_all_supir_detail(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.read_all_supir_detail() RETURNS TABLE(p_id_supir_detail character varying, p_nama character varying, p_nomor_hp character varying, p_foto_supir character varying, p_jenis_kelamin public.jenis_kelamin, p_nip character varying, p_status_supir public.status_supir)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
    SELECT
           id_supir_detail,
           nama,
           nomor_hp,
           foto_supir,
           jenis_kelamin,
           nip,
           "status_supir "
	FROM "supir_detail"
    ORDER BY id_supir_detail asc;
END;
$$;


ALTER FUNCTION public.read_all_supir_detail() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ambulance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ambulance (
    id_ambulance character varying(100),
    nama_ambulance character varying(40),
    no_plat character varying(10),
    id_jenis_kendaraan character varying(100),
    id_kategori_ambulance character varying(100),
    status_ambulance public.status_ambulance,
    kilometer integer
);


ALTER TABLE public.ambulance OWNER TO postgres;

--
-- Name: jenis_kendaraan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jenis_kendaraan (
    id_jenis_kendaraan character varying(100),
    jenis_kendaraan character varying(50)
);


ALTER TABLE public.jenis_kendaraan OWNER TO postgres;

--
-- Name: kategori_ambulance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kategori_ambulance (
    id_kategori_ambulance character varying(100),
    kategori_ambulance character varying(50)
);


ALTER TABLE public.kategori_ambulance OWNER TO postgres;

--
-- Name: supir_detail; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.supir_detail (
    id_supir_detail character varying(100),
    nama character varying(30),
    nomor_hp character varying(20),
    foto_supir character varying(100),
    jenis_kelamin public.jenis_kelamin,
    nip character varying(30),
    "status_supir " public.status_supir
);


ALTER TABLE public.supir_detail OWNER TO postgres;

--
-- Name: user_level; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_level (
    id_user_level character varying(50) NOT NULL,
    user_level character varying(50)
);


ALTER TABLE public.user_level OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id_user character varying(50) NOT NULL,
    username character varying(30),
    password character varying(50),
    id_user_level character varying(50),
    id_user_detail character varying(50)
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Data for Name: ambulance; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ambulance VALUES ('08ac024e-f3f8-9f0a-8ed6-3a5de8aafd49', 'Ambulance A', 'BG 1999 A', 'c6a246c4-0b73-43f6-b3bd-f532b676a9b3', 'c8ah48c4-0i73-03f6-b8d-f53gbf7659b3', 'R', 100);
INSERT INTO public.ambulance VALUES ('feee0aec-3b10-19dd-7267-54f346cb3120', 'Ambulance B', 'BG 2999 J', 'c6a246c4-0b73-43f6-b3bd-f532b676a9b3', 'c6a246c4-0b73-43f6-b3bd-f53gbf7659b3', 'N', 30);


--
-- Data for Name: jenis_kendaraan; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.jenis_kendaraan VALUES ('c6a246c4-0b73-43f6-b3bd-f532b676a9b3', 'AFV');


--
-- Data for Name: kategori_ambulance; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.kategori_ambulance VALUES ('c8ah48c4-0i73-03f6-b8d-f53gbf7659b3', 'Ambulance Pasien');
INSERT INTO public.kategori_ambulance VALUES ('c6a246c4-0b73-43f6-b3bd-f53gbf7659b3', 'Ambulance Jenazah');


--
-- Data for Name: supir_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.supir_detail VALUES ('75a13659-c0eb-a861-cc10-13fd27766da9', 'Amir', '082176350289', 'amir.jpg', 'L', '0182817271216', 'R');


--
-- Data for Name: user_level; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.user_level VALUES ('3ab79fe2-2234-b8c6-6387-b815c4d14e30', 'tenaga kesehatan');
INSERT INTO public.user_level VALUES ('bc814274-95da-b744-22ca-67a33ace375e', 'pengelola ambulance');
INSERT INTO public.user_level VALUES ('cef5e5a8-ebdc-b854-5fbf-0615a66e97e2', 'supir ambulance');
INSERT INTO public.user_level VALUES ('1cfef359-9669-afa2-f4bc-a7e62705f061', 'kasir');


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users VALUES ('1h291281', 'user', '123', '1', '1y2h712');


--
-- Name: user_level user_level_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_level
    ADD CONSTRAINT user_level_pk PRIMARY KEY (id_user_level);


--
-- Name: users user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT user_pkey PRIMARY KEY (id_user);


--
-- PostgreSQL database dump complete
--

