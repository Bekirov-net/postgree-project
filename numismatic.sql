--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5 (Ubuntu 14.5-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.5 (Ubuntu 14.5-0ubuntu0.22.04.1)

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
-- Name: most_active_purchaser(integer); Type: FUNCTION; Schema: public; Owner: gb_user
--

CREATE FUNCTION public.most_active_purchaser(user_id integer, OUT id bigint, OUT count_send_massages bigint) RETURNS record
    LANGUAGE sql
    AS $$
SELECT 
	from_user_id,
	(COUNT(*))
	FROM messages
	where body = 'куплю монеты золотые'
GROUP BY from_user_id
ORDER BY COUNT(*) DESC
$$;


ALTER FUNCTION public.most_active_purchaser(user_id integer, OUT id bigint, OUT count_send_massages bigint) OWNER TO gb_user;

--
-- Name: update_owner_photo_trigger(); Type: FUNCTION; Schema: public; Owner: gb_user
--

CREATE FUNCTION public.update_owner_photo_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE new_owner_id INTEGER;
 BEGIN
      new_owner_id := (SELECT owner_id FROM photo WHERE photo_id = NEW.obverse_id);
      IF new_owner_id IS NOT NULL AND NEW.user_id != new_owner_id THEN
                    RAISE EXCEPTION 'Error: Photo does not belong to this user';
END IF;
RETURN NEW;
END
$$;


ALTER FUNCTION public.update_owner_photo_trigger() OWNER TO gb_user;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: communities; Type: TABLE; Schema: public; Owner: gb_user
--

CREATE TABLE public.communities (
    community_id integer NOT NULL,
    community_name character varying(120),
    creator_id integer NOT NULL,
    created_at timestamp without time zone
);


ALTER TABLE public.communities OWNER TO gb_user;

--
-- Name: communities_users; Type: TABLE; Schema: public; Owner: gb_user
--

CREATE TABLE public.communities_users (
    community_user_id integer NOT NULL,
    user_id integer NOT NULL,
    community_id integer,
    get_in timestamp without time zone NOT NULL
);


ALTER TABLE public.communities_users OWNER TO gb_user;

--
-- Name: users; Type: TABLE; Schema: public; Owner: gb_user
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    nik_name character varying(20) NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    email character varying(120) NOT NULL,
    logo integer,
    created_at timestamp without time zone
);


ALTER TABLE public.users OWNER TO gb_user;

--
-- Name: buyers_view; Type: VIEW; Schema: public; Owner: gb_user
--

CREATE VIEW public.buyers_view AS
 SELECT concat(users.first_name, ' ', users.last_name) AS "Покупатель",
    users.email AS "Почта",
    communities.community_name AS "В сообществе"
   FROM ((public.users
     LEFT JOIN public.communities_users ON ((communities_users.user_id = users.user_id)))
     LEFT JOIN public.communities ON ((communities.community_id = communities_users.community_id)))
  WHERE ((communities.community_name)::text = 'Куплю монеты'::text);


ALTER TABLE public.buyers_view OWNER TO gb_user;

--
-- Name: coins; Type: TABLE; Schema: public; Owner: gb_user
--

CREATE TABLE public.coins (
    coin_id integer NOT NULL,
    user_id integer NOT NULL,
    denomination character varying(180) NOT NULL,
    country_id integer NOT NULL,
    series_id integer NOT NULL,
    year integer,
    conditions_id integer NOT NULL,
    obverse_id integer,
    reverse_id integer,
    edge_id integer,
    video_id integer,
    mint_id integer,
    circulation integer,
    amount integer NOT NULL,
    description character varying(250)
);


ALTER TABLE public.coins OWNER TO gb_user;

--
-- Name: coins_coin_id_seq; Type: SEQUENCE; Schema: public; Owner: gb_user
--

CREATE SEQUENCE public.coins_coin_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.coins_coin_id_seq OWNER TO gb_user;

--
-- Name: coins_coin_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gb_user
--

ALTER SEQUENCE public.coins_coin_id_seq OWNED BY public.coins.coin_id;


--
-- Name: communities_community_id_seq; Type: SEQUENCE; Schema: public; Owner: gb_user
--

CREATE SEQUENCE public.communities_community_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.communities_community_id_seq OWNER TO gb_user;

--
-- Name: communities_community_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gb_user
--

ALTER SEQUENCE public.communities_community_id_seq OWNED BY public.communities.community_id;


--
-- Name: communities_users_community_user_id_seq; Type: SEQUENCE; Schema: public; Owner: gb_user
--

CREATE SEQUENCE public.communities_users_community_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.communities_users_community_user_id_seq OWNER TO gb_user;

--
-- Name: communities_users_community_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gb_user
--

ALTER SEQUENCE public.communities_users_community_user_id_seq OWNED BY public.communities_users.community_user_id;


--
-- Name: conditions; Type: TABLE; Schema: public; Owner: gb_user
--

CREATE TABLE public.conditions (
    conditions_id integer NOT NULL,
    conditions_status character varying(120) NOT NULL
);


ALTER TABLE public.conditions OWNER TO gb_user;

--
-- Name: conditions_conditions_id_seq; Type: SEQUENCE; Schema: public; Owner: gb_user
--

CREATE SEQUENCE public.conditions_conditions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.conditions_conditions_id_seq OWNER TO gb_user;

--
-- Name: conditions_conditions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gb_user
--

ALTER SEQUENCE public.conditions_conditions_id_seq OWNED BY public.conditions.conditions_id;


--
-- Name: countries; Type: TABLE; Schema: public; Owner: gb_user
--

CREATE TABLE public.countries (
    country_id integer NOT NULL,
    country_name character varying(250) NOT NULL
);


ALTER TABLE public.countries OWNER TO gb_user;

--
-- Name: countries_country_id_seq; Type: SEQUENCE; Schema: public; Owner: gb_user
--

CREATE SEQUENCE public.countries_country_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.countries_country_id_seq OWNER TO gb_user;

--
-- Name: countries_country_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gb_user
--

ALTER SEQUENCE public.countries_country_id_seq OWNED BY public.countries.country_id;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: gb_user
--

CREATE TABLE public.messages (
    message_id integer NOT NULL,
    from_user_id integer NOT NULL,
    to_user_id integer NOT NULL,
    body text,
    created_at timestamp without time zone
);


ALTER TABLE public.messages OWNER TO gb_user;

--
-- Name: last_offer_messages; Type: VIEW; Schema: public; Owner: gb_user
--

CREATE VIEW public.last_offer_messages AS
 SELECT messages.message_id,
    messages.from_user_id,
    messages.to_user_id,
    messages.body,
    messages.created_at
   FROM public.messages
  WHERE ((messages.body = 'куплю монеты золотые'::text) AND (messages.created_at > (CURRENT_TIMESTAMP - '1 mon'::interval)));


ALTER TABLE public.last_offer_messages OWNER TO gb_user;

--
-- Name: messages_message_id_seq; Type: SEQUENCE; Schema: public; Owner: gb_user
--

CREATE SEQUENCE public.messages_message_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.messages_message_id_seq OWNER TO gb_user;

--
-- Name: messages_message_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gb_user
--

ALTER SEQUENCE public.messages_message_id_seq OWNED BY public.messages.message_id;


--
-- Name: mints; Type: TABLE; Schema: public; Owner: gb_user
--

CREATE TABLE public.mints (
    mint_id integer NOT NULL,
    mint_name character varying(180) NOT NULL
);


ALTER TABLE public.mints OWNER TO gb_user;

--
-- Name: mints_mint_id_seq; Type: SEQUENCE; Schema: public; Owner: gb_user
--

CREATE SEQUENCE public.mints_mint_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mints_mint_id_seq OWNER TO gb_user;

--
-- Name: mints_mint_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gb_user
--

ALTER SEQUENCE public.mints_mint_id_seq OWNED BY public.mints.mint_id;


--
-- Name: photo; Type: TABLE; Schema: public; Owner: gb_user
--

CREATE TABLE public.photo (
    photo_id integer NOT NULL,
    url character varying(250) NOT NULL,
    owner_id integer NOT NULL,
    description character varying(250) NOT NULL,
    uploaded_at timestamp without time zone NOT NULL,
    size integer NOT NULL
);


ALTER TABLE public.photo OWNER TO gb_user;

--
-- Name: photo_photo_id_seq; Type: SEQUENCE; Schema: public; Owner: gb_user
--

CREATE SEQUENCE public.photo_photo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.photo_photo_id_seq OWNER TO gb_user;

--
-- Name: photo_photo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gb_user
--

ALTER SEQUENCE public.photo_photo_id_seq OWNED BY public.photo.photo_id;


--
-- Name: series; Type: TABLE; Schema: public; Owner: gb_user
--

CREATE TABLE public.series (
    series_id integer NOT NULL,
    series_name character varying(250) NOT NULL
);


ALTER TABLE public.series OWNER TO gb_user;

--
-- Name: series_series_id_seq; Type: SEQUENCE; Schema: public; Owner: gb_user
--

CREATE SEQUENCE public.series_series_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.series_series_id_seq OWNER TO gb_user;

--
-- Name: series_series_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gb_user
--

ALTER SEQUENCE public.series_series_id_seq OWNED BY public.series.series_id;


--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: gb_user
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_user_id_seq OWNER TO gb_user;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gb_user
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- Name: video; Type: TABLE; Schema: public; Owner: gb_user
--

CREATE TABLE public.video (
    video_id integer NOT NULL,
    url character varying(250) NOT NULL,
    owner_id integer NOT NULL,
    description character varying(250) NOT NULL,
    uploaded_at timestamp without time zone NOT NULL,
    size integer NOT NULL
);


ALTER TABLE public.video OWNER TO gb_user;

--
-- Name: video_video_id_seq; Type: SEQUENCE; Schema: public; Owner: gb_user
--

CREATE SEQUENCE public.video_video_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.video_video_id_seq OWNER TO gb_user;

--
-- Name: video_video_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gb_user
--

ALTER SEQUENCE public.video_video_id_seq OWNED BY public.video.video_id;


--
-- Name: coins coin_id; Type: DEFAULT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.coins ALTER COLUMN coin_id SET DEFAULT nextval('public.coins_coin_id_seq'::regclass);


--
-- Name: communities community_id; Type: DEFAULT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.communities ALTER COLUMN community_id SET DEFAULT nextval('public.communities_community_id_seq'::regclass);


--
-- Name: communities_users community_user_id; Type: DEFAULT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.communities_users ALTER COLUMN community_user_id SET DEFAULT nextval('public.communities_users_community_user_id_seq'::regclass);


--
-- Name: conditions conditions_id; Type: DEFAULT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.conditions ALTER COLUMN conditions_id SET DEFAULT nextval('public.conditions_conditions_id_seq'::regclass);


--
-- Name: countries country_id; Type: DEFAULT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.countries ALTER COLUMN country_id SET DEFAULT nextval('public.countries_country_id_seq'::regclass);


--
-- Name: messages message_id; Type: DEFAULT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.messages ALTER COLUMN message_id SET DEFAULT nextval('public.messages_message_id_seq'::regclass);


--
-- Name: mints mint_id; Type: DEFAULT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.mints ALTER COLUMN mint_id SET DEFAULT nextval('public.mints_mint_id_seq'::regclass);


--
-- Name: photo photo_id; Type: DEFAULT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.photo ALTER COLUMN photo_id SET DEFAULT nextval('public.photo_photo_id_seq'::regclass);


--
-- Name: series series_id; Type: DEFAULT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.series ALTER COLUMN series_id SET DEFAULT nextval('public.series_series_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Name: video video_id; Type: DEFAULT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.video ALTER COLUMN video_id SET DEFAULT nextval('public.video_video_id_seq'::regclass);


--
-- Data for Name: coins; Type: TABLE DATA; Schema: public; Owner: gb_user
--

COPY public.coins (coin_id, user_id, denomination, country_id, series_id, year, conditions_id, obverse_id, reverse_id, edge_id, video_id, mint_id, circulation, amount, description) FROM stdin;
800	1	5	2	20	1992	4	555	514	563	309	6	1000000	6	драгметал
801	1	2	1	30	1970	4	514	505	504	373	8	1000	4	золото
802	2	5	4	10	1964	2	558	516	541	302	4	10000	7	золото
803	10	5	6	20	1993	2	577	521	519	321	2	10000	6	позолота
804	22	5	1	30	1942	4	548	514	551	301	5	10000	1	драгметал
805	22	25	1	30	1991	3	511	555	559	353	1	10000	10	золото
806	30	5	6	20	2016	3	550	567	520	384	4	1000000	8	чермет
807	10	10	2	40	1980	3	505	580	504	381	5	1000000	4	чермет
808	15	25	4	30	1937	4	512	560	504	369	2	1000000	1	чермет
809	80	2	2	30	1908	5	582	518	501	365	5	1000	4	позолота
810	80	1	5	40	1906	5	511	594	543	394	1	1000000	2	серебро
811	80	1	5	30	2021	1	527	527	540	307	5	10000	8	серебро
812	80	25	2	30	2003	2	551	558	586	391	1	10000	1	золото
813	90	10	5	20	1980	5	553	584	515	319	7	10000	7	золото
814	99	10	4	20	1935	2	504	597	519	399	7	10000	2	драгметал
815	1	5	3	30	1931	1	532	554	505	378	6	1000000	10	позолота
816	1	2	4	30	1969	1	574	543	580	370	7	1000000	8	серебро
817	5	1	6	20	2017	3	551	521	505	392	2	10000	7	драгметал
818	50	2	4	20	1953	2	597	559	531	394	3	10000	1	чермет
819	50	25	5	40	2020	2	534	521	581	301	4	1000	3	драгметал
821	50	2	5	30	2022	3	518	558	559	388	1	1000	5	биметал
822	44	1	5	30	1974	3	530	563	556	366	8	10000	9	позолота
823	44	5	2	30	1945	5	532	592	592	354	5	10000	9	драгметал
824	44	25	2	10	2000	2	593	532	590	384	6	10000	7	драгметал
825	20	25	5	20	1980	2	501	593	593	362	2	1000	0	чермет
826	33	2	5	30	2000	3	574	554	531	334	6	10000	9	драгметал
828	31	25	4	30	1909	1	579	511	529	305	6	1000	9	драгметал
827	32	10	2	20	1984	3	558	595	580	315	7	1000000	9	драгметал
829	33	10	4	10	1924	3	507	590	511	309	2	1000	1	драгметал
830	34	25	2	30	1924	4	546	543	516	327	8	10000	3	позолота
840	35	5	3	10	1947	3	584	561	549	306	7	10000	10	золото
841	36	2	3	40	2002	2	503	595	533	315	6	10000	5	драгметал
842	37	25	1	10	1957	4	597	585	596	349	6	10000	10	чермет
843	38	25	3	40	1927	4	564	594	521	376	7	1000	7	серебро
844	38	10	4	10	1980	1	545	534	593	351	2	10000	6	серебро
845	38	10	3	40	1989	3	502	530	589	355	2	1000000	9	золото
846	39	2	2	20	2012	4	581	573	577	377	5	1000	5	биметал
847	39	10	5	10	2000	4	571	527	543	379	7	10000	9	позолота
848	40	25	2	40	1993	3	554	598	557	399	7	10000	4	позолота
831	41	1	3	20	1964	3	596	514	561	349	3	1000000	0	серебро
832	41	5	2	20	2008	2	502	589	545	386	5	1000000	6	биметал
833	42	2	6	20	2010	1	544	527	564	300	8	10000	3	позолота
834	43	10	2	20	2020	1	564	504	529	376	1	10000	5	биметал
835	44	10	5	20	1920	2	525	532	549	393	7	1000	7	позолота
836	45	25	2	20	1917	2	539	542	515	386	3	10000	9	драгметал
837	45	25	1	20	2015	2	509	588	585	351	4	1000	0	чермет
838	60	5	4	30	1939	4	557	523	569	388	5	10000	1	чермет
839	60	25	3	20	1964	3	593	583	524	328	7	10000	5	драгметал
850	60	10	4	30	2009	5	558	561	566	355	4	10000	6	золото
851	61	1	3	30	2017	3	510	575	532	385	6	1000	3	серебро
852	62	5	6	20	1944	3	587	569	558	391	4	10000	9	серебро
853	62	2	3	40	1927	2	523	555	513	370	3	10000	9	позолота
854	62	2	2	30	1992	2	569	571	576	305	1	10000	3	драгметал
855	63	5	3	30	1960	3	544	551	588	317	7	10000	4	драгметал
856	64	5	2	20	1923	1	505	567	501	353	5	10000	6	драгметал
857	65	25	3	20	1906	1	590	516	586	357	7	10000	1	драгметал
858	66	10	3	20	1947	2	515	523	584	348	5	10000	8	чермет
859	67	2	2	30	1971	1	581	531	572	395	2	10000	4	драгметал
860	68	25	2	30	1987	2	562	545	588	308	4	1000000	4	чермет
871	70	2	6	20	1984	3	555	559	589	350	2	1000	5	чермет
872	71	2	3	30	1913	4	537	559	596	320	3	10000	8	чермет
873	72	10	3	30	1984	2	520	501	579	320	3	10000	8	чермет
874	73	1	6	10	2004	5	559	566	503	339	3	1000000	4	золото
875	74	10	4	30	1990	2	584	554	517	320	6	1000	7	чермет
876	75	10	2	30	1970	2	503	585	510	359	2	1000000	8	чермет
877	75	5	2	30	1919	2	545	511	565	356	5	10000	7	золото
878	75	2	4	30	2023	2	573	574	511	330	5	1000	5	серебро
879	75	25	4	10	1998	1	548	556	574	364	7	10000	3	чермет
880	75	5	4	10	1946	2	519	516	561	352	2	10000	7	драгметал
881	75	5	4	30	2012	2	560	591	587	388	4	1000	7	серебро
883	80	1	3	30	1954	3	591	568	545	366	6	10000	2	золото
884	81	2	1	40	1909	3	593	540	585	347	1	1000000	7	позолота
885	82	25	2	10	1902	4	513	586	563	329	6	1000	5	серебро
886	82	10	3	10	1951	2	534	533	576	396	2	1000000	3	чермет
887	83	25	5	30	1986	5	504	549	540	329	7	1000	8	драгметал
888	84	2	3	10	1911	2	559	531	586	340	6	10000	9	биметал
889	84	5	5	30	2023	2	552	545	500	338	5	10000	6	чермет
820	50	2	5	10	1906	3	586	528	534	385	5	1000000	4	золото
890	85	5	2	30	1952	1	501	592	524	331	4	10000	7	серебро
891	85	10	3	30	1947	2	560	573	555	358	8	10000	0	золото
892	90	25	1	30	2000	4	579	532	567	364	7	1000	1	драгметал
893	90	2	5	30	1960	2	528	521	528	326	5	1000000	4	драгметал
894	91	1	5	30	1974	2	512	507	534	360	2	1000000	6	драгметал
895	91	10	3	10	1984	4	523	522	558	313	3	10000	2	серебро
896	92	10	6	30	1902	2	596	594	545	379	2	1000000	1	драгметал
897	91	5	5	10	1985	2	519	572	538	348	2	1000	5	биметал
898	91	2	5	20	1911	2	547	557	515	337	7	10000	2	чермет
899	91	1	2	40	1950	4	502	596	543	378	5	10000	2	серебро
861	91	25	3	20	2017	3	506	553	508	334	4	10000	9	позолота
862	91	5	3	40	1955	5	536	523	537	305	5	10000	3	золото
863	1	10	1	20	1944	2	562	562	525	346	6	1000	5	серебро
864	1	10	4	20	2014	2	565	593	529	359	5	10000	1	чермет
865	1	5	2	30	1908	4	517	597	541	363	3	1000000	7	биметал
866	5	10	3	30	1974	4	597	551	545	386	6	10000	5	золото
867	5	2	4	30	2006	4	524	584	531	399	4	1000	2	золото
868	6	25	1	20	1979	2	589	598	526	359	8	1000000	5	серебро
869	7	1	2	30	1907	3	570	570	520	363	6	1000000	8	чермет
882	75	10	2	10	2015	4	548	560	521	326	6	1000000	1	серебро
\.


--
-- Data for Name: communities; Type: TABLE DATA; Schema: public; Owner: gb_user
--

COPY public.communities (community_id, community_name, creator_id, created_at) FROM stdin;
51	Обмен	77	2023-08-08 00:00:00
52	Пообщаемся_обо_всем	73	2021-10-05 00:00:00
54	Уход_за_монетами	12	2022-03-07 00:00:00
50	Куплю монеты	72	2022-08-28 00:00:00
53	Продам монеты	45	2021-12-13 00:00:00
\.


--
-- Data for Name: communities_users; Type: TABLE DATA; Schema: public; Owner: gb_user
--

COPY public.communities_users (community_user_id, user_id, community_id, get_in) FROM stdin;
2062	52	52	2022-04-05 00:00:00
2196	39	51	2023-04-04 00:00:00
2041	43	53	2022-11-01 00:00:00
2170	78	54	2023-06-24 00:00:00
2188	16	50	2022-10-16 00:00:00
2131	32	50	2021-12-29 00:00:00
2110	64	52	2023-04-02 00:00:00
2165	16	51	2021-12-01 00:00:00
2189	83	52	2022-12-18 00:00:00
2118	74	52	2021-12-30 00:00:00
2999	15	51	2022-04-15 00:00:00
2973	49	51	2021-12-30 00:00:00
2945	8	53	2022-04-09 00:00:00
2053	94	53	2021-12-14 00:00:00
2059	35	53	2022-02-20 00:00:00
2135	33	52	2023-02-08 00:00:00
2067	21	52	2022-09-07 00:00:00
2036	21	51	2023-05-11 00:00:00
2100	28	51	2023-02-06 00:00:00
2088	26	52	2021-10-19 00:00:00
2068	16	52	2021-10-18 00:00:00
2926	91	52	2022-04-19 00:00:00
2163	26	53	2023-05-22 00:00:00
2149	70	53	2022-06-25 00:00:00
2099	67	52	2023-02-02 00:00:00
2998	50	52	2022-06-14 00:00:00
2414	9	53	2022-01-03 00:00:00
2115	55	52	2021-12-28 00:00:00
2006	11	53	2022-02-01 00:00:00
2044	25	53	2023-08-11 00:00:00
2050	24	52	2022-07-29 00:00:00
2055	72	53	2022-08-22 00:00:00
2980	74	53	2022-03-06 00:00:00
2074	16	52	2021-12-09 00:00:00
2005	84	52	2023-09-08 00:00:00
2084	91	53	2021-10-02 00:00:00
2126	91	51	2021-10-08 00:00:00
2063	87	53	2022-08-30 00:00:00
2166	83	51	2023-09-03 00:00:00
2082	77	51	2022-06-05 00:00:00
2982	70	52	2023-06-10 00:00:00
2190	77	52	2022-03-09 00:00:00
2788	26	52	2022-01-31 00:00:00
2001	5	53	2022-04-18 00:00:00
2054	10	54	2023-05-23 00:00:00
2344	53	51	2022-07-11 00:00:00
2128	13	52	2021-11-29 00:00:00
2195	91	51	2022-06-22 00:00:00
2199	5	51	2022-02-23 00:00:00
2080	52	52	2022-11-24 00:00:00
2541	19	53	2022-07-31 00:00:00
2121	56	51	2023-08-07 00:00:00
2113	23	52	2022-04-10 00:00:00
2037	89	52	2022-06-29 00:00:00
2146	4	50	2022-11-16 00:00:00
2540	18	54	2021-11-06 00:00:00
2143	14	52	2022-07-19 00:00:00
2514	90	52	2022-01-19 00:00:00
2079	76	51	2022-05-10 00:00:00
2014	62	54	2023-08-05 00:00:00
2159	79	52	2023-02-05 00:00:00
2246	16	53	2023-02-08 00:00:00
2021	95	53	2022-08-14 00:00:00
2033	31	53	2021-11-18 00:00:00
2263	70	52	2023-09-12 00:00:00
2271	22	50	2023-05-12 00:00:00
2144	47	51	2022-09-11 00:00:00
2254	22	51	2023-06-29 00:00:00
2114	83	52	2023-01-21 00:00:00
2051	32	52	2023-03-24 00:00:00
2207	83	50	2023-08-02 00:00:00
2299	20	52	2023-04-09 00:00:00
2134	96	51	2021-11-06 00:00:00
2181	55	54	2023-04-18 00:00:00
2228	61	50	2022-09-07 00:00:00
2272	71	53	2023-06-05 00:00:00
2097	7	54	2023-08-09 00:00:00
2035	4	53	2023-05-03 00:00:00
2240	86	53	2022-11-07 00:00:00
2122	12	53	2022-10-14 00:00:00
2996	51	51	2022-05-08 00:00:00
2048	90	51	2022-08-15 00:00:00
2761	72	53	2023-06-11 00:00:00
2779	68	53	2022-05-29 00:00:00
2791	14	52	2021-09-28 00:00:00
2817	43	53	2022-05-05 00:00:00
2795	7	52	2022-05-30 00:00:00
2086	35	50	2023-07-29 00:00:00
2798	49	51	2022-01-17 00:00:00
2141	92	53	2023-05-26 00:00:00
2011	7	53	2023-06-13 00:00:00
2988	9	52	2021-09-24 00:00:00
2138	74	51	2023-07-26 00:00:00
2528	72	51	2022-01-23 00:00:00
2193	14	50	2022-08-02 00:00:00
2162	7	54	2023-01-27 00:00:00
2789	13	50	2022-02-23 00:00:00
2717	13	53	2021-12-04 00:00:00
2782	77	53	2022-07-20 00:00:00
2104	77	51	2022-06-13 00:00:00
2076	13	54	2023-03-22 00:00:00
2955	50	53	2022-05-15 00:00:00
2588	30	52	2022-04-02 00:00:00
2112	4	53	2023-06-22 00:00:00
2007	73	51	2022-03-16 00:00:00
2179	38	53	2023-01-20 00:00:00
2970	83	51	2022-12-28 00:00:00
2212	40	53	2023-03-17 00:00:00
2172	30	51	2023-01-17 00:00:00
2171	74	50	2022-04-23 00:00:00
2198	79	52	2022-08-03 00:00:00
2164	16	53	2022-11-25 00:00:00
2065	42	53	2023-05-24 00:00:00
2077	70	54	2022-10-30 00:00:00
2119	89	52	2023-07-24 00:00:00
2107	16	50	2023-06-13 00:00:00
2182	92	54	2022-07-16 00:00:00
2009	78	53	2022-05-03 00:00:00
2173	42	53	2023-03-17 00:00:00
2091	65	52	2023-03-30 00:00:00
2185	19	51	2023-09-10 00:00:00
2161	57	53	2022-07-10 00:00:00
2095	17	54	2021-10-14 00:00:00
2089	76	53	2022-07-10 00:00:00
2027	91	52	2022-10-31 00:00:00
2805	85	51	2022-04-16 00:00:00
2145	98	54	2022-03-18 00:00:00
2017	54	51	2023-04-08 00:00:00
2191	82	50	2023-08-03 00:00:00
2073	1	51	2022-07-09 00:00:00
2030	22	50	2021-12-18 00:00:00
2328	14	53	2022-12-16 00:00:00
2334	78	52	2022-03-28 00:00:00
2180	62	50	2022-09-05 00:00:00
2318	11	50	2022-03-24 00:00:00
2251	17	51	2022-01-23 00:00:00
2288	6	53	2023-04-23 00:00:00
2023	8	51	2023-01-28 00:00:00
2124	85	53	2021-10-14 00:00:00
2058	97	53	2022-05-03 00:00:00
2040	91	52	2022-07-16 00:00:00
2153	41	53	2023-05-31 00:00:00
2092	25	52	2022-01-02 00:00:00
2391	63	51	2022-08-01 00:00:00
2364	92	52	2022-05-05 00:00:00
2012	96	54	2023-04-28 00:00:00
2043	98	53	2021-12-21 00:00:00
2298	70	53	2023-08-06 00:00:00
2553	60	53	2023-03-05 00:00:00
2025	67	51	2023-03-19 00:00:00
2446	85	54	2022-04-18 00:00:00
2680	43	52	2021-11-15 00:00:00
2158	17	52	2022-12-14 00:00:00
2066	60	51	2022-03-29 00:00:00
2597	88	52	2023-05-26 00:00:00
2638	89	51	2022-02-10 00:00:00
2016	49	54	2023-01-25 00:00:00
2022	87	52	2021-11-24 00:00:00
2140	17	51	2021-10-13 00:00:00
2111	67	51	2022-01-15 00:00:00
2064	3	53	2022-11-21 00:00:00
2513	65	51	2022-02-13 00:00:00
2125	74	51	2021-09-25 00:00:00
2176	55	51	2022-04-23 00:00:00
2711	74	52	2023-08-12 00:00:00
2712	27	51	2023-03-14 00:00:00
2753	90	53	2022-01-16 00:00:00
2776	31	53	2022-05-07 00:00:00
2714	38	52	2022-02-20 00:00:00
2770	68	52	2023-01-30 00:00:00
2026	78	51	2022-03-28 00:00:00
2571	46	51	2022-05-12 00:00:00
2555	76	52	2021-11-24 00:00:00
2696	15	53	2022-03-12 00:00:00
2032	62	51	2023-02-17 00:00:00
2071	48	53	2022-10-08 00:00:00
2932	27	50	2022-02-14 00:00:00
2417	44	51	2023-01-08 00:00:00
2515	74	52	2023-07-27 00:00:00
2640	84	52	2022-04-10 00:00:00
\.


--
-- Data for Name: conditions; Type: TABLE DATA; Schema: public; Owner: gb_user
--

COPY public.conditions (conditions_id, conditions_status) FROM stdin;
1	новая
2	потертая
4	окисленная
5	со сколом
3	сколы
\.


--
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: gb_user
--

COPY public.countries (country_id, country_name) FROM stdin;
1	СССР
2	США
3	Аргентина
4	Индия
5	Россия
6	Куба
\.


--
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: gb_user
--

COPY public.messages (message_id, from_user_id, to_user_id, body, created_at) FROM stdin;
420	80	60	монеты золотые и_серебрянные	2023-09-09 00:00:00
357	97	74	потрепанные любого_монетного двора	2023-09-11 00:00:00
334	52	78	и_серебрянные потрепанные любого_монетного	2023-01-26 00:00:00
340	76	51	куплю монеты золотые	2022-06-04 00:00:00
339	71	37	потрепанные любого_монетного двора	2022-10-28 00:00:00
316	50	80	золотые и_серебрянные потрепанные	2022-04-16 00:00:00
342	60	81	потрепанные любого_монетного двора	2023-03-21 00:00:00
425	58	81	потрепанные любого_монетного двора	2023-08-13 00:00:00
322	44	6	потрепанные любого_монетного двора	2023-04-06 00:00:00
361	27	79	куплю монеты золотые	2023-05-02 00:00:00
368	65	51	и_серебрянные потрепанные любого_монетного	2023-08-25 00:00:00
355	20	100	монеты золотые и_серебрянные	2022-09-18 00:00:00
421	47	58	куплю монеты золотые	2021-10-19 00:00:00
403	42	49	монеты золотые и_серебрянные	2021-10-17 00:00:00
385	18	63	монеты золотые и_серебрянные	2023-02-20 00:00:00
343	59	47	и_серебрянные потрепанные любого_монетного	2021-12-04 00:00:00
365	24	44	монеты золотые и_серебрянные	2022-08-08 00:00:00
323	83	36	монеты золотые и_серебрянные	2021-11-09 00:00:00
332	75	25	и_серебрянные потрепанные любого_монетного	2022-09-23 00:00:00
397	85	74	монеты золотые и_серебрянные	2023-03-25 00:00:00
362	38	69	и_серебрянные потрепанные любого_монетного	2023-09-11 00:00:00
328	24	95	и_серебрянные потрепанные любого_монетного	2023-06-15 00:00:00
411	46	51	куплю монеты золотые	2023-03-15 00:00:00
406	9	69	золотые и_серебрянные потрепанные	2023-08-18 00:00:00
320	98	86	золотые и_серебрянные потрепанные	2022-01-21 00:00:00
350	14	76	монеты золотые и_серебрянные	2023-04-29 00:00:00
321	6	96	и_серебрянные потрепанные любого_монетного	2021-11-22 00:00:00
386	31	77	и_серебрянные потрепанные любого_монетного	2023-02-05 00:00:00
351	62	33	монеты золотые и_серебрянные	2023-08-03 00:00:00
354	97	25	куплю монеты золотые	2022-05-24 00:00:00
429	83	81	монеты золотые и_серебрянные	2022-02-17 00:00:00
393	67	6	и_серебрянные потрепанные любого_монетного	2021-11-13 00:00:00
379	81	77	и_серебрянные потрепанные любого_монетного	2021-12-28 00:00:00
360	100	30	и_серебрянные потрепанные любого_монетного	2022-01-09 00:00:00
307	70	90	монеты золотые и_серебрянные	2023-03-03 00:00:00
378	10	96	и_серебрянные потрепанные любого_монетного	2022-06-22 00:00:00
499	56	37	золотые и_серебрянные потрепанные	2022-01-02 00:00:00
410	79	57	потрепанные любого_монетного двора	2022-07-12 00:00:00
396	75	54	куплю монеты золотые	2023-02-08 00:00:00
300	13	38	монеты золотые и_серебрянные	2023-05-06 00:00:00
344	84	74	золотые и_серебрянные потрепанные	2022-06-30 00:00:00
394	51	4	монеты золотые и_серебрянные	2022-01-09 00:00:00
428	71	41	монеты золотые и_серебрянные	2022-10-17 00:00:00
304	26	73	золотые и_серебрянные потрепанные	2022-08-22 00:00:00
310	76	63	золотые и_серебрянные потрепанные	2021-12-08 00:00:00
392	78	21	и_серебрянные потрепанные любого_монетного	2022-07-04 00:00:00
348	64	45	и_серебрянные потрепанные любого_монетного	2023-06-09 00:00:00
364	94	73	золотые и_серебрянные потрепанные	2022-02-18 00:00:00
399	18	55	и_серебрянные потрепанные любого_монетного	2022-05-16 00:00:00
402	85	5	золотые и_серебрянные потрепанные	2022-08-25 00:00:00
388	84	43	куплю монеты золотые	2023-06-09 00:00:00
369	16	79	монеты золотые и_серебрянные	2022-09-29 00:00:00
389	4	23	монеты золотые и_серебрянные	2022-10-28 00:00:00
404	93	65	золотые и_серебрянные потрепанные	2022-05-03 00:00:00
382	46	79	куплю монеты золотые	2023-02-05 00:00:00
341	83	19	монеты золотые и_серебрянные	2022-01-21 00:00:00
376	36	60	монеты золотые и_серебрянные	2022-05-14 00:00:00
405	92	19	монеты золотые и_серебрянные	2022-12-19 00:00:00
306	37	74	потрепанные любого_монетного двора	2022-02-01 00:00:00
407	65	12	золотые и_серебрянные потрепанные	2022-01-16 00:00:00
401	51	15	и_серебрянные потрепанные любого_монетного	2022-09-28 00:00:00
395	97	51	золотые и_серебрянные потрепанные	2023-04-16 00:00:00
412	96	73	золотые и_серебрянные потрепанные	2023-04-08 00:00:00
387	74	76	и_серебрянные потрепанные любого_монетного	2023-07-01 00:00:00
347	28	46	монеты золотые и_серебрянные	2023-09-08 00:00:00
413	73	45	и_серебрянные потрепанные любого_монетного	2021-09-13 00:00:00
308	15	75	потрепанные любого_монетного двора	2022-03-13 00:00:00
414	2	12	монеты золотые и_серебрянные	2021-10-11 00:00:00
415	91	12	и_серебрянные потрепанные любого_монетного	2022-06-13 00:00:00
416	19	39	монеты золотые и_серебрянные	2022-01-01 00:00:00
417	63	49	монеты золотые и_серебрянные	2022-09-22 00:00:00
435	61	44	и_серебрянные потрепанные любого_монетного	2023-08-23 00:00:00
330	20	9	и_серебрянные потрепанные любого_монетного	2022-06-24 00:00:00
301	14	78	и_серебрянные потрепанные любого_монетного	2022-08-03 00:00:00
370	71	37	и_серебрянные потрепанные любого_монетного	2022-09-29 00:00:00
353	26	31	золотые и_серебрянные потрепанные	2023-02-04 00:00:00
331	94	18	монеты золотые и_серебрянные	2023-03-23 00:00:00
346	79	55	монеты золотые и_серебрянные	2023-02-21 00:00:00
426	14	62	и_серебрянные потрепанные любого_монетного	2022-04-26 00:00:00
313	7	66	золотые и_серебрянные потрепанные	2023-04-10 00:00:00
427	44	7	куплю монеты золотые	2022-10-05 00:00:00
329	100	87	монеты золотые и_серебрянные	2021-11-27 00:00:00
430	41	38	и_серебрянные потрепанные любого_монетного	2021-11-10 00:00:00
398	46	92	потрепанные любого_монетного двора	2023-07-24 00:00:00
305	60	33	и_серебрянные потрепанные любого_монетного	2023-05-09 00:00:00
431	90	26	потрепанные любого_монетного двора	2021-10-20 00:00:00
319	20	78	золотые и_серебрянные потрепанные	2022-06-16 00:00:00
325	76	73	монеты золотые и_серебрянные	2022-11-13 00:00:00
433	4	63	и_серебрянные потрепанные любого_монетного	2022-10-19 00:00:00
390	73	35	золотые и_серебрянные потрепанные	2023-06-15 00:00:00
377	47	97	куплю монеты золотые	2022-03-22 00:00:00
\.


--
-- Data for Name: mints; Type: TABLE DATA; Schema: public; Owner: gb_user
--

COPY public.mints (mint_id, mint_name) FROM stdin;
1	СПМД
2	ММД
3	W
4	D
5	Мумбай
6	Калькульта
7	Estado
8	Kuba
\.


--
-- Data for Name: photo; Type: TABLE DATA; Schema: public; Owner: gb_user
--

COPY public.photo (photo_id, url, owner_id, description, uploaded_at, size) FROM stdin;
500	http://whatsapp.com/en-ca?g=1	13	lobortis mauris. Suspendisse aliquet molestie tellus. Aenean egestas hendrerit neque.	2022-01-12 00:00:00	1293
501	https://netflix.com/group/9?q=test	30	hendrerit. Donec porttitor tellus non magna. Nam ligula elit, pretium	2022-01-24 00:00:00	389
502	https://baidu.com/group/9?str=se	66	iaculis enim, sit amet ornare lectus justo eu arcu. Morbi	2022-05-29 00:00:00	1411
503	http://yahoo.com/site?g=1	59	congue, elit sed consequat auctor, nunc nulla vulputate dui, nec	2022-04-06 00:00:00	1099
504	http://youtube.com/sub/cars?ab=441&aad=2	25	amet, risus. Donec nibh enim, gravida sit amet, dapibus id,	2022-04-11 00:00:00	1283
505	https://wikipedia.org/sub/cars?p=8	51	et arcu imperdiet ullamcorper. Duis at lacus. Quisque purus sapien,	2022-02-11 00:00:00	300
506	http://whatsapp.com/en-us?q=11	93	Maecenas mi felis, adipiscing fringilla, porttitor vulputate, posuere vulputate, lacus.	2022-01-09 00:00:00	818
507	http://guardian.co.uk/site?ad=115	87	diam at pretium aliquet, metus urna convallis erat, eget tincidunt	2022-02-17 00:00:00	1094
508	https://google.com/one?gi=100	2	netus et malesuada fames ac turpis egestas. Fusce aliquet magna	2022-08-21 00:00:00	1335
509	https://instagram.com/group/9?q=11	3	Cras interdum. Nunc sollicitudin commodo ipsum. Suspendisse non leo. Vivamus	2022-08-02 00:00:00	1416
510	http://bbc.co.uk/sub?q=test	98	ullamcorper eu, euismod ac, fermentum vel, mauris. Integer sem elit,	2022-01-20 00:00:00	622
511	http://guardian.co.uk/en-us?k=0	63	Cras sed leo. Cras vehicula aliquet libero. Integer in magna.	2021-09-28 00:00:00	996
512	http://google.com/sub?q=045	60	imperdiet dictum magna. Ut tincidunt orci quis lectus. Nullam suscipit,	2022-01-08 00:00:00	641
513	https://whatsapp.com/user/110?p=8	82	Integer sem elit, pharetra ut, pharetra sed, hendrerit a, arcu.	2022-06-09 00:00:00	420
514	https://reddit.com/site?k=0	83	eros turpis non enim. Mauris quis turpis vitae purus gravida	2022-07-20 00:00:00	1314
515	https://youtube.com/group/9?q=0	74	ultrices a, auctor non, feugiat nec, diam. Duis mi enim,	2022-08-17 00:00:00	1076
516	http://facebook.com/user/110?q=11	39	non lorem vitae odio sagittis semper. Nam tempor diam dictum	2021-10-22 00:00:00	330
517	http://walmart.com/sub/cars?q=4	85	eu, ultrices sit amet, risus. Donec nibh enim, gravida sit	2021-11-13 00:00:00	1167
518	https://cnn.com/one?page=1&offset=1	64	risus. Morbi metus. Vivamus euismod urna. Nullam lobortis quam a	2022-02-08 00:00:00	666
519	https://bbc.co.uk/user/110?search=1	42	diam. Pellentesque habitant morbi tristique senectus et netus et malesuada	2022-03-13 00:00:00	784
520	https://wikipedia.org/one?g=1	65	dictum placerat, augue. Sed molestie. Sed id risus quis diam	2022-03-12 00:00:00	1376
521	https://yahoo.com/one?q=0	94	Cras pellentesque. Sed dictum. Proin eget odio. Aliquam vulputate ullamcorper	2022-03-04 00:00:00	557
522	https://whatsapp.com/settings?page=1&offset=1	21	primis in faucibus orci luctus et ultrices posuere cubilia Curae	2021-11-24 00:00:00	374
523	http://yahoo.com/settings?search=1	48	felis eget varius ultrices, mauris ipsum porta elit, a feugiat	2022-05-22 00:00:00	1365
524	http://walmart.com/settings?p=8	89	semper cursus. Integer mollis. Integer tincidunt aliquam arcu. Aliquam ultrices	2022-07-25 00:00:00	1127
525	http://guardian.co.uk/fr?search=1&q=de	23	nibh lacinia orci, consectetuer euismod est arcu ac orci. Ut	2022-01-07 00:00:00	489
526	https://whatsapp.com/en-us?gi=100	27	In ornare sagittis felis. Donec tempor, est ac mattis semper,	2022-07-12 00:00:00	510
527	https://cnn.com/group/9?page=1&offset=1	89	congue, elit sed consequat auctor, nunc nulla vulputate dui, nec	2022-03-14 00:00:00	1386
528	http://cnn.com/user/110?str=se	8	egestas rhoncus. Proin nisl sem, consequat nec, mollis vitae, posuere	2022-03-19 00:00:00	1060
529	http://yahoo.com/en-us?search=1	67	Phasellus ornare. Fusce mollis. Duis sit amet diam eu dolor	2022-06-29 00:00:00	1046
530	https://google.com/user/110?p=3458	40	pellentesque massa lobortis ultrices. Vivamus rhoncus. Donec est. Nunc ullamcorper,	2021-11-10 00:00:00	893
531	http://naver.com/sub?client=g	9	magnis dis parturient montes, nascetur ridiculus mus. Donec dignissim magna	2022-07-24 00:00:00	1211
532	https://walmart.com/sub/cars?q=11	91	non, lobortis quis, pede. Suspendisse dui. Fusce diam nunc, ullamcorper	2022-05-18 00:00:00	593
533	http://wikipedia.org/en-ca?q=test	94	Nunc sed orci lobortis augue scelerisque mollis. Phasellus libero mauris,	2021-10-17 00:00:00	447
534	http://walmart.com/en-ca?q=11	21	habitant morbi tristique senectus et netus et malesuada fames ac	2022-03-27 00:00:00	1480
535	http://bbc.co.uk/en-us?search=1&q=de	35	per conubia nostra, per inceptos hymenaeos. Mauris ut quam vel	2022-04-10 00:00:00	579
536	https://youtube.com/en-us?page=1&offset=1	68	lorem tristique aliquet. Phasellus fermentum convallis ligula. Donec luctus aliquet	2022-05-15 00:00:00	677
537	http://whatsapp.com/settings?q=0	41	Mauris vel turpis. Aliquam adipiscing lobortis risus. In mi pede,	2021-10-16 00:00:00	1196
538	https://bbc.co.uk/user/110?g=1	93	in faucibus orci luctus et ultrices posuere cubilia Curae Phasellus	2021-12-31 00:00:00	314
539	http://walmart.com/en-us?k=0	38	ut ipsum ac mi eleifend egestas. Sed pharetra, felis eget	2022-01-15 00:00:00	858
540	http://google.com/one?str=s2354e	6	arcu vel quam dignissim pharetra. Nam ac nulla. In tincidunt	2022-04-13 00:00:00	376
541	http://netflix.com/group/9?q=4	88	iaculis odio. Nam interdum enim non nisi. Aenean eget metus.	2022-03-14 00:00:00	534
542	http://reddit.com/en-ca?client=g	65	dolor. Quisque tincidunt pede ac urna. Ut tincidunt vehicula risus.	2021-12-31 00:00:00	827
543	https://pinterest.com/group/9?search=1&q=de	17	scelerisque dui. Suspendisse ac metus vitae velit egestas lacinia. Sed	2021-11-04 00:00:00	1497
544	http://google.com/user/110?gi=1060	71	convallis dolor. Quisque tincidunt pede ac urna. Ut tincidunt vehicula	2021-10-04 00:00:00	1037
545	http://reddit.com/en-us?ab=441&aad=2	37	egestas hendrerit neque. In ornare sagittis felis. Donec tempor, est	2022-07-03 00:00:00	808
546	https://wikipedia.org/user/110?k=0	76	amet nulla. Donec non justo. Proin non massa non ante	2022-02-05 00:00:00	849
547	https://walmart.com/en-ca?search=1&q=de	21	Mauris nulla. Integer urna. Vivamus molestie dapibus ligula. Aliquam erat	2022-02-12 00:00:00	1461
548	https://youtube.com/fr?str=se	60	porta elit, a feugiat tellus lorem eu metus. In lorem.	2022-01-10 00:00:00	526
549	http://nytimes.com/user/110?q=4	11	neque. Morbi quis urna. Nunc quis arcu vel quam dignissim	2022-04-09 00:00:00	1001
550	http://reddit.com/sub?search=31	43	velit eget laoreet posuere, enim nisl elementum purus, accumsan interdum	2022-06-04 00:00:00	948
551	https://guardian.co.uk/one?q=131	18	sem, consequat nec, mollis vitae, posuere at, velit. Cras lorem	2022-07-17 00:00:00	993
552	https://reddit.com/user/110?search=1&q=de	83	dictum ultricies ligula. Nullam enim. Sed nulla ante, iaculis nec,	2021-10-25 00:00:00	1400
553	https://reddit.com/sub?page=1&offset=231	82	commodo ipsum. Suspendisse non leo. Vivamus nibh dolor, nonummy ac,	2022-04-14 00:00:00	1229
554	http://reddit.com/en-ca?str=s23e	65	tempus scelerisque, lorem ipsum sodales purus, in molestie tortor nibh	2022-04-28 00:00:00	1277
555	https://reddit.com/settings?ad=23115	8	molestie pharetra nibh. Aliquam ornare, libero at auctor ullamcorper, nisl	2021-09-18 00:00:00	716
556	http://twitter.com/one?p=8	33	Sed molestie. Sed id risus quis diam luctus lobortis. Class	2021-11-26 00:00:00	325
557	http://yahoo.com/fr?page=1&offset=1	45	sed leo. Cras vehicula aliquet libero. Integer in magna. Phasellus	2021-12-29 00:00:00	1069
558	http://baidu.com/group/9?gi=100	3	orci, in consequat enim diam vel arcu. Curabitur ut odio	2022-06-12 00:00:00	622
559	https://nytimes.com/en-ca?k=0	16	est ac facilisis facilisis, magna tellus faucibus leo, in lobortis	2021-10-02 00:00:00	1240
560	https://pinterest.com/en-us?ab=441&aad=2	43	consectetuer adipiscing elit. Etiam laoreet, libero et tristique pellentesque, tellus	2022-03-11 00:00:00	671
561	http://guardian.co.uk/en-ca?k=0	62	sed dui. Fusce aliquam, enim nec tempus scelerisque, lorem ipsum	2021-11-18 00:00:00	1200
562	http://zoom.us/sub/cars?page=1&offset=1	23	diam. Sed diam lorem, auctor quis, tristique ac, eleifend vitae,	2021-12-18 00:00:00	1100
563	http://yahoo.com/sub?q=4	5	gravida sagittis. Duis gravida. Praesent eu nulla at sem molestie	2022-08-07 00:00:00	429
564	https://guardian.co.uk/user/110?p=8	78	dignissim lacus. Aliquam rutrum lorem ac risus. Morbi metus. Vivamus	2022-01-04 00:00:00	953
565	https://baidu.com/site?search=1	89	risus. Duis a mi fringilla mi lacinia mattis. Integer eu	2022-04-10 00:00:00	1252
569	http://walmart.com/en-ca?q=23411	80	ornare, elit elit fermentum risus, at fringilla purus mauris a	2022-07-02 00:00:00	1331
566	https://bbc.co.uk/site?p=8	99	augue id ante dictum cursus. Nunc mauris elit, dictum eu,	2021-09-20 00:00:00	803
567	https://twitter.com/en-ca?search=1&q=de	64	nec ligula consectetuer rhoncus. Nullam velit dui, semper et, lacinia	2022-01-17 00:00:00	931
568	http://whatsapp.com/settings?str=se	77	montes, nascetur ridiculus mus. Proin vel arcu eu odio tristique	2022-06-26 00:00:00	1351
570	https://youtube.com/group/9?gi=100	2	Maecenas malesuada fringilla est. Mauris eu turpis. Nulla aliquet. Proin	2021-12-18 00:00:00	965
571	https://baidu.com/one?p=8	18	aliquet, sem ut cursus luctus, ipsum leo elementum sem, vitae	2021-11-10 00:00:00	685
572	https://twitter.com/settings?g=1	78	magna sed dui. Fusce aliquam, enim nec tempus scelerisque, lorem	2021-10-26 00:00:00	1097
573	https://whatsapp.com/en-ca?ab=441&aad=2	93	ligula. Donec luctus aliquet odio. Etiam ligula tortor, dictum eu,	2021-11-19 00:00:00	1374
574	http://cnn.com/fr?k=0	97	iaculis enim, sit amet ornare lectus justo eu arcu. Morbi	2022-07-30 00:00:00	1042
575	http://yahoo.com/en-us?page=1&offset=1	75	sed, est. Nunc laoreet lectus quis massa. Mauris vestibulum, neque	2022-04-11 00:00:00	832
576	https://wikipedia.org/site?k=0	22	est. Mauris eu turpis. Nulla aliquet. Proin velit. Sed malesuada	2022-05-15 00:00:00	501
577	http://nytimes.com/user/110?q=test	31	purus. Duis elementum, dui quis accumsan convallis, ante lectus convallis	2022-02-20 00:00:00	328
578	https://cnn.com/user/110?search=1	36	arcu. Sed et libero. Proin mi. Aliquam gravida mauris ut	2022-07-10 00:00:00	663
579	https://whatsapp.com/fr?str=se	21	Aenean massa. Integer vitae nibh. Donec est mauris, rhoncus id,	2022-04-09 00:00:00	1294
580	http://ebay.com/sub/cars?gi=100	23	ut quam vel sapien imperdiet ornare. In faucibus. Morbi vehicula.	2022-03-19 00:00:00	1064
581	https://nytimes.com/site?p=8	59	lectus pede et risus. Quisque libero lacus, varius et, euismod	2022-05-21 00:00:00	1420
582	https://yahoo.com/en-us?gi=100	53	leo elementum sem, vitae aliquam eros turpis non enim. Mauris	2022-03-18 00:00:00	1191
583	http://netflix.com/sub?q=test	47	dolor, nonummy ac, feugiat non, lobortis quis, pede. Suspendisse dui.	2022-05-27 00:00:00	381
584	http://youtube.com/site?search=1&q=de	46	penatibus et magnis dis parturient montes, nascetur ridiculus mus. Proin	2022-01-29 00:00:00	509
585	https://facebook.com/en-ca?p=8	18	id, ante. Nunc mauris sapien, cursus in, hendrerit consectetuer, cursus	2022-08-02 00:00:00	655
586	https://facebook.com/sub/cars?p=8	50	Curabitur massa. Vestibulum accumsan neque et nunc. Quisque ornare tortor	2022-04-26 00:00:00	964
587	https://youtube.com/settings?gi=100	92	sollicitudin a, malesuada id, erat. Etiam vestibulum massa rutrum magna.	2022-07-12 00:00:00	593
588	https://twitter.com/site?q=test	61	mollis lectus pede et risus. Quisque libero lacus, varius et,	2021-10-03 00:00:00	1174
589	https://naver.com/en-ca?q=4	15	vehicula risus. Nulla eget metus eu erat semper rutrum. Fusce	2021-10-21 00:00:00	681
590	https://baidu.com/sub?ab=441&aad=2	76	mollis. Integer tincidunt aliquam arcu. Aliquam ultrices iaculis odio. Nam	2021-10-12 00:00:00	421
591	https://guardian.co.uk/group/9?p=8	92	posuere vulputate, lacus. Cras interdum. Nunc sollicitudin commodo ipsum. Suspendisse	2022-06-22 00:00:00	722
592	http://google.com/site?q=123541	2	diam at pretium aliquet, metus urna convallis erat, eget tincidunt	2022-01-06 00:00:00	910
593	http://instagram.com/sub/cars?q=11	41	malesuada fames ac turpis egestas. Aliquam fringilla cursus purus. Nullam	2022-04-09 00:00:00	1422
594	http://google.com/site?q=11	39	fringilla est. Mauris eu turpis. Nulla aliquet. Proin velit. Sed	2022-05-19 00:00:00	344
595	http://twitter.com/fr?g=1	92	ornare, lectus ante dictum mi, ac mattis velit justo nec	2021-11-03 00:00:00	1353
596	http://whatsapp.com/group/9?q=0	29	dictum eu, placerat eget, venenatis a, magna. Lorem ipsum dolor	2022-07-13 00:00:00	1199
597	http://yahoo.com/one?k=0	65	nisl. Quisque fringilla euismod enim. Etiam gravida molestie arcu. Sed	2022-04-01 00:00:00	773
598	http://guardian.co.uk/site?gi=100	50	sapien. Aenean massa. Integer vitae nibh. Donec est mauris, rhoncus	2022-07-21 00:00:00	613
599	https://youtube.com/group/9?p=8	18	massa. Quisque porttitor eros nec tellus. Nunc lectus pede, ultrices	2022-05-10 00:00:00	491
\.


--
-- Data for Name: series; Type: TABLE DATA; Schema: public; Owner: gb_user
--

COPY public.series (series_id, series_name) FROM stdin;
10	Красная книга
20	Пайса
30	100 лет Аргентина
40	Индия
50	Великая война
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: gb_user
--

COPY public.users (user_id, nik_name, first_name, last_name, email, logo, created_at) FROM stdin;
1	Keith	Cally	Robinson	sapien.molestie.orci@hotmail.ca	536	2022-07-19 00:00:00
2	Holmes	Igor	Humphrey	mauris.magna@mail.couk	581	2022-08-15 00:00:00
3	Cruz	Tatyana	Burgess	rutrum.magna.cras@google.couk	582	2021-11-08 00:00:00
4	Abel	Dante	Barr	turpis.nec@outlook.net	590	2022-02-16 00:00:00
5	Murphy	Quail	Fitzpatrick	viverra.maecenas.iaculis@aol.org	501	2022-04-20 00:00:00
6	Kasper	Donovan	Lott	diam.nunc@outlook.couk	581	2022-03-26 00:00:00
7	Geoffrey	Sigourney	Frye	dui@outlook.ca	566	2021-12-25 00:00:00
8	Edward	Moses	Bush	sodales.nisi@mail.com	585	2022-04-19 00:00:00
9	Scott	Fitzgerald	Briggs	mauris.vel.turpis@icloud.net	517	2022-08-12 00:00:00
10	Chancellor	Dustin	Franco	nec.malesuada@outlook.couk	553	2022-02-28 00:00:00
11	Jerome	Samuel	Rodriguez	non@aol.edu	511	2022-06-28 00:00:00
12	Stephen	Chiquita	Delaney	ligula@icloud.couk	559	2021-09-20 00:00:00
13	Harrison	Tanek	Gomez	conubia.nostra@google.edu	544	2022-08-30 00:00:00
14	Talon	Raven	Rowe	ullamcorper.viverra@hotmail.org	503	2021-10-30 00:00:00
15	Josiah	Nasim	Pitts	molestie.tortor@mail.net	537	2022-08-24 00:00:00
16	Nasim	Vernon	Gonzales	cras.vehicula.aliquet@icloud.edu	582	2022-04-18 00:00:00
17	Alan	Serina	Reilly	ante.maecenas.mi@outlook.couk	520	2022-07-05 00:00:00
18	Dennis	Tanya	Wynn	sem.eget@icloud.couk	589	2022-08-03 00:00:00
19	Kuame	Deirdre	Blevins	enim.sed@google.couk	511	2022-06-23 00:00:00
20	Julian	Eaton	Eaton	nunc@aol.edu	565	2022-03-12 00:00:00
21	Alan	Carlos	Velasquez	mauris@outlook.com	525	2022-03-23 00:00:00
22	Boris	Reed	Phillips	cubilia@outlook.com	561	2022-01-20 00:00:00
24	Lars	Azalia	Tate	ut.sem@protonmail.net	522	2022-04-13 00:00:00
25	Ashton	Wyoming	Rivera	aliquet.proin@icloud.org	525	2022-08-25 00:00:00
26	Levi	Guinevere	Lee	feugiat@aol.edu	516	2022-02-24 00:00:00
27	Aaron	Donovan	Mcclure	donec.feugiat@outlook.org	528	2022-04-24 00:00:00
28	Allistair	Moses	Brewer	cursus.luctus@google.org	549	2021-11-06 00:00:00
29	Jack	Hollee	Soto	et.commodo@outlook.couk	570	2022-04-10 00:00:00
30	Adrian	Macon	Allen	ultrices@aol.net	536	2022-07-17 00:00:00
31	Hasad	Autumn	Banks	lobortis@mail.net	554	2022-07-07 00:00:00
32	Michael	Shelly	Farrell	ac@icloud.edu	503	2022-04-03 00:00:00
33	Asher	Blossom	Hull	eu.augue@yahoo.couk	527	2022-07-21 00:00:00
34	Marsden	Zachary	Castro	a@google.net	599	2021-12-29 00:00:00
35	Chaney	Blake	Tucker	vel.faucibus@yahoo.net	588	2022-02-23 00:00:00
36	Kennedy	Amal	Hull	tempor@outlook.net	540	2022-04-05 00:00:00
37	Aaron	Carissa	Alvarez	non.massa@mail.couk	531	2022-03-06 00:00:00
38	Keane	Murphy	Rasmussen	est@outlook.net	527	2021-09-29 00:00:00
39	Vincent	Odessa	Jefferson	magna.duis@outlook.couk	515	2021-09-23 00:00:00
40	Camden	Adam	Hood	vitae@hotmail.com	554	2022-04-17 00:00:00
41	Erich	Audrey	Day	nullam.enim.sed@aol.org	526	2022-03-17 00:00:00
42	Joshua	Christen	Osborn	quisque.libero.lacus@aol.ca	526	2022-05-16 00:00:00
43	Reese	Beck	Oliver	sit.amet@outlook.org	592	2021-10-04 00:00:00
44	Tyler	Jaime	Vega	nullam@google.com	526	2022-05-25 00:00:00
45	Porter	Drew	Crosby	nam.porttitor@yahoo.net	565	2022-08-19 00:00:00
46	Deacon	Shelley	Hendrix	est.mauris.rhoncus@yahoo.ca	558	2022-01-11 00:00:00
47	Zeus	Yoshi	Perry	dolor.sit@google.net	510	2022-08-06 00:00:00
48	Walter	Ria	Adams	bibendum.donec@aol.edu	518	2021-11-25 00:00:00
49	Brandon	Tyrone	Whitaker	non@icloud.org	534	2021-10-04 00:00:00
50	Curran	Fletcher	Kelley	id.libero@aol.couk	534	2022-07-10 00:00:00
51	Kareem	Kyle	Hawkins	egestas.rhoncus.proin@google.com	590	2022-05-24 00:00:00
52	Jin	Ramona	Garza	ultrices.sit.amet@outlook.net	525	2021-11-08 00:00:00
53	Joseph	Deborah	Holmes	rhoncus@hotmail.org	581	2021-12-07 00:00:00
54	Zachary	Madison	Edwards	lacus.cras@aol.edu	529	2021-10-21 00:00:00
55	Perry	Lavinia	Park	nec.quam@hotmail.edu	561	2022-01-29 00:00:00
56	Nathaniel	Jason	Moran	placerat.eget@yahoo.couk	564	2022-07-07 00:00:00
57	Elijah	Phillip	Decker	quis.turpis@yahoo.ca	546	2021-11-29 00:00:00
58	Laith	Nero	Henry	ut.semper@yahoo.com	566	2022-04-20 00:00:00
59	Isaiah	Ulla	Fuentes	mi@aol.couk	533	2022-07-07 00:00:00
60	Troy	Kaitlin	Russo	quis.diam@aol.edu	536	2022-01-18 00:00:00
61	Quinlan	Oren	Osborn	pulvinar.arcu.et@outlook.com	564	2022-02-20 00:00:00
62	Vincent	Lynn	Weaver	felis@yahoo.couk	543	2022-04-23 00:00:00
63	Zachery	Fay	Mack	mauris.blandit.enim@hotmail.couk	504	2021-11-05 00:00:00
64	Elliott	Richard	Steele	aliquam.rutrum@hotmail.net	553	2022-08-19 00:00:00
65	Lane	Yuri	Rush	faucibus@protonmail.com	554	2022-07-27 00:00:00
66	Joseph	Shelly	Trujillo	ut@protonmail.edu	538	2021-12-31 00:00:00
67	Cullen	Clio	Olsen	morbi@hotmail.org	564	2022-04-20 00:00:00
68	Travis	Carolyn	Crane	at.fringilla.purus@mail.org	526	2022-03-22 00:00:00
69	Denton	Donna	Hyde	nunc.mauris@protonmail.org	547	2022-08-03 00:00:00
70	Aladdin	Ethan	Herrera	sit.amet@aol.net	592	2021-10-02 00:00:00
71	Tucker	Buckminster	Rowland	nunc.ullamcorper@icloud.couk	577	2021-11-01 00:00:00
72	Keegan	Ann	Weaver	eu@google.com	551	2021-10-07 00:00:00
73	Hop	Quintessa	Dawson	suspendisse@mail.couk	536	2022-08-02 00:00:00
74	Tate	Jescie	Hyde	amet.diam@mail.edu	571	2022-01-09 00:00:00
75	Yoshio	Kennedy	Woods	sapien.nunc.pulvinar@protonmail.couk	580	2022-01-26 00:00:00
76	Zachery	Melinda	Bauer	felis.nulla@hotmail.ca	578	2021-09-27 00:00:00
77	Leonard	Whilemina	Dyer	cursus.luctus@yahoo.couk	546	2022-01-20 00:00:00
78	Talon	Xandra	Lang	fermentum@yahoo.edu	581	2021-09-18 00:00:00
79	Melvin	MacKenzie	Alexander	amet.ornare@yahoo.ca	576	2022-03-02 00:00:00
80	Drake	Erasmus	Foley	et.malesuada@mail.net	562	2022-01-30 00:00:00
81	Dennis	Burke	Blanchard	quisque@google.couk	569	2022-01-19 00:00:00
82	Dillon	Malcolm	Doyle	lectus.cum@icloud.com	514	2021-10-22 00:00:00
83	Basil	Bianca	Finley	pede@icloud.ca	588	2022-03-26 00:00:00
84	Jelani	Stacey	Charles	curabitur.ut@protonmail.edu	559	2021-09-30 00:00:00
85	Clark	Shea	Glass	lorem.lorem.luctus@icloud.com	518	2022-08-25 00:00:00
86	Jasper	Vivian	Davidson	dolor.dapibus@yahoo.edu	554	2021-12-21 00:00:00
87	Rafael	Damon	French	mattis@google.com	545	2022-05-08 00:00:00
88	Theodore	Nomlanga	Rice	rutrum.non.hendrerit@mail.edu	577	2022-06-14 00:00:00
89	Denton	Bradley	Duffy	mattis@google.couk	554	2022-01-08 00:00:00
90	Marvin	Jerome	Cote	nisl.quisque@mail.edu	502	2022-05-24 00:00:00
91	Emerson	Isaiah	Hines	pellentesque@hotmail.org	529	2021-10-08 00:00:00
92	Samson	Chester	Castillo	pede.nec@mail.org	537	2022-02-28 00:00:00
93	Kareem	Elton	Kennedy	ante@hotmail.ca	552	2021-10-12 00:00:00
94	Edward	Dean	Hart	nulla.semper@aol.org	502	2022-01-20 00:00:00
95	Timothy	Tyler	Gordon	sem.egestas@icloud.com	593	2022-02-13 00:00:00
96	Slade	Micah	Peters	convallis@yahoo.org	521	2022-01-24 00:00:00
97	Hall	Tiger	Small	cras.lorem@google.org	573	2021-09-18 00:00:00
98	Bevis	Cade	Daugherty	ornare.fusce@icloud.net	551	2022-05-26 00:00:00
99	Orlando	Mira	Bartlett	proin.ultrices@mail.org	531	2021-10-25 00:00:00
100	Tanek	Ashely	Blanchard	proin.vel@hotmail.net	502	2022-07-14 00:00:00
23	Demetrius	Pamela	Simmons	dis.parturient.montes@yahoo.net	500	2022-02-14 00:00:00
\.


--
-- Data for Name: video; Type: TABLE DATA; Schema: public; Owner: gb_user
--

COPY public.video (video_id, url, owner_id, description, uploaded_at, size) FROM stdin;
300	http://guardian.co.uk/settings?search=1	14	convallis convallis dolor. Quisque tincidunt pede ac urna. Ut tincidunt	2023-08-12 00:00:00	2413
301	https://nytimes.com/user/110?ad=115	9	porttitor tellus non magna. Nam ligula elit, pretium et, rutrum	2023-07-03 00:00:00	2563
302	https://pinterest.com/site?search=1&q=de	29	Donec fringilla. Donec feugiat metus sit amet ante. Vivamus non	2022-01-28 00:00:00	1987
303	http://google.com/sub/cars?q=0	14	Nulla facilisi. Sed neque. Sed eget lacus. Mauris non dui	2022-08-15 00:00:00	1617
304	https://yahoo.com/one?search=1&q=de	18	a, arcu. Sed et libero. Proin mi. Aliquam gravida mauris	2022-09-30 00:00:00	2773
305	https://cnn.com/settings?search=1	39	mauris. Integer sem elit, pharetra ut, pharetra sed, hendrerit a,	2023-07-28 00:00:00	1715
306	http://ebay.com/en-ca?q=4	9	sed leo. Cras vehicula aliquet libero. Integer in magna. Phasellus	2023-08-06 00:00:00	2266
307	http://walmart.com/en-ca?q=11	13	non dui nec urna suscipit nonummy. Fusce fermentum fermentum arcu.	2022-11-15 00:00:00	2394
308	https://ebay.com/settings?search=1&q=de	99	pede nec ante blandit viverra. Donec tempus, lorem fringilla ornare	2022-06-20 00:00:00	1794
309	https://zoom.us/user/110?str=se	22	netus et malesuada fames ac turpis egestas. Fusce aliquet magna	2023-07-27 00:00:00	2296
310	https://cnn.com/sub?q=0	99	eleifend nec, malesuada ut, sem. Nulla interdum. Curabitur dictum. Phasellus	2022-09-11 00:00:00	1933
311	https://walmart.com/sub?search=1	12	malesuada. Integer id magna et ipsum cursus vestibulum. Mauris magna.	2023-02-22 00:00:00	2636
312	http://wikipedia.org/settings?gi=100	69	lacinia. Sed congue, elit sed consequat auctor, nunc nulla vulputate	2021-11-01 00:00:00	2565
313	http://twitter.com/en-ca?search=1&q=de	52	amet ante. Vivamus non lorem vitae odio sagittis semper. Nam	2023-07-05 00:00:00	2500
314	https://reddit.com/settings?q=4	25	ornare tortor at risus. Nunc ac sem ut dolor dapibus	2022-04-21 00:00:00	2594
315	https://twitter.com/fr?q=11	4	tristique senectus et netus et malesuada fames ac turpis egestas.	2022-01-01 00:00:00	2376
316	http://pinterest.com/user/110?ad=115	82	Cras dolor dolor, tempus non, lacinia at, iaculis quis, pede.	2023-06-12 00:00:00	2903
317	https://google.com/site?search=1&q=de	10	Nunc commodo auctor velit. Aliquam nisl. Nulla eu neque pellentesque	2023-03-13 00:00:00	2546
318	https://naver.com/fr?ab=441&aad=2	41	fringilla. Donec feugiat metus sit amet ante. Vivamus non lorem	2022-11-14 00:00:00	2910
319	https://netflix.com/site?str=se	31	Donec nibh enim, gravida sit amet, dapibus id, blandit at,	2023-02-27 00:00:00	2269
320	http://yahoo.com/fr?q=11	68	a, magna. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.	2023-05-13 00:00:00	2126
321	https://wikipedia.org/en-us?q=4	75	quam. Pellentesque habitant morbi tristique senectus et netus et malesuada	2021-10-10 00:00:00	2410
322	https://nytimes.com/one?k=0	89	In tincidunt congue turpis. In condimentum. Donec at arcu. Vestibulum	2022-02-15 00:00:00	2505
323	http://facebook.com/en-ca?p=8	3	enim mi tempor lorem, eget mollis lectus pede et risus.	2022-10-17 00:00:00	2801
324	https://guardian.co.uk/en-ca?ab=441&aad=2	18	urna suscipit nonummy. Fusce fermentum fermentum arcu. Vestibulum ante ipsum	2021-09-22 00:00:00	1729
325	https://walmart.com/settings?q=4	51	Sed nulla ante, iaculis nec, eleifend non, dapibus rutrum, justo.	2021-12-10 00:00:00	2198
326	http://facebook.com/settings?q=test	26	ornare. Fusce mollis. Duis sit amet diam eu dolor egestas	2021-10-15 00:00:00	2918
327	http://twitter.com/one?ad=1415	70	Quisque nonummy ipsum non arcu. Vivamus sit amet risus. Donec	2022-12-09 00:00:00	2992
328	http://netflix.com/settings?g=1	58	nulla. Integer urna. Vivamus molestie dapibus ligula. Aliquam erat volutpat.	2022-05-21 00:00:00	2859
329	https://pinterest.com/sub/cars?q=test	9	at pretium aliquet, metus urna convallis erat, eget tincidunt dui	2022-01-28 00:00:00	2737
330	https://bbc.co.uk/site?search=1	8	Integer id magna et ipsum cursus vestibulum. Mauris magna. Duis	2022-04-02 00:00:00	2982
331	https://bbc.co.uk/group/9?search=1	47	lorem, luctus ut, pellentesque eget, dictum placerat, augue. Sed molestie.	2021-10-27 00:00:00	1632
332	http://twitter.com/one?ad=1165	39	ipsum sodales purus, in molestie tortor nibh sit amet orci.	2022-10-27 00:00:00	1654
333	http://ebay.com/en-ca?q=11	34	justo. Praesent luctus. Curabitur egestas nunc sed libero. Proin sed	2022-02-17 00:00:00	2472
334	http://nytimes.com/one?ad=1105	63	pretium neque. Morbi quis urna. Nunc quis arcu vel quam	2023-08-12 00:00:00	2384
335	https://reddit.com/site?q=test	28	Nullam vitae diam. Proin dolor. Nulla semper tellus id nunc	2023-07-08 00:00:00	2767
336	https://instagram.com/site?q=11	69	leo. Vivamus nibh dolor, nonummy ac, feugiat non, lobortis quis,	2022-03-08 00:00:00	2450
337	http://google.com/en-us?q=11	88	a ultricies adipiscing, enim mi tempor lorem, eget mollis lectus	2021-11-30 00:00:00	2760
338	https://whatsapp.com/group/9?gi=100	3	enim, gravida sit amet, dapibus id, blandit at, nisi. Cum	2023-09-07 00:00:00	2704
339	http://nytimes.com/group/9?q=0	67	Nullam scelerisque neque sed sem egestas blandit. Nam nulla magna,	2022-11-16 00:00:00	2487
340	https://netflix.com/en-us?q=11	96	Cras dolor dolor, tempus non, lacinia at, iaculis quis, pede.	2022-08-28 00:00:00	2458
341	http://google.com/fr?str=se	85	vestibulum nec, euismod in, dolor. Fusce feugiat. Lorem ipsum dolor	2022-02-11 00:00:00	2957
342	http://youtube.com/group/9?p=8	78	neque pellentesque massa lobortis ultrices. Vivamus rhoncus. Donec est. Nunc	2021-12-22 00:00:00	1639
343	http://whatsapp.com/fr?str=se	29	Ut tincidunt orci quis lectus. Nullam suscipit, est ac facilisis	2022-04-14 00:00:00	1932
344	http://zoom.us/sub?str=se	77	vitae, sodales at, velit. Pellentesque ultricies dignissim lacus. Aliquam rutrum	2022-03-19 00:00:00	2467
345	https://yahoo.com/en-us?ad=115	11	molestie tellus. Aenean egestas hendrerit neque. In ornare sagittis felis.	2022-02-18 00:00:00	1593
346	http://zoom.us/site?str=se	19	non, bibendum sed, est. Nunc laoreet lectus quis massa. Mauris	2021-11-24 00:00:00	2315
347	https://nytimes.com/one?search=1&q=de	90	nibh. Quisque nonummy ipsum non arcu. Vivamus sit amet risus.	2022-03-20 00:00:00	2200
348	http://twitter.com/en-us?page=1&offset=1	94	mauris ipsum porta elit, a feugiat tellus lorem eu metus.	2021-12-03 00:00:00	2390
349	https://nytimes.com/user/110?q=11	22	et, eros. Proin ultrices. Duis volutpat nunc sit amet metus.	2022-10-21 00:00:00	1750
350	https://guardian.co.uk/settings?ad=115	23	consectetuer adipiscing elit. Aliquam auctor, velit eget laoreet posuere, enim	2021-12-15 00:00:00	2566
351	https://walmart.com/en-ca?ab=441&aad=2	35	ac turpis egestas. Fusce aliquet magna a neque. Nullam ut	2022-07-22 00:00:00	2572
352	http://netflix.com/settings?str=se	78	Suspendisse dui. Fusce diam nunc, ullamcorper eu, euismod ac, fermentum	2023-03-20 00:00:00	1968
353	http://zoom.us/site?q=4	70	ante, iaculis nec, eleifend non, dapibus rutrum, justo. Praesent luctus.	2022-03-15 00:00:00	1911
354	http://baidu.com/en-us?str=se	92	non quam. Pellentesque habitant morbi tristique senectus et netus et	2021-10-10 00:00:00	2368
356	http://youtube.com/en-us?gi=100	23	id, erat. Etiam vestibulum massa rutrum magna. Cras convallis convallis	2023-06-12 00:00:00	2246
357	http://bbc.co.uk/one?p=8	33	eget nisi dictum augue malesuada malesuada. Integer id magna et	2022-11-18 00:00:00	2825
358	https://baidu.com/user/110?ab=441&aad=2	28	orci, consectetuer euismod est arcu ac orci. Ut semper pretium	2021-10-01 00:00:00	2229
359	https://zoom.us/sub?g=1	35	tellus. Nunc lectus pede, ultrices a, auctor non, feugiat nec,	2023-08-05 00:00:00	2962
355	http://netflix.com/sub/cars?p=8	28	eu nulla at sem molestie sodales. Mauris blandit enim consequat	2023-04-22 00:00:00	1532
360	http://reddit.com/sub?ab=441&aad=2	49	tristique aliquet. Phasellus fermentum convallis ligula. Donec luctus aliquet odio.	2022-05-18 00:00:00	1930
361	http://wikipedia.org/site?p=8	30	nunc interdum feugiat. Sed nec metus facilisis lorem tristique aliquet.	2021-09-12 00:00:00	2572
362	http://baidu.com/settings?q=4	98	eu augue porttitor interdum. Sed auctor odio a purus. Duis	2023-06-21 00:00:00	2845
363	http://google.com/sub?q=test	51	convallis erat, eget tincidunt dui augue eu tellus. Phasellus elit	2022-10-01 00:00:00	2193
364	https://pinterest.com/fr?search=1	36	eu, accumsan sed, facilisis vitae, orci. Phasellus dapibus quam quis	2023-07-29 00:00:00	2854
365	http://bbc.co.uk/en-ca?ad=115	22	in faucibus orci luctus et ultrices posuere cubilia Curae Phasellus	2022-02-24 00:00:00	2676
366	https://bbc.co.uk/site?gi=100	88	urna. Nunc quis arcu vel quam dignissim pharetra. Nam ac	2022-08-13 00:00:00	2512
367	https://ebay.com/sub/cars?client=g	20	vitae nibh. Donec est mauris, rhoncus id, mollis nec, cursus	2023-05-05 00:00:00	1630
368	https://yahoo.com/user/110?ab=441&aad=2	19	blandit congue. In scelerisque scelerisque dui. Suspendisse ac metus vitae	2021-10-31 00:00:00	2532
369	https://walmart.com/en-ca?client=g	54	metus eu erat semper rutrum. Fusce dolor quam, elementum at,	2023-05-13 00:00:00	2680
370	http://guardian.co.uk/group/9?str=se	76	ut erat. Sed nunc est, mollis non, cursus non, egestas	2022-03-18 00:00:00	1629
371	https://pinterest.com/en-ca?client=g	56	commodo auctor velit. Aliquam nisl. Nulla eu neque pellentesque massa	2022-04-13 00:00:00	2137
372	https://wikipedia.org/settings?g=1	81	vulputate, lacus. Cras interdum. Nunc sollicitudin commodo ipsum. Suspendisse non	2022-04-15 00:00:00	1760
373	https://youtube.com/settings?page=1&offset=1	43	cursus vestibulum. Mauris magna. Duis dignissim tempor arcu. Vestibulum ut	2021-12-14 00:00:00	2674
374	http://ebay.com/sub?q=0	8	risus. Nulla eget metus eu erat semper rutrum. Fusce dolor	2023-06-24 00:00:00	1543
375	http://nytimes.com/one?p=8	87	mi. Aliquam gravida mauris ut mi. Duis risus odio, auctor	2022-09-07 00:00:00	2039
376	http://walmart.com/en-us?q=11	18	vitae nibh. Donec est mauris, rhoncus id, mollis nec, cursus	2023-03-30 00:00:00	2013
377	http://nytimes.com/group/9?search=1&q=de	79	nec, leo. Morbi neque tellus, imperdiet non, vestibulum nec, euismod	2022-06-18 00:00:00	2204
378	https://zoom.us/user/110?gi=100	99	mattis semper, dui lectus rutrum urna, nec luctus felis purus	2022-02-04 00:00:00	2458
379	http://cnn.com/group/9?search=1&q=de	95	tellus sem mollis dui, in sodales elit erat vitae risus.	2021-10-10 00:00:00	2762
380	https://pinterest.com/settings?ab=441&aad=2	72	Nulla tempor augue ac ipsum. Phasellus vitae mauris sit amet	2023-01-24 00:00:00	2256
381	http://whatsapp.com/user/110?g=1	93	Ut tincidunt vehicula risus. Nulla eget metus eu erat semper	2022-03-08 00:00:00	2452
382	http://google.com/fr?page=1&offset=1	79	enim, condimentum eget, volutpat ornare, facilisis eget, ipsum. Donec sollicitudin	2023-08-03 00:00:00	1836
383	https://bbc.co.uk/sub/cars?search=1&q=de	86	Donec dignissim magna a tortor. Nunc commodo auctor velit. Aliquam	2022-01-23 00:00:00	2003
384	http://whatsapp.com/sub/cars?ab=441&aad=2	64	nunc. In at pede. Cras vulputate velit eu sem. Pellentesque	2023-05-21 00:00:00	2570
385	https://reddit.com/en-ca?ab=441&aad=2	55	sem elit, pharetra ut, pharetra sed, hendrerit a, arcu. Sed	2021-10-18 00:00:00	2302
386	https://whatsapp.com/en-ca?str=se	72	adipiscing, enim mi tempor lorem, eget mollis lectus pede et	2022-07-16 00:00:00	2270
387	http://instagram.com/fr?q=test	86	augue eu tellus. Phasellus elit pede, malesuada vel, venenatis vel,	2022-05-15 00:00:00	2468
388	http://zoom.us/en-ca?gi=100	10	tincidunt, neque vitae semper egestas, urna justo faucibus lectus, a	2022-02-04 00:00:00	2071
389	http://wikipedia.org/user/110?str=se	83	ullamcorper, velit in aliquet lobortis, nisi nibh lacinia orci, consectetuer	2022-04-19 00:00:00	2848
390	http://reddit.com/group/9?page=1&offset=1	70	ornare sagittis felis. Donec tempor, est ac mattis semper, dui	2023-07-06 00:00:00	2148
392	https://cnn.com/site?q=test	79	urna. Vivamus molestie dapibus ligula. Aliquam erat volutpat. Nulla dignissim.	2023-07-29 00:00:00	1822
391	https://whatsapp.com/en-us?q=0	38	In ornare sagittis felis. Donec tempor, est ac mattis semper,	2023-06-28 00:00:00	1775
393	http://guardian.co.uk/settings?g=1	58	scelerisque dui. Suspendisse ac metus vitae velit egestas lacinia. Sed	2022-04-11 00:00:00	1887
394	https://guardian.co.uk/sub?g=1	58	Sed eu nibh vulputate mauris sagittis placerat. Cras dictum ultricies	2023-04-27 00:00:00	2666
395	https://netflix.com/group/9?p=8	45	Ut nec urna et arcu imperdiet ullamcorper. Duis at lacus.	2023-01-18 00:00:00	2121
396	https://bbc.co.uk/en-us?q=4	27	elementum, dui quis accumsan convallis, ante lectus convallis est, vitae	2023-05-05 00:00:00	2233
397	https://instagram.com/group/9?ad=115	48	lacus. Cras interdum. Nunc sollicitudin commodo ipsum. Suspendisse non leo.	2022-06-14 00:00:00	2448
398	http://guardian.co.uk/user/110?p=8	78	mattis velit justo nec ante. Maecenas mi felis, adipiscing fringilla,	2023-05-26 00:00:00	1767
399	https://naver.com/settings?q=11	64	libero. Proin mi. Aliquam gravida mauris ut mi. Duis risus	2021-12-13 00:00:00	1632
\.


--
-- Name: coins_coin_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gb_user
--

SELECT pg_catalog.setval('public.coins_coin_id_seq', 1, false);


--
-- Name: communities_community_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gb_user
--

SELECT pg_catalog.setval('public.communities_community_id_seq', 1, false);


--
-- Name: communities_users_community_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gb_user
--

SELECT pg_catalog.setval('public.communities_users_community_user_id_seq', 1, false);


--
-- Name: conditions_conditions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gb_user
--

SELECT pg_catalog.setval('public.conditions_conditions_id_seq', 1, false);


--
-- Name: countries_country_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gb_user
--

SELECT pg_catalog.setval('public.countries_country_id_seq', 1, false);


--
-- Name: messages_message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gb_user
--

SELECT pg_catalog.setval('public.messages_message_id_seq', 1, false);


--
-- Name: mints_mint_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gb_user
--

SELECT pg_catalog.setval('public.mints_mint_id_seq', 1, false);


--
-- Name: photo_photo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gb_user
--

SELECT pg_catalog.setval('public.photo_photo_id_seq', 1, false);


--
-- Name: series_series_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gb_user
--

SELECT pg_catalog.setval('public.series_series_id_seq', 1, false);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gb_user
--

SELECT pg_catalog.setval('public.users_user_id_seq', 1, false);


--
-- Name: video_video_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gb_user
--

SELECT pg_catalog.setval('public.video_video_id_seq', 1, false);


--
-- Name: coins coins_pkey; Type: CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.coins
    ADD CONSTRAINT coins_pkey PRIMARY KEY (coin_id);


--
-- Name: communities communities_community_name_key; Type: CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.communities
    ADD CONSTRAINT communities_community_name_key UNIQUE (community_name);


--
-- Name: communities communities_pkey; Type: CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.communities
    ADD CONSTRAINT communities_pkey PRIMARY KEY (community_id);


--
-- Name: communities_users communities_users_pkey; Type: CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.communities_users
    ADD CONSTRAINT communities_users_pkey PRIMARY KEY (community_user_id);


--
-- Name: conditions conditions_pkey; Type: CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.conditions
    ADD CONSTRAINT conditions_pkey PRIMARY KEY (conditions_id);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (country_id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (message_id);


--
-- Name: mints mints_pkey; Type: CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.mints
    ADD CONSTRAINT mints_pkey PRIMARY KEY (mint_id);


--
-- Name: photo photo_pkey; Type: CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.photo
    ADD CONSTRAINT photo_pkey PRIMARY KEY (photo_id);


--
-- Name: photo photo_url_key; Type: CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.photo
    ADD CONSTRAINT photo_url_key UNIQUE (url);


--
-- Name: series series_pkey; Type: CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.series
    ADD CONSTRAINT series_pkey PRIMARY KEY (series_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: video video_pkey; Type: CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.video
    ADD CONSTRAINT video_pkey PRIMARY KEY (video_id);


--
-- Name: video video_url_key; Type: CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.video
    ADD CONSTRAINT video_url_key UNIQUE (url);


--
-- Name: coins check_owner_photo_on_update; Type: TRIGGER; Schema: public; Owner: gb_user
--

CREATE TRIGGER check_owner_photo_on_update BEFORE UPDATE ON public.coins FOR EACH ROW EXECUTE FUNCTION public.update_owner_photo_trigger();


--
-- Name: communities_users communities_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.communities_users
    ADD CONSTRAINT communities_id_fk FOREIGN KEY (community_id) REFERENCES public.communities(community_id) ON DELETE CASCADE;


--
-- Name: coins condition_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.coins
    ADD CONSTRAINT condition_id_fk FOREIGN KEY (conditions_id) REFERENCES public.conditions(conditions_id) ON DELETE CASCADE;


--
-- Name: coins country_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.coins
    ADD CONSTRAINT country_id_fk FOREIGN KEY (country_id) REFERENCES public.countries(country_id) ON DELETE CASCADE;


--
-- Name: communities creator_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.communities
    ADD CONSTRAINT creator_id_fk FOREIGN KEY (creator_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: coins edge_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.coins
    ADD CONSTRAINT edge_id_fk FOREIGN KEY (edge_id) REFERENCES public.photo(photo_id) ON DELETE CASCADE;


--
-- Name: users logo_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT logo_fk FOREIGN KEY (logo) REFERENCES public.photo(photo_id);


--
-- Name: messages messages_from_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_from_user_id_fk FOREIGN KEY (from_user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: messages messages_to_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_to_user_id_fk FOREIGN KEY (to_user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: coins mint_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.coins
    ADD CONSTRAINT mint_id_fk FOREIGN KEY (mint_id) REFERENCES public.mints(mint_id) ON DELETE CASCADE;


--
-- Name: coins obverse_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.coins
    ADD CONSTRAINT obverse_id_fk FOREIGN KEY (obverse_id) REFERENCES public.photo(photo_id) ON DELETE CASCADE;


--
-- Name: video owner_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.video
    ADD CONSTRAINT owner_id_fk FOREIGN KEY (owner_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: photo owner_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.photo
    ADD CONSTRAINT owner_id_fk FOREIGN KEY (owner_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: coins reverse_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.coins
    ADD CONSTRAINT reverse_id_fk FOREIGN KEY (reverse_id) REFERENCES public.photo(photo_id) ON DELETE CASCADE;


--
-- Name: coins series_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.coins
    ADD CONSTRAINT series_id_fk FOREIGN KEY (series_id) REFERENCES public.series(series_id) ON DELETE CASCADE;


--
-- Name: communities_users user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.communities_users
    ADD CONSTRAINT user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: coins user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.coins
    ADD CONSTRAINT user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: coins video_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: gb_user
--

ALTER TABLE ONLY public.coins
    ADD CONSTRAINT video_id_fk FOREIGN KEY (video_id) REFERENCES public.video(video_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

