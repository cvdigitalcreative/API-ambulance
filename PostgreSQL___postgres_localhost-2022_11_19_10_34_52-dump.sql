--
-- PostgreSQL database dump
--

-- Dumped from database version 14.4
-- Dumped by pg_dump version 14.4

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
            RETURN QUERY SELECT CAST('null' AS varchar),
                                CAST('null' AS varchar),
                                CAST('null' AS varchar),
                                CAST('1' AS varchar);
            END IF;
    ELSE
        RETURN QUERY SELECT CAST('null' AS varchar),
                                CAST('null' AS varchar),
                                CAST('null' AS varchar),
                                CAST('0' AS varchar);


END IF;
END;
$$;


ALTER FUNCTION public.login(param_username character varying, param_password character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

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
-- Data for Name: user_level; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_level (id_user_level, user_level) FROM stdin;
3ab79fe2-2234-b8c6-6387-b815c4d14e30	tenaga kesehatan
bc814274-95da-b744-22ca-67a33ace375e	pengelola ambulance
cef5e5a8-ebdc-b854-5fbf-0615a66e97e2	supir ambulance
1cfef359-9669-afa2-f4bc-a7e62705f061	kasir
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id_user, username, password, id_user_level, id_user_detail) FROM stdin;
awdoland2812daw	nakes	123	3ab79fe2-2234-b8c6-6387-b815c4d14e30	 
dwnd11h8d2nd291	kasir	123	1cfef359-9669-afa2-f4bc-a7e62705f061	 
mawdpiwj102h212	pengelola	123	bc814274-95da-b744-22ca-67a33ace375e	 
aldkcnawiod12h0	supir	123	cef5e5a8-ebdc-b854-5fbf-0615a66e97e2	 
\.


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

