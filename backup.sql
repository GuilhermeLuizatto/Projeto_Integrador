--
-- PostgreSQL database dump
--

\restrict 4x6VSPb5EyjZ8rMyNgr5wiC0iy3rCRyjvcgCulEazmVkBwZla7ON1CGr0K3OCfb

-- Dumped from database version 15.17 (Debian 15.17-1.pgdg13+1)
-- Dumped by pg_dump version 15.17 (Debian 15.17-1.pgdg13+1)

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
-- Name: sync_user_points(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sync_user_points() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Sincronizar o total_points de user_points para points em users
  UPDATE users
  SET points = NEW.total_points
  WHERE id = NEW.user_id;

  -- Retornar o registro modificado (obrigatório para triggers)
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sync_user_points() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: badges; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.badges (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    points_required integer NOT NULL,
    image_url text,
    description text,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.badges OWNER TO postgres;

--
-- Name: badges_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.badges_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.badges_id_seq OWNER TO postgres;

--
-- Name: badges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.badges_id_seq OWNED BY public.badges.id;


--
-- Name: points_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.points_history (
    id integer NOT NULL,
    user_id integer NOT NULL,
    points integer NOT NULL,
    task_id integer,
    task_title character varying(255),
    description text,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.points_history OWNER TO postgres;

--
-- Name: points_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.points_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.points_history_id_seq OWNER TO postgres;

--
-- Name: points_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.points_history_id_seq OWNED BY public.points_history.id;


--
-- Name: redemptions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.redemptions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    reward_id integer NOT NULL,
    points_spent integer NOT NULL,
    redeemed_at timestamp without time zone DEFAULT now(),
    cost integer DEFAULT 0 NOT NULL,
    voucher_code character varying(100) DEFAULT ''::character varying NOT NULL,
    status character varying(20) DEFAULT 'pending'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.redemptions OWNER TO postgres;

--
-- Name: redemptions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.redemptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.redemptions_id_seq OWNER TO postgres;

--
-- Name: redemptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.redemptions_id_seq OWNED BY public.redemptions.id;


--
-- Name: rewards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rewards (
    id integer NOT NULL,
    name character varying(255),
    title character varying(255),
    description text,
    points_cost integer NOT NULL,
    cost integer DEFAULT 0 NOT NULL,
    quantity integer DEFAULT 0 NOT NULL,
    active boolean DEFAULT true NOT NULL,
    created_by integer,
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT rewards_points_cost_check CHECK ((points_cost > 0))
);


ALTER TABLE public.rewards OWNER TO postgres;

--
-- Name: rewards_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rewards_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rewards_id_seq OWNER TO postgres;

--
-- Name: rewards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rewards_id_seq OWNED BY public.rewards.id;


--
-- Name: tasks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tasks (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    status character varying(20) DEFAULT 'todo'::character varying NOT NULL,
    points integer DEFAULT 10 NOT NULL,
    deadline date,
    assignee_id integer,
    created_by integer,
    gestor_id integer,
    evidence text,
    reviewed_by integer,
    reviewed_at timestamp without time zone,
    credited boolean DEFAULT false NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.tasks OWNER TO postgres;

--
-- Name: tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tasks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tasks_id_seq OWNER TO postgres;

--
-- Name: tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tasks_id_seq OWNED BY public.tasks.id;


--
-- Name: user_badges; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_badges (
    id integer NOT NULL,
    user_id integer NOT NULL,
    badge_id integer NOT NULL,
    claimed boolean DEFAULT false NOT NULL,
    unlocked_at timestamp without time zone DEFAULT now(),
    claimed_at timestamp without time zone
);


ALTER TABLE public.user_badges OWNER TO postgres;

--
-- Name: user_badges_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_badges_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_badges_id_seq OWNER TO postgres;

--
-- Name: user_badges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_badges_id_seq OWNED BY public.user_badges.id;


--
-- Name: user_points; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_points (
    id integer NOT NULL,
    user_id integer NOT NULL,
    total_points integer DEFAULT 0 NOT NULL,
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.user_points OWNER TO postgres;

--
-- Name: user_points_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_points_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_points_id_seq OWNER TO postgres;

--
-- Name: user_points_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_points_id_seq OWNED BY public.user_points.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    institution character varying(255),
    role character varying(20) DEFAULT 'funcionario'::character varying NOT NULL,
    nivel integer DEFAULT 1 NOT NULL,
    password character varying(255) NOT NULL,
    points integer DEFAULT 0 NOT NULL,
    "position" character varying(255),
    gestor_id integer,
    created_at timestamp without time zone DEFAULT now(),
    equipe character varying(255),
    visibility_settings jsonb DEFAULT '{"public_points": true, "show_in_ranking": true, "feed_achievements": true}'::jsonb
);


ALTER TABLE public.users OWNER TO postgres;

--
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
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: badges id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.badges ALTER COLUMN id SET DEFAULT nextval('public.badges_id_seq'::regclass);


--
-- Name: points_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.points_history ALTER COLUMN id SET DEFAULT nextval('public.points_history_id_seq'::regclass);


--
-- Name: redemptions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.redemptions ALTER COLUMN id SET DEFAULT nextval('public.redemptions_id_seq'::regclass);


--
-- Name: rewards id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rewards ALTER COLUMN id SET DEFAULT nextval('public.rewards_id_seq'::regclass);


--
-- Name: tasks id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks ALTER COLUMN id SET DEFAULT nextval('public.tasks_id_seq'::regclass);


--
-- Name: user_badges id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_badges ALTER COLUMN id SET DEFAULT nextval('public.user_badges_id_seq'::regclass);


--
-- Name: user_points id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_points ALTER COLUMN id SET DEFAULT nextval('public.user_points_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: badges; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.badges (id, name, points_required, image_url, description, created_at) FROM stdin;
1	Super Tarefa Bros!	50	/badges/SELO_-_MARIO-removebg-preview.png	\N	2026-05-03 21:59:19.245539
2	Velocidade de Entrega	100	/badges/SELO_-_SONIC-removebg-preview.png	\N	2026-05-03 21:59:19.252013
3	O Homem de Aço Ganhou Pontos	150	/badges/SELO_-_SUPER_MAN-removebg-preview.png	\N	2026-05-03 21:59:19.255227
4	A Câmara dos Segredos Produtivos	300	/badges/SELO_-_HARRY_POTTER-removebg-preview.png	\N	2026-05-03 21:59:19.258438
5	Com Grandes Pontos Vêm Grandes Recompensas	400	/badges/SELO_-_HOMEM_ARANHA-removebg-preview (1).png	\N	2026-05-03 21:59:19.261691
6	A Origem das Entregas	500	/badges/SELO_-_LARA_CROFT-removebg-preview.png	\N	2026-05-03 21:59:19.26479
7	A Recompensa Contra-Ataca	750	/badges/SELO_-_STAR_WARS-removebg-preview.png	\N	2026-05-03 21:59:19.267927
8	O Rei das Metas	875	/badges/SELO_-_SIMBA-removebg-preview.png	\N	2026-05-03 21:59:19.271049
9	A Lenda do Funcionário	1000	/badges/SELO_-_ZELDA-removebg-preview.png	\N	2026-05-03 21:59:19.274165
\.


--
-- Data for Name: points_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.points_history (id, user_id, points, task_id, task_title, description, created_at) FROM stdin;
\.


--
-- Data for Name: redemptions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.redemptions (id, user_id, reward_id, points_spent, redeemed_at, cost, voucher_code, status, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: rewards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rewards (id, name, title, description, points_cost, cost, quantity, active, created_by, created_at) FROM stdin;
\.


--
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tasks (id, title, description, status, points, deadline, assignee_id, created_by, gestor_id, evidence, reviewed_by, reviewed_at, credited, deleted, deleted_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: user_badges; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_badges (id, user_id, badge_id, claimed, unlocked_at, claimed_at) FROM stdin;
\.


--
-- Data for Name: user_points; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_points (id, user_id, total_points, updated_at) FROM stdin;
1	2	0	2026-05-03 21:59:19.160996
2	3	0	2026-05-03 21:59:19.174883
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, email, institution, role, nivel, password, points, "position", gestor_id, created_at, equipe, visibility_settings) FROM stdin;
1	Azis Admin	admin@azis.dev	\N	admin	3	$2b$10$1G4yuxa4flqA2KUeFWTyNORCmajV48zzW5Ty1KvmmYmYxXEUhyZKK	0	\N	\N	2026-05-03 21:59:19.085693	\N	{"public_points": true, "show_in_ranking": true, "feed_achievements": true}
4	Giovanna	gia@azis.com	\N	gestor	2	$2b$10$9vFCstySo0YCk6tokVh9O.0yJdlSLM4zRkabagbL0kx9jU2EjwKGO	0	Onipresenta	\N	2026-05-03 22:00:35.996341	\N	{"public_points": true, "show_in_ranking": true, "feed_achievements": true}
5	Giovanno	giu@azis.com	\N	gestor	2	$2b$10$/udPs0OREp/E4TYWOk25le1Y73wqFTPT5GIeUKpRGBxIGvj0RiEXy	0	Onipresento	\N	2026-05-03 22:00:36.065914	\N	{"public_points": true, "show_in_ranking": true, "feed_achievements": true}
2	Ana Silva	ana@azis.com	Azis	gestor	2	$2b$10$jdOJWveBJh1Za2v6SyaM.eM0Bf16uopB3EBanUcn.kYwsyojaRlAS	0	CEO	\N	2026-05-03 21:59:19.157506	\N	{"public_points": true, "show_in_ranking": true, "feed_achievements": true}
3	Lucas Freitas	lucas@azis.com	Azis	funcionario	1	$2b$10$jdOJWveBJh1Za2v6SyaM.eM0Bf16uopB3EBanUcn.kYwsyojaRlAS	0	Developer	2	2026-05-03 21:59:19.1678	\N	{"public_points": true, "show_in_ranking": true, "feed_achievements": true}
\.


--
-- Name: badges_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.badges_id_seq', 27, true);


--
-- Name: points_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.points_history_id_seq', 1, false);


--
-- Name: redemptions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.redemptions_id_seq', 1, false);


--
-- Name: rewards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rewards_id_seq', 1, false);


--
-- Name: tasks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tasks_id_seq', 1, false);


--
-- Name: user_badges_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_badges_id_seq', 1, false);


--
-- Name: user_points_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_points_id_seq', 6, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 7, true);


--
-- Name: badges badges_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.badges
    ADD CONSTRAINT badges_name_key UNIQUE (name);


--
-- Name: badges badges_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.badges
    ADD CONSTRAINT badges_pkey PRIMARY KEY (id);


--
-- Name: points_history points_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.points_history
    ADD CONSTRAINT points_history_pkey PRIMARY KEY (id);


--
-- Name: redemptions redemptions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.redemptions
    ADD CONSTRAINT redemptions_pkey PRIMARY KEY (id);


--
-- Name: rewards rewards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rewards
    ADD CONSTRAINT rewards_pkey PRIMARY KEY (id);


--
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- Name: user_badges user_badges_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_badges
    ADD CONSTRAINT user_badges_pkey PRIMARY KEY (id);


--
-- Name: user_badges user_badges_user_id_badge_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_badges
    ADD CONSTRAINT user_badges_user_id_badge_id_key UNIQUE (user_id, badge_id);


--
-- Name: user_points user_points_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_points
    ADD CONSTRAINT user_points_pkey PRIMARY KEY (id);


--
-- Name: user_points user_points_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_points
    ADD CONSTRAINT user_points_user_id_key UNIQUE (user_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: user_points trg_sync_user_points; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_sync_user_points AFTER INSERT OR UPDATE ON public.user_points FOR EACH ROW EXECUTE FUNCTION public.sync_user_points();


--
-- Name: points_history points_history_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.points_history
    ADD CONSTRAINT points_history_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(id) ON DELETE SET NULL;


--
-- Name: points_history points_history_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.points_history
    ADD CONSTRAINT points_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: redemptions redemptions_reward_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.redemptions
    ADD CONSTRAINT redemptions_reward_id_fkey FOREIGN KEY (reward_id) REFERENCES public.rewards(id);


--
-- Name: redemptions redemptions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.redemptions
    ADD CONSTRAINT redemptions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: rewards rewards_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rewards
    ADD CONSTRAINT rewards_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: tasks tasks_assignee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_assignee_id_fkey FOREIGN KEY (assignee_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: tasks tasks_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: tasks tasks_gestor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_gestor_id_fkey FOREIGN KEY (gestor_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: tasks tasks_reviewed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_reviewed_by_fkey FOREIGN KEY (reviewed_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: user_badges user_badges_badge_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_badges
    ADD CONSTRAINT user_badges_badge_id_fkey FOREIGN KEY (badge_id) REFERENCES public.badges(id) ON DELETE CASCADE;


--
-- Name: user_badges user_badges_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_badges
    ADD CONSTRAINT user_badges_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_points user_points_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_points
    ADD CONSTRAINT user_points_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: users users_gestor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_gestor_id_fkey FOREIGN KEY (gestor_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

\unrestrict 4x6VSPb5EyjZ8rMyNgr5wiC0iy3rCRyjvcgCulEazmVkBwZla7ON1CGr0K3OCfb

