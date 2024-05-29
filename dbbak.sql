--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2 (Debian 16.2-1)
-- Dumped by pg_dump version 16.2 (Debian 16.2-1)

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
-- Name: chats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chats (
    id text NOT NULL,
    project_id text,
    name text DEFAULT ''::text,
    user_id text
);


ALTER TABLE public.chats OWNER TO postgres;

--
-- Name: configs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.configs (
    id text NOT NULL,
    team_id text DEFAULT '0'::text,
    user_id text DEFAULT '0'::text,
    name text DEFAULT ''::text,
    display_name text DEFAULT ''::text,
    data text DEFAULT ''::text,
    visible bigint DEFAULT 0
);


ALTER TABLE public.configs OWNER TO postgres;

--
-- Name: credentials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.credentials (
    id text NOT NULL,
    login text DEFAULT ''::text,
    hash text DEFAULT ''::text,
    hash_type text DEFAULT ''::text,
    cleartext text DEFAULT ''::text,
    description text DEFAULT ''::text,
    source text DEFAULT ''::text,
    services text DEFAULT '{}'::text,
    user_id text,
    project_id text
);


ALTER TABLE public.credentials OWNER TO postgres;

--
-- Name: files; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.files (
    id text NOT NULL,
    project_id text,
    filename text DEFAULT ''::text,
    description text DEFAULT ''::text,
    services text DEFAULT '{}'::text,
    type text DEFAULT 'binary'::text,
    user_id text,
    storage text DEFAULT 'filesystem'::text,
    base64 text DEFAULT ''::text
);


ALTER TABLE public.files OWNER TO postgres;

--
-- Name: hostnames; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hostnames (
    id text NOT NULL,
    host_id text,
    hostname text,
    description text DEFAULT ''::text,
    user_id text
);


ALTER TABLE public.hostnames OWNER TO postgres;

--
-- Name: hosts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hosts (
    id text NOT NULL,
    project_id text,
    ip text,
    comment text DEFAULT ''::text,
    user_id text,
    threats text DEFAULT ''::text,
    os text DEFAULT ''::text
);


ALTER TABLE public.hosts OWNER TO postgres;

--
-- Name: issuerules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.issuerules (
    id text NOT NULL,
    name text DEFAULT ''::text,
    team_id text DEFAULT ''::text,
    user_id text DEFAULT ''::text,
    search_rules text DEFAULT '[]'::text,
    extract_vars text DEFAULT '[]'::text,
    replace_rules text DEFAULT '[]'::text
);


ALTER TABLE public.issuerules OWNER TO postgres;

--
-- Name: issues; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.issues (
    id text NOT NULL,
    name text DEFAULT ''::text,
    description text DEFAULT ''::text,
    url_path text DEFAULT ''::text,
    cvss double precision DEFAULT 0,
    cwe bigint DEFAULT 0,
    cve text DEFAULT ''::text,
    user_id text NOT NULL,
    services text DEFAULT '{}'::text,
    status text DEFAULT ''::text,
    project_id text NOT NULL,
    type text DEFAULT 'custom'::text,
    fix text DEFAULT ''::text,
    param text DEFAULT ''::text,
    fields text DEFAULT '{}'::text,
    technical text DEFAULT ''::text,
    risks text DEFAULT ''::text,
    "references" text DEFAULT ''::text,
    intruder text DEFAULT ''::text
);


ALTER TABLE public.issues OWNER TO postgres;

--
-- Name: issuetemplates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.issuetemplates (
    id text NOT NULL,
    tpl_name text DEFAULT ''::text,
    name text DEFAULT ''::text,
    description text DEFAULT ''::text,
    url_path text DEFAULT ''::text,
    cvss double precision DEFAULT 0,
    cwe bigint DEFAULT 0,
    cve text DEFAULT ''::text,
    status text DEFAULT ''::text,
    type text DEFAULT 'custom'::text,
    fix text DEFAULT ''::text,
    param text DEFAULT ''::text,
    fields text DEFAULT '{}'::text,
    variables text DEFAULT '{}'::text,
    user_id text DEFAULT ''::text,
    team_id text DEFAULT ''::text,
    technical text DEFAULT ''::text,
    risks text DEFAULT ''::text,
    "references" text DEFAULT ''::text,
    intruder text DEFAULT ''::text
);


ALTER TABLE public.issuetemplates OWNER TO postgres;

--
-- Name: logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.logs (
    id text NOT NULL,
    teams text DEFAULT ''::text,
    description text DEFAULT ''::text,
    date bigint,
    user_id text,
    project text DEFAULT ''::text
);


ALTER TABLE public.logs OWNER TO postgres;

--
-- Name: messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.messages (
    id text NOT NULL,
    chat_id text,
    message text DEFAULT ''::text,
    user_id text,
    "time" bigint
);


ALTER TABLE public.messages OWNER TO postgres;

--
-- Name: networkpaths; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.networkpaths (
    id text NOT NULL,
    host_out text DEFAULT ''::text,
    network_out text DEFAULT ''::text,
    host_in text DEFAULT ''::text,
    network_in text DEFAULT ''::text,
    description text DEFAULT ''::text,
    project_id text DEFAULT ''::text,
    type text DEFAULT 'connection'::text,
    direction text DEFAULT 'forward'::text
);


ALTER TABLE public.networkpaths OWNER TO postgres;

--
-- Name: networks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.networks (
    id text NOT NULL,
    ip text,
    name text DEFAULT ''::text,
    mask bigint,
    comment text DEFAULT ''::text,
    project_id text,
    user_id text,
    is_ipv6 bigint DEFAULT 0,
    asn bigint DEFAULT 0,
    access_from text DEFAULT '{}'::text,
    internal_ip text DEFAULT ''::text,
    cmd text DEFAULT ''::text
);


ALTER TABLE public.networks OWNER TO postgres;

--
-- Name: notes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notes (
    id text NOT NULL,
    project_id text,
    name text DEFAULT ''::text,
    text text DEFAULT ''::text,
    host_id text DEFAULT ''::text,
    user_id text,
    type text DEFAULT 'html'::text
);


ALTER TABLE public.notes OWNER TO postgres;

--
-- Name: poc; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.poc (
    id text NOT NULL,
    port_id text DEFAULT ''::text,
    description text DEFAULT ''::text,
    type text DEFAULT ''::text,
    filename text DEFAULT ''::text,
    issue_id text,
    user_id text,
    hostname_id text DEFAULT '0'::text,
    priority bigint DEFAULT 0,
    storage text DEFAULT 'filesystem'::text,
    base64 text DEFAULT ''::text
);


ALTER TABLE public.poc OWNER TO postgres;

--
-- Name: ports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ports (
    id text NOT NULL,
    host_id text,
    port bigint,
    is_tcp bigint DEFAULT 1,
    service text DEFAULT 'other'::text,
    description text DEFAULT ''::text,
    user_id text,
    project_id text
);


ALTER TABLE public.ports OWNER TO postgres;

--
-- Name: projects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.projects (
    id text NOT NULL,
    name text DEFAULT ''::text,
    description text DEFAULT ''::text,
    type text DEFAULT 'pentest'::text,
    scope text DEFAULT ''::text,
    start_date bigint,
    folder text DEFAULT ''::text,
    end_date bigint,
    report_title text DEFAULT ''::text,
    auto_archive bigint DEFAULT 0,
    status bigint DEFAULT 1,
    testers text DEFAULT ''::text,
    teams text DEFAULT ''::text,
    admin_id text
);


ALTER TABLE public.projects OWNER TO postgres;

--
-- Name: reporttemplates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reporttemplates (
    id text NOT NULL,
    team_id text DEFAULT '0'::text,
    user_id text DEFAULT '0'::text,
    name text DEFAULT ''::text,
    filename text DEFAULT ''::text,
    storage text DEFAULT 'filesystem'::text,
    base64 text DEFAULT ''::text
);


ALTER TABLE public.reporttemplates OWNER TO postgres;

--
-- Name: tasks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tasks (
    id text NOT NULL,
    name text DEFAULT ''::text,
    project_id text DEFAULT ''::text,
    description text DEFAULT ''::text,
    start_date bigint DEFAULT 0,
    finish_date bigint DEFAULT 0,
    criticality text DEFAULT 'info'::text,
    status text DEFAULT 'todo'::text,
    users text DEFAULT '[]'::text,
    teams text DEFAULT '[]'::text,
    services text DEFAULT '{}'::text
);


ALTER TABLE public.tasks OWNER TO postgres;

--
-- Name: teams; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teams (
    id text NOT NULL,
    admin_id text,
    name text DEFAULT ''::text,
    description text DEFAULT ''::text,
    users text DEFAULT '{}'::text,
    projects text DEFAULT ''::text,
    admin_email text DEFAULT ''::text
);


ALTER TABLE public.teams OWNER TO postgres;

--
-- Name: tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tokens (
    id text NOT NULL,
    user_id text DEFAULT '0'::text,
    name text DEFAULT ''::text,
    create_date bigint DEFAULT 0,
    duration bigint DEFAULT 0
);


ALTER TABLE public.tokens OWNER TO postgres;

--
-- Name: tool_sniffer_http_data; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tool_sniffer_http_data (
    id text NOT NULL,
    sniffer_id text,
    date bigint,
    ip text DEFAULT ''::text,
    request text DEFAULT ''::text
);


ALTER TABLE public.tool_sniffer_http_data OWNER TO postgres;

--
-- Name: tool_sniffer_http_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tool_sniffer_http_info (
    id text NOT NULL,
    project_id text,
    name text DEFAULT ''::text,
    status bigint DEFAULT 200,
    location text DEFAULT ''::text,
    body text DEFAULT ''::text,
    save_credentials bigint DEFAULT 0
);


ALTER TABLE public.tool_sniffer_http_info OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id text NOT NULL,
    fname text DEFAULT ''::text,
    lname text DEFAULT ''::text,
    email text,
    company text DEFAULT ''::text,
    password text,
    favorite text DEFAULT ''::text
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Data for Name: chats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chats (id, project_id, name, user_id) FROM stdin;
\.


--
-- Data for Name: configs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.configs (id, team_id, user_id, name, display_name, data, visible) FROM stdin;
\.


--
-- Data for Name: credentials; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.credentials (id, login, hash, hash_type, cleartext, description, source, services, user_id, project_id) FROM stdin;
45e928a3-2f9c-4c8c-baa5-53d95bb53ed2	myuserloc01@outlook.com			P3mbetu1an			{"dc763393-5092-4999-83aa-c54f094529cd": ["0"]}	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
1f6e1e44-212a-4b13-ab5e-f45ab6bdf546	pentest_user			pentest@mardi	user biasa		{"9414cb6c-70b2-407f-bb8c-8d53095a04f3": ["0"]}	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0dbc2858-bc39-4c8d-8cb5-b5a43eb38d99
bc2ee5af-cd58-49e9-a1ae-f4bea51dd3a3	pentest_su			pentest@mardi	user admin		{"9414cb6c-70b2-407f-bb8c-8d53095a04f3": ["0"]}	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0dbc2858-bc39-4c8d-8cb5-b5a43eb38d99
\.


--
-- Data for Name: files; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.files (id, project_id, filename, description, services, type, user_id, storage, base64) FROM stdin;
5a8b01e2-0522-460d-becd-aa71354aa1c6	926ec7f5-5674-45dc-ae0d-bd996488cb2e	report_2024-05-14T07:43:37.zip	1715643817	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
4b4e1612-d855-43a4-8efd-2a3622e2152a	926ec7f5-5674-45dc-ae0d-bd996488cb2e	report_2024-05-14T07:43:38.zip	1715643818	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
14b12697-468c-4f47-b196-44962d5acc73	926ec7f5-5674-45dc-ae0d-bd996488cb2e	report_2024-05-14T07:47:06.zip	1715644026	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
255aa675-04a9-4af4-b77e-1dd59028250e	926ec7f5-5674-45dc-ae0d-bd996488cb2e	report_2024-05-14T07:47:06.zip	1715644027	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
f136b1f9-d769-4938-b5e8-357078107100	926ec7f5-5674-45dc-ae0d-bd996488cb2e	report_2024-05-14T07:47:23.zip	1715644043	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
6b21683f-fab4-4afb-be5e-7ed36ec1ab7f	926ec7f5-5674-45dc-ae0d-bd996488cb2e	report_2024-05-14T07:47:24.zip	1715644044	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
97052c86-1853-4677-8674-9e1262a3e4ff	926ec7f5-5674-45dc-ae0d-bd996488cb2e	report_2024-05-14T07:47:59.txt	1715644079	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
398f9a34-5ac6-4952-93d4-8024757b4c3b	926ec7f5-5674-45dc-ae0d-bd996488cb2e	report_2024-05-14T07:47:59.txt	1715644079	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
86cee306-c9b9-4d3c-8e10-b3c2a158214d	926ec7f5-5674-45dc-ae0d-bd996488cb2e	report_2024-05-14T07:48:17.docx	1715644097	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
ccc3f8bc-813d-4078-9442-b7c2cabd86cb	926ec7f5-5674-45dc-ae0d-bd996488cb2e	report_2024-05-14T07:48:17.docx	1715644098	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
3dca6e09-3834-41ab-bc12-78e53f9aa025	926ec7f5-5674-45dc-ae0d-bd996488cb2e	report_2024-05-14T07:48:59.docx	1715644139	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
49004dc7-e040-48a1-a8e5-c94ff688a0f3	926ec7f5-5674-45dc-ae0d-bd996488cb2e	report_2024-05-14T07:48:59.docx	1715644139	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
80d2eeb8-0c2a-4690-88af-4b6210fa7af0	926ec7f5-5674-45dc-ae0d-bd996488cb2e	report_2024-05-14T07:49:14.docx	1715644155	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
64586117-e425-4051-93fa-68588cf785c8	926ec7f5-5674-45dc-ae0d-bd996488cb2e	report_2024-05-14T07:49:17.docx	1715644158	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
9441faca-d681-4714-ad58-a4a3cf5705f3	926ec7f5-5674-45dc-ae0d-bd996488cb2e	report_2024-05-14T07:49:50.docx	1715644191	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
917611ef-a2d8-4cb3-ad83-cf72ed48be5a	926ec7f5-5674-45dc-ae0d-bd996488cb2e	report_2024-05-14T07:50:13.docx	1715644214	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
dbefb962-15c0-4443-881b-867f0f538274	42a774cc-6853-410f-8071-0801b67a9ded	report_2024-05-15T03:52:07.docx	1715716328	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
c3a820eb-938c-4fdd-b657-01898652bcf9	42a774cc-6853-410f-8071-0801b67a9ded	report_2024-05-15T03:52:34.docx	1715716355	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
d9d39b67-05c0-48ad-84b8-6a7338547dec	42a774cc-6853-410f-8071-0801b67a9ded	report_2024-05-15T14:37:30.docx	1715755051	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
6b51c90c-790e-476e-be59-4fc2e95b68d9	42a774cc-6853-410f-8071-0801b67a9ded	report_2024-05-15T14:37:44.docx	1715755065	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
e9bc297f-bda2-4a5d-a26a-57e6f9cf4b8e	5e826717-ce5e-423c-be66-cbca319b2047	report_2024-05-16T01:43:55.docx	1715795035	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
3652614a-f38f-47b2-ae69-6c03e2f731c7	5e826717-ce5e-423c-be66-cbca319b2047	report_2024-05-16T01:49:58.txt	1715795398	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
496ec879-2294-44ff-91c2-97fdb4c2973a	5e826717-ce5e-423c-be66-cbca319b2047	report_2024-05-16T01:52:35.txt	1715795555	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
f05711f3-4065-4b24-accd-92bd406b6a61	5e826717-ce5e-423c-be66-cbca319b2047	report_2024-05-16T01:52:50.docx	1715795571	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
cf5e9045-7a24-4900-befe-ef67cb17bde0	5e826717-ce5e-423c-be66-cbca319b2047	report_2024-05-16T01:56:06.txt	1715795766	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
321d6723-8665-420d-b58d-a175cdebfc2a	5e826717-ce5e-423c-be66-cbca319b2047	report_2024-05-16T02:02:18.txt	1715796138	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
bca865f0-e45b-4e57-8ebf-4ced9c5b5783	5e826717-ce5e-423c-be66-cbca319b2047	report_2024-05-16T02:10:25.txt	1715796625	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
04244303-f268-47c1-a0af-b267ce98b46b	5e826717-ce5e-423c-be66-cbca319b2047	report_2024-05-16T02:12:26.txt	1715796746	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
2bf066d2-c185-4cfc-9a54-404cbf65eda4	5e826717-ce5e-423c-be66-cbca319b2047	report_2024-05-16T02:14:37.txt	1715796877	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
a0bc7332-4994-4d87-87eb-85b43d139bd0	5e826717-ce5e-423c-be66-cbca319b2047	report_2024-05-16T02:15:54.txt	1715796954	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
73c12a18-0cd3-4fc4-863b-93f5aa8d3061	5e826717-ce5e-423c-be66-cbca319b2047	report_2024-05-16T02:16:27.txt	1715796988	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
bf022874-e630-471d-8fe8-2209c6acaa0b	5e826717-ce5e-423c-be66-cbca319b2047	report_2024-05-16T02:17:37.txt	1715797057	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
52d5508e-3d60-4090-8515-5fb81e611f3a	5e826717-ce5e-423c-be66-cbca319b2047	report_2024-05-16T02:18:09.txt	1715797089	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
9384042f-d37d-40a4-9504-e4ef802bdaa2	5e826717-ce5e-423c-be66-cbca319b2047	report_2024-05-16T02:19:57.txt	1715797197	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
0853192c-e7f9-489a-a9b5-9d50eb662b16	5e826717-ce5e-423c-be66-cbca319b2047	report_2024-05-16T02:21:07.txt	1715797267	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
d248d6fe-b3ac-4db1-b9a9-72cf1f253db2	5e826717-ce5e-423c-be66-cbca319b2047	report_2024-05-16T02:44:39.docx	1715798680	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
038584c1-424b-4d64-bb0a-e98f8702dace	5e826717-ce5e-423c-be66-cbca319b2047	report_2024-05-16T02:47:27.docx	1715798848	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
8b0f073d-6448-4ce1-bad2-0f036f9e66c6	5e826717-ce5e-423c-be66-cbca319b2047	report_2024-05-16T02:48:42.docx	1715798922	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
36330092-60a4-4e76-925d-907e1ebfd586	42a774cc-6853-410f-8071-0801b67a9ded	report_2024-05-16T05:39:57.docx	1715809197	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
a027df0d-384b-4f63-82ae-1c96a90fa736	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-17T08:47:51.txt	1715906871	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
6c3a4e9c-f3c2-4833-b4b8-dd782a167711	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-17T08:48:05.txt	1715906885	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
926a3784-6baa-43ee-88ff-d94816bf0603	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-17T08:50:36.txt	1715907036	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
e467d002-7993-4f2b-9137-c2e9593b1e41	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-17T08:50:42.txt	1715907042	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
ed302074-e7c2-4a55-89a6-cafcc8e75e31	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-17T08:54:50.txt	1715907290	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
04459036-bec5-4235-a7a9-dce6c2669eda	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-17T08:55:37.txt	1715907337	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
7ca3bf40-d78e-4a7f-a5e6-06f75f516914	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-17T08:57:20.txt	1715907440	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
64ec221a-5cec-4dfd-9416-7c1541cbaa95	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-17T08:59:22.txt	1715907562	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
7e9c42b9-e05e-4b07-b02b-690a7b22f70d	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-17T09:01:56.txt	1715907716	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
cbd78cdd-059f-41e7-baf9-ade7e91fb3d4	42a774cc-6853-410f-8071-0801b67a9ded	report_2024-05-19T12:32:00.txt	1716093120	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
14654c83-c9bb-4f53-bab3-96e7fcfd9765	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T12:34:10.txt	1716093250	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
ae127dc9-e059-4031-b6ab-d440ba1c2690	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T12:56:09.txt	1716094569	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
7354f32a-5946-422e-bf11-744bc377e379	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T13:01:35.txt	1716094895	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
6f72baa2-a5ab-4f2e-b1d0-96aa38a7e28b	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T13:05:04.docx	1716095105	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
65f60ad1-3e62-4352-9260-0bae8703dee0	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T13:09:35.txt	1716095375	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
5a1e49d7-a611-4270-800b-903eda4e955d	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T13:11:50.txt	1716095510	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
f08bd792-2a8c-44eb-8a79-9184ae8720fb	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T13:13:04.txt	1716095584	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
c58767d0-0cb4-48ef-b8fe-e92e9ea5eb62	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T13:16:13.txt	1716095773	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
ae34e975-217d-4586-8ff4-382870e8b0f6	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T13:20:49.docx	1716096049	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
02d4384d-a848-402e-9b71-0d37f0284358	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T13:21:20.docx	1716096080	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
a6c3fe0e-2ba1-49ca-b57e-2c8f16629a90	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T13:34:59.docx	1716096900	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
866306d5-3d86-4755-a29e-3330bbeda401	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T13:35:08.docx	1716096909	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
f3aab7e0-4c0e-4277-8934-0f276732a349	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T13:37:27.docx	1716097048	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
08e895a9-787a-4153-8aa3-f99d23a16d75	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T13:37:54.docx	1716097075	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
28c2f235-73fe-4d3a-9556-7eadf9f34161	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T13:43:37.docx	1716097418	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
64b53317-a287-4e46-8c9f-3a7f7ed1d0ed	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T13:47:29.docx	1716097650	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
1ad368be-cce3-4c3c-8a3c-e425bce790b0	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T13:49:17.docx	1716097758	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
0a3ad614-f447-45df-9b37-0736ee2d4bd8	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T13:49:39.docx	1716097780	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
6739b8bf-de62-4f84-b29d-60bbf7cfe455	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T13:58:05.docx	1716098285	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
1c45df1a-2c32-4b4e-8b3e-91cea0550cca	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T14:07:03.docx	1716098824	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
7a8f04af-088b-4d5b-a0b1-62f9152a19c3	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T14:09:22.docx	1716098963	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
9770d201-f64a-42ef-ac34-65603d43a7ef	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T14:18:10.docx	1716099491	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
e8b24a93-083e-4d4b-a8b0-527616e931c2	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T14:21:55.docx	1716099716	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
c74c5d14-4cc9-4d06-9797-482359ccf756	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T14:24:13.docx	1716099854	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
5a032398-3ce9-4ccb-b13c-7a451c111942	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T15:31:10.docx	1716103871	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
b4850eb5-0738-49e3-a49a-ff7b69c4503b	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T17:06:42.docx	1716109603	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
c8c9a026-76d3-4adc-8389-3eb8de9d03c2	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T17:20:49.docx	1716110450	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
d3d2d6aa-2e7d-40bc-a63d-a57dc17cd860	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T17:27:44.docx	1716110864	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
33f5def8-1279-4100-828d-fb8c05e94dd1	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T17:34:16.docx	1716111257	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
c160c0db-3be5-48ec-bf84-029b54ca7b0c	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T17:52:11.docx	1716112331	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
8f06e9eb-4d73-4926-9184-06f0a39febb3	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T17:52:52.docx	1716112373	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
a3baec90-d0b7-40bb-acb1-cc8f526a397e	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T17:53:30.docx	1716112411	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
0ef12179-4592-48ac-87ce-01621ad3177e	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T17:57:03.docx	1716112623	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
70712927-f875-49e5-bd24-ed1a9cdc7263	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T17:59:23.docx	1716112764	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
070060e8-bd58-458a-ac19-0969a305260a	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T18:11:49.docx	1716113510	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
3e2799d8-8b1d-4c95-8172-7392c55c7ec9	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T18:21:24.docx	1716114085	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
39f4d7ef-0164-4aa0-ac30-9d67c3d90c7e	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T18:23:39.docx	1716114220	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
76fe9398-0cb6-4840-9ba1-3d8dc005bdda	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T18:26:54.docx	1716114414	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
79654dd0-6c43-45ec-abb6-d3f57e70ec7a	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T18:30:19.docx	1716114620	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
147e61e9-f80b-4395-b746-edff3bc8917a	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T18:35:02.docx	1716114903	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
64e37842-cf0e-4d27-9ebf-249b8032e7a5	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T18:35:24.docx	1716114924	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
1dc8f71d-86df-446e-8a0e-f812403e6d69	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T18:35:58.docx	1716114959	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
a13bc700-411a-4a4b-8779-fc7b71d44b11	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T18:39:14.docx	1716115155	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
788b1f4b-549f-4a80-a0bb-78032965e257	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T18:39:59.docx	1716115199	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
baaed9db-ab9d-49ba-8109-1709364b2438	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T18:40:25.docx	1716115226	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
f0f1b2b9-f1dc-4076-956b-bc0d69ddfa1c	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T20:11:02.docx	1716120663	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
355bd2c1-2aba-40d9-a797-b709daa5e15c	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T20:12:31.docx	1716120751	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
538d3a28-8705-49f5-bb55-d6b10422164e	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T20:22:08.docx	1716121329	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
abba934a-06ca-4166-ac91-2f09b7ca70b0	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T20:23:35.docx	1716121416	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
51b67241-1416-44f5-90e5-b57fbcff03d0	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T20:26:07.docx	1716121568	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
757e5666-8c30-4e24-86ab-866b94cc4683	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T20:30:58.docx	1716121859	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
da11e6ed-0320-45af-9d77-2654b844892c	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T20:33:37.docx	1716122018	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
e5e4d6c6-9cdf-41b8-b6ce-51a77dca97f7	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T20:35:39.docx	1716122139	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
e70ad13d-b2ed-4e88-afab-907bd729f373	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T20:36:20.docx	1716122181	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
1e8f54d2-dba9-4290-9344-38d4e8667f5b	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T20:38:00.docx	1716122280	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
6f2d6948-4575-4e75-951d-a2664b5d616e	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T20:40:47.docx	1716122448	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
b108c2e1-2207-48ec-9b8e-df202fb96d2a	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T20:41:19.docx	1716122480	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
7aaf7f8e-de8f-46a4-9713-8c546c32451c	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T20:50:29.docx	1716123030	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
0b0c7dcc-6164-44e9-b8a5-c55c90f179aa	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T21:01:31.docx	1716123691	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
44575a18-2164-4c0a-992b-bab61f953051	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T21:03:57.docx	1716123838	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
8bf2b066-6168-4a17-a4ca-a9a105cc7aa8	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T21:05:40.docx	1716123940	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
263df86c-f37a-4b32-826e-6a0caf9ee956	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T21:06:20.docx	1716123981	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
a680b9c3-e82f-440d-9c17-e9b9e22c1724	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T21:06:45.docx	1716124006	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
d3c40258-e3bd-4bb7-8b83-b18b02d77c42	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T21:12:24.docx	1716124344	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
22fb0ee2-f0df-4945-81a2-bc0b33f65ebc	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-19T21:26:30.docx	1716125191	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
68bec3c0-4318-4a02-a1cf-8ad426b12049	0dbc2858-bc39-4c8d-8cb5-b5a43eb38d99	report_2024-05-20T18:35:57.docx	1716201358	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
5bc96468-638d-4b81-bbeb-8267fa95c47e	0dbc2858-bc39-4c8d-8cb5-b5a43eb38d99	report_2024-05-20T18:36:56.txt	1716201416	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
fe4fae2f-907c-4b27-a214-eef5fb2259d4	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-21T00:16:29.docx	1716221790	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
d4fcabd4-757b-4f33-87da-d7a11e8971c7	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-21T00:17:27.docx	1716221848	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
d6bbefff-3885-4135-a099-72a8b8411a8f	b25edd49-04c1-4a21-b42b-05557dcf29cd	report_2024-05-21T00:19:30.docx	1716221971	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
6884bab2-29e9-46b3-aab0-298059c173f1	9dd7d458-5124-4358-943d-8d3bd8f4abe6	report_2024-05-21T21:42:07.docx	1716298928	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
b2839031-b69e-4252-9637-37f3f6d4322f	9dd7d458-5124-4358-943d-8d3bd8f4abe6	report_2024-05-21T21:43:38.docx	1716299019	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
5c5a4015-ef93-47a3-88a4-ad7b78ea71ac	9dd7d458-5124-4358-943d-8d3bd8f4abe6	report_2024-05-21T21:43:51.txt	1716299031	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
dda25c98-311a-4d8e-ab9a-f5f1407f0edf	af66f73f-15ab-4c1e-8537-ef381a0a6025	report_2024-05-23T13:48:16.docx	1716443297	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
4bb7d569-2d45-4543-9aad-b90bae5fc57f	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398	report_2024-05-26T22:34:34.docx	1716734075	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
589e58b9-84e4-42da-b94c-d332f465613b	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398	report_2024-05-29T14:32:31.docx	1716964352	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
8e5acf5d-cd2a-4b5b-9978-97ca0df3fac1	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398	report_2024-05-29T14:41:17.txt	1716964877	"{}"	report	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	filesystem	
\.


--
-- Data for Name: hostnames; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hostnames (id, host_id, hostname, description, user_id) FROM stdin;
\.


--
-- Data for Name: hosts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hosts (id, project_id, ip, comment, user_id, threats, os) FROM stdin;
ac3c0711-cb63-4a31-9175-8e25cf7f0016	926ec7f5-5674-45dc-ae0d-bd996488cb2e	mada.gov.my	vv	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	[]	
6eb8f707-f5e0-42b4-83c1-ff86694fe043	926ec7f5-5674-45dc-ae0d-bd996488cb2e	portal.mada.gov.my	kjhk	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	[]	
e9115140-5869-4a39-8bf9-a92fe2172966	926ec7f5-5674-45dc-ae0d-bd996488cb2e	hrms.mada.gov.my	hrms.mada.gov.my	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	[]	
71716422-0809-462f-94a5-bb2c4f885be0	42a774cc-6853-410f-8071-0801b67a9ded	uat-admin.myinvois.hasil.gov.my	Admin UAT	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	[]	
491d10b7-0f16-40f4-ac41-3e80df418b3b	5e826717-ce5e-423c-be66-cbca319b2047	uat-admin.myinvois.hasil.gov.my	Admin UAT	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	["high", "offline"]	Windows Server 2008
1008494e-857f-4a8d-989d-455353f21a62	b25edd49-04c1-4a21-b42b-05557dcf29cd	host1.com		543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	[]	
477e087d-3063-40a2-9c9d-e236e4dec111	b25edd49-04c1-4a21-b42b-05557dcf29cd	host2.com		543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	[]	
3b4c44f1-0d59-4389-bdbf-f61109395bcd	b25edd49-04c1-4a21-b42b-05557dcf29cd	host3.com		543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	[]	
23acc9a8-8003-4fc4-b3bf-e5e25b2026d9	b25edd49-04c1-4a21-b42b-05557dcf29cd	testurlyangpanjang.lhdn.gov.my	testurlyangpanjang.lhdn.gov.my	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	[]	
101cbf1a-c9d0-4b2a-aaa3-be59deb3324d	0dbc2858-bc39-4c8d-8cb5-b5a43eb38d99	pentest-portal.mardi.gov.my/		543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	[]	
4586d29a-df05-4130-b5e6-0ff0d316b700	9dd7d458-5124-4358-943d-8d3bd8f4abe6	livechat.ptptn.gov.my		543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	[]	
5612a6bd-5242-47d6-ac60-6198bab246b3	9dd7d458-5124-4358-943d-8d3bd8f4abe6	myptptn.ptptn.gov.my	Live PTPTN	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	[]	
986034dc-d4c9-4a0b-8c7f-b9af2a1945fa	9dd7d458-5124-4358-943d-8d3bd8f4abe6	myptptnstg.ptptn.gov.my	Staging	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	[]	
67e1544b-761e-4e5a-bd0f-e9c53fa8f8cb	af66f73f-15ab-4c1e-8537-ef381a0a6025	gateway.n9pay.ns.gov.my	Gateway N9	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	[]	
ccd40241-de9e-4c94-aab7-d5c504243e77	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398	GPKI Mobile	GPKI Mobile	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	[]	
\.


--
-- Data for Name: issuerules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.issuerules (id, name, team_id, user_id, search_rules, extract_vars, replace_rules) FROM stdin;
\.


--
-- Data for Name: issues; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.issues (id, name, description, url_path, cvss, cwe, cve, user_id, services, status, project_id, type, fix, param, fields, technical, risks, "references", intruder) FROM stdin;
d2b40a24-3b6d-427a-b63e-5ebdcf183429	File Information Disclosure	An information disclosure vulnerability exists in the remote web server due to the disclosure of the web.config file. An unauthenticated, remote attacker can exploit this, via a simple GET request, to disclose potentially sensitive configuration information.	https://uat-admin.myinvois.hasil.gov.my/static/js/main.6f9542f1.js.LICENSE.txt	6.5	1230	CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:L/I:L/A:N	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	{"5962e521-e09e-4230-a3ed-c97346a05556": ["0"]}	Need to recheck	5e826717-ce5e-423c-be66-cbca319b2047	custom	Declare this rule on .htaccess. For Examples:\r\n\r\n<files filename.ext>\r\n         order allow,deny\r\n         deny from all\r\n</files>	-	{"origin_cvss_vector": {"val": "CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:L/I:L/A:N", "type": "text"}}	Access through this URL, https://uat-admin.myinvois.hasil.gov.my/static/js/main.6f9542f1.js.LICENSE.txt\r\nAll generated plugins when building the source code will display here	An unauthenticated, remote attacker can exploit this file, via a simple GET request, to disclose potentially sensitive configuration information.	https://wordpress.stackexchange.com/questions/5400/prevent-access-or-auto-delete-readme-html-license-txt-wp-config-sample-php\r\nhttps://stackoverflow.com/questions/11728976/how-to-deny-access-to-a-file-in-htaccess	GET /static/js/main.6f9542f1.js.LICENSE.txt HTTP/2\r\nHost: uat-admin.myinvois.hasil.gov.my\r\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.6367.118 Safari/537.36\r\nAccept: */*\r\nSec-Fetch-Site: none\r\nSec-Fetch-Mode: cors\r\nSec-Fetch-Dest: empty\r\nAccept-Encoding: gzip, deflate, br\r\nAccept-Language: en-US,en;q=0.9\r\nPriority: u=1, i\r\n\r\n
d7ab474e-9e30-4a49-81a5-a6ec1d8d936c	Insecure File Upload	Uploaded files represent a significant risk to applications. The first step in many attacks is to get some code to the system to be attacked. Then the attack only needs to find a way to get the code executed. Using a file upload helps the attacker accomplish the first step.	https://uat-api.myinvois.hasil.gov.my/admin/api/v1.0/taxpayers/IG10653040	5.8	1073	CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:C/C:N/I:N/A:L	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	{"dc763393-5092-4999-83aa-c54f094529cd": ["0"]}	Need to recheck	42a774cc-6853-410f-8071-0801b67a9ded	web	Restrict file types accepted for upload: check the file extension and only allow certain files to be uploaded. Use a whitelist approach instead of a blacklist. Check for double extensions such as .php.png. Check for files without a filename like .htaccess (on ASP.NET, check for configuration files like web.config). Change the permissions on the upload folder so the files within it are not executable. If possible, rename the files that are uploaded.	CompanyIcon	{"origin_cvss_vector": {"val": "CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:C/C:N/I:N/A:L", "type": "text"}, "cvss_vector": {"val": "CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:C/C:N/I:N/A:H", "type": "text"}}	1. First we trying to upgrade normal picture with bigger than 250kb. However we unsuccessfuly upload\r\n2. We upload the allowed picture and intercept the request\r\n3. We found that the picture was encoded in based64\r\n4. Encode payload .html file with based64 using tools.\r\n5. change the value of the base64 to our payload\r\n6. successfully upload the file.	1. Server-side attacks: The web server can be compromised by uploading and executing a web-shell which can run commands, browse system files, browse local resources, attack other servers, or exploit the local vulnerabilities, and so forth.\r\n\r\n2. Client-side attacks: Uploading malicious files can make the website vulnerable to client-side attacks such as XSS or Cross-site Content Hijacking.\r\n\r\n3. Uploaded files can be abused to exploit other vulnerable sections of an application when a file on the same or a trusted server is needed (can again lead to client-side or server-side attacks)\r\n\r\n4.  A malicious file such as a Unix shell script, a windows virus, an Excel file with a dangerous formula, or a reverse shell can be uploaded on the server in order to execute code by an administrator or webmaster later – on the victim’s machine.\r\n\r\n5. An attacker might be able to put a phishing page into the website or deface the website.\r\n	https://owasp.org/www-community/vulnerabilities/Unrestricted_File_Upload	PUT /admin/api/v1.0/taxpayers/IG10653040 HTTP/2\r\nHost: uat-api.myinvois.hasil.gov.my\r\nContent-Length: 72014\r\nSec-Ch-Ua: "Not-A.Brand";v="99", "Chromium";v="124"\r\nAccept-Language: en\r\nSec-Ch-Ua-Mobile: ?0\r\nAuthorization: Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6Ijk2RjNBNjU2OEFEQzY0MzZDNjVBNDg1MUQ5REM0NTlFQTlCM0I1NTRSUzI1NiIsIng1dCI6Imx2T21Wb3JjWkRiR1draFIyZHhGbnFtenRWUSIsInR5cCI6ImF0K2p3dCJ9.eyJpc3MiOiJodHRwczovL3VhdC1pZGVudGl0eS5teWludm9pcy5oYXNpbC5nb3YubXkiLCJuYmYiOjE3MTU3MTQzMzgsImlhdCI6MTcxNTcxNDMzOCwiZXhwIjoxNzE1NzE1MjM4LCJzY29wZSI6WyJvcGVuaWQiLCJwcm9maWxlIiwiYWRtaW5wb3J0YWwuYmZmLmFwaSIsIm9mZmxpbmVfYWNjZXNzIl0sImFtciI6WyJleHRlcm5hbCJdLCJjbGllbnRfaWQiOiI1NDI0ODAwMy1EQ-and other encoded bit-"}
595fa6d3-a72b-4262-a83e-3f2581887e62	Cross Site Scripting (XSS)	Cross-site scripting (also known as XSS) is a web security vulnerability that allows an attacker to compromise the interactions that users have with a vulnerable application. It allows an attacker to circumvent the same origin policy, which is designed to segregate different websites from each other. Cross-site scripting vulnerabilities normally allow an attacker to masquerade as a victim user, to carry out any actions that the user is able to perform, and to access any of the user's data. If the victim user has privileged access within the application, then the attacker might be able to gain full control over all of the application's functionality and data.		8.3	0		543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	{"5f67db4e-d546-4a12-8597-8c9d4f7fdde4": ["0"]}	Need to recheck	b25edd49-04c1-4a21-b42b-05557dcf29cd	custom	Preventing cross-site scripting is trivial in some cases but can be much harder depending on the complexity of the application and the ways it handles user-controllable data.\r\nIn general, effectively preventing XSS vulnerabilities is likely to involve a combination of the following measures:\r\nFilter input on arrival. At the point where user input is received, filter as strictly as possible based on what is expected or valid input.\r\nEncode data on output. At the point where user-controllable data is output in HTTP responses, encode the output to prevent it from being interpreted as active content. Depending on the output context, this might require applying combinations of HTML, URL, JavaScript, and CSS encoding.\r\nUse appropriate response headers. To prevent XSS in HTTP responses that are not intended to contain any HTML or JavaScript, you can use the Content-Type and X-Content-Type-Options headers to ensure that browsers interpret the responses in the way you intend.\r\nContent Security Policy. As a last line of defence, you can use Content Security Policy (CSP) to reduce the severity of any XSS vulnerabilities that still occur.\r\n		{}		Cross-site scripting works by manipulating a vulnerable web site so that it returns malicious JavaScript to users. When the malicious code executes inside a victim's browser, the attacker can fully compromise their interaction with the application.	https://portswigger.net/web-security/cross-site-scripting	
2848237c-f97a-4cdf-9def-93d5d3501c9f	Insecure File Upload	Uploaded files represent a significant risk to applications. The first step in many attacks is to get some code to the system to be attacked. Then the attack only needs to find a way to get the code executed. Using a file upload helps the attacker accomplish the first step.		1.6	0	CVSS:3.1/AV:P/AC:H/PR:H/UI:R/S:U/C:N/I:N/A:L	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	{"0024d2df-ab61-43bd-9cc8-fe805e5617a7": ["0"]}	Need to recheck	b25edd49-04c1-4a21-b42b-05557dcf29cd	custom	Restrict file types accepted for upload: check the file extension and only allow certain files to be uploaded. Use a whitelist approach instead of a blacklist. Check for double extensions such as .php.png. Check for files without a filename like .htaccess (on ASP.NET, check for configuration files like web.config). Change the permissions on the upload folder so the files within it are not executable. If possible, rename the files that are uploaded.		{"origin_cvss_vector": {"val": "CVSS:3.1/AV:P/AC:H/PR:H/UI:R/S:U/C:N/I:N/A:L", "type": "text"}}		1. Server-side attacks: The web server can be compromised by uploading and executing a web-shell which can run commands, browse system files, browse local resources, attack other servers, or exploit the local vulnerabilities, and so forth.\r\n\r\n2. Client-side attacks: Uploading malicious files can make the website vulnerable to client-side attacks such as XSS or Cross-site Content Hijacking.\r\n\r\n3. Uploaded files can be abused to exploit other vulnerable sections of an application when a file on the same or a trusted server is needed (can again lead to client-side or server-side attacks)\r\n\r\n4.  A malicious file such as a Unix shell script, a windows virus, an Excel file with a dangerous formula, or a reverse shell can be uploaded on the server in order to execute code by an administrator or webmaster later – on the victim’s machine.\r\n\r\n5. An attacker might be able to put a phishing page into the website or deface the website.\r\n	https://owasp.org/www-community/vulnerabilities/Unrestricted_File_Upload	
2f3c93d8-4b91-413f-b94d-3e2bad2f58a3	File Information Disclosure	An information disclosure vulnerability exists in the remote web server due to the disclosure of the web.config file. An unauthenticated, remote attacker can exploit this, via a simple GET request, to disclose potentially sensitive configuration information.		7.1	0	CVSS:3.1/AV:A/AC:H/PR:N/UI:R/S:U/C:H/I:H/A:H	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	{"5f67db4e-d546-4a12-8597-8c9d4f7fdde4": ["0"]}	Need to recheck	b25edd49-04c1-4a21-b42b-05557dcf29cd	custom	Declare this rule on .htaccess. For Examples:\r\n\r\n<files filename.ext>\r\n         order allow,deny\r\n         deny from all\r\n</files>		{"origin_cvss_vector": {"val": "CVSS:3.1/AV:A/AC:H/PR:N/UI:R/S:U/C:H/I:H/A:H", "type": "text"}}		An unauthenticated, remote attacker can exploit this file, via a simple GET request, to disclose potentially sensitive configuration information.	https://wordpress.stackexchange.com/questions/5400/prevent-access-or-auto-delete-readme-html-license-txt-wp-config-sample-php\r\nhttps://stackoverflow.com/questions/11728976/how-to-deny-access-to-a-file-in-htaccess	
89a66131-8ace-4c24-b048-cba029e741c0	Unauthenticate SQL injection	SQL injection is a web security vulnerability that allows an attacker to interfere with the queries that an application makes to its database. It generally allows an attacker to view data that they are not normally able to retrieve. This might include data belonging to other users, or any other data that the application itself is able to access. In many cases, an attacker can modify or delete this data, causing persistent changes to the application's content or behaviour.		9.5	0	CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:C/C:H/I:H/A:H	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	{"5f67db4e-d546-4a12-8597-8c9d4f7fdde4": ["0"]}	Need to recheck	b25edd49-04c1-4a21-b42b-05557dcf29cd	web	Most instances of SQL injection can be prevented by using parameterized queries (also known as prepared statements) instead of string concatenation within the query.\r\nThe following code is vulnerable to SQL injection because the user input is concatenated directly into the query:\\n\r\n\r\nString query = "SELECT * FROM products WHERE category = '"+ input + "'";\\n\r\nStatement statement = connection.createStatement();\\n\r\nResultSet resultSet = statement.executeQuery(query);\r\nThis code can be easily rewritten in a way that prevents the user input from interfering with the query structure:\r\nPreparedStatement statement = connection.prepareStatement("SELECT * FROM products WHERE category = ?");\r\nstatement.setString(1, input);\r\nResultSet resultSet = statement.executeQuery();\r\n\r\nParameterized queries can be used for any situation where untrusted input appears as data within the query, including the WHERE clause and values in an INSERT or UPDATE statement. They cannot be used to handle untrusted input in other parts of the query, such as table or column names, or the ORDER BY clause. Application functionality that places untrusted data into those parts of the query will need to take a different approach, such as white listing permitted input values, or using different logic to deliver the required behaviour.\r\n\r\nFor a parameterized query to be effective in preventing SQL injection, the string that is used in the query must always be a hard-coded constant and must never contain any variable data from any origin. Do not be tempted to decide case-by-case whether an item of data is trusted and continue using string concatenation within the query for cases that are considered safe. It is all too easy to make mistakes about the possible origin of data, or for changes in other code to violate assumptions about what data is tainted.\r\n		{}	1. Test\r\n2. TETfdsfsfdsfa\r\n3. TEfdsf dfdslfjd;a	A successful SQL injection attack can result in unauthorized access to sensitive data, such as passwords, credit card details, or personal user information. Many high-profile data breaches in recent years have been the result of SQL injection attacks, leading to reputational damage and regulatory fines. In some cases, an attacker can obtain a persistent backdoor into an organization's systems, leading to a long-term compromise that can go unnoticed for an extended period.	https://portswigger.net/web-security/sql-injection\r\nhttps://www.acunetix.com/websitesecurity/sql-injection/	
e6a75ac9-33d1-49b5-a105-a652dffed734	Unauthenticate SQL injection	SQL injection is a web security vulnerability that allows an attacker to interfere with the queries that an application makes to its database. It generally allows an attacker to view data that they are not normally able to retrieve. This might include data belonging to other users, or any other data that the application itself is able to access. In many cases, an attacker can modify or delete this data, causing persistent changes to the application's content or behaviour.		9.5	0	CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:C/C:H/I:H/A:H	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	{"5f67db4e-d546-4a12-8597-8c9d4f7fdde4": ["0"]}	Need to recheck	b25edd49-04c1-4a21-b42b-05557dcf29cd	web	Most instances of SQL injection can be prevented by using parameterized queries (also known as prepared statements) instead of string concatenation within the query.\r\nThe following code is vulnerable to SQL injection because the user input is concatenated directly into the query:/n\r\nString query = "SELECT * FROM products WHERE category = '"+ input + "'";\\n\r\nStatement statement = connection.createStatement();\\r\\n\r\nResultSet resultSet = statement.executeQuery(query);\r\nThis code can be easily rewritten in a way that prevents the user input from interfering with the query structure:\r\nPreparedStatement statement = connection.prepareStatement("SELECT * FROM products WHERE category = ?");\r\nstatement.setString(1, input);\r\nResultSet resultSet = statement.executeQuery();\r\n\r\nParameterized queries can be used for any situation where untrusted input appears as data within the query, including the WHERE clause and values in an INSERT or UPDATE statement. They cannot be used to handle untrusted input in other parts of the query, such as table or column names, or the ORDER BY clause. Application functionality that places untrusted data into those parts of the query will need to take a different approach, such as white listing permitted input values, or using different logic to deliver the required behaviour.\r\n\r\nFor a parameterized query to be effective in preventing SQL injection, the string that is used in the query must always be a hard-coded constant and must never contain any variable data from any origin. Do not be tempted to decide case-by-case whether an item of data is trusted and continue using string concatenation within the query for cases that are considered safe. It is all too easy to make mistakes about the possible origin of data, or for changes in other code to violate assumptions about what data is tainted.\r\n		{}		A successful SQL injection attack can result in unauthorized access to sensitive data, such as passwords, credit card details, or personal user information. Many high-profile data breaches in recent years have been the result of SQL injection attacks, leading to reputational damage and regulatory fines. In some cases, an attacker can obtain a persistent backdoor into an organization's systems, leading to a long-term compromise that can go unnoticed for an extended period.	https://portswigger.net/web-security/sql-injection\r\nhttps://www.acunetix.com/websitesecurity/sql-injection/	
e6fa72dc-40e6-4f6f-b323-2edcaccc0502	.htaccess Disclosure	The remote web server discloses information via HTTP request.	https://pentest-portal.mardi.gov.my/htaccess.txt	5.1	0	CVSS:3.1/AV:L/AC:L/PR:N/UI:N/S:U/C:L/I:L/A:N	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	{"9414cb6c-70b2-407f-bb8c-8d53095a04f3": ["0"]}	Need to recheck	0dbc2858-bc39-4c8d-8cb5-b5a43eb38d99	custom	Change the configuration to block access to these files by set in .htaccess\r\n<Files ~ "^\\.(htaccess|htpasswd)$">\r\ndeny from all\r\n</Files>		{"origin_cvss_vector": {"val": "CVSS:3.1/AV:L/AC:L/PR:N/UI:N/S:U/C:L/I:L/A:N", "type": "text"}}	1. Access the htaccess.txt using browser https://pentest-portal.mardi.gov.my/htaccess.txt or https://pentest-portal.mardi.gov.my/htaccess-ori\r\n2. Observe the findings	The server does not properly restrict access to .htaccess and/or .htpasswd files. A remote unauthenticated attacker can download these files and potentially uncover important information.\r\n	https://www.tenable.com/plugins/nessus/106231\r\nhttps://stackoverflow.com/questions/11831698/trying-to-hide-htaccess-file	GET /htaccess.txt HTTP/1.1\r\nHost: pentest-portal.mardi.gov.my\r\nCookie: 4128f9f5b9e70a4061c506a29054b1a9=hnrn0tjtfu4nt0genvo9oeo388; 9e374ee8243494d64d952785ee18a4f0=6rvdbcdpdpsjmd6gt34lt1vqi3\r\nSec-Ch-Ua: "Not-A.Brand";v="99", "Chromium";v="124"\r\nSec-Ch-Ua-Mobile: ?0\r\nSec-Ch-Ua-Platform: "Windows"\r\nUpgrade-Insecure-Requests: 1\r\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.6367.118 Safari/537.36\r\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7\r\nSec-Fetch-Site: none\r\nSec-Fetch-Mode: navigate\r\nSec-Fetch-User: ?1\r\nSec-Fetch-Dest: document\r\nAccept-Encoding: gzip, deflate, br\r\nAccept-Language: en-US,en;q=0.9\r\nPriority: u=0, i\r\nConnection: close\r\n\r\n
2888f910-9591-4c6b-9879-6a6e747cf19b	Joomla XML disclose file and version	Joomla allow joomla.xml file	https://pentest-portal.mardi.gov.my/administrator/manifests/files/joomla.xml	4.3	0	CVSS:3.1/AV:A/AC:L/PR:N/UI:N/S:U/C:L/I:N/A:N	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	{"9414cb6c-70b2-407f-bb8c-8d53095a04f3": ["0"]}	Need to recheck	0dbc2858-bc39-4c8d-8cb5-b5a43eb38d99	custom	Oftenly, the joomla.xml were not used and able to remove the file from server. Alternatively, deny the file from being access by configure .htaccess.\r\n\r\n<Files ~ "^.*">\r\n  Deny from all\r\n</Files>		{}	1. Access the pages https://pentest-portal.mardi.gov.my/administrator/manifests/files/joomla.xml\r\n2. Found all the project structure of the system	Attacker able to gain the file tree and version of plugins used in Joomla	https://forum.joomla.org/viewtopic.php?t=1005483\r\nhttps://forum.joomla.org/viewtopic.php?t=902633	GET /administrator/manifests/files/joomla.xml HTTP/1.1\r\nHost: pentest-portal.mardi.gov.my\r\nCookie: atumSidebarState=open; 4128f9f5b9e70a4061c506a29054b1a9=hnrn0tjtfu4nt0genvo9oeo388; 9e374ee8243494d64d952785ee18a4f0=inrii4ockvao83t6ljm0pt7rbc; _ga=GA1.1.2008948846.1716178257; _ga_W56G32JSEL=GS1.1.1716178256.1.1.1716178455.0.0.0\r\nCache-Control: max-age=0\r\nSec-Ch-Ua: "Not-A.Brand";v="99", "Chromium";v="124"\r\nSec-Ch-Ua-Mobile: ?0\r\nSec-Ch-Ua-Platform: "Windows"\r\nUpgrade-Insecure-Requests: 1\r\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.6367.118 Safari/537.36\r\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7\r\nSec-Fetch-Site: none\r\nSec-Fetch-Mode: navigate\r\nSec-Fetch-User: ?1\r\nSec-Fetch-Dest: document\r\nAccept-Encoding: gzip, deflate, br\r\nAccept-Language: en-US,en;q=0.9\r\nPriority: u=0, i\r\nConnection: close\r\n\r\n
641f6dd3-47f1-4ded-8f2c-d46e4efb9a46	Joomla Administrator Folder disclosure	Joomla able to access the Administrator folder without any authentication	https://pentest-portal.mardi.gov.my/administrator/manifests/files/joomla.xml	3.5	0	CVSS:3.1/AV:A/AC:L/PR:L/UI:N/S:U/C:L/I:N/A:N	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	{"9414cb6c-70b2-407f-bb8c-8d53095a04f3": ["0"]}	Need to recheck	0dbc2858-bc39-4c8d-8cb5-b5a43eb38d99	custom	Implement zero trust by restricting the access to admin folder and allow only specific ip. This can be done by creating .htaccess on root of Administrator and add the following code:\r\n\r\n<Limit GET POST>\r\n order deny,allow\r\n deny from all\r\n allow from 192.168.x.x\r\n</Limit>		{}	1. Access any pages under the /Administrator folder\r\n2. Find any interesting files	Attacker might able to gain personal access like plugins version and information of the system	https://www.itsupportguides.com/knowledge-base/joomla-tips/joomla-how-to-use-htaccess-to-protect-the-administrator-directory/#:~:text=As%20a%20Joomla%20administrator%20one%20of%20the%20simplest,you.%20This%20can%20be%20done%20quite%20easily%20using.htaccess.	GET /administrator/manifests/files/joomla.xml HTTP/1.1\r\nHost: pentest-portal.mardi.gov.my\r\nCookie: atumSidebarState=open; 4128f9f5b9e70a4061c506a29054b1a9=hnrn0tjtfu4nt0genvo9oeo388; 9e374ee8243494d64d952785ee18a4f0=inrii4ockvao83t6ljm0pt7rbc; _ga=GA1.1.2008948846.1716178257; _ga_W56G32JSEL=GS1.1.1716178256.1.1.1716178455.0.0.0\r\nCache-Control: max-age=0\r\nSec-Ch-Ua: "Not-A.Brand";v="99", "Chromium";v="124"\r\nSec-Ch-Ua-Mobile: ?0\r\nSec-Ch-Ua-Platform: "Windows"\r\nUpgrade-Insecure-Requests: 1\r\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.6367.118 Safari/537.36\r\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7\r\nSec-Fetch-Site: none\r\nSec-Fetch-Mode: navigate\r\nSec-Fetch-User: ?1\r\nSec-Fetch-Dest: document\r\nAccept-Encoding: gzip, deflate, br\r\nAccept-Language: en-US,en;q=0.9\r\nPriority: u=0, i\r\nConnection: close\r\n\r\n
b9819023-7a56-4ab4-b809-896c748f9bfa	Directory Listing	Directory listing is a web server function that displays the directory contents when there is no index file in a specific website directory. It is dangerous to leave this function turned on for the web server because it leads to information disclosure.	https://livechat.ptptn.gov.my/assets/	4.7	0	CVSS:3.1/AV:A/AC:L/PR:N/UI:N/S:C/C:L/I:N/A:N	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	{"6f31ce9b-be64-4458-b9a9-5c278bf352e8": ["0"]}	Need to recheck	9dd7d458-5124-4358-943d-8d3bd8f4abe6	custom	There is not usually any good reason to provide directory listings and disabling them may place additional hurdles in the path of an attacker. This can normally be achieved in two ways:\r\n•\tConfigure your web server to prevent directory listings for all paths beneath the web root.\r\n•\tPlace into each directory a default file (such as index.htm) that the web server will display instead of returning a directory listing.\r\n		{}	1. Access the URL , https://livechat.ptptn.gov.my/assets/. \r\n2. Found the Directory listing.	Directory listings themselves do not necessarily constitute a security vulnerability. Any sensitive resources within the web root should in any case be properly access-controlled and should not be accessible by an unauthorized party who happens to know or guess the URL. Even when directory listings are disabled, an attacker may guess the location of sensitive files using automated tools	https://portswigger.net/kb/issues/00600100_directory-listing\r\nhttps://www.acunetix.com/vulnerabilities/web/directory-listings/	GET /assets HTTP/1.1\r\nHost: livechat.ptptn.gov.my\r\nSec-Ch-Ua: "Not-A.Brand";v="99", "Chromium";v="124"\r\nSec-Ch-Ua-Mobile: ?0\r\nSec-Ch-Ua-Platform: "Windows"\r\nUpgrade-Insecure-Requests: 1\r\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.6367.118 Safari/537.36\r\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7\r\nSec-Fetch-Site: none\r\nSec-Fetch-Mode: navigate\r\nSec-Fetch-User: ?1\r\nSec-Fetch-Dest: document\r\nAccept-Encoding: gzip, deflate, br\r\nAccept-Language: en-US,en;q=0.9\r\nPriority: u=0, i\r\nConnection: close\r\n\r\n
5c2583a9-ecc1-42d3-a644-ac07c5d42ade	Error Message Disclose Sensitive information	The application error message discloses sensitive information such as path and line of code.	https://myptptnstg.ptptn.gov.my/PtptnDbService/v2/calculator/saving	5.3	1230	CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:L/I:N/A:N	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	{"944889ce-3165-4363-a55a-b768f8979679": ["0"]}	Need to recheck	9dd7d458-5124-4358-943d-8d3bd8f4abe6	web	Create a custom error pages or show general information like "server encounter error".		{}	1. Access the url\r\n2. Intercept the request and change to any string.\r\n3. Observe the value.	An attacker may user this information to craft exploit to bypass the restriction.	https://www.php.net/manual/en/function.oci-error.php	POST /PtptnDbService/v2/calculator/saving HTTP/2\r\nHost: myptptnstg.ptptn.gov.my\r\nCookie: _gcl_au=1.1.1941488683.1716282160; _fbp=fb.2.1716282160361.486006788; _tt_enable_cookie=1; _ttp=H9hIZLlEoz_TFhHvl2JwGmsBwVe; _ga=GA1.3.1060422940.1716282159; _gid=GA1.3.242300084.1716282161; _gat_gtag_UA_118586866_3=1; _ga_1HV7RSN8YN=GS1.1.1716282158.1.0.1716282161.57.0.0\r\nContent-Length: 42\r\nSec-Ch-Ua: "Not-A.Brand";v="99", "Chromium";v="124"\r\nAccept: application/json, text/plain, */*\r\nContent-Type: application/json\r\nSec-Ch-Ua-Mobile: ?0\r\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.6367.118 Safari/537.36\r\nSec-Ch-Ua-Platform: "Windows"\r\nOrigin: https://myptptnstg.ptptn.gov.my\r\nSec-Fetch-Site: same-origin\r\nSec-Fetch-Mode: cors\r\nSec-Fetch-Dest: empty\r\nReferer: https://myptptnstg.ptptn.gov.my/ptptn/app/saving_calculator\r\nAccept-Encoding: gzip, deflate, br\r\nAccept-Language: en-US,en;q=0.9\r\nPriority: u=1, i\r\n\r\n{"expectedSaving":"7*7","yearPeriod":"11"}
6e3b5986-3760-4bda-b451-fd4ac41851b8	Broken Access Control able to view other loan details	Access control (or authorization) is the application of constraints on who (or what) can perform attempted actions or access resources that they have requested. In the context of web applications, access control is dependent on authentication and session management:\r\n\r\n•\tAuthentication identifies the user and confirms that they are who they say they are.\r\n•\tSession management identifies which subsequent HTTP requests are being made by that same user.\r\n•\tAccess control determines whether the user can carry out the action that they are attempting to perform.\r\n\r\nBroken access controls are a commonly encountered and often critical security vulnerability. Design and management of access controls is a complex and dynamic problem that applies business, organizational, and legal constraints to a technical implementation. Access control design decisions have to be made by humans, not technology, and the potential for errors is high.\r\n	https://myptptnstg.ptptn.gov.my/ptptn/app_api/statement/get_ujrah_details_statement	8.5	0	CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:C/C:H/I:L/A:N	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	{"944889ce-3165-4363-a55a-b768f8979679": ["0"]}	Need to recheck	9dd7d458-5124-4358-943d-8d3bd8f4abe6	web	Access control vulnerabilities can generally be prevented by taking a defense-in-depth approach and applying the following principles:\r\n\r\n•\tNever rely on obfuscation alone for access control.\r\n•\tUnless a resource is intended to be publicly accessible, deny access by default.\r\n•\tWherever possible, use a single application-wide mechanism for enforcing access controls.\r\n•\tAt the code level, make it mandatory for developers to declare the access that is allowed for each resource, and deny access by default.\r\n•\tThoroughly audit and test access controls to ensure they are working as designed.\r\n	"no_mykad":"960506065011"	{}	1. Login using any account.\r\n2. Go to Semakan Penyata\r\n3. View statement\r\n4. Turn on intercept mode and change the year to 2022\r\n5. Change the no_mykad value \r\n6. Able to view the statement of the corresponding mykad	An attacker might be able to perform horizontal and vertical privilege escalation by altering the user to one with additional privileges while bypassing access controls. Other possibilities include exploiting password leakage or modifying parameters once the attacker has landed in the user's accounts page, for example.	https://portswigger.net/web-security/access-control/idor\r\nhttps://www.kiuwan.com/blog/owasp-top-10-2017-a5-broken-access-control\r\nhttps://portswigger.net/web-security/access-control\r\n	POST /ptptn/app_api/statement/get_ujrah_details_statement HTTP/2\r\nHost: myptptnstg.ptptn.gov.my\r\nCookie: JSESSIONID=9FC0EE46E72BAEE61B589150081402BD; _gcl_au=1.1.1941488683.1716282160; _fbp=fb.2.1716282160361.486006788; _tt_enable_cookie=1; _ttp=H9hIZLlEoz_TFhHvl2JwGmsBwVe; _gid=GA1.3.242300084.1716282161; _ga=GA1.3.1060422940.1716282159; _ga_1HV7RSN8YN=GS1.1.1716289473.2.1.1716290171.60.0.0\r\nContent-Length: 64\r\nSec-Ch-Ua: "Not-A.Brand";v="99", "Chromium";v="124"\r\nAccept: application/json, text/plain, */*\r\nContent-Type: application/json;charset=UTF-8\r\nAccept-Language: bm\r\nSec-Ch-Ua-Mobile: ?0\r\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.6367.118 Safari/537.36\r\nSec-Ch-Ua-Platform: "Windows"\r\nOrigin: https://myptptnstg.ptptn.gov.my\r\nSec-Fetch-Site: same-origin\r\nSec-Fetch-Mode: cors\r\nSec-Fetch-Dest: empty\r\nReferer: https://myptptnstg.ptptn.gov.my/ptptn/app/home\r\nAccept-Encoding: gzip, deflate, br\r\nPriority: u=1, i\r\n\r\n{"no_mykad":"960506065011","year":2024,"date_filter":"365 HARI"}
48ea6b42-52bf-4d05-9c07-3a265dfeb0e3	Broken Access Control able to view other loan details	Access control (or authorization) is the application of constraints on who (or what) can perform attempted actions or access resources that they have requested. In the context of web applications, access control is dependent on authentication and session management:\r\n\r\n•\tAuthentication identifies the user and confirms that they are who they say they are.\r\n•\tSession management identifies which subsequent HTTP requests are being made by that same user.\r\n•\tAccess control determines whether the user can carry out the action that they are attempting to perform.\r\n\r\nBroken access controls are a commonly encountered and often critical security vulnerability. Design and management of access controls is a complex and dynamic problem that applies business, organizational, and legal constraints to a technical implementation. Access control design decisions have to be made by humans, not technology, and the potential for errors is high.\r\n	https://myptptn.ptptn.gov.my/ptptn/app_api/statement/get_ujrah_details_statement	8.5	0	CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:C/C:H/I:L/A:N	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	{"487ba141-6c5e-43c9-b698-987d3d43e776": ["0"]}	Need to recheck	9dd7d458-5124-4358-943d-8d3bd8f4abe6	custom	Access control vulnerabilities can generally be prevented by taking a defense-in-depth approach and applying the following principles:\r\n\r\n•\tNever rely on obfuscation alone for access control.\r\n•\tUnless a resource is intended to be publicly accessible, deny access by default.\r\n•\tWherever possible, use a single application-wide mechanism for enforcing access controls.\r\n•\tAt the code level, make it mandatory for developers to declare the access that is allowed for each resource, and deny access by default.\r\n•\tThoroughly audit and test access controls to ensure they are working as designed.\r\n	"no_mykad":"960506065011"	{}	1. Login using any account.\r\n2. Go to Semakan Penyata\r\n3. View statement\r\n4. Turn on intercept mode and change the year to 2022\r\n5. Change the no_mykad value \r\n6. Able to view the statement of the corresponding mykad	An attacker might be able to perform horizontal and vertical privilege escalation by altering the user to one with additional privileges while bypassing access controls. Other possibilities include exploiting password leakage or modifying parameters once the attacker has landed in the user's accounts page, for example.	https://portswigger.net/web-security/access-control/idor\r\nhttps://www.kiuwan.com/blog/owasp-top-10-2017-a5-broken-access-control\r\nhttps://portswigger.net/web-security/access-control\r\n	POST /ptptn/app_api/statement/get_ujrah_details_statement HTTP/2\r\nHost: myptptnstg.ptptn.gov.my\r\nCookie: JSESSIONID=9FC0EE46E72BAEE61B589150081402BD; _gcl_au=1.1.1941488683.1716282160; _fbp=fb.2.1716282160361.486006788; _tt_enable_cookie=1; _ttp=H9hIZLlEoz_TFhHvl2JwGmsBwVe; _gid=GA1.3.242300084.1716282161; _ga=GA1.3.1060422940.1716282159; _ga_1HV7RSN8YN=GS1.1.1716289473.2.1.1716290171.60.0.0\r\nContent-Length: 64\r\nSec-Ch-Ua: "Not-A.Brand";v="99", "Chromium";v="124"\r\nAccept: application/json, text/plain, */*\r\nContent-Type: application/json;charset=UTF-8\r\nAccept-Language: bm\r\nSec-Ch-Ua-Mobile: ?0\r\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.6367.118 Safari/537.36\r\nSec-Ch-Ua-Platform: "Windows"\r\nOrigin: https://myptptn.ptptn.gov.my\r\nSec-Fetch-Site: same-origin\r\nSec-Fetch-Mode: cors\r\nSec-Fetch-Dest: empty\r\nReferer: https://myptptnstg.ptptn.gov.my/ptptn/app/home\r\nAccept-Encoding: gzip, deflate, br\r\nPriority: u=1, i\r\n\r\n{"no_mykad":"960506065011","year":2024,"date_filter":"365 HARI"}
db85870a-ce69-409b-8c50-429339ffb8a5	Server Header Disclosure	The remote web server discloses information via HTTP headers.	https://gateway.n9pay.ns.gov.my/	4.3	0	CVSS:3.1/AV:A/AC:L/PR:N/UI:N/S:U/C:L/I:N/A:N	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	{"cc6b635a-0804-4c48-a8fe-cd79e08cd910": ["0"]}	Need to recheck	af66f73f-15ab-4c1e-8537-ef381a0a6025	custom	Modify the HTTP headers of the web server to not disclose detailed information about the underlying web server.		{}	1. Access to whatweb with gateway url\r\n2. Observe the result	The HTTP headers sent by the remote web server disclose information that can aid an attacker, such as the server version and languages used by the web server. 	https://techcommunity.microsoft.com/t5/iis-support-blog/remove-unwanted-http-response-headers/ba-p/369710	GET / HTTP/1.1\r\nHost: gateway.n9pay.ns.gov.my\r\nCookie: x-bni-fpc=f429346e06ac6deba76d3ae620a9407c; x-bni-rncf=1716442966749\r\nCache-Control: max-age=0\r\nSec-Ch-Ua: "Not-A.Brand";v="99", "Chromium";v="124"\r\nSec-Ch-Ua-Mobile: ?0\r\nSec-Ch-Ua-Platform: "Windows"\r\nUpgrade-Insecure-Requests: 1\r\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.6367.118 Safari/537.36\r\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7\r\nSec-Fetch-Site: same-origin\r\nSec-Fetch-Mode: navigate\r\nSec-Fetch-User: ?1\r\nSec-Fetch-Dest: document\r\nAccept-Encoding: gzip, deflate, br\r\nAccept-Language: en-US,en;q=0.9\r\nIf-None-Match: "664a6983-46c"\r\nIf-Modified-Since: Sun, 19 May 2024 21:05:07 GMT\r\nPriority: u=0, i\r\nConnection: close\r\n\r\n
4b97a2b8-4326-498d-a8fb-f52dc4b74927	Broken Access Control able to View other user Identity	Access control (or authorization) is the application of constraints on who (or what) can perform attempted actions or access resources that they have requested. In the context of web applications, access control is dependent on authentication and session management:\r\n\r\n•\tAuthentication identifies the user and confirms that they are who they say they are.\r\n•\tSession management identifies which subsequent HTTP requests are being made by that same user.\r\n•\tAccess control determines whether the user can carry out the action that they are attempting to perform.\r\n\r\nBroken access controls are a commonly encountered and often critical security vulnerability. Design and management of access controls is a complex and dynamic problem that applies business, organizational, and legal constraints to a technical implementation. Access control design decisions have to be made by humans, not technology, and the potential for errors is high.\r\n	https://e4.mygpki.gov.my/gpki_api/api/user/get_user_identity?data=eyJucmljIjoiODgwMjEwMTQxMjE4IiwidXNlclR5cGUiOiJHcGtpTWFuYWdlclVzZXIiLCJtZWRpdW1UeXBlSWQiOjN9	8.5	0	CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:C/C:H/I:L/A:N	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	{"66f64b3b-962a-44e2-a1f1-48f630e48040": ["0"]}	Need to recheck	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398	custom	Access control vulnerabilities can generally be prevented by taking a defense-in-depth approach and applying the following principles:\r\n\r\n•\tNever rely on obfuscation alone for access control.\r\n•\tUnless a resource is intended to be publicly accessible, deny access by default.\r\n•\tWherever possible, use a single application-wide mechanism for enforcing access controls.\r\n•\tAt the code level, make it mandatory for developers to declare the access that is allowed for each resource, and deny access by default.\r\n•\tThoroughly audit and test access controls to ensure they are working as designed.\r\n	data	{}	1. Intercept any normal user account. For this testing, normal user is Uatuser7.\r\n2. Change the IC value on data parameter.\r\n3. Observe the result	An attacker might be able to perform horizontal and vertical privilege escalation by altering the user to one with additional privileges while bypassing access controls. Other possibilities include exploiting password leakage or modifying parameters once the attacker has landed in the user's accounts page, for example.	https://portswigger.net/web-security/access-control/idor\r\nhttps://www.kiuwan.com/blog/owasp-top-10-2017-a5-broken-access-control\r\nhttps://portswigger.net/web-security/access-control\r\n	GET /gpki_api/api/user/get_user_identity?data=eyJucmljIjoiODgwMjEwMTQxMjE4IiwidXNlclR5cGUiOiJHcGtpTWFuYWdlclVzZXIiLCJtZWRpdW1UeXBlSWQiOjN9 HTTP/1.1\r\nHost: e4.mygpki.gov.my\r\nSec-Ch-Ua: "Android WebView";v="125", "Chromium";v="125", "Not.A/Brand";v="24"\r\nAccept: application/json, text/plain, */*\r\nSec-Ch-Ua-Mobile: ?1\r\nAuthorization: Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI4ODAyMTAxNDEyMDciLCJhdWRpZW5jZSI6Im1vYmlsZSIsImNyZWF0ZWQiOjE3MTY3MjU3NjcxNDQsImV4cCI6MTcxNjcyNzU2N30.quqbAJm1-J3yE3gFo4GQduNEN5vknlFth5C0H20fK3LBvG35wefNyk2SOgaWfv0k1BQEJ3VO6st8pC9Du3U4zg\r\nUser-Agent: Mozilla/5.0 (Linux; Android 14; Pixel 6a Build/UQ1A.240205.004.B1; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/125.0.6422.82 Mobile Safari/537.36\r\nSec-Ch-Ua-Platform: "Android"\r\nOrigin: http://localhost\r\nX-Requested-With: com.my.posdigicert.GPKIMobileClient\r\nSec-Fetch-Site: cross-site\r\nSec-Fetch-Mode: cors\r\nSec-Fetch-Dest: empty\r\nReferer: http://localhost/\r\nAccept-Encoding: gzip, deflate, br\r\nAccept-Language: en-MY,en;q=0.9,ms-MY;q=0.8,ms;q=0.7,en-US;q=0.6\r\nPriority: u=1, i\r\nConnection: keep-alive\r\n\r\n
b79394a3-33f4-4745-b454-d15d41c01e71	Broken Access Control able to view other Profile	Access control (or authorization) is the application of constraints on who (or what) can perform attempted actions or access resources that they have requested. In the context of web applications, access control is dependent on authentication and session management:\r\n\r\n•\tAuthentication identifies the user and confirms that they are who they say they are.\r\n•\tSession management identifies which subsequent HTTP requests are being made by that same user.\r\n•\tAccess control determines whether the user can carry out the action that they are attempting to perform.\r\n\r\nBroken access controls are a commonly encountered and often critical security vulnerability. Design and management of access controls is a complex and dynamic problem that applies business, organizational, and legal constraints to a technical implementation. Access control design decisions have to be made by humans, not technology, and the potential for errors is high.\r\n	https://e4.mygpki.gov.my/gpki_api/api/user/get_contact_info?data=eyJucmljIjoiODgwMjEwMTQxMjA2IiwibnJpYyI6Ijg4MDIxMDE0MTIwNiIsInVzZXJUeXBlIjoid3cifQ%3d%3d	8.5	0	CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:C/C:H/I:L/A:N	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	{"66f64b3b-962a-44e2-a1f1-48f630e48040": ["0"]}	Need to recheck	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398	custom	Access control vulnerabilities can generally be prevented by taking a defense-in-depth approach and applying the following principles:\r\n\r\n•\tNever rely on obfuscation alone for access control.\r\n•\tUnless a resource is intended to be publicly accessible, deny access by default.\r\n•\tWherever possible, use a single application-wide mechanism for enforcing access controls.\r\n•\tAt the code level, make it mandatory for developers to declare the access that is allowed for each resource, and deny access by default.\r\n•\tThoroughly audit and test access controls to ensure they are working as designed.\r\n	data	{}	1. Access the profile user.\r\n2. Change the IC value. Also add random value on userType var\r\n3. observe the value	An attacker might be able to perform horizontal and vertical privilege escalation by altering the user to one with additional privileges while bypassing access controls. Other possibilities include exploiting password leakage or modifying parameters once the attacker has landed in the user's accounts page, for example.	https://portswigger.net/web-security/access-control/idor\r\nhttps://www.kiuwan.com/blog/owasp-top-10-2017-a5-broken-access-control\r\nhttps://portswigger.net/web-security/access-control\r\n	GET /gpki_api/api/user/get_contact_info?data=eyJucmljIjoiODgwMjEwMTQxMjA2IiwibnJpYyI6Ijg4MDIxMDE0MTIwNiIsInVzZXJUeXBlIjoid3cifQ%3d%3d HTTP/1.1\r\nHost: e4.mygpki.gov.my\r\nSec-Ch-Ua: "Android WebView";v="125", "Chromium";v="125", "Not.A/Brand";v="24"\r\nAccept: application/json, text/plain, */*\r\nSec-Ch-Ua-Mobile: ?1\r\nAuthorization: Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI4ODAyMTAxNDEyMDciLCJhdWRpZW5jZSI6Im1vYmlsZSIsImNyZWF0ZWQiOjE3MTY3MzI2OTYzNjcsImV4cCI6MTcxNjczNDQ5Nn0.hw27AIWu0BgK9Ps6rThpZn5spPnd4j52a-QeoDIBv6d-8UQbq6hrx2RzJBxdZW-MlPtFGlknqn4ctudXFaYF1g\r\nUser-Agent: Mozilla/5.0 (Linux; Android 14; Pixel 6a Build/UQ1A.240205.004.B1; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/125.0.6422.82 Mobile Safari/537.36\r\nSec-Ch-Ua-Platform: "Android"\r\nOrigin: http://localhost\r\nX-Requested-With: com.my.posdigicert.GPKIMobileClient\r\nSec-Fetch-Site: cross-site\r\nSec-Fetch-Mode: cors\r\nSec-Fetch-Dest: empty\r\nReferer: http://localhost/\r\nAccept-Encoding: gzip, deflate, br\r\nAccept-Language: en-MY,en;q=0.9,ms-MY;q=0.8,ms;q=0.7,en-US;q=0.6\r\nPriority: u=1, i\r\nConnection: keep-alive\r\n\r\n
36c92989-4290-4186-a6d9-f205eb6fa3b1	Excessive data on Response leads to sensitive data exposure	This vulnerability is highlighted by the Open Web Application Security Project (OWASP). The API developer sends more data than required to the client. The client-side has to filter the information to show it to the user, thus leaving a lot of unused data. 	https://e4.mygpki.gov.my/gpki_api/api/register/retrieve_email?data=eyJucmljIjoiODgwMjEwMTQxMjM1IiwicGhvbmVObyI6IjU1NSIsImNhcHRjaGEiOiIwM0FGY1dlQTdTM21UUmN4cUN0UnhadDhYN2RreU5ZdFlrbTVQdDNSdDgxUFN3MTU1VHJ5MzdlejllUTRMZjRRa1BUU3RNWDVDTG1ZcmdDUWVMaXRlMWRoV0FCeHBPdnBEck8xb3FQTVhUUTlpdWRjclB0NUw0RTNvSG5sWEp2amptOGRhWElmbm03X1htby0xcUFUSUt1Sm1RV3ZSZ1ZiSzhWU19OWE1hSnV3ZVZSdjlIQUQ2QTMyMjFXckNSWHpYb19MaEduYnEwanRsM2s1dWV6ckl2bkk5R3pzVS12QUNnWmpQZ1NleW5RR1FkQi1CX01qWnNCZWEtdHZDY3VDR1p3ajBqdmhUMkl1NHZmd0p4enJhcU1PMVU2QWdaSDlNeXBRQmtBR1hIT3VzU2hnQVJ1UHZyRnJGUXJ6VzgySzZzM1FQNDVvZzlCX0VJWkVaemVUQi1mN29HNFV1RzVOMFlPNDRTUWVZbURlcjBfY3lyZkVqanQwRElYSnptb2IyUDZJQnVSeURBbEpCYkdiQ3hMbk9hOGFuMkhNaTNNdy1NNlRvNU94cUVqSzk5X3BOVGo3dmk4Q3ZOejlzekJhTGJ4enU3d0l2ZDFmXzZkTkNlVkpXeFNiRmt4aThNLWl1ZTBKQjNrNUFtelpwbndtOHpTYmw3WVkzLU9DczZvYTFYS1JNeUFzOWc2MDBfOEt0YUgwemdfejNKMnN4QWRMeG5Qa1dvS2NfNTBjZlp3SkdaTXE1cHhVSEtzNDZ4bmJXM1lZbHhkSHFuRW1XVTBtaGZwdWpXczJZYnp1clNPOFhnWDJsV2g5aGE0UElDTC1fU2JFaXgwNk0tWC0xRTBGZ1Yya2Vkbng5ODlVMzBySEd5Rk9IeXNvVXY0Tk1meXB1elpWemlScUpycEJ3VmtDamtyLXdock11N3A3cVlNcGVzb0pDRFNKcXVSdEhhTTFJa2EtaDhIenl5cGpYMVg4emdxMllJSkluY3o2TlhFSTJtV2JSWEwyLTROeUZ0TGkyYnk0aExCUnFvMEtBNXZnNVdvWWxJVkNUdFJLRFZtc3lXQW5vd0hXbjZkeXdsdnV5cWpFd0xncVZhTVlvZWp6M1B4bWt0R0N6eEVFVHAwSXQyMldUZTJhYnBUZmN1LU15ckI5dm5OYVZGdk8zMUpwRnFZbXZpcVM1RTdBc2JuWHBUY0lCY2dnTlR5QVpxVW1JQmFXeFZxZGpDcHF1ZENuTFR4dzJLRHFVdzRqdEcybnFGVjd0Vm5TdjFCcTBYb2pCSWZ0NHo5b1JzVTFuN2VCNWUzVElDbEhiLWFYQU8wbjNzdGRabzAtVG9NTDdDUUN0cWcwUFJSNnduSmk2U25kZUxXZm1xRHo5Tl9aazRJLXB2WmpWQVBDM2U5VWlUdmE4YlAyQjZPM1VQZ3RiS1pEY19wclBhUmhOV1VxNExfTXNwMFJ6SHhuRC11R1MwWUpJbnB2TTdUb2o4SnFfU3U0UW1rREFjNkE2SmVqaEpPaEU2bFZWbXNrcXZWSjVtcEhxVEtRTHpZcndCZUNNZktRNEtSbUdxanlUWVZGS3RYRnBGVzNIRHNQTXFmOTBsQ1RaQnljV3NrQ0J6aWhTVWVuT2prcnFPUy1LVlRsVl9fbWt4VjNUZXVKU2ZoRTZlYy1QTWpQMTB4MUtGMkxHQzBJNUYxMGRfWFdaY2hOdHhsX0l1RDRRekVJdTRjTTl5dTVhZllpMjR5S1E0dW9yT1RNM3cxemlsMExrZU5TOF9QM3RucjhXQzg4anc3NVJCeFhMOWw4MXZ3V1V2ajAyLXhWSWliWGZ2V0xRMU9vaDhPNFJCbklCOWx4elBiQmRRRVpfc3lIbFFzZ3RqQ0xRdHdHTTBMNnpUeEZsUGd0OXRPZ1dJME9oRUkzdkFnZnNWd21yeldUTFphSnZWZ3lfeFBkcFlXbXJkN3o5LVk0aHRmX0JrX083YXFiQW8xcHkzenBWRm16WXFNbTVIREpfSGU5U2YxWGtpZW5VNF9pV25QS0lHc2hxSk03SGhZVWd4V0x3Qm54U1FMbURsVEhNV19PaE4xYmJWT3NDYXZKcVdTMDhSbEtSNWJsYnU3Q1BCMGpJSFVQa1ZlM2pMVW01bDQ5SjRtUE9VdVhEYWVYUEV5VEFVOHBlSU5fQkJfSDc3R0pLME81ZkRLbjFkR1JOWWZ5YmxBZGNFMV9BS19fczRnLWVNQ1d4Y3RTT0hvWm5pMDJUWGpadlE1cmhNUkFXQlhxZEc4bHlYZnozcDEydmYtTjJqSmthSWRmYXBSbUxYeENXSnRKYkRfeVAtbUlPSjVvZUxmNmROcXNDbE5mbFJHYzRUc0ZKOWZOeHJIUndsRHgxY2h4XzdWOTJHOVUwT1BIaEpXcWR5Z2cxQ2l3RjE5SlduSDdDTHkyUkZSdi1la0sySnZ6NmNWdHVZYUhWSkowb1F6WVVwVXMxYUdfLXhGdHFMU0prZk42bUNqS05xUUstZ183U2VmbnlXWUc5bXlTV3VRT1VrTEVEdENVTnptSnJ5Wk1MR0VTWU52N3RSNDJUMmo0bU1vTXFnTGV3ZWU4OWxaeDJzRUhWUlV6TFR0Wk9xWWk5UXZiZUgxWlRyMjVVc3NLWlQxN3E3X1pHYnY3QW1seDg3ZXNSYkVHV3JXRTlMZFlPZHFIcEdmMThzTXdidFVNTFhhUEZmVTduRmVfaS1XYmpuUDJURDZQcnZTTmdWeWdsNXRWeXB1SGJ5MWVxUzhITGNXQW8wb1dSc3RTMldpRDg3RllaY0FxVFhKQlg4LWh2c0pUU3BhdFktc25Cb0JkVThURHR5bGJQOEVKaW5Pd0cyVEVlSDYzWEdraTQ0aFEifQ==	7.5	0	CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:N/A:N	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	{"66f64b3b-962a-44e2-a1f1-48f630e48040": ["0"]}	Need to recheck	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398	custom	1. Instead of relying on the client-side to filter the data, this operation should be performed on the server before sending the data. The client-side should only take the data and render it on the screen.\r\n\r\n2. Another thing that you can do is to ensure only the data the client has requested is sent to them. You are not sending any unnecessary information.\r\n\r\n3. To ensure that you are not sending sensitive data, you can also categorize your data as admin, personal, or sensitive information.	data	{}	1. Enter any valid IC.\r\n2. Before process of verifying the user via email, the server already show the user profile details on response\r\n	The man-in-the-middle is the most common attack that can exploit this information as the data can be intercepted by the unwanted personnel when it is in transit. The data can later be used to perform different actions on the website. It can be sold to the highest bidder.	https://rapidapi.com/guides/excessive-data-exposure\r\nhttps://owasp.org/API-Security/editions/2019/en/0xa3-excessive-data-exposure/	GET /gpki_api/api/register/retrieve_email?data=eyJucmljIjoiODgwMjEwMTQxMjM1IiwicGhvbmVObyI6IjU1NSIsImNhcHRjaGEiOiIwM0FGY1dlQTdTM21UUmN4cUN0UnhadDhYN2RreU5ZdFlrbTVQdDNSdDgxUFN3MTU1VHJ5MzdlejllUTRMZjRRa1BUU3RNWDVDTG1ZcmdDUWVMaXRlMWRoV0FCeHBPdnBEck8xb3FQTVhUUTlpdWRjclB0NUw0RTNvSG5sWEp2amptOGRhWElmbm03X1htby0xcUFUSUt1Sm1RV3ZSZ1ZiSzhWU19OWE1hSnV3ZVZSdjlIQUQ2QTMyMjFXckNSWHpYb19MaEduYnEwanRsM2s1dWV6ckl2bkk5R3pzVS12QUNnWmpQZ1NleW5RR1FkQi1CX01qWnNCZWEtdHZDY3VDR1p3ajBqdmhUMkl1NHZmd0p4enJhcU1PMVU2QWdaSDlNeXBRQmtBR1hIT3VzU2hnQVJ1UHZyRnJGUXJ6VzgySzZzM1FQNDVvZzlCX0VJWkVaemVUQi1mN29HNFV1RzVOMFlPNDRTUWVZbURlcjBfY3lyZkVqanQwRElYSnptb2IyUDZJQnVSeURBbEpCYkdiQ3hMbk9hOGFuMkhNaTNNdy1NNlRvNU94cUVqSzk5X3BOVGo3dmk4Q3ZOejlzekJhTGJ4enU3d0l2ZDFmXzZkTkNlVkpXeFNiRmt4aThNLWl1ZTBKQjNrNUFtelpwbndtOHpTYmw3WVkzLU9DczZvYTFYS1JNeUFzOWc2MDBfOEt0YUgwemdfejNKMnN4QWRMeG5Qa1dvS2NfNTBjZlp3SkdaTXE1cHhVSEtzNDZ4bmJXM1lZbHhkSHFuRW1XVTBtaGZwdWpXczJZYnp1clNPOFhnWDJsV2g5aGE0UElDTC1fU2JFaXgwNk0tWC0xRTBGZ1Yya2Vkbng5ODlVMzBySEd5Rk9IeXNvVXY0Tk1meXB1elpWemlScUpycEJ3VmtDamtyLXdock11N3A3cVlNcGVzb0pDRFNKcXVSdEhhTTFJa2EtaDhIenl5cGpYMVg4emdxMllJSkluY3o2TlhFSTJtV2JSWEwyLTROeUZ0TGkyYnk0aExCUnFvMEtBNXZnNVdvWWxJVkNUdFJLRFZtc3lXQW5vd0hXbjZkeXdsdnV5cWpFd0xncVZhTVlvZWp6M1B4bWt0R0N6eEVFVHAwSXQyMldUZTJhYnBUZmN1LU15ckI5dm5OYVZGdk8zMUpwRnFZbXZpcVM1RTdBc2JuWHBUY0lCY2dnTlR5QVpxVW1JQmFXeFZxZGpDcHF1ZENuTFR4dzJLRHFVdzRqdEcybnFGVjd0Vm5TdjFCcTBYb2pCSWZ0NHo5b1JzVTFuN2VCNWUzVElDbEhiLWFYQU8wbjNzdGRabzAtVG9NTDdDUUN0cWcwUFJSNnduSmk2U25kZUxXZm1xRHo5Tl9aazRJLXB2WmpWQVBDM2U5VWlUdmE4YlAyQjZPM1VQZ3RiS1pEY19wclBhUmhOV1VxNExfTXNwMFJ6SHhuRC11R1MwWUpJbnB2TTdUb2o4SnFfU3U0UW1rREFjNkE2SmVqaEpPaEU2bFZWbXNrcXZWSjVtcEhxVEtRTHpZcndCZUNNZktRNEtSbUdxanlUWVZGS3RYRnBGVzNIRHNQTXFmOTBsQ1RaQnljV3NrQ0J6aWhTVWVuT2prcnFPUy1LVlRsVl9fbWt4VjNUZXVKU2ZoRTZlYy1QTWpQMTB4MUtGMkxHQzBJNUYxMGRfWFdaY2hOdHhsX0l1RDRRekVJdTRjTTl5dTVhZllpMjR5S1E0dW9yT1RNM3cxemlsMExrZU5TOF9QM3RucjhXQzg4anc3NVJCeFhMOWw4MXZ3V1V2ajAyLXhWSWliWGZ2V0xRMU9vaDhPNFJCbklCOWx4elBiQmRRRVpfc3lIbFFzZ3RqQ0xRdHdHTTBMNnpUeEZsUGd0OXRPZ1dJME9oRUkzdkFnZnNWd21yeldUTFphSnZWZ3lfeFBkcFlXbXJkN3o5LVk0aHRmX0JrX083YXFiQW8xcHkzenBWRm16WXFNbTVIREpfSGU5U2YxWGtpZW5VNF9pV25QS0lHc2hxSk03SGhZVWd4V0x3Qm54U1FMbURsVEhNV19PaE4xYmJWT3NDYXZKcVdTMDhSbEtSNWJsYnU3Q1BCMGpJSFVQa1ZlM2pMVW01bDQ5SjRtUE9VdVhEYWVYUEV5VEFVOHBlSU5fQkJfSDc3R0pLME81ZkRLbjFkR1JOWWZ5YmxBZGNFMV9BS19fczRnLWVNQ1d4Y3RTT0hvWm5pMDJUWGpadlE1cmhNUkFXQlhxZEc4bHlYZnozcDEydmYtTjJqSmthSWRmYXBSbUxYeENXSnRKYkRfeVAtbUlPSjVvZUxmNmROcXNDbE5mbFJHYzRUc0ZKOWZOeHJIUndsRHgxY2h4XzdWOTJHOVUwT1BIaEpXcWR5Z2cxQ2l3RjE5SlduSDdDTHkyUkZSdi1la0sySnZ6NmNWdHVZYUhWSkowb1F6WVVwVXMxYUdfLXhGdHFMU0prZk42bUNqS05xUUstZ183U2VmbnlXWUc5bXlTV3VRT1VrTEVEdENVTnptSnJ5Wk1MR0VTWU52N3RSNDJUMmo0bU1vTXFnTGV3ZWU4OWxaeDJzRUhWUlV6TFR0Wk9xWWk5UXZiZUgxWlRyMjVVc3NLWlQxN3E3X1pHYnY3QW1seDg3ZXNSYkVHV3JXRTlMZFlPZHFIcEdmMThzTXdidFVNTFhhUEZmVTduRmVfaS1XYmpuUDJURDZQcnZTTmdWeWdsNXRWeXB1SGJ5MWVxUzhITGNXQW8wb1dSc3RTMldpRDg3RllaY0FxVFhKQlg4LWh2c0pUU3BhdFktc25Cb0JkVThURHR5bGJQOEVKaW5Pd0cyVEVlSDYzWEdraTQ0aFEifQ== HTTP/1.1\r\nHost: e4.mygpki.gov.my\r\nAccept: application/json, text/plain, */*\r\nUser-Agent: Mozilla/5.0 (Linux; Android 14; Pixel 6a Build/UQ1A.240205.004.B1; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/116.0.0.0 Mobile Safari/537.36\r\nOrigin: http://localhost\r\nX-Requested-With: com.my.posdigicert.GPKIMobileClient\r\nSec-Fetch-Site: cross-site\r\nSec-Fetch-Mode: cors\r\nSec-Fetch-Dest: empty\r\nReferer: http://localhost/\r\nAccept-Encoding: gzip, deflate, br\r\nAccept-Language: en-MY,en;q=0.9,ms-MY;q=0.8,ms;q=0.7,en-US;q=0.6\r\nConnection: keep-alive\r\n\r\n
24462a62-644a-4daf-bfd1-d4f774e1e5aa	Hardcoded Credentials	The application store the hardcorded credentials that able to being viewed by anyone.	File = res/values/strings.xml	4.3	0	CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:L/I:N/A:N	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	{"66f64b3b-962a-44e2-a1f1-48f630e48040": ["0"]}	Need to recheck	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398	custom	Properly store the credentials/key to save place. For Android apk, store the key on gradle.properties 	google_api_key, google_crash_reporting_api_key, 	{}	1. Decode the apk file using apktools (apktools d test.apk)\r\n2. Read the res/values/strings.xml \r\n3, Key was displayed on hardcoded strings.	Attacker might able to use the credentials or key to access sensitive information or overcharged the billing.	https://stefma.medium.com/something-about-google-api-keys-how-to-secure-them-and-what-firebase-got-to-do-with-this-e10473637ed3\r\nhttps://medium.com/@dugguRK/secure-android-api-keys-f865b344808c	Not Applicable
bb71f411-7493-4275-bbc8-fe98b19deaa6	Android Debug mode enabled	The android:debuggable attribute sets whether the application is debuggable. It is set for the application as a whole and can not be overridden by individual components. The attribute is set to false by default.	AndroidManifest.xml File	3.5	0	CVSS:3.1/AV:A/AC:L/PR:L/UI:N/S:U/C:L/I:N/A:N	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	{"66f64b3b-962a-44e2-a1f1-48f630e48040": ["0"]}	Need to recheck	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398	custom	Always make sure to set the android:debuggable flag to false when shipping your application.	<uses-permission android:name="com.my.posdigicert.GPKIMobileClient.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION"/> < android:debuggable="true"	{}	1. Decode the APK using apktools\r\n2. Read the AndroidManifest.xml\r\n3. search for "debug" strings.	Allowing the application to be debuggable in itself is not a vulnerability, but it does expose the application to greater risk through unintended and unauthorized access to administrative functions. This can allow attackers more access to the application and resources used by the application than intended.\r\n\r\nSetting the android:debuggable flag to true enables an attacker to debug the application, making it easier for them to gain access to parts of the application that should be kept secure.	https://developer.android.com/privacy-and-security/risks/android-debuggable#:~:text=Allowing%20the%20application%20to%20be%20debuggable%20in%20itself,and%20resources%20used%20by%20the%20application%20than%20intended.	Not Applicable
\.


--
-- Data for Name: issuetemplates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.issuetemplates (id, tpl_name, name, description, url_path, cvss, cwe, cve, status, type, fix, param, fields, variables, user_id, team_id, technical, risks, "references", intruder) FROM stdin;
41a72c52-fadc-4f06-80f0-a8746bcf9b57	Unathenticated SQL Injection	Unauthenticate SQL injection	SQL injection is a web security vulnerability that allows an attacker to interfere with the queries that an application makes to its database. It generally allows an attacker to view data that they are not normally able to retrieve. This might include data belonging to other users, or any other data that the application itself is able to access. In many cases, an attacker can modify or delete this data, causing persistent changes to the application's content or behaviour.		9.5	0	CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:C/C:H/I:H/A:H	Need to recheck	web	Most instances of SQL injection can be prevented by using parameterized queries (also known as prepared statements) instead of string concatenation within the query.\r\nThe following code is vulnerable to SQL injection because the user input is concatenated directly into the query:\r\n\r\nString query = "SELECT * FROM products WHERE category = '"+ input + "'";\r\nStatement statement = connection.createStatement();\r\nResultSet resultSet = statement.executeQuery(query);\r\nThis code can be easily rewritten in a way that prevents the user input from interfering with the query structure:\r\nPreparedStatement statement = connection.prepareStatement("SELECT * FROM products WHERE category = ?");\r\nstatement.setString(1, input);\r\nResultSet resultSet = statement.executeQuery();\r\n\r\nParameterized queries can be used for any situation where untrusted input appears as data within the query, including the WHERE clause and values in an INSERT or UPDATE statement. They cannot be used to handle untrusted input in other parts of the query, such as table or column names, or the ORDER BY clause. Application functionality that places untrusted data into those parts of the query will need to take a different approach, such as white listing permitted input values, or using different logic to deliver the required behaviour.\r\n\r\nFor a parameterized query to be effective in preventing SQL injection, the string that is used in the query must always be a hard-coded constant and must never contain any variable data from any origin. Do not be tempted to decide case-by-case whether an item of data is trusted and continue using string concatenation within the query for cases that are considered safe. It is all too easy to make mistakes about the possible origin of data, or for changes in other code to violate assumptions about what data is tainted.\r\n		{}	{}	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c			A successful SQL injection attack can result in unauthorized access to sensitive data, such as passwords, credit card details, or personal user information. Many high-profile data breaches in recent years have been the result of SQL injection attacks, leading to reputational damage and regulatory fines. In some cases, an attacker can obtain a persistent backdoor into an organization's systems, leading to a long-term compromise that can go unnoticed for an extended period.	https://portswigger.net/web-security/sql-injection\r\nhttps://www.acunetix.com/websitesecurity/sql-injection/	
667bdd67-b12d-4ce7-bbdf-ebceec01b35c	Directory Listing	Directory Listing	Directory listing is a web server function that displays the directory contents when there is no index file in a specific website directory. It is dangerous to leave this function turned on for the web server because it leads to information disclosure.		4.7	0	CVSS:3.1/AV:A/AC:L/PR:N/UI:N/S:C/C:L/I:N/A:N	Need to recheck	custom	There is not usually any good reason to provide directory listings and disabling them may place additional hurdles in the path of an attacker. This can normally be achieved in two ways:\r\n•\tConfigure your web server to prevent directory listings for all paths beneath the web root.\r\n•\tPlace into each directory a default file (such as index.htm) that the web server will display instead of returning a directory listing.\r\n		{}	{}	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c			Directory listings themselves do not necessarily constitute a security vulnerability. Any sensitive resources within the web root should in any case be properly access-controlled and should not be accessible by an unauthorized party who happens to know or guess the URL. Even when directory listings are disabled, an attacker may guess the location of sensitive files using automated tools	https://portswigger.net/kb/issues/00600100_directory-listing\r\nhttps://www.acunetix.com/vulnerabilities/web/directory-listings/	
d77ea433-8cf9-4ef7-8e61-02f8c0b47354	Cross Site Scripting (XSS)	Cross Site Scripting (XSS)	Cross-site scripting (also known as XSS) is a web security vulnerability that allows an attacker to compromise the interactions that users have with a vulnerable application. It allows an attacker to circumvent the same origin policy, which is designed to segregate different websites from each other. Cross-site scripting vulnerabilities normally allow an attacker to masquerade as a victim user, to carry out any actions that the user is able to perform, and to access any of the user's data. If the victim user has privileged access within the application, then the attacker might be able to gain full control over all of the application's functionality and data.		8.3	0		Need to recheck	custom	Preventing cross-site scripting is trivial in some cases but can be much harder depending on the complexity of the application and the ways it handles user-controllable data.\r\nIn general, effectively preventing XSS vulnerabilities is likely to involve a combination of the following measures:\r\nFilter input on arrival. At the point where user input is received, filter as strictly as possible based on what is expected or valid input.\r\nEncode data on output. At the point where user-controllable data is output in HTTP responses, encode the output to prevent it from being interpreted as active content. Depending on the output context, this might require applying combinations of HTML, URL, JavaScript, and CSS encoding.\r\nUse appropriate response headers. To prevent XSS in HTTP responses that are not intended to contain any HTML or JavaScript, you can use the Content-Type and X-Content-Type-Options headers to ensure that browsers interpret the responses in the way you intend.\r\nContent Security Policy. As a last line of defence, you can use Content Security Policy (CSP) to reduce the severity of any XSS vulnerabilities that still occur.\r\n		{}	{}	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c			Cross-site scripting works by manipulating a vulnerable web site so that it returns malicious JavaScript to users. When the malicious code executes inside a victim's browser, the attacker can fully compromise their interaction with the application.	https://portswigger.net/web-security/cross-site-scripting	
9d3431b5-c597-4496-9f9c-613faba56e94	Insecure File Upload	Insecure File Upload	Uploaded files represent a significant risk to applications. The first step in many attacks is to get some code to the system to be attacked. Then the attack only needs to find a way to get the code executed. Using a file upload helps the attacker accomplish the first step.		0	0		Need to recheck	custom	Restrict file types accepted for upload: check the file extension and only allow certain files to be uploaded. Use a whitelist approach instead of a blacklist. Check for double extensions such as .php.png. Check for files without a filename like .htaccess (on ASP.NET, check for configuration files like web.config). Change the permissions on the upload folder so the files within it are not executable. If possible, rename the files that are uploaded.		{}	{}	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c			1. Server-side attacks: The web server can be compromised by uploading and executing a web-shell which can run commands, browse system files, browse local resources, attack other servers, or exploit the local vulnerabilities, and so forth.\r\n\r\n2. Client-side attacks: Uploading malicious files can make the website vulnerable to client-side attacks such as XSS or Cross-site Content Hijacking.\r\n\r\n3. Uploaded files can be abused to exploit other vulnerable sections of an application when a file on the same or a trusted server is needed (can again lead to client-side or server-side attacks)\r\n\r\n4.  A malicious file such as a Unix shell script, a windows virus, an Excel file with a dangerous formula, or a reverse shell can be uploaded on the server in order to execute code by an administrator or webmaster later – on the victim’s machine.\r\n\r\n5. An attacker might be able to put a phishing page into the website or deface the website.\r\n	https://owasp.org/www-community/vulnerabilities/Unrestricted_File_Upload	
458a828a-f5b9-48f9-9343-6262f5b4d246	File Information Disclosure	File Information Disclosure	An information disclosure vulnerability exists in the remote web server due to the disclosure of the web.config file. An unauthenticated, remote attacker can exploit this, via a simple GET request, to disclose potentially sensitive configuration information.		0	0		Need to recheck	custom	Declare this rule on .htaccess. For Examples:\r\n\r\n<files filename.ext>\r\n         order allow,deny\r\n         deny from all\r\n</files>		{}	{}	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c			An unauthenticated, remote attacker can exploit this file, via a simple GET request, to disclose potentially sensitive configuration information.	https://wordpress.stackexchange.com/questions/5400/prevent-access-or-auto-delete-readme-html-license-txt-wp-config-sample-php\r\nhttps://stackoverflow.com/questions/11728976/how-to-deny-access-to-a-file-in-htaccess	
ce941fa7-ac82-49e8-98a0-56f1db9794fb	htaccess file disclosure	.htaccess Disclosure	The remote web server discloses information via HTTP request.		5.4	0	CVSS:3.1/AV:A/AC:L/PR:N/UI:N/S:U/C:L/I:L/A:N	Need to recheck	custom	Change the configuration to block access to these files by set in .htaccess\r\n<Files ~ "^\\.(htaccess|htpasswd)$">\r\ndeny from all\r\n</Files>		{}	{}	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c			The server does not properly restrict access to .htaccess and/or .htpasswd files. A remote unauthenticated attacker can download these files and potentially uncover important information.\r\n	https://www.tenable.com/plugins/nessus/106231\r\nhttps://stackoverflow.com/questions/11831698/trying-to-hide-htaccess-file	
bfa2cd13-67f3-4a17-9bcf-3716053f92e9	Joomla XML disclose file and version	Joomla XML disclose file and version	Joomla allow joomla.xml file		4.3	0	CVSS:3.1/AV:A/AC:L/PR:N/UI:N/S:U/C:L/I:N/A:N	Need to recheck	custom	Oftenly, the joomla.xml were not used and able to remove the file from server. Alternatively, deny the file from being access by configure .htaccess.\r\n\r\n<Files ~ "^.*">\r\n  Deny from all\r\n</Files>		{}	{}	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c			Attacker able to gain the file tree and version of plugins used in Joomla	https://forum.joomla.org/viewtopic.php?t=1005483\r\nhttps://forum.joomla.org/viewtopic.php?t=902633	
03898ae8-ff1b-4c02-a1d5-a4c41797fdae	Joomla Sensitive Folder disclosure	Joomla Administrator Folder disclosure	Joomla able to access the Administrator folder without any authentication		3.5	0	CVSS:3.1/AV:A/AC:L/PR:L/UI:N/S:U/C:L/I:N/A:N	Need to recheck	custom	Implement zero trust by restricting the access to admin folder and allow only specific ip. This can be done by creating .htaccess on root of Administrator and add the following code:\r\n\r\n<Limit GET POST>\r\n order deny,allow\r\n deny from all\r\n allow from 192.168.x.x\r\n</Limit>		{}	{}	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c			Attacker might able to gain personal access like plugins version and information of the system	https://www.itsupportguides.com/knowledge-base/joomla-tips/joomla-how-to-use-htaccess-to-protect-the-administrator-directory/#:~:text=As%20a%20Joomla%20administrator%20one%20of%20the%20simplest,you.%20This%20can%20be%20done%20quite%20easily%20using.htaccess.	
cff57190-3561-4344-89d4-e827f02c6db9	Error disclose information	Error Message Disclose Sensitive information	The application error message discloses sensitive information such as path and line of code.		5.3	0	CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:L/I:N/A:N	Need to recheck	custom	Create a custom error pages or show general information like "server encounter error".		{}	{}	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c			An attacker may user this information to craft exploit to bypass the restriction.	https://www.php.net/manual/en/function.oci-error.php	
c4a2d27b-a851-42c2-9926-07274f43dcbf	Broken Access Control	Broken Access Control able to view other loan details	Access control (or authorization) is the application of constraints on who (or what) can perform attempted actions or access resources that they have requested. In the context of web applications, access control is dependent on authentication and session management:\r\n\r\n•\tAuthentication identifies the user and confirms that they are who they say they are.\r\n•\tSession management identifies which subsequent HTTP requests are being made by that same user.\r\n•\tAccess control determines whether the user can carry out the action that they are attempting to perform.\r\n\r\nBroken access controls are a commonly encountered and often critical security vulnerability. Design and management of access controls is a complex and dynamic problem that applies business, organizational, and legal constraints to a technical implementation. Access control design decisions have to be made by humans, not technology, and the potential for errors is high.\r\n		8.5	0	CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:C/C:H/I:L/A:N	Need to recheck	custom	Access control vulnerabilities can generally be prevented by taking a defense-in-depth approach and applying the following principles:\r\n\r\n•\tNever rely on obfuscation alone for access control.\r\n•\tUnless a resource is intended to be publicly accessible, deny access by default.\r\n•\tWherever possible, use a single application-wide mechanism for enforcing access controls.\r\n•\tAt the code level, make it mandatory for developers to declare the access that is allowed for each resource, and deny access by default.\r\n•\tThoroughly audit and test access controls to ensure they are working as designed.\r\n		{}	{}	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c			An attacker might be able to perform horizontal and vertical privilege escalation by altering the user to one with additional privileges while bypassing access controls. Other possibilities include exploiting password leakage or modifying parameters once the attacker has landed in the user's accounts page, for example.	https://portswigger.net/web-security/access-control/idor\r\nhttps://www.kiuwan.com/blog/owasp-top-10-2017-a5-broken-access-control\r\nhttps://portswigger.net/web-security/access-control\r\n	
402e1ffe-9a1f-4ecc-b6ca-6b5f1b6c484f	Server Header Disclosure	Server Header Disclosure	The remote web server discloses information via HTTP headers.		4.3	0	CVSS:3.1/AV:A/AC:L/PR:N/UI:N/S:U/C:L/I:N/A:N	Need to recheck	custom	Modify the HTTP headers of the web server to not disclose detailed information about the underlying web server.		{}	{}	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c			The HTTP headers sent by the remote web server disclose information that can aid an attacker, such as the server version and languages used by the web server. 	https://techcommunity.microsoft.com/t5/iis-support-blog/remove-unwanted-http-response-headers/ba-p/369710	
d542f8f9-b424-44de-9b78-6bb187ce0f2a	Excessive data on Response	Excessive data on Response leads to sensitive data exposure	This vulnerability is highlighted by the Open Web Application Security Project (OWASP). The API developer sends more data than required to the client. The client-side has to filter the information to show it to the user, thus leaving a lot of unused data. 		7.5	0	CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:N/A:N	Need to recheck	custom	1. Instead of relying on the client-side to filter the data, this operation should be performed on the server before sending the data. The client-side should only take the data and render it on the screen.\r\n\r\n2. Another thing that you can do is to ensure only the data the client has requested is sent to them. You are not sending any unnecessary information.\r\n\r\n3. To ensure that you are not sending sensitive data, you can also categorize your data as admin, personal, or sensitive information.		{}	{}	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c			The man-in-the-middle is the most common attack that can exploit this information as the data can be intercepted by the unwanted personnel when it is in transit. The data can later be used to perform different actions on the website. It can be sold to the highest bidder.	https://rapidapi.com/guides/excessive-data-exposure\r\nhttps://owasp.org/API-Security/editions/2019/en/0xa3-excessive-data-exposure/	
a4284106-f4ca-4fe6-b050-84574c87c47f	Hardcoded Credentials	Hardcoded Credentials	The application store the hardcorded credentials that able to being viewed by anyone.		4.3	0	CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:L/I:N/A:N	Need to recheck	custom	Properly store the credentials/key to save place. For Android apk, store the key on gradle.properties 		{}	{}	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c			Attacker might able to use the credentials or key to access sensitive information or overcharged the billing.	https://stefma.medium.com/something-about-google-api-keys-how-to-secure-them-and-what-firebase-got-to-do-with-this-e10473637ed3\r\nhttps://medium.com/@dugguRK/secure-android-api-keys-f865b344808c	
bebe0321-02f8-4f29-bd5e-bb7b7e2be357	Android Debug mode enabled	Android Debug mode enabled	The android:debuggable attribute sets whether the application is debuggable. It is set for the application as a whole and can not be overridden by individual components. The attribute is set to false by default.		3.5	0	CVSS:3.1/AV:A/AC:L/PR:L/UI:N/S:U/C:L/I:N/A:N	Need to recheck	custom	Always make sure to set the android:debuggable flag to false when shipping your application.		{}	{}	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c			Allowing the application to be debuggable in itself is not a vulnerability, but it does expose the application to greater risk through unintended and unauthorized access to administrative functions. This can allow attackers more access to the application and resources used by the application than intended.\r\n\r\nSetting the android:debuggable flag to true enables an attacker to debug the application, making it easier for them to gain access to parts of the application that should be kept secure.	https://developer.android.com/privacy-and-security/risks/android-debuggable#:~:text=Allowing%20the%20application%20to%20be%20debuggable%20in%20itself,and%20resources%20used%20by%20the%20application%20than%20intended.	
\.


--
-- Data for Name: logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.logs (id, teams, description, date, user_id, project) FROM stdin;
e8624c4f-5d9c-4a0a-988c-5890019b8052	[]	Project MADA WASA was created!	1715642235	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	
59ffefa3-ee5d-4881-b12b-e7ad801f5234	[]	Added issue template "Unathenticated SQL Injection"	1715642342	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	
fb7c82c5-d506-43ae-950e-398d2201c4a7	[]	Added issue template "Directory Listing"	1715642342	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	
c76e08ad-f962-42e2-b05b-709c65f164b4	"\\"[]\\""	Added ip mada.gov.my	1715642911	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
0247d4ba-c0bb-40a9-880f-bb47aaf25018	"\\"[]\\""	Added ip mada.gov.my	1715643019	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
954e279e-07e7-4bd6-bd0f-7933f1e2c89d	"\\"[]\\""	Added issue "Unauthenticate SQL injection"	1715643394	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
3dbfcf0b-ce4e-4bb1-9ccb-49ee7b40c3a0	"\\"[]\\""	Updated issue Unauthenticate SQL injection	1715643447	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
8bb5256b-5f9c-4cdf-b1f1-132c977b166f	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 0.0	1715643517	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
33a83e97-3a93-4fb6-aa5b-6e1fe2ca56d8	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 9.5	1715643540	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
e03116aa-6b11-4736-b639-a0ea80429b7b	"\\"[]\\""	Added ip portal.mada.gov.my	1715643660	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
f3a756ac-fe4c-40d0-bae4-97d6c2c50dcd	"\\"[]\\""	Added ip hrms.mada.gov.my	1715643677	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
68e0e1e0-3757-43bd-8992-061a992e0324	"\\"[]\\""	Added issue "Directory Listing"	1715643688	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
e132f0a8-7241-4522-bccc-2f01e95f2b27	"\\"[]\\""	Updated issue Directory Listing	1715643695	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
1ceaebfe-1245-4dc4-8620-4aa08eda39c5	"\\"[]\\""	Updated issue Directory Listing	1715643759	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
9de31594-2101-4318-b2ce-82e14ede2c50	"\\"[]\\""	Added new file report_2024-05-14T07:43:37.zip	1715643817	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
612400e8-df53-4460-9c34-f084a7885107	"\\"[]\\""	Added new file report_2024-05-14T07:43:38.zip	1715643818	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
bc86d0d6-ded0-4938-9fe5-ad44b5c6ea2a	"\\"[]\\""	Added new file report_2024-05-14T07:47:06.zip	1715644026	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
da25f407-d5a1-4f52-943e-859f66508dcf	"\\"[]\\""	Added new file report_2024-05-14T07:47:06.zip	1715644027	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
ed33a8ed-646a-417e-a8dd-ca63e7101722	"\\"[]\\""	Added new file report_2024-05-14T07:47:23.zip	1715644043	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
fc5c642d-d003-4e50-b4bf-604252fa90bf	"\\"[]\\""	Added new file report_2024-05-14T07:47:24.zip	1715644044	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
d5867bcf-c796-48a6-9bfd-b7302a3bcc4e	"\\"[]\\""	Added new file report_2024-05-14T07:47:59.txt	1715644079	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
becb6989-0dad-4e0a-b6ba-d01d619cffbe	"\\"[]\\""	Added new file report_2024-05-14T07:47:59.txt	1715644079	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
6ee4f2c8-970e-4d82-a820-8b05c8b7cf23	"\\"[]\\""	Added new file report_2024-05-14T07:48:17.docx	1715644097	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
cb9258b4-41c7-4a5a-ad1e-65f3b35ac859	"\\"[]\\""	Added new file report_2024-05-14T07:48:17.docx	1715644098	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
2581b3b5-66fa-49bf-86af-13c3057818c2	"\\"[]\\""	Added new file report_2024-05-14T07:48:59.docx	1715644139	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
5f0113d1-264b-4b75-93e9-1f6120ef3910	"\\"[]\\""	Added new file report_2024-05-14T07:48:59.docx	1715644140	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
97d9e16d-0c87-4a6a-9ca5-6e221f4fb2a6	"\\"[]\\""	Added new file report_2024-05-14T07:49:14.docx	1715644155	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
98e2c3c7-2f01-467c-b81f-5ef20e4583bf	"\\"[]\\""	Added new file report_2024-05-14T07:49:17.docx	1715644158	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
f47d459c-dc0c-4ae8-b4de-91d8fcf00fe3	"\\"[]\\""	Added new file report_2024-05-14T07:49:50.docx	1715644191	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
92458764-7383-4f88-af68-4c7c0314f85a	"\\"[]\\""	Added new file report_2024-05-14T07:50:13.docx	1715644214	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
84ca52f1-bd9f-4284-90eb-1ae2fbde0cb9	[]	Project EPT 13/5 was created!	1715679421	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	
6d3db5e0-ea60-4008-8cc5-25f6ecbb955e	"\\"[]\\""	Added ip uat-admin.myinvois.hasil.gov.my	1715679819	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
a0d90de8-c2cd-4d08-92cf-40266256fe6d	"\\"[]\\""	Added issue "Unauthenticate SQL injection"	1715680647	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
d5293df5-78fb-4590-b027-c7e462391ad6	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 10	1715682025	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
141c4369-f6bd-49a3-b517-53fde24144a2	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715682025	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
1a982d3c-c7f7-444e-906c-f62e1f3f08c0	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 7.8	1715682286	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
b4fb0e95-b525-4a43-87c7-fc022c79ae52	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 7.8	1715682294	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
dc8b39ee-4e35-4e2a-a0a3-08bccb7c500d	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715682316	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
7df893ae-f786-46e3-ba58-45362d234b1f	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715682372	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
f7a6d8e5-20a2-4646-bf30-4c80fa4d9648	[]	Added issue template "Insecure File Upload"	1715707256	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	
fb0e68b9-8640-4be2-ba17-438c211b1a62	"\\"[]\\""	Deleted Issue Unauthenticate SQL injection	1715682440	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
164e9b85-60a0-4abc-8d0d-0a5330682a8a	"\\"[]\\""	Deleted Issue Directory Listing	1715682440	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
1a236e3b-7258-4f8b-8cca-327298d81063	"\\"[]\\""	Added issue "Unauthenticate SQL injection"	1715682462	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
47d8d66a-cd5f-4dcb-b262-35e26603b5dc	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 10	1715682471	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
496ba7e3-21dd-441e-a61a-343dd3354b28	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715682779	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
53168801-9661-4286-adc4-cc66cd2231b1	"\\"[]\\""	Deleted Issue Unauthenticate SQL injection	1715682826	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
f6beadc3-a536-4b9a-a12b-3248360f9f85	"\\"[]\\""	Added issue "Unauthenticate SQL injection"	1715682830	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
eedc0638-4016-49ee-b107-13c860e97b9d	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 10	1715682843	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
7439e39c-bd42-4448-8f6c-b979c0bf09aa	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715682843	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
ad565d5d-4a18-4bf0-ae31-902742358c00	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 10	1715682850	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
3c1fb8fb-473c-4d0c-85b2-d3910ed4e075	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715682858	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
1cf81fd0-fd65-4650-8307-0db8dbbc73e4	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715682888	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
5dec0b46-96db-40a9-a2ca-fae0e312c51c	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 10	1715682890	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
8697388e-5e42-41e8-8daa-110524b4eb33	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715682895	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
418b913c-f349-4010-a819-b96f8034131b	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715682903	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
eb5541e2-6858-4c52-b750-a40c0773c5b7	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 9.6	1715683014	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
6130849b-ad6d-4f0b-bd48-f9c822df55ad	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 9.6	1715683016	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
ff3ee60a-c3f0-40d5-84fc-16a3dafad7a0	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715683017	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
5c80b06c-6e0f-440c-af3e-ebffa0d9df94	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 9.6	1715683017	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
f330bce2-c02b-44d0-8800-666faa54af89	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 9.6	1715683017	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
71cd1ff3-d8b3-4aa3-a7d3-e025466d6bc3	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 9.6	1715683017	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
c3fb08c2-12de-4c78-a5ec-34a6a16251e6	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 9.6	1715683018	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
cfabda05-a711-4810-a257-b5d68d3f7884	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715683051	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
8d812667-38b2-4e09-90c1-eba98f154f9f	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715683108	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
d6411d20-6b6e-4955-96e8-95a2855ae4e1	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 9.9	1715683119	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
074a8bb8-a343-4052-94e9-486e15ed310e	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715683119	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
f5850a56-183c-41e1-b719-37e641a8558e	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715683122	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
86b7649c-18b0-4211-a2d7-c44575c52158	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715683124	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
d35f7387-e611-4cca-81a5-53bfdddd1166	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715683310	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
1633e444-d273-4c4f-944d-ffcd79b74afd	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 9.9	1715683312	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
667f39ba-5147-47d3-ac8d-d08ec3224085	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715683312	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
525ab1c8-6d8f-4846-bf1a-061a6321dd6a	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715683313	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
84d293db-cc55-4901-b476-41cbc57ebd70	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 9.9	1715683314	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
6801c25f-05e6-42ee-9d1b-e1d077596d3b	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 9.9	1715683315	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
90efa295-6972-4e21-9874-0cb97fb846ee	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715683315	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
913ee90c-addd-4bda-bbc0-e1da621eccd2	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715683316	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
3132eae5-00fe-4dd8-8d3c-568b3def5dc9	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715683316	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
f98c458f-9fc4-49b1-894f-6e7cd0c0b520	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715683322	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
586de72f-a740-4c32-94cd-c323614b4864	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715683343	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
934a967f-fde1-4551-aaee-1e75a1d5771b	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715683344	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
c159cb08-37ff-48d3-9770-cf0d1bac07a6	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715683345	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
fc91989c-ed6c-40b9-b9a7-f232b45ccca1	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715683345	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
d8992936-bae2-40bd-a09c-365d4256e891	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 8.8	1715683358	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
d95b85b8-2581-4838-813e-85fe194dcbfa	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715683390	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
3d12fef4-8f1f-406f-a45e-b67e6a1c2453	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 9.9	1715683390	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
aaf03a33-3bfe-4be4-8e9c-694262254564	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 10	1715683405	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
0344610f-6757-45ef-a856-5676ac7a0a08	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 9.9	1715683435	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
9acc2225-8544-46ac-b25a-adbf7a22b11b	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 9.9	1715683958	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
a2ffc1d4-9f37-4715-a00e-376a2148c954	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 9.9	1715683959	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
90ca5ca8-32c4-4c57-8abe-ee9de030ef0c	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715683960	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
69bcadfa-09de-476e-8e0d-2ea28497aa81	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 9.9	1715683960	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
ef49e39d-b209-453e-a0b7-32c2be7a9ef5	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715683960	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
97a3649a-6278-48c1-88cf-181e28a7e318	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715683960	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
ee1c7957-bb6f-41f0-bf77-248752960480	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715683960	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
9c59e76d-5ab8-4711-b445-6e48f311d0ec	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 9.9	1715683961	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
69b99330-5ebd-4da3-bd75-52a824de74e8	"\\"[]\\""	Updated issue Unauthenticate SQL injection	1715684187	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
0667b45b-9cba-4f90-a229-6230612d2a80	"\\"[]\\""	Updated issue Unauthenticate SQL injection	1715684193	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
2789bb12-ac70-4315-8f72-411f0470718d	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715684223	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
c5a74b65-4d4e-4f72-b2da-0883f5b06eec	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 10	1715684223	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
44d1bbea-6a35-4924-a44d-775ff32b85eb	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715684260	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
d668e6fa-916c-4a24-a286-bed8d9c2a868	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 9.9	1715684262	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
ecf65a75-a637-46f7-a493-73581aabc2ec	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 9.9	1715684331	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
f7bb0ebb-dc4c-4826-9d25-10f8a34df819	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715684360	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
6f56f313-bf67-45da-b1f5-9248f2613a29	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715684361	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
65534fe3-8953-466e-a912-dc8f4d8bdb02	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715684441	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
c7707ff1-2e4c-48e2-99de-3ca7fadf2610	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715684447	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
cc034b1b-af4b-4f65-af49-5ca6d494f90b	"\\"[]\\""	Added issue "Unauthenticate SQL injection"	1715684840	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
8ea1b1ce-552c-415c-836c-04a77fa7825c	"\\"[]\\""	Deleted Issue Unauthenticate SQL injection	1715684938	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
0fa281de-13c4-400a-8154-ea88c85f3fb5	"\\"[]\\""	Deleted Issue Unauthenticate SQL injection	1715684938	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
83888c47-4c1b-450c-85f6-4b10542d6bfc	"\\"[]\\""	Added issue "Unauthenticate SQL injection"	1715685303	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
68090bb0-873d-478d-b6c0-80d813638231	"\\"[]\\""	Added issue "Unauthenticate SQL injection"	1715685570	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
e240b056-f8fd-4862-9cab-6ccedb09c0ea	"\\"[]\\""	Added issue "Unauthenticate SQL injection"	1715686112	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
e8c10e5a-f788-46bc-8cf9-56ebc523fa73	"\\"[]\\""	Deleted Issue Unauthenticate SQL injection	1715686367	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
7bf85282-3a28-4cd0-ba38-1d0e12f800bd	"\\"[]\\""	Deleted Issue Unauthenticate SQL injection	1715686367	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
9bca1550-9bac-4dac-bc5e-ccdcbfcd72e7	"\\"[]\\""	Deleted Issue Unauthenticate SQL injection	1715686367	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
a694e28a-72be-44aa-8baf-68fe8a8e86c2	"\\"[]\\""	Added issue "Unauthenticate SQL injection"	1715686800	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
22868bb5-e171-4fd5-ad40-dc64e88eab39	[]	Added issue template "Cross Site Scripting (XSS)"	1715688148	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	
3d3e56ad-e3a2-4736-a7cf-cf4d202d7e8d	"\\"[]\\""	Added issue "Cross Site Scripting (XSS)"	1715688168	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
14d67698-0912-4860-8bca-954910c6bf1d	"\\"[]\\""	Added issue "Unauthenticate SQL injection"	1715695621	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
ef30b043-ef8e-40ad-8e49-1281343b6663	"\\"[]\\""	Added issue "Unauthenticate SQL injection"	1715695627	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
91cd17b3-f834-4198-b36c-2d5904fbf3a3	"\\"[]\\""	Added issue "Unauthenticate SQL injection"	1715695680	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
b0761401-8b60-42ff-87ab-196f1c03ad71	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715695695	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
26ad98bd-fc9a-4f3f-8ea1-b9587b6d1cdb	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715696955	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
b8d3903e-efde-4450-972d-1faf697c4649	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 10	1715697006	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
9dd048bc-4528-4f38-b807-0c12f49cb566	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715697006	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
e8ab9475-53f8-4a1d-917f-5f7a3b5f752e	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 9.9	1715697028	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
187de7d0-c74e-42a3-b75e-19df07607f25	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715697058	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
1dc907a8-12c7-4925-84dc-b984f508f72d	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 9.1	1715697070	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
468e976b-dd75-476f-b4d5-a6ca31e5cc58	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 9.1	1715697071	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
f7c4f15e-6081-4707-b979-0a7f7d91f0f6	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 10	1715697101	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
64be7e71-a8ed-43d3-990e-3450e107c774	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 10	1715697245	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
020c4223-74f8-4b7e-8181-0d022c502dfd	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 10	1715697247	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
9c331a41-ee99-4dbe-b3a9-e8ca27fc13f0	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 10	1715697248	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
22a04a8e-74a0-4ab5-ba6b-68bd4999b686	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 10	1715697249	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
be7ee9e8-a3f0-4804-8b44-8dc799515b97	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715697249	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
f0290657-faa8-4d45-b57a-22c34b9f0a2a	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715697249	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
cfe80076-9220-4a53-b469-feeadd5ebb02	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 10	1715697249	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
6e9c4f66-cd5a-47b8-b6ef-df739247ab64	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 10	1715697250	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
7396e3db-fe68-4c5d-a990-1e49391af895	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 10	1715697251	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
c9410ebd-4dd9-49d4-98c5-062c320dd7f4	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715697785	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
36f3d4dd-11ef-4deb-ae6e-14b1fcda106f	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 10	1715697787	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
77ac2999-c2e8-49d9-8625-380c4ac8d5d4	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715697787	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
47445021-1d69-4f60-8ebd-017ee706f1ac	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 10	1715697788	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
269039e2-7d09-4274-91ed-72daec9d5815	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715697789	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
a8c552f4-1577-401e-b99b-7fedef615446	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 10	1715697789	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
a4a67427-2548-48aa-8a23-82b12cfb7fbf	"\\"[]\\""	Updated issue Unauthenticate SQL injection field "cvss_vector"	1715697791	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
ba87b71b-0350-4d0a-b36c-29244b261155	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 10	1715697791	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
35dfa467-e201-4344-96c2-374d87bb675f	"\\"[]\\""	Updated issue Unauthenticate SQL injection cvss to 10	1715697792	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
ccc06fa3-aff0-4bba-a9c8-1698d5f16a35	"\\"[]\\""	Deleted Issue Unauthenticate SQL injection	1715697829	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
8d0c3b6a-2a0e-42e7-8a8d-000d860cb741	"\\"[]\\""	Added issue "Insecure File Upload"	1715707270	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
c0021bf2-9ba6-4bf4-86c4-2103f080a7c1	"\\"[]\\""	Updated issue Insecure File Upload cvss to 8.2	1715707293	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
735a3c7a-75a0-478d-b8fe-134a4f2da064	"\\"[]\\""	Updated issue Insecure File Upload field "cvss_vector"	1715707305	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
124b9d36-afff-457f-b48c-e5ee23411f1c	"\\"[]\\""	Updated issue Insecure File Upload cvss to 8.2	1715707331	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
86e71643-00bc-42b7-a153-b5a48f24033a	"\\"[]\\""	Updated issue Insecure File Upload cvss to 8.2	1715707331	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
a8e558f6-5f9a-4376-b05c-aed81bbe96de	"\\"[]\\""	Updated issue Insecure File Upload cvss to 8.2	1715707362	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
f6d5809c-5372-414c-9232-e61a87f6ab79	"\\"[]\\""	Updated issue Insecure File Upload field "cvss_vector"	1715707556	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
9b4bde1a-c85e-470e-b218-359b2e60cdea	"\\"[]\\""	Updated issue Insecure File Upload field "cvss_vector"	1715707558	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
06a1cca1-f2bc-498f-bf8c-1cdc4fcba78a	"\\"[]\\""	Updated issue Insecure File Upload field "cvss_vector"	1715707558	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
acde9f04-f4db-44df-801d-8f149999e555	"\\"[]\\""	Updated issue Insecure File Upload cvss to 8.2	1715707600	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
4cb3977b-4726-41b0-a410-58f3f0e822cc	"\\"[]\\""	Updated issue Insecure File Upload cvss to 10	1715707610	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
5236ecb6-3274-424e-9600-caa035eb5f18	"\\"[]\\""	Updated issue Insecure File Upload field "cvss_vector"	1715707610	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
0343fca6-4e5c-45cb-9a7a-b5157faf5397	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715707641	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
479553d6-a854-4173-bf55-1dad2e39e868	"\\"[]\\""	Updated issue Insecure File Upload field "cvss_vector"	1715707641	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
17ea0714-5d45-42ef-a271-3703750ac3e9	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715707641	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
38b169e5-23fc-42c7-9373-93a19ce2c2a4	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715707641	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
1523af6c-bbc7-4abf-b5fe-ca777eed3f35	"\\"[]\\""	Updated issue Insecure File Upload	1715707668	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
c86ec3cb-237b-4c45-a1b3-e8d7fc15e8a7	"\\"[]\\""	Updated issue Insecure File Upload field "cvss_vector"	1715707722	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
dff78ee2-1ac9-434b-a8cb-ac354f991678	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715707725	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
192c7062-29e6-452b-bcf2-5ec1e0358c79	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715707725	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
c9835fd2-057f-4d95-be12-62d145c0de3e	"\\"[]\\""	Updated issue Insecure File Upload field "cvss_vector"	1715707725	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
8c94cd70-af24-4c91-9677-e2361d45c1fa	"\\"[]\\""	Updated issue Insecure File Upload field "cvss_vector"	1715707725	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
77097eea-155c-41d8-ada5-f8a8350d7f8e	"\\"[]\\""	Updated issue Insecure File Upload	1715707734	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
6f095c6e-3ca9-4865-8f70-ce5a7483739d	"\\"[]\\""	Updated issue Insecure File Upload cvss to 0	1715707971	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
e5e53b3a-c426-417b-9d11-c8b9fcea851b	"\\"[]\\""	Updated issue Insecure File Upload field "cvss_vector"	1715707972	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
c1383938-421e-4bdb-8e98-6fbbfa128716	"\\"[]\\""	Updated issue Insecure File Upload field "cvss_vector"	1715708006	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
72c1f247-1bd7-4bf1-a673-eb20f7860e41	"\\"[]\\""	Updated issue Insecure File Upload	1715708033	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
e550de25-7e4a-4c83-ab6b-f6a4f409e1cc	"\\"[]\\""	Updated issue Insecure File Upload field "cvss_vector"	1715708057	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
d5847662-49cf-48c5-a930-c705fa48f469	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715708057	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
b1649f72-c61c-486a-b92f-cd316233f6ce	"\\"[]\\""	Updated issue Insecure File Upload field "cvss_vector"	1715708058	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
4b701fb1-23c2-4935-a859-6b56211d620d	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715708058	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
7ba076a1-7cad-4867-bf20-8aa4f64f6453	"\\"[]\\""	Updated issue Insecure File Upload field "cvss_vector"	1715708059	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
b2ebff0f-eb50-4521-a009-8c404b3a6150	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715708402	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
c5dc914c-a9c0-49f0-ace8-28ca24816977	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.6	1715708439	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
9242cfe2-3619-4377-89a5-989d555db6ae	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715708460	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
748144b6-122a-4047-95fa-42f1a0c7abf8	"\\"[]\\""	Updated issue Insecure File Upload field "cvss_vector"	1715708460	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
928458cb-c253-4a6c-874b-3361d43d5541	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715708461	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
bdfc3b1c-119d-4b28-a55b-c55bbba1db1e	"\\"[]\\""	Updated issue Insecure File Upload field "cvss_vector"	1715708461	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
fd8606c3-a08b-4591-be7c-cfeeb411f7cf	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715708461	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
c3bd8543-4cc6-4bbe-aa58-a5976ac83604	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715708489	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
c964620d-ca4b-453f-8aa8-0dd73406caa1	"\\"[]\\""	Updated issue Insecure File Upload	1715708659	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
c3a02809-c1ce-4e73-a851-b03a791f9699	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715708710	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
9024877c-2395-47fc-bf67-412179362af2	"\\"[]\\""	Updated issue Insecure File Upload field "cvss_vector"	1715708710	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
b1d7558e-30db-4222-9caf-e30eee0eab25	"\\"[]\\""	Updated issue Insecure File Upload field "cvss_vector"	1715708711	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
3448e800-26da-4965-94c4-989afafd9d05	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715708711	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
95e3e06d-44f8-4ba6-b353-3af70b2a054a	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715708712	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
e49c9a28-d8dc-4e1d-a1b7-b78073306d26	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715708729	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
a4ac5b8d-ba31-4154-89a0-b2cc76315507	"\\"[]\\""	Updated issue Insecure File Upload field "cvss_vector"	1715708729	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
8daca8c4-714e-425d-a594-71ea8a7008dc	"\\"[]\\""	Updated issue Insecure File Upload cvss to 6.3	1715708745	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
9bc18f84-4b73-4015-a462-f6c7f6e2a6f2	"\\"[]\\""	Updated issue Insecure File Upload field "cvss_vector"	1715708745	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
766ef13a-5fc8-42e7-addf-fd34304d92d0	"\\"[]\\""	Updated issue Insecure File Upload field "cvss_vector"	1715708767	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
8001e933-4ec3-4b80-be51-20ce2d9cbfc3	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715708778	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
f53bc737-c4ae-4103-84d6-885a8ffbb562	"\\"[]\\""	Updated issue Insecure File Upload cvss to 6.3	1715709008	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
9d69786b-45d0-4a5b-8c7b-947b3731211e	"\\"[]\\""	Updated issue Insecure File Upload cvss to 6.3	1715709119	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
e9161a66-1341-4c8f-8724-9b8ed6ed4a55	"\\"[]\\""	Updated issue Insecure File Upload field "cvss_vector"	1715709119	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
0344b345-75d0-42cc-b6e8-4ed2566d1cd7	"\\"[]\\""	Updated issue Insecure File Upload cvss to 6.3	1715709120	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
60648eb5-83ad-4eac-bbff-04f0b28e6081	"\\"[]\\""	Updated issue Insecure File Upload field "cvss_vector"	1715709120	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
3faacfc5-dee7-4cfa-a9fc-fc25dfcc9b8b	"\\"[]\\""	Updated issue Insecure File Upload field "cvss_vector"	1715709120	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
1379cce1-d487-47f2-abd0-0821e05fa99e	"\\"[]\\""	Updated issue Insecure File Upload cvss to 6.3	1715709132	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
59aff438-2050-4112-9ad0-383c5fa5bf26	"\\"[]\\""	Updated issue Insecure File Upload field "cvss_vector"	1715709132	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
b0b330f8-66a2-4b1f-92e5-58391f8f6053	"\\"[]\\""	Updated issue Insecure File Upload cvss to 6.3	1715709132	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
07fe3d9f-58b0-4e51-b742-8cc2bf816ac6	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715709140	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
0f0e58f5-380c-4b41-8119-a3998e74f18d	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715709170	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
32c21e8a-881c-4349-b63c-654dae38f6a8	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715709170	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
396469e4-a3af-47d4-91a0-fdfcc5e6bd83	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715709171	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
a277eb26-d145-408c-8a7a-ff1f8861fdad	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715709171	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
79f40c4c-8065-43c5-872e-027e2c15a32d	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715709171	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
8aa18a3d-eb9c-4aa3-afbe-0f2efc847085	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715709172	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
7c29d5db-3512-47d1-b76e-b3e6f224c267	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715709172	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
c8f60a16-d38b-44f9-954d-4be473fd633d	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715709172	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
f5054a22-74a9-4f9b-9af2-75f48668b9a3	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715709172	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
5d6e83cc-4028-4bf0-947f-2ea2c8d856c0	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715709172	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
2c399a66-e8a9-4bae-9ce6-2d4031bca2ae	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715709172	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
82aa1707-9799-4207-ba2c-496c554eaca1	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715709173	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
3b343c2e-4ee2-4372-9a37-4f1d34155ae3	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715709173	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
874bd84b-be98-4ad0-94c3-61e359e967c8	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715709173	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
792e3b14-98c6-457d-95d6-75f2779d41de	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715709173	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
58685195-922e-4427-962e-cd8b56a8c306	"\\"[]\\""	Updated issue Insecure File Upload cvss to 10	1715709175	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
60ced946-8533-480d-a97b-0b53b3e82c73	"\\"[]\\""	Updated issue Insecure File Upload cvss to 10	1715709176	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
c9828d89-c7b8-4025-a441-e61e55714901	"\\"[]\\""	Updated issue Insecure File Upload cvss to 10	1715709176	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
026b2a42-f4bd-4278-9892-2d819f0ab8ff	"\\"[]\\""	Updated issue Insecure File Upload cvss to 10	1715709176	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
7301251e-8148-4a9b-88b2-e25e6c001e13	"\\"[]\\""	Updated issue Insecure File Upload cvss to 10	1715709176	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
e210c7c1-e991-4418-9c1d-c027cfd2630e	"\\"[]\\""	Updated issue Insecure File Upload cvss to 10	1715709176	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
e595e92a-5d8d-43c5-88e0-5fe7f2e32ea4	"\\"[]\\""	Updated issue Insecure File Upload cvss to 10	1715709176	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
ae560519-8b23-44dd-9dff-e3b201de4e72	"\\"[]\\""	Updated issue Insecure File Upload cvss to 10	1715709177	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
ddb56ab6-6967-4518-bd0d-da3d7d1c5097	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715709383	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
09310174-ac4e-4d22-b467-496f56ed7bd6	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715709384	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
2c6310d8-f2fa-4ae1-bc87-66db8d07a143	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715709384	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
4faa87d2-ec77-41eb-bb9c-a98ffb2bfea4	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715709384	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
19c1dcef-a478-4c4b-a69e-c45440f26400	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715709384	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
142f4ea9-de71-4814-9770-a0b14180fb80	"\\"[]\\""	Updated issue Insecure File Upload	1715709392	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
4895b399-f048-45ef-820b-7ba4b43c0944	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715709479	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
25e127de-ed16-4934-9d07-a030c98854d8	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715709480	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
23690006-695b-4a13-841f-c16a47123ec6	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715709480	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
5e8fb472-a835-466c-aa40-59e9b49bf40e	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715709480	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
5bb9488a-86e9-4bfe-b15a-98bd17e0f1cb	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715709481	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
984e65de-79a8-40b0-ac62-493e89710475	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715709481	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
e54ca8f4-3161-4940-8b47-86b6f2572c2e	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715709481	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
8f21cda1-46de-4b95-892e-0c8ddfd5c5ed	"\\"[]\\""	Deleted Issue Unauthenticate SQL injection	1715709590	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
4a0c956e-48f7-4287-95f6-18cb34a7252a	"\\"[]\\""	Deleted Issue Unauthenticate SQL injection	1715709590	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
e2d098b9-d0f1-41d4-8852-445fbe9965fa	"\\"[]\\""	Deleted Issue Unauthenticate SQL injection	1715709590	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
0d7ceade-a6db-4ca9-959b-fedb70122819	"\\"[]\\""	Deleted Issue Unauthenticate SQL injection	1715709590	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
9abde46f-9902-461d-812b-6ea9fc35bb46	"\\"[]\\""	Deleted Issue Cross Site Scripting (XSS)	1715709590	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
c79e6b7e-a2ee-4d3f-b28f-06221a564d36	"\\"[]\\""	Updated issue Insecure File Upload	1715709617	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
f06ccef8-b3c0-4528-8007-e9d691acb4bb	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715709780	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
908eefb8-f75f-43d7-aae9-592f03d861cd	"\\"[]\\""	Updated issue Insecure File Upload	1715709796	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
4e948824-11f3-465e-98bf-c321a200f6a9	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715709867	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
57de0d53-0b7b-43a4-b711-77f1d24bbbb2	"\\"[]\\""	Updated issue Insecure File Upload	1715709882	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
211dc31a-c7a1-4b06-8305-4fc95f542fe7	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715709971	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
ee581124-03d2-4f46-8954-07292b77f791	"\\"[]\\""	Updated issue Insecure File Upload	1715709975	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
fc1d3713-0774-4f2e-b25b-ee7c4d2d3ee6	"\\"[]\\""	Updated issue Insecure File Upload	1715710013	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
f5af0326-971a-41cf-8d88-d2953cfcdb0c	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715710016	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
c0fb6efd-04a8-4357-8c3e-0eacd5748667	"\\"[]\\""	Updated issue Insecure File Upload	1715710020	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
9f71e50d-38ba-452b-a1fd-7b80e4d1e85d	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715710106	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
f6e6966f-72b6-4409-a276-30fb100279ee	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715710108	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
70d6d719-6c9d-42a5-8231-10f9feb381f2	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715710108	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
105c3360-5dc6-49eb-a6fe-baec4a833f4d	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715710108	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
e013f4ba-cf24-4f6a-b420-956c4dfdaa5b	"\\"[]\\""	Updated issue Insecure File Upload field "cvss_vector"	1715710140	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
c619d5b4-052d-498b-ae57-89d2364e014e	"\\"[]\\""	Updated issue Insecure File Upload	1715710146	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
319c6662-87aa-442d-8a55-881e6aed6a02	"\\"[]\\""	Updated issue Insecure File Upload	1715710149	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
f64eaa21-b347-4c28-b096-e10d4e4e8ff6	"\\"[]\\""	Updated issue Insecure File Upload	1715710152	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
065bce4d-7b42-4bf2-a85f-bfdc1dff2d87	"\\"[]\\""	Updated issue Insecure File Upload	1715710193	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
e979aff4-af4d-437d-ab79-ffe67b7860d4	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715710200	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
94abc0fc-c163-4559-af34-95cb0ce2597a	"\\"[]\\""	Updated issue Insecure File Upload	1715710204	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
d24d73ea-5fdb-4798-a484-7d60b05826ea	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715710212	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
75153583-d474-4905-84eb-ab6c77ec56cc	"\\"[]\\""	Updated issue Insecure File Upload field "cvss_vector"	1715710212	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
66b64c26-9e00-4f1e-abb5-8ff16b1b21fa	"\\"[]\\""	Updated issue Insecure File Upload	1715710219	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
db76e128-d8e0-4a8b-b3fc-1989bf641f39	"\\"[]\\""	Updated issue Insecure File Upload	1715710264	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
73e8b7c2-2bc9-4d53-98b7-ee4e6f083306	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715710287	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
b1eeec65-7b7d-4840-929a-0cfd26e55d79	"\\"[]\\""	Updated issue Insecure File Upload cvss to 6.1	1715710302	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
f7f5acff-b346-46f3-855b-bd40e664f209	"\\"[]\\""	Updated issue Insecure File Upload field "cvss_vector"	1715710304	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
d8c6f9c2-7950-4c8c-8455-d8a3c29f130f	"\\"[]\\""	Updated issue Insecure File Upload cvss to 6.1	1715710305	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
a2d0525d-19bd-46b4-a8e6-9858e88aac29	"\\"[]\\""	Updated issue Insecure File Upload	1715710317	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
2520ea17-641d-458f-afc6-ac4220df1e35	"\\"[]\\""	Updated issue Insecure File Upload	1715710372	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
a6f6d0de-eda0-42a9-b347-1f22a0c85e70	"\\"[]\\""	Updated issue Insecure File Upload cvss to 6.1	1715710376	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
a8fa437c-f456-4874-9718-8bbfd2522676	"\\"[]\\""	Updated issue Insecure File Upload cvss to 6.1	1715710391	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
2de6dd67-7efb-4bf6-b033-a7fd2972f9c7	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.3	1715710810	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
841cd776-eab2-44c4-8690-d8ca8a17175d	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.3	1715710811	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
05cc0b13-b44b-4f3f-a881-1d1faa59aeac	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.3	1715710811	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
31a1667c-67d1-4f80-b651-70adde202b38	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.3	1715710811	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
b19ce795-336b-467d-beee-7e2d02dd5e27	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.3	1715710812	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
c04f0f50-f305-4a0a-b6e3-913343fa4f0d	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.3	1715710812	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
895adc46-033f-4a90-94b8-aa10321aa3f5	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.3	1715710812	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
df002efa-1070-4407-a680-d2f5ada99076	"\\"[]\\""	Updated issue Insecure File Upload cvss to 6.6	1715710824	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
5a7f6407-35ed-45c2-913e-256f94003b13	"\\"[]\\""	Updated issue Insecure File Upload cvss to 6.6	1715710824	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
08dcf9c7-a363-4f94-b32a-7de26f6b1576	"\\"[]\\""	Updated issue Insecure File Upload	1715710837	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
2b9fa006-31b2-42c0-9ca5-d18c4ee7927f	"\\"[]\\""	Updated issue Insecure File Upload	1715710849	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
2d7d3b64-f2ce-407d-9c90-8a785b2f9795	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.3	1715710966	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
b9f62b2a-f426-436e-87c0-d72993085c92	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.3	1715710967	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
e2af02dc-3f03-47bd-b4b7-d7408434941d	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.3	1715710968	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
44426899-8062-496b-ba95-dda58d42614b	"\\"[]\\""	Updated issue Insecure File Upload field "cvss_vector"	1715710978	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
9df30176-3744-47bc-aef6-1747015f3125	"\\"[]\\""	Updated issue Insecure File Upload field "cvss_vector"	1715710978	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
cac18628-96af-4924-a26a-56b13dfe342d	"\\"[]\\""	Updated issue Insecure File Upload field "cvss_vector"	1715710991	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
4d9eef6e-151d-4e7d-aa12-1dd706a7bf64	"\\"[]\\""	Updated issue Insecure File Upload field "cvss_vector"	1715710992	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
31a28f7a-dd1a-4825-85c0-559a29a7a8f4	"\\"[]\\""	Added issue "Insecure File Upload"	1715711003	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
b127e707-1174-4ce4-9a43-ea71e4f16014	"\\"[]\\""	Updated issue Insecure File Upload	1715711013	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
d490d9bf-ab04-4f7e-b6ee-32cb9cbf8f36	"\\"[]\\""	Updated issue Insecure File Upload	1715711030	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
03983301-094a-4e49-b319-05e495f87df6	"\\"[]\\""	Updated issue Insecure File Upload cvss to 10	1715711047	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
3a69ebac-7a0a-4180-accc-97b54bb8894b	"\\"[]\\""	Updated issue Insecure File Upload cvss to 10	1715711048	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
c8e13d5a-03a5-4caa-999c-69ec45e3ecb0	"\\"[]\\""	Updated issue Insecure File Upload	1715711058	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
fe3486fc-0dc2-4e38-912c-79bb430b3cba	"\\"[]\\""	Updated issue Insecure File Upload	1715711159	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
cc0a9fe1-67c9-4c13-90de-2e2a7797c541	"\\"[]\\""	Updated issue Insecure File Upload cvss to 4.3	1715711169	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
a88bd46f-6ade-4b4c-be0a-a875d8bfe369	"\\"[]\\""	Updated issue Insecure File Upload	1715711177	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
0ac06f89-8b0b-45cd-b7d7-ec2bf669db8f	"\\"[]\\""	Updated issue Insecure File Upload cvss to 8.6	1715711472	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
5e717efc-8bb8-4da8-b0ea-046d8039efc8	"\\"[]\\""	Updated issue Insecure File Upload	1715711498	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
45930fd9-91d5-4e82-9e93-04a82bc532bc	"\\"[]\\""	Updated issue Insecure File Upload cvss to 10	1715711594	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
1f275084-49d2-4e62-8a1c-1ec8c8789f2d	"\\"[]\\""	Updated issue Insecure File Upload cvss to 10	1715711595	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
b1e297bc-26ab-4730-845d-5ed3db5658d7	"\\"[]\\""	Updated issue Insecure File Upload	1715711608	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
535bfa0b-d7de-4983-9715-9fd9b445c301	"\\"[]\\""	Updated issue Insecure File Upload	1715711883	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
9c68dccc-5f6f-465f-b1a8-da4d16601dea	"\\"[]\\""	Updated issue Insecure File Upload	1715712257	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
c909df04-30d3-40ac-9e00-0dab4ec5aaf1	"\\"[]\\""	Updated issue Insecure File Upload field "cvss_vector"	1715712271	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
0ef00379-979d-42e7-9dff-90d606847125	"\\"[]\\""	Updated issue Insecure File Upload cvss to 10	1715712271	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
5d1a3366-b602-4d78-a562-c6ad01cde55f	"\\"[]\\""	Updated issue Insecure File Upload cvss to 10	1715712272	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
3d8c99ee-d6a6-4416-8939-80ac6c54c7cd	"\\"[]\\""	Updated issue Insecure File Upload field "cvss_vector"	1715712272	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
14e86fea-94df-4e4e-82ec-ae43e25a034c	"\\"[]\\""	Updated issue Insecure File Upload field "cvss_vector"	1715712273	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
c99bf174-78fa-4a8e-960c-10532df907b8	"\\"[]\\""	Updated issue Insecure File Upload field "cvss_vector"	1715712273	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
dd37f6cd-20b9-4252-aada-28c7fea2e8f1	"\\"[]\\""	Updated issue Insecure File Upload cvss to 10	1715712273	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
2869b920-2884-4057-aa14-e802be036c53	"\\"[]\\""	Updated issue Insecure File Upload field "cvss_vector"	1715712274	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
97255d24-84bd-4795-a89a-7b8bae279615	"\\"[]\\""	Updated issue Insecure File Upload	1715712286	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
0a33d519-9729-44e2-ac91-48fdda51c6f8	"\\"[]\\""	Updated issue Insecure File Upload	1715712382	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
38e4962c-0294-43f8-8de3-8ba49f75bf58	"\\"[]\\""	Updated issue Insecure File Upload cvss to 10	1715712391	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
1001d550-6beb-4c0b-97d5-aed89fb13b80	"\\"[]\\""	Updated issue Insecure File Upload cvss to 10	1715712392	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
eaa279b2-f429-4311-bbc2-1bee8403ef55	"\\"[]\\""	Updated issue Insecure File Upload cvss to 10	1715712392	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
314544e2-673c-422e-86c2-6545e190b8c2	"\\"[]\\""	Updated issue Insecure File Upload cvss to 10	1715712392	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
7ac99ef6-6b9c-45a2-8748-0caeab072851	"\\"[]\\""	Updated issue Insecure File Upload cvss to 10	1715712392	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
ec2529b7-27f9-43d2-9ad7-497268171a44	"\\"[]\\""	Updated issue Insecure File Upload cvss to 10	1715712392	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
5b754397-6d06-4c30-8a34-678488ddcce9	"\\"[]\\""	Updated issue Insecure File Upload cvss to 10	1715712393	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
a2ac44ab-b40f-4bec-ba14-d11192a48b08	"\\"[]\\""	Updated issue Insecure File Upload cvss to 10	1715712393	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
5992b310-0c3e-458c-9836-8419684dc273	"\\"[]\\""	Updated issue Insecure File Upload cvss to 10	1715712393	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
c78f03b6-0be7-407b-8cfd-1c0dc20551ea	"\\"[]\\""	Updated issue Insecure File Upload cvss to 10	1715712393	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
28d46a56-9867-4172-b273-c058ed682b2e	"\\"[]\\""	Updated issue Insecure File Upload cvss to 10	1715712393	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
8957a4a1-a05e-4b13-afb9-963f72972db0	"\\"[]\\""	Updated issue Insecure File Upload cvss to 10	1715712393	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
858ba542-8592-47e3-9ad3-d657275b6524	"\\"[]\\""	Updated issue Insecure File Upload	1715712404	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
13572352-ce45-4caf-922f-f0a152e4e2b9	"\\"[]\\""	Updated issue Insecure File Upload cvss to 10	1715712427	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
404162d6-13b2-4021-b524-f50fef3370b3	"\\"[]\\""	Updated issue Insecure File Upload	1715712437	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
949a00f7-9cd1-44d9-a513-d0056f263fe2	"\\"[]\\""	Updated issue Insecure File Upload	1715712619	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
ca9f1f27-cc57-455d-b1b8-e5b6b03f28a7	"\\"[]\\""	Updated issue Insecure File Upload cvss to 10	1715712624	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
d992a405-9f48-41be-b08b-0a7922e7a882	"\\"[]\\""	Updated issue Insecure File Upload	1715712629	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
15af0cfa-963b-4e11-82aa-de7b28845a4f	"\\"[]\\""	Updated issue Insecure File Upload	1715712635	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
29e7200f-e9c2-4083-8ce5-cb1fd53cba55	"\\"[]\\""	Updated issue Insecure File Upload cvss to 9	1715712647	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
d0bfd8c2-5521-45d2-9947-b642c5346a0d	"\\"[]\\""	Updated issue Insecure File Upload cvss to 9	1715712648	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
b53e1fe6-3a56-4b95-ac4f-f4fa4aec1c3a	"\\"[]\\""	Updated issue Insecure File Upload	1715712654	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
48592df4-cf8b-4233-bca7-cd413864046c	"\\"[]\\""	Updated issue Insecure File Upload cvss to 9	1715712668	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
d55a1c37-f900-4e4a-9e3f-27dfab13832b	"\\"[]\\""	Updated issue Insecure File Upload cvss to 9.9	1715712675	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
0c1c2af5-7ef0-475c-8b8c-61ee2bb7811c	"\\"[]\\""	Updated issue Insecure File Upload cvss to 9.9	1715712675	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
70789c5d-bdbf-45d9-998b-b9b260b0c77a	"\\"[]\\""	Updated issue Insecure File Upload cvss to 9.9	1715712676	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
d3bb0f3f-9d8a-41ee-8468-48aa5a33cb72	"\\"[]\\""	Updated issue Insecure File Upload cvss to 9.9	1715712676	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
715b2136-63c8-4fb1-ba90-10eda4150ffc	"\\"[]\\""	Updated issue Insecure File Upload	1715712684	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
5a074964-aa63-4008-be15-84f2120b6cef	"\\"[]\\""	Deleted Issue Insecure File Upload	1715712713	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
167c01d8-77cc-457e-98d3-6354cdd971f8	"\\"[]\\""	Deleted Issue Insecure File Upload	1715712713	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
427b8f49-0f56-4dfb-9afa-ebcf73ff8e4d	"\\"[]\\""	Added issue "Insecure File Upload"	1715712719	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
db88ff13-555a-4b28-a71b-0ab8ad5834d7	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715712737	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
b5227c64-f983-468c-a6b6-9843719f0160	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715712739	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
f2dfad06-42bb-463c-a8ab-b99699c4fc23	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715712739	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
525ebde8-2720-4ea2-afe2-04820d3f6261	"\\"[]\\""	Updated issue Insecure File Upload	1715712746	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
1cba8dda-3e24-44c3-abc1-cffa676d02d3	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.1	1715712786	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
04ca804a-7452-463f-960c-35ebf94b7eab	"\\"[]\\""	Updated issue Insecure File Upload	1715712793	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
cc6f9a9f-2dfc-4863-ba46-ec00933ec503	"\\"[]\\""	Updated issue Insecure File Upload field "origin_cvss_vector"	1715713637	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
87cd3d46-8e63-47a8-aa8b-15b5db29e91e	"\\"[]\\""	Updated issue Insecure File Upload	1715713655	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
2e4c0294-ce7d-4ddf-a913-79fa67414f1e	"\\"[]\\""	Updated issue Insecure File Upload	1715713720	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
2c765431-b516-4528-b9b3-8251cb5b0c2f	"\\"[]\\""	Updated issue Insecure File Upload	1715713728	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
cdf31ec6-e7d8-4b82-bc86-28655f770f5c	"\\"[]\\""	Updated issue Insecure File Upload field "origin_cvss_vector"	1715713741	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
ea47681b-d7e4-4d1c-ad43-b9636f6521b7	"\\"[]\\""	Updated issue Insecure File Upload field "cvss_vector"	1715713741	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
fbb362a8-5ce0-4632-9f42-ab41a521abc6	"\\"[]\\""	Updated issue Insecure File Upload field "origin_cvss_vector"	1715713742	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
3172f901-e232-4ba3-9406-f47754221928	"\\"[]\\""	Updated issue Insecure File Upload field "origin_cvss_vector"	1715713744	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
61750877-93d4-4d60-8b6a-29489e20bc22	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.4	1715714178	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
21852dca-e24a-4ef2-ad90-c3cecf0939ce	"\\"[]\\""	Updated issue Insecure File Upload field "origin_cvss_vector"	1715714178	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
1c1304cd-9bc0-4439-98c9-6549d2f144b2	"\\"[]\\""	Updated issue Insecure File Upload field "origin_cvss_vector"	1715714180	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
04dfcc83-5698-4dfa-9c6b-674d4d12b37c	"\\"[]\\""	Updated issue Insecure File Upload field "origin_cvss_vector"	1715714180	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
6f4132d0-c2ea-49e6-aed7-3b2efcae50f4	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.4	1715714180	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
a1d8702e-ef12-4f7e-a831-975dc8a31b3c	"\\"[]\\""	Updated issue Insecure File Upload cvss to 7.4	1715714181	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
e6584024-4b4a-48f0-8012-e3d579362e49	"\\"[]\\""	Updated issue Insecure File Upload field "origin_cvss_vector"	1715714181	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
2d77c2ef-9931-4f76-ad8b-1be509e7d9a4	"\\"[]\\""	Updated issue Insecure File Upload field "origin_cvss_vector"	1715714181	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
dc9b97ae-20c2-4222-a42b-f40ec41740ad	"\\"[]\\""	Updated issue Insecure File Upload field "origin_cvss_vector"	1715714283	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
16af8320-a089-4336-b97c-5961eac54ed5	"\\"[]\\""	Updated issue Insecure File Upload field "origin_cvss_vector"	1715714284	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
69f68b3c-09b0-477e-9256-19eba3e43b8d	"\\"[]\\""	Updated issue Insecure File Upload field "origin_cvss_vector"	1715714285	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
4f56da94-ef8a-4e7a-a11c-6833f048a625	"\\"[]\\""	Updated issue Insecure File Upload field "origin_cvss_vector"	1715714285	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
3ad064da-7563-477c-ad50-174ca6ea25d5	"\\"[]\\""	Updated issue Insecure File Upload field "origin_cvss_vector"	1715714285	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
e4a356a9-004b-4a17-9b20-189793c4be34	"\\"[]\\""	Updated issue Insecure File Upload field "origin_cvss_vector"	1715714285	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
71cdb348-5d5a-4175-acf2-b7e97fed1b14	"\\"[]\\""	Updated issue Insecure File Upload field "origin_cvss_vector"	1715714285	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
acb2a2a4-300b-493b-b21f-61bfb8d8a449	"\\"[]\\""	Updated issue Insecure File Upload field "origin_cvss_vector"	1715714299	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
e5081a95-665e-4b42-8d80-2235bb7b9687	"\\"[]\\""	Updated issue Insecure File Upload field "origin_cvss_vector"	1715714299	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
cf9bfe33-7803-4be2-bbc3-0c672969b0ed	"\\"[]\\""	Updated issue Insecure File Upload field "origin_cvss_vector"	1715714299	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
73443d9d-0491-4a1e-b91d-2b8c9bb23ba3	"\\"[]\\""	Updated issue Insecure File Upload field "origin_cvss_vector"	1715714300	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
49c30c18-1d83-42c2-9b6c-eb2293d17100	"\\"[]\\""	Updated issue Insecure File Upload	1715714303	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
64d454ca-d933-4594-9e1f-bb00af9e778e	"\\"[]\\""	Updated issue Insecure File Upload field "origin_cvss_vector"	1715714542	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
f0638f01-5a54-43a4-ae42-46b4709168fa	"\\"[]\\""	Updated issue Insecure File Upload field "origin_cvss_vector"	1715714542	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
aeac5667-b9ed-4c4f-92e7-dacff1e53a43	"\\"[]\\""	Updated issue Insecure File Upload	1715714547	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
cb0c1862-5b9b-4afb-80b3-981914962e57	"\\"[]\\""	Updated issue Insecure File Upload field "origin_cvss_vector"	1715714572	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
04ca775d-5e6d-4c06-bbd2-14059884cef6	"\\"[]\\""	Updated issue Insecure File Upload field "origin_cvss_vector"	1715714573	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
f209cce8-5fbf-49d1-9796-aefaf02f987e	"\\"[]\\""	Updated issue Insecure File Upload	1715714579	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
6f1dcec7-271a-4064-be16-bfe8f1070d1b	"\\"[]\\""	Updated issue Insecure File Upload	1715714725	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
758e2d70-6fca-44a7-be89-a700c9a50fd1	"\\"[]\\""	Updated issue Insecure File Upload	1715714828	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
5830b9f3-51a5-48d8-a3f9-ebf559a6331c	"\\"[]\\""	Updated issue Insecure File Upload	1715714944	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
d1f55d3c-6bf1-49ff-9304-80dd4a596f2e	"\\"[]\\""	Updated issue Insecure File Upload	1715715421	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
414994f4-6b27-49fe-8498-61122631a6c2	"\\"[]\\""	Added PoC ef13b909-c896-4e21-93ad-5e4f80ce3bb9 to issue Insecure File Upload	1715715632	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
e242a838-eec3-45a9-a06a-dcc5a6f81421	"\\"[]\\""	Updated issue Insecure File Upload	1715715632	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
0eaf1e98-5fe8-44b9-b191-b47780b78532	"\\"[]\\""	Added PoC 32b8fae0-6682-4533-a98d-22f442e25774 to issue Insecure File Upload	1715715777	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
2fea904b-9281-4888-8cf7-f3a8b6b02355	"\\"[]\\""	Updated issue Insecure File Upload	1715715777	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
a8f3d0ff-7808-4b5e-882e-f8c7f552748e	"\\"[]\\""	Added PoC 7eb26e49-545d-49cd-9d65-5c6b31201bcd to issue Insecure File Upload	1715715947	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
d6483558-b9c9-4aa5-a1a1-d507dcb59266	"\\"[]\\""	Updated issue Insecure File Upload	1715715947	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
6eb3f5f9-f1f9-407f-b8fc-fed8e6e082ef	"\\"[]\\""	Added PoC cb951d39-715b-4e67-a189-ce8cde0727ac to issue Insecure File Upload	1715716214	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
96864ed6-9d80-400d-999d-37e44a93832c	"\\"[]\\""	Updated issue Insecure File Upload	1715716214	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
60034188-1890-40cf-9352-3fd2f3d85c7d	"\\"[]\\""	Added PoC 4642b997-ee77-4a01-bfd8-2dc72e4d8d8f to issue Insecure File Upload	1715716277	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
da7a3250-44c0-4cbe-9ce4-0ae4f2d9bf9e	"\\"[]\\""	Updated issue Insecure File Upload	1715716277	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
a20c81cc-3e63-489f-a3ba-6068ad599800	"\\"[]\\""	Updated issue Insecure File Upload	1715716308	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
fa1525fd-2b8d-4afd-b5c7-9bc964518f57	"\\"[]\\""	Added new file report_2024-05-15T03:52:07.docx	1715716328	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
3aa5bf3c-7cf4-4c6a-81c0-fd2d926a76eb	"\\"[]\\""	Added new file report_2024-05-15T03:52:34.docx	1715716355	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
5024e529-b7ec-421c-9bf1-1f22b6235c05	"\\"[]\\""	Updated issue Insecure File Upload	1715754997	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
ca2ff95a-62bd-484a-ba41-915569cdebe9	"\\"[]\\""	Updated issue Insecure File Upload	1715755017	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
e7faca2c-8d39-45bf-bc3e-2d7a8fb6d1a7	"\\"[]\\""	Added new file report_2024-05-15T14:37:30.docx	1715755051	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
8f693379-ee45-49de-9bdd-2c69d108f89c	"\\"[]\\""	Added new file report_2024-05-15T14:37:44.docx	1715755065	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
04dc5de3-408c-461c-8af6-6ec1933acf45	"\\"[]\\""	Updated issue Insecure File Upload field "origin_cvss_vector"	1715784689	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
c782ddd5-fe85-4c32-a07b-6c77e1949fa3	"\\"[]\\""	Updated issue Insecure File Upload field "origin_cvss_vector"	1715784689	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
c09db01c-71f4-4d94-a7d9-a8886b1539b3	"\\"[]\\""	Updated issue Insecure File Upload	1715784921	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
9cfaa022-8803-4f16-9598-41ac903f8b3b	"\\"[]\\""	Updated issue Insecure File Upload	1715784965	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
3f4861c5-06d9-4c58-b393-5b8b7b678a86	"\\"[]\\""	Updated issue Insecure File Upload	1715784983	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
e0b800af-165e-42eb-8a51-9bb479ee235a	"\\"[]\\""	Updated project settings 	1715785197	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
79c51ee9-4f50-488b-80bf-e3320d417008	"\\"[]\\""	Updated project settings 	1715785200	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
767cd4c4-5c6e-4076-8e90-f1f85771fd3d	"\\"[]\\""	Added new credentials 45e928a3-2f9c-4c8c-baa5-53d95bb53ed2	1715789312	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
01cde350-fea3-43b3-9ecf-14b11a6c28a6	[]	Project EPT 13/5 was created!	1715791436	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	
5ce835af-ce65-44ca-bdea-99a551c5e5b7	"\\"[]\\""	Added ip uat-admin.myinvois.hasil.gov.my	1715791459	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	5e826717-ce5e-423c-be66-cbca319b2047
453ce9bd-5021-46fd-a662-a5edb96584c8	[]	Added issue template "File Information Disclosure"	1715792810	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	
67dd296f-8ecd-4069-936a-42a0fc3c6da0	[]	Added "v0.1WASA" report template.	1715793439	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	
6c25cbf1-98a5-4f9d-94e9-6df17ad2620e	"\\"[]\\""	Added issue "File Information Disclosure"	1715793465	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	5e826717-ce5e-423c-be66-cbca319b2047
1ad2eabe-c56c-469f-a975-4582eecaaadd	"\\"[]\\""	Updated issue File Information Disclosure field "origin_cvss_vector"	1715793512	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	5e826717-ce5e-423c-be66-cbca319b2047
745c7622-dc56-4140-bc35-9739ca4afa07	"\\"[]\\""	Updated issue File Information Disclosure	1715793523	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	5e826717-ce5e-423c-be66-cbca319b2047
1953bd4e-036f-4f20-88c0-b4ba9902642a	"\\"[]\\""	Updated issue File Information Disclosure	1715794050	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	5e826717-ce5e-423c-be66-cbca319b2047
30b0426a-85ab-4a31-8485-86ced2b1e2dc	"\\"[]\\""	Added PoC c86c1aea-00b6-457d-bd79-5b829d169c30 to issue File Information Disclosure	1715794121	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	5e826717-ce5e-423c-be66-cbca319b2047
72d90d2a-f702-42e6-9453-c0d238b02fa1	"\\"[]\\""	Updated issue File Information Disclosure	1715794121	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	5e826717-ce5e-423c-be66-cbca319b2047
eb4dddfc-b4ab-4b18-a35b-cddb09bf10b6	"\\"[]\\""	Updated issue File Information Disclosure	1715794135	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	5e826717-ce5e-423c-be66-cbca319b2047
58f52791-71ab-4e71-a4da-f6253586c395	"\\"[]\\""	Updated ip uat-admin.myinvois.hasil.gov.my description	1715794719	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	5e826717-ce5e-423c-be66-cbca319b2047
66affbf8-d617-41e9-95f3-67c772628755	"\\"[]\\""	Updated ip uat-admin.myinvois.hasil.gov.my description	1715794808	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	5e826717-ce5e-423c-be66-cbca319b2047
a9ef3c3d-f29a-43bf-a5ea-b1fda89f6d6b	"\\"[]\\""	Updated ip uat-admin.myinvois.hasil.gov.my description	1715794821	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	5e826717-ce5e-423c-be66-cbca319b2047
2de7db51-e0bb-4f04-85ed-0d46189fd05e	"\\"[]\\""	Added new file report_2024-05-16T01:43:55.docx	1715795035	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	5e826717-ce5e-423c-be66-cbca319b2047
36c32615-18c0-4887-8287-83a331433a7b	"\\"[]\\""	Added new file report_2024-05-16T01:49:58.txt	1715795398	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	5e826717-ce5e-423c-be66-cbca319b2047
92d83260-6533-47e2-b5f5-4ed019e0d6ef	"\\"[]\\""	Added new file report_2024-05-16T01:52:35.txt	1715795555	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	5e826717-ce5e-423c-be66-cbca319b2047
c53c81f0-f8a8-45e3-abd7-ce39ddf2af3a	"\\"[]\\""	Added new file report_2024-05-16T01:52:50.docx	1715795571	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	5e826717-ce5e-423c-be66-cbca319b2047
a5fe6b05-eb42-4558-a16c-66fb19d8bc9f	"\\"[]\\""	Added new file report_2024-05-16T01:56:06.txt	1715795766	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	5e826717-ce5e-423c-be66-cbca319b2047
0da165b9-f2f0-44be-a8d9-6fbf5c1c1cbf	"\\"[]\\""	Added new file report_2024-05-16T02:02:18.txt	1715796138	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	5e826717-ce5e-423c-be66-cbca319b2047
899fd1a9-b8bc-43fb-a1aa-4d55346fd86b	"\\"[]\\""	Added new file report_2024-05-16T02:10:25.txt	1715796625	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	5e826717-ce5e-423c-be66-cbca319b2047
c54239c5-fb28-4305-b29a-9ec48fa71528	"\\"[]\\""	Added new file report_2024-05-16T02:12:26.txt	1715796746	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	5e826717-ce5e-423c-be66-cbca319b2047
95059aba-dfd6-4f7f-9dcc-c7561f5b465a	"\\"[]\\""	Added new file report_2024-05-16T02:14:37.txt	1715796877	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	5e826717-ce5e-423c-be66-cbca319b2047
1b7177bb-4ec5-40cb-9dd9-63e5b2558f2b	"\\"[]\\""	Added new file report_2024-05-16T02:15:54.txt	1715796954	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	5e826717-ce5e-423c-be66-cbca319b2047
5d69ff67-061b-45d0-8cd4-2d7858f94d8f	"\\"[]\\""	Added new file report_2024-05-16T02:16:27.txt	1715796988	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	5e826717-ce5e-423c-be66-cbca319b2047
fe5ee92a-301e-4fc8-a678-a76a12b82bad	"\\"[]\\""	Added new file report_2024-05-16T02:17:37.txt	1715797057	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	5e826717-ce5e-423c-be66-cbca319b2047
07531abf-6453-4c1c-a6f3-134515112a7a	"\\"[]\\""	Added new file report_2024-05-16T02:18:09.txt	1715797089	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	5e826717-ce5e-423c-be66-cbca319b2047
187992b1-7275-44da-b7b9-7d380792dcfe	"\\"[]\\""	Added new file report_2024-05-16T02:19:57.txt	1715797197	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	5e826717-ce5e-423c-be66-cbca319b2047
d6d4841f-1ffc-43bb-b46c-4e71a2263f12	"\\"[]\\""	Added new file report_2024-05-16T02:21:07.txt	1715797267	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	5e826717-ce5e-423c-be66-cbca319b2047
2996b207-804d-44e5-99dd-9dc7fb101869	"\\"[]\\""	Updated issue File Information Disclosure	1715798600	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	5e826717-ce5e-423c-be66-cbca319b2047
c640fd0a-c986-46d9-916c-896bcb62a31b	"\\"[]\\""	Added new file report_2024-05-16T02:44:39.docx	1715798680	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	5e826717-ce5e-423c-be66-cbca319b2047
3b571a42-ebf7-4669-ace5-13325ed23f75	"\\"[]\\""	Added new file report_2024-05-16T02:47:27.docx	1715798848	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	5e826717-ce5e-423c-be66-cbca319b2047
51ab51b3-bdd4-4874-b775-4ce3fad00a45	"\\"[]\\""	Updated issue File Information Disclosure	1715798905	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	5e826717-ce5e-423c-be66-cbca319b2047
7198e77a-65de-4c0e-85a7-04092fd02c01	"\\"[]\\""	Added new file report_2024-05-16T02:48:42.docx	1715798922	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	5e826717-ce5e-423c-be66-cbca319b2047
faf85446-0293-4f5a-a666-3444429e50a9	"\\"[]\\""	Created new note "Unauthenticate SQL i"	1715801912	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
515aab57-6267-4b6a-a5f7-930fd08a871a	"\\"[]\\""	Edited note Unauthenticate SQL i	1715802000	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
3e59b092-9954-4ff8-a038-0e75c8200dc3	"\\"[]\\""	Edited note Unauthenticate SQL i	1715802001	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
69a03618-7cfc-4ae1-97e9-cf6b3c90eff5	"\\"[]\\""	Updated issue Insecure File Upload field "origin_cvss_vector"	1715809167	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
59eecb0a-087c-4f2c-912f-fda56d893356	"\\"[]\\""	Updated issue Insecure File Upload field "origin_cvss_vector"	1715809181	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
52b8bcc9-abe4-427f-8aa7-e20926e738e2	"\\"[]\\""	Updated issue Insecure File Upload field "origin_cvss_vector"	1715809181	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
138562e7-217a-4256-94b2-96ad3099e508	"\\"[]\\""	Updated issue Insecure File Upload	1715809184	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
044012ab-82ea-476c-9835-3ac70cf9ee18	"\\"[]\\""	Added new file report_2024-05-16T05:39:57.docx	1715809197	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
95ac1c0a-143a-496a-bedd-79c6022c017e	[]	Project Test Project Name was created!	1715840783	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	
857a1952-b6bd-4131-b5a4-1c0543ae2ab3	"\\"[]\\""	Added issue "Unauthenticate SQL injection"	1715840808	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
828a4e68-44c7-4ef2-9d88-afde17e19a7f	"\\"[]\\""	Added ip host1.com	1715840824	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
ac405b47-6a5a-492a-b274-456bb7cd08ef	"\\"[]\\""	Added ip host2.com	1715840831	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
5ea24947-46d9-4439-8d09-cc683fa9725c	"\\"[]\\""	Added ip host3.com	1715840839	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
cf22117d-4837-46fa-bb8c-7bb1297dc49a	"\\"[]\\""	Updated issue Unauthenticate SQL injection	1715840849	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
638b20f7-bb1c-49ee-84b4-18195dc07f42	"\\"[]\\""	Added issue "Cross Site Scripting (XSS)"	1715840862	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
dbe7091a-ab3b-4d5f-ae69-88347b86dbdd	"\\"[]\\""	Updated issue Cross Site Scripting (XSS)	1715840875	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
90ef34fc-7ba0-4b72-ac25-1cd481e370db	"\\"[]\\""	Added issue "Insecure File Upload"	1715840885	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
e92a21d3-f598-4f64-b172-15cf3e44b70f	"\\"[]\\""	Updated issue Insecure File Upload field "origin_cvss_vector"	1715840901	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
3a4b20b8-59ca-42b8-ac60-25c49a8f78fe	"\\"[]\\""	Updated issue Insecure File Upload	1715840910	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
af8eaa20-1be4-4313-bdd0-f25d8ac51713	"\\"[]\\""	Added issue "File Information Disclosure"	1715840923	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
b082fe1f-2d49-4f32-b05a-bc58a16e5efb	"\\"[]\\""	Updated issue File Information Disclosure	1715840933	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
10b8ab10-56c5-4b50-9518-56395322709c	"\\"[]\\""	Updated issue File Information Disclosure	1715840943	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
ff260555-c105-455e-94c6-da7b97e65142	"\\"[]\\""	Updated issue File Information Disclosure field "origin_cvss_vector"	1715840985	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
f93f0209-ab8a-4fdf-8a4a-7d78491b2e68	"\\"[]\\""	Updated issue File Information Disclosure	1715840993	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
684bb9d4-c5ea-447a-af01-923f5133058d	"\\"[]\\""	Updated issue Unauthenticate SQL injection	1715841056	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
e0242419-a599-46a6-a974-0e36942aa08b	"\\"[]\\""	Updated issue Cross Site Scripting (XSS)	1715841070	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
ab45b789-e3ce-4d4d-91fd-3d37b37204df	"\\"[]\\""	Updated issue Insecure File Upload	1715841088	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
996923b0-ae0a-4798-b4e2-deb5716b5815	"\\"[]\\""	Added issue "Unauthenticate SQL injection"	1715906608	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
bb0dc380-baeb-4d28-a044-41084e47bc28	"\\"[]\\""	Updated issue Unauthenticate SQL injection	1715906613	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
568a7894-dd9d-4f10-98fc-7e892e1daa74	"\\"[]\\""	Added ip testurlyangpanjang.lhdn.gov.my	1715906669	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
1f89c88d-1de3-46e5-bae0-509dfb303aec	"\\"[]\\""	Added new file report_2024-05-17T08:47:51.txt	1715906871	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
1861db90-8524-492c-9f66-6a12769b1313	"\\"[]\\""	Added new file report_2024-05-17T08:48:05.txt	1715906885	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
86f7c41a-8df6-4435-aac8-e19d7aadcbe9	"\\"[]\\""	Added new file report_2024-05-17T08:50:36.txt	1715907036	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
26283d36-715b-4cf2-9eb7-5110e5e566c3	"\\"[]\\""	Added new file report_2024-05-17T08:50:42.txt	1715907042	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
eb37ad13-dcea-4721-86ae-e0329959b52b	"\\"[]\\""	Added new file report_2024-05-17T08:54:50.txt	1715907290	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
8a4f8b0a-26de-4433-8842-0da8e213d3e2	"\\"[]\\""	Added new file report_2024-05-17T08:55:37.txt	1715907337	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
3e552d18-ad13-4ee5-8512-40ca54bee346	"\\"[]\\""	Added new file report_2024-05-17T08:57:20.txt	1715907440	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
bee8df3c-074c-451e-aaa5-411de93b4a15	"\\"[]\\""	Updated issue Unauthenticate SQL injection	1715907551	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
6d2f91ba-c8ae-4f5a-bebc-c9ceead065a2	"\\"[]\\""	Added new file report_2024-05-17T08:59:22.txt	1715907562	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
a71aea91-9dc4-400f-99c9-2e2be1dedbe4	"\\"[]\\""	Added new file report_2024-05-17T09:01:56.txt	1715907716	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
4b8ba4d1-67d1-4ca2-8be3-b079bbda309f	[]	Added "Tracker csv" report template.	1715907895	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	
6a1e7c44-92f4-4875-8590-bf8c9524830c	"\\"[]\\""	Added new file report_2024-05-19T12:32:00.txt	1716093120	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
f4f5a709-d1ca-4121-b47e-c67b31027118	"\\"[]\\""	Added new file report_2024-05-19T12:34:10.txt	1716093250	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
f521e9da-baa1-4c33-b99f-2a88678bc1d2	"\\"[]\\""	Added new file report_2024-05-19T12:56:09.txt	1716094569	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
6fa33ab7-fd1f-487f-83b6-db5798809593	"\\"[]\\""	Added new file report_2024-05-19T13:01:35.txt	1716094895	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
276543a0-44ff-4743-80cf-e404fda416b1	"\\"[]\\""	Added new file report_2024-05-19T13:05:04.docx	1716095105	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
d23bf5a9-fc19-4f52-9080-f7f234c616a3	"\\"[]\\""	Added new file report_2024-05-19T13:09:35.txt	1716095375	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
e8c7bcab-4467-4ecd-a6ce-22ba9733854b	"\\"[]\\""	Added new file report_2024-05-19T13:11:50.txt	1716095510	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
fd8bdf86-8037-47a8-8353-bd84772ff43e	"\\"[]\\""	Added new file report_2024-05-19T13:13:04.txt	1716095584	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
47ced113-0c6a-4696-831c-8a7c8b159fbe	"\\"[]\\""	Added new file report_2024-05-19T13:16:13.txt	1716095773	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
e0c430b2-8c37-4212-8230-05b0e0ca5634	[]	Deleted "Tracker csv" template	1716095883	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	
2bebf8d4-3b4b-4608-bbc8-11bd133d931f	[]	Added "Tracker excel" report template.	1716095895	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	
77e2113e-c735-4602-b8e8-4fd8f04bc141	"\\"[]\\""	Added new file report_2024-05-19T13:20:49.docx	1716096049	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
058b1e97-0e87-4c87-be46-ff5f231b6dbc	"\\"[]\\""	Added new file report_2024-05-19T13:21:20.docx	1716096080	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
9253673c-86c5-4e10-abcb-97400bce921c	"\\"[]\\""	Added new file report_2024-05-19T13:34:59.docx	1716096900	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
83f3dcb0-3eb0-465b-ba74-b8eb55b1a6ef	"\\"[]\\""	Added new file report_2024-05-19T13:35:08.docx	1716096909	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
6f8a062f-63ef-48c0-8c16-fea063741b3a	"\\"[]\\""	Added new file report_2024-05-19T13:37:27.docx	1716097048	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
4077d567-267c-4e98-a063-635975814979	"\\"[]\\""	Added new file report_2024-05-19T13:37:54.docx	1716097075	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
ffc98c43-25f2-4706-8017-7d3223fe6cb5	"\\"[]\\""	Added new file report_2024-05-19T13:43:37.docx	1716097418	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
c59fa8cc-33a1-4a70-a9f2-0a82dd9051f1	"\\"[]\\""	Added new file report_2024-05-19T13:47:29.docx	1716097650	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
7d4750d2-76eb-4f42-b6a8-125463c1a0db	"\\"[]\\""	Added new file report_2024-05-19T13:49:17.docx	1716097758	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
9f235e25-4ff2-4ee1-9be8-fcdcfd7b4d3f	"\\"[]\\""	Added new file report_2024-05-19T13:49:39.docx	1716097780	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
32b35c53-f120-4b5d-8d5a-19e9ce99d03a	"\\"[]\\""	Added new file report_2024-05-19T13:58:05.docx	1716098285	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
31d8b81e-fc31-49a1-9fc6-d7d0543bfa49	"\\"[]\\""	Added new file report_2024-05-19T14:07:03.docx	1716098824	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
5ea28170-407c-41d1-8cc1-2d34615ea267	"\\"[]\\""	Added new file report_2024-05-19T14:09:22.docx	1716098963	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
0ae07f62-73ad-463f-83d6-feb0410e19dd	"\\"[]\\""	Added new file report_2024-05-19T14:18:10.docx	1716099491	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
a76a5339-bdac-4bd0-81a0-2a79a4e45812	"\\"[]\\""	Added new file report_2024-05-19T14:21:55.docx	1716099716	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
1127db77-cb08-4d40-bdfe-ef6cc5340771	"\\"[]\\""	Added new file report_2024-05-19T14:24:13.docx	1716099854	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
a5d7324a-4a72-4ef1-abeb-50dad01f77c6	"\\"[]\\""	Added new file report_2024-05-19T15:31:10.docx	1716103871	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
510c6df7-6cc6-4829-a42a-68c6f2031bc0	"\\"[]\\""	Added new file report_2024-05-19T17:06:42.docx	1716109603	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
574cc74d-c709-4bff-99d5-62cdce818270	"\\"[]\\""	Added new file report_2024-05-19T17:20:49.docx	1716110450	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
a27e2fa0-e313-4884-9b50-16dbefc056bf	"\\"[]\\""	Added new file report_2024-05-19T17:27:44.docx	1716110864	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
87bd6bc5-ee7d-4d9c-8dec-3c3d91fb51ca	"\\"[]\\""	Updated issue Unauthenticate SQL injection	1716111240	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
e0d9d13b-b354-4487-9b47-f4343d2460f2	"\\"[]\\""	Added new file report_2024-05-19T17:34:16.docx	1716111257	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
0ac3b163-5230-4547-a262-0a01bc8ce440	"\\"[]\\""	Added new file report_2024-05-19T17:52:11.docx	1716112331	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
aadce58f-02eb-4589-a0a9-d5cbe9237951	"\\"[]\\""	Added new file report_2024-05-19T17:52:52.docx	1716112373	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
67b1148d-6b80-44ec-b7cd-232d70270daf	"\\"[]\\""	Added new file report_2024-05-19T17:53:30.docx	1716112411	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
2203a4be-a2f1-4ede-b026-e46c8f05b19e	"\\"[]\\""	Added new file report_2024-05-19T17:57:03.docx	1716112623	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
d8ecb64a-5a88-4be3-ba60-e1dbc5a81437	"\\"[]\\""	Added new file report_2024-05-19T17:59:23.docx	1716112764	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
ea5e3aba-8535-48ab-93b8-176c70480c64	"\\"[]\\""	Added new file report_2024-05-19T18:11:49.docx	1716113510	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
f1ea615e-d9bb-4930-aca1-16badb6a0e3e	"\\"[]\\""	Added new file report_2024-05-19T18:21:24.docx	1716114085	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
e2b783b5-f9de-4ac9-89ed-d338410bb561	"\\"[]\\""	Added new file report_2024-05-19T18:23:39.docx	1716114220	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
766a5fbc-7129-4f86-8462-79f596e8439c	"\\"[]\\""	Added new file report_2024-05-19T18:26:54.docx	1716114414	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
6c4337f4-485d-45eb-83ce-ae52e580e9b4	"\\"[]\\""	Added new file report_2024-05-19T18:30:19.docx	1716114620	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
e71925c6-689d-46e6-abae-45734c4e1cb0	"\\"[]\\""	Added new file report_2024-05-19T18:35:02.docx	1716114903	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
e00169d8-8c82-42fe-b92c-7869ad19abe7	"\\"[]\\""	Added new file report_2024-05-19T18:35:24.docx	1716114924	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
27c75c5e-4219-4e79-ae78-04a258a326ab	"\\"[]\\""	Added new file report_2024-05-19T18:35:58.docx	1716114959	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
01529093-3223-4317-a930-094f4cda559f	"\\"[]\\""	Added new file report_2024-05-19T18:39:14.docx	1716115155	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
76eaa0ad-9143-46bb-a9f9-4e2c2c7e6363	"\\"[]\\""	Added new file report_2024-05-19T18:39:59.docx	1716115199	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
01d9336a-c670-468d-ba58-50455d1b4fd8	"\\"[]\\""	Added new file report_2024-05-19T18:40:25.docx	1716115226	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
9ee97a2e-c64d-40d1-87cf-4ce59eb274fd	"\\"[]\\""	Added new file report_2024-05-19T20:11:02.docx	1716120663	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
f2e74f47-c20f-4b29-b52a-7f2c67daca01	"\\"[]\\""	Added new file report_2024-05-19T20:12:31.docx	1716120751	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
57d067fd-daa5-43b6-b0b0-0b097c2fc2f1	"\\"[]\\""	Added new file report_2024-05-19T20:22:08.docx	1716121329	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
6c5ab579-8850-4378-aad0-d28a076b9cb8	"\\"[]\\""	Added new file report_2024-05-19T20:23:35.docx	1716121416	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
5885103f-8a3c-4287-ac5a-3849195da5e1	"\\"[]\\""	Added new file report_2024-05-19T20:26:07.docx	1716121568	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
d47c54fa-6d95-4aeb-972f-016d427bf75f	"\\"[]\\""	Added new file report_2024-05-19T20:30:58.docx	1716121859	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
452fff11-69eb-491b-b4a4-60745795f238	"\\"[]\\""	Added new file report_2024-05-19T20:33:37.docx	1716122018	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
cf35469f-9c92-4e18-80a1-b3a7d443c094	"\\"[]\\""	Added new file report_2024-05-19T20:35:39.docx	1716122139	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
c0311df1-5dfa-4fc0-937c-cb4273f8d794	"\\"[]\\""	Added new file report_2024-05-19T20:36:20.docx	1716122181	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
2e77acc2-e09f-4d89-a2d3-001c8f939ced	"\\"[]\\""	Added new file report_2024-05-19T20:38:00.docx	1716122280	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
4c6ecd59-318c-4b15-ae7d-ff5022592a7c	"\\"[]\\""	Added new file report_2024-05-19T20:40:47.docx	1716122448	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
d62cfa1b-21c6-4837-8465-d92e5b5fbfc5	"\\"[]\\""	Added new file report_2024-05-19T20:41:19.docx	1716122480	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
32846f71-f268-4309-81f1-7aaaddf5c6e3	"\\"[]\\""	Added new file report_2024-05-19T20:50:29.docx	1716123030	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
bb2241c8-74ae-4d60-882f-86ae34b927e6	"\\"[]\\""	Added new file report_2024-05-19T21:01:31.docx	1716123691	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
a2eb23bc-58b6-4854-8037-7edf704ef1d0	"\\"[]\\""	Added new file report_2024-05-19T21:03:57.docx	1716123838	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
d60fec7b-b293-415f-b3e9-9b165e0b6a7b	"\\"[]\\""	Added new file report_2024-05-19T21:05:40.docx	1716123940	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
4e3be8c9-f958-4ae0-8cea-67361a5b690f	"\\"[]\\""	Added new file report_2024-05-19T21:06:20.docx	1716123981	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
52f18ce1-0e93-482c-808f-a7bf892eb7de	"\\"[]\\""	Added new file report_2024-05-19T21:06:45.docx	1716124006	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
8dbbba11-1b48-4043-a5e1-1bdedae4f1eb	"\\"[]\\""	Added new file report_2024-05-19T21:12:24.docx	1716124344	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
f4ad847e-a261-4ff6-8165-4a0a84bfd11f	"\\"[]\\""	Added new file report_2024-05-19T21:26:30.docx	1716125191	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
c1162ec2-b92e-42af-aef0-6687316a2f42	[]	Project WASA 2024 was created!	1716170744	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	
6fe24f80-9dae-4dad-afe9-a1daa2c50cfe	"\\"[]\\""	Added ip pentest-portal.mardi.gov.my/	1716170764	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0dbc2858-bc39-4c8d-8cb5-b5a43eb38d99
54da7250-1a1c-4ddd-b10c-63cca856b557	"\\"[]\\""	Added new credentials 1f6e1e44-212a-4b13-ab5e-f45ab6bdf546	1716171145	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0dbc2858-bc39-4c8d-8cb5-b5a43eb38d99
ab945667-3dd2-456c-a958-dc3a5484622d	"\\"[]\\""	Added new credentials bc2ee5af-cd58-49e9-a1ae-f4bea51dd3a3	1716171164	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0dbc2858-bc39-4c8d-8cb5-b5a43eb38d99
64c94c0d-d057-4989-9d2d-3ee083b29aee	[]	Added issue template "htaccess file disclosure"	1716175927	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	
4745fe19-d585-4ba8-9850-423aea74e2bf	"\\"[]\\""	Added issue ".htaccess Disclosure"	1716175938	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0dbc2858-bc39-4c8d-8cb5-b5a43eb38d99
2db63726-2a8f-44ec-b3bf-e05ac6b80909	"\\"[]\\""	Updated issue .htaccess Disclosure field "origin_cvss_vector"	1716176067	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0dbc2858-bc39-4c8d-8cb5-b5a43eb38d99
913a70df-2c83-49a6-8ba7-d457010e7df3	"\\"[]\\""	Added PoC c03e5c87-69ec-44c1-855b-2805eb4dcd12 to issue .htaccess Disclosure	1716176087	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0dbc2858-bc39-4c8d-8cb5-b5a43eb38d99
05cde1cf-69c2-4090-ad04-8887a503f634	"\\"[]\\""	Updated issue .htaccess Disclosure	1716176096	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0dbc2858-bc39-4c8d-8cb5-b5a43eb38d99
4575dd71-cc74-4bf8-95fd-7b8c0e4139c7	"\\"[]\\""	Updated issue .htaccess Disclosure	1716176121	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0dbc2858-bc39-4c8d-8cb5-b5a43eb38d99
0433e8f1-0228-4d00-84cf-c415476a0f0c	"\\"[]\\""	Updated issue .htaccess Disclosure field "origin_cvss_vector"	1716176141	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0dbc2858-bc39-4c8d-8cb5-b5a43eb38d99
3eab91f9-1169-469d-9c87-cbde19c4cafc	"\\"[]\\""	Updated issue .htaccess Disclosure field "origin_cvss_vector"	1716176142	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0dbc2858-bc39-4c8d-8cb5-b5a43eb38d99
865c527e-e92f-4387-90dc-526f5e03f215	"\\"[]\\""	Updated issue .htaccess Disclosure	1716176145	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0dbc2858-bc39-4c8d-8cb5-b5a43eb38d99
e6091528-b178-4fb6-ad80-9b710dad0735	"\\"[]\\""	Updated issue .htaccess Disclosure	1716176220	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0dbc2858-bc39-4c8d-8cb5-b5a43eb38d99
ef4ffc3d-c7ce-4560-9ebb-45acb1173b5c	"\\"[]\\""	Updated issue .htaccess Disclosure	1716176224	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0dbc2858-bc39-4c8d-8cb5-b5a43eb38d99
f8b8d379-bacd-4b0a-9e54-9de4805b21cd	"\\"[]\\""	Updated issue .htaccess Disclosure	1716176272	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0dbc2858-bc39-4c8d-8cb5-b5a43eb38d99
388cd498-89ea-4a03-942a-010a62e96564	"\\"[]\\""	Updated issue .htaccess Disclosure	1716176275	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0dbc2858-bc39-4c8d-8cb5-b5a43eb38d99
1a8c8ae6-0e77-4f5e-a14b-5c468bd7d372	"\\"[]\\""	Updated issue .htaccess Disclosure	1716176302	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0dbc2858-bc39-4c8d-8cb5-b5a43eb38d99
fb17c227-9a79-4de1-a3a2-e8608d41d282	[]	Edited issue template "htaccess file disclosure"	1716176365	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	
58a0ee7b-ce4e-45aa-b2c2-17882436d9eb	[]	Added issue template "Joomla XML disclose file and version"	1716179144	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	
2e747a46-e631-4748-887f-dff9be5ec977	[]	Edited issue template "Joomla XML disclose file and version"	1716179198	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	
669d28fc-ac9c-4132-b03b-0b548d229afa	"\\"[]\\""	Added issue "Joomla XML disclose file and version"	1716179211	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0dbc2858-bc39-4c8d-8cb5-b5a43eb38d99
fea7fc23-4c26-4beb-8f4b-d0edaa3298df	"\\"[]\\""	Updated issue Joomla XML disclose file and version	1716179289	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0dbc2858-bc39-4c8d-8cb5-b5a43eb38d99
ed196e09-95f3-4ef0-9dd3-549ce3c009b0	"\\"[]\\""	Added PoC 70c2264b-b981-41a2-8757-7b819b8c3e7a to issue Joomla XML disclose file and version	1716179324	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0dbc2858-bc39-4c8d-8cb5-b5a43eb38d99
b5cca229-47b6-49a3-950c-557417ef3427	"\\"[]\\""	Updated issue Joomla XML disclose file and version	1716179324	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0dbc2858-bc39-4c8d-8cb5-b5a43eb38d99
0b8baa36-a063-4954-aefb-4d80ff918e0b	"\\"[]\\""	Added PoC 06340ae6-cd3a-40b9-898f-d0728df35629 to issue Joomla XML disclose file and version	1716179353	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0dbc2858-bc39-4c8d-8cb5-b5a43eb38d99
533865b5-2ff5-4e5c-b7c6-290803712f2a	"\\"[]\\""	Updated issue Joomla XML disclose file and version	1716179353	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0dbc2858-bc39-4c8d-8cb5-b5a43eb38d99
41a1238b-aa5e-4cc6-bab5-1170986bb2af	[]	Added issue template "Joomla Sensitive Folder disclosure"	1716179666	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	
038c1dd1-cccb-44f6-8bfa-2afa46700788	"\\"[]\\""	Added issue "Joomla Administrator Folder disclosure"	1716179676	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0dbc2858-bc39-4c8d-8cb5-b5a43eb38d99
68219f38-8a4e-41d2-a821-3690e9e71359	"\\"[]\\""	Updated issue Joomla Administrator Folder disclosure	1716179731	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0dbc2858-bc39-4c8d-8cb5-b5a43eb38d99
f20b919d-f4c9-49c0-8cc3-495f41d8206f	"\\"[]\\""	Added PoC 04a0acb7-8c82-4d2f-b2c7-ed51e766548a to issue Joomla Administrator Folder disclosure	1716179773	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0dbc2858-bc39-4c8d-8cb5-b5a43eb38d99
c7250e92-d5d1-4941-84b4-245280511f05	"\\"[]\\""	Updated issue Joomla Administrator Folder disclosure	1716179773	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0dbc2858-bc39-4c8d-8cb5-b5a43eb38d99
20d7aa99-e63a-47a9-975a-455a19c797cd	"\\"[]\\""	Added new file report_2024-05-20T18:35:57.docx	1716201358	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0dbc2858-bc39-4c8d-8cb5-b5a43eb38d99
289f32d4-f27d-4959-b11c-d9444f99655d	"\\"[]\\""	Added new file report_2024-05-20T18:36:56.txt	1716201416	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0dbc2858-bc39-4c8d-8cb5-b5a43eb38d99
4fda1b43-839f-4b01-8c4c-06f11eeed08c	"\\"[]\\""	Updated issue Unauthenticate SQL injection	1716221751	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
19d821d3-b4d7-48e2-8300-92e7413f8066	[]	Deleted "v0.1WASA" template	1716221765	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	
d3075f4e-c8ed-4888-89e5-d9088f024aaa	[]	Added "WASA" report template.	1716221773	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	
fcbd57ee-b493-4f44-a306-5ebca3fead53	"\\"[]\\""	Added new file report_2024-05-21T00:16:29.docx	1716221790	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
edfdc410-a9de-41f0-af37-a1f8409b98cf	"\\"[]\\""	Added new file report_2024-05-21T00:17:27.docx	1716221849	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
3383b592-31d0-4034-993f-2ca9346a90f2	"\\"[]\\""	Added new file report_2024-05-21T00:19:30.docx	1716221971	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
60984d6b-944d-4a15-9441-bac5ec97a13d	[]	Project WASA 2024 was created!	1716281260	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	
b2396232-8251-4535-bef4-dc201581e9c2	"\\"[]\\""	Added ip livechat.ptptn.gov.my	1716281274	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
fb181c98-03db-4625-aadc-834dcebaff80	"\\"[]\\""	Added issue "Directory Listing"	1716281440	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
72d4f899-40d8-4a80-8a66-e78d2b1b12b6	"\\"[]\\""	Updated issue Directory Listing	1716281877	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
0a181b48-a451-4fe0-aa85-90525925173f	"\\"[]\\""	Added PoC 6cea90cb-5efe-44e3-ad97-0f61f73d12a9 to issue Directory Listing	1716281922	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
85f057cf-a87e-47c7-a14e-530078602687	"\\"[]\\""	Updated issue Directory Listing	1716281923	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
3915b09a-923c-4c87-b53e-735164b111e9	"\\"[]\\""	Added ip myptptnstg.ptptn.gov.my	1716290312	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
1d7a65e7-0b83-4d9a-844b-bcd5ecd91a3f	[]	Added issue template "Error disclose information"	1716290646	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	
6e6eb6de-cd37-4608-8ead-1dece6cc537a	"\\"[]\\""	Added issue "Error Message Disclose Sensitive information"	1716290685	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
b0931e52-7506-4551-9179-068e08e91261	"\\"[]\\""	Updated issue Error Message Disclose Sensitive information	1716290782	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
79bbb4fd-8a44-4bc5-810e-0aee67f1bd02	"\\"[]\\""	Added PoC fb7e8756-b3a4-47ce-9a32-8e5623f7728c to issue Error Message Disclose Sensitive information	1716290837	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
e787d8d3-6e90-4402-8cdb-d906fc498a5c	"\\"[]\\""	Updated issue Error Message Disclose Sensitive information	1716290837	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
744be454-c97b-4027-a1e3-55c9af86ea91	[]	Added issue template "Broken Access Control"	1716296281	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	
f634e3ac-d807-491f-92bc-d407d2fb8540	"\\"[]\\""	Added issue "Broken Access Control able to view other loan details"	1716296297	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
e8f67550-3f8c-465d-8b45-e57ad2f15b3e	"\\"[]\\""	Updated issue Broken Access Control able to view other loan details	1716296495	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
95f0870c-331b-48ab-b92b-fff93b31b4ee	"\\"[]\\""	Added PoC 621db168-6920-4c3d-a864-5d20cedff469 to issue Broken Access Control able to view other loan details	1716296574	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
f802356e-f85c-4bc5-87d6-56d5937585d3	"\\"[]\\""	Updated issue Broken Access Control able to view other loan details	1716296574	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
104976d2-aa38-418a-a98c-6770789ba40d	"\\"[]\\""	Added PoC 3217868d-fc4e-4a8d-98df-06cd9f747f16 to issue Broken Access Control able to view other loan details	1716296665	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
0385b58b-de28-4ca3-9438-4e72d732fefd	"\\"[]\\""	Updated issue Broken Access Control able to view other loan details	1716296666	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
f66e2092-96cd-4605-88c9-2e2be4ecbec6	"\\"[]\\""	Added PoC 49652a5f-004a-496a-baab-6acab3aa2bd3 to issue Broken Access Control able to view other loan details	1716296785	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
669bbd30-a084-44bd-9b01-141e4142138b	"\\"[]\\""	Updated issue Broken Access Control able to view other loan details	1716296785	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
7d37f435-aff2-4f64-8d3d-d2af735dcba0	"\\"[]\\""	Added PoC af867938-cd4b-4acf-9c90-c616c0948e45 to issue Broken Access Control able to view other loan details	1716296914	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
bafe836e-65de-4409-bdef-8bc0ba1754cc	"\\"[]\\""	Updated issue Broken Access Control able to view other loan details	1716296914	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
9681b375-a1a5-4e05-b8f5-b8f0fbe9ba4b	"\\"[]\\""	Added PoC bf517ed4-7704-43c9-bee8-bef94c6e13ef to issue Broken Access Control able to view other loan details	1716297018	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
aaabfed6-5e7a-497a-b866-51cad12807d5	"\\"[]\\""	Added ip myptptn.ptptn.gov.my	1716297757	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
51e3c694-b8c5-4def-9097-8fd60149a0cc	"\\"[]\\""	Updated ip myptptnstg.ptptn.gov.my description	1716297782	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
33353e5a-6548-48e9-b4fc-fc8c2183f61b	"\\"[]\\""	Added issue "Error Message Disclose Sensitive information"	1716297822	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
3547103a-eaf4-4677-8938-30599fbffad4	"\\"[]\\""	Added issue "Broken Access Control able to view other loan details"	1716297840	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
4aa04163-c696-47b2-950f-e01a59471df8	"\\"[]\\""	Updated issue Broken Access Control able to view other loan details	1716297898	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
527e04a1-26fa-4172-af3f-5ec42bf4807b	"\\"[]\\""	Added PoC 07f47bf9-1e6d-412a-9f29-cda21db525ea to issue Broken Access Control able to view other loan details	1716297950	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
390b6469-21d7-4124-b225-1dc5f69c1f5a	"\\"[]\\""	Updated issue Broken Access Control able to view other loan details	1716297951	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
52dc1e94-5fee-434d-b7d4-4549c0baf425	"\\"[]\\""	Added PoC a517df9f-dc60-4411-880e-094b82280678 to issue Broken Access Control able to view other loan details	1716297987	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
8d9debe0-f578-4773-a109-f64f2dfcfc81	"\\"[]\\""	Updated issue Broken Access Control able to view other loan details	1716297987	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
7907ff3b-c0ca-4170-8485-00ccfaa21e73	"\\"[]\\""	Added PoC 1c6846ba-72ba-44f6-b079-52034bb248a4 to issue Broken Access Control able to view other loan details	1716298046	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
a73884b7-f3a3-4f77-b926-436a3da34d52	"\\"[]\\""	Updated issue Broken Access Control able to view other loan details	1716298046	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
851854fa-e3a4-464e-a492-eb3e90d1808a	"\\"[]\\""	Added PoC 260631bc-fdf2-493c-af38-48ecdf165f80 to issue Broken Access Control able to view other loan details	1716298105	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
3ba092cc-b002-4de0-8164-ac7d7bd0c82d	"\\"[]\\""	Updated issue Error Message Disclose Sensitive information	1716298207	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
5885d5ba-67c3-49ae-8066-f6897b54bb1b	"\\"[]\\""	Deleted Issue Error Message Disclose Sensitive information	1716298906	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
c3660d47-a1fa-4248-9932-445c6ce383a1	"\\"[]\\""	Added new file report_2024-05-21T21:42:07.docx	1716298928	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
eadf67f1-6744-44ac-873d-5c96f3eece6f	"\\"[]\\""	Added new file report_2024-05-21T21:43:38.docx	1716299019	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
047e288f-2583-43c0-b5fb-225de298f207	"\\"[]\\""	Added new file report_2024-05-21T21:43:51.txt	1716299031	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
6adeba28-6785-4b6f-bd47-ecede24f2110	[]	Project WASA 2024 was created!	1716442537	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	
c5af416b-c7e3-4ae2-b4bc-f7b1126c42ff	"\\"[]\\""	Added ip gateway.n9pay.ns.gov.my	1716442588	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	af66f73f-15ab-4c1e-8537-ef381a0a6025
37bfee12-4144-453c-bc7b-14a66c35857b	[]	Added issue template "Server Header Disclosure"	1716442890	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	
31e3e427-9f98-4680-b5cc-dfba27d1cc90	"\\"[]\\""	Added issue "Server Header Disclosure"	1716442909	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	af66f73f-15ab-4c1e-8537-ef381a0a6025
b888a33f-4d0a-4159-94f0-3c13d048e715	"\\"[]\\""	Updated issue Server Header Disclosure	1716443076	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	af66f73f-15ab-4c1e-8537-ef381a0a6025
97baa0f9-9700-494e-937f-313840c15750	"\\"[]\\""	Added PoC ee88d893-1300-4828-b56c-96d0c8397c6c to issue Server Header Disclosure	1716443217	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	af66f73f-15ab-4c1e-8537-ef381a0a6025
f109c18b-e0db-47f2-b8f0-93ce64d21ca6	"\\"[]\\""	Updated issue Server Header Disclosure	1716443217	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	af66f73f-15ab-4c1e-8537-ef381a0a6025
26343827-dd02-4881-8e6e-ff0a4b2f0f9a	"\\"[]\\""	Updated issue Server Header Disclosure	1716443280	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	af66f73f-15ab-4c1e-8537-ef381a0a6025
d78d9746-829d-4e52-bac6-6bdf153dd9c9	"\\"[]\\""	Added new file report_2024-05-23T13:48:16.docx	1716443297	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	af66f73f-15ab-4c1e-8537-ef381a0a6025
587850b9-16c2-41c5-a8cf-1453c8b3f0dc	[]	Project GPKI WASA was created!	1716729895	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	
d0d11db6-1f2a-4787-afb0-274b014e9110	"\\"[]\\""	Added ip GPKI Mobile	1716729977	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
8dd342ed-9123-41d1-b725-1989f8f3de75	"\\"[]\\""	Added issue "Broken Access Control able to view other loan details"	1716731030	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
89cbc1ea-61c3-424d-816f-1b227aa41c56	"\\"[]\\""	Updated issue Broken Access Control able to View other profile	1716731264	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
421d5c3a-4042-4de2-9dc0-e0b7a9cc2cc8	"\\"[]\\""	Added PoC b8329961-0abe-4d0c-a1d6-abb95edb206c to issue Broken Access Control able to View other profile	1716731291	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
0cd2c99f-79c8-4456-9732-4cad997ad903	"\\"[]\\""	Updated issue Broken Access Control able to View other profile	1716731291	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
13702f6b-af81-4875-8df9-c096b6500cae	"\\"[]\\""	Added PoC 31f1dc52-9c41-46d5-8a21-3b761fdc0930 to issue Broken Access Control able to View other profile	1716731364	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
04a52883-0896-4219-bf35-6edebf16791d	"\\"[]\\""	Updated issue Broken Access Control able to View other profile	1716731364	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
671d44dc-97c5-4763-9c47-c4252b14e30a	"\\"[]\\""	Added PoC 227a8282-c14b-4d29-8dde-7a9562594a91 to issue Broken Access Control able to View other profile	1716731537	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
9f0fad0c-e524-4980-b219-12305abafc54	"\\"[]\\""	Updated issue Broken Access Control able to View other profile	1716731537	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
f8f537d2-6399-4cbd-9ba1-af53f78c7621	"\\"[]\\""	Added issue "Broken Access Control able to view other loan details"	1716733688	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
03fac3c8-f785-4001-a546-96a70f330107	"\\"[]\\""	Updated issue Broken Access Control able to View other user Identity	1716733765	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
e93a0dc0-8732-4e81-b44d-3fd18d416e05	"\\"[]\\""	Updated issue Broken Access Control able to view other Profile	1716733873	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
9792a410-6396-4dab-b766-40d82bd51552	"\\"[]\\""	Added PoC 15addddd-d833-48c3-853f-16009fb670e9 to issue Broken Access Control able to view other Profile	1716733908	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
6d51048f-829a-4bb7-bc1b-cc430dd3219c	"\\"[]\\""	Updated issue Broken Access Control able to view other Profile	1716733908	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
0db14a0d-48ff-41e9-9d21-3653a0fd6bc0	"\\"[]\\""	Added PoC 97f520ff-3633-4c04-8bf5-c446c7a93da7 to issue Broken Access Control able to view other Profile	1716733946	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
d6189c82-79a7-4cc3-8bec-abdcaa34ac0d	"\\"[]\\""	Updated issue Broken Access Control able to view other Profile	1716733947	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
7091004d-0d25-4bfd-92c1-8f959b57d48e	"\\"[]\\""	Added PoC a6195f3b-1847-45f6-a70a-25a65145c626 to issue Broken Access Control able to view other Profile	1716734021	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
de442fde-a4fc-4edc-aa3f-227f6a8a1af6	"\\"[]\\""	Updated issue Broken Access Control able to view other Profile	1716734021	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
bd6434d4-ad8a-4554-9cfc-d6bd1a48a8c4	"\\"[]\\""	Updated PoC a6195f3b-1847-45f6-a70a-25a65145c626 of issue b79394a3-33f4-4745-b454-d15d41c01e71	1716734060	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
f9529a1a-9530-4287-b4e8-866516bae131	"\\"[]\\""	Added new file report_2024-05-26T22:34:34.docx	1716734075	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
404b5607-ac6c-41c2-b047-cbb5e310b51b	[]	Added issue template "Excessive data on Response"	1716738090	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	
31f6906f-23e2-441a-88a0-3846d51934fb	"\\"[]\\""	Added issue "Excessive data on Response leads to sensitive data exposure"	1716738105	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
be561bcb-db19-4aae-a5b2-4460f5303e96	"\\"[]\\""	Updated issue Excessive data on Response leads to sensitive data exposure	1716738358	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
ca16b305-73cb-4366-a876-b0c6baf6cbd2	"\\"[]\\""	Added PoC db86cb42-7cd9-4ed1-825e-4d547391b829 to issue Excessive data on Response leads to sensitive data exposure	1716738522	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
51e77713-4aa1-4cf0-9f73-b55afe1155ea	"\\"[]\\""	Updated issue Excessive data on Response leads to sensitive data exposure	1716738522	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
3f3aedb9-9492-4fcf-945d-14863fe94079	"\\"[]\\""	Added PoC 55c48b6f-22be-400e-99d9-513509d0a640 to issue Excessive data on Response leads to sensitive data exposure	1716738667	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
6bd32b06-467c-456b-b581-a9eeef9751a1	"\\"[]\\""	Updated issue Excessive data on Response leads to sensitive data exposure	1716738667	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
88d67245-ba42-40e9-8e84-7246c870a268	"\\"[]\\""	Added PoC 8d25296c-7c9e-4ac6-93f7-8e5275501b21 to issue Excessive data on Response leads to sensitive data exposure	1716738801	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
d43f6865-8dad-459c-9ae0-4c4c7708d3e2	"\\"[]\\""	Updated issue Excessive data on Response leads to sensitive data exposure	1716738801	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
c8c5e12a-b07c-4662-ba65-7e03c3097979	"\\"[]\\""	Updated project settings 	1716743539	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
c448b093-925e-4c89-b2ae-e48a732bf111	[]	Added issue template "Hardcoded Credentials"	1716744618	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	
b3bbee1e-2198-4a3b-9786-71118344dffc	"\\"[]\\""	Added issue "Hardcoded Credentials"	1716744634	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
311445af-f4a6-4bcd-8aee-3c188f5eb7ea	"\\"[]\\""	Updated issue Hardcoded Credentials	1716744666	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
18d23c65-a20a-4549-a066-06eab727e056	"\\"[]\\""	Added PoC ad29db46-a992-4210-88cb-b9a9343d6b41 to issue Hardcoded Credentials	1716744678	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
caf433a1-4fd5-4965-a47e-7cf81672e37e	"\\"[]\\""	Updated issue Hardcoded Credentials	1716744678	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
2575da8f-034b-4ee3-9819-36bf09cd3725	"\\"[]\\""	Updated issue Hardcoded Credentials	1716744821	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
5b85f203-8841-42ac-b5aa-1a27129f48c8	[]	Added issue template "Android Debug mode enabled"	1716745351	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	
fbdf1ce6-4b9d-4137-82f3-7af8d1218805	"\\"[]\\""	Added issue "Android Debug mode enabled"	1716745361	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
8b59ebd1-628c-4e2b-8c5a-5d02a8d4f58f	"\\"[]\\""	Updated issue Android Debug mode enabled	1716745458	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
202774f9-fa40-4704-a304-a65958534009	"\\"[]\\""	Added PoC 1228a514-7f61-463d-9690-4e54e082e104 to issue Android Debug mode enabled	1716745494	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
261c6d37-79b6-4fdb-bb6a-1f3c97deb7fb	"\\"[]\\""	Updated issue Android Debug mode enabled	1716745495	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
9fcb2a3e-5d63-4ade-819e-0692c8648da1	"\\"[]\\""	Added new file report_2024-05-29T14:32:31.docx	1716964352	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
019ce8fe-d66b-4847-ab42-43557cbeb12d	"\\"[]\\""	Added new file report_2024-05-29T14:41:17.txt	1716964877	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
\.


--
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.messages (id, chat_id, message, user_id, "time") FROM stdin;
\.


--
-- Data for Name: networkpaths; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.networkpaths (id, host_out, network_out, host_in, network_in, description, project_id, type, direction) FROM stdin;
\.


--
-- Data for Name: networks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.networks (id, ip, name, mask, comment, project_id, user_id, is_ipv6, asn, access_from, internal_ip, cmd) FROM stdin;
\.


--
-- Data for Name: notes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notes (id, project_id, name, text, host_id, user_id, type) FROM stdin;
94009448-c7fd-42be-b533-354419d47f54	42a774cc-6853-410f-8071-0801b67a9ded	Unauthenticate SQL i	<ol><li data-list="ordered"><span class="ql-ui" contenteditable="false"></span><img src="data:image/png;base64,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"></li></ol>	71716422-0809-462f-94a5-bb2c4f885be0	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	html
\.


--
-- Data for Name: poc; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.poc (id, port_id, description, type, filename, issue_id, user_id, hostname_id, priority, storage, base64) FROM stdin;
ef13b909-c896-4e21-93ad-5e4f80ce3bb9	dc763393-5092-4999-83aa-c54f094529cd	Cannot upload files other than png with other restriction	image	image.png	d7ab474e-9e30-4a49-81a5-a6ec1d8d936c	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0	1	filesystem	
32b8fae0-6682-4533-a98d-22f442e25774	0	Intercept the request with dummy valid picture	image	image.png	d7ab474e-9e30-4a49-81a5-a6ec1d8d936c	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0	0	filesystem	
7eb26e49-545d-49cd-9d65-5c6b31201bcd	0	Encode the offensive payload with base64	image	image.png	d7ab474e-9e30-4a49-81a5-a6ec1d8d936c	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0	0	filesystem	
cb951d39-715b-4e67-a189-ce8cde0727ac	0	Copy the encoded payload	image	image.png	d7ab474e-9e30-4a49-81a5-a6ec1d8d936c	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0	0	filesystem	
4642b997-ee77-4a01-bfd8-2dc72e4d8d8f	0	Payload have been saved to server	image	image.png	d7ab474e-9e30-4a49-81a5-a6ec1d8d936c	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0	0	filesystem	
c86c1aea-00b6-457d-bd79-5b829d169c30	0	Version Disclosure	image	image.png	d2b40a24-3b6d-427a-b63e-5ebdcf183429	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0	1	filesystem	
c03e5c87-69ec-44c1-855b-2805eb4dcd12	0	Htaccess backup disclosre	image	image.png	e6fa72dc-40e6-4f6f-b323-2edcaccc0502	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0	1	filesystem	
70c2264b-b981-41a2-8757-7b819b8c3e7a	0	Found the file structure	image	image.png	2888f910-9591-4c6b-9879-6a6e747cf19b	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0	1	filesystem	
06340ae6-cd3a-40b9-898f-d0728df35629	0	Access the htaccess.txt	image	image.png	2888f910-9591-4c6b-9879-6a6e747cf19b	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0	0	filesystem	
04a0acb7-8c82-4d2f-b2c7-ed51e766548a	0	Able to access administrator folder	image	image.png	641f6dd3-47f1-4ded-8f2c-d46e4efb9a46	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0	1	filesystem	
6cea90cb-5efe-44e3-ad97-0f61f73d12a9	0	Directory Listing	image	image.png	b9819023-7a56-4ab4-b809-896c748f9bfa	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0	1	filesystem	
fb7e8756-b3a4-47ce-9a32-8e5623f7728c	0	Sensitve information	image	image.png	5c2583a9-ecc1-42d3-a644-ac07c5d42ade	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0	1	filesystem	
621db168-6920-4c3d-a864-5d20cedff469	0	Login and go to semakan penyata	image	image.png	6e3b5986-3760-4bda-b451-fd4ac41851b8	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0	1	filesystem	
3217868d-fc4e-4a8d-98df-06cd9f747f16	0	view statement and notice the balance	image	image.png	6e3b5986-3760-4bda-b451-fd4ac41851b8	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0	0	filesystem	
49652a5f-004a-496a-baab-6acab3aa2bd3	0	Intercepted request	image	image.png	6e3b5986-3760-4bda-b451-fd4ac41851b8	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0	0	filesystem	
af867938-cd4b-4acf-9c90-c616c0948e45	0	The details have been change correspond to the IC	image	image.png	6e3b5986-3760-4bda-b451-fd4ac41851b8	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0	0	filesystem	
bf517ed4-7704-43c9-bee8-bef94c6e13ef	0	Brute Force IC	image	image.png	6e3b5986-3760-4bda-b451-fd4ac41851b8	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0	0	filesystem	
07f47bf9-1e6d-412a-9f29-cda21db525ea	0	Login and go to semakan penyata	image	image.png	48ea6b42-52bf-4d05-9c07-3a265dfeb0e3	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0	1	filesystem	
a517df9f-dc60-4411-880e-094b82280678	0	view statement and notice the balance	image	image.png	48ea6b42-52bf-4d05-9c07-3a265dfeb0e3	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0	0	filesystem	
1c6846ba-72ba-44f6-b079-52034bb248a4	0	Brute Force IC	image	image.png	48ea6b42-52bf-4d05-9c07-3a265dfeb0e3	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0	0	filesystem	
260631bc-fdf2-493c-af38-48ecdf165f80	0	Able to view other statement	image	image.png	48ea6b42-52bf-4d05-9c07-3a265dfeb0e3	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0	0	filesystem	
ee88d893-1300-4828-b56c-96d0c8397c6c	0	version disclosure	image	image.png	db85870a-ce69-409b-8c50-429339ffb8a5	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0	1	filesystem	
b8329961-0abe-4d0c-a1d6-abb95edb206c	0	Login as Normal User	image	image.png	4b97a2b8-4326-498d-a8fb-f52dc4b74927	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0	1	filesystem	
31f1dc52-9c41-46d5-8a21-3b761fdc0930	0	Copy the Authorization of normal user	image	image.png	4b97a2b8-4326-498d-a8fb-f52dc4b74927	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0	0	filesystem	
227a8282-c14b-4d29-8dde-7a9562594a91	0	Change to other user ID and able to view the details	image	image.png	4b97a2b8-4326-498d-a8fb-f52dc4b74927	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0	0	filesystem	
15addddd-d833-48c3-853f-16009fb670e9	0	Intercept this page request	image	image.png	b79394a3-33f4-4745-b454-d15d41c01e71	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0	1	filesystem	
97f520ff-3633-4c04-8bf5-c446c7a93da7	0	Intercepted request	image	image.png	b79394a3-33f4-4745-b454-d15d41c01e71	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0	0	filesystem	
a6195f3b-1847-45f6-a70a-25a65145c626	0	Change the IC value	image	image.png	b79394a3-33f4-4745-b454-d15d41c01e71	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0	0	filesystem	
db86cb42-7cd9-4ed1-825e-4d547391b829	0	Enter any valid IC and observe the value	image	image.png	36c92989-4290-4186-a6d9-f205eb6fa3b1	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0	1	filesystem	
55c48b6f-22be-400e-99d9-513509d0a640	0	When on intercepted mode, able to view the details before verifiying user	image	image.png	36c92989-4290-4186-a6d9-f205eb6fa3b1	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0	0	filesystem	
8d25296c-7c9e-4ac6-93f7-8e5275501b21	0	Data exposure before verify the user via email	image	image.png	36c92989-4290-4186-a6d9-f205eb6fa3b1	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0	0	filesystem	
ad29db46-a992-4210-88cb-b9a9343d6b41	0	API key disclosure	image	image.png	24462a62-644a-4daf-bfd1-d4f774e1e5aa	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0	1	filesystem	
1228a514-7f61-463d-9690-4e54e082e104	0	Android debug on	image	image.png	bb71f411-7493-4275-bbc8-fe98b19deaa6	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0	1	filesystem	
\.


--
-- Data for Name: ports; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ports (id, host_id, port, is_tcp, service, description, user_id, project_id) FROM stdin;
ad7cd9c9-2acb-48cf-bc1d-2801655f623c	74ac30f8-5b19-4c81-8fab-2b91acb76c74	0	1	info	Information about whole host	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
3461a68d-0348-40e1-bfea-1520e1260ef3	ac3c0711-cb63-4a31-9175-8e25cf7f0016	0	1	info	Information about whole host	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
2585e4df-822b-4185-9135-89d6778d7602	6eb8f707-f5e0-42b4-83c1-ff86694fe043	0	1	info	Information about whole host	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
4f20a6bd-e0bf-4a82-b32b-f99d3140c706	e9115140-5869-4a39-8bf9-a92fe2172966	0	1	info	Information about whole host	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	926ec7f5-5674-45dc-ae0d-bd996488cb2e
dc763393-5092-4999-83aa-c54f094529cd	71716422-0809-462f-94a5-bb2c4f885be0	0	1	info	Information about whole host	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	42a774cc-6853-410f-8071-0801b67a9ded
5962e521-e09e-4230-a3ed-c97346a05556	491d10b7-0f16-40f4-ac41-3e80df418b3b	0	1	info	Information about whole host	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	5e826717-ce5e-423c-be66-cbca319b2047
5f67db4e-d546-4a12-8597-8c9d4f7fdde4	1008494e-857f-4a8d-989d-455353f21a62	0	1	info	Information about whole host	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
0024d2df-ab61-43bd-9cc8-fe805e5617a7	477e087d-3063-40a2-9c9d-e236e4dec111	0	1	info	Information about whole host	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
39dd6b56-f91b-4cc8-8c96-2de7be2588df	3b4c44f1-0d59-4389-bdbf-f61109395bcd	0	1	info	Information about whole host	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
4ddbfbd8-7594-4dc8-97b6-4dd8f8617d2e	23acc9a8-8003-4fc4-b3bf-e5e25b2026d9	0	1	info	Information about whole host	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	b25edd49-04c1-4a21-b42b-05557dcf29cd
9414cb6c-70b2-407f-bb8c-8d53095a04f3	101cbf1a-c9d0-4b2a-aaa3-be59deb3324d	0	1	info	Information about whole host	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	0dbc2858-bc39-4c8d-8cb5-b5a43eb38d99
6f31ce9b-be64-4458-b9a9-5c278bf352e8	4586d29a-df05-4130-b5e6-0ff0d316b700	0	1	info	Information about whole host	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
944889ce-3165-4363-a55a-b768f8979679	986034dc-d4c9-4a0b-8c7f-b9af2a1945fa	0	1	info	Information about whole host	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
487ba141-6c5e-43c9-b698-987d3d43e776	5612a6bd-5242-47d6-ac60-6198bab246b3	0	1	info	Information about whole host	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	9dd7d458-5124-4358-943d-8d3bd8f4abe6
cc6b635a-0804-4c48-a8fe-cd79e08cd910	67e1544b-761e-4e5a-bd0f-e9c53fa8f8cb	0	1	info	Information about whole host	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	af66f73f-15ab-4c1e-8537-ef381a0a6025
66f64b3b-962a-44e2-a1f1-48f630e48040	ccd40241-de9e-4c94-aab7-d5c504243e77	0	1	info	Information about whole host	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398
\.


--
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.projects (id, name, description, type, scope, start_date, folder, end_date, report_title, auto_archive, status, testers, teams, admin_id) FROM stdin;
926ec7f5-5674-45dc-ae0d-bd996488cb2e	MADA WASA		pentest		1715644800	MADA	1718323200		1	1	["543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c"]	[]	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c
42a774cc-6853-410f-8071-0801b67a9ded	WASA 13/5	Lembaga Hasil Dalam Negeri	pentest		1715644800	LHDN	1715904000		0	1	["543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c"]	[]	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c
5e826717-ce5e-423c-be66-cbca319b2047	EPT 13/5	Lembaga Hasil Dalam Negeri	pentest		1715558400	LHDN	1715817600		0	1	["543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c"]	[]	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c
b25edd49-04c1-4a21-b42b-05557dcf29cd	Test Project Name		pentest		1715817600	Test Project Folder	1718496000	Test Project Name	0	1	["543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c"]	[]	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c
0dbc2858-bc39-4c8d-8cb5-b5a43eb38d99	WASA 2024	Untuk skop eportal	pentest		1716163200	MARDI	1716163200		0	1	["543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c"]	[]	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c
9dd7d458-5124-4358-943d-8d3bd8f4abe6	WASA 2024		pentest		1716249600	PTPTN	1718928000		0	1	["543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c"]	[]	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c
af66f73f-15ab-4c1e-8537-ef381a0a6025	WASA 2024	Negeri Sembilan Pay	pentest		1716422400	N9PAY	1717113600		0	1	["543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c"]	[]	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c
6e3ed207-03f6-4f7a-bcf1-7acc5a8d4398	GPKI MOBILE		pentest		1716163200	MyGPKI	1717113600		0	1	["543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c"]	[]	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c
\.


--
-- Data for Name: reporttemplates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reporttemplates (id, team_id, user_id, name, filename, storage, base64) FROM stdin;
12e11015-5b69-4065-b45e-fffc116e1bfd	0	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	Tracker excel	uat.csv	filesystem	
2951f598-fec2-485a-9206-d91e56bfdf1a	0	543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c	WASA	generateddocxPCF.docx	filesystem	
\.


--
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tasks (id, name, project_id, description, start_date, finish_date, criticality, status, users, teams, services) FROM stdin;
\.


--
-- Data for Name: teams; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teams (id, admin_id, name, description, users, projects, admin_email) FROM stdin;
\.


--
-- Data for Name: tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tokens (id, user_id, name, create_date, duration) FROM stdin;
\.


--
-- Data for Name: tool_sniffer_http_data; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tool_sniffer_http_data (id, sniffer_id, date, ip, request) FROM stdin;
\.


--
-- Data for Name: tool_sniffer_http_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tool_sniffer_http_info (id, project_id, name, status, location, body, save_credentials) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, fname, lname, email, company, password, favorite) FROM stdin;
543d36eb-8bd5-49cc-a3ba-8812c9ef0d7c			daniel@orengacademy.com		$2b$12$YPQQDBf./SFR1iWmshQYzuiFitCFKLwZc0hNqDLVok4SbPW0UASvq	
\.


--
-- Name: chats chats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chats
    ADD CONSTRAINT chats_pkey PRIMARY KEY (id);


--
-- Name: configs configs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.configs
    ADD CONSTRAINT configs_pkey PRIMARY KEY (id);


--
-- Name: credentials credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credentials
    ADD CONSTRAINT credentials_pkey PRIMARY KEY (id);


--
-- Name: files files_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_pkey PRIMARY KEY (id);


--
-- Name: hostnames hostnames_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hostnames
    ADD CONSTRAINT hostnames_pkey PRIMARY KEY (id);


--
-- Name: hosts hosts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hosts
    ADD CONSTRAINT hosts_pkey PRIMARY KEY (id);


--
-- Name: issuerules issuerules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issuerules
    ADD CONSTRAINT issuerules_pkey PRIMARY KEY (id);


--
-- Name: issues issues_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issues
    ADD CONSTRAINT issues_pkey PRIMARY KEY (id);


--
-- Name: issuetemplates issuetemplates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issuetemplates
    ADD CONSTRAINT issuetemplates_pkey PRIMARY KEY (id);


--
-- Name: logs logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: networkpaths networkpaths_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.networkpaths
    ADD CONSTRAINT networkpaths_pkey PRIMARY KEY (id);


--
-- Name: networks networks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.networks
    ADD CONSTRAINT networks_pkey PRIMARY KEY (id);


--
-- Name: notes notes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (id);


--
-- Name: poc poc_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poc
    ADD CONSTRAINT poc_pkey PRIMARY KEY (id);


--
-- Name: ports ports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ports
    ADD CONSTRAINT ports_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: reporttemplates reporttemplates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reporttemplates
    ADD CONSTRAINT reporttemplates_pkey PRIMARY KEY (id);


--
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: tokens tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT tokens_pkey PRIMARY KEY (id);


--
-- Name: tool_sniffer_http_data tool_sniffer_http_data_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_sniffer_http_data
    ADD CONSTRAINT tool_sniffer_http_data_pkey PRIMARY KEY (id);


--
-- Name: tool_sniffer_http_info tool_sniffer_http_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_sniffer_http_info
    ADD CONSTRAINT tool_sniffer_http_info_pkey PRIMARY KEY (id);


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
-- PostgreSQL database dump complete
--

