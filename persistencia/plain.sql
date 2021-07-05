--
-- PostgreSQL database dump
--

-- Dumped from database version 13.2
-- Dumped by pg_dump version 13.2

-- Started on 2021-07-05 08:46:57

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
-- TOC entry 2 (class 3079 OID 16384)
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- TOC entry 3068 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


--
-- TOC entry 647 (class 1247 OID 40961)
-- Name: producttype; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.producttype AS ENUM (
    'bien',
    'servicio'
);


ALTER TYPE public.producttype OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 204 (class 1259 OID 24661)
-- Name: campana; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.campana (
    idcampana integer NOT NULL,
    lider integer,
    nombre character varying(256),
    objetivo numeric(11,2) DEFAULT 0 NOT NULL,
    recaudado numeric(11,2) DEFAULT 0 NOT NULL
);


ALTER TABLE public.campana OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 24659)
-- Name: campana_idcampana_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.campana_idcampana_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.campana_idcampana_seq OWNER TO postgres;

--
-- TOC entry 3069 (class 0 OID 0)
-- Dependencies: 203
-- Name: campana_idcampana_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.campana_idcampana_seq OWNED BY public.campana.idcampana;


--
-- TOC entry 213 (class 1259 OID 65595)
-- Name: donacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.donacion (
    iddonacion integer NOT NULL,
    idorden integer NOT NULL,
    monto numeric(11,2) NOT NULL
);


ALTER TABLE public.donacion OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 65593)
-- Name: donacion_iddonacion_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.donacion_iddonacion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.donacion_iddonacion_seq OWNER TO postgres;

--
-- TOC entry 3070 (class 0 OID 0)
-- Dependencies: 212
-- Name: donacion_iddonacion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.donacion_iddonacion_seq OWNED BY public.donacion.iddonacion;


--
-- TOC entry 205 (class 1259 OID 32770)
-- Name: equipo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.equipo (
    idcampana integer NOT NULL,
    idusuario integer NOT NULL
);


ALTER TABLE public.equipo OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 65538)
-- Name: orden; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orden (
    idorden integer NOT NULL,
    idcampana integer NOT NULL,
    idusuario integer NOT NULL
);


ALTER TABLE public.orden OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 65536)
-- Name: orden_idorden_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orden_idorden_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orden_idorden_seq OWNER TO postgres;

--
-- TOC entry 3071 (class 0 OID 0)
-- Dependencies: 208
-- Name: orden_idorden_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orden_idorden_seq OWNED BY public.orden.idorden;


--
-- TOC entry 207 (class 1259 OID 49206)
-- Name: producto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.producto (
    idproducto integer NOT NULL,
    titulo character varying(255) NOT NULL,
    idcampana integer NOT NULL,
    costo numeric(11,2) NOT NULL,
    tipo public.producttype NOT NULL
);


ALTER TABLE public.producto OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 49204)
-- Name: producto_idproducto_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.producto_idproducto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.producto_idproducto_seq OWNER TO postgres;

--
-- TOC entry 3072 (class 0 OID 0)
-- Dependencies: 206
-- Name: producto_idproducto_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.producto_idproducto_seq OWNED BY public.producto.idproducto;


--
-- TOC entry 202 (class 1259 OID 24649)
-- Name: usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario (
    idusuario integer NOT NULL,
    username character varying(50) NOT NULL,
    pass character varying(50) NOT NULL,
    agente boolean NOT NULL,
    lider boolean NOT NULL,
    administrador boolean NOT NULL
);


ALTER TABLE public.usuario OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 24647)
-- Name: usuario_idusuario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuario_idusuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usuario_idusuario_seq OWNER TO postgres;

--
-- TOC entry 3073 (class 0 OID 0)
-- Dependencies: 201
-- Name: usuario_idusuario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuario_idusuario_seq OWNED BY public.usuario.idusuario;


--
-- TOC entry 211 (class 1259 OID 65582)
-- Name: venta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.venta (
    idventa integer NOT NULL,
    idorden integer NOT NULL,
    unidades integer NOT NULL,
    titulo character varying(255) NOT NULL,
    costo numeric(11,2) NOT NULL
);


ALTER TABLE public.venta OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 65580)
-- Name: venta_idventa_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.venta_idventa_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.venta_idventa_seq OWNER TO postgres;

--
-- TOC entry 3074 (class 0 OID 0)
-- Dependencies: 210
-- Name: venta_idventa_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.venta_idventa_seq OWNED BY public.venta.idventa;


--
-- TOC entry 2889 (class 2604 OID 24664)
-- Name: campana idcampana; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campana ALTER COLUMN idcampana SET DEFAULT nextval('public.campana_idcampana_seq'::regclass);


--
-- TOC entry 2895 (class 2604 OID 65598)
-- Name: donacion iddonacion; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donacion ALTER COLUMN iddonacion SET DEFAULT nextval('public.donacion_iddonacion_seq'::regclass);


--
-- TOC entry 2893 (class 2604 OID 65541)
-- Name: orden idorden; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden ALTER COLUMN idorden SET DEFAULT nextval('public.orden_idorden_seq'::regclass);


--
-- TOC entry 2892 (class 2604 OID 49209)
-- Name: producto idproducto; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto ALTER COLUMN idproducto SET DEFAULT nextval('public.producto_idproducto_seq'::regclass);


--
-- TOC entry 2888 (class 2604 OID 24652)
-- Name: usuario idusuario; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario ALTER COLUMN idusuario SET DEFAULT nextval('public.usuario_idusuario_seq'::regclass);


--
-- TOC entry 2894 (class 2604 OID 65585)
-- Name: venta idventa; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta ALTER COLUMN idventa SET DEFAULT nextval('public.venta_idventa_seq'::regclass);


--
-- TOC entry 3053 (class 0 OID 24661)
-- Dependencies: 204
-- Data for Name: campana; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.campana (idcampana, lider, nombre, objetivo, recaudado) FROM stdin;
14	13	adopta un perro	500000.00	10.00
13	13	niños con cancer	1000.00	36.00
\.


--
-- TOC entry 3062 (class 0 OID 65595)
-- Dependencies: 213
-- Data for Name: donacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.donacion (iddonacion, idorden, monto) FROM stdin;
19	45	2.00
20	46	10.00
21	47	5.00
\.


--
-- TOC entry 3054 (class 0 OID 32770)
-- Dependencies: 205
-- Data for Name: equipo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.equipo (idcampana, idusuario) FROM stdin;
13	13
13	14
14	13
\.


--
-- TOC entry 3058 (class 0 OID 65538)
-- Dependencies: 209
-- Data for Name: orden; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orden (idorden, idcampana, idusuario) FROM stdin;
45	13	14
46	14	13
47	13	13
\.


--
-- TOC entry 3056 (class 0 OID 49206)
-- Dependencies: 207
-- Data for Name: producto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.producto (idproducto, titulo, idcampana, costo, tipo) FROM stdin;
21	camisa alusiva a la causa	13	12.00	bien
22	boletos para concierto	13	5.00	bien
\.


--
-- TOC entry 3051 (class 0 OID 24649)
-- Dependencies: 202
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuario (idusuario, username, pass, agente, lider, administrador) FROM stdin;
13	admin	admin	t	t	t
14	agent	agent	t	f	f
\.


--
-- TOC entry 3060 (class 0 OID 65582)
-- Dependencies: 211
-- Data for Name: venta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.venta (idventa, idorden, unidades, titulo, costo) FROM stdin;
55	45	0	camisa alusiva a la causa	12.00
56	45	0	boletos para concierto	5.00
57	47	0	camisa alusiva a la causa	12.00
\.


--
-- TOC entry 3075 (class 0 OID 0)
-- Dependencies: 203
-- Name: campana_idcampana_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.campana_idcampana_seq', 14, true);


--
-- TOC entry 3076 (class 0 OID 0)
-- Dependencies: 212
-- Name: donacion_iddonacion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.donacion_iddonacion_seq', 21, true);


--
-- TOC entry 3077 (class 0 OID 0)
-- Dependencies: 208
-- Name: orden_idorden_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orden_idorden_seq', 47, true);


--
-- TOC entry 3078 (class 0 OID 0)
-- Dependencies: 206
-- Name: producto_idproducto_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.producto_idproducto_seq', 22, true);


--
-- TOC entry 3079 (class 0 OID 0)
-- Dependencies: 201
-- Name: usuario_idusuario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuario_idusuario_seq', 18, true);


--
-- TOC entry 3080 (class 0 OID 0)
-- Dependencies: 210
-- Name: venta_idventa_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.venta_idventa_seq', 57, true);


--
-- TOC entry 2901 (class 2606 OID 24666)
-- Name: campana campana_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campana
    ADD CONSTRAINT campana_pkey PRIMARY KEY (idcampana);


--
-- TOC entry 2911 (class 2606 OID 65600)
-- Name: donacion donacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donacion
    ADD CONSTRAINT donacion_pkey PRIMARY KEY (iddonacion);


--
-- TOC entry 2903 (class 2606 OID 73864)
-- Name: equipo equipo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipo
    ADD CONSTRAINT equipo_pkey PRIMARY KEY (idcampana, idusuario);


--
-- TOC entry 2907 (class 2606 OID 65543)
-- Name: orden orden_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden
    ADD CONSTRAINT orden_pkey PRIMARY KEY (idorden);


--
-- TOC entry 2905 (class 2606 OID 49211)
-- Name: producto producto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_pkey PRIMARY KEY (idproducto);


--
-- TOC entry 2897 (class 2606 OID 24654)
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (idusuario);


--
-- TOC entry 2899 (class 2606 OID 24656)
-- Name: usuario usuario_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_username_key UNIQUE (username);


--
-- TOC entry 2909 (class 2606 OID 65587)
-- Name: venta venta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta
    ADD CONSTRAINT venta_pkey PRIMARY KEY (idventa);


--
-- TOC entry 2912 (class 2606 OID 24667)
-- Name: campana campana_lider_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.campana
    ADD CONSTRAINT campana_lider_fkey FOREIGN KEY (lider) REFERENCES public.usuario(idusuario);


--
-- TOC entry 2919 (class 2606 OID 65601)
-- Name: donacion donacion_idorden_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donacion
    ADD CONSTRAINT donacion_idorden_fkey FOREIGN KEY (idorden) REFERENCES public.orden(idorden);


--
-- TOC entry 2913 (class 2606 OID 32776)
-- Name: equipo equipo_idcampana_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipo
    ADD CONSTRAINT equipo_idcampana_fkey FOREIGN KEY (idcampana) REFERENCES public.campana(idcampana);


--
-- TOC entry 2914 (class 2606 OID 32781)
-- Name: equipo equipo_idusuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipo
    ADD CONSTRAINT equipo_idusuario_fkey FOREIGN KEY (idusuario) REFERENCES public.usuario(idusuario);


--
-- TOC entry 2916 (class 2606 OID 65544)
-- Name: orden orden_idcampana_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden
    ADD CONSTRAINT orden_idcampana_fkey FOREIGN KEY (idcampana) REFERENCES public.campana(idcampana);


--
-- TOC entry 2917 (class 2606 OID 65549)
-- Name: orden orden_idusuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden
    ADD CONSTRAINT orden_idusuario_fkey FOREIGN KEY (idusuario) REFERENCES public.usuario(idusuario);


--
-- TOC entry 2915 (class 2606 OID 49212)
-- Name: producto producto_idcampana_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_idcampana_fkey FOREIGN KEY (idcampana) REFERENCES public.campana(idcampana);


--
-- TOC entry 2918 (class 2606 OID 65588)
-- Name: venta venta_idorden_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venta
    ADD CONSTRAINT venta_idorden_fkey FOREIGN KEY (idorden) REFERENCES public.orden(idorden);


-- Completed on 2021-07-05 08:46:57

--
-- PostgreSQL database dump complete
--

