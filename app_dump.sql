--
-- PostgreSQL database dump
--

-- Dumped from database version 14.1
-- Dumped by pg_dump version 14.1

-- Started on 2023-02-24 21:58:21 UTC

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
-- TOC entry 210 (class 1259 OID 26559)
-- Name: albums; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.albums (
    id integer NOT NULL,
    title text NOT NULL,
    year integer NOT NULL,
    artist_id integer NOT NULL,
    tracklist_length integer NOT NULL
);


ALTER TABLE public.albums OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 26558)
-- Name: albums_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.albums_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.albums_id_seq OWNER TO postgres;

--
-- TOC entry 3394 (class 0 OID 0)
-- Dependencies: 209
-- Name: albums_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.albums_id_seq OWNED BY public.albums.id;


--
-- TOC entry 221 (class 1259 OID 26829)
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 26587)
-- Name: artist_accounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.artist_accounts (
    id integer NOT NULL,
    username text NOT NULL,
    password text NOT NULL,
    email character varying(128)
);


ALTER TABLE public.artist_accounts OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 26586)
-- Name: artist_account_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.artist_account_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.artist_account_id_seq OWNER TO postgres;

--
-- TOC entry 3395 (class 0 OID 0)
-- Dependencies: 215
-- Name: artist_account_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.artist_account_id_seq OWNED BY public.artist_accounts.id;


--
-- TOC entry 214 (class 1259 OID 26577)
-- Name: artists; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.artists (
    id integer NOT NULL,
    name text NOT NULL,
    verified boolean DEFAULT false NOT NULL,
    followers integer,
    bio text,
    account_id integer NOT NULL
);


ALTER TABLE public.artists OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 26576)
-- Name: artist_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.artist_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.artist_id_seq OWNER TO postgres;

--
-- TOC entry 3396 (class 0 OID 0)
-- Dependencies: 213
-- Name: artist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.artist_id_seq OWNED BY public.artists.id;


--
-- TOC entry 212 (class 1259 OID 26568)
-- Name: songs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.songs (
    id integer NOT NULL,
    title text NOT NULL,
    year integer NOT NULL,
    album_id integer,
    artist_id integer NOT NULL,
    duration_in_secs integer NOT NULL
);


ALTER TABLE public.songs OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 26567)
-- Name: songs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.songs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.songs_id_seq OWNER TO postgres;

--
-- TOC entry 3397 (class 0 OID 0)
-- Dependencies: 211
-- Name: songs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.songs_id_seq OWNED BY public.songs.id;


--
-- TOC entry 218 (class 1259 OID 26598)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email text,
    username text NOT NULL,
    password text NOT NULL,
    private boolean DEFAULT false NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 26626)
-- Name: users_albums; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users_albums (
    user_id integer NOT NULL,
    album_id integer NOT NULL,
    rating integer NOT NULL
);


ALTER TABLE public.users_albums OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 26597)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 3398 (class 0 OID 0)
-- Dependencies: 217
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 219 (class 1259 OID 26621)
-- Name: users_songs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users_songs (
    user_id integer NOT NULL,
    song_id integer NOT NULL,
    rating integer NOT NULL
);


ALTER TABLE public.users_songs OWNER TO postgres;

--
-- TOC entry 3198 (class 2604 OID 26562)
-- Name: albums id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.albums ALTER COLUMN id SET DEFAULT nextval('public.albums_id_seq'::regclass);


--
-- TOC entry 3202 (class 2604 OID 26590)
-- Name: artist_accounts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artist_accounts ALTER COLUMN id SET DEFAULT nextval('public.artist_account_id_seq'::regclass);


--
-- TOC entry 3200 (class 2604 OID 26580)
-- Name: artists id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artists ALTER COLUMN id SET DEFAULT nextval('public.artist_id_seq'::regclass);


--
-- TOC entry 3199 (class 2604 OID 26571)
-- Name: songs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.songs ALTER COLUMN id SET DEFAULT nextval('public.songs_id_seq'::regclass);


--
-- TOC entry 3203 (class 2604 OID 26601)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3377 (class 0 OID 26559)
-- Dependencies: 210
-- Data for Name: albums; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.albums (id, title, year, artist_id, tracklist_length) FROM stdin;
1	The Dark Side of the Moon	1971	1	10
2	Whats Going On	1971	4	9
3	American Beauty	1970	3	10
4	Eagles	1972	2	10
5	Hotel California	1976	2	9
6	Wish You Were Here	1975	1	5
8	I Want You	1976	4	11
15	The Wall	1979	1	26
7	Skull & Roses	1971	3	11
\.


--
-- TOC entry 3388 (class 0 OID 26829)
-- Dependencies: 221
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alembic_version (version_num) FROM stdin;
31af8001d72a
\.


--
-- TOC entry 3383 (class 0 OID 26587)
-- Dependencies: 216
-- Data for Name: artist_accounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.artist_accounts (id, username, password, email) FROM stdin;
6	kendricklamar	58691b2dc62f546d25b03ce250d1db056548b13b11b6bca9798fd8ccdfbd5248ec22ac48c34688ce8492096aa16e2452153239229e311a925951abc83a703448	\N
7	peachpit	6992e326d3258684778eef1c5bcd4f68877df3dd5cb0fa69731c956352315371e9cf9d9480f536544ed9022cd69ac898c8a02fba62778dea6182a3ec8896d43b	\N
9	smino	ba9d4ffe8cb2f9712ce6d29315206466b8330b89491cc51e6de797354935a86161ac6e5b7fe1a66dcacd114ab41f1f5dc686270f870548b2f9fde5c162922102	\N
10	johnmayer	06812730d25c5ab6f510a2fb74fabb98721916d86d55f6aa9b9bf505a358240939c1a5588e5b2ccf7c18ff9bb58da8c5a38b15d123b3f55be470bc2a21473c12	john@gmail.com
1	pinkfloyd	23a74985e956b6a0bffd7e31acc84d944f5d1a09c2610bc27c698753054c78fa5fa71d0d3467a519eb72368a4044f59be79e77d73c07fb2e1156a5dbe43c1f9f	\N
2	eagles	862f55cfe40f639c247712c2bfbffaa3d76b049eed21dfed4e00f39a2c781166482a4b9ccd291a5a1a126de80f065d22a58fe2e421a995a5154f7a21d047761c	\N
3	gratefuldead	9cfa69460750300c8e3916ef1442e5f99a89283940ea217a30b264b16daa00ff8a01436556182eea4192671504eb7933e27c19d86cb8bae2e6de29384f90abd7	\N
4	marvingaye	ab839543ad535fadae147edaadf55b4e12ca1ede317ad3fa0723142edecaca1be50276c2766b79215ba4dea635bfddf7d749b1f48d76ed27e0a2a6a3aea71587	\N
\.


--
-- TOC entry 3381 (class 0 OID 26577)
-- Dependencies: 214
-- Data for Name: artists; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.artists (id, name, verified, followers, bio, account_id) FROM stdin;
1	Pink Floyd	t	17588457	Pink Floyd are one of the most successful and influential rock groups in history	1
2	Eagles	t	18152717	The Eagles were unquestionably the biggest mainstream American rock band to emerge in the 1970s	2
3	Grateful Dead	t	2310235	The Grateful Dead were the psychedelic eras most beloved ambassadors	3
4	Marvin Gaye	t	14356610	Few figures in American music in the 20th century can compare to Marvin Gaye	4
\.


--
-- TOC entry 3379 (class 0 OID 26568)
-- Dependencies: 212
-- Data for Name: songs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.songs (id, title, year, album_id, artist_id, duration_in_secs) FROM stdin;
9	Wish You Were Here	1975	6	1	334
7	I Want You	1976	8	4	274
8	Mama Tried	1971	7	3	162
6	Hotel California	1976	5	2	391
5	Train Leaves Here This Morning	1972	4	2	250
4	Shine On You Crazy Diamond	1975	6	1	1558
3	Us and Them	1971	1	1	469
2	Ripple	1970	3	3	248
1	Whats Going On	1971	2	4	233
\.


--
-- TOC entry 3385 (class 0 OID 26598)
-- Dependencies: 218
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, username, password, private) FROM stdin;
2	bob@gmail.com	bob	c4681c828b855864a9b651249426c4d8408fdd9f227199a7b6bd8157aed1acfa7b0dea0c1b0ea350c43c3feec97c591e9cbd94846398a0dbb3c90fddeefc8a88	t
9	stacey@gmail.com	stacey	13bf3d33279ca8a92f7cc9e15faca726376c737077b9754813e15d31b7a7d2255bc4becce5bc3676cdd335086796130be9f1b194a7ed7a3803e28fc285c05854	f
10	zack@gmail.com	zack	27ee08a3ac60b13fd2f48d8449992e39b147a22e259253c0e1a81619d357cb82b2996bb2df45fbcdceb791beec5c529d8ed9c3a1e752efd48788127716b962b8	f
17	jason@gmail.com	jason	03903b197c5bb97c17be34af3aa9ad5d6fd11ccf57f24bb3fb9d3a9d7dff410ea480af23b2e911c56613ea1408253b510e85d3eab9a2d9a9a3eb816ec228683a	f
1	kyle@gmail.com	kyle	6ae6169f434bee2500a7fbc57b4c2a40a2ff3d6caa55039dbbdd59ae01aa63c3ec6dc803e3125479ea86ca71d01adb46b7201f22bf98a38fd546047ce06d6ba0	t
\.


--
-- TOC entry 3387 (class 0 OID 26626)
-- Dependencies: 220
-- Data for Name: users_albums; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users_albums (user_id, album_id, rating) FROM stdin;
1	1	10
1	2	10
1	3	8
1	4	9
1	5	10
1	6	10
1	7	9
1	8	9
2	15	10
2	8	8
\.


--
-- TOC entry 3386 (class 0 OID 26621)
-- Dependencies: 219
-- Data for Name: users_songs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users_songs (user_id, song_id, rating) FROM stdin;
1	2	10
1	3	10
1	4	10
1	5	9
1	6	10
1	7	9
1	8	8
2	2	7
1	1	10
2	1	10
\.


--
-- TOC entry 3399 (class 0 OID 0)
-- Dependencies: 209
-- Name: albums_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.albums_id_seq', 15, true);


--
-- TOC entry 3400 (class 0 OID 0)
-- Dependencies: 215
-- Name: artist_account_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.artist_account_id_seq', 10, true);


--
-- TOC entry 3401 (class 0 OID 0)
-- Dependencies: 213
-- Name: artist_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.artist_id_seq', 5, true);


--
-- TOC entry 3402 (class 0 OID 0)
-- Dependencies: 211
-- Name: songs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.songs_id_seq', 11, true);


--
-- TOC entry 3403 (class 0 OID 0)
-- Dependencies: 217
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 17, true);


--
-- TOC entry 3206 (class 2606 OID 26566)
-- Name: albums albums_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.albums
    ADD CONSTRAINT albums_pkey PRIMARY KEY (id);


--
-- TOC entry 3228 (class 2606 OID 26833)
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- TOC entry 3212 (class 2606 OID 26594)
-- Name: artist_accounts artist_account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artist_accounts
    ADD CONSTRAINT artist_account_pkey PRIMARY KEY (id);


--
-- TOC entry 3214 (class 2606 OID 26596)
-- Name: artist_accounts artist_account_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artist_accounts
    ADD CONSTRAINT artist_account_username_key UNIQUE (username);


--
-- TOC entry 3216 (class 2606 OID 26864)
-- Name: artist_accounts artist_accounts_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artist_accounts
    ADD CONSTRAINT artist_accounts_email_key UNIQUE (email);


--
-- TOC entry 3210 (class 2606 OID 26585)
-- Name: artists artist_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artists
    ADD CONSTRAINT artist_pkey PRIMARY KEY (id);


--
-- TOC entry 3208 (class 2606 OID 26575)
-- Name: songs songs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.songs
    ADD CONSTRAINT songs_pkey PRIMARY KEY (id);


--
-- TOC entry 3226 (class 2606 OID 26630)
-- Name: users_albums users_albums_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_albums
    ADD CONSTRAINT users_albums_pkey PRIMARY KEY (user_id, album_id);


--
-- TOC entry 3218 (class 2606 OID 26608)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 3220 (class 2606 OID 26606)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3224 (class 2606 OID 26625)
-- Name: users_songs users_songs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_songs
    ADD CONSTRAINT users_songs_pkey PRIMARY KEY (user_id, song_id);


--
-- TOC entry 3222 (class 2606 OID 26610)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 3229 (class 2606 OID 26641)
-- Name: albums fk_albums_artists; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.albums
    ADD CONSTRAINT fk_albums_artists FOREIGN KEY (artist_id) REFERENCES public.artists(id);


--
-- TOC entry 3232 (class 2606 OID 26646)
-- Name: artists fk_artists_artist_accounts; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artists
    ADD CONSTRAINT fk_artists_artist_accounts FOREIGN KEY (account_id) REFERENCES public.artist_accounts(id);


--
-- TOC entry 3230 (class 2606 OID 26631)
-- Name: songs fk_songs_albums; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.songs
    ADD CONSTRAINT fk_songs_albums FOREIGN KEY (album_id) REFERENCES public.albums(id);


--
-- TOC entry 3231 (class 2606 OID 26636)
-- Name: songs fk_songs_artists; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.songs
    ADD CONSTRAINT fk_songs_artists FOREIGN KEY (artist_id) REFERENCES public.artists(id);


--
-- TOC entry 3236 (class 2606 OID 26656)
-- Name: users_albums fk_users_albums_albums; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_albums
    ADD CONSTRAINT fk_users_albums_albums FOREIGN KEY (album_id) REFERENCES public.albums(id);


--
-- TOC entry 3235 (class 2606 OID 26651)
-- Name: users_albums fk_users_albums_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_albums
    ADD CONSTRAINT fk_users_albums_users FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 3234 (class 2606 OID 26666)
-- Name: users_songs fk_users_songs_songs; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_songs
    ADD CONSTRAINT fk_users_songs_songs FOREIGN KEY (song_id) REFERENCES public.songs(id);


--
-- TOC entry 3233 (class 2606 OID 26661)
-- Name: users_songs fk_users_songs_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_songs
    ADD CONSTRAINT fk_users_songs_users FOREIGN KEY (user_id) REFERENCES public.users(id);


-- Completed on 2023-02-24 21:58:22 UTC

--
-- PostgreSQL database dump complete
--

