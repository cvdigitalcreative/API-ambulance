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
-- Name: golongan_pasien; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.golongan_pasien AS ENUM (
    'REG',
    'PBI',
    'NULL'
);


ALTER TYPE public.golongan_pasien OWNER TO postgres;

--
-- Name: jenis_kelamin; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.jenis_kelamin AS ENUM (
    'L',
    'P',
    'NULL'
);


ALTER TYPE public.jenis_kelamin OWNER TO postgres;

--
-- Name: metode_pembayaran; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.metode_pembayaran AS ENUM (
    'CASH',
    'NON CASH',
    'NULL'
);


ALTER TYPE public.metode_pembayaran OWNER TO postgres;

--
-- Name: status_ambulance; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.status_ambulance AS ENUM (
    'R',
    'N',
    'NULL'
);


ALTER TYPE public.status_ambulance OWNER TO postgres;

--
-- Name: status_supir; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.status_supir AS ENUM (
    'R',
    'N',
    'NULL'
);


ALTER TYPE public.status_supir OWNER TO postgres;

--
-- Name: count_all_ambulance_by_status_and_kategori_ambulance(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.count_all_ambulance_by_status_and_kategori_ambulance(param_status character varying, param_kategori_ambulance character varying) RETURNS TABLE(p_total_ambulance bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
    SELECT
           COUNT(ambulance.no_plat)
	FROM "ambulance"

	    JOIN jenis_kendaraan jk on ambulance.id_jenis_kendaraan = jk.id_jenis_kendaraan
	    JOIN kategori_ambulance ka on ambulance.id_kategori_ambulance = ka.id_kategori_ambulance
        JOIN wilayah w on ambulance.id_wilayah = w.id_wilayah

    WHERE CAST(ambulance.status_ambulance as varchar) = param_status AND ambulance.id_kategori_ambulance = param_kategori_ambulance
    GROUP BY ambulance.id_kategori_ambulance;
END;
$$;


ALTER FUNCTION public.count_all_ambulance_by_status_and_kategori_ambulance(param_status character varying, param_kategori_ambulance character varying) OWNER TO postgres;

--
-- Name: count_ambulance_on_ordered_by_no_plat(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.count_ambulance_on_ordered_by_no_plat(param_no_plat character varying) RETURNS TABLE(p_total_ambulance bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
select COUNT(a.id_ambulance) from transaksi JOIN ambulance a on transaksi.id_ambulance = a.id_ambulance
WHERE transaksi.id_status_transaksi != 'e17b741e-46a8-1712-cdb6-1f010c473691' AND
      transaksi.id_status_transaksi != 'e17b741e-46a8-1712-cdb6-1c010a473697' AND a.no_plat = param_no_plat;
END;
$$;


ALTER FUNCTION public.count_ambulance_on_ordered_by_no_plat(param_no_plat character varying) OWNER TO postgres;

--
-- Name: count_supir_on_ordered_by_id(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.count_supir_on_ordered_by_id(param_id_supir_detail character varying) RETURNS TABLE(p_total_supir bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
select COUNT(sd.id_supir_detail) from transaksi JOIN supir_detail sd on transaksi.id_supir_detail = sd.id_supir_detail
WHERE transaksi.id_status_transaksi != 'e17b741e-46a8-1712-cdb6-1f010c473691' AND
      transaksi.id_status_transaksi != 'e17b741e-46a8-1712-cdb6-1c010a473697' AND (transaksi.id_supir_detail = param_id_supir_detail OR transaksi.id_supir_detail_2 = param_id_supir_detail);
END;
$$;


ALTER FUNCTION public.count_supir_on_ordered_by_id(param_id_supir_detail character varying) OWNER TO postgres;

--
-- Name: create_ambulance(character varying, character varying, character varying, character varying, character varying, integer, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_ambulance(p_nama_ambulance character varying, p_no_plat character varying, p_id_jenis_kendaraan character varying, p_id_kategori_ambulance character varying, p_status_ambulance character varying, p_kilometer integer, p_id_wilayah character varying, p_kondisi integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

    			p_id_ambulance varchar ;

				BEGIN

				p_id_ambulance = uuid_in(md5(random()::text || random()::text)::cstring)::varchar;


				INSERT INTO ambulance(id_ambulance, nama_ambulance, no_plat, id_jenis_kendaraan, id_kategori_ambulance, status_ambulance, kilometer, id_wilayah, kondisi)
				VALUES(p_id_ambulance, p_nama_ambulance, p_no_plat, p_id_jenis_kendaraan, p_id_kategori_ambulance, CAST(p_status_ambulance AS status_ambulance),p_kilometer,  p_id_wilayah, p_kondisi);

				END;

$$;


ALTER FUNCTION public.create_ambulance(p_nama_ambulance character varying, p_no_plat character varying, p_id_jenis_kendaraan character varying, p_id_kategori_ambulance character varying, p_status_ambulance character varying, p_kilometer integer, p_id_wilayah character varying, p_kondisi integer) OWNER TO postgres;

--
-- Name: create_status_pembayaran(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_status_pembayaran(p_status_pembayaran character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

    			p_id_status_pembayaran varchar ;

				BEGIN

				p_id_status_pembayaran = uuid_in(md5(random()::text || random()::text)::cstring)::varchar;


				INSERT INTO status_pembayaran(id_status_pembayaran, status_pembayaran)
				VALUES(p_id_status_pembayaran, p_status_pembayaran);

				END;

$$;


ALTER FUNCTION public.create_status_pembayaran(p_status_pembayaran character varying) OWNER TO postgres;

--
-- Name: create_status_transaksi(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_status_transaksi(p_status_transaksi character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

    			p_id_status_transaksi varchar ;

				BEGIN

				p_id_status_transaksi = uuid_in(md5(random()::text || random()::text)::cstring)::varchar;


				INSERT INTO status_transaksi(id_status_transaksi, status_transaksi)
				VALUES(p_id_status_transaksi, p_status_transaksi);

				END;

$$;


ALTER FUNCTION public.create_status_transaksi(p_status_transaksi character varying) OWNER TO postgres;

--
-- Name: create_transaksi(character varying, character varying, character varying, character varying, character varying, numeric, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, numeric, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_transaksi(p_nomor_invoice character varying, p_nomor_registrasi character varying, p_nomor_surat_tugas character varying, p_link_tracking character varying, p_alamat character varying, p_jarak numeric, p_latitude_tujuan character varying, p_longitude_tujuan character varying, p_foto_maps character varying, p_id_supir_detail character varying, p_id_supir_detail_2 character varying, p_id_status_transaksi character varying, p_id_ambulance character varying, p_id_wilayah character varying, p_id_user_nakes character varying, p_tarif_pembayaran numeric, p_tanggal_pembayaran character varying, p_kode_tindakan character varying, p_id_status_pembayaran character varying, p_id_user_kasir character varying, p_metode_pembayaran character varying, p_nama_lengkap character varying, p_jenis_kelamin character varying, p_nama_ruangan_medik character varying, p_nomor_rekam_medik character varying, p_nomor_kamar character varying, p_golongan_pasien character varying, p_nomor_telepon character varying, p_id_kategori_ambulance character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

    			p_id_transaksi varchar ;
                p_id_pasien_detail varchar ;
                p_id_pembayaran varchar ;
				BEGIN

				p_id_transaksi = uuid_in(md5(random()::text || random()::text)::cstring)::varchar;
				p_id_pasien_detail = uuid_in(md5(random()::text || random()::text)::cstring)::varchar;
				p_id_pembayaran = uuid_in(md5(random()::text || random()::text)::cstring)::varchar;

				INSERT INTO transaksi(id_transaksi, nomor_invoice, nomor_registrasi, nomor_surat_tugas, link_tracking,
				                      alamat, jarak, latitude_tujuan, longitude_tujuan, tanggal_transaksi, foto_maps, id_supir_detail, id_supir_detail_2,
				                      id_status_transaksi, id_ambulance, id_wilayah, id_user_nakes, id_pasien_detail,
				                      id_pembayaran, id_kategori_ambulance) VALUES (p_id_transaksi, p_nomor_invoice, p_nomor_registrasi,
				                      p_nomor_surat_tugas, p_link_tracking,  p_alamat, p_jarak ,  p_latitude_tujuan, p_longitude_tujuan,
				                      NOW(), p_foto_maps, p_id_supir_detail, p_id_supir_detail_2, p_id_status_transaksi, p_id_ambulance,
				                      p_id_wilayah,  p_id_user_nakes, p_id_pasien_detail, p_id_pembayaran, p_id_kategori_ambulance);
				INSERT INTO pembayaran(id_pembayaran, tarif, tanggal_pembayaran, kode_tindakan, id_status_pembayaran, id_user_kasir,
				                       metode_pembayaran) VALUES (p_id_pembayaran, CAST(p_tarif_pembayaran as decimal), CAST(p_tanggal_pembayaran AS timestamp), p_kode_tindakan, p_id_status_pembayaran, p_id_user_kasir,
				                        CAST(p_metode_pembayaran AS metode_pembayaran));
				INSERT INTO pasien_detail(id_pasien_detail, nama_lengkap, jenis_kelamin, nama_ruangan_medik, nomor_rekam_medik, nomor_kamar,
				                          golongan_pasien, nomor_telepon) VALUES (p_id_pasien_detail, p_nama_lengkap, CAST(p_jenis_kelamin AS jenis_kelamin),
				                          p_nama_ruangan_medik, p_nomor_rekam_medik, p_nomor_kamar, CAST(p_golongan_pasien AS golongan_pasien), p_nomor_telepon);
				



				END;

$$;


ALTER FUNCTION public.create_transaksi(p_nomor_invoice character varying, p_nomor_registrasi character varying, p_nomor_surat_tugas character varying, p_link_tracking character varying, p_alamat character varying, p_jarak numeric, p_latitude_tujuan character varying, p_longitude_tujuan character varying, p_foto_maps character varying, p_id_supir_detail character varying, p_id_supir_detail_2 character varying, p_id_status_transaksi character varying, p_id_ambulance character varying, p_id_wilayah character varying, p_id_user_nakes character varying, p_tarif_pembayaran numeric, p_tanggal_pembayaran character varying, p_kode_tindakan character varying, p_id_status_pembayaran character varying, p_id_user_kasir character varying, p_metode_pembayaran character varying, p_nama_lengkap character varying, p_jenis_kelamin character varying, p_nama_ruangan_medik character varying, p_nomor_rekam_medik character varying, p_nomor_kamar character varying, p_golongan_pasien character varying, p_nomor_telepon character varying, p_id_kategori_ambulance character varying) OWNER TO postgres;

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
-- Name: create_user_supir(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_user_supir(p_username character varying, p_password character varying, p_id_user_level character varying, p_nama character varying, p_nomor_hp character varying, p_foto_supir character varying, p_jenis_kelamin character varying, p_nip character varying, p_status_supir character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

    			p_id_user varchar;
                p_id_log_status_supir varchar ;
				BEGIN

				p_id_user = uuid_in(md5(random()::text || random()::text)::cstring)::varchar;
				p_id_log_status_supir = uuid_in(md5(random()::text || random()::text)::cstring)::varchar;

				INSERT INTO users(id_user, username, password, id_user_level, id_user_detail)
				VALUES (p_id_user, p_username, p_password, p_id_user_level, p_id_user);
				INSERT INTO supir_detail(id_supir_detail, nama, nomor_hp, foto_supir, jenis_kelamin, nip, "status_supir ")
				VALUES (p_id_user, p_nama, p_nomor_hp, p_foto_supir, CAST(p_jenis_kelamin AS jenis_kelamin), p_nip, CAST(p_status_supir AS status_supir) );
                INSERT INTO log_status_supir(id_log_status_supir, updated_at, id_supir_detail) VALUES (p_id_log_status_supir, NOW() ,p_id_user);
				END;

$$;


ALTER FUNCTION public.create_user_supir(p_username character varying, p_password character varying, p_id_user_level character varying, p_nama character varying, p_nomor_hp character varying, p_foto_supir character varying, p_jenis_kelamin character varying, p_nip character varying, p_status_supir character varying) OWNER TO postgres;

--
-- Name: create_wilayah(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_wilayah(p_wilayah character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

    			p_id_wilayah varchar ;

				BEGIN

				p_id_wilayah = uuid_in(md5(random()::text || random()::text)::cstring)::varchar;


				INSERT INTO wilayah("id_wilayah ", wilayah)
				VALUES(p_id_wilayah, p_wilayah);

				END;

$$;


ALTER FUNCTION public.create_wilayah(p_wilayah character varying) OWNER TO postgres;

--
-- Name: delete_ambulance_by_plat(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.delete_ambulance_by_plat(p_no_plat character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN

DELETE FROM ambulance WHERE no_plat = p_no_plat;

END;
$$;


ALTER FUNCTION public.delete_ambulance_by_plat(p_no_plat character varying) OWNER TO postgres;

--
-- Name: login(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.login(param_username character varying, param_password character varying) RETURNS TABLE(p_id_user character varying, p_username character varying, p_id_user_level character varying, p_status_user character varying)
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

CREATE FUNCTION public.read_all_ambulance() RETURNS TABLE(p_no_plat character varying, p_id_ambulance character varying, p_nama_ambulance character varying, p_kilometer integer, p_id_jenis_kendaraa character varying, p_jenis_kendaraan character varying, p_id_kategori_ambulance character varying, p_kategori_ambulance character varying, p_status_ambulance public.status_ambulance, p_id_wilayah character varying, p_wilayah character varying, p_kondisi integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
    SELECT
           DISTINCT ON (ambulance.no_plat) ambulance.no_plat,
           id_ambulance,
           nama_ambulance,
           kilometer,
           ambulance.id_jenis_kendaraan,
           jk.jenis_kendaraan,
           ambulance.id_kategori_ambulance,
           ka.kategori_ambulance,
           ambulance.status_ambulance,
           ambulance.id_wilayah,
           w.wilayah,
           kondisi
	FROM "ambulance"
	    JOIN jenis_kendaraan jk on ambulance.id_jenis_kendaraan = jk.id_jenis_kendaraan
	    JOIN kategori_ambulance ka on ambulance.id_kategori_ambulance = ka.id_kategori_ambulance
        JOIN wilayah w on ambulance.id_wilayah = w.id_wilayah 
    ORDER BY ambulance.no_plat asc;
END;
$$;


ALTER FUNCTION public.read_all_ambulance() OWNER TO postgres;

--
-- Name: read_all_ambulance_by_no_plat(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.read_all_ambulance_by_no_plat(param_no_plat character varying) RETURNS TABLE(p_no_plat character varying, p_id_ambulance character varying, p_nama_ambulance character varying, p_kilometer integer, p_id_jenis_kendaraa character varying, p_jenis_kendaraan character varying, p_id_kategori_ambulance character varying, p_kategori_ambulance character varying, p_status_ambulance public.status_ambulance, p_id_wilayah character varying, p_wilayah character varying, p_kondisi integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
    SELECT
           ambulance.no_plat,
           id_ambulance,
           nama_ambulance,
           kilometer,
           ambulance.id_jenis_kendaraan,
           jk.jenis_kendaraan,
           ambulance.id_kategori_ambulance,
           ka.kategori_ambulance,
           ambulance.status_ambulance,
           ambulance.id_wilayah,
           w.wilayah,
           kondisi
	FROM "ambulance"
	    JOIN jenis_kendaraan jk on ambulance.id_jenis_kendaraan = jk.id_jenis_kendaraan
	    JOIN kategori_ambulance ka on ambulance.id_kategori_ambulance = ka.id_kategori_ambulance
        JOIN wilayah w on ambulance.id_wilayah = w.id_wilayah WHERE "ambulance".no_plat = param_no_plat
    ORDER BY ambulance.no_plat asc;
END;
$$;


ALTER FUNCTION public.read_all_ambulance_by_no_plat(param_no_plat character varying) OWNER TO postgres;

--
-- Name: read_all_ambulance_by_no_plat_distict(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.read_all_ambulance_by_no_plat_distict(param_no_plat character varying) RETURNS TABLE(p_no_plat character varying, p_id_ambulance character varying, p_nama_ambulance character varying, p_kilometer integer, p_id_jenis_kendaraa character varying, p_jenis_kendaraan character varying, p_id_kategori_ambulance character varying, p_kategori_ambulance character varying, p_status_ambulance public.status_ambulance, p_id_wilayah character varying, p_wilayah character varying, p_kondisi integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
    SELECT
           DISTINCT ON (ambulance.no_plat) ambulance.no_plat,
           id_ambulance,
           nama_ambulance,
           kilometer,
           ambulance.id_jenis_kendaraan,
           jk.jenis_kendaraan,
           ambulance.id_kategori_ambulance,
           ka.kategori_ambulance,
           ambulance.status_ambulance,
           ambulance.id_wilayah,
           w.wilayah,
           kondisi
	FROM "ambulance"
	    JOIN jenis_kendaraan jk on ambulance.id_jenis_kendaraan = jk.id_jenis_kendaraan
	    JOIN kategori_ambulance ka on ambulance.id_kategori_ambulance = ka.id_kategori_ambulance
        JOIN wilayah w on ambulance.id_wilayah = w.id_wilayah WHERE ambulance.no_plat = param_no_plat
    ORDER BY ambulance.no_plat asc;
END;
$$;


ALTER FUNCTION public.read_all_ambulance_by_no_plat_distict(param_no_plat character varying) OWNER TO postgres;

--
-- Name: read_all_ambulance_filter(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.read_all_ambulance_filter(param_status_ambulance character varying) RETURNS TABLE(p_no_plat character varying, p_id_ambulance character varying, p_nama_ambulance character varying, p_kilometer integer, p_id_jenis_kendaraa character varying, p_jenis_kendaraan character varying, p_id_kategori_ambulance character varying, p_kategori_ambulance character varying, p_status_ambulance public.status_ambulance, p_id_wilayah character varying, p_wilayah character varying, p_kondisi integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    if param_status_ambulance <> ''  then

 return query
    SELECT
          DISTINCT  ON(ambulance.no_plat) no_plat,
           id_ambulance,
           nama_ambulance,
           kilometer,
           ambulance.id_jenis_kendaraan,
           jk.jenis_kendaraan,
           ambulance.id_kategori_ambulance,
           ka.kategori_ambulance,
           ambulance.status_ambulance,
           ambulance.id_wilayah,
           w.wilayah,
           kondisi
	FROM "ambulance"
	    JOIN jenis_kendaraan jk on ambulance.id_jenis_kendaraan = jk.id_jenis_kendaraan
	    JOIN kategori_ambulance ka on ambulance.id_kategori_ambulance = ka.id_kategori_ambulance

        JOIN wilayah w on ambulance.id_wilayah = w.id_wilayah
    WHERE
          CAST(ambulance.status_ambulance as varchar)   =  param_status_ambulance
 
    ORDER BY no_plat asc;
    else
 return query
    SELECT
           DISTINCT  ON(ambulance.no_plat) no_plat,
           id_ambulance,
           nama_ambulance,
           kilometer,
           ambulance.id_jenis_kendaraan,
           jk.jenis_kendaraan,
           ambulance.id_kategori_ambulance,
           ka.kategori_ambulance,
           ambulance.status_ambulance,
           ambulance.id_wilayah,
           w.wilayah,
           kondisi
	FROM "ambulance"
	    JOIN jenis_kendaraan jk on ambulance.id_jenis_kendaraan = jk.id_jenis_kendaraan
	    JOIN kategori_ambulance ka on ambulance.id_kategori_ambulance = ka.id_kategori_ambulance

        JOIN wilayah w on ambulance.id_wilayah = w.id_wilayah
    ORDER BY no_plat asc;

    end if;
END;
$$;


ALTER FUNCTION public.read_all_ambulance_filter(param_status_ambulance character varying) OWNER TO postgres;

--
-- Name: read_all_ambulance_rekomendasi(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.read_all_ambulance_rekomendasi(param_wilayah character varying, param_kategori_ambulance character varying) RETURNS TABLE(p_id_ambulance character varying, p_no_plat character varying, p_nama_ambulance character varying, p_kilometer integer, p_id_jenis_kendaraa character varying, p_jenis_kendaraan character varying, p_id_kategori_ambulance character varying, p_kategori_ambulance character varying, p_status_ambulance public.status_ambulance, p_id_wilayah character varying, p_wilayah character varying, p_kondisi integer)
    LANGUAGE plpgsql
    AS $$
BEGIN

 return query
    SELECT
           ambulance.id_ambulance,
           ambulance.no_plat,
           ambulance.nama_ambulance,
           ambulance.kilometer,
           ambulance.id_jenis_kendaraan,
           jk.jenis_kendaraan,
           ambulance.id_kategori_ambulance,
           ka.kategori_ambulance,
           ambulance.status_ambulance,
           ambulance.id_wilayah,
           w.wilayah,
           ambulance.kondisi
	FROM "ambulance"
	
	    JOIN jenis_kendaraan jk on ambulance.id_jenis_kendaraan = jk.id_jenis_kendaraan
	    JOIN kategori_ambulance ka on ambulance.id_kategori_ambulance = ka.id_kategori_ambulance
        JOIN wilayah w on ambulance.id_wilayah = w.id_wilayah
    WHERE "ambulance".status_ambulance = 'R' AND "ambulance".id_kategori_ambulance = param_kategori_ambulance  AND "ambulance".id_wilayah = param_wilayah
    ORDER BY  "ambulance".kondisi DESC
 LIMIT 1;
END;
$$;


ALTER FUNCTION public.read_all_ambulance_rekomendasi(param_wilayah character varying, param_kategori_ambulance character varying) OWNER TO postgres;

--
-- Name: read_all_ambulance_search(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.read_all_ambulance_search(param_search character varying, param_status_ambulance character varying) RETURNS TABLE(p_no_plat character varying, p_id_ambulance character varying, p_nama_ambulance character varying, p_kilometer integer, p_id_jenis_kendaraa character varying, p_jenis_kendaraan character varying, p_id_kategori_ambulance character varying, p_kategori_ambulance character varying, p_status_ambulance public.status_ambulance, p_id_wilayah character varying, p_wilayah character varying, p_kondisi integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    if param_search <> ''  then
        
        if param_status_ambulance <> '' then
              return query
    SELECT
           DISTINCT  ON(ambulance.no_plat) no_plat,
           id_ambulance,
           nama_ambulance,
           kilometer,
           ambulance.id_jenis_kendaraan,
           jk.jenis_kendaraan,
           ambulance.id_kategori_ambulance,
           ka.kategori_ambulance,
           ambulance.status_ambulance,
           ambulance.id_wilayah,
           w.wilayah,
           kondisi
	FROM "ambulance"
	    JOIN jenis_kendaraan jk on ambulance.id_jenis_kendaraan = jk.id_jenis_kendaraan
	    JOIN kategori_ambulance ka on ambulance.id_kategori_ambulance = ka.id_kategori_ambulance
    
        JOIN wilayah w on ambulance.id_wilayah = w."id_wilayah" 
    WHERE LOWER(ambulance.nama_ambulance)  LIKE  CONCAT ('%',param_search,'%') OR
          LOWER(ambulance.no_plat)  LIKE  CONCAT ('%', param_search, '%')OR
          CAST(ambulance.kondisi as varchar)   LIKE  CONCAT ('%', param_search, '%')
          AND CAST(ambulance.status_ambulance as varchar) = param_status_ambulance
    
    ORDER BY no_plat asc;
            else
            return query
    SELECT
           DISTINCT  ON(ambulance.no_plat) no_plat,
           id_ambulance,
           nama_ambulance,
           kilometer,
           ambulance.id_jenis_kendaraan,
           jk.jenis_kendaraan,
           ambulance.id_kategori_ambulance,
           ka.kategori_ambulance,
           ambulance.status_ambulance,
           ambulance.id_wilayah,
           w.wilayah,
           kondisi
	FROM "ambulance"
	    JOIN jenis_kendaraan jk on ambulance.id_jenis_kendaraan = jk.id_jenis_kendaraan
	    JOIN kategori_ambulance ka on ambulance.id_kategori_ambulance = ka.id_kategori_ambulance
    
        JOIN wilayah w on ambulance.id_wilayah = w."id_wilayah" 
    WHERE LOWER(ambulance.nama_ambulance)  LIKE  CONCAT ('%',param_search,'%') OR
          LOWER(ambulance.no_plat)  LIKE  CONCAT ('%', param_search, '%')OR
          CAST(ambulance.kondisi as varchar)   LIKE  CONCAT ('%', param_search, '%')
    ORDER BY no_plat asc;
            
end if;
        
   
 
    else
        
        if param_status_ambulance <> '' then
            
 return query
    SELECT
           DISTINCT  ON(ambulance.no_plat) no_plat,
           id_ambulance,
           nama_ambulance,
           kilometer,
           ambulance.id_jenis_kendaraan,
           jk.jenis_kendaraan,
           ambulance.id_kategori_ambulance,
           ka.kategori_ambulance,
           ambulance.status_ambulance,
           ambulance.id_wilayah,
           w.wilayah,
           kondisi
	FROM "ambulance"
	    JOIN jenis_kendaraan jk on ambulance.id_jenis_kendaraan = jk.id_jenis_kendaraan
	    JOIN kategori_ambulance ka on ambulance.id_kategori_ambulance = ka.id_kategori_ambulance
    
        JOIN wilayah w on ambulance.id_wilayah = w."id_wilayah" 
        WHERE CAST(ambulance.status_ambulance as varchar) = param_status_ambulance
    ORDER BY no_plat asc;
   
            else 
            
 return query
    SELECT
           DISTINCT  ON(ambulance.no_plat) no_plat,
           id_ambulance,
           nama_ambulance,
           kilometer,
           ambulance.id_jenis_kendaraan,
           jk.jenis_kendaraan,
           ambulance.id_kategori_ambulance,
           ka.kategori_ambulance,
           ambulance.status_ambulance,
           ambulance.id_wilayah,
           w.wilayah,
           kondisi
	FROM "ambulance"
	    JOIN jenis_kendaraan jk on ambulance.id_jenis_kendaraan = jk.id_jenis_kendaraan
	    JOIN kategori_ambulance ka on ambulance.id_kategori_ambulance = ka.id_kategori_ambulance
    
        JOIN wilayah w on ambulance.id_wilayah = w."id_wilayah" 
    
    ORDER BY no_plat asc;
   
        end if;
    end if;
END
$$;


ALTER FUNCTION public.read_all_ambulance_search(param_search character varying, param_status_ambulance character varying) OWNER TO postgres;

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
-- Name: read_all_supir_filter(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.read_all_supir_filter(param_status_supir character varying) RETURNS TABLE(p_id_user character varying, p_username character varying, p_password character varying, p_id_user_level character varying, p_id_supir_detail character varying, p_nama character varying, p_nomor_hp character varying, p_foto_supir character varying, p_jenis_kelamin public.jenis_kelamin, p_nip character varying, p_status_supir public.status_supir, p_updated_at timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    if param_status_supir <> ''  then

 return query
    SELECT
           id_user,
           users.username,
           users.password,
           users.id_user_level,
           sd.id_supir_detail,
            sd.nama,
           sd.nomor_hp,
           sd.foto_supir,
           sd.jenis_kelamin,
           sd.nip,
           sd."status_supir ",
           lss.updated_at

	FROM "users"
	    JOIN supir_detail sd on "users".id_user = sd.id_supir_detail
        JOIN log_status_supir lss on sd.id_supir_detail = lss.id_supir_detail

    WHERE
          CAST(sd."status_supir " as varchar)   =  param_status_supir

    ORDER BY id_user asc;
    else
 return query
    SELECT
           id_user,
           users.username,
           users.password,
           users.id_user_level,
           sd.id_supir_detail,
            sd.nama,
           sd.nomor_hp,
           sd.foto_supir,
           sd.jenis_kelamin,
           sd.nip,
           sd."status_supir "

	FROM "users"
	    JOIN supir_detail sd on "users".id_user = sd.id_supir_detail
    ORDER BY id_user asc;

    end if;
END;
$$;


ALTER FUNCTION public.read_all_supir_filter(param_status_supir character varying) OWNER TO postgres;

--
-- Name: read_all_supir_search(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.read_all_supir_search(param_search character varying, param_status_supir character varying) RETURNS TABLE(p_id_user character varying, p_username character varying, p_password character varying, p_id_user_level character varying, p_id_supir_detail character varying, p_nama character varying, p_nomor_hp character varying, p_foto_supir character varying, p_jenis_kelamin public.jenis_kelamin, p_nip character varying, p_status_supir public.status_supir, p_updated_at timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    if param_search <> ''  then
        if param_status_supir <> '' then
            return query
         SELECT
           id_user,
           users.username,
           users.password,
           users.id_user_level,
           sd.id_supir_detail,
            sd.nama,
           sd.nomor_hp,
           sd.foto_supir,
           sd.jenis_kelamin,
           sd.nip,
           sd."status_supir ",
            lss.updated_at
	FROM "users"
	    JOIN supir_detail sd on "users".id_user = sd.id_supir_detail
        JOIN log_status_supir lss on sd.id_supir_detail = lss.id_supir_detail
         WHERE LOWER(sd.nama)  LIKE  CONCAT ('%',param_search,'%') OR
               LOWER(sd.nip)  LIKE  CONCAT ('%', param_search, '%') AND  
         CAST(sd."status_supir " as varchar)   =  param_status_supir
    ORDER BY id_user asc;
            else
             return query
         SELECT
           id_user,
           users.username,
           users.password,
           users.id_user_level,
           sd.id_supir_detail,
            sd.nama,
           sd.nomor_hp,
           sd.foto_supir,
           sd.jenis_kelamin,
           sd.nip,
           sd."status_supir ",
            lss.updated_at
	FROM "users"
	    JOIN supir_detail sd on "users".id_user = sd.id_supir_detail
        JOIN log_status_supir lss on sd.id_supir_detail = lss.id_supir_detail
         WHERE LOWER(sd.nama)  LIKE  CONCAT ('%',param_search,'%') OR
               LOWER(sd.nip)  LIKE  CONCAT ('%', param_search, '%') 
    ORDER BY id_user asc;
        end if;
    else
      if param_status_supir <> '' then
          return query
 SELECT
           id_user,
           users.username,
           users.password,
           users.id_user_level,
           sd.id_supir_detail,
            sd.nama,
           sd.nomor_hp,
           sd.foto_supir,
           sd.jenis_kelamin,
           sd.nip,
           sd."status_supir ",
            lss.updated_at
	FROM "users"
	    JOIN supir_detail sd on "users".id_user = sd.id_supir_detail
        JOIN log_status_supir lss on sd.id_supir_detail = lss.id_supir_detail
 AND  
         CAST(sd."status_supir " as varchar)   =  param_status_supir
    ORDER BY id_user asc;
          else
          return query
 SELECT
           id_user,
           users.username,
           users.password,
           users.id_user_level,
           sd.id_supir_detail,
            sd.nama,
           sd.nomor_hp,
           sd.foto_supir,
           sd.jenis_kelamin,
           sd.nip,
           sd."status_supir ",
            lss.updated_at
	FROM "users"
	    JOIN supir_detail sd on "users".id_user = sd.id_supir_detail
        JOIN log_status_supir lss on sd.id_supir_detail = lss.id_supir_detail
    ORDER BY id_user asc;
      end if;
 
    end if;
END;
$$;


ALTER FUNCTION public.read_all_supir_search(param_search character varying, param_status_supir character varying) OWNER TO postgres;

--
-- Name: read_all_transaksi(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.read_all_transaksi() RETURNS TABLE(p_id_transaksi character varying, p_nomor_invoice character varying, p_nomor_registrasi character varying, p_nomor_surat_tugas character varying, p_link_tracking text, p_alamat text, p_jarak numeric, p_latitude_tujuan character varying, p_longitude_tujuan character varying, p_tanggal_transaksi timestamp without time zone, p_foto_maps character varying, p_id_supir_detail character varying, p_id_supir_detail_2 character varying, p_id_status_transaksi character varying, p_id_ambulance character varying, p_no_plat character varying, p_id_jenis_kendaraan character varying, p_jenis_kendaraan character varying, p_id_kategori_kendaraan character varying, p_kategori_kendaraan character varying, p_id_wilayah character varying, p_id_user_nakes character varying, p_id_pasien_detail character varying, p_id_pembayaran character varying, p_tarif_pembayaran integer, p_tanggal_pembayaran timestamp without time zone, p_kode_tindakan character varying, p_id_status_pembayaran character varying, p_id_user_kasir character varying, p_metode_pembayaran public.metode_pembayaran, p_nama_lengkap character varying, p_jenis_kelamin public.jenis_kelamin, p_nama_ruangan_medik character varying, p_nomor_rekam_medik character varying, p_nomor_kamar character varying, p_golongan_pasien public.golongan_pasien, p_nomor_telepon character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
    SELECT transaksi.id_transaksi,
           transaksi.nomor_invoice,
           transaksi.nomor_registrasi,
           transaksi.nomor_surat_tugas,
           transaksi.link_tracking,
           transaksi.alamat,
           transaksi.jarak,
           transaksi.latitude_tujuan,
           transaksi.longitude_tujuan,
           transaksi.tanggal_transaksi,
           transaksi.foto_maps,
           transaksi.id_supir_detail,
           transaksi.id_supir_detail_2,
           transaksi.id_status_transaksi,
           transaksi.id_ambulance,
           ambulance.no_plat,
           jk.id_jenis_kendaraan,
           jk.jenis_kendaraan,
           ka.id_kategori_ambulance,
           ka.kategori_ambulance,
           transaksi.id_wilayah,
           transaksi.id_user_nakes,
           transaksi.id_pasien_detail,
           transaksi.id_pembayaran,
           p.tarif,
           p.tanggal_pembayaran,
           p.kode_tindakan,
           p.id_status_pembayaran,
           p.id_user_kasir,
           p.metode_pembayaran,
           pd.nama_lengkap,
           pd.jenis_kelamin,
           pd.nama_ruangan_medik,
           pd.nomor_rekam_medik,
           pd.nomor_kamar,
           pd.golongan_pasien,
           pd.nomor_telepon


    FROM transaksi
         JOIN pembayaran p on transaksi.id_pembayaran = p.id_pembayaran
        JOIN pasien_detail pd on transaksi.id_pasien_detail = pd.id_pasien_detail
        JOIN status_transaksi sk on transaksi.id_status_transaksi = sk.id_status_transaksi
        JOIN supir_detail on transaksi.id_supir_detail = supir_detail.id_supir_detail
        JOIN ambulance on transaksi.id_ambulance = ambulance.id_ambulance
        JOIN jenis_kendaraan jk on ambulance.id_jenis_kendaraan = jk.id_jenis_kendaraan
        JOIN kategori_ambulance ka on ambulance.id_kategori_ambulance = ka.id_kategori_ambulance
        JOIN wilayah on transaksi.id_wilayah = wilayah."id_wilayah"
        JOIN users on transaksi.id_user_nakes = users.id_user
        JOIN supir_detail s  on transaksi.id_supir_detail_2 = s.id_supir_detail;
END;
$$;


ALTER FUNCTION public.read_all_transaksi() OWNER TO postgres;

--
-- Name: read_all_transaksi_by_id(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.read_all_transaksi_by_id(param_id_transaksi character varying) RETURNS TABLE(p_id_transaksi character varying, p_nomor_invoice character varying, p_nomor_registrasi character varying, p_nomor_surat_tugas character varying, p_link_tracking text, p_alamat text, p_jarak numeric, p_latitude_tujuan character varying, p_longitude_tujuan character varying, p_tanggal_transaksi timestamp without time zone, p_foto_maps character varying, p_id_supir_detail character varying, p_nama_supir_1 character varying, p_id_supir_detail_2 character varying, p_nama_supir_2 character varying, p_id_status_transaksi character varying, p_id_ambulance character varying, p_no_plat character varying, p_jenis_kendaraan character varying, p_kategori_ambulance character varying, p_id_wilayah character varying, p_id_user_nakes character varying, p_id_pasien_detail character varying, p_id_pembayaran character varying, p_tarif_pembayaran integer, p_tanggal_pembayaran timestamp without time zone, p_kode_tindakan character varying, p_id_status_pembayaran character varying, p_id_user_kasir character varying, p_metode_pembayaran public.metode_pembayaran, p_nama_lengkap character varying, p_jenis_kelamin public.jenis_kelamin, p_nama_ruangan_medik character varying, p_nomor_rekam_medik character varying, p_nomor_kamar character varying, p_golongan_pasien public.golongan_pasien, p_nomor_telepon character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
    SELECT transaksi.id_transaksi,
           transaksi.nomor_invoice,
           transaksi.nomor_registrasi,
           transaksi.nomor_surat_tugas,
           transaksi.link_tracking,
           transaksi.alamat,
           transaksi.jarak,
           transaksi.latitude_tujuan,
           transaksi.longitude_tujuan,
           transaksi.tanggal_transaksi,
           transaksi.foto_maps,
           transaksi.id_supir_detail,
           supir_detail.nama,
           transaksi.id_supir_detail_2,
           sd.nama,
           transaksi.id_status_transaksi,
           transaksi.id_ambulance,
           ambulance.no_plat,
           jk.id_jenis_kendaraan,
           ka.kategori_ambulance,
           transaksi.id_wilayah,
           transaksi.id_user_nakes,
           transaksi.id_pasien_detail,
           transaksi.id_pembayaran,
           p.tarif,
           p.tanggal_pembayaran,
           p.kode_tindakan,
           p.id_status_pembayaran,
           p.id_user_kasir,
           p.metode_pembayaran,
           pd.nama_lengkap,
           pd.jenis_kelamin,
           pd.nama_ruangan_medik,
           pd.nomor_rekam_medik,
           pd.nomor_kamar,
           pd.golongan_pasien,
           pd.nomor_telepon


    FROM transaksi
         JOIN pembayaran p on transaksi.id_pembayaran = p.id_pembayaran
        JOIN pasien_detail pd on transaksi.id_pasien_detail = pd.id_pasien_detail
        JOIN status_transaksi sk on transaksi.id_status_transaksi = sk.id_status_transaksi
        JOIN supir_detail on transaksi.id_supir_detail = supir_detail.id_supir_detail
        LEFT JOIN supir_detail sd on transaksi.id_supir_detail_2 = sd.id_supir_detail
        JOIN ambulance on transaksi.id_ambulance = ambulance.id_ambulance
        JOIN jenis_kendaraan jk on ambulance.id_jenis_kendaraan = jk.id_jenis_kendaraan
        JOIN kategori_ambulance ka on transaksi.id_kategori_ambulance = ka.id_kategori_ambulance
        JOIN wilayah on transaksi.id_wilayah = wilayah."id_wilayah"
        JOIN users on transaksi.id_user_nakes = users.id_user
    WHERE transaksi.id_transaksi = param_id_transaksi;
END;
$$;


ALTER FUNCTION public.read_all_transaksi_by_id(param_id_transaksi character varying) OWNER TO postgres;

--
-- Name: read_all_transaksi_by_no_plat(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.read_all_transaksi_by_no_plat(param_no_plat character varying) RETURNS TABLE(p_id_transaksi character varying, p_nomor_invoice character varying, p_nomor_registrasi character varying, p_nomor_surat_tugas character varying, p_link_tracking text, p_alamat text, p_jarak numeric, p_latitude_tujuan character varying, p_longitude_tujuan character varying, p_tanggal_transaksi timestamp without time zone, p_foto_maps character varying, p_id_supir_detail character varying, p_id_supir_detail_2 character varying, nama_supir_1 character varying, nama_supir_2 character varying, p_id_status_transaksi character varying, p_id_ambulance character varying, p_no_plat character varying, p_id_jenis_kendaraan character varying, p_jenis_kendaraan character varying, p_id_kategori_kendaraan character varying, p_kategori_kendaraan character varying, p_id_wilayah character varying, p_id_user_nakes character varying, p_id_pasien_detail character varying, p_id_pembayaran character varying, p_tarif_pembayaran integer, p_tanggal_pembayaran timestamp without time zone, p_kode_tindakan character varying, p_id_status_pembayaran character varying, p_id_user_kasir character varying, p_metode_pembayaran public.metode_pembayaran, p_nama_lengkap character varying, p_jenis_kelamin public.jenis_kelamin, p_nama_ruangan_medik character varying, p_nomor_rekam_medik character varying, p_nomor_kamar character varying, p_golongan_pasien public.golongan_pasien, p_nomor_telepon character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
    SELECT transaksi.id_transaksi,
           transaksi.nomor_invoice,
           transaksi.nomor_registrasi,
           transaksi.nomor_surat_tugas,
           transaksi.link_tracking,
           transaksi.alamat,
           transaksi.jarak,
           transaksi.latitude_tujuan,
           transaksi.longitude_tujuan,
           transaksi.tanggal_transaksi,
           transaksi.foto_maps,
           transaksi.id_supir_detail,
           transaksi.id_supir_detail_2,
            supir_detail.nama,
           s.nama,
           transaksi.id_status_transaksi,
           transaksi.id_ambulance,
           ambulance.no_plat,
           jk.id_jenis_kendaraan,
           jk.jenis_kendaraan,
           ka.id_kategori_ambulance,
           ka.kategori_ambulance,
           transaksi.id_wilayah,
           transaksi.id_user_nakes,
           transaksi.id_pasien_detail,
           transaksi.id_pembayaran,
           p.tarif,
           p.tanggal_pembayaran,
           p.kode_tindakan,
           p.id_status_pembayaran,
           p.id_user_kasir,
           p.metode_pembayaran,
           pd.nama_lengkap,
           pd.jenis_kelamin,
           pd.nama_ruangan_medik,
           pd.nomor_rekam_medik,
           pd.nomor_kamar,
           pd.golongan_pasien,
           pd.nomor_telepon


    FROM transaksi
         JOIN pembayaran p on transaksi.id_pembayaran = p.id_pembayaran
        JOIN pasien_detail pd on transaksi.id_pasien_detail = pd.id_pasien_detail
        JOIN status_transaksi sk on transaksi.id_status_transaksi = sk.id_status_transaksi
        JOIN supir_detail on transaksi.id_supir_detail = supir_detail.id_supir_detail
        JOIN ambulance on transaksi.id_ambulance = ambulance.id_ambulance
        JOIN jenis_kendaraan jk on ambulance.id_jenis_kendaraan = jk.id_jenis_kendaraan
        JOIN kategori_ambulance ka on ambulance.id_kategori_ambulance = ka.id_kategori_ambulance
        JOIN wilayah on transaksi.id_wilayah = wilayah."id_wilayah"
        JOIN users on transaksi.id_user_nakes = users.id_user
        LEFT JOIN supir_detail s  on transaksi.id_supir_detail_2 = s.id_supir_detail
    WHERE ambulance.no_plat = param_no_plat AND transaksi.id_status_transaksi = 'e17b741e-46a8-1712-cdb6-1c010a473697';
END;
$$;


ALTER FUNCTION public.read_all_transaksi_by_no_plat(param_no_plat character varying) OWNER TO postgres;

--
-- Name: read_all_transaksi_by_no_plat_filter_date(timestamp without time zone, timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.read_all_transaksi_by_no_plat_filter_date(param_no_plat timestamp without time zone, param_from_date timestamp without time zone, param_to_date timestamp without time zone) RETURNS TABLE(p_id_transaksi character varying, p_nomor_invoice character varying, p_nomor_registrasi character varying, p_nomor_surat_tugas character varying, p_link_tracking text, p_alamat text, p_jarak integer, p_latitude_tujuan character varying, p_longitude_tujuan character varying, p_tanggal_transaksi timestamp without time zone, p_foto_maps character varying, p_id_supir_detail character varying, p_id_supir_detail_2 character varying, p_tarif_supir integer, p_id_status_transaksi character varying, p_id_ambulance character varying, p_no_plat character varying, p_id_jenis_kendaraan character varying, p_jenis_kendaraan character varying, p_id_kategori_kendaraan character varying, p_kategori_kendaraan character varying, p_id_wilayah character varying, p_id_user_nakes character varying, p_id_pasien_detail character varying, p_id_pembayaran character varying, p_id_tarif_supir character varying, p_tarif_pembayaran integer, p_tanggal_pembayaran timestamp without time zone, p_kode_tindakan character varying, p_id_status_pembayaran character varying, p_id_user_kasir character varying, p_metode_pembayaran public.metode_pembayaran, p_nama_lengkap character varying, p_jenis_kelamin public.jenis_kelamin, p_nama_ruangan_medik character varying, p_nomor_rekam_medik character varying, p_nomor_kamar character varying, p_golongan_pasien public.golongan_pasien, p_nomor_telepon character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
    SELECT transaksi.id_transaksi,
           transaksi.nomor_invoice,
           transaksi.nomor_registrasi,
           transaksi.nomor_surat_tugas,
           transaksi.link_tracking,
           transaksi.alamat,
           transaksi.jarak,
           transaksi.latitude_tujuan,
           transaksi.longitude_tujuan,
           transaksi.tanggal_transaksi,
           transaksi.foto_maps,
           transaksi.id_supir_detail,
           transaksi.id_supir_detail_2,
           ts.tarif,
           transaksi.id_status_transaksi,
           transaksi.id_ambulance,
           ambulance.no_plat,
           jk.id_jenis_kendaraan,
           jk.jenis_kendaraan,
           ka.id_kategori_ambulance,
           ka.kategori_ambulance,
           transaksi.id_wilayah,
           transaksi.id_user_nakes,
           transaksi.id_pasien_detail,
           transaksi.id_pembayaran,
           transaksi.id_tarif_supir,
           p.tarif,
           p.tanggal_pembayaran,
           p.kode_tindakan,
           p.id_status_pembayaran,
           p.id_user_kasir,
           p.metode_pembayaran,
           pd.nama_lengkap,
           pd.jenis_kelamin,
           pd.nama_ruangan_medik,
           pd.nomor_rekam_medik,
           pd.nomor_kamar,
           pd.golongan_pasien,
           pd.nomor_telepon


    FROM transaksi
         JOIN pembayaran p on transaksi.id_pembayaran = p.id_pembayaran
        JOIN pasien_detail pd on transaksi.id_pasien_detail = pd.id_pasien_detail
        JOIN status_transaksi sk on transaksi.id_status_transaksi = sk.id_status_transaksi
        JOIN supir_detail on transaksi.id_supir_detail = supir_detail.id_supir_detail
        JOIN ambulance on transaksi.id_ambulance = ambulance.id_ambulance
        JOIN jenis_kendaraan jk on ambulance.id_jenis_kendaraan = jk.id_jenis_kendaraan
        JOIN kategori_ambulance ka on ambulance.id_kategori_ambulance = ka.id_kategori_ambulance
        JOIN wilayah on transaksi.id_wilayah = wilayah."id_wilayah "
        JOIN users on transaksi.id_user_nakes = users.id_user
        JOIN supir_detail s  on transaksi.id_supir_detail_2 = s.id_supir_detail
        JOIN tarif_supir ts on transaksi.id_tarif_supir = ts.id_tarif_supir
    WHERE "ambulance".no_plat = param_no_plat AND transaksi.tanggal_transaksi BETWEEN param_from_date AND param_to_date;
END;
$$;


ALTER FUNCTION public.read_all_transaksi_by_no_plat_filter_date(param_no_plat timestamp without time zone, param_from_date timestamp without time zone, param_to_date timestamp without time zone) OWNER TO postgres;

--
-- Name: read_all_transaksi_by_status_transaksi(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.read_all_transaksi_by_status_transaksi(param_status_transaksi_1 character varying, param_status_transaksi_2 character varying, param_status_transaksi_3 character varying) RETURNS TABLE(p_id_transaksi character varying, p_nomor_invoice character varying, p_nomor_registrasi character varying, p_nomor_surat_tugas character varying, p_link_tracking text, p_alamat text, p_jarak numeric, p_latitude_tujuan character varying, p_longitude_tujuan character varying, p_tanggal_transaksi timestamp without time zone, p_foto_maps character varying, p_id_supir_detail character varying, p_id_supir_detail_2 character varying, p_id_status_transaksi character varying, p_id_ambulance character varying, p_kategori_ambulance character varying, p_jenis_kendaraan character varying, p_id_wilayah character varying, p_id_user_nakes character varying, p_id_pasien_detail character varying, p_id_pembayaran character varying, p_tarif_pembayaran integer, p_tanggal_pembayaran timestamp without time zone, p_kode_tindakan character varying, p_id_status_pembayaran character varying, p_id_user_kasir character varying, p_metode_pembayaran public.metode_pembayaran, p_nama_lengkap character varying, p_jenis_kelamin public.jenis_kelamin, p_nama_ruangan_medik character varying, p_nomor_rekam_medik character varying, p_nomor_kamar character varying, p_golongan_pasien public.golongan_pasien, p_nomor_telepon character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
    SELECT transaksi.id_transaksi,
           transaksi.nomor_invoice,
           transaksi.nomor_registrasi,
           transaksi.nomor_surat_tugas,
           transaksi.link_tracking,
           transaksi.alamat,
           transaksi.jarak,
           transaksi.latitude_tujuan,
           transaksi.longitude_tujuan,
           transaksi.tanggal_transaksi,
           transaksi.foto_maps,
           transaksi.id_supir_detail,
           transaksi.id_supir_detail_2,
           transaksi.id_status_transaksi,
           transaksi.id_ambulance,
           ka.kategori_ambulance,
           jk.id_jenis_kendaraan,
           transaksi.id_wilayah,
           transaksi.id_user_nakes,
           transaksi.id_pasien_detail,
           transaksi.id_pembayaran,
           p.tarif,
           p.tanggal_pembayaran,
           p.kode_tindakan,
           p.id_status_pembayaran,
           p.id_user_kasir,
           p.metode_pembayaran,
           pd.nama_lengkap,
           pd.jenis_kelamin,
           pd.nama_ruangan_medik,
           pd.nomor_rekam_medik,
           pd.nomor_kamar,
           pd.golongan_pasien,
           pd.nomor_telepon


    FROM transaksi
         JOIN pembayaran p on transaksi.id_pembayaran = p.id_pembayaran
        JOIN pasien_detail pd on transaksi.id_pasien_detail = pd.id_pasien_detail
        JOIN status_transaksi sk on transaksi.id_status_transaksi = sk.id_status_transaksi
        JOIN supir_detail on transaksi.id_supir_detail = supir_detail.id_supir_detail
        JOIN ambulance on transaksi.id_ambulance = ambulance.id_ambulance
        JOIN kategori_ambulance ka on transaksi.id_kategori_ambulance = ka.id_kategori_ambulance
        JOIN jenis_kendaraan jk on ambulance.id_jenis_kendaraan = jk.id_jenis_kendaraan
        JOIN wilayah on transaksi.id_wilayah = wilayah."id_wilayah"
        JOIN users on transaksi.id_user_nakes = users.id_user
    WHERE transaksi.id_status_transaksi = param_status_transaksi_1 OR transaksi.id_status_transaksi = param_status_transaksi_2 OR transaksi.id_status_transaksi = param_status_transaksi_3
    ORDER BY transaksi.tanggal_transaksi DESC;
END;
$$;


ALTER FUNCTION public.read_all_transaksi_by_status_transaksi(param_status_transaksi_1 character varying, param_status_transaksi_2 character varying, param_status_transaksi_3 character varying) OWNER TO postgres;

--
-- Name: read_all_transaksi_filter_by_status_transaksi(timestamp without time zone, timestamp without time zone, character varying, public.golongan_pasien, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.read_all_transaksi_filter_by_status_transaksi(param_from_date timestamp without time zone, param_to_date timestamp without time zone, param_status_transaksi character varying, param_golongan_pasien public.golongan_pasien, param_id_kategori_ambulance character varying) RETURNS TABLE(p_id_transaksi character varying, p_nomor_invoice character varying, p_nomor_registrasi character varying, p_nomor_surat_tugas character varying, p_link_tracking text, p_alamat text, p_jarak integer, p_latitude_tujuan character varying, p_longitude_tujuan character varying, p_tanggal_transaksi timestamp without time zone, p_foto_maps character varying, p_id_supir_detail character varying, p_id_supir_detail_2 character varying, p_tarif_supir integer, p_id_status_transaksi character varying, p_id_ambulance character varying, p_no_plat character varying, p_id_jenis_kendaraan character varying, p_jenis_kendaraan character varying, p_id_kategori_kendaraan character varying, p_kategori_kendaraan character varying, p_id_wilayah character varying, p_id_user_nakes character varying, p_id_pasien_detail character varying, p_id_pembayaran character varying, p_id_tarif_supir character varying, p_tarif_pembayaran integer, p_tanggal_pembayaran timestamp without time zone, p_kode_tindakan character varying, p_id_status_pembayaran character varying, p_id_user_kasir character varying, p_metode_pembayaran public.metode_pembayaran, p_nama_lengkap character varying, p_jenis_kelamin public.jenis_kelamin, p_nama_ruangan_medik character varying, p_nomor_rekam_medik character varying, p_nomor_kamar character varying, p_golongan_pasien public.golongan_pasien, p_nomor_telepon character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
    SELECT transaksi.id_transaksi,
           transaksi.nomor_invoice,
           transaksi.nomor_registrasi,
           transaksi.nomor_surat_tugas,
           transaksi.link_tracking,
           transaksi.alamat,
           transaksi.jarak,
           transaksi.latitude_tujuan,
           transaksi.longitude_tujuan,
           transaksi.tanggal_transaksi,
           transaksi.foto_maps,
           transaksi.id_supir_detail,
           transaksi.id_supir_detail_2,
           ts.tarif,
           transaksi.id_status_transaksi,
           transaksi.id_ambulance,
           ambulance.no_plat,
           jk.id_jenis_kendaraan,
           jk.jenis_kendaraan,
           ka.id_kategori_ambulance,
           ka.kategori_ambulance,
           transaksi.id_wilayah,
           transaksi.id_user_nakes,
           transaksi.id_pasien_detail,
           transaksi.id_pembayaran,
           transaksi.id_tarif_supir,
           p.tarif,
           p.tanggal_pembayaran,
           p.kode_tindakan,
           p.id_status_pembayaran,
           p.id_user_kasir,
           p.metode_pembayaran,
           pd.nama_lengkap,
           pd.jenis_kelamin,
           pd.nama_ruangan_medik,
           pd.nomor_rekam_medik,
           pd.nomor_kamar,
           pd.golongan_pasien,
           pd.nomor_telepon


    FROM transaksi
         JOIN pembayaran p on transaksi.id_pembayaran = p.id_pembayaran
        JOIN pasien_detail pd on transaksi.id_pasien_detail = pd.id_pasien_detail
        JOIN status_transaksi sk on transaksi.id_status_transaksi = sk.id_status_transaksi
        JOIN supir_detail on transaksi.id_supir_detail = supir_detail.id_supir_detail
        JOIN ambulance on transaksi.id_ambulance = ambulance.id_ambulance
        JOIN jenis_kendaraan jk on ambulance.id_jenis_kendaraan = jk.id_jenis_kendaraan
        JOIN kategori_ambulance ka on ambulance.id_kategori_ambulance = ka.id_kategori_ambulance
        JOIN wilayah w on transaksi.id_wilayah = w.id_wilayah
        JOIN users on transaksi.id_user_nakes = users.id_user
        JOIN supir_detail s  on transaksi.id_supir_detail_2 = s.id_supir_detail
        JOIN tarif_supir ts on transaksi.id_tarif_supir = ts.id_tarif_supir

    WHERE transaksi.tanggal_transaksi BETWEEN param_from_date  AND param_to_date
       AND  (transaksi.id_status_transaksi =  param_status_transaksi OR transaksi.id_status_transaksi = '')
      AND  (CAST(pd.golongan_pasien as golongan_pasien) =  param_golongan_pasien OR pd.golongan_pasien = 'PBI') 
       AND ( ambulance.id_kategori_ambulance =  param_id_kategori_ambulance OR  ambulance.id_kategori_ambulance = '') ;
END;
$$;


ALTER FUNCTION public.read_all_transaksi_filter_by_status_transaksi(param_from_date timestamp without time zone, param_to_date timestamp without time zone, param_status_transaksi character varying, param_golongan_pasien public.golongan_pasien, param_id_kategori_ambulance character varying) OWNER TO postgres;

--
-- Name: read_all_transaksi_supir_1_by_id_and_status_transaksi(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.read_all_transaksi_supir_1_by_id_and_status_transaksi(param_id_supir character varying, param_status_transaksi character varying) RETURNS TABLE(p_id_transaksi character varying, p_nomor_invoice character varying, p_nomor_registrasi character varying, p_nomor_surat_tugas character varying, p_link_tracking text, p_alamat text, p_jarak integer, p_latitude_tujuan character varying, p_longitude_tujuan character varying, p_tanggal_transaksi timestamp without time zone, p_foto_maps character varying, p_id_supir_detail character varying, p_id_supir_detail_2 character varying, p_tarif_supir integer, p_id_status_transaksi character varying, p_id_ambulance character varying, p_jenis_kendaraan character varying, p_id_wilayah character varying, p_id_user_nakes character varying, p_id_pasien_detail character varying, p_id_pembayaran character varying, p_id_tarif_supir character varying, p_tarif_pembayaran integer, p_tanggal_pembayaran timestamp without time zone, p_kode_tindakan character varying, p_id_status_pembayaran character varying, p_id_user_kasir character varying, p_metode_pembayaran public.metode_pembayaran, p_nama_lengkap character varying, p_jenis_kelamin public.jenis_kelamin, p_nama_ruangan_medik character varying, p_nomor_rekam_medik character varying, p_nomor_kamar character varying, p_golongan_pasien public.golongan_pasien, p_nomor_telepon character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
    SELECT transaksi.id_transaksi,
           transaksi.nomor_invoice,
           transaksi.nomor_registrasi,
           transaksi.nomor_surat_tugas,
           transaksi.link_tracking,
           transaksi.alamat,
           transaksi.jarak,
           transaksi.latitude_tujuan,
           transaksi.longitude_tujuan,
           transaksi.tanggal_transaksi,
           transaksi.foto_maps,
           transaksi.id_supir_detail,
           transaksi.id_supir_detail_2,
           ts.tarif,
           transaksi.id_status_transaksi,
           transaksi.id_ambulance,
           jk.id_jenis_kendaraan,
           transaksi.id_wilayah,
           transaksi.id_user_nakes,
           transaksi.id_pasien_detail,
           transaksi.id_pembayaran,
           transaksi.id_tarif_supir,
           p.tarif,
           p.tanggal_pembayaran,
           p.kode_tindakan,
           p.id_status_pembayaran,
           p.id_user_kasir,
           p.metode_pembayaran,
           pd.nama_lengkap,
           pd.jenis_kelamin,
           pd.nama_ruangan_medik,
           pd.nomor_rekam_medik,
           pd.nomor_kamar,
           pd.golongan_pasien,
           pd.nomor_telepon


    FROM transaksi
         JOIN pembayaran p on transaksi.id_pembayaran = p.id_pembayaran
        JOIN pasien_detail pd on transaksi.id_pasien_detail = pd.id_pasien_detail
        JOIN status_transaksi sk on transaksi.id_status_transaksi = sk.id_status_transaksi
        JOIN supir_detail on transaksi.id_supir_detail = supir_detail.id_supir_detail
        JOIN ambulance on transaksi.id_ambulance = ambulance.id_ambulance
        JOIN jenis_kendaraan jk on ambulance.id_jenis_kendaraan = jk.id_jenis_kendaraan
        JOIN wilayah on transaksi.id_wilayah = wilayah."id_wilayah "
        JOIN users on transaksi.id_user_nakes = users.id_user
        JOIN supir_detail s  on transaksi.id_supir_detail_2 = s.id_supir_detail
        JOIN tarif_supir ts on transaksi.id_tarif_supir = ts.id_tarif_supir
    WHERE transaksi.id_supir_detail = param_id_supir AND transaksi.id_status_transaksi = param_status_transaksi;
END;
$$;


ALTER FUNCTION public.read_all_transaksi_supir_1_by_id_and_status_transaksi(param_id_supir character varying, param_status_transaksi character varying) OWNER TO postgres;

--
-- Name: read_all_transaksi_supir_2_by_id_and_status_transaksi(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.read_all_transaksi_supir_2_by_id_and_status_transaksi(param_id_supir character varying, param_status_transaksi character varying) RETURNS TABLE(p_id_transaksi character varying, p_nomor_invoice character varying, p_nomor_registrasi character varying, p_nomor_surat_tugas character varying, p_link_tracking text, p_alamat text, p_jarak integer, p_latitude_tujuan character varying, p_longitude_tujuan character varying, p_tanggal_transaksi timestamp without time zone, p_foto_maps character varying, p_id_supir_detail character varying, p_id_supir_detail_2 character varying, p_tarif_supir integer, p_id_status_transaksi character varying, p_id_ambulance character varying, p_jenis_kendaraan character varying, p_id_wilayah character varying, p_id_user_nakes character varying, p_id_pasien_detail character varying, p_id_pembayaran character varying, p_id_tarif_supir character varying, p_tarif_pembayaran integer, p_tanggal_pembayaran timestamp without time zone, p_kode_tindakan character varying, p_id_status_pembayaran character varying, p_id_user_kasir character varying, p_metode_pembayaran public.metode_pembayaran, p_nama_lengkap character varying, p_jenis_kelamin public.jenis_kelamin, p_nama_ruangan_medik character varying, p_nomor_rekam_medik character varying, p_nomor_kamar character varying, p_golongan_pasien public.golongan_pasien, p_nomor_telepon character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
    SELECT transaksi.id_transaksi,
           transaksi.nomor_invoice,
           transaksi.nomor_registrasi,
           transaksi.nomor_surat_tugas,
           transaksi.link_tracking,
           transaksi.alamat,
           transaksi.jarak,
           transaksi.latitude_tujuan,
           transaksi.longitude_tujuan,
           transaksi.tanggal_transaksi,
           transaksi.foto_maps,
           transaksi.id_supir_detail,
           transaksi.id_supir_detail_2,
           ts.tarif,
           transaksi.id_status_transaksi,
           transaksi.id_ambulance,
           jk.id_jenis_kendaraan,
           transaksi.id_wilayah,
           transaksi.id_user_nakes,
           transaksi.id_pasien_detail,
           transaksi.id_pembayaran,
           transaksi.id_tarif_supir,
           p.tarif,
           p.tanggal_pembayaran,
           p.kode_tindakan,
           p.id_status_pembayaran,
           p.id_user_kasir,
           p.metode_pembayaran,
           pd.nama_lengkap,
           pd.jenis_kelamin,
           pd.nama_ruangan_medik,
           pd.nomor_rekam_medik,
           pd.nomor_kamar,
           pd.golongan_pasien,
           pd.nomor_telepon


    FROM transaksi
         JOIN pembayaran p on transaksi.id_pembayaran = p.id_pembayaran
        JOIN pasien_detail pd on transaksi.id_pasien_detail = pd.id_pasien_detail
        JOIN status_transaksi sk on transaksi.id_status_transaksi = sk.id_status_transaksi
        JOIN supir_detail on transaksi.id_supir_detail = supir_detail.id_supir_detail
        JOIN ambulance on transaksi.id_ambulance = ambulance.id_ambulance
        JOIN jenis_kendaraan jk on ambulance.id_jenis_kendaraan = jk.id_jenis_kendaraan
        JOIN wilayah on transaksi.id_wilayah = wilayah."id_wilayah "
        JOIN users on transaksi.id_user_nakes = users.id_user
        JOIN supir_detail s  on transaksi.id_supir_detail_2 = s.id_supir_detail
        JOIN tarif_supir ts on transaksi.id_tarif_supir = ts.id_tarif_supir
    WHERE transaksi.id_supir_detail_2 = param_id_supir AND transaksi.id_status_transaksi = param_status_transaksi;
END;
$$;


ALTER FUNCTION public.read_all_transaksi_supir_2_by_id_and_status_transaksi(param_id_supir character varying, param_status_transaksi character varying) OWNER TO postgres;

--
-- Name: read_all_transaksi_supir_by_id_and_status_transaksi(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.read_all_transaksi_supir_by_id_and_status_transaksi(param_id_supir character varying, param_status_transaksi character varying) RETURNS TABLE(p_id_transaksi character varying, p_nomor_invoice character varying, p_nomor_registrasi character varying, p_nomor_surat_tugas character varying, p_link_tracking text, p_alamat text, p_jarak numeric, p_latitude_tujuan character varying, p_longitude_tujuan character varying, p_tanggal_transaksi timestamp without time zone, p_foto_maps character varying, p_id_supir_detail character varying, p_id_supir_detail_2 character varying, p_id_status_transaksi character varying, p_id_ambulance character varying, p_id_wilayah character varying, p_id_user_nakes character varying, p_id_pasien_detail character varying, p_id_pembayaran character varying, p_tarif_pembayaran integer, p_nama_lengkap character varying, p_jenis_kelamin public.jenis_kelamin, p_nama_ruangan_medik character varying, p_nomor_rekam_medik character varying, p_nomor_kamar character varying, p_golongan_pasien public.golongan_pasien, p_nomor_telepon character varying, p_tarif_supir integer, p_nama_supir character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
    SELECT transaksi.id_transaksi,
           transaksi.nomor_invoice,
           transaksi.nomor_registrasi,
           transaksi.nomor_surat_tugas,
           transaksi.link_tracking,
           transaksi.alamat,
           transaksi.jarak,
           transaksi.latitude_tujuan,
           transaksi.longitude_tujuan,
           transaksi.tanggal_transaksi,
           transaksi.foto_maps,
           transaksi.id_supir_detail,
           transaksi.id_supir_detail_2,
           transaksi.id_status_transaksi,
           transaksi.id_ambulance,
           transaksi.id_wilayah,
           transaksi.id_user_nakes,
           transaksi.id_pasien_detail,
           transaksi.id_pembayaran,
           p.tarif,
           pd.nama_lengkap,
           pd.jenis_kelamin,
           pd.nama_ruangan_medik,
           pd.nomor_rekam_medik,
           pd.nomor_kamar,
           pd.golongan_pasien,
           pd.nomor_telepon,
           ts.tarif,
           sd.nama


    FROM transaksi
        JOIN pasien_detail pd on transaksi.id_pasien_detail = pd.id_pasien_detail
        JOIN tarif_supir ts on transaksi.id_transaksi = ts.id_transaksi
        JOIN supir_detail sd on sd.id_supir_detail = ts.id_supir_detail
        JOIN pembayaran p on transaksi.id_pembayaran = p.id_pembayaran
    WHERE ts.id_supir_detail = param_id_supir AND transaksi.id_status_transaksi = param_status_transaksi;
END;
$$;


ALTER FUNCTION public.read_all_transaksi_supir_by_id_and_status_transaksi(param_id_supir character varying, param_status_transaksi character varying) OWNER TO postgres;

--
-- Name: read_all_user_supir(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.read_all_user_supir() RETURNS TABLE(p_id_user character varying, p_username character varying, p_password character varying, p_id_user_level character varying, p_id_supir_detail character varying, p_nama character varying, p_nomor_hp character varying, p_foto_supir character varying, p_jenis_kelamin public.jenis_kelamin, p_nip character varying, p_status_supir public.status_supir, p_updated_at timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
    SELECT
           id_user,
           users.username,
           users.password,
           users.id_user_level,
           sd.id_supir_detail,
            sd.nama,
           sd.nomor_hp,
           sd.foto_supir,
           sd.jenis_kelamin,
           sd.nip,
           sd."status_supir ",
            lss.updated_at

	FROM "users"
	    JOIN supir_detail sd on "users".id_user = sd.id_supir_detail
        JOIN log_status_supir lss on sd.id_supir_detail = lss.id_supir_detail
    ORDER BY id_user asc;
END;
$$;


ALTER FUNCTION public.read_all_user_supir() OWNER TO postgres;

--
-- Name: read_all_user_supir_by_id(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.read_all_user_supir_by_id(param_id_user_supir character varying) RETURNS TABLE(p_id_user character varying, p_username character varying, p_password character varying, p_id_user_level character varying, p_id_supir_detail character varying, p_nama character varying, p_nomor_hp character varying, p_foto_supir character varying, p_jenis_kelamin public.jenis_kelamin, p_nip character varying, p_status_supir public.status_supir, p_updated_at timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
    SELECT
           id_user,
           users.username,
           users.password,
           users.id_user_level,
           sd.id_supir_detail,
            sd.nama,
           sd.nomor_hp,
           sd.foto_supir,
           sd.jenis_kelamin,
           sd.nip,
           sd."status_supir ",
            lss.updated_at

	FROM "users"
	    JOIN supir_detail sd on "users".id_user = sd.id_supir_detail
        JOIN log_status_supir lss on sd.id_supir_detail = lss.id_supir_detail
    WHERE users.id_user = param_id_user_supir
    ORDER BY id_user asc;
END;
$$;


ALTER FUNCTION public.read_all_user_supir_by_id(param_id_user_supir character varying) OWNER TO postgres;

--
-- Name: read_all_user_supir_rekomendasi(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.read_all_user_supir_rekomendasi() RETURNS TABLE(p_id_user character varying, p_username character varying, p_password character varying, p_id_user_level character varying, p_id_supir_detail character varying, p_nama character varying, p_nomor_hp character varying, p_foto_supir character varying, p_jenis_kelamin public.jenis_kelamin, p_nip character varying, p_status_supir public.status_supir, p_updated_at timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
    SELECT
           id_user,
           users.username,
           users.password,
           users.id_user_level,
           sd.id_supir_detail,
            sd.nama,
           sd.nomor_hp,
           sd.foto_supir,
           sd.jenis_kelamin,
           sd.nip,
           sd."status_supir ",
            lss.updated_at

	FROM "users"
	    JOIN supir_detail sd on "users".id_user = sd.id_supir_detail
        JOIN log_status_supir lss on sd.id_supir_detail = lss.id_supir_detail
    WHERE sd."status_supir " = 'R'
    ORDER BY lss.updated_at asc;
END;
$$;


ALTER FUNCTION public.read_all_user_supir_rekomendasi() OWNER TO postgres;

--
-- Name: read_all_wilayah(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.read_all_wilayah() RETURNS TABLE(p_id_wilayah character varying, p_wilayah character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
    SELECT id_wilayah, wilayah.wilayah
	FROM "wilayah"
    ORDER BY id_wilayah asc;
END;
$$;


ALTER FUNCTION public.read_all_wilayah() OWNER TO postgres;

--
-- Name: sum_jarak_supir_by_id_and_status_transaksi(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sum_jarak_supir_by_id_and_status_transaksi(param_id_supir character varying, param_status_transaksi character varying) RETURNS TABLE(p_jarak numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query

select SUM(transaksi.jarak) from transaksi
    JOIN pasien_detail pd on transaksi.id_pasien_detail = pd.id_pasien_detail
    JOIN tarif_supir ts on transaksi.id_transaksi = ts.id_transaksi
    JOIN supir_detail sd on sd.id_supir_detail = ts.id_supir_detail
    WHERE ts.id_supir_detail = param_id_supir AND transaksi.id_status_transaksi = param_status_transaksi;
END;
$$;


ALTER FUNCTION public.sum_jarak_supir_by_id_and_status_transaksi(param_id_supir character varying, param_status_transaksi character varying) OWNER TO postgres;

--
-- Name: update_2_supir_and_ambulance_on_transaksi(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_2_supir_and_ambulance_on_transaksi(p_id_supir_detail character varying, p_id_supir_detail_2 character varying, p_id_ambulance character varying, p_id_transaksi character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN

UPDATE "transaksi"
SET id_supir_detail = p_id_supir_detail, id_supir_detail_2 =  p_id_supir_detail_2, id_ambulance = p_id_ambulance WHERE id_transaksi = p_id_transaksi;

END
$$;


ALTER FUNCTION public.update_2_supir_and_ambulance_on_transaksi(p_id_supir_detail character varying, p_id_supir_detail_2 character varying, p_id_ambulance character varying, p_id_transaksi character varying) OWNER TO postgres;

--
-- Name: update_ambulance(character varying, character varying, character varying, character varying, character varying, integer, character varying, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_ambulance(p_nama_ambulance character varying, p_no_plat character varying, p_id_jenis_kendaraan character varying, p_id_kategori_ambulance character varying, p_status_ambulance character varying, p_kilometer integer, p_id_wilayah character varying, p_kondisi integer, p_id_ambulance character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN

UPDATE "ambulance"
SET nama_ambulance = p_nama_ambulance, no_plat =  p_no_plat, id_jenis_kendaraan =  p_id_jenis_kendaraan, id_kategori_ambulance = p_id_kategori_ambulance, status_ambulance = CAST(p_status_ambulance as status_ambulance), kilometer = p_kilometer, id_wilayah = p_id_wilayah, kondisi = p_kondisi WHERE id_ambulance = p_id_ambulance;



END
$$;


ALTER FUNCTION public.update_ambulance(p_nama_ambulance character varying, p_no_plat character varying, p_id_jenis_kendaraan character varying, p_id_kategori_ambulance character varying, p_status_ambulance character varying, p_kilometer integer, p_id_wilayah character varying, p_kondisi integer, p_id_ambulance character varying) OWNER TO postgres;

--
-- Name: update_ambulance_on_transaksi(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_ambulance_on_transaksi(p_id_ambulance character varying, p_id_transaksi character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN

UPDATE "transaksi"
SET  id_ambulance = p_id_ambulance WHERE id_transaksi = p_id_transaksi;

END
$$;


ALTER FUNCTION public.update_ambulance_on_transaksi(p_id_ambulance character varying, p_id_transaksi character varying) OWNER TO postgres;

--
-- Name: update_foto_maps_on_pembayaran(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_foto_maps_on_pembayaran(p_foto_maps character varying, p_id_transaksi character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN

UPDATE "transaksi"
SET foto_maps = p_foto_maps WHERE id_transaksi = p_id_transaksi;

END
$$;


ALTER FUNCTION public.update_foto_maps_on_pembayaran(p_foto_maps character varying, p_id_transaksi character varying) OWNER TO postgres;

--
-- Name: update_jarak_on_transaksi(numeric, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_jarak_on_transaksi(p_jarak numeric, p_id_transaksi character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN

UPDATE "transaksi"
SET jarak = p_jarak WHERE id_transaksi = p_id_transaksi;

END
$$;


ALTER FUNCTION public.update_jarak_on_transaksi(p_jarak numeric, p_id_transaksi character varying) OWNER TO postgres;

--
-- Name: update_status_ambulance(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_status_ambulance(p_status_ambulance character varying, p_no_plat character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
UPDATE "ambulance"
SET "status_ambulance"  = CAST(p_status_ambulance as status_ambulance) WHERE no_plat = p_no_plat;
END;
$$;


ALTER FUNCTION public.update_status_ambulance(p_status_ambulance character varying, p_no_plat character varying) OWNER TO postgres;

--
-- Name: update_status_pembayaran(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_status_pembayaran(p_id_status_pembayaran character varying, p_id_pembayaran character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
UPDATE "pembayaran"
SET "id_status_pembayaran"  = p_id_status_pembayaran WHERE id_pembayaran = p_id_pembayaran;
END;
$$;


ALTER FUNCTION public.update_status_pembayaran(p_id_status_pembayaran character varying, p_id_pembayaran character varying) OWNER TO postgres;

--
-- Name: update_status_transaksi(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_status_transaksi(p_id_status_transaksi character varying, p_id_transaksi character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
UPDATE "transaksi"
SET "id_status_transaksi"  = p_id_status_transaksi WHERE id_transaksi = p_id_transaksi;
END;
$$;


ALTER FUNCTION public.update_status_transaksi(p_id_status_transaksi character varying, p_id_transaksi character varying) OWNER TO postgres;

--
-- Name: update_status_user_supir(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_status_user_supir(p_status_supir character varying, p_id_supir_detail character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
UPDATE "supir_detail"
SET "status_supir " = CAST(p_status_supir as status_supir) WHERE id_supir_detail = p_id_supir_detail;
END;
$$;


ALTER FUNCTION public.update_status_user_supir(p_status_supir character varying, p_id_supir_detail character varying) OWNER TO postgres;

--
-- Name: update_supir(character varying, character varying, character varying, public.jenis_kelamin, character varying, public.status_supir, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_supir(p_nama character varying, p_nomor_hp character varying, p_foto_supir character varying, p_jenis_kelamin public.jenis_kelamin, p_nip character varying, p_status_supir public.status_supir, p_id_supir_detail character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
UPDATE "supir_detail"
SET nama = p_nama, nomor_hp =  p_nomor_hp, foto_supir =  p_foto_supir, jenis_kelamin = p_jenis_kelamin, nip = p_nip, "status_supir " = p_status_supir WHERE id_supir_detail = p_id_supir_detail;
END
$$;


ALTER FUNCTION public.update_supir(p_nama character varying, p_nomor_hp character varying, p_foto_supir character varying, p_jenis_kelamin public.jenis_kelamin, p_nip character varying, p_status_supir public.status_supir, p_id_supir_detail character varying) OWNER TO postgres;

--
-- Name: update_supir_1_and_ambulance_on_transaksi(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_supir_1_and_ambulance_on_transaksi(p_id_supir_detail character varying, p_id_ambulance character varying, p_id_transaksi character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN

UPDATE "transaksi"
SET id_supir_detail = p_id_supir_detail, id_ambulance = p_id_ambulance WHERE id_transaksi = p_id_transaksi;

END
$$;


ALTER FUNCTION public.update_supir_1_and_ambulance_on_transaksi(p_id_supir_detail character varying, p_id_ambulance character varying, p_id_transaksi character varying) OWNER TO postgres;

--
-- Name: update_supir_1_on_transaksi(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_supir_1_on_transaksi(p_id_supir_detail character varying, p_id_transaksi character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN

UPDATE "transaksi"
SET id_supir_detail = p_id_supir_detail WHERE id_transaksi = p_id_transaksi;

END
$$;


ALTER FUNCTION public.update_supir_1_on_transaksi(p_id_supir_detail character varying, p_id_transaksi character varying) OWNER TO postgres;

--
-- Name: update_supir_2_and_ambulance_on_transaksi(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_supir_2_and_ambulance_on_transaksi(p_id_supir_detail_2 character varying, p_id_ambulance character varying, p_id_transaksi character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN

UPDATE "transaksi"
SET id_supir_detail_2 = p_id_supir_detail_2, id_ambulance = p_id_ambulance WHERE id_transaksi = p_id_transaksi;

END
$$;


ALTER FUNCTION public.update_supir_2_and_ambulance_on_transaksi(p_id_supir_detail_2 character varying, p_id_ambulance character varying, p_id_transaksi character varying) OWNER TO postgres;

--
-- Name: update_supir_2_on_transaksi(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_supir_2_on_transaksi(p_id_supir_detail_2 character varying, p_id_transaksi character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN

UPDATE "transaksi"
SET id_supir_detail_2 = p_id_supir_detail_2 WHERE id_transaksi = p_id_transaksi;

END
$$;


ALTER FUNCTION public.update_supir_2_on_transaksi(p_id_supir_detail_2 character varying, p_id_transaksi character varying) OWNER TO postgres;

--
-- Name: update_tarif_on_pembayaran(numeric, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_tarif_on_pembayaran(p_tarif numeric, p_id_pembayaran character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN

UPDATE "pembayaran"
SET tarif = p_tarif WHERE id_pembayaran = p_id_pembayaran;

END
$$;


ALTER FUNCTION public.update_tarif_on_pembayaran(p_tarif numeric, p_id_pembayaran character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ambulance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ambulance (
    id_ambulance character varying(100) NOT NULL,
    nama_ambulance character varying(40),
    no_plat character varying(10),
    id_jenis_kendaraan character varying(100),
    id_kategori_ambulance character varying(100),
    status_ambulance public.status_ambulance,
    kilometer integer,
    id_wilayah character varying(100),
    kondisi integer
);


ALTER TABLE public.ambulance OWNER TO postgres;

--
-- Name: jenis_kendaraan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jenis_kendaraan (
    id_jenis_kendaraan character varying(100) NOT NULL,
    jenis_kendaraan character varying(50)
);


ALTER TABLE public.jenis_kendaraan OWNER TO postgres;

--
-- Name: kategori_ambulance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kategori_ambulance (
    id_kategori_ambulance character varying(100) NOT NULL,
    kategori_ambulance character varying(50)
);


ALTER TABLE public.kategori_ambulance OWNER TO postgres;

--
-- Name: log_status_supir; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.log_status_supir (
    id_log_status_supir character varying(100) NOT NULL,
    updated_at timestamp without time zone,
    id_supir_detail character varying(100)
);


ALTER TABLE public.log_status_supir OWNER TO postgres;

--
-- Name: pasien_detail; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pasien_detail (
    id_pasien_detail character varying(100),
    nama_lengkap character varying(30),
    jenis_kelamin public.jenis_kelamin,
    nama_ruangan_medik character varying(100),
    nomor_rekam_medik character varying(100),
    nomor_kamar character varying(100),
    golongan_pasien public.golongan_pasien,
    nomor_telepon character varying(20)
);


ALTER TABLE public.pasien_detail OWNER TO postgres;

--
-- Name: pembayaran; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pembayaran (
    id_pembayaran character varying(100) NOT NULL,
    tarif integer,
    tanggal_pembayaran timestamp without time zone,
    kode_tindakan character varying(100),
    id_status_pembayaran character varying(100),
    id_user_kasir character varying(100),
    metode_pembayaran public.metode_pembayaran
);


ALTER TABLE public.pembayaran OWNER TO postgres;

--
-- Name: status_pembayaran; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.status_pembayaran (
    id_status_pembayaran character varying(100) NOT NULL,
    status_pembayaran character varying(50)
);


ALTER TABLE public.status_pembayaran OWNER TO postgres;

--
-- Name: status_transaksi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.status_transaksi (
    id_status_transaksi character varying(100) NOT NULL,
    status_transaksi character varying(50)
);


ALTER TABLE public.status_transaksi OWNER TO postgres;

--
-- Name: supir_detail; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.supir_detail (
    id_supir_detail character varying(100) NOT NULL,
    nama character varying(30),
    nomor_hp character varying(20),
    foto_supir character varying(100),
    jenis_kelamin public.jenis_kelamin,
    nip character varying(30),
    "status_supir " public.status_supir
);


ALTER TABLE public.supir_detail OWNER TO postgres;

--
-- Name: tarif_supir; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tarif_supir (
    id_tarif_supir character varying(100),
    tarif integer,
    id_supir_detail character varying(100),
    id_transaksi character varying(100)
);


ALTER TABLE public.tarif_supir OWNER TO postgres;

--
-- Name: transaksi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transaksi (
    id_transaksi character varying(100) NOT NULL,
    nomor_invoice character varying(50),
    nomor_registrasi character varying(50),
    nomor_surat_tugas character varying(50),
    link_tracking text,
    alamat text,
    jarak numeric,
    latitude_tujuan character varying(30),
    longitude_tujuan character varying(30),
    tanggal_transaksi timestamp without time zone,
    foto_maps character varying(100),
    id_supir_detail character varying(100),
    id_status_transaksi character varying(100),
    id_ambulance character varying(100),
    id_wilayah character varying(100),
    id_user_nakes character varying(100),
    id_pasien_detail character varying(100),
    id_pembayaran character varying(100),
    id_supir_detail_2 character varying(100),
    id_kategori_ambulance character varying(100)
);


ALTER TABLE public.transaksi OWNER TO postgres;

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
-- Name: wilayah; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wilayah (
    id_wilayah character varying(100) NOT NULL,
    wilayah character varying(50)
);


ALTER TABLE public.wilayah OWNER TO postgres;

--
-- Data for Name: ambulance; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ambulance VALUES ('08ac024e-f3f8-9f0a-8ed6-3a5de8aafd49', 'Ambulance A23', 'BG 1999 A', 'c6a246c4-0b73-43f6-b3bd-f532b676a9b3', 'c8ah48c4-0i73-03f6-b8d-f53gbf7659b3', 'R', 0, 'ca651c81-13d9-716b-4d57-ed01ea8ea7f0', 72);
INSERT INTO public.ambulance VALUES ('feee0aec-3b10-19dd-7267-54f346cb3120', 'Ambulance JJ', 'ZS 2999 TA', 'c6a246c4-0b73-43f6-b3bd-f532b676a9b3', 'c6a246c4-0b73-43f6-b3bd-f53gbf7659b3', 'N', 0, 'fc5c72c7-0cbb-b03c-76f0-836b3c0df1b3', 90);
INSERT INTO public.ambulance VALUES ('dfe17a7c-f1af-f878-549b-3ec83714b428', 'Ambulance JJ', 'ZS 2999 TA', 'c6a246c4-0b73-43f6-b3bd-f532b676a9b3', 'c8ah48c4-0i73-03f6-b8d-f53gbf7659b3', 'N', 0, '7d8d17cf-2bf5-0bad-d368-2b175a4dd93e', 90);


--
-- Data for Name: jenis_kendaraan; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.jenis_kendaraan VALUES ('c6a246c4-0b73-43f6-b3bd-f532b676a9b3', 'AFV');


--
-- Data for Name: kategori_ambulance; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.kategori_ambulance VALUES ('c8ah48c4-0i73-03f6-b8d-f53gbf7659b3', 'Ambulance Pasien');
INSERT INTO public.kategori_ambulance VALUES ('c6a246c4-0b73-43f6-b3bd-f53gbf7659b3', 'Ambulance Jenazah');
INSERT INTO public.kategori_ambulance VALUES ('12121esa-0b73-43f6-b3bd-gfy172612172', 'NULL');


--
-- Data for Name: log_status_supir; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.log_status_supir VALUES ('agshagshagsha12h1g21', '2022-06-29 17:52:57.098303', 'ec28d096-6551-2174-d60b-946a4178e08b');
INSERT INTO public.log_status_supir VALUES ('bahsbhabsgshagsha12h1g21', '2022-06-29 01:52:57.098303', '40473db9-8707-92ef-73a5-51ce1bb36c9c');
INSERT INTO public.log_status_supir VALUES ('bahsbhsasasasassgshagsha12h1g21', '2022-06-29 02:52:57.098303', '75a13659-c0eb-a861-cc10-13fd27766da9');
INSERT INTO public.log_status_supir VALUES ('212121213121212', '2022-06-29 02:52:57.098303', 'c36bf8c9-5619-6147-b868-9c08beadbc5a');
INSERT INTO public.log_status_supir VALUES ('6e9c8682-ffd5-e1d6-36a0-765365b29df4', '2022-12-19 13:47:05.624773', '8f525bf3-191d-4e73-ab0b-2c6f2591c439');


--
-- Data for Name: pasien_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.pasien_detail VALUES ('8613b656-7cde-f4ad-9af3-4f391d20d3ed', 'Taufik', 'L', 'RA 1', 'TA 1', 'AS 1', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('50471ba7-734a-97c0-767c-3a4a425584b2', 'Hakim', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('0fdf9512-0879-52dc-7645-b1e9f98c952a', 'Hakim 2', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('2635fb96-3049-beb0-0a33-de32c41e9819', 'Hakim 2', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('c6e498e5-92c5-fbd4-19e5-345160b76e08', 'Hakim 2', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('6aa139bf-13cc-9d8e-5643-11d596b1f3f9', 'Hakim 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('b5858557-5196-2118-2431-ce9bc1fa6b4a', 'Hakim 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('4b93196e-529b-b8f5-61bd-173b1ea521e0', 'Hakim 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('cf71be45-a6af-3fe0-e910-157afa821657', 'Hakim 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('6dfac0bd-a7d0-6153-66e6-a6e7de1a6605', 'Hakim 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('d66d60a7-2c04-4e20-a30e-554c9f38f341', 'Hakim 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('67ba85f6-c57d-3cba-e3b0-cdb83ad59b80', 'Hakim 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('18bbf603-1ecf-4c7d-b308-b62c7a38bd86', 'Hakim 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('c685a091-35a6-7ab3-a6df-cf592b5df1d4', 'Hakim 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('95467ec2-c48e-a597-fd79-e461dfc96c27', 'Hakim 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('1577c71f-cdf2-22f4-c07e-3ad2aaf550ee', 'Hakim 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('8ce0b88f-d211-fbb5-cf02-123dcdb5f4e2', 'Hakim 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('cc83a136-5cc7-bf6a-3287-9c4d2b3fe6c3', 'Hakim 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('5dbfe9e7-751b-3c22-4bc6-72eedd213839', 'Hakim 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('079e1964-91cc-4eb3-d867-3a4b04f7dd10', 'Hakim 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('f262cd72-49ab-2e3a-0e11-dc2b2cb978c2', 'Hakim 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('cce4ad8b-8c2c-cfab-acc2-02e890b5a565', 'Hakim 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('b61abc29-b1c7-96ee-607b-70e9701338f5', 'Hakim 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('74096459-1121-fa03-4b6a-c78ec268aa88', 'Hakim 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('a8baa397-0d42-154c-873b-b2ef3ea9e167', 'Hakim 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('1bb52f34-b58e-0618-4563-6cf8c6a1a236', 'Hakim 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('7be28262-e602-ffcc-10d3-4fb508a10fcd', 'Hakim 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('94f89762-79c4-ab6f-4667-4d188feb1ecd', 'KRESSS 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('388ecd6b-bdf0-85bc-7811-23f9015c3eb3', 'KRESSS 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('2c4bd1a1-ea5f-3924-cb5b-f335c059dafa', 'KRESSS 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('738cd426-bad8-7748-b7c9-25cb098efa0e', 'KRESSS 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('121de37b-0bbc-96ff-a34c-f8ea08272b03', 'KRESSS 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('a61ccb42-2b87-b6b6-c1fc-810bfbb3fc28', 'KRESSS 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('670fcf2d-3d6a-42b6-2237-73fdec353366', 'KRESSS 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('85c088fe-732e-ea5b-79ce-aad362dfa3f5', 'KRESSS 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('9a7dff43-5a7c-5358-a636-d9dea6690dad', 'KRESSS 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('e2b2fe41-e861-9c03-0f6c-ee32b3aa9a18', 'KRESSS 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('4711bef6-50bd-0d33-d175-4430d9ecd446', 'KRESSS 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('248f31b9-6126-eadc-31fe-5acca9176b82', 'KRESSS 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('4f63d449-242b-31f0-03f6-5dd5133a70ab', 'KRESSS 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('02bcc0a8-027a-7958-2f27-158e6f0b69ac', 'KRESSS 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('d8d5f539-bc39-e4dc-218d-169cb90284c5', 'KRESSS 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('c13be9d8-8ee9-aacf-8ccc-34500e397d3a', 'KRESSS 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('7fc19ac1-fb6c-faf7-2d57-0d1b7cc45988', 'KRESSS 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('c5fc9dc8-7123-085c-9ab6-02c9972ce7a6', 'KRESSS 100', 'L', 'RA 2', 'TA 2', 'AS 2', 'REG', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('8edd1956-0a58-e6b9-f9de-79de94244a22', 'Hakim 2', 'L', 'RA 2', 'TA 2', 'AS 2', 'REG', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('8012625e-4745-3055-d2d6-cfcd72720d0a', 'JJJJJJJJ', 'L', '12121212', '121212121', '12121212121', 'NULL', '12121212121');
INSERT INTO public.pasien_detail VALUES ('ad1025fa-5d99-4b45-c259-41051945620c', 'DEA ENJE LIKA', 'P', 'AX 01', '0AHJASHHA18', '00000', 'REG', '0000000000');
INSERT INTO public.pasien_detail VALUES ('0c16b983-b0b7-89fc-f6f0-f0019109bfd4', 'DEA ENJE LIKA', 'P', 'AX 01', '0AHJASHHA18', '00000', 'REG', '0000000000');
INSERT INTO public.pasien_detail VALUES ('c5cfac24-0e23-5370-9bb0-ab5d7080a1d3', 'ILMA BINTI MUHAMAD', 'P', 'AX 01', '0AHJASHHA18', '00000', 'REG', '0000000000');
INSERT INTO public.pasien_detail VALUES ('b1a4f915-3e6c-9058-5d99-bdf8d0817927', 'ILMA BINTI MUHAMAD', 'P', 'AX 01', '0AHJASHHA18', '00000', 'REG', '0000000000');
INSERT INTO public.pasien_detail VALUES ('480fdd3c-9aa4-d33b-1d2a-b8ce12110cf1', 'ILMA BINTI MUHAMAD', 'P', 'AX 01', '0AHJASHHA18', '00000', 'REG', '0000000000');
INSERT INTO public.pasien_detail VALUES ('63ff7fad-f2c4-6ba8-e382-15f22f59cc65', 'ILMA BINTI MUHAMAD', 'P', 'AX 01', '0AHJASHHA18', '00000', 'REG', '0000000000');
INSERT INTO public.pasien_detail VALUES ('7525d5f2-aadd-ae77-ba51-3bbedc77c17e', 'Hakim 1', 'L', '12121212', '121212121', '12121212121', 'REG', '12121212121');
INSERT INTO public.pasien_detail VALUES ('8362327d-7422-9c40-510f-5ad9dbcaac3f', 'Hakim 120', 'L', '12121212', '121212121', '12121212121', 'REG', '12121212121');
INSERT INTO public.pasien_detail VALUES ('3943ed1b-1584-23d6-195e-4e7310b3362c', 'Hakim 56', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('89411df9-83ab-5156-c9a4-e39e6e709855', 'Hakim 12', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('2b937aff-8f2b-0b58-2567-15110a958019', 'Hakim 10', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('3881b356-8011-884d-9acd-c33fdcb40719', 'Hakim 7', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('ff5eb8ca-5c1a-7d8c-51ae-ef8fc322e443', 'Hakim 78', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('a92c5749-948e-e57f-71db-625c38b48bc0', 'Hakim 6', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('b6677e5d-d989-1795-527d-c9b74ec8fbad', 'Hakim 4', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('8fbc52c0-f1ec-b246-4ca7-bb12750883e2', 'Hakim 126', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('30b7a99a-0e1a-9272-f6c9-432be521fad3', 'Hakim 8', 'L', 'RA 2', 'TA 2', 'AS 2', 'PBI', '0812612716212');
INSERT INTO public.pasien_detail VALUES ('ca2ffda3-3bd8-de28-61b9-54701a32b8a3', 'DEA ENJE LIKA', 'P', 'AX 01', '0AHJASHHA18', '00000', 'REG', '0000000000');
INSERT INTO public.pasien_detail VALUES ('77d8bb09-4e02-e897-61f1-7d60cddba490', 'DEA ENJE LIKA', 'P', 'AX 01', '0AHJASHHA18', '00000', 'REG', '0000000000');
INSERT INTO public.pasien_detail VALUES ('6c5fe6a9-44c4-41fc-b719-e1e6d70e87bd', 'DEA ENJE LIKA', 'P', 'AX 01', '0AHJASHHA18', '00000', 'REG', '0000000000');
INSERT INTO public.pasien_detail VALUES ('f6621d71-8c9b-77fc-f62a-f4d6f49b1aea', 'DEA ENJE LIKA', 'P', 'AX 01', '0AHJASHHA18', '00000', 'REG', '0000000000');
INSERT INTO public.pasien_detail VALUES ('e744b6d6-47f9-6cd7-da1e-5556793e928e', 'DEA ENJE LIKA', 'P', 'AX 01', '0AHJASHHA18', '00000', 'REG', '0000000000');
INSERT INTO public.pasien_detail VALUES ('88a6baf8-4bbb-1e26-b6fb-aa1291e840d3', 'DEA ENJE LIKA', 'P', 'AX 01', '0AHJASHHA18', '00000', 'REG', '0000000000');
INSERT INTO public.pasien_detail VALUES ('fe2822e8-8b4e-cc3d-ac3c-179609c6a0c3', 'DEA ENJE LIKA', 'P', 'AX 01', '0AHJASHHA18', '00000', 'REG', '0000000000');
INSERT INTO public.pasien_detail VALUES ('bad23572-beff-790a-6574-987ef253cb68', 'DEA ENJE LIKA', 'P', 'AX 01', '0AHJASHHA18', '00000', 'REG', '0000000000');
INSERT INTO public.pasien_detail VALUES ('b03a8a50-364f-0443-d7e6-bb29c59ba260', 'DEA ENJE LIKA', 'P', 'AX 01', '0AHJASHHA18', '00000', 'REG', '0000000000');
INSERT INTO public.pasien_detail VALUES ('49217aa3-3735-079c-488c-274382892cac', 'DEA ENJE LIKA', 'P', 'AX 01', '0AHJASHHA18', '00000', 'REG', '0000000000');
INSERT INTO public.pasien_detail VALUES ('7c91e9b5-9796-d296-e657-cd84334e70f9', 'DEA ENJE LIKA', 'P', 'AX 01', '0AHJASHHA18', '00000', 'REG', '0000000000');
INSERT INTO public.pasien_detail VALUES ('041543bb-8d6f-7dd2-523e-2b8d143e08f6', 'DEA ENJE LIKA', 'P', 'AX 01', '0AHJASHHA18', '00000', 'REG', '0000000000');
INSERT INTO public.pasien_detail VALUES ('b5f367c7-3192-8b31-7353-e5f12e867f93', 'DEA ENJE LIKA', 'P', 'AX 01', '0AHJASHHA18', '00000', 'REG', '0000000000');
INSERT INTO public.pasien_detail VALUES ('c097f07d-543a-172a-bf3f-9d9dabc13b2e', 'DEA ENJE LIKA', 'P', 'AX 01', '0AHJASHHA18', '00000', 'REG', '0000000000');
INSERT INTO public.pasien_detail VALUES ('72e2ba99-b319-60d1-df9a-0ba5e240dfcb', 'DEA ENJE LIKA', 'P', 'AX 01', '0AHJASHHA18', '00000', 'REG', '0000000000');
INSERT INTO public.pasien_detail VALUES ('17aa28f0-f39a-43ae-644b-94a21a1dc526', 'DEA ENJE LIKA', 'P', 'AX 01', '0AHJASHHA18', '00000', 'REG', '0000000000');
INSERT INTO public.pasien_detail VALUES ('41327a73-2e48-37bf-4643-d19a30c59871', 'DEA ENJE LIKA', 'P', 'AX 01', '0AHJASHHA18', '00000', 'REG', '0000000000');
INSERT INTO public.pasien_detail VALUES ('211d7f89-99b1-9135-78fd-124f63694930', 'DEA ENJE LIKA', 'P', 'AX 01', '0AHJASHHA18', '00000', 'REG', '0000000000');
INSERT INTO public.pasien_detail VALUES ('e4570695-a588-c34a-026e-3bd15cabd8e6', 'DEA ENJE LIKA', 'P', 'AX 01', '0AHJASHHA18', '00000', 'REG', '0000000000');
INSERT INTO public.pasien_detail VALUES ('db40fd34-8d57-b20c-d8e6-717bfa32ab8c', 'DEA ENJE LIKA', 'P', 'AX 01', '0AHJASHHA18', '00000', 'REG', '0000000000');
INSERT INTO public.pasien_detail VALUES ('d9c059b3-2736-8f9b-0b39-576d28c42cc1', 'DEA ENJE LIKA', 'P', 'AX 01', '0AHJASHHA18', '00000', 'REG', '0000000000');
INSERT INTO public.pasien_detail VALUES ('e387528d-3d34-9197-fcbb-3fc7eb56e0dc', 'DEA ENJE LIKA', 'P', 'AX 01', '0AHJASHHA18', '00000', 'REG', '0000000000');


--
-- Data for Name: pembayaran; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.pembayaran VALUES ('6fab7a7d-26a8-b02a-1307-4f9a0ad40745', 6800287, '1212-12-12 00:00:00', '12782178721', '1d437360-2851-f989-e4f0-cfcbc2d0ebad', '1d437360-2851-f989-e4f0-cfcbc2d0ebad', 'NULL');
INSERT INTO public.pembayaran VALUES ('4e0dd68e-3eac-1716-ef12-e21b0b921b1c', 2309605, '1212-12-12 00:00:00', '12782178721', '1d437360-2851-f989-e4f0-cfcbc2d0ebad', '1d437360-2851-f989-e4f0-cfcbc2d0ebad', 'NULL');
INSERT INTO public.pembayaran VALUES ('7d85778e-5987-629b-9bae-2119ff44a661', 9610509, '1212-12-12 00:00:00', '12782178721', '1d437360-2851-f989-e4f0-cfcbc2d0ebad', '1d437360-2851-f989-e4f0-cfcbc2d0ebad', 'NULL');
INSERT INTO public.pembayaran VALUES ('f254d55e-8139-a397-9d14-0fc3aebff5b9', 2309605, '1212-12-12 00:00:00', '12782178721', '1d437360-2851-f989-e4f0-cfcbc2d0ebad', '1d437360-2851-f989-e4f0-cfcbc2d0ebad', 'NULL');
INSERT INTO public.pembayaran VALUES ('6e26e86a-1262-f051-5ec2-c22102d8b342', 2309605, '1212-12-12 00:00:00', '12782178721', '1d437360-2851-f989-e4f0-cfcbc2d0ebad', '1d437360-2851-f989-e4f0-cfcbc2d0ebad', 'NULL');


--
-- Data for Name: status_pembayaran; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.status_pembayaran VALUES ('895d6aee-8ff9-f066-1eac-45fe80153ee7', 'Lunas');
INSERT INTO public.status_pembayaran VALUES ('1d437360-2851-f989-e4f0-cfcbc2d0ebad', 'Belum Lunas');


--
-- Data for Name: status_transaksi; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.status_transaksi VALUES ('43223343-7394-36c4-d06e-e5386d2e28d1', 'Belum Acc Pasien');
INSERT INTO public.status_transaksi VALUES ('5f6bd832-e553-27ea-9733-30517939e6cf', 'Acc Pengelola Ambulance');
INSERT INTO public.status_transaksi VALUES ('1644f443-0704-7241-4004-3cbdee1bf3f2', 'Acc Pasien');
INSERT INTO public.status_transaksi VALUES ('625962e2-7dd1-a6de-a5aa-b04e760a8c8c', 'Acc Kasir');
INSERT INTO public.status_transaksi VALUES ('83f80c00-a4da-2939-096b-e976b719d7ac', 'Acc Supir');
INSERT INTO public.status_transaksi VALUES ('3b6b76bc-20ca-7ebc-5afa-ed5d26b1c9d2', 'Acc Supir Sampai Tujuan Antar');
INSERT INTO public.status_transaksi VALUES ('e17b741e-46a8-1712-cdb6-1c010a473697', 'Acc Supir Samapi Di RSMH');
INSERT INTO public.status_transaksi VALUES ('e17b741e-46a8-1712-cdb6-1f010c473691', 'Cancel Pesanan');


--
-- Data for Name: supir_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.supir_detail VALUES ('75a13659-c0eb-a861-cc10-13fd27766da9', 'Amir', '082176350289', 'amir.jpg', 'L', '0182817271216', 'N');
INSERT INTO public.supir_detail VALUES ('8f525bf3-191d-4e73-ab0b-2c6f2591c439', 'rian', '12112121', '4f79e8188a8b47ecdc2bdc051e2fbdd5.png', 'L', '1212121', 'R');
INSERT INTO public.supir_detail VALUES ('c36bf8c9-5619-6147-b868-9c08beadbc5a', 'taufik', '01281782712', '54c052237be6191fac1720014b2cde8c.png', 'L', '121212', 'R');
INSERT INTO public.supir_detail VALUES ('ec28d096-6551-2174-d60b-946a4178e08b', 'Kresna Vespri', '08126y1762712', 'kresna.jpg', 'L', '12617261762172', 'R');
INSERT INTO public.supir_detail VALUES ('40473db9-8707-92ef-73a5-51ce1bb36c9c', 'Supardi', '082176350289', 'supardi.jpg', 'L', '1829819212', 'N');
INSERT INTO public.supir_detail VALUES ('895c9c65-ab34-2b66-3ff3-6b6a7d327175', 'taufik', '123', 'f0eafb27cb18ebd1e0e978d467d52f4c.png', 'L', '1267121', 'N');


--
-- Data for Name: tarif_supir; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tarif_supir VALUES ('12121212-a4f6-a7f3-ccdf-4919121f7dahsajasa', 20000, '40473db9-8707-92ef-73a5-51ce1bb36c9c', '02dacb3c-eb0f-ecb3-d39a-a74cb0714187');
INSERT INTO public.tarif_supir VALUES ('e481c646-a2e0-60b3-5f51-5d549103f56b', 100000, 'c36bf8c9-5619-6147-b868-9c08beadbc5a', '02dacb3c-eb0f-ecb3-d39a-a74cb0714187');


--
-- Data for Name: transaksi; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.transaksi VALUES ('fc84873f-c03d-cfab-1ae8-bd29f106f8b4', 'AJ-PB-REG-0000000001', 'RJ22150014 ', 'nomor surat tugas', 'maps.com', 'Desa Sangku, Bangka Barat, Kepulauan Bangka Belitung, Indonesia', 230.96050000000002, '-2.0359831', '105.69122047643395', '2022-12-21 11:32:43.386272', 'dummy.jpg', '40473db9-8707-92ef-73a5-51ce1bb36c9c', '43223343-7394-36c4-d06e-e5386d2e28d1', 'dfe17a7c-f1af-f878-549b-3ec83714b428', '7d8d17cf-2bf5-0bad-d368-2b175a4dd93e', '3ab79fe2-2234-b8c6-6387-b815c4d14e30', 'e387528d-3d34-9197-fcbb-3fc7eb56e0dc', '6e26e86a-1262-f051-5ec2-c22102d8b342', 'NULL', 'c8ah48c4-0i73-03f6-b8d-f53gbf7659b3');


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
INSERT INTO public.users VALUES ('dPC1d9f8E8s6PRE6', 'pengelola', '123', 'bc814274-95da-b744-22ca-67a33ace375e', '128912h9181u2');
INSERT INTO public.users VALUES ('40473db9-8707-92ef-73a5-51ce1bb36c9c', 'supir 1', '123', 'cef5e5a8-ebdc-b854-5fbf-0615a66e97e2', '40473db9-8707-92ef-73a5-51ce1bb36c9c');
INSERT INTO public.users VALUES ('ec28d096-6551-2174-d60b-946a4178e08b', 'Kresna', '123', 'cef5e5a8-ebdc-b854-5fbf-0615a66e97e2', 'ec28d096-6551-2174-d60b-946a4178e08b');
INSERT INTO public.users VALUES ('3ab79fe2-2234-b8c6-6387-b815c4d14e30', 'nakes', '123', '3ab79fe2-2234-b8c6-6387-b815c4d14e30', '162y791y218721');
INSERT INTO public.users VALUES ('c36bf8c9-5619-6147-b868-9c08beadbc5a', 'taufik', '121212', 'cef5e5a8-ebdc-b854-5fbf-0615a66e97e2', 'c36bf8c9-5619-6147-b868-9c08beadbc5a');
INSERT INTO public.users VALUES ('895c9c65-ab34-2b66-3ff3-6b6a7d327175', 'taufik', '1267121', 'cef5e5a8-ebdc-b854-5fbf-0615a66e97e2', '895c9c65-ab34-2b66-3ff3-6b6a7d327175');
INSERT INTO public.users VALUES ('8f525bf3-191d-4e73-ab0b-2c6f2591c439', 'kasir', '123', '1cfef359-9669-afa2-f4bc-a7e62705f061', '8f525bf3-191d-4e73-ab0b-2c6f2591c439');


--
-- Data for Name: wilayah; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.wilayah VALUES ('7d8d17cf-2bf5-0bad-d368-2b175a4dd93e', 'BANGKA');
INSERT INTO public.wilayah VALUES ('ca651c81-13d9-716b-4d57-ed01ea8ea7f0', 'JAWA');
INSERT INTO public.wilayah VALUES ('fc5c72c7-0cbb-b03c-76f0-836b3c0df1b3', 'SUMATERA');
INSERT INTO public.wilayah VALUES ('a7s8sa8as8-2bf5-0bad-d368-2b175a4dd92e', 'NULL');


--
-- Name: ambulance ambulance_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ambulance
    ADD CONSTRAINT ambulance_pk PRIMARY KEY (id_ambulance);


--
-- Name: jenis_kendaraan jenis_kendaraan_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jenis_kendaraan
    ADD CONSTRAINT jenis_kendaraan_pk PRIMARY KEY (id_jenis_kendaraan);


--
-- Name: kategori_ambulance kategori_ambulance_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kategori_ambulance
    ADD CONSTRAINT kategori_ambulance_pk PRIMARY KEY (id_kategori_ambulance);


--
-- Name: log_status_supir log_status_supir_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_status_supir
    ADD CONSTRAINT log_status_supir_pk PRIMARY KEY (id_log_status_supir);


--
-- Name: pembayaran pembayaran_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pembayaran
    ADD CONSTRAINT pembayaran_pk PRIMARY KEY (id_pembayaran);


--
-- Name: status_pembayaran status_pembayaran_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status_pembayaran
    ADD CONSTRAINT status_pembayaran_pk PRIMARY KEY (id_status_pembayaran);


--
-- Name: status_transaksi status_transaksi_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status_transaksi
    ADD CONSTRAINT status_transaksi_pk PRIMARY KEY (id_status_transaksi);


--
-- Name: supir_detail supir_detail_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supir_detail
    ADD CONSTRAINT supir_detail_pk PRIMARY KEY (id_supir_detail);


--
-- Name: transaksi transaksi_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaksi
    ADD CONSTRAINT transaksi_pk PRIMARY KEY (id_transaksi);


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
-- Name: wilayah wilayah_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wilayah
    ADD CONSTRAINT wilayah_pk PRIMARY KEY (id_wilayah);


--
-- PostgreSQL database dump complete
--

