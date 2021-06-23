PGDMP          '                y           postgres    13.2    13.2 >    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    13442    postgres    DATABASE     h   CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Spanish_Venezuela.1252';
    DROP DATABASE postgres;
                postgres    false            �           0    0    DATABASE postgres    COMMENT     N   COMMENT ON DATABASE postgres IS 'default administrative connection database';
                   postgres    false    3067                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
                postgres    false            �           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                   postgres    false    4            �           1247    40961    producttype    TYPE     G   CREATE TYPE public.producttype AS ENUM (
    'bien',
    'servicio'
);
    DROP TYPE public.producttype;
       public          postgres    false    4            �            1259    24661    campana    TABLE     �   CREATE TABLE public.campana (
    idcampana integer NOT NULL,
    lider integer,
    nombre character varying(256),
    objetivo double precision,
    recaudado numeric(11,2) DEFAULT 0 NOT NULL
);
    DROP TABLE public.campana;
       public         heap    postgres    false    4            �            1259    24659    campana_idcampana_seq    SEQUENCE     �   CREATE SEQUENCE public.campana_idcampana_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.campana_idcampana_seq;
       public          postgres    false    204    4            �           0    0    campana_idcampana_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.campana_idcampana_seq OWNED BY public.campana.idcampana;
          public          postgres    false    203            �            1259    65595    donacion    TABLE     �   CREATE TABLE public.donacion (
    iddonacion integer NOT NULL,
    idorden integer NOT NULL,
    monto numeric(11,2) NOT NULL
);
    DROP TABLE public.donacion;
       public         heap    postgres    false    4            �            1259    65593    donacion_iddonacion_seq    SEQUENCE     �   CREATE SEQUENCE public.donacion_iddonacion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.donacion_iddonacion_seq;
       public          postgres    false    213    4            �           0    0    donacion_iddonacion_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.donacion_iddonacion_seq OWNED BY public.donacion.iddonacion;
          public          postgres    false    212            �            1259    32770    equipo    TABLE     _   CREATE TABLE public.equipo (
    idcampana integer NOT NULL,
    idusuario integer NOT NULL
);
    DROP TABLE public.equipo;
       public         heap    postgres    false    4            �            1259    65538    orden    TABLE     |   CREATE TABLE public.orden (
    idorden integer NOT NULL,
    idcampana integer NOT NULL,
    idusuario integer NOT NULL
);
    DROP TABLE public.orden;
       public         heap    postgres    false    4            �            1259    65536    orden_idorden_seq    SEQUENCE     �   CREATE SEQUENCE public.orden_idorden_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.orden_idorden_seq;
       public          postgres    false    4    209                        0    0    orden_idorden_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.orden_idorden_seq OWNED BY public.orden.idorden;
          public          postgres    false    208            �            1259    49206    producto    TABLE     �   CREATE TABLE public.producto (
    idproducto integer NOT NULL,
    titulo character varying(255) NOT NULL,
    idcampana integer NOT NULL,
    costo numeric(11,2) NOT NULL,
    tipo public.producttype NOT NULL
);
    DROP TABLE public.producto;
       public         heap    postgres    false    4    647            �            1259    49204    producto_idproducto_seq    SEQUENCE     �   CREATE SEQUENCE public.producto_idproducto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.producto_idproducto_seq;
       public          postgres    false    4    207                       0    0    producto_idproducto_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.producto_idproducto_seq OWNED BY public.producto.idproducto;
          public          postgres    false    206            �            1259    24649    usuario    TABLE     �   CREATE TABLE public.usuario (
    idusuario integer NOT NULL,
    username character varying(50) NOT NULL,
    pass character varying(50) NOT NULL,
    agente boolean,
    lider boolean,
    administrador boolean
);
    DROP TABLE public.usuario;
       public         heap    postgres    false    4            �            1259    24647    usuario_idusuario_seq    SEQUENCE     �   CREATE SEQUENCE public.usuario_idusuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.usuario_idusuario_seq;
       public          postgres    false    4    202                       0    0    usuario_idusuario_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.usuario_idusuario_seq OWNED BY public.usuario.idusuario;
          public          postgres    false    201            �            1259    65582    venta    TABLE     �   CREATE TABLE public.venta (
    idventa integer NOT NULL,
    idorden integer NOT NULL,
    unidades integer NOT NULL,
    titulo character varying(255) NOT NULL,
    costo numeric(11,2) NOT NULL
);
    DROP TABLE public.venta;
       public         heap    postgres    false    4            �            1259    65580    venta_idventa_seq    SEQUENCE     �   CREATE SEQUENCE public.venta_idventa_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.venta_idventa_seq;
       public          postgres    false    211    4                       0    0    venta_idventa_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.venta_idventa_seq OWNED BY public.venta.idventa;
          public          postgres    false    210            I           2604    24664    campana idcampana    DEFAULT     v   ALTER TABLE ONLY public.campana ALTER COLUMN idcampana SET DEFAULT nextval('public.campana_idcampana_seq'::regclass);
 @   ALTER TABLE public.campana ALTER COLUMN idcampana DROP DEFAULT;
       public          postgres    false    204    203    204            N           2604    65598    donacion iddonacion    DEFAULT     z   ALTER TABLE ONLY public.donacion ALTER COLUMN iddonacion SET DEFAULT nextval('public.donacion_iddonacion_seq'::regclass);
 B   ALTER TABLE public.donacion ALTER COLUMN iddonacion DROP DEFAULT;
       public          postgres    false    212    213    213            L           2604    65541    orden idorden    DEFAULT     n   ALTER TABLE ONLY public.orden ALTER COLUMN idorden SET DEFAULT nextval('public.orden_idorden_seq'::regclass);
 <   ALTER TABLE public.orden ALTER COLUMN idorden DROP DEFAULT;
       public          postgres    false    208    209    209            K           2604    49209    producto idproducto    DEFAULT     z   ALTER TABLE ONLY public.producto ALTER COLUMN idproducto SET DEFAULT nextval('public.producto_idproducto_seq'::regclass);
 B   ALTER TABLE public.producto ALTER COLUMN idproducto DROP DEFAULT;
       public          postgres    false    206    207    207            H           2604    24652    usuario idusuario    DEFAULT     v   ALTER TABLE ONLY public.usuario ALTER COLUMN idusuario SET DEFAULT nextval('public.usuario_idusuario_seq'::regclass);
 @   ALTER TABLE public.usuario ALTER COLUMN idusuario DROP DEFAULT;
       public          postgres    false    201    202    202            M           2604    65585    venta idventa    DEFAULT     n   ALTER TABLE ONLY public.venta ALTER COLUMN idventa SET DEFAULT nextval('public.venta_idventa_seq'::regclass);
 <   ALTER TABLE public.venta ALTER COLUMN idventa DROP DEFAULT;
       public          postgres    false    210    211    211            �          0    24661    campana 
   TABLE DATA           P   COPY public.campana (idcampana, lider, nombre, objetivo, recaudado) FROM stdin;
    public          postgres    false    204   xE       �          0    65595    donacion 
   TABLE DATA           >   COPY public.donacion (iddonacion, idorden, monto) FROM stdin;
    public          postgres    false    213   F       �          0    32770    equipo 
   TABLE DATA           6   COPY public.equipo (idcampana, idusuario) FROM stdin;
    public          postgres    false    205   �F       �          0    65538    orden 
   TABLE DATA           >   COPY public.orden (idorden, idcampana, idusuario) FROM stdin;
    public          postgres    false    209   �F       �          0    49206    producto 
   TABLE DATA           N   COPY public.producto (idproducto, titulo, idcampana, costo, tipo) FROM stdin;
    public          postgres    false    207   G       �          0    24649    usuario 
   TABLE DATA           Z   COPY public.usuario (idusuario, username, pass, agente, lider, administrador) FROM stdin;
    public          postgres    false    202   �G       �          0    65582    venta 
   TABLE DATA           J   COPY public.venta (idventa, idorden, unidades, titulo, costo) FROM stdin;
    public          postgres    false    211   �G                  0    0    campana_idcampana_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.campana_idcampana_seq', 10, true);
          public          postgres    false    203                       0    0    donacion_iddonacion_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.donacion_iddonacion_seq', 14, true);
          public          postgres    false    212                       0    0    orden_idorden_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.orden_idorden_seq', 34, true);
          public          postgres    false    208                       0    0    producto_idproducto_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.producto_idproducto_seq', 16, true);
          public          postgres    false    206                       0    0    usuario_idusuario_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.usuario_idusuario_seq', 11, true);
          public          postgres    false    201            	           0    0    venta_idventa_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.venta_idventa_seq', 34, true);
          public          postgres    false    210            T           2606    24666    campana campana_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.campana
    ADD CONSTRAINT campana_pkey PRIMARY KEY (idcampana);
 >   ALTER TABLE ONLY public.campana DROP CONSTRAINT campana_pkey;
       public            postgres    false    204            ^           2606    65600    donacion donacion_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.donacion
    ADD CONSTRAINT donacion_pkey PRIMARY KEY (iddonacion);
 @   ALTER TABLE ONLY public.donacion DROP CONSTRAINT donacion_pkey;
       public            postgres    false    213            V           2606    73864    equipo equipo_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.equipo
    ADD CONSTRAINT equipo_pkey PRIMARY KEY (idcampana, idusuario);
 <   ALTER TABLE ONLY public.equipo DROP CONSTRAINT equipo_pkey;
       public            postgres    false    205    205            Z           2606    65543    orden orden_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.orden
    ADD CONSTRAINT orden_pkey PRIMARY KEY (idorden);
 :   ALTER TABLE ONLY public.orden DROP CONSTRAINT orden_pkey;
       public            postgres    false    209            X           2606    49211    producto producto_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_pkey PRIMARY KEY (idproducto);
 @   ALTER TABLE ONLY public.producto DROP CONSTRAINT producto_pkey;
       public            postgres    false    207            P           2606    24654    usuario usuario_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (idusuario);
 >   ALTER TABLE ONLY public.usuario DROP CONSTRAINT usuario_pkey;
       public            postgres    false    202            R           2606    24656    usuario usuario_username_key 
   CONSTRAINT     [   ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_username_key UNIQUE (username);
 F   ALTER TABLE ONLY public.usuario DROP CONSTRAINT usuario_username_key;
       public            postgres    false    202            \           2606    65587    venta venta_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.venta
    ADD CONSTRAINT venta_pkey PRIMARY KEY (idventa);
 :   ALTER TABLE ONLY public.venta DROP CONSTRAINT venta_pkey;
       public            postgres    false    211            _           2606    24667    campana campana_lider_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.campana
    ADD CONSTRAINT campana_lider_fkey FOREIGN KEY (lider) REFERENCES public.usuario(idusuario);
 D   ALTER TABLE ONLY public.campana DROP CONSTRAINT campana_lider_fkey;
       public          postgres    false    202    204    2896            f           2606    65601    donacion donacion_idorden_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.donacion
    ADD CONSTRAINT donacion_idorden_fkey FOREIGN KEY (idorden) REFERENCES public.orden(idorden);
 H   ALTER TABLE ONLY public.donacion DROP CONSTRAINT donacion_idorden_fkey;
       public          postgres    false    209    213    2906            `           2606    32776    equipo equipo_idcampana_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.equipo
    ADD CONSTRAINT equipo_idcampana_fkey FOREIGN KEY (idcampana) REFERENCES public.campana(idcampana);
 F   ALTER TABLE ONLY public.equipo DROP CONSTRAINT equipo_idcampana_fkey;
       public          postgres    false    205    204    2900            a           2606    32781    equipo equipo_idusuario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.equipo
    ADD CONSTRAINT equipo_idusuario_fkey FOREIGN KEY (idusuario) REFERENCES public.usuario(idusuario);
 F   ALTER TABLE ONLY public.equipo DROP CONSTRAINT equipo_idusuario_fkey;
       public          postgres    false    205    2896    202            c           2606    65544    orden orden_idcampana_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.orden
    ADD CONSTRAINT orden_idcampana_fkey FOREIGN KEY (idcampana) REFERENCES public.campana(idcampana);
 D   ALTER TABLE ONLY public.orden DROP CONSTRAINT orden_idcampana_fkey;
       public          postgres    false    2900    209    204            d           2606    65549    orden orden_idusuario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.orden
    ADD CONSTRAINT orden_idusuario_fkey FOREIGN KEY (idusuario) REFERENCES public.usuario(idusuario);
 D   ALTER TABLE ONLY public.orden DROP CONSTRAINT orden_idusuario_fkey;
       public          postgres    false    209    202    2896            b           2606    49212     producto producto_idcampana_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_idcampana_fkey FOREIGN KEY (idcampana) REFERENCES public.campana(idcampana);
 J   ALTER TABLE ONLY public.producto DROP CONSTRAINT producto_idcampana_fkey;
       public          postgres    false    204    2900    207            e           2606    65588    venta venta_idorden_fkey    FK CONSTRAINT     |   ALTER TABLE ONLY public.venta
    ADD CONSTRAINT venta_idorden_fkey FOREIGN KEY (idorden) REFERENCES public.orden(idorden);
 B   ALTER TABLE ONLY public.venta DROP CONSTRAINT venta_idorden_fkey;
       public          postgres    false    209    211    2906            �   �   x�u��� DϢ
*�l�i"����	��RC��=��&���j9�TXs�
�7�	Q-cj�6�)?�	��?�
�TI���r�F^�E޸Ap�/i�yg����㓞z�$�t=|���.U{9��>>�J��f�n�Z�}��R_eb;�      �   S   x�E��	 1D��XLȨ�`/���! ����s��}D����"��.����
4�J�n�	����`9M�9��x��|���      �   #   x�3�4��4b#.C0��0�2���qqq PGe      �   I   x�%���0�7S;�t��?G	�pBؔm��q�9@(�դ#���xzm����P�A=��r���?��      �   �   x�m���0���S��R%i���J�KzCP���IU	���}�l����NJ(�_κ(�a<�q����	~�JC��WH9.�n\WBK>Q ��Z�{�2zƂ�BeZ��t���Ko�+��6d)���˹B�o92      �   <   x�3�LL��̃�% �eę���W%K8�8ӸL9s2SR��$X�����FA���qqq x��      �   �   x�����0Eg�Y�T�^�t1��*P���:J$KG�\;vP��/���[[�Ф�
�P�hm�1CH�Y�.)�责,���f�rj"��Z ����=�f�i�3��q�S��#:ED@�p�>t���^�y���^�)�������l�y�#���+��5�����Q�e|�iJ#�)�9;�֜ݗ9����&��(���q�     