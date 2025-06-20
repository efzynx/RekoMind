--
-- PostgreSQL database dump
--

-- Dumped from database version 16.8 (Debian 16.8-1.pgdg120+1)
-- Dumped by pg_dump version 16.8 (Debian 16.8-1.pgdg120+1)

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
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: quiz_app_user
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO quiz_app_user;

--
-- Name: quiz_attempt; Type: TABLE; Schema: public; Owner: quiz_app_user
--

CREATE TABLE public.quiz_attempt (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    score double precision NOT NULL,
    total_questions integer NOT NULL,
    correct_answers integer NOT NULL,
    categories_played text,
    "timestamp" timestamp with time zone NOT NULL
);


ALTER TABLE public.quiz_attempt OWNER TO quiz_app_user;

--
-- Name: user; Type: TABLE; Schema: public; Owner: quiz_app_user
--

CREATE TABLE public."user" (
    id uuid NOT NULL,
    email character varying(320) NOT NULL,
    hashed_password character varying(1024) NOT NULL,
    is_active boolean NOT NULL,
    is_superuser boolean NOT NULL,
    is_verified boolean NOT NULL,
    name character varying(150),
    education_level character varying(50),
    institution_name character varying(200),
    favorite_subjects text
);


ALTER TABLE public."user" OWNER TO quiz_app_user;

--
-- Name: user_answer_detail; Type: TABLE; Schema: public; Owner: quiz_app_user
--

CREATE TABLE public.user_answer_detail (
    id integer NOT NULL,
    quiz_attempt_id uuid NOT NULL,
    user_id uuid NOT NULL,
    question_text text NOT NULL,
    options_presented jsonb,
    user_answer text NOT NULL,
    correct_answer text NOT NULL,
    is_correct boolean NOT NULL,
    category_name character varying(255),
    difficulty character varying(50),
    "timestamp" timestamp with time zone NOT NULL
);


ALTER TABLE public.user_answer_detail OWNER TO quiz_app_user;

--
-- Name: user_answer_detail_id_seq; Type: SEQUENCE; Schema: public; Owner: quiz_app_user
--

CREATE SEQUENCE public.user_answer_detail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_answer_detail_id_seq OWNER TO quiz_app_user;

--
-- Name: user_answer_detail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: quiz_app_user
--

ALTER SEQUENCE public.user_answer_detail_id_seq OWNED BY public.user_answer_detail.id;


--
-- Name: user_answer_detail id; Type: DEFAULT; Schema: public; Owner: quiz_app_user
--

ALTER TABLE ONLY public.user_answer_detail ALTER COLUMN id SET DEFAULT nextval('public.user_answer_detail_id_seq'::regclass);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: quiz_app_user
--

COPY public.alembic_version (version_num) FROM stdin;
1a1f038833d9
\.


--
-- Data for Name: quiz_attempt; Type: TABLE DATA; Schema: public; Owner: quiz_app_user
--

COPY public.quiz_attempt (id, user_id, score, total_questions, correct_answers, categories_played, "timestamp") FROM stdin;
aa49853a-9ddc-47d4-aa3e-1ca9c524ac8a	db41e912-effa-4b18-866d-661544d15b84	100	10	10	Science: Computers	2025-05-12 11:14:06.671662+00
aa55a4df-4c27-4998-a66a-40abed697bff	db41e912-effa-4b18-866d-661544d15b84	100	10	10	Science: Computers	2025-05-12 11:19:10.692563+00
a2c03233-b17e-4ca7-8d70-deb9e13744a1	db41e912-effa-4b18-866d-661544d15b84	100	10	10	Science: Computers	2025-05-14 04:04:23.429267+00
1d0532a1-5f4f-4742-ba2f-63debb261580	db41e912-effa-4b18-866d-661544d15b84	33.33	3	1	Science: Computers	2025-05-14 06:02:58.398454+00
e0408bba-109a-49eb-b0e4-c888cf7f442d	56e53446-74d9-467a-99a7-f55c56939bb4	30	10	3	Science: Computers	2025-05-14 06:03:56.914363+00
3ec49de2-e677-44d0-8e03-1e82497bf63d	db41e912-effa-4b18-866d-661544d15b84	20	10	2	Science: Computers	2025-05-14 06:14:47.512461+00
da8aff90-1f81-499a-8c15-02e58986be17	db41e912-effa-4b18-866d-661544d15b84	20	10	2	Science: Computers	2025-05-14 06:24:01.536045+00
5b1af7d3-487b-4ed8-9422-ac86d58c2dd3	db41e912-effa-4b18-866d-661544d15b84	0	10	0	Science: Gadgets	2025-05-14 06:24:42.543464+00
a4e83a13-d3b5-4738-8428-c41a16746c17	db41e912-effa-4b18-866d-661544d15b84	40	10	4	Entertainment: Japanese Anime & Manga, Entertainment: Video Games, History, Mythology, Science & Nature, Sports	2025-05-14 06:25:17.349668+00
99cf70aa-e3ec-44ab-9664-182fd50c5274	db41e912-effa-4b18-866d-661544d15b84	40	10	4	Science: Computers	2025-05-14 06:47:21.402618+00
c6eccb5c-7569-4264-a161-192fe4c67532	db41e912-effa-4b18-866d-661544d15b84	40	10	4	Science: Computers	2025-05-14 06:58:07.332085+00
4df0f870-5d27-405a-b1c3-7e781ef2eb9a	db41e912-effa-4b18-866d-661544d15b84	100	2	2	Science: Computers, Science: Gadgets	2025-05-14 06:59:13.589361+00
d175f88a-32fc-4ae5-9a8c-b5e4e09041d9	56e53446-74d9-467a-99a7-f55c56939bb4	20	10	2	Animals	2025-05-14 07:04:35.895338+00
d313ef0f-1305-4349-a59b-61a9ca5df7d4	db41e912-effa-4b18-866d-661544d15b84	60	10	6	Science: Computers	2025-05-14 08:08:25.150164+00
a998f9aa-58b5-412b-827b-633e07aa2600	db41e912-effa-4b18-866d-661544d15b84	60	10	6	Science: Computers	2025-05-14 08:30:12.321909+00
6e1e80bc-62bd-4610-a0cd-2044166a5fea	db41e912-effa-4b18-866d-661544d15b84	40	10	4	Science: Gadgets	2025-05-14 08:37:30.740121+00
dd49de63-f954-4c91-9d46-8b347f2725ae	db41e912-effa-4b18-866d-661544d15b84	0	1	0	Science: Gadgets	2025-05-14 08:37:56.075528+00
2ca8fab2-805d-47e7-a651-ce56734ef5d1	db41e912-effa-4b18-866d-661544d15b84	50	10	5	Science: Computers	2025-05-14 10:32:25.410855+00
b2e2a196-73ca-4bb6-bd6c-7f99c0b523ee	db41e912-effa-4b18-866d-661544d15b84	50	4	2	Science: Computers	2025-05-14 10:34:02.073787+00
1710ed29-73ef-4d46-8da3-2477943d2e9b	db41e912-effa-4b18-866d-661544d15b84	100	1	1	Science: Computers	2025-05-14 10:36:31.088901+00
b4d88459-3258-4674-86bd-b321adca637a	db41e912-effa-4b18-866d-661544d15b84	0	1	0	Science: Computers	2025-05-14 10:36:51.994911+00
77044ae3-3980-4434-b014-45512fb44a57	db41e912-effa-4b18-866d-661544d15b84	0	1	0	Science: Computers	2025-05-14 10:48:18.521291+00
970d5888-8de0-491e-8ba7-caa55069ac8e	db41e912-effa-4b18-866d-661544d15b84	20	10	2	Entertainment: Board Games, Entertainment: Cartoon & Animations, Entertainment: Japanese Anime & Manga, Entertainment: Music, Entertainment: Video Games, History, Sports	2025-05-14 11:00:37.767941+00
386a8988-e500-4aba-8699-5cddc6cfeb1e	db41e912-effa-4b18-866d-661544d15b84	40	5	2	Science: Computers, Science: Gadgets	2025-05-14 11:06:06.305903+00
f22e44f0-9b40-45c2-81bf-9fbdbfe8cc5b	db41e912-effa-4b18-866d-661544d15b84	0	2	0	Science: Computers	2025-05-14 11:14:51.534563+00
c656e73a-538f-4d5a-bcd3-4db7e6c2eb8b	db41e912-effa-4b18-866d-661544d15b84	50	2	1	Science: Computers	2025-05-14 11:27:11.085235+00
e8534d38-f65b-4285-a20d-f2f258e2db25	db41e912-effa-4b18-866d-661544d15b84	30	10	3	Science: Computers	2025-05-14 11:37:53.49793+00
5af7f209-38b6-41ce-8d5d-3d8abe7566a4	db41e912-effa-4b18-866d-661544d15b84	10	10	1	Science: Gadgets	2025-05-14 11:43:03.676648+00
728f1f8c-cdbf-4f9f-a5e5-16edbac0ada0	db41e912-effa-4b18-866d-661544d15b84	40	10	4	Science: Gadgets	2025-05-14 11:47:41.782771+00
4f590314-9db8-4694-8764-e1aaf4e4d420	db41e912-effa-4b18-866d-661544d15b84	20	10	2	Science: Gadgets	2025-05-14 11:49:42.554614+00
204d40bb-fcb9-4442-9f11-3b2744d9cd6c	db41e912-effa-4b18-866d-661544d15b84	20	10	2	Entertainment: Cartoon & Animations, Entertainment: Music, Entertainment: Television, Entertainment: Video Games, General Knowledge, Vehicles	2025-05-14 11:50:16.081843+00
f9d618be-27c7-4a21-9b77-b28b54046b7b	db41e912-effa-4b18-866d-661544d15b84	40	10	4	Science: Gadgets	2025-05-14 12:00:51.408456+00
2bfc59f8-9fbd-43ba-8409-1168d5411fa7	db41e912-effa-4b18-866d-661544d15b84	50	10	5	Science: Gadgets	2025-05-14 12:12:42.981864+00
14c34f15-13f9-4efb-94e2-3ebcc52223bc	db41e912-effa-4b18-866d-661544d15b84	30	10	3	Science: Computers	2025-05-14 12:22:23.564407+00
98b8d322-3ff9-46e8-ba98-33c44d692f1c	db41e912-effa-4b18-866d-661544d15b84	0	2	0	Science: Computers	2025-05-14 12:37:02.545032+00
8b97d9b6-4385-4a25-add4-8d56c7bd2fe6	db41e912-effa-4b18-866d-661544d15b84	70	10	7	Science: Computers	2025-05-14 12:47:39.765251+00
355ebafe-92f3-49da-81a9-12cd06e5711c	db41e912-effa-4b18-866d-661544d15b84	70	10	7	Science: Computers	2025-05-14 13:01:45.947327+00
4e96fb3b-5714-424b-82a2-43e30b6f8073	db41e912-effa-4b18-866d-661544d15b84	70	10	7	Science: Computers	2025-05-14 13:32:04.354473+00
673be6b0-7c10-4263-aae0-ae4e6d72c749	db41e912-effa-4b18-866d-661544d15b84	70	10	7	Science: Computers	2025-05-14 14:13:14.955455+00
b5d58378-fa1b-4ad7-bec6-addaf173950d	db41e912-effa-4b18-866d-661544d15b84	80	10	8	Science: Computers	2025-05-14 14:19:15.99681+00
8e14a6ac-262d-498e-a223-3d302be0c90f	db41e912-effa-4b18-866d-661544d15b84	10	10	1	Science: Computers	2025-05-14 14:34:01.776802+00
c5a6db75-5d1f-4f7d-97f1-466dde2d1996	db41e912-effa-4b18-866d-661544d15b84	10	10	1	Entertainment: Books, Entertainment: Cartoon & Animations, Entertainment: Television, Entertainment: Video Games, General Knowledge, Geography, History	2025-05-14 14:36:20.345567+00
c09e9d45-aeb9-4f0c-987a-1d9d305c8480	db41e912-effa-4b18-866d-661544d15b84	40	10	4	Entertainment: Books, Entertainment: Music, Entertainment: Television, Entertainment: Video Games, General Knowledge, Mythology, Science & Nature	2025-05-14 14:37:30.082916+00
ec17809f-296e-4c30-b919-9da70a707755	56e53446-74d9-467a-99a7-f55c56939bb4	30	10	3	Animals, Entertainment: Music, Entertainment: Video Games, Geography, History, Vehicles	2025-05-14 14:41:31.259986+00
ef8fec2a-6323-4b5d-8507-18d6cdaf3016	56e53446-74d9-467a-99a7-f55c56939bb4	20	10	2	Celebrities, Entertainment: Film, Entertainment: Television, Entertainment: Video Games, General Knowledge, Science: Computers, Vehicles	2025-05-14 14:43:47.346377+00
45cced86-79dd-43c7-ab0d-613d41af17b9	db41e912-effa-4b18-866d-661544d15b84	20	10	2	Science: Computers	2025-05-14 14:51:17.834267+00
7bac0939-65b5-4204-b991-b0c6ba18a3f3	db41e912-effa-4b18-866d-661544d15b84	10	10	1	Celebrities, Entertainment: Film, Entertainment: Music, Entertainment: Video Games, General Knowledge, Geography, Sports, Vehicles	2025-05-14 14:52:09.200954+00
50e11cce-2ce7-4613-9a20-03a1f6362896	db41e912-effa-4b18-866d-661544d15b84	40	10	4	Entertainment: Board Games, Entertainment: Television, Entertainment: Video Games, General Knowledge, Geography, History, Science: Gadgets, Sports	2025-05-14 16:28:42.856149+00
a6cbfe43-06a6-4587-af6b-62780b3f655f	db41e912-effa-4b18-866d-661544d15b84	20	10	2	Science: Computers	2025-05-15 03:33:43.983947+00
9d81f16e-bb92-4fa8-9c56-2a086a44350c	db41e912-effa-4b18-866d-661544d15b84	40	10	4	Science: Computers	2025-05-15 05:12:31.171756+00
49676ebc-58ef-4490-bdd6-9562dbc1c74a	db41e912-effa-4b18-866d-661544d15b84	20	10	2	Entertainment: Cartoon & Animations, Entertainment: Film, Entertainment: Music, Entertainment: Video Games, General Knowledge, Geography, History, Science & Nature, Vehicles	2025-05-17 05:06:59.779116+00
56484960-af54-4fcb-b1af-84a31f93a42a	2348a6fb-3244-4187-9969-ba1452dd5397	30	10	3	Mythology	2025-05-17 11:28:16.685393+00
662a5441-6c75-4031-9b82-115a69f3d6fa	2348a6fb-3244-4187-9969-ba1452dd5397	40	10	4	Sports	2025-05-17 11:33:24.586646+00
3b4778f2-d479-4086-821f-df1010d271eb	2348a6fb-3244-4187-9969-ba1452dd5397	40	10	4	Science & Nature	2025-05-19 07:42:57.36884+00
c066363a-09bf-4512-b7ed-13facc5451ef	2348a6fb-3244-4187-9969-ba1452dd5397	60	10	6	Science: Computers	2025-05-19 07:46:53.750095+00
5091a420-926f-4063-a0cf-149517dde0a2	2348a6fb-3244-4187-9969-ba1452dd5397	50	10	5	Science: Computers	2025-05-19 07:53:32.254918+00
be9e1502-0f42-45cb-9063-70e17012b02c	db41e912-effa-4b18-866d-661544d15b84	10	10	1	Science: Computers	2025-05-19 07:58:51.410159+00
5bc2110c-ca85-41c1-820d-0a33b481359b	db41e912-effa-4b18-866d-661544d15b84	50	10	5	Science: Computers	2025-05-19 08:47:39.255566+00
febc8b99-6af5-4c4c-883b-a650d6680c14	db41e912-effa-4b18-866d-661544d15b84	10	10	1	Celebrities, Entertainment: Music, Entertainment: Musicals & Theatres, Entertainment: Video Games, Mythology, Science & Nature	2025-05-19 09:10:44.008585+00
8c6bf92c-c569-434d-95ed-72590140d630	db41e912-effa-4b18-866d-661544d15b84	20	10	2	Entertainment: Film, Entertainment: Music, Entertainment: Television, Entertainment: Video Games, General Knowledge, Mythology, Science: Gadgets	2025-05-19 09:16:29.454395+00
f50428c6-717a-44f7-bc07-833ed58009bf	db41e912-effa-4b18-866d-661544d15b84	40	10	4	Entertainment: Comics, Entertainment: Film, Entertainment: Music, Entertainment: Video Games, Geography	2025-05-19 09:21:47.206472+00
0e74bf14-e119-4719-98a2-422a04497ca5	db41e912-effa-4b18-866d-661544d15b84	0	10	0	Entertainment: Film, Entertainment: Japanese Anime & Manga, Entertainment: Music, Entertainment: Musicals & Theatres, Entertainment: Video Games, General Knowledge, Science & Nature	2025-05-19 13:53:49.429832+00
310dc814-85d7-4505-91c9-d007c11e2f41	db41e912-effa-4b18-866d-661544d15b84	20	10	2	Art, Entertainment: Board Games, Entertainment: Film, Entertainment: Japanese Anime & Manga, Entertainment: Video Games, History, Science & Nature	2025-05-19 13:56:04.98245+00
cdfed960-cea5-4501-95af-0ee9835523d5	db41e912-effa-4b18-866d-661544d15b84	30	10	3	Animals, Entertainment: Music, Entertainment: Television, Entertainment: Video Games, History, Mythology	2025-05-19 14:06:14.059395+00
a5457cb8-8058-4ca2-9b4e-a0cadf8cff04	db41e912-effa-4b18-866d-661544d15b84	60	10	6	Science: Computers	2025-05-19 14:09:08.251826+00
a07be9d0-f12c-4220-aaa6-7975ba709c3a	db41e912-effa-4b18-866d-661544d15b84	40	10	4	Science: Computers	2025-05-19 14:14:35.514941+00
730d7c7e-a7b2-4b3b-93f3-d17873b99e4d	db41e912-effa-4b18-866d-661544d15b84	30	10	3	Science: Computers	2025-05-19 14:16:10.160293+00
ff6217ed-654c-4c41-b75f-f1c6eda1466e	7fa86fcc-87db-4391-8f20-7a633f1b77d0	20	10	2	Science: Mathematics	2025-05-19 14:24:00.884132+00
330c7aa7-6fd7-473c-97ed-8aeb8f40b04e	c6652b7b-9a93-4b77-b8e2-fcc89f656e59	40	10	4	Animals	2025-05-24 14:23:28.86355+00
442c43c9-118c-4e01-acde-b07706f96324	db41e912-effa-4b18-866d-661544d15b84	40	10	4	Science: Computers	2025-06-01 02:44:27.171419+00
cca7dfa1-0c01-40e5-ac8d-65b9033460d0	db41e912-effa-4b18-866d-661544d15b84	0	10	0	Science: Computers	2025-06-01 02:46:11.965635+00
ef599e1c-9a3b-4749-ad22-1cca4cdcf90f	db41e912-effa-4b18-866d-661544d15b84	60	10	6	Science: Computers	2025-06-01 03:02:22.747886+00
be7d757e-6bb3-4902-aa8b-eb515980293f	90bdd136-034b-4ec0-a527-bc308bcc1a2f	33.33	3	1	Science: Computers, Science: Mathematics	2025-06-12 10:45:24.333846+00
c3c818d7-0447-4502-8509-db0080f3284b	90bdd136-034b-4ec0-a527-bc308bcc1a2f	50	10	5	Science: Computers	2025-06-12 10:46:53.926215+00
4d828ccc-0805-4750-ae25-3e41bb4bbf4a	7d1154e2-46ef-4534-8f41-fe568ee8663b	30	10	3	Animals, Entertainment: Film, Entertainment: Japanese Anime & Manga, Entertainment: Music, Entertainment: Television, Entertainment: Video Games, History, Science: Computers, Science: Gadgets	2025-06-14 13:24:18.451582+00
109b516f-ef36-4d5b-a881-5047854ed4a9	7d1154e2-46ef-4534-8f41-fe568ee8663b	50	10	5	Science & Nature	2025-06-14 13:25:59.720222+00
dd42aef5-db01-48eb-b547-6de8b0aa0c6a	7d1154e2-46ef-4534-8f41-fe568ee8663b	90	10	9	Science: Computers	2025-06-14 13:29:10.003561+00
501bd7c4-66eb-4f3f-933d-f8cbcf1be9e6	7d1154e2-46ef-4534-8f41-fe568ee8663b	20	10	2	Science: Computers	2025-06-14 13:30:16.362094+00
2d73f411-60ef-4bee-ae91-89926a3e9e3f	2348a6fb-3244-4187-9969-ba1452dd5397	30	10	3	Science: Computers	2025-06-14 13:32:20.22958+00
743f01c0-1991-4d9f-8f34-8ed332ebf31c	7d1154e2-46ef-4534-8f41-fe568ee8663b	20	10	2	Animals	2025-06-19 03:31:18.904486+00
768a2c3f-1686-4fe1-b3cc-98725c654af9	7d1154e2-46ef-4534-8f41-fe568ee8663b	40	10	4	Art	2025-06-19 03:40:31.043789+00
dcaa9d26-dc50-475b-b867-363fd35e2f30	7d1154e2-46ef-4534-8f41-fe568ee8663b	20	10	2	Celebrities	2025-06-19 03:41:27.129308+00
e744116f-3da0-4250-b0ba-41999b6da129	7d1154e2-46ef-4534-8f41-fe568ee8663b	10	10	1	Entertainment: Board Games	2025-06-19 03:42:16.100751+00
53db1df2-b39c-45aa-addd-8d03b5c9d4f0	7d1154e2-46ef-4534-8f41-fe568ee8663b	20	10	2	Entertainment: Books	2025-06-19 03:42:53.739128+00
6e83e170-a7dd-4aca-9351-6afa42d87aea	7d1154e2-46ef-4534-8f41-fe568ee8663b	50	10	5	Entertainment: Cartoon & Animations	2025-06-19 03:43:25.924489+00
2ada816b-5e34-4b93-9faa-28dccd82a689	7d1154e2-46ef-4534-8f41-fe568ee8663b	30	10	3	Entertainment: Comics	2025-06-19 03:44:05.092943+00
e93f0cd8-b203-4599-b702-e858e4888b2a	7d1154e2-46ef-4534-8f41-fe568ee8663b	20	10	2	Entertainment: Film	2025-06-19 03:47:13.937645+00
c878784f-1c01-4531-9832-5ebe9f7a15dd	7d1154e2-46ef-4534-8f41-fe568ee8663b	10	10	1	Entertainment: Musicals & Theatres	2025-06-19 03:49:16.439872+00
d583d3b7-110c-4d76-94f3-a81a830235e8	7d1154e2-46ef-4534-8f41-fe568ee8663b	20	10	2	Entertainment: Television	2025-06-19 03:50:10.625928+00
623b8231-e6df-426f-8725-48764aa9e8ae	7d1154e2-46ef-4534-8f41-fe568ee8663b	30	10	3	Entertainment: Video Games	2025-06-19 03:51:23.491233+00
ecd51e41-2cf9-42ae-8328-8a04e7a89f4d	7d1154e2-46ef-4534-8f41-fe568ee8663b	10	10	1	General Knowledge	2025-06-19 03:52:04.728743+00
4036abf3-de84-4ce9-b0a4-7beff6ed7871	7d1154e2-46ef-4534-8f41-fe568ee8663b	40	10	4	Geography	2025-06-19 03:52:58.793885+00
27c2f83c-af8b-49fa-83bf-b19dd9e23817	7d1154e2-46ef-4534-8f41-fe568ee8663b	30	10	3	History	2025-06-19 03:53:37.773582+00
fb5cb953-ce03-444d-ba6c-38e5d7f3904f	7d1154e2-46ef-4534-8f41-fe568ee8663b	40	10	4	Mythology	2025-06-19 03:54:30.773674+00
ba5d6417-5e5f-4616-bb46-da23bedcd2db	7d1154e2-46ef-4534-8f41-fe568ee8663b	40	10	4	Politics	2025-06-19 03:55:20.224055+00
c7d0131a-f38d-480e-9743-04a12add675f	7d1154e2-46ef-4534-8f41-fe568ee8663b	30	10	3	Science & Nature	2025-06-19 03:55:54.552124+00
fc97de5c-054d-4f0a-b96a-8eb890818073	7d1154e2-46ef-4534-8f41-fe568ee8663b	40	10	4	Science: Computers	2025-06-19 03:57:34.008068+00
38794c98-30b2-414b-aa0a-093664ae6cb2	7d1154e2-46ef-4534-8f41-fe568ee8663b	40	10	4	Science: Gadgets	2025-06-19 03:59:26.375031+00
14e19520-c402-4ba5-9338-832bff42540a	7d1154e2-46ef-4534-8f41-fe568ee8663b	10	10	1	Science: Mathematics	2025-06-19 04:00:18.549908+00
90c493f0-dcfa-40fe-b1ff-f126a92c2d96	7d1154e2-46ef-4534-8f41-fe568ee8663b	50	10	5	Sports	2025-06-19 04:00:53.583781+00
2b0caa58-8083-4678-acdb-72930a00727f	7d1154e2-46ef-4534-8f41-fe568ee8663b	20	10	2	Vehicles	2025-06-19 04:01:36.978134+00
2714d39c-2e70-4efe-810b-89f6c35d831a	90bdd136-034b-4ec0-a527-bc308bcc1a2f	60	10	6	Animals	2025-06-19 04:05:03.070211+00
dc82fc9a-ad64-4a50-8fac-0e2c3b340ccd	6a96be88-aec5-4aba-8b78-6aa2693cfa18	90	10	9	Entertainment: Japanese Anime & Manga	2025-06-19 04:09:15.352994+00
b7edd887-0abf-4e46-9b8e-55b134fad996	6a96be88-aec5-4aba-8b78-6aa2693cfa18	90	10	9	Entertainment: Comics	2025-06-19 04:12:07.225726+00
54434b25-2d8d-4e90-ab4c-1dba826f6ea8	6a96be88-aec5-4aba-8b78-6aa2693cfa18	30	10	3	Entertainment: Music	2025-06-19 04:12:45.76865+00
b8098889-3a02-4585-8551-3b33db8b7978	6a96be88-aec5-4aba-8b78-6aa2693cfa18	70	10	7	Science: Computers	2025-06-19 04:42:31.329199+00
84d18272-b73a-4837-b7c7-906464d1bebf	6a96be88-aec5-4aba-8b78-6aa2693cfa18	80	10	8	Science: Computers	2025-06-19 04:46:49.046713+00
8d0146b0-5c0b-4329-a7ba-8ef4229789cd	5ff9ae62-1c6f-4894-a133-adeef163e141	10	10	1	Science: Gadgets	2025-06-19 05:00:23.273518+00
f6d72f6a-c320-4e92-bf6a-a61f4bcb6116	8e3d46bf-7b38-4c25-97c7-cc74e7dee8b0	80	10	8	General Knowledge	2025-06-19 05:24:54.60844+00
8b7f7a3a-a95e-4ead-ae85-98af364b1e11	8e3d46bf-7b38-4c25-97c7-cc74e7dee8b0	80	10	8	General Knowledge	2025-06-19 05:27:59.658197+00
d8fe1928-f390-42c8-863d-242792c4bd79	01e1003d-da05-4156-bfa4-b152c2a10c09	0	5	0	Entertainment: Japanese Anime & Manga, Science: Computers	2025-06-19 06:17:13.942449+00
2ead92d7-2acd-400b-8e6c-5e479b233df0	01e1003d-da05-4156-bfa4-b152c2a10c09	20	10	2	Entertainment: Japanese Anime & Manga	2025-06-19 06:19:32.858676+00
5575394d-c096-4ad8-ab4f-b850fbc0cab9	b7496375-ca27-487a-a9a0-33fb6e1f14c8	40	10	4	Science: Mathematics	2025-06-19 07:16:02.490076+00
86c9dab4-8981-4684-82b1-be5629d3711b	b7496375-ca27-487a-a9a0-33fb6e1f14c8	100	10	10	Mythology	2025-06-19 07:39:29.487751+00
4921ec34-b970-4e9d-b850-5c05999ad4e0	b7496375-ca27-487a-a9a0-33fb6e1f14c8	20	10	2	Animals	2025-06-19 11:22:32.915913+00
ec5ea9ca-be5b-4c93-90c1-6d9b9713cf0d	b7496375-ca27-487a-a9a0-33fb6e1f14c8	30	10	3	Animals	2025-06-19 11:23:08.055877+00
fd0bb875-7103-422e-bbe7-388dad60f59f	b7496375-ca27-487a-a9a0-33fb6e1f14c8	30	10	3	Sports	2025-06-19 11:24:25.433472+00
c715cc4b-4c82-4a8a-b61d-b893a6302345	8e3d46bf-7b38-4c25-97c7-cc74e7dee8b0	40	10	4	General Knowledge	2025-06-19 11:28:27.038457+00
101780f1-5613-46c4-88e4-5494df98cd08	b7496375-ca27-487a-a9a0-33fb6e1f14c8	40	10	4	Celebrities	2025-06-19 11:39:38.577289+00
5ef46980-a6e4-4ad8-ba13-ddce448d64d9	b7496375-ca27-487a-a9a0-33fb6e1f14c8	30	10	3	Art	2025-06-19 11:50:02.707513+00
d918d4e4-50e2-4f69-80a4-781d4758d080	b7496375-ca27-487a-a9a0-33fb6e1f14c8	20	10	2	Geography	2025-06-19 11:53:21.700886+00
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: quiz_app_user
--

COPY public."user" (id, email, hashed_password, is_active, is_superuser, is_verified, name, education_level, institution_name, favorite_subjects) FROM stdin;
db41e912-effa-4b18-866d-661544d15b84	namida@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$BVUTKCy2MGIY2NmSCqVPpQ$bXhPu8yb4tw+YyHzFkYqV1y4hfQxda6PKa1rvJHbeck	t	f	f	fauzan adiman	Mahasiswa	nurul jadid	coding
56e53446-74d9-467a-99a7-f55c56939bb4	namida2@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$HceJeNTxzM+7u990nJZ9Tw$3U3Sfg3MuYoItcjRY9CgBkMZ80fI/saV70TqeqwCyC8	t	f	f	Namida	Mahasiswa	Nurul jadid	Fisika
2348a6fb-3244-4187-9969-ba1452dd5397	usenpusen1@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$WQRlyg2N0iKpSVap0sf9hQ$HfgCvYpp8fez5ZsornzHxHJQjvO4YoGA+WY68/NKirw	t	f	f	ahmad fauzan adiman	SMA/SMK	\N	coding
7fa86fcc-87db-4391-8f20-7a633f1b77d0	shohib@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$8C4/ndW9my9m4Pqg9e0qPw$uSnl1gwxmecNtAQnYlrQcks8Jt5OJl0iRbRPbZvm5HA	t	f	f	shohibul karom	SMA/SMK	\N	Matematika
c6652b7b-9a93-4b77-b8e2-fcc89f656e59	d1@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$xZ8/7deQUXhzUepRN1sptA$83wYH9IzLHQlrL1ApEPEbDr8zV0BVR2EOh0cPcrSQag	t	f	f	dyym	Mahasiswa	unuja	matematika
90bdd136-034b-4ec0-a527-bc308bcc1a2f	userbaru@efzyn.my.id	$argon2id$v=19$m=65536,t=3,p=4$3Q+UhkldXnYlDIApxemDCg$Mwek2ConMntBg7QRlHAxP4G9DiWGat/oQphyO9SAeQw	t	f	f	user baru	Mahasiswa	universitas nurul jadid	matematika
f7b76a48-62c4-4ff2-bd55-1011e0dfc122	me@efzyn.my.id	$argon2id$v=19$m=65536,t=3,p=4$XkqEWqvX9w09bYm//5k0zQ$XJ0MaBwXghi8CajAEFvkc0CrCh/Z/l3Zevg8Mh+F1Oo	t	t	f	efzyn	Mahasiswa	universitas nurul jadid	pemrograman
7d1154e2-46ef-4534-8f41-fe568ee8663b	userbaru2@efzyn.my.id	$argon2id$v=19$m=65536,t=3,p=4$qcEIp8o0zQZpHtfr4D+xcw$wTAGaHZY0FxcDX7nP54JKkPk0YRB4olAgsi7AmLfy20	t	f	f	user baru dua	Mahasiswa	universitas nurul jadid	fisika
6a96be88-aec5-4aba-8b78-6aa2693cfa18	user3@efzyn.my.id	$argon2id$v=19$m=65536,t=3,p=4$ptYFsrbfeSnI3CZtZvEJmg$7fq32iZKz8pJ1eYAiuQynH3cDOJ/hhWYSyGhdAhOs4E	t	f	f	user 3	SMA/SMK	\N	smk cinta sejati
5ff9ae62-1c6f-4894-a133-adeef163e141	user4@efzyn.my.id	$argon2id$v=19$m=65536,t=3,p=4$8v0loiBI/2tVW8ZXKI7pZA$DsFd3vTffL9FRZ5DissrlCWjsvGWU8RWXw8AFPTb2zQ	t	f	f	user 4	SMA/SMK	\N	smk jembatan cinta 4
8e3d46bf-7b38-4c25-97c7-cc74e7dee8b0	user5@efzyn.my.id	$argon2id$v=19$m=65536,t=3,p=4$b3XHWLlMH/jUwiIDP88d9w$Wc4djk92HS8FKvQZ3e1OA8OaFBGoZp/0rO9G7aQq7Cg	t	f	f	user 5	Umum	\N	coding
01e1003d-da05-4156-bfa4-b152c2a10c09	abc@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$0P5eHnWIMxfEpPadFDPVjA$ihVZrXaiDRkiTqx7oqIix7OlIB6Rwo0jLa/BTDiCws0	t	f	f	Abc	Mahasiswa	Universitas Nurul Jadid	\N
b7496375-ca27-487a-a9a0-33fb6e1f14c8	user6@efzyn.my.id	$argon2id$v=19$m=65536,t=3,p=4$BuqksAEHyS/+XjF7uMMVPA$/v6nGsWVciPvgEwtMzhxgDQ/84Fgz6+jAvg79xZocbs	t	f	f	User 6	SMA/SMK	\N	Fisika
\.


--
-- Data for Name: user_answer_detail; Type: TABLE DATA; Schema: public; Owner: quiz_app_user
--

COPY public.user_answer_detail (id, quiz_attempt_id, user_id, question_text, options_presented, user_answer, correct_answer, is_correct, category_name, difficulty, "timestamp") FROM stdin;
1	be7d757e-6bb3-4902-aa8b-eb515980293f	90bdd136-034b-4ec0-a527-bc308bcc1a2f	What is the alphanumeric representation of the imaginary number?	["i", "n", "e", "x"]	x	i	f	Science: Mathematics	medium	2025-06-12 10:45:24.33873+00
2	be7d757e-6bb3-4902-aa8b-eb515980293f	90bdd136-034b-4ec0-a527-bc308bcc1a2f	What vulnerability ranked #1 on the OWASP Top 10 in 2013?	["Insecure Direct Object References", "Injection ", "Broken Authentication", "Cross-Site Scripting"]	Insecure Direct Object References	Injection 	f	Science: Computers	hard	2025-06-12 10:45:24.338736+00
3	be7d757e-6bb3-4902-aa8b-eb515980293f	90bdd136-034b-4ec0-a527-bc308bcc1a2f	What was the name given to Android 4.3?	["Froyo", "Lollipop", "Jelly Bean", "Nutella"]	Jelly Bean	Jelly Bean	t	Science: Computers	medium	2025-06-12 10:45:24.33874+00
4	c3c818d7-0447-4502-8509-db0080f3284b	90bdd136-034b-4ec0-a527-bc308bcc1a2f	What vulnerability ranked #1 on the OWASP Top 10 in 2013?	["Cross-Site Scripting", "Injection ", "Insecure Direct Object References", "Broken Authentication"]	Cross-Site Scripting	Injection 	f	Science: Computers	hard	2025-06-12 10:46:53.927651+00
5	c3c818d7-0447-4502-8509-db0080f3284b	90bdd136-034b-4ec0-a527-bc308bcc1a2f	The acronym "RIP" stands for which of these?	["Routing Information Protocol", "Regular Interval Processes", "Routine Inspection Protocol", "Runtime Instance Processes"]	Routing Information Protocol	Routing Information Protocol	t	Science: Computers	hard	2025-06-12 10:46:53.927656+00
6	c3c818d7-0447-4502-8509-db0080f3284b	90bdd136-034b-4ec0-a527-bc308bcc1a2f	What does AD stand for in relation to Windows Operating Systems? 	["Active Department", "Active Directory", "Automated Database", "Alternative Drive"]	Active Directory	Active Directory	t	Science: Computers	medium	2025-06-12 10:46:53.927657+00
7	c3c818d7-0447-4502-8509-db0080f3284b	90bdd136-034b-4ec0-a527-bc308bcc1a2f	Which data structure does FILO apply to?	["Tree", "Stack", "Queue", "Heap"]	Queue	Stack	f	Science: Computers	hard	2025-06-12 10:46:53.927658+00
8	c3c818d7-0447-4502-8509-db0080f3284b	90bdd136-034b-4ec0-a527-bc308bcc1a2f	What is the number of keys on a standard Windows Keyboard?	["94", "76", "64", "104"]	104	104	t	Science: Computers	medium	2025-06-12 10:46:53.92766+00
9	c3c818d7-0447-4502-8509-db0080f3284b	90bdd136-034b-4ec0-a527-bc308bcc1a2f	Which company was established on April 1st, 1976 by Steve Jobs, Steve Wozniak and Ronald Wayne?	["Atari", "Apple", "Microsoft", "Commodore"]	Apple	Apple	t	Science: Computers	easy	2025-06-12 10:46:53.927661+00
10	c3c818d7-0447-4502-8509-db0080f3284b	90bdd136-034b-4ec0-a527-bc308bcc1a2f	Which operating system was released first?	["Linux", "Windows", "OS/2", "Mac OS"]	OS/2	Mac OS	f	Science: Computers	medium	2025-06-12 10:46:53.927662+00
11	c3c818d7-0447-4502-8509-db0080f3284b	90bdd136-034b-4ec0-a527-bc308bcc1a2f	On a standard American QWERTY keyboard, what symbol will you enter if you hold the shift key and press 1?	["Dollar Sign", "Exclamation Mark", "Percent Sign", "Asterisk"]	Asterisk	Exclamation Mark	f	Science: Computers	easy	2025-06-12 10:46:53.927662+00
12	c3c818d7-0447-4502-8509-db0080f3284b	90bdd136-034b-4ec0-a527-bc308bcc1a2f	What was the first commerically available computer processor?	["TMS 1000", "Intel 4004", "Intel 486SX", "AMD AM386"]	Intel 4004	Intel 4004	t	Science: Computers	medium	2025-06-12 10:46:53.927663+00
13	c3c818d7-0447-4502-8509-db0080f3284b	90bdd136-034b-4ec0-a527-bc308bcc1a2f	What is the name of the default theme that is installed with Windows XP?	["Whistler", "Bliss", "Neptune", "Luna"]	Whistler	Luna	f	Science: Computers	medium	2025-06-12 10:46:53.927664+00
14	4d828ccc-0805-4750-ae25-3e41bb4bbf4a	7d1154e2-46ef-4534-8f41-fe568ee8663b	In "Sonic the Hedgehog 3" for the Sega Genesis, what is the color of the second Chaos Emerald you can get from Special Stages?	["Blue", "Magenta", "Orange", "Green"]	Orange	Orange	t	Entertainment: Video Games	hard	2025-06-14 13:24:18.460203+00
15	4d828ccc-0805-4750-ae25-3e41bb4bbf4a	7d1154e2-46ef-4534-8f41-fe568ee8663b	In the 2014 film "Birdman", what is the primary instrument in the score?	["Actual Live Birds Singing", "Drums", "Saxophone", "Violin"]	Saxophone	Drums	f	Entertainment: Film	medium	2025-06-14 13:24:18.460209+00
16	4d828ccc-0805-4750-ae25-3e41bb4bbf4a	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which of the following is another name for the "Poecilotheria Metallica Tarantula"?	["Silver Stripe", "Hopper", "Gooty", "Woebegone"]	Hopper	Gooty	f	Animals	hard	2025-06-14 13:24:18.460212+00
17	4d828ccc-0805-4750-ae25-3e41bb4bbf4a	7d1154e2-46ef-4534-8f41-fe568ee8663b	On the show "Rick and Morty", in episode "Total Rickall", who was a parasite?	["Beth Smith", "Summer Smith", "Mr. Poopy Butthole", "Pencilvester"]	Beth Smith	Pencilvester	f	Entertainment: Television	easy	2025-06-14 13:24:18.460214+00
18	4d828ccc-0805-4750-ae25-3e41bb4bbf4a	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which of these songs from American Idiot: The Musical was a previously unreleased Green Day song?	["Before The Lobotomy", "Are We The Waiting", "When It's Time", "Favorite Son"]	Favorite Son	When It's Time	f	Entertainment: Music	medium	2025-06-14 13:24:18.460215+00
19	4d828ccc-0805-4750-ae25-3e41bb4bbf4a	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which internet company began life as an online bookstore called 'Cadabra'?	["Shopify", "Amazon", "Overstock", "eBay"]	Amazon	Amazon	t	Science: Computers	medium	2025-06-14 13:24:18.460216+00
20	4d828ccc-0805-4750-ae25-3e41bb4bbf4a	7d1154e2-46ef-4534-8f41-fe568ee8663b	When did the British hand-over sovereignty of Hong Kong back to China?	["1900", "1997", "1999", "1841"]	1900	1997	f	History	medium	2025-06-14 13:24:18.460217+00
21	4d828ccc-0805-4750-ae25-3e41bb4bbf4a	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which company developed the Hololens?	["Oculus", "HTC", "Microsoft", "Tobii"]	Microsoft	Microsoft	t	Science: Gadgets	medium	2025-06-14 13:24:18.460219+00
22	4d828ccc-0805-4750-ae25-3e41bb4bbf4a	7d1154e2-46ef-4534-8f41-fe568ee8663b	What is the name for a male bee that comes from an unfertilized egg?	["Male", "Worker", "Drone", "Soldier"]	Male	Drone	f	Animals	medium	2025-06-14 13:24:18.46022+00
23	4d828ccc-0805-4750-ae25-3e41bb4bbf4a	7d1154e2-46ef-4534-8f41-fe568ee8663b	Kirito and Asuna are main characters from which anime?	["Sword Art Online", "One Piece", "Fairy Tail", "Death Note"]	Fairy Tail	Sword Art Online	f	Entertainment: Japanese Anime & Manga	easy	2025-06-14 13:24:18.460221+00
24	109b516f-ef36-4d5b-a881-5047854ed4a9	7d1154e2-46ef-4534-8f41-fe568ee8663b	How much radiation does a banana emit?	["0.1 Microsievert", "0.3 Microsievert", "0.5 Microsievert", "0.7 Microsievert"]	0.3 Microsievert	0.1 Microsievert	f	Science & Nature	hard	2025-06-14 13:25:59.721529+00
25	109b516f-ef36-4d5b-a881-5047854ed4a9	7d1154e2-46ef-4534-8f41-fe568ee8663b	What is "Stenoma"?	["A type of seasoning", "A port city in the carribean", "A genus of moths", "A combat stimulant from WW2"]	A type of seasoning	A genus of moths	f	Science & Nature	hard	2025-06-14 13:25:59.721534+00
26	109b516f-ef36-4d5b-a881-5047854ed4a9	7d1154e2-46ef-4534-8f41-fe568ee8663b	Where is the Gluteus Maximus muscle located?	["Arm", "Butt", "Head", "Torso"]	Head	Butt	f	Science & Nature	hard	2025-06-14 13:25:59.721535+00
27	109b516f-ef36-4d5b-a881-5047854ed4a9	7d1154e2-46ef-4534-8f41-fe568ee8663b	How long is a light-year?	["9.461 Trillion Kilometres", "105.40 Earth-years", "501.2 Million Miles", "1 AU"]	9.461 Trillion Kilometres	9.461 Trillion Kilometres	t	Science & Nature	hard	2025-06-14 13:25:59.721536+00
28	109b516f-ef36-4d5b-a881-5047854ed4a9	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which major extinction event was caused by an asteroid collision and eliminated the majority of non-avian dinosaurs?	["Triassic–Jurassic", "Cretaceous-Paleogene", "Permian–Triassic", "Ordovician–Silurian"]	Cretaceous-Paleogene	Cretaceous-Paleogene	t	Science & Nature	hard	2025-06-14 13:25:59.721537+00
29	109b516f-ef36-4d5b-a881-5047854ed4a9	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which of the following liquids is least viscous? Assume temperature is 25°C.	["Benzene", "Water", "Acetone", "Mercury"]	Benzene	Acetone	f	Science & Nature	hard	2025-06-14 13:25:59.721538+00
30	109b516f-ef36-4d5b-a881-5047854ed4a9	7d1154e2-46ef-4534-8f41-fe568ee8663b	What causes the sound of a heartbeat?	["Blood exiting the heart", "Contraction of the heart chambers", "Closure of the heart valves", "Relaxation of the heart chambers"]	Closure of the heart valves	Closure of the heart valves	t	Science & Nature	hard	2025-06-14 13:25:59.721539+00
31	109b516f-ef36-4d5b-a881-5047854ed4a9	7d1154e2-46ef-4534-8f41-fe568ee8663b	What is the scientific name of the red fox?	["Vulpes Vulpes", "Red Fox", "Vulpes Vulpie", "Vulpes Redus"]	Vulpes Vulpes	Vulpes Vulpes	t	Science & Nature	hard	2025-06-14 13:25:59.72154+00
32	109b516f-ef36-4d5b-a881-5047854ed4a9	7d1154e2-46ef-4534-8f41-fe568ee8663b	The 'Islets of Langerhans' is found in which human organ?	["Kidney", "Liver", "Brain", "Pancreas"]	Brain	Pancreas	f	Science & Nature	hard	2025-06-14 13:25:59.72154+00
33	109b516f-ef36-4d5b-a881-5047854ed4a9	7d1154e2-46ef-4534-8f41-fe568ee8663b	A comet's gaseous envelope (which creates the tail) is called what?	["The wake", "The coma", "The ablative", "The backwash"]	The coma	The coma	t	Science & Nature	hard	2025-06-14 13:25:59.721541+00
34	dd42aef5-db01-48eb-b547-6de8b0aa0c6a	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which RAID array type is associated with data mirroring?	["RAID 1", "RAID 5", "RAID 0", "RAID 10"]	RAID 1	RAID 1	t	Science: Computers	hard	2025-06-14 13:29:10.0055+00
35	dd42aef5-db01-48eb-b547-6de8b0aa0c6a	7d1154e2-46ef-4534-8f41-fe568ee8663b	What is the codename of the eighth generation Intel Core micro-architecture launched in October 2017?	["Skylake", "Broadwell", "Coffee Lake", "Sandy Bridge"]	Coffee Lake	Coffee Lake	t	Science: Computers	hard	2025-06-14 13:29:10.005508+00
36	dd42aef5-db01-48eb-b547-6de8b0aa0c6a	7d1154e2-46ef-4534-8f41-fe568ee8663b	Australia, Japan, and Southeast Asia are in which ITU Region?	["Region 4", "Region 2", "Region 1", "Region 3"]	Region 3	Region 3	t	Science: Computers	hard	2025-06-14 13:29:10.005509+00
37	dd42aef5-db01-48eb-b547-6de8b0aa0c6a	7d1154e2-46ef-4534-8f41-fe568ee8663b	Dutch computer scientist Mark Overmars is known for creating which game development engine?	["Stencyl", "Game Maker", "Construct", "Torque 2D"]	Game Maker	Game Maker	t	Science: Computers	hard	2025-06-14 13:29:10.00551+00
38	dd42aef5-db01-48eb-b547-6de8b0aa0c6a	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which of these names was an actual codename for a cancelled Microsoft project?	["Pollux", "Saturn", "Enceladus", "Neptune"]	Neptune	Neptune	t	Science: Computers	hard	2025-06-14 13:29:10.005512+00
39	dd42aef5-db01-48eb-b547-6de8b0aa0c6a	7d1154e2-46ef-4534-8f41-fe568ee8663b	What does the International System of Quantities refer 1024 bytes as?	["Kelobyte", "Kylobyte", "Kilobyte", "Kibibyte"]	Kibibyte	Kibibyte	t	Science: Computers	hard	2025-06-14 13:29:10.005513+00
40	dd42aef5-db01-48eb-b547-6de8b0aa0c6a	7d1154e2-46ef-4534-8f41-fe568ee8663b	How many Hz does the video standard PAL support?	["59", "50", "60", "25"]	50	50	t	Science: Computers	hard	2025-06-14 13:29:10.005514+00
41	dd42aef5-db01-48eb-b547-6de8b0aa0c6a	7d1154e2-46ef-4534-8f41-fe568ee8663b	America Online (AOL) started out as which of these online service providers?	["CompuServe", "GEnie", "Quantum Link", "Prodigy"]	Quantum Link	Quantum Link	t	Science: Computers	hard	2025-06-14 13:29:10.005515+00
42	dd42aef5-db01-48eb-b547-6de8b0aa0c6a	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which of these is not a key value of Agile software development?	["Comprehensive documentation", "Responding to change", "Customer collaboration", "Individuals and interactions"]	Customer collaboration	Comprehensive documentation	f	Science: Computers	hard	2025-06-14 13:29:10.005516+00
43	dd42aef5-db01-48eb-b547-6de8b0aa0c6a	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which of these is not a layer in the OSI model for data communications?	["Transport Layer", "Connection Layer", "Physical Layer", "Application Layer"]	Connection Layer	Connection Layer	t	Science: Computers	hard	2025-06-14 13:29:10.005517+00
44	501bd7c4-66eb-4f3f-933d-f8cbcf1be9e6	7d1154e2-46ef-4534-8f41-fe568ee8663b	The Harvard architecture for micro-controllers added which additional bus?	["Address", "Control", "Data", "Instruction"]	Control	Instruction	f	Science: Computers	hard	2025-06-14 13:30:16.363249+00
45	501bd7c4-66eb-4f3f-933d-f8cbcf1be9e6	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which of these names was an actual codename for a cancelled Microsoft project?	["Neptune", "Enceladus", "Pollux", "Saturn"]	Neptune	Neptune	t	Science: Computers	hard	2025-06-14 13:30:16.363253+00
46	501bd7c4-66eb-4f3f-933d-f8cbcf1be9e6	7d1154e2-46ef-4534-8f41-fe568ee8663b	Australia, Japan, and Southeast Asia are in which ITU Region?	["Region 1", "Region 4", "Region 3", "Region 2"]	Region 2	Region 3	f	Science: Computers	hard	2025-06-14 13:30:16.363254+00
47	501bd7c4-66eb-4f3f-933d-f8cbcf1be9e6	7d1154e2-46ef-4534-8f41-fe568ee8663b	According to DeMorgan's Theorem, the Boolean expression (AB)' is equivalent to:	["A'B + B'A", "A'B'", "AB' + AB", "A' + B'"]	A'B'	A' + B'	f	Science: Computers	hard	2025-06-14 13:30:16.363255+00
48	501bd7c4-66eb-4f3f-933d-f8cbcf1be9e6	7d1154e2-46ef-4534-8f41-fe568ee8663b	What is the name of the process that sends one qubit of information using two bits of classical information?	["Quantum Teleportation", "Quantum Entanglement", "Super Dense Coding", "Quantum Programming"]	Quantum Teleportation	Quantum Teleportation	t	Science: Computers	hard	2025-06-14 13:30:16.363256+00
49	501bd7c4-66eb-4f3f-933d-f8cbcf1be9e6	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which of the following physical typologies are used with Ethernet Networks?	["Ring", "Mesh", "Hex", "Star"]	Hex	Star	f	Science: Computers	hard	2025-06-14 13:30:16.363257+00
50	501bd7c4-66eb-4f3f-933d-f8cbcf1be9e6	7d1154e2-46ef-4534-8f41-fe568ee8663b	What is the name given to layer 4 of the Open Systems Interconnection (ISO) model?	["Network", "Data link", "Session", "Transport"]	Network	Transport	f	Science: Computers	hard	2025-06-14 13:30:16.363258+00
51	501bd7c4-66eb-4f3f-933d-f8cbcf1be9e6	7d1154e2-46ef-4534-8f41-fe568ee8663b	What internet protocol was documented in RFC 1459?	["HTTP", "IRC", "HTTPS", "FTP"]	HTTPS	IRC	f	Science: Computers	hard	2025-06-14 13:30:16.363259+00
52	501bd7c4-66eb-4f3f-933d-f8cbcf1be9e6	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which of these is not a layer in the OSI model for data communications?	["Transport Layer", "Physical Layer", "Connection Layer", "Application Layer"]	Transport Layer	Connection Layer	f	Science: Computers	hard	2025-06-14 13:30:16.363259+00
53	501bd7c4-66eb-4f3f-933d-f8cbcf1be9e6	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which of these was the name of a bug found in April 2014 in the publicly available OpenSSL cryptography library?	["Shellscript", "Corrupted Blood", "Shellshock", "Heartbleed"]	Corrupted Blood	Heartbleed	f	Science: Computers	hard	2025-06-14 13:30:16.36326+00
54	2d73f411-60ef-4bee-ae91-89926a3e9e3f	2348a6fb-3244-4187-9969-ba1452dd5397	How many kilobytes in one gigabyte (in decimal)?	["1000", "1024", "1000000", "1048576"]	1024	1000000	f	Science: Computers	easy	2025-06-14 13:32:20.230738+00
55	2d73f411-60ef-4bee-ae91-89926a3e9e3f	2348a6fb-3244-4187-9969-ba1452dd5397	In any programming language, what is the most common way to iterate through an array?	["'While' loops", "'Do-while' loops", "'For' loops", "'If' Statements"]	'If' Statements	'For' loops	f	Science: Computers	easy	2025-06-14 13:32:20.230741+00
56	2d73f411-60ef-4bee-ae91-89926a3e9e3f	2348a6fb-3244-4187-9969-ba1452dd5397	In computing, what does MIDI stand for?	["Musical Instrument Data Interface", "Musical Instrument Digital Interface", "Musical Interface of Digital Instruments", "Modular Interface of Digital Instruments"]	Musical Instrument Digital Interface	Musical Instrument Digital Interface	t	Science: Computers	easy	2025-06-14 13:32:20.230743+00
57	2d73f411-60ef-4bee-ae91-89926a3e9e3f	2348a6fb-3244-4187-9969-ba1452dd5397	What is the name of Layer 7 of the OSI model?	["Present", "Application", "Network", "Session"]	Network	Application	f	Science: Computers	easy	2025-06-14 13:32:20.230743+00
58	2d73f411-60ef-4bee-ae91-89926a3e9e3f	2348a6fb-3244-4187-9969-ba1452dd5397	Which computer hardware device provides an interface for all other connected devices to communicate?	["Hard Disk Drive", "Motherboard", "Random Access Memory", "Central Processing Unit"]	Hard Disk Drive	Motherboard	f	Science: Computers	easy	2025-06-14 13:32:20.230744+00
59	2d73f411-60ef-4bee-ae91-89926a3e9e3f	2348a6fb-3244-4187-9969-ba1452dd5397	Which computer language would you associate Django framework with?	["C#", "Python", "Java", "C++"]	Python	Python	t	Science: Computers	easy	2025-06-14 13:32:20.230745+00
60	2d73f411-60ef-4bee-ae91-89926a3e9e3f	2348a6fb-3244-4187-9969-ba1452dd5397	What amount of bits commonly equals one byte?	["8", "2", "1", "64"]	8	8	t	Science: Computers	easy	2025-06-14 13:32:20.230746+00
61	2d73f411-60ef-4bee-ae91-89926a3e9e3f	2348a6fb-3244-4187-9969-ba1452dd5397	What does the Prt Sc button do?	["Nothing", "Captures what's on the screen and copies it to your clipboard", "Saves a .png file of what's on the screen in your screenshots folder in photos", "Closes all windows"]	Saves a .png file of what's on the screen in your screenshots folder in photos	Captures what's on the screen and copies it to your clipboard	f	Science: Computers	easy	2025-06-14 13:32:20.230747+00
62	2d73f411-60ef-4bee-ae91-89926a3e9e3f	2348a6fb-3244-4187-9969-ba1452dd5397	How long is an IPv6 address?	["128 bytes", "128 bits", "64 bits", "32 bits"]	128 bytes	128 bits	f	Science: Computers	easy	2025-06-14 13:32:20.230747+00
63	2d73f411-60ef-4bee-ae91-89926a3e9e3f	2348a6fb-3244-4187-9969-ba1452dd5397	When Gmail first launched, how much storage did it provide for your email?	["5GB", "512MB", "1GB", "Unlimited"]	5GB	1GB	f	Science: Computers	easy	2025-06-14 13:32:20.230748+00
64	743f01c0-1991-4d9f-8f34-8ed332ebf31c	7d1154e2-46ef-4534-8f41-fe568ee8663b	What are rhino's horn made of?	["Keratin", "Bone", "Ivory", "Skin"]	Keratin	Keratin	t	Animals	medium	2025-06-19 03:31:18.911306+00
65	743f01c0-1991-4d9f-8f34-8ed332ebf31c	7d1154e2-46ef-4534-8f41-fe568ee8663b	What is the collective noun for a group of crows?	["Pack", "Murder", "Herd", "Gaggle"]	Herd	Murder	f	Animals	easy	2025-06-19 03:31:18.911312+00
66	743f01c0-1991-4d9f-8f34-8ed332ebf31c	7d1154e2-46ef-4534-8f41-fe568ee8663b	What is the name for a male bee that comes from an unfertilized egg?	["Male", "Soldier", "Drone", "Worker"]	Soldier	Drone	f	Animals	medium	2025-06-19 03:31:18.911316+00
67	743f01c0-1991-4d9f-8f34-8ed332ebf31c	7d1154e2-46ef-4534-8f41-fe568ee8663b	What is the fastest  land animal?	["Lion", "Cheetah", "Thomson’s Gazelle", "Pronghorn Antelope"]	Cheetah	Cheetah	t	Animals	easy	2025-06-19 03:31:18.911317+00
68	743f01c0-1991-4d9f-8f34-8ed332ebf31c	7d1154e2-46ef-4534-8f41-fe568ee8663b	What type of creature is a Bonobo?	["Parrot", "Lion", "Ape", "Wildcat"]	Wildcat	Ape	f	Animals	hard	2025-06-19 03:31:18.911318+00
69	743f01c0-1991-4d9f-8f34-8ed332ebf31c	7d1154e2-46ef-4534-8f41-fe568ee8663b	What scientific family does the Aardwolf belong to?	["Canidae", "Eupleridae", "Hyaenidae", "Felidae"]	Canidae	Hyaenidae	f	Animals	hard	2025-06-19 03:31:18.911327+00
70	743f01c0-1991-4d9f-8f34-8ed332ebf31c	7d1154e2-46ef-4534-8f41-fe568ee8663b	What do you call a baby bat?	["Chick", "Pup", "Kid", "Cub"]	Kid	Pup	f	Animals	easy	2025-06-19 03:31:18.911328+00
71	743f01c0-1991-4d9f-8f34-8ed332ebf31c	7d1154e2-46ef-4534-8f41-fe568ee8663b	Hippocampus is the Latin name for which marine creature?	["Seahorse", "Octopus", "Dolphin", "Whale"]	Octopus	Seahorse	f	Animals	easy	2025-06-19 03:31:18.91133+00
72	743f01c0-1991-4d9f-8f34-8ed332ebf31c	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which of these species is not extinct?	["Tasmanian tiger", "Japanese sea lion", "Komodo dragon", "Saudi gazelle"]	Tasmanian tiger	Komodo dragon	f	Animals	medium	2025-06-19 03:31:18.911331+00
73	743f01c0-1991-4d9f-8f34-8ed332ebf31c	7d1154e2-46ef-4534-8f41-fe568ee8663b	What is the common term for bovine spongiform encephalopathy (BSE)?	["Foot-and-mouth disease", "Milk fever", "Mad Cow disease", "Weil's disease"]	Weil's disease	Mad Cow disease	f	Animals	medium	2025-06-19 03:31:18.911332+00
74	768a2c3f-1686-4fe1-b3cc-98725c654af9	7d1154e2-46ef-4534-8f41-fe568ee8663b	What nationality was the surrealist painter Salvador Dali?	["French", "Portuguese", "Spanish", "Italian"]	French	Spanish	f	Art	medium	2025-06-19 03:40:31.045603+00
75	768a2c3f-1686-4fe1-b3cc-98725c654af9	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which Van Gogh painting depicts the view from his asylum in Saint-Rémy-de-Provence in southern France?	["The Sower with Setting Sun", "The Starry Night", "Wheatfields with Crows", "The Church at Auvers"]	The Church at Auvers	The Starry Night	f	Art	easy	2025-06-19 03:40:31.04561+00
76	768a2c3f-1686-4fe1-b3cc-98725c654af9	7d1154e2-46ef-4534-8f41-fe568ee8663b	What was the first successful and commercially viable photographic technique?	["Kodachrome film", "Collodion process", "The Turin Shroud", "The Daguerreotype"]	The Turin Shroud	The Daguerreotype	f	Art	hard	2025-06-19 03:40:31.045611+00
77	768a2c3f-1686-4fe1-b3cc-98725c654af9	7d1154e2-46ef-4534-8f41-fe568ee8663b	Who painted the biblical fresco The Creation of Adam?	["Michelangelo", "Rembrandt", "Caravaggio", "Leonardo da Vinci"]	Rembrandt	Michelangelo	f	Art	easy	2025-06-19 03:40:31.045612+00
78	768a2c3f-1686-4fe1-b3cc-98725c654af9	7d1154e2-46ef-4534-8f41-fe568ee8663b	Who painted the Mona Lisa?	["Leonardo da Vinci ", "Pablo Picasso", " Vincent van Gogh", "Michelangelo"]	Leonardo da Vinci 	Leonardo da Vinci 	t	Art	easy	2025-06-19 03:40:31.045613+00
79	768a2c3f-1686-4fe1-b3cc-98725c654af9	7d1154e2-46ef-4534-8f41-fe568ee8663b	Who painted "The Starry Night"?	["Pablo Picasso", "Claude Monet", "Vincent van Gogh", "Edvard Munch"]	Vincent van Gogh	Vincent van Gogh	t	Art	easy	2025-06-19 03:40:31.045614+00
80	768a2c3f-1686-4fe1-b3cc-98725c654af9	7d1154e2-46ef-4534-8f41-fe568ee8663b	Who painted the Mona Lisa?	["Pablo Picasso", "Leonardo da Vinci", "Vincent van Gogh", "Claude Monet"]	Leonardo da Vinci	Leonardo da Vinci	t	Art	easy	2025-06-19 03:40:31.045614+00
81	768a2c3f-1686-4fe1-b3cc-98725c654af9	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which artist painted the late 15th century mural 'The Last Supper'?	["Piero della Francesca", "Leonardo da Vinci", "Luca Pacioli", "Paolo Uccello"]	Piero della Francesca	Leonardo da Vinci	f	Art	easy	2025-06-19 03:40:31.045615+00
82	768a2c3f-1686-4fe1-b3cc-98725c654af9	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which one of these paintings is not by Caspar David Friedrich?	["The Black Sea", "Wanderer above the Sea of Fog", "The Sea of Ice", "The Monk by the Sea"]	The Sea of Ice	The Black Sea	f	Art	medium	2025-06-19 03:40:31.045616+00
83	768a2c3f-1686-4fe1-b3cc-98725c654af9	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which artist's style was to use small different colored dots to create a picture?	["Georges Seurat", "Henri Rousseau", "Paul Cézanne", "Vincent Van Gogh"]	Georges Seurat	Georges Seurat	t	Art	medium	2025-06-19 03:40:31.045617+00
84	dcaa9d26-dc50-475b-b867-363fd35e2f30	7d1154e2-46ef-4534-8f41-fe568ee8663b	The eccentric natural philosopher Tycho Brahe kept what as a pet?	["Moose", "Bear", "Goat", "Dog"]	Bear	Moose	f	Celebrities	hard	2025-06-19 03:41:27.130486+00
85	dcaa9d26-dc50-475b-b867-363fd35e2f30	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which actress married Michael Douglas in 2000?	["Ruth Jones", "Pam Ferris", "Catherine Zeta-Jones", "Sara Sugarman"]	Catherine Zeta-Jones	Catherine Zeta-Jones	t	Celebrities	easy	2025-06-19 03:41:27.13049+00
86	dcaa9d26-dc50-475b-b867-363fd35e2f30	7d1154e2-46ef-4534-8f41-fe568ee8663b	In what year did "Bob Ross" die?	["1989", "1997", "1986", "1995"]	1997	1995	f	Celebrities	medium	2025-06-19 03:41:27.130491+00
87	dcaa9d26-dc50-475b-b867-363fd35e2f30	7d1154e2-46ef-4534-8f41-fe568ee8663b	What was the name of Marilyn Monroe's first husband?	["Kirk Douglas", "Arthur Miller", "James Dougherty", "Joe Dimaggio"]	Kirk Douglas	James Dougherty	f	Celebrities	medium	2025-06-19 03:41:27.130492+00
88	dcaa9d26-dc50-475b-b867-363fd35e2f30	7d1154e2-46ef-4534-8f41-fe568ee8663b	If he was still alive, in what year would Elvis Presley celebrate his 100th birthday?	["2045", "2030", "2035", "2040"]	2030	2035	f	Celebrities	medium	2025-06-19 03:41:27.130493+00
89	dcaa9d26-dc50-475b-b867-363fd35e2f30	7d1154e2-46ef-4534-8f41-fe568ee8663b	When was Elvis Presley born?	["December 13, 1931", "April 17, 1938", "January 8, 1935", "July 18, 1940"]	January 8, 1935	January 8, 1935	t	Celebrities	medium	2025-06-19 03:41:27.130494+00
90	dcaa9d26-dc50-475b-b867-363fd35e2f30	7d1154e2-46ef-4534-8f41-fe568ee8663b	In 2014, this new top 100 rapper who featured in "Computers" and "Body Dance" was arrested in a NYPD sting for murder.	["Bobby Shmurda", "Swae Lee", "Young Thug", "DJ Snake"]	Swae Lee	Bobby Shmurda	f	Celebrities	medium	2025-06-19 03:41:27.130494+00
91	dcaa9d26-dc50-475b-b867-363fd35e2f30	7d1154e2-46ef-4534-8f41-fe568ee8663b	In which situation was musician John Lennon assassinated?	["Signing an autograph outside the Record Plant studio", "During an impromptu walk through Central Park", "Attempting to enter the Dakota Apartments building", "Waiting outside a music venue in Manhattan following a gig"]	Waiting outside a music venue in Manhattan following a gig	Attempting to enter the Dakota Apartments building	f	Celebrities	medium	2025-06-19 03:41:27.130495+00
92	dcaa9d26-dc50-475b-b867-363fd35e2f30	7d1154e2-46ef-4534-8f41-fe568ee8663b	By what name is Carlos Estevez better known? 	["Joaquin Phoenix", "Bruno Mars", "Charlie Sheen", "Ricky Martin"]	Joaquin Phoenix	Charlie Sheen	f	Celebrities	easy	2025-06-19 03:41:27.130496+00
93	dcaa9d26-dc50-475b-b867-363fd35e2f30	7d1154e2-46ef-4534-8f41-fe568ee8663b	What was the cause of Marilyn Monroes suicide?	["Knife Attack", "Gunshot", "Drug Overdose", "House Fire"]	Gunshot	Drug Overdose	f	Celebrities	easy	2025-06-19 03:41:27.130497+00
94	e744116f-3da0-4250-b0ba-41999b6da129	7d1154e2-46ef-4534-8f41-fe568ee8663b	In Dungeons and Dragons (5th edition), what stat do you normally add onto your initiative die roll?	["Strength", "Speed", "Dexterity", "Wisdom"]	Strength	Dexterity	f	Entertainment: Board Games	easy	2025-06-19 03:42:16.101904+00
95	e744116f-3da0-4250-b0ba-41999b6da129	7d1154e2-46ef-4534-8f41-fe568ee8663b	In what year was the card game Magic: the Gathering first introduced?	["1998", "2003", "1987", "1993"]	1987	1993	f	Entertainment: Board Games	medium	2025-06-19 03:42:16.101908+00
96	e744116f-3da0-4250-b0ba-41999b6da129	7d1154e2-46ef-4534-8f41-fe568ee8663b	In a standard game of Monopoly, what colour are the two cheapest properties?	["Yellow", "Brown", "Blue", "Green"]	Brown	Brown	t	Entertainment: Board Games	easy	2025-06-19 03:42:16.101909+00
97	e744116f-3da0-4250-b0ba-41999b6da129	7d1154e2-46ef-4534-8f41-fe568ee8663b	What Magic: The Gathering card's flavor text is just 'Ribbit.'?	["Bloated Toad", "Frogmite", "Turn to Frog", "Spore Frog"]	Bloated Toad	Turn to Frog	f	Entertainment: Board Games	hard	2025-06-19 03:42:16.10191+00
98	e744116f-3da0-4250-b0ba-41999b6da129	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which of these games includes the phrase "Do not pass Go, do not collect $200"?	["Cluedo", "Monopoly", "Coppit", "Pay Day"]	Pay Day	Monopoly	f	Entertainment: Board Games	easy	2025-06-19 03:42:16.101911+00
99	e744116f-3da0-4250-b0ba-41999b6da129	7d1154e2-46ef-4534-8f41-fe568ee8663b	The board game Monopoly takes its street names from which real American city?	["Las Vegas, Nevada", "Charleston, South Carolina", "Duluth, Minnesota", "Atlantic City, New Jersey"]	Charleston, South Carolina	Atlantic City, New Jersey	f	Entertainment: Board Games	easy	2025-06-19 03:42:16.101912+00
100	e744116f-3da0-4250-b0ba-41999b6da129	7d1154e2-46ef-4534-8f41-fe568ee8663b	The board game, Nightmare was released in what year?	["1989", "1992", "1991", "1995"]	1989	1991	f	Entertainment: Board Games	medium	2025-06-19 03:42:16.101913+00
101	e744116f-3da0-4250-b0ba-41999b6da129	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which of the following characters is not in the board game Clue?	["Reverend Green", "Miss Scarlet", "Colonel Mustard", "Mister Indigo"]	Colonel Mustard	Mister Indigo	f	Entertainment: Board Games	medium	2025-06-19 03:42:16.101913+00
102	e744116f-3da0-4250-b0ba-41999b6da129	7d1154e2-46ef-4534-8f41-fe568ee8663b	On a standard Monopoly board, how much do you have to pay for Tennessee Ave?	["$200", "$220", "$160", "$180"]	$200	$180	f	Entertainment: Board Games	hard	2025-06-19 03:42:16.101914+00
103	e744116f-3da0-4250-b0ba-41999b6da129	7d1154e2-46ef-4534-8f41-fe568ee8663b	What is the maximum level you can have in a single class in Dungeons and Dragons (5e)?	["25", "15", "30", "20"]	30	20	f	Entertainment: Board Games	easy	2025-06-19 03:42:16.101915+00
104	53db1df2-b39c-45aa-addd-8d03b5c9d4f0	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which novel by John Grisham was conceived on a road trip to Florida while thinking about stolen books with his wife?	["Camino Island", "Rogue Lawyer", "The Litigators", "Gray Mountain"]	Rogue Lawyer	Camino Island	f	Entertainment: Books	medium	2025-06-19 03:42:53.740393+00
105	53db1df2-b39c-45aa-addd-8d03b5c9d4f0	7d1154e2-46ef-4534-8f41-fe568ee8663b	What is the title of the first Sherlock Holmes book by Arthur Conan Doyle?	["The Sign of the Four", "A Case of Identity", "A Study in Scarlet", "The Doings of Raffles Haw"]	A Study in Scarlet	A Study in Scarlet	t	Entertainment: Books	easy	2025-06-19 03:42:53.740398+00
106	53db1df2-b39c-45aa-addd-8d03b5c9d4f0	7d1154e2-46ef-4534-8f41-fe568ee8663b	In which classic novel by Mark Twain did a beggar and Prince of Wales switch clothes, and learn about social class inequality?	["The Prince and the Pauper", "A Modern Twain Story", "Hamlet", "Wealthy Boy and the Schmuck"]	A Modern Twain Story	The Prince and the Pauper	f	Entertainment: Books	hard	2025-06-19 03:42:53.740399+00
107	53db1df2-b39c-45aa-addd-8d03b5c9d4f0	7d1154e2-46ef-4534-8f41-fe568ee8663b	In the Lord of the Rings, who is the father of the dwarf Gimli?	["Dwalin", "Gloin", "Bombur", "Thorin Oakenshield"]	Thorin Oakenshield	Gloin	f	Entertainment: Books	medium	2025-06-19 03:42:53.7404+00
108	53db1df2-b39c-45aa-addd-8d03b5c9d4f0	7d1154e2-46ef-4534-8f41-fe568ee8663b	The novel "Of Mice And Men" was written by what author? 	["John Steinbeck ", "Harper Lee", "George Orwell", "Mark Twain "]	John Steinbeck 	John Steinbeck 	t	Entertainment: Books	medium	2025-06-19 03:42:53.740401+00
109	53db1df2-b39c-45aa-addd-8d03b5c9d4f0	7d1154e2-46ef-4534-8f41-fe568ee8663b	By what nickname is Jack Dawkins known in the Charles Dickens novel, 'Oliver Twist'?	["Bull’s-eye", "Mr. Fang", "Fagin", "The Artful Dodger"]	Fagin	The Artful Dodger	f	Entertainment: Books	medium	2025-06-19 03:42:53.740402+00
110	53db1df2-b39c-45aa-addd-8d03b5c9d4f0	7d1154e2-46ef-4534-8f41-fe568ee8663b	The title of Adolf Hitler's autobiography "Mein Kampf" is what when translated to English?	["My Desire", "My Sadness", "My Hatred", "My Struggle"]	My Desire	My Struggle	f	Entertainment: Books	medium	2025-06-19 03:42:53.740403+00
111	53db1df2-b39c-45aa-addd-8d03b5c9d4f0	7d1154e2-46ef-4534-8f41-fe568ee8663b	What is Ron Weasley's middle name?	["Bilius", "Arthur", "Dominic", "John"]	Arthur	Bilius	f	Entertainment: Books	hard	2025-06-19 03:42:53.740403+00
112	53db1df2-b39c-45aa-addd-8d03b5c9d4f0	7d1154e2-46ef-4534-8f41-fe568ee8663b	In Terry Pratchett's Discworld novel 'Wyrd Sisters', which of these are not one of the three main witches?	["Winny Hathersham", "Nanny Ogg", "Granny Weatherwax", "Magrat Garlick"]	Granny Weatherwax	Winny Hathersham	f	Entertainment: Books	medium	2025-06-19 03:42:53.740404+00
113	53db1df2-b39c-45aa-addd-8d03b5c9d4f0	7d1154e2-46ef-4534-8f41-fe568ee8663b	In Alice in Wonderland, what is the name of Alice's kitten?	["Smokey", "Oscar", "Heath", "Dinah"]	Oscar	Dinah	f	Entertainment: Books	medium	2025-06-19 03:42:53.740405+00
114	6e83e170-a7dd-4aca-9351-6afa42d87aea	7d1154e2-46ef-4534-8f41-fe568ee8663b	In The Simpsons, which war did Seymour Skinner serve in the USA Army as a Green Beret?	["Vietnam War", "World War 2", "World War 1", "Cold War"]	Vietnam War	Vietnam War	t	Entertainment: Cartoon & Animations	easy	2025-06-19 03:43:25.925927+00
115	6e83e170-a7dd-4aca-9351-6afa42d87aea	7d1154e2-46ef-4534-8f41-fe568ee8663b	Who created the Cartoon Network series "Regular Show"?	["J. G. Quintel", "Rebecca Sugar", "Pendleton Ward", "Ben Bocquelet"]	Pendleton Ward	J. G. Quintel	f	Entertainment: Cartoon & Animations	easy	2025-06-19 03:43:25.925933+00
116	6e83e170-a7dd-4aca-9351-6afa42d87aea	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which Teenage Mutant Ninja Turtle traditionally wears an orange bandana?	["Leonardo", "Michelangelo", "Donatello", "Raphael"]	Michelangelo	Michelangelo	t	Entertainment: Cartoon & Animations	easy	2025-06-19 03:43:25.925934+00
117	6e83e170-a7dd-4aca-9351-6afa42d87aea	7d1154e2-46ef-4534-8f41-fe568ee8663b	In My Little Pony, what is the name of Applejack's younger sister?	["Red Delicious", "Apple Sweets", "Apple Bloom", "Apple Fritter"]	Red Delicious	Apple Bloom	f	Entertainment: Cartoon & Animations	easy	2025-06-19 03:43:25.925935+00
118	6e83e170-a7dd-4aca-9351-6afa42d87aea	7d1154e2-46ef-4534-8f41-fe568ee8663b	What is the name of Sid's dog in "Toy Story"?	["Mr. Jones", "Whiskers", "Scud", "Buster"]	Scud	Scud	t	Entertainment: Cartoon & Animations	medium	2025-06-19 03:43:25.925936+00
119	6e83e170-a7dd-4aca-9351-6afa42d87aea	7d1154e2-46ef-4534-8f41-fe568ee8663b	In the web-comic Homestuck, what is the name of the game the 4 kids play?	["Sburb", "Husslie", "Hiveswap", "Homesick"]	Husslie	Sburb	f	Entertainment: Cartoon & Animations	hard	2025-06-19 03:43:25.925937+00
120	6e83e170-a7dd-4aca-9351-6afa42d87aea	7d1154e2-46ef-4534-8f41-fe568ee8663b	Who is the only voice actor to have a speaking part in all of the Disney Pixar feature films? 	["Tom Hanks", "Geoffrey Rush", "Dave Foley", "John Ratzenberger"]	John Ratzenberger	John Ratzenberger	t	Entertainment: Cartoon & Animations	easy	2025-06-19 03:43:25.925938+00
121	6e83e170-a7dd-4aca-9351-6afa42d87aea	7d1154e2-46ef-4534-8f41-fe568ee8663b	In the show "Steven Universe", who are the main two employees of The Big Donut?	["Sadie and Lars", "Steven and James", "Bob and May", "Erik and Julie"]	Sadie and Lars	Sadie and Lars	t	Entertainment: Cartoon & Animations	easy	2025-06-19 03:43:25.925939+00
122	6e83e170-a7dd-4aca-9351-6afa42d87aea	7d1154e2-46ef-4534-8f41-fe568ee8663b	What is the name of Ruby Rose's weapon from RWBY?	["Crescent Rose", "Crooked Scythe", "Thorned Rosebud", "Magnhild"]	Thorned Rosebud	Crescent Rose	f	Entertainment: Cartoon & Animations	medium	2025-06-19 03:43:25.925939+00
123	6e83e170-a7dd-4aca-9351-6afa42d87aea	7d1154e2-46ef-4534-8f41-fe568ee8663b	The song 'Little April Shower' features in which Disney cartoon film?	["Bambi", "The Jungle Book", "Cinderella", "Pinocchio"]	The Jungle Book	Bambi	f	Entertainment: Cartoon & Animations	easy	2025-06-19 03:43:25.92594+00
124	2ada816b-5e34-4b93-9faa-28dccd82a689	7d1154e2-46ef-4534-8f41-fe568ee8663b	When was the Garfield comic first published?	["1982", "1978", "1973", "1988"]	1978	1978	t	Entertainment: Comics	hard	2025-06-19 03:44:05.093931+00
125	2ada816b-5e34-4b93-9faa-28dccd82a689	7d1154e2-46ef-4534-8f41-fe568ee8663b	Who was the inspiration for Cuthbert Calculus in the Tintin series?	["Jacques Piccard", "Will Morris", "Auguste Picard", "J. Cecil Maby"]	Jacques Piccard	Auguste Picard	f	Entertainment: Comics	medium	2025-06-19 03:44:05.093935+00
126	2ada816b-5e34-4b93-9faa-28dccd82a689	7d1154e2-46ef-4534-8f41-fe568ee8663b	Better known by his nickname Logan, what is Wolverine's birth name?	["Logan Wolf", "John Savage", "Thomas Wilde", "James Howlett"]	Thomas Wilde	James Howlett	f	Entertainment: Comics	hard	2025-06-19 03:44:05.093936+00
127	2ada816b-5e34-4b93-9faa-28dccd82a689	7d1154e2-46ef-4534-8f41-fe568ee8663b	Who is the creator of the comic series "The Walking Dead"?	["Robert Kirkman", "Robert Crumb", "Malcolm Wheeler-Nicholson", "Stan Lee"]	Robert Crumb	Robert Kirkman	f	Entertainment: Comics	easy	2025-06-19 03:44:05.093937+00
128	2ada816b-5e34-4b93-9faa-28dccd82a689	7d1154e2-46ef-4534-8f41-fe568ee8663b	In "Sonic the Hedgehog" comic, who was the creator of Roboticizer? 	["Julian Robotnik", "Ivo Robotnik", "Snively Robotnik", "Professor Charles the Hedgehog"]	Julian Robotnik	Professor Charles the Hedgehog	f	Entertainment: Comics	medium	2025-06-19 03:44:05.093938+00
129	2ada816b-5e34-4b93-9faa-28dccd82a689	7d1154e2-46ef-4534-8f41-fe568ee8663b	When Batman trolls the online chat rooms, what alias does he use?	["iAmBatman", "BWayne13", "JonDoe297", "BW1129"]	JonDoe297	JonDoe297	t	Entertainment: Comics	hard	2025-06-19 03:44:05.093939+00
130	2ada816b-5e34-4b93-9faa-28dccd82a689	7d1154e2-46ef-4534-8f41-fe568ee8663b	What's the race of Invincible's father?	["Viltrumite", "Kryptonian", "Kree", "Irken"]	Viltrumite	Viltrumite	t	Entertainment: Comics	easy	2025-06-19 03:44:05.093939+00
131	2ada816b-5e34-4b93-9faa-28dccd82a689	7d1154e2-46ef-4534-8f41-fe568ee8663b	What otherworldly land does Thor come from?	["Jotunheim", "Midgard", "Asgard", "Sovengarde"]	Sovengarde	Asgard	f	Entertainment: Comics	medium	2025-06-19 03:44:05.09394+00
132	2ada816b-5e34-4b93-9faa-28dccd82a689	7d1154e2-46ef-4534-8f41-fe568ee8663b	In the Hellboy universe, who founded the BPRD?	["Johann Kraus", "Kate Corrigan", "Benjamin Daimio", "Trevor Bruttenholm"]	Kate Corrigan	Trevor Bruttenholm	f	Entertainment: Comics	medium	2025-06-19 03:44:05.093941+00
133	2ada816b-5e34-4b93-9faa-28dccd82a689	7d1154e2-46ef-4534-8f41-fe568ee8663b	In the Marvel Universe, the planet of Svartalfheim is home to what race?	["Dark Elves", "Frost Giants", "Kronans", "Skrulls"]	Kronans	Dark Elves	f	Entertainment: Comics	hard	2025-06-19 03:44:05.093942+00
134	e93f0cd8-b203-4599-b702-e858e4888b2a	7d1154e2-46ef-4534-8f41-fe568ee8663b	In the movie "Cast Away" the main protagonist's best friend while on the island is named	["Willy", "Jackson", "Wilson", "Carson"]	Wilson	Wilson	t	Entertainment: Film	easy	2025-06-19 03:47:13.938641+00
135	e93f0cd8-b203-4599-b702-e858e4888b2a	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which actor plays the character "Tommy Jarvis" in "Friday the 13th: The Final Chapter" (1984)?	["Mel Gibson", "Mark Hamill", "Corey Feldman", "Macaulay Culkin"]	Mel Gibson	Corey Feldman	f	Entertainment: Film	medium	2025-06-19 03:47:13.938645+00
136	e93f0cd8-b203-4599-b702-e858e4888b2a	7d1154e2-46ef-4534-8f41-fe568ee8663b	This movie contains the quote, "Houston, we have a problem."	["Apollo 13", "Capricorn One", "The Right Stuff", "Marooned"]	The Right Stuff	Apollo 13	f	Entertainment: Film	easy	2025-06-19 03:47:13.938646+00
137	e93f0cd8-b203-4599-b702-e858e4888b2a	7d1154e2-46ef-4534-8f41-fe568ee8663b	In Big Hero 6, what fictional city is the Big Hero 6 from?	["Tokysisco", "San Tokyo", "Sankyo", "San Fransokyo"]	Tokysisco	San Fransokyo	f	Entertainment: Film	easy	2025-06-19 03:47:13.938647+00
138	e93f0cd8-b203-4599-b702-e858e4888b2a	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which director directed the movie "Pan's Labyrinth"?	[" Alejandro Jodorowsky", "Alfonso Cuarón", "Alejandro González Iñárritu", "Guillermo Del Toro"]	Alejandro González Iñárritu	Guillermo Del Toro	f	Entertainment: Film	medium	2025-06-19 03:47:13.938648+00
139	e93f0cd8-b203-4599-b702-e858e4888b2a	7d1154e2-46ef-4534-8f41-fe568ee8663b	What year did the James Cameron film "Titanic" come out in theaters?	["1996", "1997", "1999", "1998"]	1996	1997	f	Entertainment: Film	medium	2025-06-19 03:47:13.938649+00
140	e93f0cd8-b203-4599-b702-e858e4888b2a	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which actress danced the twist with John Travolta in 'Pulp Fiction'?	["Bridget Fonda", "Pam Grier", "Uma Thurman", "Kathy Griffin"]	Kathy Griffin	Uma Thurman	f	Entertainment: Film	easy	2025-06-19 03:47:13.938649+00
141	e93f0cd8-b203-4599-b702-e858e4888b2a	7d1154e2-46ef-4534-8f41-fe568ee8663b	In the movie "V for Vendetta," what is the date that masked vigilante "V" urges people to remember?	["November 5th", "September 5th", "November 6th", "November 4th"]	September 5th	November 5th	f	Entertainment: Film	easy	2025-06-19 03:47:13.93865+00
142	e93f0cd8-b203-4599-b702-e858e4888b2a	7d1154e2-46ef-4534-8f41-fe568ee8663b	Mark Wahlberg played the titular character of which 2008 video-game adaptation?	["God Of War", "Alan Wake", "Max Payne", "Hitman"]	Max Payne	Max Payne	t	Entertainment: Film	medium	2025-06-19 03:47:13.938651+00
143	e93f0cd8-b203-4599-b702-e858e4888b2a	7d1154e2-46ef-4534-8f41-fe568ee8663b	In the 1976 film 'Taxi Driver', how many guns did Travis buy from the salesman?	["6", "2", "1", "4"]	6	4	f	Entertainment: Film	hard	2025-06-19 03:47:13.938652+00
144	c878784f-1c01-4531-9832-5ebe9f7a15dd	7d1154e2-46ef-4534-8f41-fe568ee8663b	The World Chess Championship in Chess, Act 1 is set in which Italian city?	["Rome", "Milan", "Merano", "Venice"]	Rome	Merano	f	Entertainment: Musicals & Theatres	medium	2025-06-19 03:49:16.440908+00
145	c878784f-1c01-4531-9832-5ebe9f7a15dd	7d1154e2-46ef-4534-8f41-fe568ee8663b	When was the play "Macbeth" written?	["1723", "1606", "1605", "1628"]	1628	1606	f	Entertainment: Musicals & Theatres	medium	2025-06-19 03:49:16.440912+00
146	c878784f-1c01-4531-9832-5ebe9f7a15dd	7d1154e2-46ef-4534-8f41-fe568ee8663b	How many plays is Shakespeare generally considered to have written?	["54", "18", "37", "25"]	18	37	f	Entertainment: Musicals & Theatres	easy	2025-06-19 03:49:16.440913+00
147	c878784f-1c01-4531-9832-5ebe9f7a15dd	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which musical has won the most Tony awards?	["The Producers", "Hamilton", "Phantom of the Opera", "Chicago"]	Phantom of the Opera	The Producers	f	Entertainment: Musicals & Theatres	medium	2025-06-19 03:49:16.440914+00
148	c878784f-1c01-4531-9832-5ebe9f7a15dd	7d1154e2-46ef-4534-8f41-fe568ee8663b	In Jeff Wayne's Musical Version of War of the Worlds, the chances of anything coming from Mars are...	["A hundred to one", "A million to one", "A trillion to one", "A billion to one"]	A million to one	A million to one	t	Entertainment: Musicals & Theatres	medium	2025-06-19 03:49:16.440914+00
149	c878784f-1c01-4531-9832-5ebe9f7a15dd	7d1154e2-46ef-4534-8f41-fe568ee8663b	In Macbeth, the eyes of what animals were used in the Witches' cauldron?	["Newts", "Humans", "Squids", "Sharks"]	Sharks	Newts	f	Entertainment: Musicals & Theatres	hard	2025-06-19 03:49:16.440915+00
150	c878784f-1c01-4531-9832-5ebe9f7a15dd	7d1154e2-46ef-4534-8f41-fe568ee8663b	In Les Misérables, who is Prison Code 24601?	["Marius Pontmercy", "Jean Claude Van Damme", "Javert", "Jean Valjean"]	Jean Claude Van Damme	Jean Valjean	f	Entertainment: Musicals & Theatres	hard	2025-06-19 03:49:16.440916+00
151	c878784f-1c01-4531-9832-5ebe9f7a15dd	7d1154e2-46ef-4534-8f41-fe568ee8663b	What play is the quote "Hell is other people" from?	["The Flies", "The Devil and the Good Lord", "The Condemned of Altona", "No Exit"]	The Flies	No Exit	f	Entertainment: Musicals & Theatres	medium	2025-06-19 03:49:16.440917+00
152	c878784f-1c01-4531-9832-5ebe9f7a15dd	7d1154e2-46ef-4534-8f41-fe568ee8663b	Who wrote the play 'Angels in America'?	["Tony Kusher", "Matthew Lopez", "Anthony Neilson", "Tom Stoppard"]	Anthony Neilson	Tony Kusher	f	Entertainment: Musicals & Theatres	easy	2025-06-19 03:49:16.440918+00
153	c878784f-1c01-4531-9832-5ebe9f7a15dd	7d1154e2-46ef-4534-8f41-fe568ee8663b	Who is the musical director for the award winning musical "Hamilton"?	["Renee Elise-Goldberry", "Leslie Odom Jr.", "Lin-Manuel Miranda", "Alex Lacamoire"]	Leslie Odom Jr.	Alex Lacamoire	f	Entertainment: Musicals & Theatres	medium	2025-06-19 03:49:16.440918+00
154	d583d3b7-110c-4d76-94f3-a81a830235e8	7d1154e2-46ef-4534-8f41-fe568ee8663b	The fictional movie 'Rochelle, Rochelle' features in which sitcom?	["Seinfeld", "Cheers", "Frasier", "Friends"]	Seinfeld	Seinfeld	t	Entertainment: Television	medium	2025-06-19 03:50:10.626945+00
155	d583d3b7-110c-4d76-94f3-a81a830235e8	7d1154e2-46ef-4534-8f41-fe568ee8663b	What is the setting of the show "Parks and Recreation"?	["Pasadena, California", "Eagleton, Indiana", "London, England", "Pawnee, Indiana"]	London, England	Pawnee, Indiana	f	Entertainment: Television	medium	2025-06-19 03:50:10.626948+00
156	d583d3b7-110c-4d76-94f3-a81a830235e8	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which former Coronation Street actress was once a hostess on the British Game Show "Double Your Money"?	["Amanda Barrie", "Sue Nicholls", "Violet Carson", "Jean Alexander"]	Sue Nicholls	Amanda Barrie	f	Entertainment: Television	hard	2025-06-19 03:50:10.62695+00
157	d583d3b7-110c-4d76-94f3-a81a830235e8	7d1154e2-46ef-4534-8f41-fe568ee8663b	In Two and a Half Men, what is Alan Harper's son's name?	["Jake", "James", "John", "Jeremy"]	Jeremy	Jake	f	Entertainment: Television	easy	2025-06-19 03:50:10.626951+00
158	d583d3b7-110c-4d76-94f3-a81a830235e8	7d1154e2-46ef-4534-8f41-fe568ee8663b	In "Star Trek: Voyager", which episode did Voyager establish real-time communication with Starfleet Headquarters?	["Counterpoint", "Someone To Watch Over Me", "Message In A Bottle", "Pathfinder"]	Someone To Watch Over Me	Pathfinder	f	Entertainment: Television	easy	2025-06-19 03:50:10.626951+00
159	d583d3b7-110c-4d76-94f3-a81a830235e8	7d1154e2-46ef-4534-8f41-fe568ee8663b	In Naruto: Shippuden, which of the following elements is a "Kekkei Tōta?"	["Shadow Style", "Any Doujutsu", "Ice Style", "Particle Style"]	Shadow Style	Particle Style	f	Entertainment: Television	medium	2025-06-19 03:50:10.626952+00
160	d583d3b7-110c-4d76-94f3-a81a830235e8	7d1154e2-46ef-4534-8f41-fe568ee8663b	What TV show is about a grandfather dragging his grandson around on adventures?	["Rick & Morty", "American Dad", "Family Guy", "South Park"]	Family Guy	Rick & Morty	f	Entertainment: Television	easy	2025-06-19 03:50:10.626953+00
161	d583d3b7-110c-4d76-94f3-a81a830235e8	7d1154e2-46ef-4534-8f41-fe568ee8663b	In the show "Futurama" what is Fry's full name?	["Philip J. Fry", "Fry Rodríguez", "Fry J. Philip", "Fry Philip"]	Fry Rodríguez	Philip J. Fry	f	Entertainment: Television	easy	2025-06-19 03:50:10.626954+00
162	d583d3b7-110c-4d76-94f3-a81a830235e8	7d1154e2-46ef-4534-8f41-fe568ee8663b	This composer worked on the 2003 TV series Battlestar Galatica.	["Bear McCreary", "Jeremy Soule", "Ramin Djawadi", "Harry Gregson-Williams"]	Ramin Djawadi	Bear McCreary	f	Entertainment: Television	medium	2025-06-19 03:50:10.626954+00
163	d583d3b7-110c-4d76-94f3-a81a830235e8	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which race enjoys a glass of warm baghol in "Star Trek"?	["Vulcan", "Human", "Klingon", "Botha"]	Klingon	Klingon	t	Entertainment: Television	hard	2025-06-19 03:50:10.626955+00
164	623b8231-e6df-426f-8725-48764aa9e8ae	7d1154e2-46ef-4534-8f41-fe568ee8663b	Who's the voice actor for Thrall in the Warcraft game series?	["Chris Metzen", "Jason Derulo", "Ben Affleck", "Jim Carrey"]	Chris Metzen	Chris Metzen	t	Entertainment: Video Games	easy	2025-06-19 03:51:23.492245+00
165	623b8231-e6df-426f-8725-48764aa9e8ae	7d1154e2-46ef-4534-8f41-fe568ee8663b	What company develops the Rock Band series of rhythm games?	["Activision", "Electronic Arts", "Konami", "Harmonix"]	Konami	Harmonix	f	Entertainment: Video Games	easy	2025-06-19 03:51:23.492249+00
166	623b8231-e6df-426f-8725-48764aa9e8ae	7d1154e2-46ef-4534-8f41-fe568ee8663b	How many games are there in the "Colony Wars" series for the PlayStation?	["3", "4", "5", "2"]	4	3	f	Entertainment: Video Games	medium	2025-06-19 03:51:23.49225+00
167	623b8231-e6df-426f-8725-48764aa9e8ae	7d1154e2-46ef-4534-8f41-fe568ee8663b	In "Earthbound", how does one enter "Master Belch's" factory?	["Enter the password \\"Fly Honey\\"", "Wait 3 Minutes", "Enter the password \\"Master Belch Rules\\"", "Enter the password \\"Mr Saturn Drools\\""]	Wait 3 Minutes	Wait 3 Minutes	t	Entertainment: Video Games	hard	2025-06-19 03:51:23.492251+00
168	623b8231-e6df-426f-8725-48764aa9e8ae	7d1154e2-46ef-4534-8f41-fe568ee8663b	Who was Tetris created by?	["Toru Iwatani", "Alexey Pajitnov", "William Higinbotham", "Allan Alcorn"]	Toru Iwatani	Alexey Pajitnov	f	Entertainment: Video Games	medium	2025-06-19 03:51:23.492252+00
169	623b8231-e6df-426f-8725-48764aa9e8ae	7d1154e2-46ef-4534-8f41-fe568ee8663b	When was "Garry's Mod" released?	["December 13, 2004", "November 13, 2004", "November 12, 2004", "December 24, 2004"]	November 12, 2004	December 24, 2004	f	Entertainment: Video Games	medium	2025-06-19 03:51:23.492253+00
170	623b8231-e6df-426f-8725-48764aa9e8ae	7d1154e2-46ef-4534-8f41-fe568ee8663b	In Call of Duty: Modern Warfare 2, how many consecutive kills does it require to earn the "Tactical Nuke" killstreak?	["20", "25", "35", "30"]	20	25	f	Entertainment: Video Games	medium	2025-06-19 03:51:23.492254+00
171	623b8231-e6df-426f-8725-48764aa9e8ae	7d1154e2-46ef-4534-8f41-fe568ee8663b	In the game Nuclear Throne, what organization chases the player character throughout the game?	["The I.D.P.D", "The Bandits", "The Fishmen", "The Y.V.G.G"]	The Fishmen	The I.D.P.D	f	Entertainment: Video Games	hard	2025-06-19 03:51:23.492254+00
172	623b8231-e6df-426f-8725-48764aa9e8ae	7d1154e2-46ef-4534-8f41-fe568ee8663b	In Touhou 12: Undefined Fantastic Object, which of these was not a playable character?	["Kirisame Marisa", "Hakurei Reimu", "Kochiya Sanae", "Izayoi Sakuya"]	Izayoi Sakuya	Izayoi Sakuya	t	Entertainment: Video Games	medium	2025-06-19 03:51:23.492255+00
173	623b8231-e6df-426f-8725-48764aa9e8ae	7d1154e2-46ef-4534-8f41-fe568ee8663b	Who is the main antagonist of Silent Hill 4?	["Pyramid Head", "Alessa Gillespie", "Claudia Wolf", "Walter Sullivan"]	Alessa Gillespie	Walter Sullivan	f	Entertainment: Video Games	medium	2025-06-19 03:51:23.492256+00
174	ecd51e41-2cf9-42ae-8328-8a04e7a89f4d	7d1154e2-46ef-4534-8f41-fe568ee8663b	In ancient Greece, if your job were a "hippeus" which of these would you own?	["Boat", "Horse", "Weave", "Guitar"]	Weave	Horse	f	General Knowledge	medium	2025-06-19 03:52:04.730408+00
175	ecd51e41-2cf9-42ae-8328-8a04e7a89f4d	7d1154e2-46ef-4534-8f41-fe568ee8663b	The architect known as Le Corbusier was an important figure in what style of architecture?	["Neoclassical", "Baroque", "Modernism", "Gothic Revival"]	Baroque	Modernism	f	General Knowledge	medium	2025-06-19 03:52:04.730416+00
176	ecd51e41-2cf9-42ae-8328-8a04e7a89f4d	7d1154e2-46ef-4534-8f41-fe568ee8663b	The word "astasia" means which of the following?	["The inability to make decisions", "A feverish desire to rip one's clothes off", "The inability to concentrate on anything", "The inability to stand up"]	The inability to make decisions	The inability to stand up	f	General Knowledge	hard	2025-06-19 03:52:04.730428+00
177	ecd51e41-2cf9-42ae-8328-8a04e7a89f4d	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which essential condiment is also known as Japanese horseradish?	["Wasabi ", "Ponzu", "Karashi", "Mentsuyu"]	Mentsuyu	Wasabi 	f	General Knowledge	medium	2025-06-19 03:52:04.73043+00
178	ecd51e41-2cf9-42ae-8328-8a04e7a89f4d	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which of the following Ivy League universities has its official motto in Hebrew as well as in Latin?	["Yale University", "Columbia University", "Princeton University", "Harvard University"]	Columbia University	Yale University	f	General Knowledge	medium	2025-06-19 03:52:04.730431+00
179	ecd51e41-2cf9-42ae-8328-8a04e7a89f4d	7d1154e2-46ef-4534-8f41-fe568ee8663b	The Mexican Beer "Corona" is what type of beer?	["Pilfsner", "Baltic Porter", "Pale Lager", "India Pale Ale"]	Pale Lager	Pale Lager	t	General Knowledge	medium	2025-06-19 03:52:04.730432+00
180	ecd51e41-2cf9-42ae-8328-8a04e7a89f4d	7d1154e2-46ef-4534-8f41-fe568ee8663b	What is the largest living species of penguin?	["King", "Emperor", "Gentoo", "Adele"]	King	Emperor	f	General Knowledge	easy	2025-06-19 03:52:04.730433+00
181	ecd51e41-2cf9-42ae-8328-8a04e7a89f4d	7d1154e2-46ef-4534-8f41-fe568ee8663b	In the video-game franchise Kingdom Hearts, the main protagonist, carries a weapon with what shape?	["Key", "Pen", "Cellphone", "Sword"]	Cellphone	Key	f	General Knowledge	easy	2025-06-19 03:52:04.730434+00
182	ecd51e41-2cf9-42ae-8328-8a04e7a89f4d	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which of the following is not another name for the eggplant?	["Brinjal", "Potimarron", "Melongene", "Guinea Squash"]	Guinea Squash	Potimarron	f	General Knowledge	hard	2025-06-19 03:52:04.730435+00
183	ecd51e41-2cf9-42ae-8328-8a04e7a89f4d	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which of the following presidents is not on Mount Rushmore?	["John F. Kennedy", "Theodore Roosevelt", "Abraham Lincoln", "Thomas Jefferson"]	Theodore Roosevelt	John F. Kennedy	f	General Knowledge	easy	2025-06-19 03:52:04.730435+00
184	4036abf3-de84-4ce9-b0a4-7beff6ed7871	7d1154e2-46ef-4534-8f41-fe568ee8663b	How many stations does the Central Line have on the London Underground?	["51", "47", "43", "49"]	47	49	f	Geography	hard	2025-06-19 03:52:58.795476+00
185	4036abf3-de84-4ce9-b0a4-7beff6ed7871	7d1154e2-46ef-4534-8f41-fe568ee8663b	Bridgetown is the capital of which island country in the Carribean?	["Jamaica‎", "Dominica", "Barbados", "Cuba"]	Jamaica‎	Barbados	f	Geography	medium	2025-06-19 03:52:58.795485+00
186	4036abf3-de84-4ce9-b0a4-7beff6ed7871	7d1154e2-46ef-4534-8f41-fe568ee8663b	What is the capital of the US state Nevada?	["Las Vegas", "Henderson", "Carson City", "Reno"]	Carson City	Carson City	t	Geography	medium	2025-06-19 03:52:58.795486+00
187	4036abf3-de84-4ce9-b0a4-7beff6ed7871	7d1154e2-46ef-4534-8f41-fe568ee8663b	Broome is a town in which state of Australia?	["Northern Territory", "South Australia", "Western Australia", "Tasmania"]	Tasmania	Western Australia	f	Geography	medium	2025-06-19 03:52:58.795487+00
252	38794c98-30b2-414b-aa0a-093664ae6cb2	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which of the following is used to measure blood pressure?	["Sphygmomanometer", "Haemoerythrometer", "Ruler", "Barometer"]	Barometer	Sphygmomanometer	f	Science: Gadgets	hard	2025-06-19 03:59:26.37646+00
188	4036abf3-de84-4ce9-b0a4-7beff6ed7871	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which of these American cities has fewer than 1,000,000 people?	["Philadelphia, Pennsylvania", "Phoenix, Arizona", "San Antonio, Texas", "San Francisco, California"]	Phoenix, Arizona	San Francisco, California	f	Geography	medium	2025-06-19 03:52:58.795488+00
189	4036abf3-de84-4ce9-b0a4-7beff6ed7871	7d1154e2-46ef-4534-8f41-fe568ee8663b	What was the African nation of Zimbabwe formerly known as?	["Rhodesia", " Bulawayo", "Zambia", "Mozambique"]	Rhodesia	Rhodesia	t	Geography	medium	2025-06-19 03:52:58.795489+00
190	4036abf3-de84-4ce9-b0a4-7beff6ed7871	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which country does Austria not border?	["Slovenia", "Slovakia", "France", "Switzerland"]	France	France	t	Geography	easy	2025-06-19 03:52:58.79549+00
191	4036abf3-de84-4ce9-b0a4-7beff6ed7871	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which is the largest city in Morocco?	["Fes", "Sale", "Rabat", "Casablanca"]	Sale	Casablanca	f	Geography	medium	2025-06-19 03:52:58.795491+00
192	4036abf3-de84-4ce9-b0a4-7beff6ed7871	7d1154e2-46ef-4534-8f41-fe568ee8663b	Where is the fast food chain "Panda Express" headquartered?	["Sacramento, California", "San Diego, California", "Fresno, California", "Rosemead, California"]	Rosemead, California	Rosemead, California	t	Geography	hard	2025-06-19 03:52:58.795492+00
193	4036abf3-de84-4ce9-b0a4-7beff6ed7871	7d1154e2-46ef-4534-8f41-fe568ee8663b	How many provinces are in the Netherlands?	["13", "10", "12", "14"]	10	12	f	Geography	medium	2025-06-19 03:52:58.795493+00
194	27c2f83c-af8b-49fa-83bf-b19dd9e23817	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which Nation did NOT have a Colony in modern-day North America?	["Spain", "Netherlands", "Portugal", "Sweden"]	Spain	Portugal	f	History	medium	2025-06-19 03:53:37.7746+00
195	27c2f83c-af8b-49fa-83bf-b19dd9e23817	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which of these countries was NOT a part of the Soviet Union?	["Turkmenistan", "Uzbekistan", "Kazakhstan", "Afghanistan"]	Uzbekistan	Afghanistan	f	History	medium	2025-06-19 03:53:37.774603+00
196	27c2f83c-af8b-49fa-83bf-b19dd9e23817	7d1154e2-46ef-4534-8f41-fe568ee8663b	Against which country did the Dutch Republic fight the Eighty Years' War?	["Portugal", "France", "England", "Spain"]	England	Spain	f	History	medium	2025-06-19 03:53:37.774604+00
197	27c2f83c-af8b-49fa-83bf-b19dd9e23817	7d1154e2-46ef-4534-8f41-fe568ee8663b	When did Lithuania declare independence from the Soviet Union?	["December 5th, 1991", "December 25th, 1991", "March 11th, 1990", "April 20th, 1989"]	December 25th, 1991	March 11th, 1990	f	History	hard	2025-06-19 03:53:37.774605+00
198	27c2f83c-af8b-49fa-83bf-b19dd9e23817	7d1154e2-46ef-4534-8f41-fe568ee8663b	The son of which pope supposedly held a lecherous fête involving 50 courtesans in the papal palace?	["Pius III", "Innocent V", "Urban II", "Alexander VI"]	Alexander VI	Alexander VI	t	History	hard	2025-06-19 03:53:37.774606+00
199	27c2f83c-af8b-49fa-83bf-b19dd9e23817	7d1154e2-46ef-4534-8f41-fe568ee8663b	In 1961, an American B-52 aircraft crashed and nearly detonated two 4mt nuclear bombs over which US city?	["Jacksonville, Florida", "Conway, Arkansas", "Hicksville, New York", "Goldsboro, North Carolina"]	Hicksville, New York	Goldsboro, North Carolina	f	History	medium	2025-06-19 03:53:37.774606+00
200	27c2f83c-af8b-49fa-83bf-b19dd9e23817	7d1154e2-46ef-4534-8f41-fe568ee8663b	A collection of Sanskrit hymns and verses known as the Vedas are sacred texts in what religion?	["Islam", "Hinduism", "Judaism", "Buddhism"]	Hinduism	Hinduism	t	History	easy	2025-06-19 03:53:37.774607+00
201	27c2f83c-af8b-49fa-83bf-b19dd9e23817	7d1154e2-46ef-4534-8f41-fe568ee8663b	What is the name of the Boeing B-29 that dropped the 'Little Boy' atomic bomb on Hiroshima?	["The Great Artiste", "Enola Gay", "Full House", "Necessary Evil"]	Necessary Evil	Enola Gay	f	History	hard	2025-06-19 03:53:37.774608+00
202	27c2f83c-af8b-49fa-83bf-b19dd9e23817	7d1154e2-46ef-4534-8f41-fe568ee8663b	The Battle of Hastings was fought in which year?	["1204", "911", "1420", "1066"]	1204	1066	f	History	hard	2025-06-19 03:53:37.774608+00
203	27c2f83c-af8b-49fa-83bf-b19dd9e23817	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which of the following battles is often considered as marking the beginning of the fall of the Western Roman Empire?	["Battle of Thessalonica", "Battle of Pollentia", "Battle of Adrianople", "Battle of Constantinople"]	Battle of Adrianople	Battle of Adrianople	t	History	medium	2025-06-19 03:53:37.774609+00
204	fb5cb953-ce03-444d-ba6c-38e5d7f3904f	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which of the following is not one of the Greek Fates?	["Clotho", "Narcissus", "Lachesis", "Atropos"]	Lachesis	Narcissus	f	Mythology	medium	2025-06-19 03:54:30.775305+00
205	fb5cb953-ce03-444d-ba6c-38e5d7f3904f	7d1154e2-46ef-4534-8f41-fe568ee8663b	According to Japanese folklore, what is the favorite food of the Kappa.	["Soba", "Kabocha", "Nasu", "Cucumbers"]	Soba	Cucumbers	f	Mythology	medium	2025-06-19 03:54:30.775309+00
206	fb5cb953-ce03-444d-ba6c-38e5d7f3904f	7d1154e2-46ef-4534-8f41-fe568ee8663b	Who in Greek mythology, who led the Argonauts in search of the Golden Fleece?	["Odysseus", "Jason", "Daedalus", "Castor"]	Jason	Jason	t	Mythology	easy	2025-06-19 03:54:30.77531+00
207	fb5cb953-ce03-444d-ba6c-38e5d7f3904f	7d1154e2-46ef-4534-8f41-fe568ee8663b	What immense structure is referred to in Norse Mythology as the Yggdrasil.	["Mountain", "Temple", "Castle", "Tree"]	Tree	Tree	t	Mythology	hard	2025-06-19 03:54:30.775311+00
208	fb5cb953-ce03-444d-ba6c-38e5d7f3904f	7d1154e2-46ef-4534-8f41-fe568ee8663b	In Norse mythology, what is the name of the serpent which eats the roots of the ash tree Yggdrasil?	["Nidhogg", "Ymir", "Bragi", "Odin"]	Ymir	Nidhogg	f	Mythology	hard	2025-06-19 03:54:30.775312+00
209	fb5cb953-ce03-444d-ba6c-38e5d7f3904f	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which of these mythological creatures is said to be half-man and half-horse?	["Centaur", "Minotaur", "Gorgon", "Pegasus"]	Gorgon	Centaur	f	Mythology	easy	2025-06-19 03:54:30.775313+00
210	fb5cb953-ce03-444d-ba6c-38e5d7f3904f	7d1154e2-46ef-4534-8f41-fe568ee8663b	The greek god Poseidon was the god of what?	["The Sea", "Sun", "Fire", "War"]	Sun	The Sea	f	Mythology	easy	2025-06-19 03:54:30.775314+00
211	fb5cb953-ce03-444d-ba6c-38e5d7f3904f	7d1154e2-46ef-4534-8f41-fe568ee8663b	Talos, the mythical giant bronze man, was the protector of which island?	["Crete", "Cyprus", "Sicily", "Sardinia"]	Crete	Crete	t	Mythology	hard	2025-06-19 03:54:30.775315+00
212	fb5cb953-ce03-444d-ba6c-38e5d7f3904f	7d1154e2-46ef-4534-8f41-fe568ee8663b	Who is the god of war in Polynesian mythology?	["Hina", "'Oro", "Māui", "Kohara"]	Māui	'Oro	f	Mythology	medium	2025-06-19 03:54:30.775315+00
213	fb5cb953-ce03-444d-ba6c-38e5d7f3904f	7d1154e2-46ef-4534-8f41-fe568ee8663b	According to Algonquian folklore, how does one transform into a Wendigo?	["Drinking the blood of many slain animals.", "Performing a ritual involving murder.", "Excessive mutilation of animal corpses.", "Participating in cannibalism."]	Participating in cannibalism.	Participating in cannibalism.	t	Mythology	hard	2025-06-19 03:54:30.775316+00
214	ba5d6417-5e5f-4616-bb46-da23bedcd2db	7d1154e2-46ef-4534-8f41-fe568ee8663b	What year did the effort to deploy the Common Core State Standards (CCSS) in the US begin?	["1997", "2012", "2006", "2009"]	2012	2009	f	Politics	hard	2025-06-19 03:55:20.225234+00
215	ba5d6417-5e5f-4616-bb46-da23bedcd2db	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which of these is NOT one of Donald Trump's children?	["Eric", "Ivanka", "Donald Jr.", "Julius"]	Julius	Julius	t	Politics	medium	2025-06-19 03:55:20.225239+00
216	ba5d6417-5e5f-4616-bb46-da23bedcd2db	7d1154e2-46ef-4534-8f41-fe568ee8663b	Who succeeded Joseph Stalin as General Secretary of the Communist Party of the Soviet Union?	["Boris Yeltsin", "Mikhail Gorbachev", "Nikita Khrushchev", "Leonid Brezhnev"]	Boris Yeltsin	Nikita Khrushchev	f	Politics	medium	2025-06-19 03:55:20.22524+00
217	ba5d6417-5e5f-4616-bb46-da23bedcd2db	7d1154e2-46ef-4534-8f41-fe568ee8663b	How many people are in the U.S. House of Representatives?	["260", "435", "415", "50"]	435	435	t	Politics	easy	2025-06-19 03:55:20.225242+00
218	ba5d6417-5e5f-4616-bb46-da23bedcd2db	7d1154e2-46ef-4534-8f41-fe568ee8663b	Former United States President Bill Clinton famously played which instrument?	["Violin", "Baritone horn", "Piano", "Saxophone"]	Violin	Saxophone	f	Politics	easy	2025-06-19 03:55:20.225243+00
219	ba5d6417-5e5f-4616-bb46-da23bedcd2db	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which Native American tribe/nation requires at least one half blood quantum (equivalent to one parent) to be eligible for membership?	["Yomba Shoshone Tribe", "Pawnee Nation of Oklahoma", "Kiowa Tribe of Oklahoma", "Standing Rock Sioux Tribe"]	Standing Rock Sioux Tribe	Yomba Shoshone Tribe	f	Politics	hard	2025-06-19 03:55:20.225243+00
340	84d18272-b73a-4837-b7c7-906464d1bebf	6a96be88-aec5-4aba-8b78-6aa2693cfa18	What is the domain name for the country Tuvalu?	[".tv", ".tl", ".tu", ".tt"]	.tv	.tv	t	Science: Computers	easy	2025-06-19 04:46:49.049172+00
220	ba5d6417-5e5f-4616-bb46-da23bedcd2db	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which former US president was nicknamed "Teddy" after he refused to shoot a defenseless black bear?	["Woodrow Wilson", "Theodore Roosevelt", "James F. Fielder", "Andrew Jackson"]	Theodore Roosevelt	Theodore Roosevelt	t	Politics	easy	2025-06-19 03:55:20.225244+00
221	ba5d6417-5e5f-4616-bb46-da23bedcd2db	7d1154e2-46ef-4534-8f41-fe568ee8663b	What was the personal nickname of the 40th Governor of the US State Louisiana, Huey Long?	["The Oracle", "The Hoot Owl", "The Kingfish", "The Champ"]	The Kingfish	The Kingfish	t	Politics	medium	2025-06-19 03:55:20.225245+00
222	ba5d6417-5e5f-4616-bb46-da23bedcd2db	7d1154e2-46ef-4534-8f41-fe568ee8663b	Who was the British Prime Minister at the outbreak of the Second World War?	["Stanley Baldwin", "Winston Churchill", "Neville Chamberlain", "Clement Attlee"]	Winston Churchill	Neville Chamberlain	f	Politics	medium	2025-06-19 03:55:20.225246+00
223	ba5d6417-5e5f-4616-bb46-da23bedcd2db	7d1154e2-46ef-4534-8f41-fe568ee8663b	Who was the longest-serving senator in US history, serving from 1959 to 2010?	["Daniel Inouye", "Strom Thurmond", "Joe Biden", "Robert Byrd"]	Daniel Inouye	Robert Byrd	f	Politics	hard	2025-06-19 03:55:20.225247+00
224	c7d0131a-f38d-480e-9743-04a12add675f	7d1154e2-46ef-4534-8f41-fe568ee8663b	Human cells typically have how many copies of each gene?	["1", "4", "3", "2"]	2	2	t	Science & Nature	easy	2025-06-19 03:55:54.55353+00
225	c7d0131a-f38d-480e-9743-04a12add675f	7d1154e2-46ef-4534-8f41-fe568ee8663b	What term is best associated with Sigmund Freud?	["Theory of Gravity", "Psychoanalysis", "Dialectical Behavior Therapy", "Cognitive-Behavioral Therapy"]	Psychoanalysis	Psychoanalysis	t	Science & Nature	medium	2025-06-19 03:55:54.553534+00
226	c7d0131a-f38d-480e-9743-04a12add675f	7d1154e2-46ef-4534-8f41-fe568ee8663b	Folic acid is the synthetic form of which vitamin?	["Vitamin D", "Vitamin C", "Vitamin A", "Vitamin B"]	Vitamin C	Vitamin B	f	Science & Nature	hard	2025-06-19 03:55:54.553535+00
227	c7d0131a-f38d-480e-9743-04a12add675f	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which of these chemical compounds is NOT found in gastric acid?	["Potassium chloride", "Sodium chloride", "Hydrochloric acid", "Sulfuric acid"]	Hydrochloric acid	Sulfuric acid	f	Science & Nature	hard	2025-06-19 03:55:54.553536+00
228	c7d0131a-f38d-480e-9743-04a12add675f	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which of these is a semiconductor amplifying device?	["transistor", "tube", "P-N junction", "diode"]	transistor	transistor	t	Science & Nature	hard	2025-06-19 03:55:54.553537+00
229	c7d0131a-f38d-480e-9743-04a12add675f	7d1154e2-46ef-4534-8f41-fe568ee8663b	The 'Islets of Langerhans' is found in which human organ?	["Pancreas", "Liver", "Kidney", "Brain"]	Kidney	Pancreas	f	Science & Nature	hard	2025-06-19 03:55:54.553538+00
230	c7d0131a-f38d-480e-9743-04a12add675f	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which of the following are cells of the adaptive immune system?	["Dendritic cells", "Natural killer cells", "Cytotoxic T cells", "White blood cells"]	Natural killer cells	Cytotoxic T cells	f	Science & Nature	hard	2025-06-19 03:55:54.553539+00
231	c7d0131a-f38d-480e-9743-04a12add675f	7d1154e2-46ef-4534-8f41-fe568ee8663b	An organic compound is considered an alcohol if it has what functional group?	["Aldehyde", "Carbonyl", "Hydroxyl", "Alkyl"]	Alkyl	Hydroxyl	f	Science & Nature	hard	2025-06-19 03:55:54.55354+00
232	c7d0131a-f38d-480e-9743-04a12add675f	7d1154e2-46ef-4534-8f41-fe568ee8663b	Where in the human body is the Pineal Gland located?	["Chest", "Groin", "Brain", "Throat"]	Chest	Brain	f	Science & Nature	hard	2025-06-19 03:55:54.55354+00
233	c7d0131a-f38d-480e-9743-04a12add675f	7d1154e2-46ef-4534-8f41-fe568ee8663b	The medical term for the belly button is which of the following?	["Nares", "Umbilicus", "Paxillus", "Nevus"]	Paxillus	Umbilicus	f	Science & Nature	easy	2025-06-19 03:55:54.553541+00
234	fc97de5c-054d-4f0a-b96a-8eb890818073	7d1154e2-46ef-4534-8f41-fe568ee8663b	HTML is what type of language?	["Programming Language", "Markup Language", "Macro Language", "Scripting Language"]	Markup Language	Markup Language	t	Science: Computers	easy	2025-06-19 03:57:34.010279+00
235	fc97de5c-054d-4f0a-b96a-8eb890818073	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which operating system was released first?	["Windows", "OS/2", "Linux", "Mac OS"]	OS/2	Mac OS	f	Science: Computers	medium	2025-06-19 03:57:34.010288+00
236	fc97de5c-054d-4f0a-b96a-8eb890818073	7d1154e2-46ef-4534-8f41-fe568ee8663b	Who is the original author of the realtime physics engine called PhysX?	["Nvidia", "Ageia", "AMD", "NovodeX"]	NovodeX	NovodeX	t	Science: Computers	hard	2025-06-19 03:57:34.010289+00
237	fc97de5c-054d-4f0a-b96a-8eb890818073	7d1154e2-46ef-4534-8f41-fe568ee8663b	The Harvard architecture for micro-controllers added which additional bus?	["Data", "Instruction", "Control", "Address"]	Address	Instruction	f	Science: Computers	hard	2025-06-19 03:57:34.010291+00
238	fc97de5c-054d-4f0a-b96a-8eb890818073	7d1154e2-46ef-4534-8f41-fe568ee8663b	Released in 2001, the first edition of Apple's Mac OS X operating system (version 10.0) was given what animal code name?	["Leopard", "Puma", "Tiger", "Cheetah"]	Puma	Cheetah	f	Science: Computers	hard	2025-06-19 03:57:34.010292+00
239	fc97de5c-054d-4f0a-b96a-8eb890818073	7d1154e2-46ef-4534-8f41-fe568ee8663b	What type of sound chip does the Super Nintendo Entertainment System (SNES) have?	["PCM Sampler", "ADPCM Sampler", "Programmable Sound Generator (PSG)", "FM Synthesizer"]	PCM Sampler	ADPCM Sampler	f	Science: Computers	hard	2025-06-19 03:57:34.010293+00
240	fc97de5c-054d-4f0a-b96a-8eb890818073	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which of the following is a personal computer made by the Japanese company Fujitsu?	["Xmillennium ", "PC-9801", "MSX", "FM-7"]	Xmillennium 	FM-7	f	Science: Computers	medium	2025-06-19 03:57:34.010294+00
241	fc97de5c-054d-4f0a-b96a-8eb890818073	7d1154e2-46ef-4534-8f41-fe568ee8663b	What does RAID stand for?	["Randomized Abstract Identification Description", "Redundant Array of Independent Disks", "Rapid Access for Indexed Devices", "Range of Applications with Identical Designs"]	Redundant Array of Independent Disks	Redundant Array of Independent Disks	t	Science: Computers	medium	2025-06-19 03:57:34.010295+00
242	fc97de5c-054d-4f0a-b96a-8eb890818073	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which of the following languages is used as a scripting language in the Unity 3D game engine?	["C#", "Java", "C++", "Objective-C"]	C#	C#	t	Science: Computers	medium	2025-06-19 03:57:34.010296+00
243	fc97de5c-054d-4f0a-b96a-8eb890818073	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which one of these is not an official development name for a Ubuntu release?	["Trusty Tahr", "Utopic Unicorn", "Mystic Mansion", "Wily Werewolf"]	Trusty Tahr	Mystic Mansion	f	Science: Computers	medium	2025-06-19 03:57:34.010297+00
244	38794c98-30b2-414b-aa0a-093664ae6cb2	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which virtual assistant is developed by Amazon?	["Alexa", "Google Assistant", "Cortana", "Siri"]	Alexa	Alexa	t	Science: Gadgets	easy	2025-06-19 03:59:26.37645+00
245	38794c98-30b2-414b-aa0a-093664ae6cb2	7d1154e2-46ef-4534-8f41-fe568ee8663b	What does GPS stand for?	["General Personal Satellite", "Global Positioning System", "Global Personal System", "General Positioning System"]	Global Positioning System	Global Positioning System	t	Science: Gadgets	easy	2025-06-19 03:59:26.376454+00
246	38794c98-30b2-414b-aa0a-093664ae6cb2	7d1154e2-46ef-4534-8f41-fe568ee8663b	When was the iPhone released?	["2007", "2006", "2004", "2005"]	2004	2007	f	Science: Gadgets	easy	2025-06-19 03:59:26.376455+00
247	38794c98-30b2-414b-aa0a-093664ae6cb2	7d1154e2-46ef-4534-8f41-fe568ee8663b	When did the CD begin to appear on the consumer market?	["1992", "1962", "1982", "1972"]	1992	1982	f	Science: Gadgets	easy	2025-06-19 03:59:26.376456+00
248	38794c98-30b2-414b-aa0a-093664ae6cb2	7d1154e2-46ef-4534-8f41-fe568ee8663b	Who built the first laser?	["Edith Clarke", "Theodore Harold Maiman", "Jack Kilby", "Nikola Tesla"]	Edith Clarke	Theodore Harold Maiman	f	Science: Gadgets	hard	2025-06-19 03:59:26.376457+00
249	38794c98-30b2-414b-aa0a-093664ae6cb2	7d1154e2-46ef-4534-8f41-fe568ee8663b	Mobile hardware and software company "Blackberry Limited" was founded in which country?	["Norway", "Canada", "United Kingdom", "United States of America"]	Canada	Canada	t	Science: Gadgets	medium	2025-06-19 03:59:26.376458+00
250	38794c98-30b2-414b-aa0a-093664ae6cb2	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which of the following is not a type of computer mouse?	["Optical mouse", "Drum mouse", "Smoothie mouse", "Trackball mouse"]	Drum mouse	Smoothie mouse	f	Science: Gadgets	easy	2025-06-19 03:59:26.376459+00
251	38794c98-30b2-414b-aa0a-093664ae6cb2	7d1154e2-46ef-4534-8f41-fe568ee8663b	Who patented a steam engine that produced continuous rotary motion?	["Alessandro Volta", "James Watt", "Nikola Tesla", "Albert Einstein"]	James Watt	James Watt	t	Science: Gadgets	medium	2025-06-19 03:59:26.37646+00
253	38794c98-30b2-414b-aa0a-093664ae6cb2	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which of the following cellular device companies is NOT headquartered in Asia?	["Samsung", "Nokia", "HTC", "LG Electronics"]	HTC	Nokia	f	Science: Gadgets	hard	2025-06-19 03:59:26.376461+00
254	14e19520-c402-4ba5-9338-832bff42540a	7d1154e2-46ef-4534-8f41-fe568ee8663b	How many books are in Euclid's Elements of Geometry?	["17", "10", "8", "13"]	8	13	f	Science: Mathematics	medium	2025-06-19 04:00:18.551308+00
255	14e19520-c402-4ba5-9338-832bff42540a	7d1154e2-46ef-4534-8f41-fe568ee8663b	What is the first Mersenne prime exponent over 1000?	["2203", "1009", "1279", "1069"]	2203	1279	f	Science: Mathematics	medium	2025-06-19 04:00:18.551312+00
256	14e19520-c402-4ba5-9338-832bff42540a	7d1154e2-46ef-4534-8f41-fe568ee8663b	The decimal number 31 in hexadecimal would be what?	["2E", "1B", "3D", "1F"]	3D	1F	f	Science: Mathematics	hard	2025-06-19 04:00:18.551313+00
257	14e19520-c402-4ba5-9338-832bff42540a	7d1154e2-46ef-4534-8f41-fe568ee8663b	What is the alphanumeric representation of the imaginary number?	["i", "n", "e", "x"]	i	i	t	Science: Mathematics	medium	2025-06-19 04:00:18.551314+00
258	14e19520-c402-4ba5-9338-832bff42540a	7d1154e2-46ef-4534-8f41-fe568ee8663b	What is the equation for the area of a sphere?	["4πr^2", "(1/3)πhr^2", "πr^4", "(4/3)πr^3"]	πr^4	(4/3)πr^3	f	Science: Mathematics	easy	2025-06-19 04:00:18.551315+00
259	14e19520-c402-4ba5-9338-832bff42540a	7d1154e2-46ef-4534-8f41-fe568ee8663b	The French mathematician Évariste Galois is primarily known for his work in which?	["Galois' Continued Fractions", "Abelian Integration", "Galois' Method for PDE's ", "Galois Theory"]	Galois' Continued Fractions	Galois Theory	f	Science: Mathematics	hard	2025-06-19 04:00:18.551316+00
260	14e19520-c402-4ba5-9338-832bff42540a	7d1154e2-46ef-4534-8f41-fe568ee8663b	What type of angle is greater than 90°?	["Right", "Straight", "Acute", "Obtuse"]	Acute	Obtuse	f	Science: Mathematics	easy	2025-06-19 04:00:18.551316+00
261	14e19520-c402-4ba5-9338-832bff42540a	7d1154e2-46ef-4534-8f41-fe568ee8663b	How many sides does a trapezium have?	["6", "4", "5", "3"]	3	4	f	Science: Mathematics	easy	2025-06-19 04:00:18.551317+00
262	14e19520-c402-4ba5-9338-832bff42540a	7d1154e2-46ef-4534-8f41-fe568ee8663b	What is the area of a circle with a diameter of 20 inches if π= 3.1415?	["3141.5 Inches", "380.1215 Inches", "314.15 Inches", "1256.6 Inches"]	380.1215 Inches	314.15 Inches	f	Science: Mathematics	medium	2025-06-19 04:00:18.551318+00
263	14e19520-c402-4ba5-9338-832bff42540a	7d1154e2-46ef-4534-8f41-fe568ee8663b	What is the fourth digit of π?	["4", "2", "3", "1"]	3	1	f	Science: Mathematics	hard	2025-06-19 04:00:18.551329+00
264	90c493f0-dcfa-40fe-b1ff-f126a92c2d96	7d1154e2-46ef-4534-8f41-fe568ee8663b	How many French Open's did Björn Borg win?	["2", "4", "6", "9"]	2	6	f	Sports	medium	2025-06-19 04:00:53.585568+00
265	90c493f0-dcfa-40fe-b1ff-f126a92c2d96	7d1154e2-46ef-4534-8f41-fe568ee8663b	Who won the premier league title in the 2015-2016 season following a fairy tale run?	["Watford", "Tottenham Hotspur", "Leicester City", "Stoke City"]	Leicester City	Leicester City	t	Sports	easy	2025-06-19 04:00:53.585586+00
266	90c493f0-dcfa-40fe-b1ff-f126a92c2d96	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which English football club has the nickname 'The Foxes'?	["West Bromwich Albion", "Leicester City", "Northampton Town", "Bradford City"]	Leicester City	Leicester City	t	Sports	easy	2025-06-19 04:00:53.585588+00
267	90c493f0-dcfa-40fe-b1ff-f126a92c2d96	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which player holds the NHL record of 2,857 points?	["Sidney Crosby", "Wayne Gretzky", "Gordie Howe", "Mario Lemieux "]	Gordie Howe	Wayne Gretzky	f	Sports	easy	2025-06-19 04:00:53.585589+00
268	90c493f0-dcfa-40fe-b1ff-f126a92c2d96	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which English football team is nicknamed 'The Tigers'?	["Bristol City", "Cardiff City", "Manchester City", "Hull City"]	Bristol City	Hull City	f	Sports	hard	2025-06-19 04:00:53.58559+00
269	90c493f0-dcfa-40fe-b1ff-f126a92c2d96	7d1154e2-46ef-4534-8f41-fe568ee8663b	Who scored the injury time winning goal in the 1999 UEFA Champions League final between Manchester United and Bayern Munich?	["Dwight Yorke", "Andy Cole", "Ole Gunnar Solskjær", "David Beckham"]	Ole Gunnar Solskjær	Ole Gunnar Solskjær	t	Sports	hard	2025-06-19 04:00:53.58559+00
270	90c493f0-dcfa-40fe-b1ff-f126a92c2d96	7d1154e2-46ef-4534-8f41-fe568ee8663b	Josh Mansour is part of what NRL team?	["Melbourne Storm", "Sydney Roosters", "North Queensland Cowboys", "Penrith Panthers"]	Penrith Panthers	Penrith Panthers	t	Sports	medium	2025-06-19 04:00:53.585591+00
271	90c493f0-dcfa-40fe-b1ff-f126a92c2d96	7d1154e2-46ef-4534-8f41-fe568ee8663b	How many times did Martina Navratilova win the Wimbledon Singles Championship?	["Eight", "Ten", "Seven", "Nine"]	Ten	Nine	f	Sports	hard	2025-06-19 04:00:53.585593+00
272	90c493f0-dcfa-40fe-b1ff-f126a92c2d96	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which country hosted the 2022 FIFA World Cup?	["Qatar", "Switzerland", "Japan", "USA"]	Qatar	Qatar	t	Sports	easy	2025-06-19 04:00:53.585594+00
273	90c493f0-dcfa-40fe-b1ff-f126a92c2d96	7d1154e2-46ef-4534-8f41-fe568ee8663b	How many soccer players should be on the field at the same time?	["26", "22", "24", "20"]	20	22	f	Sports	easy	2025-06-19 04:00:53.585595+00
274	2b0caa58-8083-4678-acdb-72930a00727f	7d1154e2-46ef-4534-8f41-fe568ee8663b	Automobiles produced by Tesla Motors operate on which form of energy?	["Nuclear", "Diesel", "Gasoline", "Electricity"]	Gasoline	Electricity	f	Vehicles	easy	2025-06-19 04:01:36.979479+00
275	2b0caa58-8083-4678-acdb-72930a00727f	7d1154e2-46ef-4534-8f41-fe568ee8663b	Which one of these chassis codes are used by BMW 3-series?	["E39", "F10", "E46", "E85"]	F10	E46	f	Vehicles	hard	2025-06-19 04:01:36.979484+00
276	2b0caa58-8083-4678-acdb-72930a00727f	7d1154e2-46ef-4534-8f41-fe568ee8663b	The LS7 engine is how many cubic inches?	["364", "346", "427", "376"]	364	427	f	Vehicles	easy	2025-06-19 04:01:36.979485+00
277	2b0caa58-8083-4678-acdb-72930a00727f	7d1154e2-46ef-4534-8f41-fe568ee8663b	Where are the cars of the brand "Ferrari" manufactured?	["Italy", "Germany", "Romania", "Russia"]	Romania	Italy	f	Vehicles	easy	2025-06-19 04:01:36.979486+00
278	2b0caa58-8083-4678-acdb-72930a00727f	7d1154e2-46ef-4534-8f41-fe568ee8663b	The difference between the lengths of a Boeing 777-300ER and an Airbus A350-1000 is closest to:	["100m", "0.1m", "1m", "10m "]	0.1m	0.1m	t	Vehicles	hard	2025-06-19 04:01:36.979487+00
279	2b0caa58-8083-4678-acdb-72930a00727f	7d1154e2-46ef-4534-8f41-fe568ee8663b	What model was the sports car gifted to Yuri Gagarin by the French government in 1965?	["AC Cobra", "Alpine A110", "Matra Djet", "Porsche 911"]	AC Cobra	Matra Djet	f	Vehicles	hard	2025-06-19 04:01:36.979487+00
280	2b0caa58-8083-4678-acdb-72930a00727f	7d1154e2-46ef-4534-8f41-fe568ee8663b	What are the cylinder-like parts that pump up and down within the engine?	["Leaf Springs", "Radiators", "ABS", "Pistons"]	Pistons	Pistons	t	Vehicles	easy	2025-06-19 04:01:36.979488+00
281	2b0caa58-8083-4678-acdb-72930a00727f	7d1154e2-46ef-4534-8f41-fe568ee8663b	What car manufacturer gave away their patent for the seat-belt in the interest of saving lives?	["Renault", "Ford", "Ferrari", "Volvo"]	Ford	Volvo	f	Vehicles	hard	2025-06-19 04:01:36.979489+00
282	2b0caa58-8083-4678-acdb-72930a00727f	7d1154e2-46ef-4534-8f41-fe568ee8663b	Complete the following analogy: Audi is to Volkswagen as Infiniti is to ?	["Nissan", "Honda", "Subaru", "Hyundai"]	Subaru	Nissan	f	Vehicles	medium	2025-06-19 04:01:36.97949+00
283	2b0caa58-8083-4678-acdb-72930a00727f	7d1154e2-46ef-4534-8f41-fe568ee8663b	When was Tesla founded?	["2007", "2008", "2005", "2003"]	2007	2003	f	Vehicles	medium	2025-06-19 04:01:36.979491+00
284	2714d39c-2e70-4efe-810b-89f6c35d831a	90bdd136-034b-4ec0-a527-bc308bcc1a2f	Cashmere is the wool from which kind of animal?	["Sheep", "Camel", "Llama", "Goat"]	Goat	Goat	t	Animals	medium	2025-06-19 04:05:03.071241+00
285	2714d39c-2e70-4efe-810b-89f6c35d831a	90bdd136-034b-4ec0-a527-bc308bcc1a2f	How many known living species of hyenas are there?	["4", "6", "2", "8"]	4	4	t	Animals	hard	2025-06-19 04:05:03.071245+00
286	2714d39c-2e70-4efe-810b-89f6c35d831a	90bdd136-034b-4ec0-a527-bc308bcc1a2f	By definition, where does an abyssopelagic animal live?	["Inside a tree", "At the bottom of the ocean", "In the desert", "On top of a mountain"]	In the desert	At the bottom of the ocean	f	Animals	easy	2025-06-19 04:05:03.071246+00
287	2714d39c-2e70-4efe-810b-89f6c35d831a	90bdd136-034b-4ec0-a527-bc308bcc1a2f	What is Grumpy Cat's real name?	["Minnie", "Tardar Sauce", "Sauce", "Broccoli"]	Tardar Sauce	Tardar Sauce	t	Animals	easy	2025-06-19 04:05:03.071247+00
288	2714d39c-2e70-4efe-810b-89f6c35d831a	90bdd136-034b-4ec0-a527-bc308bcc1a2f	Which of the following is true when alligators are behaving territorially?	["They bellow while showing their tail and neck", "Slap their tails on the ground", "They run full force at the threat", "Open their jaws while making a clicking noise"]	Open their jaws while making a clicking noise	They bellow while showing their tail and neck	f	Animals	medium	2025-06-19 04:05:03.071248+00
289	2714d39c-2e70-4efe-810b-89f6c35d831a	90bdd136-034b-4ec0-a527-bc308bcc1a2f	What scientific suborder does the family Hyaenidae belong to?	["Feliformia", "Haplorhini", "Caniformia", "Ciconiiformes"]	Feliformia	Feliformia	t	Animals	hard	2025-06-19 04:05:03.071249+00
290	2714d39c-2e70-4efe-810b-89f6c35d831a	90bdd136-034b-4ec0-a527-bc308bcc1a2f	What is the scientific name of the cheetah?	["Acinonyx jubatus", "Lynx rufus", "Panthera onca", "Felis catus"]	Felis catus	Acinonyx jubatus	f	Animals	hard	2025-06-19 04:05:03.071249+00
291	2714d39c-2e70-4efe-810b-89f6c35d831a	90bdd136-034b-4ec0-a527-bc308bcc1a2f	How many teeth does an adult rabbit have?	["24", "30", "26", "28"]	28	28	t	Animals	easy	2025-06-19 04:05:03.07125+00
292	2714d39c-2e70-4efe-810b-89f6c35d831a	90bdd136-034b-4ec0-a527-bc308bcc1a2f	"Decapods" are an order of ten-footed crustaceans.  Which of these are NOT decapods?	["Crabs", "Shrimp", "Lobsters", "Krill"]	Crabs	Krill	f	Animals	medium	2025-06-19 04:05:03.071251+00
293	2714d39c-2e70-4efe-810b-89f6c35d831a	90bdd136-034b-4ec0-a527-bc308bcc1a2f	What is the name for a male bee that comes from an unfertilized egg?	["Drone", "Soldier", "Male", "Worker"]	Drone	Drone	t	Animals	medium	2025-06-19 04:05:03.071252+00
314	54434b25-2d8d-4e90-ab4c-1dba826f6ea8	6a96be88-aec5-4aba-8b78-6aa2693cfa18	The song "Feel Good Inc." by British band Gorillaz features which hip hop group?	["Public Enemy", "De La Soul", "OutKast", "Cypress Hill"]	Public Enemy	De La Soul	f	Entertainment: Music	medium	2025-06-19 04:12:45.769665+00
315	54434b25-2d8d-4e90-ab4c-1dba826f6ea8	6a96be88-aec5-4aba-8b78-6aa2693cfa18	What album did Gorillaz release in 2017?	["Demon Days", "The Fall", "Plastic Beach", "Humanz"]	Plastic Beach	Humanz	f	Entertainment: Music	medium	2025-06-19 04:12:45.769669+00
316	54434b25-2d8d-4e90-ab4c-1dba826f6ea8	6a96be88-aec5-4aba-8b78-6aa2693cfa18	What was the name of Pink Floyd's first studio album?	["More", "The Piper at the Gates of Dawn", "Atom Heart Mother", "Ummagumma"]	The Piper at the Gates of Dawn	The Piper at the Gates of Dawn	t	Entertainment: Music	medium	2025-06-19 04:12:45.76967+00
317	54434b25-2d8d-4e90-ab4c-1dba826f6ea8	6a96be88-aec5-4aba-8b78-6aa2693cfa18	"All the Boys" by Panic! At the Disco was released as a bonus track on what album?	["Death Of A Bachelor", "A Fever You Can't Sweat Out", "Too Weird To Live, Too Rare To Die!", "Vices & Virtues"]	Too Weird To Live, Too Rare To Die!	Too Weird To Live, Too Rare To Die!	t	Entertainment: Music	hard	2025-06-19 04:12:45.769671+00
318	54434b25-2d8d-4e90-ab4c-1dba826f6ea8	6a96be88-aec5-4aba-8b78-6aa2693cfa18	What M83 was featured in Grand Theft Auto V's radio?	["Midnight City", "Outro", "Reunion", "Wait"]	Outro	Midnight City	f	Entertainment: Music	medium	2025-06-19 04:12:45.769672+00
319	54434b25-2d8d-4e90-ab4c-1dba826f6ea8	6a96be88-aec5-4aba-8b78-6aa2693cfa18	Which of these artists do NOT originate from France?	["Air", "Daft Punk", "Justice", "The Chemical Brothers"]	The Chemical Brothers	The Chemical Brothers	t	Entertainment: Music	medium	2025-06-19 04:12:45.769673+00
320	54434b25-2d8d-4e90-ab4c-1dba826f6ea8	6a96be88-aec5-4aba-8b78-6aa2693cfa18	Björk's "Unison" contains a sample of which Oval song?	["Textuell", "Do While", "Aero Deck", "Panorama"]	Textuell	Aero Deck	f	Entertainment: Music	hard	2025-06-19 04:12:45.769674+00
321	54434b25-2d8d-4e90-ab4c-1dba826f6ea8	6a96be88-aec5-4aba-8b78-6aa2693cfa18	Which song in rapper Kanye West's album "The Life of Pablo" features Rihanna?	["Ultralight Beam", "Highlights", "Wolves", "Famous"]	Wolves	Famous	f	Entertainment: Music	hard	2025-06-19 04:12:45.769675+00
322	54434b25-2d8d-4e90-ab4c-1dba826f6ea8	6a96be88-aec5-4aba-8b78-6aa2693cfa18	African-American performer Sammy Davis Jr. was known for losing which part of his body in a car accident?	["Left Eye", "Right Middle Finger", "Nose", "Right Ear"]	Right Middle Finger	Left Eye	f	Entertainment: Music	medium	2025-06-19 04:12:45.769675+00
323	54434b25-2d8d-4e90-ab4c-1dba826f6ea8	6a96be88-aec5-4aba-8b78-6aa2693cfa18	What is Fergie's debut album called?	["The Dutchess", "Loose", "Fergalicious ", "The Sweet Escape"]	The Sweet Escape	The Dutchess	f	Entertainment: Music	medium	2025-06-19 04:12:45.769676+00
324	b8098889-3a02-4585-8551-3b33db8b7978	6a96be88-aec5-4aba-8b78-6aa2693cfa18	How long is an IPv6 address?	["128 bytes", "128 bits", "64 bits", "32 bits"]	64 bits	128 bits	f	Science: Computers	easy	2025-06-19 04:42:31.340572+00
325	b8098889-3a02-4585-8551-3b33db8b7978	6a96be88-aec5-4aba-8b78-6aa2693cfa18	In the programming language Java, which of these keywords would you put on a variable to make sure it doesn't get modified?	["Public", "Private", "Final", "Static"]	Public	Final	f	Science: Computers	easy	2025-06-19 04:42:31.340582+00
326	b8098889-3a02-4585-8551-3b33db8b7978	6a96be88-aec5-4aba-8b78-6aa2693cfa18	What is the code name for the mobile operating system Android 7.0?	["Ice Cream Sandwich", "Nougat", "Marshmallow", "Jelly Bean"]	Nougat	Nougat	t	Science: Computers	easy	2025-06-19 04:42:31.340583+00
327	b8098889-3a02-4585-8551-3b33db8b7978	6a96be88-aec5-4aba-8b78-6aa2693cfa18	HTML is what type of language?	["Programming Language", "Scripting Language", "Markup Language", "Macro Language"]	Markup Language	Markup Language	t	Science: Computers	easy	2025-06-19 04:42:31.340585+00
328	b8098889-3a02-4585-8551-3b33db8b7978	6a96be88-aec5-4aba-8b78-6aa2693cfa18	What does the Prt Sc button do?	["Closes all windows", "Captures what's on the screen and copies it to your clipboard", "Saves a .png file of what's on the screen in your screenshots folder in photos", "Nothing"]	Captures what's on the screen and copies it to your clipboard	Captures what's on the screen and copies it to your clipboard	t	Science: Computers	easy	2025-06-19 04:42:31.340586+00
329	b8098889-3a02-4585-8551-3b33db8b7978	6a96be88-aec5-4aba-8b78-6aa2693cfa18	On a standard American QWERTY keyboard, what symbol will you enter if you hold the shift key and press 1?	["Dollar Sign", "Asterisk", "Exclamation Mark", "Percent Sign"]	Exclamation Mark	Exclamation Mark	t	Science: Computers	easy	2025-06-19 04:42:31.340587+00
330	b8098889-3a02-4585-8551-3b33db8b7978	6a96be88-aec5-4aba-8b78-6aa2693cfa18	What programming language was GitHub written in?	["Lua", "JavaScript", "Python", "Ruby"]	Lua	Ruby	f	Science: Computers	easy	2025-06-19 04:42:31.340589+00
331	b8098889-3a02-4585-8551-3b33db8b7978	6a96be88-aec5-4aba-8b78-6aa2693cfa18	What does LTS stand for in the software market?	["Long Term Support", "Ludicrous Turbo Speed", "Long Taco Service", "Ludicrous Transfer Speed"]	Long Term Support	Long Term Support	t	Science: Computers	easy	2025-06-19 04:42:31.34059+00
332	b8098889-3a02-4585-8551-3b33db8b7978	6a96be88-aec5-4aba-8b78-6aa2693cfa18	In web design, what does CSS stand for?	["Cascading Style Sheet", "Corrective Style Sheet", "Counter Strike: Source", "Computer Style Sheet"]	Cascading Style Sheet	Cascading Style Sheet	t	Science: Computers	easy	2025-06-19 04:42:31.340591+00
333	b8098889-3a02-4585-8551-3b33db8b7978	6a96be88-aec5-4aba-8b78-6aa2693cfa18	Which SQL keyword is used to fetch data from a database?	["INDEX", "VALUES", "EXEC", "SELECT"]	SELECT	SELECT	t	Science: Computers	easy	2025-06-19 04:42:31.340592+00
334	84d18272-b73a-4837-b7c7-906464d1bebf	6a96be88-aec5-4aba-8b78-6aa2693cfa18	What is the code name for the mobile operating system Android 7.0?	["Ice Cream Sandwich", "Nougat", "Jelly Bean", "Marshmallow"]	Nougat	Nougat	t	Science: Computers	easy	2025-06-19 04:46:49.04915+00
335	84d18272-b73a-4837-b7c7-906464d1bebf	6a96be88-aec5-4aba-8b78-6aa2693cfa18	What does the Prt Sc button do?	["Saves a .png file of what's on the screen in your screenshots folder in photos", "Captures what's on the screen and copies it to your clipboard", "Closes all windows", "Nothing"]	Captures what's on the screen and copies it to your clipboard	Captures what's on the screen and copies it to your clipboard	t	Science: Computers	easy	2025-06-19 04:46:49.049165+00
336	84d18272-b73a-4837-b7c7-906464d1bebf	6a96be88-aec5-4aba-8b78-6aa2693cfa18	Which computer language would you associate Django framework with?	["Java", "C++", "Python", "C#"]	Python	Python	t	Science: Computers	easy	2025-06-19 04:46:49.049167+00
337	84d18272-b73a-4837-b7c7-906464d1bebf	6a96be88-aec5-4aba-8b78-6aa2693cfa18	What is the most preferred image format used for logos in the Wikimedia database?	[".svg", ".jpeg", ".gif", ".png"]	.svg	.svg	t	Science: Computers	easy	2025-06-19 04:46:49.049168+00
338	84d18272-b73a-4837-b7c7-906464d1bebf	6a96be88-aec5-4aba-8b78-6aa2693cfa18	The programming language 'Swift' was created to replace what other programming language?	["Objective-C", "Ruby", "C++", "C#"]	Objective-C	Objective-C	t	Science: Computers	easy	2025-06-19 04:46:49.04917+00
339	84d18272-b73a-4837-b7c7-906464d1bebf	6a96be88-aec5-4aba-8b78-6aa2693cfa18	What programming language was GitHub written in?	["Ruby", "JavaScript", "Lua", "Python"]	Lua	Ruby	f	Science: Computers	easy	2025-06-19 04:46:49.049171+00
294	dc82fc9a-ad64-4a50-8fac-0e2c3b340ccd	6a96be88-aec5-4aba-8b78-6aa2693cfa18	In JoJo's Bizarre Adventure, which character is able to accelerate time?	["Jotaro Kujo", "Jolyne Cujoh", "Kujo Jotaro", "Enrico Pucci"]	Enrico Pucci	Enrico Pucci	t	Entertainment: Japanese Anime & Manga	medium	2025-06-19 04:09:15.354109+00
295	dc82fc9a-ad64-4a50-8fac-0e2c3b340ccd	6a96be88-aec5-4aba-8b78-6aa2693cfa18	In which manga did the "404 Girl" from 4chan originate from?	["Azumanga Daioh", "Lucky Star", "Yotsuba&!", "Clover"]	Yotsuba&!	Yotsuba&!	t	Entertainment: Japanese Anime & Manga	hard	2025-06-19 04:09:15.354112+00
296	dc82fc9a-ad64-4a50-8fac-0e2c3b340ccd	6a96be88-aec5-4aba-8b78-6aa2693cfa18	Which of the following films was NOT directed by Hayao Miyazaki?	["Wolf Children", "Spirited Away", "Kiki's Delivery Service", "Princess Mononoke"]	Spirited Away	Wolf Children	f	Entertainment: Japanese Anime & Manga	medium	2025-06-19 04:09:15.354113+00
297	dc82fc9a-ad64-4a50-8fac-0e2c3b340ccd	6a96be88-aec5-4aba-8b78-6aa2693cfa18	In the Overlord Anime who was Cocytus made by?	["Ulbert Alain Odle", "Warrior Takemikazuchi", "Bukubukuchagama", "Peroroncino"]	Warrior Takemikazuchi	Warrior Takemikazuchi	t	Entertainment: Japanese Anime & Manga	hard	2025-06-19 04:09:15.354114+00
298	dc82fc9a-ad64-4a50-8fac-0e2c3b340ccd	6a96be88-aec5-4aba-8b78-6aa2693cfa18	What is the name of the school in the anime and manga "Gosick"?	["St. Mary", "St. Marguerite", "St. Bernadette", "St. Augustine"]	St. Marguerite	St. Marguerite	t	Entertainment: Japanese Anime & Manga	hard	2025-06-19 04:09:15.354115+00
299	dc82fc9a-ad64-4a50-8fac-0e2c3b340ccd	6a96be88-aec5-4aba-8b78-6aa2693cfa18	Who was a voice actor for the English dubbing of HOWL'S MOVING CASTLE (2004)?	["Christian Bale", "Matt Damon", "Willem Dafoe", "Joseph Gordon-Levitt"]	Christian Bale	Christian Bale	t	Entertainment: Japanese Anime & Manga	easy	2025-06-19 04:09:15.354116+00
300	dc82fc9a-ad64-4a50-8fac-0e2c3b340ccd	6a96be88-aec5-4aba-8b78-6aa2693cfa18	Who voices the character "Reigen"  in the English dub of "Mob Psycho 100"?	["Max Mittelman", "Chris Niosi", "Kyle McCarley", "Casey Mongillo"]	Chris Niosi	Chris Niosi	t	Entertainment: Japanese Anime & Manga	medium	2025-06-19 04:09:15.354117+00
301	dc82fc9a-ad64-4a50-8fac-0e2c3b340ccd	6a96be88-aec5-4aba-8b78-6aa2693cfa18	In "Black Lagoon", what colour is Rock's tie?	["Crimson", "Dark Brown", "Black", "Teal"]	Teal	Teal	t	Entertainment: Japanese Anime & Manga	medium	2025-06-19 04:09:15.354117+00
302	dc82fc9a-ad64-4a50-8fac-0e2c3b340ccd	6a96be88-aec5-4aba-8b78-6aa2693cfa18	The character Momonga from the "Overlord" series orders his servants to call him by what name?	["Kugane Maruyama", "Yggdrasil", "Ainz Ooal Gown", "Master"]	Ainz Ooal Gown	Ainz Ooal Gown	t	Entertainment: Japanese Anime & Manga	medium	2025-06-19 04:09:15.354118+00
303	dc82fc9a-ad64-4a50-8fac-0e2c3b340ccd	6a96be88-aec5-4aba-8b78-6aa2693cfa18	In the "To Love-Ru" series, how many Trans-weapons were created?	["4", "1", "3", "2"]	3	3	t	Entertainment: Japanese Anime & Manga	medium	2025-06-19 04:09:15.354119+00
304	b7edd887-0abf-4e46-9b8e-55b134fad996	6a96be88-aec5-4aba-8b78-6aa2693cfa18	Which "Green Arrow" sidekick commonly wears a baseball cap?	["Dick Grayson", "Roy Harper", "Emiko Queen", "Black Canary"]	Roy Harper	Roy Harper	t	Entertainment: Comics	medium	2025-06-19 04:12:07.227858+00
305	b7edd887-0abf-4e46-9b8e-55b134fad996	6a96be88-aec5-4aba-8b78-6aa2693cfa18	What is Hellboy's true name?	["Right Hand of Doom", "Ogdru Jahad", "Anung Un Rama", "Azzael"]	Anung Un Rama	Anung Un Rama	t	Entertainment: Comics	medium	2025-06-19 04:12:07.227866+00
306	b7edd887-0abf-4e46-9b8e-55b134fad996	6a96be88-aec5-4aba-8b78-6aa2693cfa18	Who is the creator of the comic series "The Walking Dead"?	["Robert Crumb", "Stan Lee", "Robert Kirkman", "Malcolm Wheeler-Nicholson"]	Robert Kirkman	Robert Kirkman	t	Entertainment: Comics	easy	2025-06-19 04:12:07.227868+00
307	b7edd887-0abf-4e46-9b8e-55b134fad996	6a96be88-aec5-4aba-8b78-6aa2693cfa18	In 1978, Superman teamed up with what celebrity, to defeat an alien invasion?	["Mike Tyson", "Sylvester Stallone", "Arnold Schwarzenegger", "Muhammad Ali"]	Muhammad Ali	Muhammad Ali	t	Entertainment: Comics	hard	2025-06-19 04:12:07.227869+00
308	b7edd887-0abf-4e46-9b8e-55b134fad996	6a96be88-aec5-4aba-8b78-6aa2693cfa18	In Marvel comics, which of the following is not one of the infinity stones?	["Energy", "Soul", "Time", "Power"]	Power	Energy	f	Entertainment: Comics	medium	2025-06-19 04:12:07.227869+00
309	b7edd887-0abf-4e46-9b8e-55b134fad996	6a96be88-aec5-4aba-8b78-6aa2693cfa18	The stuffed tiger in Calvin and Hobbes is named after what philosopher?	["John Hobbes", "David Hobbes", "Thomas Hobbes", "Nathaniel Hobbes"]	Thomas Hobbes	Thomas Hobbes	t	Entertainment: Comics	medium	2025-06-19 04:12:07.22787+00
310	b7edd887-0abf-4e46-9b8e-55b134fad996	6a96be88-aec5-4aba-8b78-6aa2693cfa18	Who was the inspiration for Cuthbert Calculus in the Tintin series?	["Jacques Piccard", "Will Morris", "J. Cecil Maby", "Auguste Picard"]	Auguste Picard	Auguste Picard	t	Entertainment: Comics	medium	2025-06-19 04:12:07.227871+00
311	b7edd887-0abf-4e46-9b8e-55b134fad996	6a96be88-aec5-4aba-8b78-6aa2693cfa18	In the Homestuck Series, what is the alternate name for the Kingdom of Lights?	["Prospit", "Golden City", "No Name", "Yellow Moon"]	Prospit	Prospit	t	Entertainment: Comics	hard	2025-06-19 04:12:07.227872+00
312	b7edd887-0abf-4e46-9b8e-55b134fad996	6a96be88-aec5-4aba-8b78-6aa2693cfa18	What year was the first San Diego Comic-Con?	["2000", "1990", "1970", "1985"]	1970	1970	t	Entertainment: Comics	hard	2025-06-19 04:12:07.227873+00
313	b7edd887-0abf-4e46-9b8e-55b134fad996	6a96be88-aec5-4aba-8b78-6aa2693cfa18	In the Batman comics, by what other name is the villain Dr. Jonathan Crane known?	["Calendar Man", "Scarecrow", "Bane", "Clayface"]	Scarecrow	Scarecrow	t	Entertainment: Comics	hard	2025-06-19 04:12:07.227873+00
341	84d18272-b73a-4837-b7c7-906464d1bebf	6a96be88-aec5-4aba-8b78-6aa2693cfa18	In web design, what does CSS stand for?	["Corrective Style Sheet", "Cascading Style Sheet", "Computer Style Sheet", "Counter Strike: Source"]	Cascading Style Sheet	Cascading Style Sheet	t	Science: Computers	easy	2025-06-19 04:46:49.049173+00
342	84d18272-b73a-4837-b7c7-906464d1bebf	6a96be88-aec5-4aba-8b78-6aa2693cfa18	In "Hexadecimal", what color would be displayed from the color code? "#00FF00"?	["Blue", "Green", "Yellow", "Red"]	Yellow	Green	f	Science: Computers	easy	2025-06-19 04:46:49.049175+00
343	84d18272-b73a-4837-b7c7-906464d1bebf	6a96be88-aec5-4aba-8b78-6aa2693cfa18	If you were to code software in this language you'd only be able to type 0's and 1's.	["C++", "Python", "Binary", "JavaScript"]	Binary	Binary	t	Science: Computers	easy	2025-06-19 04:46:49.049176+00
344	8d0146b0-5c0b-4329-a7ba-8ef4229789cd	5ff9ae62-1c6f-4894-a133-adeef163e141	Which buzzword did Apple Inc. use to describe their removal of the headphone jack?	["Innovation", "Bravery", "Courage", "Revolution"]	Bravery	Courage	f	Science: Gadgets	easy	2025-06-19 05:00:23.279203+00
345	8d0146b0-5c0b-4329-a7ba-8ef4229789cd	5ff9ae62-1c6f-4894-a133-adeef163e141	What round is a classic AK-47 chambered in?	["5.56x45mm", "5.45x39mm", "7.62x39mm", "7.62x51mm"]	5.56x45mm	7.62x39mm	f	Science: Gadgets	easy	2025-06-19 05:00:23.279214+00
346	8d0146b0-5c0b-4329-a7ba-8ef4229789cd	5ff9ae62-1c6f-4894-a133-adeef163e141	When was the iPhone released?	["2007", "2005", "2006", "2004"]	2004	2007	f	Science: Gadgets	easy	2025-06-19 05:00:23.279216+00
347	8d0146b0-5c0b-4329-a7ba-8ef4229789cd	5ff9ae62-1c6f-4894-a133-adeef163e141	Which virtual assistant is developed by Amazon?	["Cortana", "Alexa", "Google Assistant", "Siri"]	Alexa	Alexa	t	Science: Gadgets	easy	2025-06-19 05:00:23.279217+00
348	8d0146b0-5c0b-4329-a7ba-8ef4229789cd	5ff9ae62-1c6f-4894-a133-adeef163e141	What is the name of a simple machine that is made up of a stiff arm that can move freely around a fixed point?	["Lever", "Pulley", "Wedge", "Screw"]	Wedge	Lever	f	Science: Gadgets	easy	2025-06-19 05:00:23.279218+00
349	8d0146b0-5c0b-4329-a7ba-8ef4229789cd	5ff9ae62-1c6f-4894-a133-adeef163e141	Which of the following is not a type of computer mouse?	["Trackball mouse", "Drum mouse", "Smoothie mouse", "Optical mouse"]	Drum mouse	Smoothie mouse	f	Science: Gadgets	easy	2025-06-19 05:00:23.27922+00
350	8d0146b0-5c0b-4329-a7ba-8ef4229789cd	5ff9ae62-1c6f-4894-a133-adeef163e141	When was the DVD invented?	["2000", "1995", "1980", "1990"]	1990	1995	f	Science: Gadgets	easy	2025-06-19 05:00:23.279222+00
351	8d0146b0-5c0b-4329-a7ba-8ef4229789cd	5ff9ae62-1c6f-4894-a133-adeef163e141	When did the CD begin to appear on the consumer market?	["1982", "1992", "1972", "1962"]	1992	1982	f	Science: Gadgets	easy	2025-06-19 05:00:23.279224+00
352	8d0146b0-5c0b-4329-a7ba-8ef4229789cd	5ff9ae62-1c6f-4894-a133-adeef163e141	Which gaming console is developed by Sony?	["Xbox", "Atari", "Nintendo Switch", "PlayStation"]	Xbox	PlayStation	f	Science: Gadgets	easy	2025-06-19 05:00:23.279225+00
353	8d0146b0-5c0b-4329-a7ba-8ef4229789cd	5ff9ae62-1c6f-4894-a133-adeef163e141	The term "battery" to describe an electrical storage device was coined by?	[" Alessandro Volta", "Benjamin Franklin", "Luigi Galvani", "Nikola Tesla"]	Luigi Galvani	Benjamin Franklin	f	Science: Gadgets	easy	2025-06-19 05:00:23.279227+00
354	f6d72f6a-c320-4e92-bf6a-a61f4bcb6116	8e3d46bf-7b38-4c25-97c7-cc74e7dee8b0	In which fast food chain can you order a Jamocha Shake?	["Arby's", "Burger King", "McDonald's", "Wendy's"]	Arby's	Arby's	t	General Knowledge	easy	2025-06-19 05:24:54.613971+00
355	f6d72f6a-c320-4e92-bf6a-a61f4bcb6116	8e3d46bf-7b38-4c25-97c7-cc74e7dee8b0	What step in cellular respiration forms ATP?	["Pyruvate Oxidation", "Oxidative Phosphorylation", "Calvin Cycle", "Glycolysis"]	Glycolysis	Oxidative Phosphorylation	f	General Knowledge	easy	2025-06-19 05:24:54.61398+00
356	f6d72f6a-c320-4e92-bf6a-a61f4bcb6116	8e3d46bf-7b38-4c25-97c7-cc74e7dee8b0	Waluigi's first appearance was in what game?	["Mario Party (N64)", "Super Smash Bros. Ultimate", "Mario Tennis 64 (N64)", "Wario Land: Super Mario Land 3"]	Mario Tennis 64 (N64)	Mario Tennis 64 (N64)	t	General Knowledge	easy	2025-06-19 05:24:54.613981+00
357	f6d72f6a-c320-4e92-bf6a-a61f4bcb6116	8e3d46bf-7b38-4c25-97c7-cc74e7dee8b0	When was the website reddit founded ?	["2008", "2005", "2004", "2006"]	2005	2005	t	General Knowledge	easy	2025-06-19 05:24:54.613982+00
358	f6d72f6a-c320-4e92-bf6a-a61f4bcb6116	8e3d46bf-7b38-4c25-97c7-cc74e7dee8b0	Which sign of the zodiac comes between Virgo and Scorpio?	["Gemini", "Taurus", "Libra", "Capricorn"]	Libra	Libra	t	General Knowledge	easy	2025-06-19 05:24:54.613983+00
359	f6d72f6a-c320-4e92-bf6a-a61f4bcb6116	8e3d46bf-7b38-4c25-97c7-cc74e7dee8b0	How tall is the Burj Khalifa?	["3,024 ft", "2,546 ft", "2,717 ft", "2,722 ft"]	2,722 ft	2,722 ft	t	General Knowledge	easy	2025-06-19 05:24:54.613984+00
360	f6d72f6a-c320-4e92-bf6a-a61f4bcb6116	8e3d46bf-7b38-4c25-97c7-cc74e7dee8b0	What alcoholic drink is made from molasses?	["Gin", "Whisky", "Vodka", "Rum"]	Rum	Rum	t	General Knowledge	easy	2025-06-19 05:24:54.613985+00
361	f6d72f6a-c320-4e92-bf6a-a61f4bcb6116	8e3d46bf-7b38-4c25-97c7-cc74e7dee8b0	What is the French word for "hat"?	[" Écharpe", " Casque", "Bonnet", "Chapeau"]	Chapeau	Chapeau	t	General Knowledge	easy	2025-06-19 05:24:54.613986+00
362	f6d72f6a-c320-4e92-bf6a-a61f4bcb6116	8e3d46bf-7b38-4c25-97c7-cc74e7dee8b0	Which of these is NOT considered to be a colour that makes up the rainbow?	["Blue", "Orange", "Pink", "Violet"]	Violet	Pink	f	General Knowledge	easy	2025-06-19 05:24:54.613987+00
363	f6d72f6a-c320-4e92-bf6a-a61f4bcb6116	8e3d46bf-7b38-4c25-97c7-cc74e7dee8b0	In Half-Life, what is the name of the alien that attaches to heads?	["Bullsquid", "Facehugger", "Headcrab", "Vortigaunt"]	Headcrab	Headcrab	t	General Knowledge	easy	2025-06-19 05:24:54.613988+00
364	8b7f7a3a-a95e-4ead-ae85-98af364b1e11	8e3d46bf-7b38-4c25-97c7-cc74e7dee8b0	What step in cellular respiration forms ATP?	["Calvin Cycle", "Oxidative Phosphorylation", "Glycolysis", "Pyruvate Oxidation"]	Glycolysis	Oxidative Phosphorylation	f	General Knowledge	easy	2025-06-19 05:27:59.662246+00
365	8b7f7a3a-a95e-4ead-ae85-98af364b1e11	8e3d46bf-7b38-4c25-97c7-cc74e7dee8b0	Where is the train station "Llanfair­pwllgwyngyll­gogery­chwyrn­drobwll­llan­tysilio­gogo­goch"?	["Czech Republic", "Denmark", "Wales", "Moldova"]	Wales	Wales	t	General Knowledge	easy	2025-06-19 05:27:59.662254+00
366	8b7f7a3a-a95e-4ead-ae85-98af364b1e11	8e3d46bf-7b38-4c25-97c7-cc74e7dee8b0	Which sign of the zodiac comes between Virgo and Scorpio?	["Gemini", "Libra", "Taurus", "Capricorn"]	Libra	Libra	t	General Knowledge	easy	2025-06-19 05:27:59.662256+00
367	8b7f7a3a-a95e-4ead-ae85-98af364b1e11	8e3d46bf-7b38-4c25-97c7-cc74e7dee8b0	What is Cynophobia the fear of?	["Dogs", "Birds", "Germs", "Flying"]	Dogs	Dogs	t	General Knowledge	easy	2025-06-19 05:27:59.662258+00
368	8b7f7a3a-a95e-4ead-ae85-98af364b1e11	8e3d46bf-7b38-4c25-97c7-cc74e7dee8b0	What is the nickname of the US state of California?	["Golden State", "Bay State", "Sunshine State", "Treasure State"]	Golden State	Golden State	t	General Knowledge	easy	2025-06-19 05:27:59.662259+00
369	8b7f7a3a-a95e-4ead-ae85-98af364b1e11	8e3d46bf-7b38-4c25-97c7-cc74e7dee8b0	Which of the following card games revolves around numbers and basic math?	["Twister", "Uno", "Go Fish", "Munchkin"]	Uno	Uno	t	General Knowledge	easy	2025-06-19 05:27:59.66226+00
370	8b7f7a3a-a95e-4ead-ae85-98af364b1e11	8e3d46bf-7b38-4c25-97c7-cc74e7dee8b0	Which language is most widely spoken in Switzerland?	["Italian", "Swiss", "German", "French"]	German	German	t	General Knowledge	easy	2025-06-19 05:27:59.662261+00
371	8b7f7a3a-a95e-4ead-ae85-98af364b1e11	8e3d46bf-7b38-4c25-97c7-cc74e7dee8b0	When one is "envious", they are said to be what color?	["Green", "Red", "Yellow", "Blue"]	Green	Green	t	General Knowledge	easy	2025-06-19 05:27:59.662262+00
372	8b7f7a3a-a95e-4ead-ae85-98af364b1e11	8e3d46bf-7b38-4c25-97c7-cc74e7dee8b0	What are Panama hats made out of?	["Flax", "Hemp", "Straw", "Silk"]	Flax	Straw	f	General Knowledge	easy	2025-06-19 05:27:59.662263+00
373	8b7f7a3a-a95e-4ead-ae85-98af364b1e11	8e3d46bf-7b38-4c25-97c7-cc74e7dee8b0	What is Tasmania?	["A flavor of Ben and Jerry's ice-cream", "A Psychological Disorder", "An Australian State", "The Name of a Warner Brothers Cartoon Character"]	An Australian State	An Australian State	t	General Knowledge	easy	2025-06-19 05:27:59.662264+00
374	d8fe1928-f390-42c8-863d-242792c4bd79	01e1003d-da05-4156-bfa4-b152c2a10c09	The name of technology company HP stands for what?	["Husker-Pollosk", "Hewlett-Packard", "Howard Packmann", "Hellman-Pohl"]	Howard Packmann	Hewlett-Packard	f	Science: Computers	medium	2025-06-19 06:17:13.951167+00
375	d8fe1928-f390-42c8-863d-242792c4bd79	01e1003d-da05-4156-bfa4-b152c2a10c09	The character Plum from "No Game No Life" is of what race?	["Flügel", "Dhampir", "Imanity", "Seiren"]	Flügel	Dhampir	f	Entertainment: Japanese Anime & Manga	medium	2025-06-19 06:17:13.951176+00
376	d8fe1928-f390-42c8-863d-242792c4bd79	01e1003d-da05-4156-bfa4-b152c2a10c09	What does RAID stand for?	["Randomized Abstract Identification Description", "Rapid Access for Indexed Devices", "Range of Applications with Identical Designs", "Redundant Array of Independent Disks"]	Randomized Abstract Identification Description	Redundant Array of Independent Disks	f	Science: Computers	medium	2025-06-19 06:17:13.951178+00
377	d8fe1928-f390-42c8-863d-242792c4bd79	01e1003d-da05-4156-bfa4-b152c2a10c09	When was the first episode of Soul Eater released?	["2008", "2003", "2011", "2005"]	2005	2008	f	Entertainment: Japanese Anime & Manga	medium	2025-06-19 06:17:13.951179+00
378	d8fe1928-f390-42c8-863d-242792c4bd79	01e1003d-da05-4156-bfa4-b152c2a10c09	Generally, which component of a computer draws the most power?	["Hard Drive", "Processor", "Video Card", "Power Supply"]	Power Supply	Video Card	f	Science: Computers	medium	2025-06-19 06:17:13.95118+00
379	2ead92d7-2acd-400b-8e6c-5e479b233df0	01e1003d-da05-4156-bfa4-b152c2a10c09	What animation studio produced "Gurren Lagann"?	["Gainax", "A-1 Pictures", "Kyoto Animation", "Pierrot"]	Kyoto Animation	Gainax	f	Entertainment: Japanese Anime & Manga	easy	2025-06-19 06:19:32.861533+00
380	2ead92d7-2acd-400b-8e6c-5e479b233df0	01e1003d-da05-4156-bfa4-b152c2a10c09	Which Pokémon and it's evolutions were banned from appearing in a main role after the Episode 38 Incident?	["The Porygon Line", "The Pikachu Line", "The Magby Line", "The Elekid Line"]	The Elekid Line	The Porygon Line	f	Entertainment: Japanese Anime & Manga	easy	2025-06-19 06:19:32.861538+00
381	2ead92d7-2acd-400b-8e6c-5e479b233df0	01e1003d-da05-4156-bfa4-b152c2a10c09	In "Future Diary", what is the name of Yuno Gasai's Phone Diary?	["Murder Diary", "Justice Diary ", "Yukiteru Diary", "Escape Diary "]	Murder Diary	Yukiteru Diary	f	Entertainment: Japanese Anime & Manga	easy	2025-06-19 06:19:32.861539+00
382	2ead92d7-2acd-400b-8e6c-5e479b233df0	01e1003d-da05-4156-bfa4-b152c2a10c09	What is the last name of Edward and Alphonse in the Fullmetal Alchemist series.	["Elric", "Elwood", "Eliek", "Ellis"]	Elric	Elric	t	Entertainment: Japanese Anime & Manga	easy	2025-06-19 06:19:32.86154+00
383	2ead92d7-2acd-400b-8e6c-5e479b233df0	01e1003d-da05-4156-bfa4-b152c2a10c09	Who is the true moon princess in Sailor Moon?	["Sailor Mars", "Sailor Jupiter", "Sailor Venus", "Sailor Moon"]	Sailor Moon	Sailor Moon	t	Entertainment: Japanese Anime & Manga	easy	2025-06-19 06:19:32.861541+00
384	2ead92d7-2acd-400b-8e6c-5e479b233df0	01e1003d-da05-4156-bfa4-b152c2a10c09	What is the age of Ash Ketchum in Pokemon when he starts his journey?	["10", "9", "12", "11"]	9	10	f	Entertainment: Japanese Anime & Manga	easy	2025-06-19 06:19:32.861542+00
385	2ead92d7-2acd-400b-8e6c-5e479b233df0	01e1003d-da05-4156-bfa4-b152c2a10c09	What was Ash Ketchum's second Pokemon?	["Caterpie", "Pikachu", "Pidgey", "Charmander"]	Pikachu	Caterpie	f	Entertainment: Japanese Anime & Manga	easy	2025-06-19 06:19:32.861543+00
386	2ead92d7-2acd-400b-8e6c-5e479b233df0	01e1003d-da05-4156-bfa4-b152c2a10c09	What year did "Attack on Titan" first air?	["2014", "2012", "2015", "2013"]	2015	2013	f	Entertainment: Japanese Anime & Manga	easy	2025-06-19 06:19:32.861543+00
387	2ead92d7-2acd-400b-8e6c-5e479b233df0	01e1003d-da05-4156-bfa4-b152c2a10c09	What is the name of Funny Valentine's stand in Jojo's Bizarre Adventure Part 7, Steel Ball Run?	["Civil War", "Dirty Deeds Done Dirt Cheap", "Filthy Acts Done For A Reasonable Price", "God Bless The USA"]	Filthy Acts Done For A Reasonable Price	Dirty Deeds Done Dirt Cheap	f	Entertainment: Japanese Anime & Manga	easy	2025-06-19 06:19:32.861544+00
388	2ead92d7-2acd-400b-8e6c-5e479b233df0	01e1003d-da05-4156-bfa4-b152c2a10c09	What is the name of the stuffed lion in Bleach?	["Jo", "Chad", "Kon", "Urdiu"]	Jo	Kon	f	Entertainment: Japanese Anime & Manga	easy	2025-06-19 06:19:32.861545+00
389	5575394d-c096-4ad8-ab4f-b850fbc0cab9	b7496375-ca27-487a-a9a0-33fb6e1f14c8	What is the equation for the area of a sphere?	["(4/3)πr^3", "(1/3)πhr^2", "πr^4", "4πr^2"]	(1/3)πhr^2	(4/3)πr^3	f	Science: Mathematics	easy	2025-06-19 07:16:02.501357+00
390	5575394d-c096-4ad8-ab4f-b850fbc0cab9	b7496375-ca27-487a-a9a0-33fb6e1f14c8	What is the symbol for Displacement?	["Δr", "dr", "r", "Dp"]	Δr	Δr	t	Science: Mathematics	easy	2025-06-19 07:16:02.501366+00
391	5575394d-c096-4ad8-ab4f-b850fbc0cab9	b7496375-ca27-487a-a9a0-33fb6e1f14c8	What's the square root of 49?	["4", "12", "9", "7"]	7	7	t	Science: Mathematics	easy	2025-06-19 07:16:02.501368+00
392	5575394d-c096-4ad8-ab4f-b850fbc0cab9	b7496375-ca27-487a-a9a0-33fb6e1f14c8	How many sides does a trapezium have?	["3", "4", "5", "6"]	4	4	t	Science: Mathematics	easy	2025-06-19 07:16:02.501369+00
393	5575394d-c096-4ad8-ab4f-b850fbc0cab9	b7496375-ca27-487a-a9a0-33fb6e1f14c8	What prime number comes next after 19?	["23", "25", "27", "21"]	27	23	f	Science: Mathematics	easy	2025-06-19 07:16:02.50137+00
394	5575394d-c096-4ad8-ab4f-b850fbc0cab9	b7496375-ca27-487a-a9a0-33fb6e1f14c8	In Roman Numerals, what does XL equate to?	["40", "15", "60", "90"]	40	40	t	Science: Mathematics	easy	2025-06-19 07:16:02.501372+00
395	5575394d-c096-4ad8-ab4f-b850fbc0cab9	b7496375-ca27-487a-a9a0-33fb6e1f14c8	The metric prefix "atto-" makes a measurement how much smaller than the base unit?	["One Billionth", "One Quintillionth", "One Quadrillionth", "One Septillionth"]	One Quadrillionth	One Quintillionth	f	Science: Mathematics	easy	2025-06-19 07:16:02.501372+00
396	5575394d-c096-4ad8-ab4f-b850fbc0cab9	b7496375-ca27-487a-a9a0-33fb6e1f14c8	How many sides does a heptagon have?	["6", "5", "7", "8"]	8	7	f	Science: Mathematics	easy	2025-06-19 07:16:02.501375+00
397	5575394d-c096-4ad8-ab4f-b850fbc0cab9	b7496375-ca27-487a-a9a0-33fb6e1f14c8	What type of angle is greater than 90°?	["Acute", "Right", "Straight", "Obtuse"]	Right	Obtuse	f	Science: Mathematics	easy	2025-06-19 07:16:02.501376+00
398	5575394d-c096-4ad8-ab4f-b850fbc0cab9	b7496375-ca27-487a-a9a0-33fb6e1f14c8	What is the correct order of operations for solving equations?	["Parentheses, Exponents, Addition, Substraction, Multiplication, Division", "The order in which the operations are written.", "Parentheses, Exponents, Multiplication, Division, Addition, Subtraction", "Addition, Multiplication, Division, Subtraction, Addition, Parentheses"]	The order in which the operations are written.	Parentheses, Exponents, Multiplication, Division, Addition, Subtraction	f	Science: Mathematics	easy	2025-06-19 07:16:02.501377+00
399	86c9dab4-8981-4684-82b1-be5629d3711b	b7496375-ca27-487a-a9a0-33fb6e1f14c8	Talos, the mythical giant bronze man, was the protector of which island?	["Sardinia", "Cyprus", "Crete", "Sicily"]	Crete	Crete	t	Mythology	hard	2025-06-19 07:39:29.505209+00
400	86c9dab4-8981-4684-82b1-be5629d3711b	b7496375-ca27-487a-a9a0-33fb6e1f14c8	This Greek mythological figure is the god/goddess of battle strategy (among other things).	["Ares", "Athena", "Artemis", "Apollo"]	Athena	Athena	t	Mythology	medium	2025-06-19 07:39:29.505217+00
401	86c9dab4-8981-4684-82b1-be5629d3711b	b7496375-ca27-487a-a9a0-33fb6e1f14c8	What was the punishment for Sysiphus's craftiness?	["Cursed to roll a boulder up a hill for eternity.", "Tied to a boulder for eternity, being pecked by birds.", "Standing in a lake filled with water he could not drink.", "To fell a tree that regenerated after every axe swing."]	Cursed to roll a boulder up a hill for eternity.	Cursed to roll a boulder up a hill for eternity.	t	Mythology	hard	2025-06-19 07:39:29.505218+00
402	86c9dab4-8981-4684-82b1-be5629d3711b	b7496375-ca27-487a-a9a0-33fb6e1f14c8	The Nike apparel and footwear brand takes it's name from the Greek goddess of what?	["Strength", "Courage", "Victory", "Honor"]	Victory	Victory	t	Mythology	easy	2025-06-19 07:39:29.505219+00
403	86c9dab4-8981-4684-82b1-be5629d3711b	b7496375-ca27-487a-a9a0-33fb6e1f14c8	According to Algonquian folklore, how does one transform into a Wendigo?	["Performing a ritual involving murder.", "Participating in cannibalism.", "Excessive mutilation of animal corpses.", "Drinking the blood of many slain animals."]	Participating in cannibalism.	Participating in cannibalism.	t	Mythology	hard	2025-06-19 07:39:29.50522+00
404	86c9dab4-8981-4684-82b1-be5629d3711b	b7496375-ca27-487a-a9a0-33fb6e1f14c8	Nidhogg is a mythical creature from what mythology?	["Greek", "Egyptian", "Norse", "Hindu"]	Norse	Norse	t	Mythology	hard	2025-06-19 07:39:29.505221+00
405	86c9dab4-8981-4684-82b1-be5629d3711b	b7496375-ca27-487a-a9a0-33fb6e1f14c8	The Maori hold that which island nation was founded by Kupe, who discovered it under a long white cloud?	["Hawaii", "New Zealand", "Fiji", "Vanuatu"]	New Zealand	New Zealand	t	Mythology	medium	2025-06-19 07:39:29.505222+00
472	d918d4e4-50e2-4f69-80a4-781d4758d080	b7496375-ca27-487a-a9a0-33fb6e1f14c8	The Space Needle is located in which city?	["Seattle", "Vancouver", "Toronto", "Los Angles"]	Los Angles	Seattle	f	Geography	easy	2025-06-19 11:53:21.707825+00
406	86c9dab4-8981-4684-82b1-be5629d3711b	b7496375-ca27-487a-a9a0-33fb6e1f14c8	In Greek mythology, Persephone must return to the underworld because she had eaten what kind of seeds?	["Fig", "Orange", "Sunflower", "Pomegranate"]	Pomegranate	Pomegranate	t	Mythology	medium	2025-06-19 07:39:29.505223+00
407	86c9dab4-8981-4684-82b1-be5629d3711b	b7496375-ca27-487a-a9a0-33fb6e1f14c8	Which figure from Greek mythology traveled to the underworld to return his wife Eurydice to the land of the living?	["Perseus", "Daedalus", "Orpheus", "Hercules"]	Orpheus	Orpheus	t	Mythology	easy	2025-06-19 07:39:29.505224+00
408	86c9dab4-8981-4684-82b1-be5629d3711b	b7496375-ca27-487a-a9a0-33fb6e1f14c8	What is the name of the Greek god of peaceful deaths?	["Moros", "Hades", "Tartarus", "Thanatos"]	Thanatos	Thanatos	t	Mythology	medium	2025-06-19 07:39:29.505225+00
409	4921ec34-b970-4e9d-b850-5c05999ad4e0	b7496375-ca27-487a-a9a0-33fb6e1f14c8	What is the scientific name for modern day humans?	["Homo Sapiens", "Homo Ergaster", "Homo Erectus", "Homo Neanderthalensis"]	Homo Sapiens	Homo Sapiens	t	Animals	easy	2025-06-19 11:22:32.921844+00
410	4921ec34-b970-4e9d-b850-5c05999ad4e0	b7496375-ca27-487a-a9a0-33fb6e1f14c8	What is Grumpy Cat's real name?	["Tardar Sauce", "Minnie", "Broccoli", "Sauce"]	Broccoli	Tardar Sauce	f	Animals	easy	2025-06-19 11:22:32.92185+00
411	4921ec34-b970-4e9d-b850-5c05999ad4e0	b7496375-ca27-487a-a9a0-33fb6e1f14c8	The Kākāpō is a large, flightless, nocturnal parrot native to which country?	["Madagascar", "South Africa", "New Zealand", "Australia"]	South Africa	New Zealand	f	Animals	easy	2025-06-19 11:22:32.921853+00
412	4921ec34-b970-4e9d-b850-5c05999ad4e0	b7496375-ca27-487a-a9a0-33fb6e1f14c8	Snakes and lizards are known to flick their tongue, this behavior is to?	["Threaten other species", "Capture scent particles", "Taste the sweet air", "Attract female mates"]	Threaten other species	Capture scent particles	f	Animals	easy	2025-06-19 11:22:32.921855+00
413	4921ec34-b970-4e9d-b850-5c05999ad4e0	b7496375-ca27-487a-a9a0-33fb6e1f14c8	What do you call a baby bat?	["Kid", "Chick", "Cub", "Pup"]	Pup	Pup	t	Animals	easy	2025-06-19 11:22:32.921856+00
414	4921ec34-b970-4e9d-b850-5c05999ad4e0	b7496375-ca27-487a-a9a0-33fb6e1f14c8	By definition, where does an abyssopelagic animal live?	["On top of a mountain", "Inside a tree", "At the bottom of the ocean", "In the desert"]	Inside a tree	At the bottom of the ocean	f	Animals	easy	2025-06-19 11:22:32.921857+00
415	4921ec34-b970-4e9d-b850-5c05999ad4e0	b7496375-ca27-487a-a9a0-33fb6e1f14c8	What colour is the female blackbird?	["White", "Yellow", "Black", "Brown"]	White	Brown	f	Animals	easy	2025-06-19 11:22:32.921858+00
416	4921ec34-b970-4e9d-b850-5c05999ad4e0	b7496375-ca27-487a-a9a0-33fb6e1f14c8	What is the name of a rabbit's abode?	["Burrow", "Nest", "Den", "Dray"]	Den	Burrow	f	Animals	easy	2025-06-19 11:22:32.921859+00
417	4921ec34-b970-4e9d-b850-5c05999ad4e0	b7496375-ca27-487a-a9a0-33fb6e1f14c8	Hippocampus is the Latin name for which marine creature?	["Whale", "Dolphin", "Seahorse", "Octopus"]	Dolphin	Seahorse	f	Animals	easy	2025-06-19 11:22:32.921861+00
418	4921ec34-b970-4e9d-b850-5c05999ad4e0	b7496375-ca27-487a-a9a0-33fb6e1f14c8	How many legs do butterflies have?	["0", "6", "2", "4"]	0	6	f	Animals	easy	2025-06-19 11:22:32.921861+00
419	ec5ea9ca-be5b-4c93-90c1-6d9b9713cf0d	b7496375-ca27-487a-a9a0-33fb6e1f14c8	What is Grumpy Cat's real name?	["Sauce", "Minnie", "Tardar Sauce", "Broccoli"]	Tardar Sauce	Tardar Sauce	t	Animals	easy	2025-06-19 11:23:08.05823+00
420	ec5ea9ca-be5b-4c93-90c1-6d9b9713cf0d	b7496375-ca27-487a-a9a0-33fb6e1f14c8	What type of animal is a natterjack?	["Fish", "Toad", "Bird", "Insect"]	Fish	Toad	f	Animals	medium	2025-06-19 11:23:08.058245+00
421	ec5ea9ca-be5b-4c93-90c1-6d9b9713cf0d	b7496375-ca27-487a-a9a0-33fb6e1f14c8	What was the name of the Ethiopian Wolf before they knew it was related to wolves?	["Canis Simiensis", "Amharic Fox", "Ethiopian Coyote", "Simien Jackel"]	Amharic Fox	Simien Jackel	f	Animals	hard	2025-06-19 11:23:08.058247+00
422	ec5ea9ca-be5b-4c93-90c1-6d9b9713cf0d	b7496375-ca27-487a-a9a0-33fb6e1f14c8	What scientific family does the Aardwolf belong to?	["Hyaenidae", "Eupleridae", "Felidae", "Canidae"]	Felidae	Hyaenidae	f	Animals	hard	2025-06-19 11:23:08.058248+00
423	ec5ea9ca-be5b-4c93-90c1-6d9b9713cf0d	b7496375-ca27-487a-a9a0-33fb6e1f14c8	Which of these animals is NOT a lizard?	["Tuatara", "Gila Monster", "Green Iguana", "Komodo Dragon"]	Tuatara	Tuatara	t	Animals	hard	2025-06-19 11:23:08.05825+00
424	ec5ea9ca-be5b-4c93-90c1-6d9b9713cf0d	b7496375-ca27-487a-a9a0-33fb6e1f14c8	How many teeth does an adult rabbit have?	["30", "26", "24", "28"]	28	28	t	Animals	easy	2025-06-19 11:23:08.058251+00
425	ec5ea9ca-be5b-4c93-90c1-6d9b9713cf0d	b7496375-ca27-487a-a9a0-33fb6e1f14c8	A carnivorous animal eats flesh, what does a nucivorous animal eat?	["Seaweed", "Fruit", "Nothing", "Nuts"]	Fruit	Nuts	f	Animals	medium	2025-06-19 11:23:08.058252+00
426	ec5ea9ca-be5b-4c93-90c1-6d9b9713cf0d	b7496375-ca27-487a-a9a0-33fb6e1f14c8	By definition, where does an abyssopelagic animal live?	["Inside a tree", "At the bottom of the ocean", "On top of a mountain", "In the desert"]	On top of a mountain	At the bottom of the ocean	f	Animals	easy	2025-06-19 11:23:08.058253+00
427	ec5ea9ca-be5b-4c93-90c1-6d9b9713cf0d	b7496375-ca27-487a-a9a0-33fb6e1f14c8	What is the Gray Wolf's scientific name?	["Canis Aureus", "Canis Latrans", "Canis Lupus Lycaon", "Canis Lupus"]	Canis Aureus	Canis Lupus	f	Animals	hard	2025-06-19 11:23:08.058255+00
428	ec5ea9ca-be5b-4c93-90c1-6d9b9713cf0d	b7496375-ca27-487a-a9a0-33fb6e1f14c8	What is the name of a rabbit's abode?	["Den", "Dray", "Nest", "Burrow"]	Nest	Burrow	f	Animals	easy	2025-06-19 11:23:08.058256+00
429	fd0bb875-7103-422e-bbe7-388dad60f59f	b7496375-ca27-487a-a9a0-33fb6e1f14c8	Which player holds the NHL record of 2,857 points?	["Gordie Howe", "Mario Lemieux ", "Wayne Gretzky", "Sidney Crosby"]	Wayne Gretzky	Wayne Gretzky	t	Sports	easy	2025-06-19 11:24:25.434739+00
430	fd0bb875-7103-422e-bbe7-388dad60f59f	b7496375-ca27-487a-a9a0-33fb6e1f14c8	Which team has won the most Stanley Cups in the NHL?	["Montreal Canadians", "Detroit Red Wings", "Chicago Blackhawks", "Toronto Maple Leafs"]	Detroit Red Wings	Montreal Canadians	f	Sports	easy	2025-06-19 11:24:25.434745+00
431	fd0bb875-7103-422e-bbe7-388dad60f59f	b7496375-ca27-487a-a9a0-33fb6e1f14c8	Which boxer was banned for taking a bite out of Evander Holyfield's ear in 1997?	["Mike Tyson", "Lennox Lewis", "Evander Holyfield", "Roy Jones Jr."]	Evander Holyfield	Mike Tyson	f	Sports	easy	2025-06-19 11:24:25.434747+00
432	fd0bb875-7103-422e-bbe7-388dad60f59f	b7496375-ca27-487a-a9a0-33fb6e1f14c8	Who won the 2016 Formula 1 World Driver's Championship?	["Max Verstappen", "Nico Rosberg", "Lewis Hamilton", "Kimi Raikkonen"]	Nico Rosberg	Nico Rosberg	t	Sports	easy	2025-06-19 11:24:25.434748+00
433	fd0bb875-7103-422e-bbe7-388dad60f59f	b7496375-ca27-487a-a9a0-33fb6e1f14c8	Who won the 2017 Formula One World Drivers' Championship?	["Lewis Hamilton", "Sebastian Vettel", "Nico Rosberg", "Max Verstappen"]	Max Verstappen	Lewis Hamilton	f	Sports	easy	2025-06-19 11:24:25.434749+00
434	fd0bb875-7103-422e-bbe7-388dad60f59f	b7496375-ca27-487a-a9a0-33fb6e1f14c8	How many players are there in an association football/soccer team?	["10", "8", "9", "11"]	9	11	f	Sports	easy	2025-06-19 11:24:25.43475+00
435	fd0bb875-7103-422e-bbe7-388dad60f59f	b7496375-ca27-487a-a9a0-33fb6e1f14c8	The Rio 2016 Summer Olympics held it's closing ceremony on what date?	["August 21", "August 17", "August 19", "August 23"]	August 17	August 21	f	Sports	easy	2025-06-19 11:24:25.434751+00
436	fd0bb875-7103-422e-bbe7-388dad60f59f	b7496375-ca27-487a-a9a0-33fb6e1f14c8	Who won the UEFA Champions League in 2017?	["Real Madrid C.F.", "AS Monaco FC", "Atletico Madrid", "Juventus F.C."]	Real Madrid C.F.	Real Madrid C.F.	t	Sports	easy	2025-06-19 11:24:25.434752+00
437	fd0bb875-7103-422e-bbe7-388dad60f59f	b7496375-ca27-487a-a9a0-33fb6e1f14c8	Which two teams played in Super Bowl XLII?	["The Green Bay Packers & The Pittsburgh Steelers", "The New York Giants & The New England Patriots", "The Philadelphia Eagles & The New England Patriots", "The Seattle Seahawks & The Denver Broncos"]	The Philadelphia Eagles & The New England Patriots	The New York Giants & The New England Patriots	f	Sports	easy	2025-06-19 11:24:25.434753+00
438	fd0bb875-7103-422e-bbe7-388dad60f59f	b7496375-ca27-487a-a9a0-33fb6e1f14c8	Which country hosted the 2020 Summer Olympics?	["Japan", "Australia", "China", "Germany"]	Germany	Japan	f	Sports	easy	2025-06-19 11:24:25.434754+00
439	c715cc4b-4c82-4a8a-b61d-b893a6302345	8e3d46bf-7b38-4c25-97c7-cc74e7dee8b0	When did the website "Facebook" launch?	["2005", "2003", "2004", "2006"]	2005	2004	f	General Knowledge	medium	2025-06-19 11:28:27.041242+00
473	d918d4e4-50e2-4f69-80a4-781d4758d080	b7496375-ca27-487a-a9a0-33fb6e1f14c8	What is Laos?	["Region", "Country", "City", "River"]	Country	Country	t	Geography	easy	2025-06-19 11:53:21.707827+00
440	c715cc4b-4c82-4a8a-b61d-b893a6302345	8e3d46bf-7b38-4c25-97c7-cc74e7dee8b0	What was Mountain Dew's original slogan?	["Give Me A Dew", "Get' that barefoot feelin' drinkin' Mountain Dew", "Yahoo! Mountain Dew... It'll tickle your innards!", "Do The Dew"]	Get' that barefoot feelin' drinkin' Mountain Dew	Yahoo! Mountain Dew... It'll tickle your innards!	f	General Knowledge	medium	2025-06-19 11:28:27.041248+00
441	c715cc4b-4c82-4a8a-b61d-b893a6302345	8e3d46bf-7b38-4c25-97c7-cc74e7dee8b0	Which of these fast-food chains is NOT mainly known to sell pizza?	["Domino's", "Papa John's", "Wendy's", "Little Caesars"]	Wendy's	Wendy's	t	General Knowledge	easy	2025-06-19 11:28:27.041249+00
442	c715cc4b-4c82-4a8a-b61d-b893a6302345	8e3d46bf-7b38-4c25-97c7-cc74e7dee8b0	Chartreuse is a color between yellow and what?	["Purple", "Black", "Red", "Green"]	Black	Green	f	General Knowledge	hard	2025-06-19 11:28:27.04125+00
443	c715cc4b-4c82-4a8a-b61d-b893a6302345	8e3d46bf-7b38-4c25-97c7-cc74e7dee8b0	What does VR stand for?	["Very Real", "Visual Recognition", "Voice Recognition", "Virtual Reality"]	Virtual Reality	Virtual Reality	t	General Knowledge	easy	2025-06-19 11:28:27.041251+00
444	c715cc4b-4c82-4a8a-b61d-b893a6302345	8e3d46bf-7b38-4c25-97c7-cc74e7dee8b0	Nephelococcygia is the practice of doing what?	["Sleeping with your eyes open", "Finding shapes in clouds", "Breaking glass with your voice", "Swimming in freezing water"]	Finding shapes in clouds	Finding shapes in clouds	t	General Knowledge	hard	2025-06-19 11:28:27.041252+00
445	c715cc4b-4c82-4a8a-b61d-b893a6302345	8e3d46bf-7b38-4c25-97c7-cc74e7dee8b0	In a 1994 CBS interview, Microsoft co-founder Bill Gates performed what unusual trick on camera?	["Jumping over an office chair", "Typing on a keyboard during a handstand", "Jumping backwards over a desk", "Standing on his head"]	Jumping backwards over a desk	Jumping over an office chair	f	General Knowledge	medium	2025-06-19 11:28:27.041253+00
446	c715cc4b-4c82-4a8a-b61d-b893a6302345	8e3d46bf-7b38-4c25-97c7-cc74e7dee8b0	What geometric shape is generally used for stop signs?	["Circle", "Octagon", "Triangle", "Hexagon"]	Octagon	Octagon	t	General Knowledge	easy	2025-06-19 11:28:27.041253+00
447	c715cc4b-4c82-4a8a-b61d-b893a6302345	8e3d46bf-7b38-4c25-97c7-cc74e7dee8b0	In ancient Greece, if your job were a "hippeus" which of these would you own?	["Boat", "Guitar", "Weave", "Horse"]	Weave	Horse	f	General Knowledge	medium	2025-06-19 11:28:27.041254+00
448	c715cc4b-4c82-4a8a-b61d-b893a6302345	8e3d46bf-7b38-4c25-97c7-cc74e7dee8b0	Who founded the Khan Academy?	["Adel Khan", "Kitt Khan", "Sal Khan", "Ben Khan"]	Ben Khan	Sal Khan	f	General Knowledge	hard	2025-06-19 11:28:27.041255+00
449	101780f1-5613-46c4-88e4-5494df98cd08	b7496375-ca27-487a-a9a0-33fb6e1f14c8	What was James Coburn's last film role before his death?	["Texas Rangers", "Snow Dogs", "American Gun", "Monsters Inc"]	Snow Dogs	American Gun	f	Celebrities	easy	2025-06-19 11:39:38.580669+00
450	101780f1-5613-46c4-88e4-5494df98cd08	b7496375-ca27-487a-a9a0-33fb6e1f14c8	Neil Hamburger is played by which comedian?	["Nathan Fielder", "Todd Glass", "Gregg Turkington", "Tim Heidecker"]	Tim Heidecker	Gregg Turkington	f	Celebrities	easy	2025-06-19 11:39:38.580673+00
451	101780f1-5613-46c4-88e4-5494df98cd08	b7496375-ca27-487a-a9a0-33fb6e1f14c8	What does film maker Dan Bell typically focus his films on?	["Historic Landmarks", "Abandoned Buildings and Dead Malls", "Action Films", "Documentaries "]	Abandoned Buildings and Dead Malls	Abandoned Buildings and Dead Malls	t	Celebrities	easy	2025-06-19 11:39:38.580674+00
452	101780f1-5613-46c4-88e4-5494df98cd08	b7496375-ca27-487a-a9a0-33fb6e1f14c8	By what name is Carlos Estevez better known? 	["Bruno Mars", "Ricky Martin", "Joaquin Phoenix", "Charlie Sheen"]	Bruno Mars	Charlie Sheen	f	Celebrities	easy	2025-06-19 11:39:38.580675+00
453	101780f1-5613-46c4-88e4-5494df98cd08	b7496375-ca27-487a-a9a0-33fb6e1f14c8	Aubrey Graham is better known as	["Travis Scott", "Lil Wayne", "Drake", "2 Chainz"]	Drake	Drake	t	Celebrities	easy	2025-06-19 11:39:38.580676+00
454	101780f1-5613-46c4-88e4-5494df98cd08	b7496375-ca27-487a-a9a0-33fb6e1f14c8	Named after a character he played in a 1969 film, what is the name of the ski resort in Utah that Robert Redford bought in 1968?	["Booker", "Sundance", "Turner", "Woodward"]	Sundance	Sundance	t	Celebrities	easy	2025-06-19 11:39:38.580677+00
455	101780f1-5613-46c4-88e4-5494df98cd08	b7496375-ca27-487a-a9a0-33fb6e1f14c8	Gwyneth Paltrow has a daughter named...?	["Lily", "Apple", "Dakota", "French"]	French	Apple	f	Celebrities	easy	2025-06-19 11:39:38.580678+00
456	101780f1-5613-46c4-88e4-5494df98cd08	b7496375-ca27-487a-a9a0-33fb6e1f14c8	What was the cause of Marilyn Monroes suicide?	["House Fire", "Gunshot", "Drug Overdose", "Knife Attack"]	Gunshot	Drug Overdose	f	Celebrities	easy	2025-06-19 11:39:38.580678+00
457	101780f1-5613-46c4-88e4-5494df98cd08	b7496375-ca27-487a-a9a0-33fb6e1f14c8	Which actress married Michael Douglas in 2000?	["Catherine Zeta-Jones", "Ruth Jones", "Sara Sugarman", "Pam Ferris"]	Catherine Zeta-Jones	Catherine Zeta-Jones	t	Celebrities	easy	2025-06-19 11:39:38.580679+00
458	101780f1-5613-46c4-88e4-5494df98cd08	b7496375-ca27-487a-a9a0-33fb6e1f14c8	By which name is Ramon Estevez better known as?	["Martin Sheen", "Ramon Sheen", "Emilio Estevez", "Charlie Sheen"]	Charlie Sheen	Martin Sheen	f	Celebrities	easy	2025-06-19 11:39:38.58068+00
459	5ef46980-a6e4-4ad8-ba13-ddce448d64d9	b7496375-ca27-487a-a9a0-33fb6e1f14c8	Who painted the Mona Lisa?	["Claude Monet", "Pablo Picasso", "Vincent van Gogh", "Leonardo da Vinci"]	Pablo Picasso	Leonardo da Vinci	f	Art	easy	2025-06-19 11:50:02.714133+00
460	5ef46980-a6e4-4ad8-ba13-ddce448d64d9	b7496375-ca27-487a-a9a0-33fb6e1f14c8	Which artist painted the late 15th century mural 'The Last Supper'?	["Paolo Uccello", "Piero della Francesca", "Luca Pacioli", "Leonardo da Vinci"]	Paolo Uccello	Leonardo da Vinci	f	Art	easy	2025-06-19 11:50:02.714156+00
461	5ef46980-a6e4-4ad8-ba13-ddce448d64d9	b7496375-ca27-487a-a9a0-33fb6e1f14c8	What is a fundamental element of the Gothic style of architecture?	["pointed arch", "façades surmounted by a pediment ", "internal frescoes", "coffered ceilings"]	coffered ceilings	pointed arch	f	Art	easy	2025-06-19 11:50:02.714158+00
462	5ef46980-a6e4-4ad8-ba13-ddce448d64d9	b7496375-ca27-487a-a9a0-33fb6e1f14c8	Who painted "The Starry Night"?	["Claude Monet", "Pablo Picasso", "Vincent van Gogh", "Edvard Munch"]	Vincent van Gogh	Vincent van Gogh	t	Art	easy	2025-06-19 11:50:02.714159+00
463	5ef46980-a6e4-4ad8-ba13-ddce448d64d9	b7496375-ca27-487a-a9a0-33fb6e1f14c8	What is the name of the Japanese art of folding paper into decorative shapes and figures?	["Sumi-e", "Ukiyo-e", "Origami", "Haiku"]	Ukiyo-e	Origami	f	Art	easy	2025-06-19 11:50:02.714161+00
464	5ef46980-a6e4-4ad8-ba13-ddce448d64d9	b7496375-ca27-487a-a9a0-33fb6e1f14c8	Who sculpted the statue of David?	["Gian Lorenzo Bernini", "Auguste Rodin", "Michelangelo", "Donatello"]	Michelangelo	Michelangelo	t	Art	easy	2025-06-19 11:50:02.714162+00
465	5ef46980-a6e4-4ad8-ba13-ddce448d64d9	b7496375-ca27-487a-a9a0-33fb6e1f14c8	Who painted the Sistine Chapel?	["Pablo Picasso", "Raphael", "Michelangelo", "Leonardo da Vinci"]	Pablo Picasso	Michelangelo	f	Art	easy	2025-06-19 11:50:02.714163+00
466	5ef46980-a6e4-4ad8-ba13-ddce448d64d9	b7496375-ca27-487a-a9a0-33fb6e1f14c8	Which painting was not made by Vincent Van Gogh?	["Starry Night", "Café Terrace at Night", "Bedroom In Arles", "The Ninth Wave"]	Bedroom In Arles	The Ninth Wave	f	Art	easy	2025-06-19 11:50:02.714164+00
467	5ef46980-a6e4-4ad8-ba13-ddce448d64d9	b7496375-ca27-487a-a9a0-33fb6e1f14c8	What is the world's oldest known piece of fiction?	["Code of Hammurabi", "Epic of Gilgamesh", "Rosetta Stone", "Papyrus of Ani"]	Epic of Gilgamesh	Epic of Gilgamesh	t	Art	easy	2025-06-19 11:50:02.714165+00
468	5ef46980-a6e4-4ad8-ba13-ddce448d64d9	b7496375-ca27-487a-a9a0-33fb6e1f14c8	Who painted the biblical fresco The Creation of Adam?	["Caravaggio", "Leonardo da Vinci", "Michelangelo", "Rembrandt"]	Caravaggio	Michelangelo	f	Art	easy	2025-06-19 11:50:02.714168+00
469	d918d4e4-50e2-4f69-80a4-781d4758d080	b7496375-ca27-487a-a9a0-33fb6e1f14c8	All of the following are classified as Finno-Ugric languages EXCEPT:	["Finnish", "Estonian", "Hungarian", "Samoyedic"]	Hungarian	Samoyedic	f	Geography	easy	2025-06-19 11:53:21.707808+00
470	d918d4e4-50e2-4f69-80a4-781d4758d080	b7496375-ca27-487a-a9a0-33fb6e1f14c8	What is the largest country, by area, that has only one time zone?	["Russia", "India", "China", "Canada"]	India	China	f	Geography	easy	2025-06-19 11:53:21.707818+00
471	d918d4e4-50e2-4f69-80a4-781d4758d080	b7496375-ca27-487a-a9a0-33fb6e1f14c8	What is the name of New Zealand's indigenous people?	["Vikings", "Maori", "Samoans", "Polynesians"]	Vikings	Maori	f	Geography	easy	2025-06-19 11:53:21.707823+00
474	d918d4e4-50e2-4f69-80a4-781d4758d080	b7496375-ca27-487a-a9a0-33fb6e1f14c8	What is the Polish city known to Germans as Danzig?	["Zakopane", "Gdańsk", "Warsaw", "Poznań"]	Zakopane	Gdańsk	f	Geography	easy	2025-06-19 11:53:21.707828+00
475	d918d4e4-50e2-4f69-80a4-781d4758d080	b7496375-ca27-487a-a9a0-33fb6e1f14c8	Which of the following former Yugoslavian states is landlocked?	["Montenegro", "Bosnia and Herzegovina", "Serbia", "Croatia"]	Croatia	Serbia	f	Geography	easy	2025-06-19 11:53:21.707829+00
476	d918d4e4-50e2-4f69-80a4-781d4758d080	b7496375-ca27-487a-a9a0-33fb6e1f14c8	What is the smallest country in the world?	["Monaco", "Vatican City", "Maldives", "Malta"]	Vatican City	Vatican City	t	Geography	easy	2025-06-19 11:53:21.707832+00
477	d918d4e4-50e2-4f69-80a4-781d4758d080	b7496375-ca27-487a-a9a0-33fb6e1f14c8	Which country was NOT part of the Soviet Union?	["Belarus", "Turkmenistan", "Tajikistan", "Romania"]	Belarus	Romania	f	Geography	easy	2025-06-19 11:53:21.707834+00
478	d918d4e4-50e2-4f69-80a4-781d4758d080	b7496375-ca27-487a-a9a0-33fb6e1f14c8	What is the largest country in the world ?	["China", "Russian Federation", "Canada", "Brazil"]	Brazil	Russian Federation	f	Geography	easy	2025-06-19 11:53:21.707836+00
\.


--
-- Name: user_answer_detail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: quiz_app_user
--

SELECT pg_catalog.setval('public.user_answer_detail_id_seq', 478, true);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: quiz_app_user
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: quiz_attempt quiz_attempt_pkey; Type: CONSTRAINT; Schema: public; Owner: quiz_app_user
--

ALTER TABLE ONLY public.quiz_attempt
    ADD CONSTRAINT quiz_attempt_pkey PRIMARY KEY (id);


--
-- Name: user_answer_detail user_answer_detail_pkey; Type: CONSTRAINT; Schema: public; Owner: quiz_app_user
--

ALTER TABLE ONLY public.user_answer_detail
    ADD CONSTRAINT user_answer_detail_pkey PRIMARY KEY (id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: quiz_app_user
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: ix_quiz_attempt_user_id; Type: INDEX; Schema: public; Owner: quiz_app_user
--

CREATE INDEX ix_quiz_attempt_user_id ON public.quiz_attempt USING btree (user_id);


--
-- Name: ix_user_answer_detail_quiz_attempt_id; Type: INDEX; Schema: public; Owner: quiz_app_user
--

CREATE INDEX ix_user_answer_detail_quiz_attempt_id ON public.user_answer_detail USING btree (quiz_attempt_id);


--
-- Name: ix_user_answer_detail_user_id; Type: INDEX; Schema: public; Owner: quiz_app_user
--

CREATE INDEX ix_user_answer_detail_user_id ON public.user_answer_detail USING btree (user_id);


--
-- Name: ix_user_email; Type: INDEX; Schema: public; Owner: quiz_app_user
--

CREATE UNIQUE INDEX ix_user_email ON public."user" USING btree (email);


--
-- Name: quiz_attempt quiz_attempt_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: quiz_app_user
--

ALTER TABLE ONLY public.quiz_attempt
    ADD CONSTRAINT quiz_attempt_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: user_answer_detail user_answer_detail_quiz_attempt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: quiz_app_user
--

ALTER TABLE ONLY public.user_answer_detail
    ADD CONSTRAINT user_answer_detail_quiz_attempt_id_fkey FOREIGN KEY (quiz_attempt_id) REFERENCES public.quiz_attempt(id) ON DELETE CASCADE;


--
-- Name: user_answer_detail user_answer_detail_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: quiz_app_user
--

ALTER TABLE ONLY public.user_answer_detail
    ADD CONSTRAINT user_answer_detail_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

