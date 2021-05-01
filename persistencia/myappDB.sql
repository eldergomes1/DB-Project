PGDMP     )                    y           postgres    13.2    13.2 )    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    13442    postgres    DATABASE     h   CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Spanish_Venezuela.1252';
    DROP DATABASE postgres;
                postgres    false            �           0    0    DATABASE postgres    COMMENT     N   COMMENT ON DATABASE postgres IS 'default administrative connection database';
                   postgres    false    3033                        3079    16384 	   adminpack 	   EXTENSION     A   CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;
    DROP EXTENSION adminpack;
                   false            �           0    0    EXTENSION adminpack    COMMENT     M   COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';
                        false    2            �           1247    40961    producttype    TYPE     G   CREATE TYPE public.producttype AS ENUM (
    'bien',
    'servicio'
);
    DROP TYPE public.producttype;
       public          postgres    false            �            1259    24661    campana    TABLE     �   CREATE TABLE public.campana (
    idcampana integer NOT NULL,
    lider integer,
    nombre character varying(256),
    objetivo double precision
);
    DROP TABLE public.campana;
       public         heap    postgres    false            �            1259    24659    campana_idcampana_seq    SEQUENCE     �   CREATE SEQUENCE public.campana_idcampana_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.campana_idcampana_seq;
       public          postgres    false    204            �           0    0    campana_idcampana_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.campana_idcampana_seq OWNED BY public.campana.idcampana;
          public          postgres    false    203            �            1259    32770    equipo    TABLE     l   CREATE TABLE public.equipo (
    idequipo integer NOT NULL,
    idcampana integer,
    idusuario integer
);
    DROP TABLE public.equipo;
       public         heap    postgres    false            �            1259    32768    equipo_idequipo_seq    SEQUENCE     �   CREATE SEQUENCE public.equipo_idequipo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.equipo_idequipo_seq;
       public          postgres    false    206            �           0    0    equipo_idequipo_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.equipo_idequipo_seq OWNED BY public.equipo.idequipo;
          public          postgres    false    205            �            1259    49206    producto    TABLE     �   CREATE TABLE public.producto (
    idproducto integer NOT NULL,
    titulo character varying(255) NOT NULL,
    idcampana integer NOT NULL,
    costo numeric(11,2) NOT NULL,
    tipo public.producttype NOT NULL
);
    DROP TABLE public.producto;
       public         heap    postgres    false    643            �            1259    49204    producto_idproducto_seq    SEQUENCE     �   CREATE SEQUENCE public.producto_idproducto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.producto_idproducto_seq;
       public          postgres    false    208            �           0    0    producto_idproducto_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.producto_idproducto_seq OWNED BY public.producto.idproducto;
          public          postgres    false    207            �            1259    24649    usuario    TABLE     �   CREATE TABLE public.usuario (
    idusuario integer NOT NULL,
    username character varying(50) NOT NULL,
    pass character varying(50) NOT NULL,
    agente boolean,
    lider boolean,
    administrador boolean
);
    DROP TABLE public.usuario;
       public         heap    postgres    false            �            1259    24647    usuario_idusuario_seq    SEQUENCE     �   CREATE SEQUENCE public.usuario_idusuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.usuario_idusuario_seq;
       public          postgres    false    202            �           0    0    usuario_idusuario_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.usuario_idusuario_seq OWNED BY public.usuario.idusuario;
          public          postgres    false    201            9           2604    24664    campana idcampana    DEFAULT     v   ALTER TABLE ONLY public.campana ALTER COLUMN idcampana SET DEFAULT nextval('public.campana_idcampana_seq'::regclass);
 @   ALTER TABLE public.campana ALTER COLUMN idcampana DROP DEFAULT;
       public          postgres    false    204    203    204            :           2604    32773    equipo idequipo    DEFAULT     r   ALTER TABLE ONLY public.equipo ALTER COLUMN idequipo SET DEFAULT nextval('public.equipo_idequipo_seq'::regclass);
 >   ALTER TABLE public.equipo ALTER COLUMN idequipo DROP DEFAULT;
       public          postgres    false    206    205    206            ;           2604    49209    producto idproducto    DEFAULT     z   ALTER TABLE ONLY public.producto ALTER COLUMN idproducto SET DEFAULT nextval('public.producto_idproducto_seq'::regclass);
 B   ALTER TABLE public.producto ALTER COLUMN idproducto DROP DEFAULT;
       public          postgres    false    207    208    208            8           2604    24652    usuario idusuario    DEFAULT     v   ALTER TABLE ONLY public.usuario ALTER COLUMN idusuario SET DEFAULT nextval('public.usuario_idusuario_seq'::regclass);
 @   ALTER TABLE public.usuario ALTER COLUMN idusuario DROP DEFAULT;
       public          postgres    false    202    201    202            �          0    24661    campana 
   TABLE DATA           E   COPY public.campana (idcampana, lider, nombre, objetivo) FROM stdin;
    public          postgres    false    204   -       �          0    32770    equipo 
   TABLE DATA           @   COPY public.equipo (idequipo, idcampana, idusuario) FROM stdin;
    public          postgres    false    206   �-       �          0    49206    producto 
   TABLE DATA           N   COPY public.producto (idproducto, titulo, idcampana, costo, tipo) FROM stdin;
    public          postgres    false    208   �-       �          0    24649    usuario 
   TABLE DATA           Z   COPY public.usuario (idusuario, username, pass, agente, lider, administrador) FROM stdin;
    public          postgres    false    202    .       �           0    0    campana_idcampana_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.campana_idcampana_seq', 9, true);
          public          postgres    false    203            �           0    0    equipo_idequipo_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.equipo_idequipo_seq', 1, true);
          public          postgres    false    205            �           0    0    producto_idproducto_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.producto_idproducto_seq', 12, true);
          public          postgres    false    207            �           0    0    usuario_idusuario_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.usuario_idusuario_seq', 11, true);
          public          postgres    false    201            A           2606    24666    campana campana_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.campana
    ADD CONSTRAINT campana_pkey PRIMARY KEY (idcampana);
 >   ALTER TABLE ONLY public.campana DROP CONSTRAINT campana_pkey;
       public            postgres    false    204            C           2606    32775    equipo equipo_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.equipo
    ADD CONSTRAINT equipo_pkey PRIMARY KEY (idequipo);
 <   ALTER TABLE ONLY public.equipo DROP CONSTRAINT equipo_pkey;
       public            postgres    false    206            E           2606    49211    producto producto_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_pkey PRIMARY KEY (idproducto);
 @   ALTER TABLE ONLY public.producto DROP CONSTRAINT producto_pkey;
       public            postgres    false    208            =           2606    24654    usuario usuario_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (idusuario);
 >   ALTER TABLE ONLY public.usuario DROP CONSTRAINT usuario_pkey;
       public            postgres    false    202            ?           2606    24656    usuario usuario_username_key 
   CONSTRAINT     [   ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_username_key UNIQUE (username);
 F   ALTER TABLE ONLY public.usuario DROP CONSTRAINT usuario_username_key;
       public            postgres    false    202            F           2606    24667    campana campana_lider_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.campana
    ADD CONSTRAINT campana_lider_fkey FOREIGN KEY (lider) REFERENCES public.usuario(idusuario);
 D   ALTER TABLE ONLY public.campana DROP CONSTRAINT campana_lider_fkey;
       public          postgres    false    204    202    2877            G           2606    32776    equipo equipo_idcampana_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.equipo
    ADD CONSTRAINT equipo_idcampana_fkey FOREIGN KEY (idcampana) REFERENCES public.campana(idcampana);
 F   ALTER TABLE ONLY public.equipo DROP CONSTRAINT equipo_idcampana_fkey;
       public          postgres    false    206    2881    204            H           2606    32781    equipo equipo_idusuario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.equipo
    ADD CONSTRAINT equipo_idusuario_fkey FOREIGN KEY (idusuario) REFERENCES public.usuario(idusuario);
 F   ALTER TABLE ONLY public.equipo DROP CONSTRAINT equipo_idusuario_fkey;
       public          postgres    false    206    2877    202            I           2606    49212     producto producto_idcampana_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_idcampana_fkey FOREIGN KEY (idcampana) REFERENCES public.campana(idcampana);
 J   ALTER TABLE ONLY public.producto DROP CONSTRAINT producto_idcampana_fkey;
       public          postgres    false    2881    204    208            �      x�e��1D�v� m˧	*؋��`�8@�P5�^�=q�4o�/B�ϻ�����<!M&o��,�nZ�:�V��{HP�y
&�r]��ti�-�NF]3���`����Ώ<;��Yv���-�      �      x�3�4�4����� �Y      �   9   x���,05-,O��4�30�L�L��24�,0����e&g�sqc���qqq Td�      �   <   x�3�LL��̃�% �eę���W%K8�8ӸL9s2SR��$X�����FA���qqq x��     