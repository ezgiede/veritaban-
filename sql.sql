--
-- PostgreSQL database dump
--

-- Dumped from database version 11.18
-- Dumped by pg_dump version 11.18

-- Started on 2022-12-26 20:47:31

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
-- TOC entry 232 (class 1255 OID 33310)
-- Name: maxsiparis(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.maxsiparis() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE 
MAKS INTEGER;
BEGIN 
MAKS:=(SELECT MAX("urun_siparis")FROM "tbl_urun");
RETURN MAKS;
END;
$$;


ALTER FUNCTION public.maxsiparis() OWNER TO postgres;

--
-- TOC entry 217 (class 1255 OID 49440)
-- Name: silinenurun(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.silinenurun() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO "silinenurunler" ( "urun_id", "magaza_id", "urun_fiyat","urun_turu" ,"urun_stok")
         VALUES(NEW."urunid",NEW."magazaid",NEW."fiyat",current_user,now(),'delete');
RETURN NEW;
END;
$$;


ALTER FUNCTION public.silinenurun() OWNER TO postgres;

--
-- TOC entry 219 (class 1255 OID 33309)
-- Name: siparis_toplam(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.siparis_toplam() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE 
toplam INTEGER;
BEGIN 
toplam:=(SELECT SUM("urun_siparis")FROM "tbl_urun");
RETURN toplam;
END;
$$;


ALTER FUNCTION public.siparis_toplam() OWNER TO postgres;

--
-- TOC entry 216 (class 1255 OID 33306)
-- Name: toplamurun(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.toplamurun() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN 
UPDATE tbl_toplam_urun set sayi=sayi+1;
return new;
end;
$$;


ALTER FUNCTION public.toplamurun() OWNER TO postgres;

--
-- TOC entry 215 (class 1255 OID 33305)
-- Name: urun_sayisi(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.urun_sayisi() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
total INTEGER;
BEGIN 
SELECT COUNT(*) INTO total FROM "tbl_urun";
RETURN total;
END;
$$;


ALTER FUNCTION public.urun_sayisi() OWNER TO postgres;

--
-- TOC entry 214 (class 1255 OID 33304)
-- Name: urunbul(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.urunbul(urunid integer) RETURNS TABLE(id integer, adi character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
RETURN QUERY SELECT "urun_id", "urun_ad" FROM tbl_urun
    WHERE "urun_id" = urunid;
END;
$$;


ALTER FUNCTION public.urunbul(urunid integer) OWNER TO postgres;

--
-- TOC entry 213 (class 1255 OID 49437)
-- Name: urunekle(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.urunekle() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE toplamurun set sayi=sayi+1;
RETURN NEW;
END;
$$;


ALTER FUNCTION public.urunekle() OWNER TO postgres;

--
-- TOC entry 218 (class 1255 OID 33308)
-- Name: urunguncel(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.urunguncel() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW."urun_fiyat" <> OLD."urun_fiyat" THEN
        INSERT INTO "tbl_urunson"("urunNo", "eskifiyat", "yenifiyat")
        VALUES(OLD."urun_id", OLD."urun_fiyat", NEW."urun_fiyat");
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.urunguncel() OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 204 (class 1259 OID 32991)
-- Name: adres; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.adres (
    adres_no integer NOT NULL,
    adres_turu character varying NOT NULL,
    mahalle character varying NOT NULL,
    sokak character varying NOT NULL,
    daire character varying NOT NULL
);


ALTER TABLE public.adres OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 33006)
-- Name: eveteslimat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.eveteslimat (
    teslimat_no integer NOT NULL
);


ALTER TABLE public.eveteslimat OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 32994)
-- Name: fatura; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fatura (
    fatura_no integer NOT NULL,
    adres_no integer,
    tarih date,
    toplam_tutar money
);


ALTER TABLE public.fatura OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 33197)
-- Name: il; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.il (
    il_kodu integer NOT NULL,
    il_adi character varying
);


ALTER TABLE public.il OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 33003)
-- Name: ilce; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ilce (
    ilce_kodu integer NOT NULL,
    ilce_adi character varying,
    il integer
);


ALTER TABLE public.ilce OWNER TO postgres;

--
-- TOC entry 196 (class 1259 OID 32964)
-- Name: kisi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kisi (
    kisi_id integer NOT NULL,
    kisi_tel character varying,
    kisi_mail character varying,
    kisi_turu character varying,
    kisi_ad character varying,
    kisi_soyad character varying
);


ALTER TABLE public.kisi OWNER TO postgres;

--
-- TOC entry 200 (class 1259 OID 32979)
-- Name: magaza; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.magaza (
    magaza_id integer NOT NULL,
    magaza_adi character varying
);


ALTER TABLE public.magaza OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 33009)
-- Name: magazayateslimat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.magazayateslimat (
    teslimat_no integer NOT NULL
);


ALTER TABLE public.magazayateslimat OWNER TO postgres;

--
-- TOC entry 198 (class 1259 OID 32973)
-- Name: musteri; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.musteri (
    kisi_id integer NOT NULL,
    adres integer,
    siparis integer
);


ALTER TABLE public.musteri OWNER TO postgres;

--
-- TOC entry 199 (class 1259 OID 32976)
-- Name: personel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.personel (
    kisi_id integer NOT NULL,
    magaza integer
);


ALTER TABLE public.personel OWNER TO postgres;

--
-- TOC entry 197 (class 1259 OID 32970)
-- Name: satistemsilcisi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.satistemsilcisi (
    kisi_id integer NOT NULL,
    siparis integer
);


ALTER TABLE public.satistemsilcisi OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 49452)
-- Name: silinenurun; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.silinenurun (
    urun_id integer NOT NULL,
    magaza_id integer NOT NULL,
    urun_fiyat money NOT NULL,
    urun_turu character varying(20) NOT NULL,
    urun_stok integer NOT NULL
);


ALTER TABLE public.silinenurun OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 32985)
-- Name: siparis; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.siparis (
    siparis_no integer NOT NULL,
    fatura_no integer,
    musteri_id integer,
    satistemsilci_id integer,
    siparis_tarihi date
);


ALTER TABLE public.siparis OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 32988)
-- Name: siparisurun; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.siparisurun (
    siparisurun_no integer NOT NULL,
    siparis_no integer,
    urun_id integer
);


ALTER TABLE public.siparisurun OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 32997)
-- Name: teslimat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teslimat (
    teslimat_no integer NOT NULL,
    adres_no integer,
    teslimat_turu character varying
);


ALTER TABLE public.teslimat OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 49434)
-- Name: toplamurun; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.toplamurun (
);


ALTER TABLE public.toplamurun OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 32982)
-- Name: urun; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.urun (
    urun_id integer NOT NULL,
    magaza_id integer,
    urun_fiyat money,
    urun_turu character varying,
    urun_stok integer
);


ALTER TABLE public.urun OWNER TO postgres;

--
-- TOC entry 2960 (class 0 OID 32991)
-- Dependencies: 204
-- Data for Name: adres; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.adres (adres_no, adres_turu, mahalle, sokak, daire) FROM stdin;
10	ev	cicek	kent	2
11	ev	yesilkent	devir	6
12	is	yenikoy	bulut	9
13	is	kemalpasa	sevgi	8
14	ev	kemalpasa	doga	3
\.


--
-- TOC entry 2964 (class 0 OID 33006)
-- Dependencies: 208
-- Data for Name: eveteslimat; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.eveteslimat (teslimat_no) FROM stdin;
1
\.


--
-- TOC entry 2961 (class 0 OID 32994)
-- Dependencies: 205
-- Data for Name: fatura; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fatura (fatura_no, adres_no, tarih, toplam_tutar) FROM stdin;
123	10	2022-12-12	?5.000,00
124	11	2022-11-15	?60.000,00
125	13	2021-09-25	?2.000,00
126	14	2020-01-13	?2.000,00
\.


--
-- TOC entry 2966 (class 0 OID 33197)
-- Dependencies: 210
-- Data for Name: il; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.il (il_kodu, il_adi) FROM stdin;
34	istanbul
44	malatya
41	kocaeli
54	sakarya
67	zonguldak
\.


--
-- TOC entry 2963 (class 0 OID 33003)
-- Dependencies: 207
-- Data for Name: ilce; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ilce (ilce_kodu, ilce_adi, il) FROM stdin;
1	pendik	34
2	besiktas	34
3	kozlu	67
4	yesilyurt	44
5	yenikoy	41
6	serdivan	54
\.


--
-- TOC entry 2952 (class 0 OID 32964)
-- Dependencies: 196
-- Data for Name: kisi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kisi (kisi_id, kisi_tel, kisi_mail, kisi_turu, kisi_ad, kisi_soyad) FROM stdin;
1	05325624547	omeraltinok@hotmail.com	personel	omer	altinok
2	05417895220	selenkilic@icloud.com	satistemsilcisi	selen	kilic
3	05347158547	melikeuygun@gmail.com	personel	melike	uygun
4	05536322414	ensaryildirim@gmail.com	musteri	ensar	yildirim
5	05371231148	mithatbakirtas@gmail.com	musteri	mithat	bakirtas
8	05457896622	sevimekinci@gmail.com	satistemsilcisi	sevim	ekinci
7	05325894567	ezgiede@gmail.com	satistemsilcisi	ezgi	ede
6	05369523695	azradogan@gmail.com	satistemsilcisi	azra	dogan
\.


--
-- TOC entry 2956 (class 0 OID 32979)
-- Dependencies: 200
-- Data for Name: magaza; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.magaza (magaza_id, magaza_adi) FROM stdin;
123	serdivan
124	agora
\.


--
-- TOC entry 2965 (class 0 OID 33009)
-- Dependencies: 209
-- Data for Name: magazayateslimat; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.magazayateslimat (teslimat_no) FROM stdin;
1
2
3
\.


--
-- TOC entry 2954 (class 0 OID 32973)
-- Dependencies: 198
-- Data for Name: musteri; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.musteri (kisi_id, adres, siparis) FROM stdin;
4	12	1
5	14	2
\.


--
-- TOC entry 2955 (class 0 OID 32976)
-- Dependencies: 199
-- Data for Name: personel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.personel (kisi_id, magaza) FROM stdin;
3	123
1	124
\.


--
-- TOC entry 2953 (class 0 OID 32970)
-- Dependencies: 197
-- Data for Name: satistemsilcisi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.satistemsilcisi (kisi_id, siparis) FROM stdin;
8	\N
2	1
6	2
7	3
\.


--
-- TOC entry 2968 (class 0 OID 49452)
-- Dependencies: 212
-- Data for Name: silinenurun; Type: TABLE DATA; Schema: public; Owner: postgres










--

COPY public.silinenurun (urun_id, magaza_id, urun_fiyat, urun_turu, urun_stok) FROM stdin;
\.


--
-- TOC entry 2958 (class 0 OID 32985)
-- Dependencies: 202
-- Data for Name: siparis; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.siparis (siparis_no, fatura_no, musteri_id, satistemsilci_id, siparis_tarihi) FROM stdin;
1	123	4	2	2022-02-12
2	124	4	6	2022-02-13
3	125	5	7	2022-01-06
\.


--
-- TOC entry 2959 (class 0 OID 32988)
-- Dependencies: 203
-- Data for Name: siparisurun; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.siparisurun (siparisurun_no, siparis_no, urun_id) FROM stdin;
1	1	100
2	2	101
3	3	102
\.


--
-- TOC entry 2962 (class 0 OID 32997)
-- Dependencies: 206
-- Data for Name: teslimat; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teslimat (teslimat_no, adres_no, teslimat_turu) FROM stdin;
1	11	ev
2	12	is
3	13	is
\.


--
-- TOC entry 2967 (class 0 OID 49434)
-- Dependencies: 211
-- Data for Name: toplamurun; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.toplamurun  FROM stdin;
\.


--
-- TOC entry 2957 (class 0 OID 32982)
-- Dependencies: 201
-- Data for Name: urun; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.urun (urun_id, magaza_id, urun_fiyat, urun_turu, urun_stok) FROM stdin;
101	123	?5.000,00	kucukevaleti	30
102	124	?10.000,00	beyazesya	8
103	124	?7.000,00	kucukevaleti	40
100	123	?2.000,00	beyazesya	10
\.


--
-- TOC entry 2764 (class 2606 OID 33035)
-- Name: kisi Kisi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kisi
    ADD CONSTRAINT "Kisi_pkey" PRIMARY KEY (kisi_id);


--
-- TOC entry 2793 (class 2606 OID 33099)
-- Name: adres adres_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adres
    ADD CONSTRAINT adres_pkey PRIMARY KEY (adres_no);


--
-- TOC entry 2804 (class 2606 OID 33121)
-- Name: eveteslimat eveteslimat_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eveteslimat
    ADD CONSTRAINT eveteslimat_pkey PRIMARY KEY (teslimat_no);


--
-- TOC entry 2795 (class 2606 OID 33119)
-- Name: fatura fatura_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fatura
    ADD CONSTRAINT fatura_pkey PRIMARY KEY (fatura_no);


--
-- TOC entry 2810 (class 2606 OID 33204)
-- Name: il il_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.il
    ADD CONSTRAINT il_pkey PRIMARY KEY (il_kodu);


--
-- TOC entry 2802 (class 2606 OID 33207)
-- Name: ilce ilce_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ilce
    ADD CONSTRAINT ilce_pkey PRIMARY KEY (ilce_kodu);


--
-- TOC entry 2778 (class 2606 OID 33115)
-- Name: magaza magaza_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.magaza
    ADD CONSTRAINT magaza_pkey PRIMARY KEY (magaza_id);


--
-- TOC entry 2808 (class 2606 OID 33260)
-- Name: magazayateslimat magazayateslimat_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.magazayateslimat
    ADD CONSTRAINT magazayateslimat_pkey PRIMARY KEY (teslimat_no);


--
-- TOC entry 2773 (class 2606 OID 33157)
-- Name: musteri musteri_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.musteri
    ADD CONSTRAINT musteri_pkey PRIMARY KEY (kisi_id);


--
-- TOC entry 2776 (class 2606 OID 33105)
-- Name: personel personel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personel
    ADD CONSTRAINT personel_pkey PRIMARY KEY (kisi_id);


--
-- TOC entry 2766 (class 2606 OID 33103)
-- Name: satistemsilcisi satistemsilcisi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.satistemsilcisi
    ADD CONSTRAINT satistemsilcisi_pkey PRIMARY KEY (kisi_id);


--
-- TOC entry 2787 (class 2606 OID 33107)
-- Name: siparis siparis_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siparis
    ADD CONSTRAINT siparis_pkey PRIMARY KEY (siparis_no);


--
-- TOC entry 2791 (class 2606 OID 33109)
-- Name: siparisurun siparisurun_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siparisurun
    ADD CONSTRAINT siparisurun_pkey PRIMARY KEY (siparisurun_no);


--
-- TOC entry 2799 (class 2606 OID 33111)
-- Name: teslimat teslimat_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teslimat
    ADD CONSTRAINT teslimat_pkey PRIMARY KEY (teslimat_no);


--
-- TOC entry 2782 (class 2606 OID 33113)
-- Name: urun urun_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.urun
    ADD CONSTRAINT urun_pkey PRIMARY KEY (urun_id);


--
-- TOC entry 2767 (class 1259 OID 33143)
-- Name: fki__adres; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki__adres ON public.musteri USING btree (adres);


--
-- TOC entry 2796 (class 1259 OID 33196)
-- Name: fki__adresno; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki__adresno ON public.fatura USING btree (adres_no);


--
-- TOC entry 2783 (class 1259 OID 33178)
-- Name: fki__faturano; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki__faturano ON public.siparis USING btree (fatura_no);


--
-- TOC entry 2800 (class 1259 OID 33213)
-- Name: fki__il; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki__il ON public.ilce USING btree (il);


--
-- TOC entry 2768 (class 1259 OID 33137)
-- Name: fki__kisiid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki__kisiid ON public.musteri USING btree (kisi_id);


--
-- TOC entry 2774 (class 1259 OID 33237)
-- Name: fki__magaza; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki__magaza ON public.personel USING btree (kisi_id);


--
-- TOC entry 2779 (class 1259 OID 33231)
-- Name: fki__magazaid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki__magazaid ON public.urun USING btree (magaza_id);


--
-- TOC entry 2784 (class 1259 OID 33184)
-- Name: fki__musteriid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki__musteriid ON public.siparis USING btree (musteri_id);


--
-- TOC entry 2785 (class 1259 OID 33190)
-- Name: fki__satistemslcisi; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki__satistemslcisi ON public.siparis USING btree (satistemsilci_id);


--
-- TOC entry 2769 (class 1259 OID 33155)
-- Name: fki__siparis; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki__siparis ON public.musteri USING btree (siparis);


--
-- TOC entry 2788 (class 1259 OID 33219)
-- Name: fki__siparisno; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki__siparisno ON public.siparisurun USING btree (siparis_no);


--
-- TOC entry 2805 (class 1259 OID 33258)
-- Name: fki__teslimatno; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki__teslimatno ON public.eveteslimat USING btree (teslimat_no);


--
-- TOC entry 2789 (class 1259 OID 33225)
-- Name: fki__urunid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki__urunid ON public.siparisurun USING btree (urun_id);


--
-- TOC entry 2770 (class 1259 OID 33149)
-- Name: fki_adres; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_adres ON public.musteri USING btree (adres);


--
-- TOC entry 2797 (class 1259 OID 33272)
-- Name: fki_adresno; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_adresno ON public.teslimat USING btree (adres_no);


--
-- TOC entry 2780 (class 1259 OID 49462)
-- Name: fki_mgzidfk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_mgzidfk ON public.urun USING btree (magaza_id);


--
-- TOC entry 2771 (class 1259 OID 33283)
-- Name: fki_siparis; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_siparis ON public.musteri USING btree (siparis);


--
-- TOC entry 2806 (class 1259 OID 33266)
-- Name: fki_teslimatno; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_teslimatno ON public.magazayateslimat USING btree (teslimat_no);


--
-- TOC entry 2828 (class 2620 OID 49438)
-- Name: urun ekletrig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER ekletrig AFTER INSERT ON public.urun FOR EACH ROW EXECUTE PROCEDURE public.urunekle();


--
-- TOC entry 2829 (class 2620 OID 49445)
-- Name: urun gunceltrig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER gunceltrig BEFORE UPDATE ON public.urun FOR EACH ROW EXECUTE PROCEDURE public.urunguncel();


--
-- TOC entry 2830 (class 2620 OID 49448)
-- Name: urun silinenurun; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER silinenurun BEFORE DELETE ON public.urun FOR EACH ROW EXECUTE PROCEDURE public.silinenurun();


--
-- TOC entry 2827 (class 2620 OID 49427)
-- Name: urun verify_user_for_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER verify_user_for_update BEFORE UPDATE ON public.urun FOR EACH ROW EXECUTE PROCEDURE public.urunguncel();


--
-- TOC entry 2825 (class 2606 OID 33253)
-- Name: eveteslimat eveteslimat_teslimat_no_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eveteslimat
    ADD CONSTRAINT eveteslimat_teslimat_no_fkey FOREIGN KEY (teslimat_no) REFERENCES public.teslimat(teslimat_no) NOT VALID;


--
-- TOC entry 2822 (class 2606 OID 33191)
-- Name: fatura fatura_adres_no_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fatura
    ADD CONSTRAINT fatura_adres_no_fkey FOREIGN KEY (adres_no) REFERENCES public.adres(adres_no) NOT VALID;


--
-- TOC entry 2824 (class 2606 OID 33208)
-- Name: ilce ilce_il_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ilce
    ADD CONSTRAINT ilce_il_fkey FOREIGN KEY (il) REFERENCES public.il(il_kodu) NOT VALID;


--
-- TOC entry 2826 (class 2606 OID 33261)
-- Name: magazayateslimat magazayateslimat_teslimat_no_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.magazayateslimat
    ADD CONSTRAINT magazayateslimat_teslimat_no_fkey FOREIGN KEY (teslimat_no) REFERENCES public.teslimat(teslimat_no) NOT VALID;


--
-- TOC entry 2816 (class 2606 OID 49457)
-- Name: urun mgzidfk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.urun
    ADD CONSTRAINT mgzidfk FOREIGN KEY (magaza_id) REFERENCES public.magaza(magaza_id) NOT VALID;


--
-- TOC entry 2811 (class 2606 OID 33273)
-- Name: musteri musteri_adres_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.musteri
    ADD CONSTRAINT musteri_adres_fkey FOREIGN KEY (adres) REFERENCES public.adres(adres_no) NOT VALID;


--
-- TOC entry 2813 (class 2606 OID 33284)
-- Name: musteri musteri_kisi_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.musteri
    ADD CONSTRAINT musteri_kisi_id_fkey FOREIGN KEY (kisi_id) REFERENCES public.kisi(kisi_id) NOT VALID;


--
-- TOC entry 2812 (class 2606 OID 33278)
-- Name: musteri musteri_siparis_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.musteri
    ADD CONSTRAINT musteri_siparis_fkey FOREIGN KEY (siparis) REFERENCES public.siparis(siparis_no) NOT VALID;


--
-- TOC entry 2814 (class 2606 OID 33232)
-- Name: personel personel_kisi_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personel
    ADD CONSTRAINT personel_kisi_id_fkey FOREIGN KEY (kisi_id) REFERENCES public.kisi(kisi_id) NOT VALID;


--
-- TOC entry 2815 (class 2606 OID 33238)
-- Name: personel personel_magaza_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personel
    ADD CONSTRAINT personel_magaza_fkey FOREIGN KEY (magaza) REFERENCES public.magaza(magaza_id) NOT VALID;


--
-- TOC entry 2817 (class 2606 OID 33173)
-- Name: siparis siparis_fatura_no_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siparis
    ADD CONSTRAINT siparis_fatura_no_fkey FOREIGN KEY (fatura_no) REFERENCES public.fatura(fatura_no) NOT VALID;


--
-- TOC entry 2818 (class 2606 OID 33179)
-- Name: siparis siparis_musteri_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siparis
    ADD CONSTRAINT siparis_musteri_id_fkey FOREIGN KEY (musteri_id) REFERENCES public.musteri(kisi_id) NOT VALID;


--
-- TOC entry 2819 (class 2606 OID 33185)
-- Name: siparis siparis_satistemsilci_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siparis
    ADD CONSTRAINT siparis_satistemsilci_id_fkey FOREIGN KEY (satistemsilci_id) REFERENCES public.satistemsilcisi(kisi_id) NOT VALID;


--
-- TOC entry 2820 (class 2606 OID 33214)
-- Name: siparisurun siparisurun_siparis_no_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siparisurun
    ADD CONSTRAINT siparisurun_siparis_no_fkey FOREIGN KEY (siparis_no) REFERENCES public.siparis(siparis_no) NOT VALID;


--
-- TOC entry 2821 (class 2606 OID 33220)
-- Name: siparisurun siparisurun_urun_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siparisurun
    ADD CONSTRAINT siparisurun_urun_id_fkey FOREIGN KEY (urun_id) REFERENCES public.urun(urun_id) NOT VALID;


--
-- TOC entry 2823 (class 2606 OID 33267)
-- Name: teslimat teslimat_adres_no_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teslimat
    ADD CONSTRAINT teslimat_adres_no_fkey FOREIGN KEY (adres_no) REFERENCES public.adres(adres_no) NOT VALID;


-- Completed on 2022-12-26 20:47:32

--
-- PostgreSQL database dump complete
--

