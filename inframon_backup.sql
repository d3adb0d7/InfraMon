--
-- PostgreSQL database dump
--

\restrict 1bthCmbix2Uu3ylj80vd9St4x0el1vbg9s5PJxp00DHNuDt1Zb29rVCEVzSNrUZ

-- Dumped from database version 15.14 (Debian 15.14-0+deb12u1)
-- Dumped by pg_dump version 15.14 (Debian 15.14-0+deb12u1)

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
-- Name: enum_Alerts_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."enum_Alerts_type" AS ENUM (
    'email',
    'telegram'
);


ALTER TYPE public."enum_Alerts_type" OWNER TO postgres;

--
-- Name: enum_MonitorLogs_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."enum_MonitorLogs_status" AS ENUM (
    'up',
    'down'
);


ALTER TYPE public."enum_MonitorLogs_status" OWNER TO postgres;

--
-- Name: enum_Users_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."enum_Users_role" AS ENUM (
    'admin',
    'user',
    'monitoring_user'
);


ALTER TYPE public."enum_Users_role" OWNER TO postgres;

--
-- Name: enum_Websites_httpMethod; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."enum_Websites_httpMethod" AS ENUM (
    'GET',
    'POST',
    'HEAD',
    'OPTIONS',
    'PING',
    'CURL_GET',
    'CURL_POST',
    'CUSTOM_CURL'
);


ALTER TYPE public."enum_Websites_httpMethod" OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Alerts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Alerts" (
    id integer NOT NULL,
    type public."enum_Alerts_type" NOT NULL,
    "sentAt" timestamp with time zone,
    message text NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "websiteId" integer,
    "userId" integer
);


ALTER TABLE public."Alerts" OWNER TO postgres;

--
-- Name: Alerts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Alerts_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Alerts_id_seq" OWNER TO postgres;

--
-- Name: Alerts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Alerts_id_seq" OWNED BY public."Alerts".id;


--
-- Name: MonitorLogs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."MonitorLogs" (
    id integer NOT NULL,
    status public."enum_MonitorLogs_status" NOT NULL,
    "responseTime" integer,
    "statusCode" integer,
    message text,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "websiteId" integer
);


ALTER TABLE public."MonitorLogs" OWNER TO postgres;

--
-- Name: MonitorLogs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."MonitorLogs_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."MonitorLogs_id_seq" OWNER TO postgres;

--
-- Name: MonitorLogs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."MonitorLogs_id_seq" OWNED BY public."MonitorLogs".id;


--
-- Name: Users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Users" (
    id integer NOT NULL,
    username character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    "firstName" character varying(255),
    "lastName" character varying(255),
    phone character varying(255),
    role public."enum_Users_role" DEFAULT 'user'::public."enum_Users_role",
    "telegramChatId" character varying(255),
    "isActive" boolean DEFAULT true,
    "alertPreferences" jsonb DEFAULT '{"email": true, "telegram": false, "minUptime": 99.5, "notifyOnUp": true, "quietHours": {"end": "06:00", "start": "22:00", "enabled": false}, "notifyOnDown": true, "alertCooldown": 30}'::jsonb NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Users" OWNER TO postgres;

--
-- Name: Users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Users_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Users_id_seq" OWNER TO postgres;

--
-- Name: Users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Users_id_seq" OWNED BY public."Users".id;


--
-- Name: Websites; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Websites" (
    id integer NOT NULL,
    url character varying(255) NOT NULL,
    name character varying(255),
    "interval" integer DEFAULT 5,
    "httpMethod" public."enum_Websites_httpMethod" DEFAULT 'GET'::public."enum_Websites_httpMethod",
    "expectedStatusCodes" integer[] DEFAULT ARRAY[200],
    "isActive" boolean DEFAULT true,
    headers jsonb DEFAULT '[]'::jsonb,
    "customCurlCommand" text,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "userId" integer
);


ALTER TABLE public."Websites" OWNER TO postgres;

--
-- Name: Websites_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Websites_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Websites_id_seq" OWNER TO postgres;

--
-- Name: Websites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Websites_id_seq" OWNED BY public."Websites".id;


--
-- Name: Alerts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Alerts" ALTER COLUMN id SET DEFAULT nextval('public."Alerts_id_seq"'::regclass);


--
-- Name: MonitorLogs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."MonitorLogs" ALTER COLUMN id SET DEFAULT nextval('public."MonitorLogs_id_seq"'::regclass);


--
-- Name: Users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users" ALTER COLUMN id SET DEFAULT nextval('public."Users_id_seq"'::regclass);


--
-- Name: Websites id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Websites" ALTER COLUMN id SET DEFAULT nextval('public."Websites_id_seq"'::regclass);


--
-- Data for Name: Alerts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Alerts" (id, type, "sentAt", message, "createdAt", "updatedAt", "websiteId", "userId") FROM stdin;
1	telegram	2025-10-01 23:26:34.848+00	Test alert from UptimeGuard\nTime: 10/2/2025, 5:26:33 AM\nThis is a test notification to verify your alert settings.	2025-10-01 23:26:34.848+00	2025-10-01 23:26:34.848+00	\N	1
2	telegram	2025-10-01 23:26:40.078+00	Test alert from UptimeGuard\nTime: 10/2/2025, 5:26:39 AM\nThis is a test notification to verify your alert settings.	2025-10-01 23:26:40.078+00	2025-10-01 23:26:40.078+00	\N	1
3	email	2025-10-01 23:29:20.993+00	Test alert from UptimeGuard\nTime: 10/2/2025, 5:29:15 AM\nThis is a test notification to verify your alert settings.	2025-10-01 23:29:20.993+00	2025-10-01 23:29:20.993+00	\N	1
4	email	2025-10-01 23:29:54.858+00	Test alert from UptimeGuard\nTime: 10/2/2025, 5:29:50 AM\nThis is a test notification to verify your alert settings.	2025-10-01 23:29:54.858+00	2025-10-01 23:29:54.858+00	\N	1
5	telegram	2025-10-01 23:30:42.968+00	Test alert from UptimeGuard\nTime: 10/2/2025, 5:30:42 AM\nThis is a test notification to verify your alert settings.	2025-10-01 23:30:42.968+00	2025-10-01 23:30:42.968+00	\N	1
8	email	2025-10-03 10:06:42.847+00	\n🚨 CRITICAL: Website Down Alert\n================================\n\nWebsite: GOOGLE\nURL: https://google.com\nStatus: DOWN ❌\nResponse Time: 5292ms\nStatus Code: N/A\nMonitoring Method: GET\nError: HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com\n\n📊 Technical Details:\n- URL: https://google.com\n- Method: GET\n- Status Code: N/A\n- Response Time: 5292ms\n- Timestamp: 10/3/2025, 4:06:42 PM\n\n🔧 Recommended Actions:\n• Check server status and logs\n• Verify network connectivity  \n• Review recent deployments\n• Check SSL certificate validity\n\nThis is an automated alert from InfraMon.\nMonitor ID: 1\n      	2025-10-03 10:06:42.85+00	2025-10-03 10:06:42.85+00	1	1
9	telegram	2025-10-03 10:06:42.85+00	\n🚨 *CRITICAL ALERT: Website Down* 🚨\n\n*Website:* GOOGLE\n*URL:* https://google\\.com\n*Status:* DOWN ❌\n*Response Time:* 5292ms\n*Status Code:* N/A\n*Method:* GET\n\n📊 *Technical Details:*\n• URL: https://google\\.com\n• Monitoring Method: GET\n• Status Code: N/A\n• Response Time: 5292ms\n• Timestamp: 10/3/2025, 4:06:42 PM\n\n⚠️ *Error:* HTTP failed and PING fallback also failed: getaddrinfo EAI\\_AGAIN google\\.com\n\n🔧 *Recommended Actions:*\n• Check server status\n• Verify network connectivity\n• Review recent changes\n• Check SSL certificates\n\n_This is an automated alert from InfraMon_\n_Monitor ID: 1_\n    	2025-10-03 10:06:42.85+00	2025-10-03 10:06:42.85+00	1	1
10	email	2025-10-03 10:42:37.718+00	\n🚨 CRITICAL: Website Down Alert\n================================\n\nWebsite: GOOGLE\nURL: https://google.com\nStatus: DOWN ❌\nResponse Time: 41ms\nStatus Code: N/A\nMonitoring Method: GET\nError: HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com\n\n📊 Technical Details:\n- URL: https://google.com\n- Method: GET\n- Status Code: N/A\n- Response Time: 41ms\n- Timestamp: 10/3/2025, 4:42:37 PM\n\n🔧 Recommended Actions:\n• Check server status and logs\n• Verify network connectivity  \n• Review recent deployments\n• Check SSL certificate validity\n\nThis is an automated alert from InfraMon.\nMonitor ID: 1\n      	2025-10-03 10:42:37.719+00	2025-10-03 10:42:37.719+00	1	1
11	telegram	2025-10-03 10:42:37.719+00	\n🚨 *CRITICAL ALERT: Website Down* 🚨\n\n*Website:* GOOGLE\n*URL:* https://google\\.com\n*Status:* DOWN ❌\n*Response Time:* 41ms\n*Status Code:* N/A\n*Method:* GET\n\n📊 *Technical Details:*\n• URL: https://google\\.com\n• Monitoring Method: GET\n• Status Code: N/A\n• Response Time: 41ms\n• Timestamp: 10/3/2025, 4:42:37 PM\n\n⚠️ *Error:* HTTP failed and PING fallback also failed: getaddrinfo EAI\\_AGAIN google\\.com\n\n🔧 *Recommended Actions:*\n• Check server status\n• Verify network connectivity\n• Review recent changes\n• Check SSL certificates\n\n_This is an automated alert from InfraMon_\n_Monitor ID: 1_\n    	2025-10-03 10:42:37.719+00	2025-10-03 10:42:37.719+00	1	1
12	email	2025-10-03 10:42:55.686+00	\n✅ RECOVERY: Website Back Online\n================================\n\nWebsite: GOOGLE\nURL: https://google.com\nStatus: ONLINE ✅\nResponse Time: 2099ms\nMonitoring Method: GET\n\n🎉 Recovery Confirmed!\nYour website has successfully recovered and is now responding normally.\n\n📊 Current Status:\n- URL: https://google.com\n- Method: GET \n- Response Time: 2099ms\n- Status: ONLINE ✅\n- Check Interval: Every 1 minutes\n- Recovery Time: 10/3/2025, 4:42:55 PM\n\nThe monitoring system will continue to track your website's status.\n\nThis is an automated recovery alert from InfraMon.\nMonitor ID: 1\n      	2025-10-03 10:42:55.686+00	2025-10-03 10:42:55.686+00	1	1
13	telegram	2025-10-03 10:42:55.686+00	\n✅ *RECOVERY ALERT: Website Back Online* ✅\n\n*Website:* GOOGLE\n*URL:* https://google\\.com  \n*Status:* ONLINE ✅\n*Response Time:* 2099ms\n*Method:* GET\n\n🎉 *Recovery Confirmed!*\nYour website has successfully recovered and is now responding normally.\n\n📊 *Current Status:*\n• URL: https://google\\.com\n• Monitoring Method: GET\n• Response Time: 2099ms\n• Status: ONLINE ✅\n• Check Interval: Every 1 minutes\n• Recovery Time: 10/3/2025, 4:42:55 PM\n\nThe monitoring system will continue to track your website's status.\n\n_This is an automated recovery alert from InfraMon_\n_Monitor ID: 1_\n    	2025-10-03 10:42:55.686+00	2025-10-03 10:42:55.686+00	1	1
14	email	2025-10-03 10:42:55.729+00	\n✅ RECOVERY: Website Back Online\n================================\n\nWebsite: GOOGLE\nURL: https://google.com\nStatus: ONLINE ✅\nResponse Time: 1740ms\nMonitoring Method: GET\n\n🎉 Recovery Confirmed!\nYour website has successfully recovered and is now responding normally.\n\n📊 Current Status:\n- URL: https://google.com\n- Method: GET \n- Response Time: 1740ms\n- Status: ONLINE ✅\n- Check Interval: Every 1 minutes\n- Recovery Time: 10/3/2025, 4:42:55 PM\n\nThe monitoring system will continue to track your website's status.\n\nThis is an automated recovery alert from InfraMon.\nMonitor ID: 1\n      	2025-10-03 10:42:55.729+00	2025-10-03 10:42:55.729+00	1	1
15	telegram	2025-10-03 10:42:55.729+00	\n✅ *RECOVERY ALERT: Website Back Online* ✅\n\n*Website:* GOOGLE\n*URL:* https://google\\.com  \n*Status:* ONLINE ✅\n*Response Time:* 1740ms\n*Method:* GET\n\n🎉 *Recovery Confirmed!*\nYour website has successfully recovered and is now responding normally.\n\n📊 *Current Status:*\n• URL: https://google\\.com\n• Monitoring Method: GET\n• Response Time: 1740ms\n• Status: ONLINE ✅\n• Check Interval: Every 1 minutes\n• Recovery Time: 10/3/2025, 4:42:55 PM\n\nThe monitoring system will continue to track your website's status.\n\n_This is an automated recovery alert from InfraMon_\n_Monitor ID: 1_\n    	2025-10-03 10:42:55.729+00	2025-10-03 10:42:55.729+00	1	1
16	email	2025-10-03 10:46:54.951+00	\n✅ RECOVERY: Website Back Online\n================================\n\nWebsite: GOOGLE\nURL: https://google.com\nStatus: ONLINE ✅\nResponse Time: 995ms\nMonitoring Method: GET\n\n🎉 Recovery Confirmed!\nYour website has successfully recovered and is now responding normally.\n\n📊 Current Status:\n- URL: https://google.com\n- Method: GET \n- Response Time: 995ms\n- Status: ONLINE ✅\n- Check Interval: Every 1 minutes\n- Recovery Time: 10/3/2025, 4:46:54 PM\n\nThe monitoring system will continue to track your website's status.\n\nThis is an automated recovery alert from InfraMon.\nMonitor ID: 1\n      	2025-10-03 10:46:54.951+00	2025-10-03 10:46:54.951+00	1	1
17	telegram	2025-10-03 10:46:54.951+00	\n✅ *RECOVERY ALERT: Website Back Online* ✅\n\n*Website:* GOOGLE\n*URL:* https://google\\.com  \n*Status:* ONLINE ✅\n*Response Time:* 995ms\n*Method:* GET\n\n🎉 *Recovery Confirmed!*\nYour website has successfully recovered and is now responding normally.\n\n📊 *Current Status:*\n• URL: https://google\\.com\n• Monitoring Method: GET\n• Response Time: 995ms\n• Status: ONLINE ✅\n• Check Interval: Every 1 minutes\n• Recovery Time: 10/3/2025, 4:46:54 PM\n\nThe monitoring system will continue to track your website's status.\n\n_This is an automated recovery alert from InfraMon_\n_Monitor ID: 1_\n    	2025-10-03 10:46:54.952+00	2025-10-03 10:46:54.952+00	1	1
18	email	2025-10-03 11:39:57.006+00	\n🚨 CRITICAL: Website Down Alert\n================================\n\nWebsite: GOOGLE\nURL: https://google.com\nStatus: DOWN ❌\nResponse Time: 4737ms\nStatus Code: N/A\nMonitoring Method: GET\nError: HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN www.google.com\n\n📊 Technical Details:\n- URL: https://google.com\n- Method: GET\n- Status Code: N/A\n- Response Time: 4737ms\n- Timestamp: 10/3/2025, 5:39:57 PM\n\n🔧 Recommended Actions:\n• Check server status and logs\n• Verify network connectivity  \n• Review recent deployments\n• Check SSL certificate validity\n\nThis is an automated alert from InfraMon.\nMonitor ID: 1\n      	2025-10-03 11:39:57.006+00	2025-10-03 11:39:57.006+00	1	1
19	telegram	2025-10-03 11:39:57.006+00	\n🚨 *CRITICAL ALERT: Website Down* 🚨\n\n*Website:* GOOGLE\n*URL:* https://google\\.com\n*Status:* DOWN ❌\n*Response Time:* 4737ms\n*Status Code:* N/A\n*Method:* GET\n\n📊 *Technical Details:*\n• URL: https://google\\.com\n• Monitoring Method: GET\n• Status Code: N/A\n• Response Time: 4737ms\n• Timestamp: 10/3/2025, 5:39:57 PM\n\n⚠️ *Error:* HTTP failed and PING fallback also failed: getaddrinfo EAI\\_AGAIN www\\.google\\.com\n\n🔧 *Recommended Actions:*\n• Check server status\n• Verify network connectivity\n• Review recent changes\n• Check SSL certificates\n\n_This is an automated alert from InfraMon_\n_Monitor ID: 1_\n    	2025-10-03 11:39:57.006+00	2025-10-03 11:39:57.006+00	1	1
20	email	2025-10-03 11:40:53.368+00	\n✅ RECOVERY: Website Back Online\n================================\n\nWebsite: GOOGLE\nURL: https://google.com\nStatus: ONLINE ✅\nResponse Time: 1068ms\nMonitoring Method: GET\n\n🎉 Recovery Confirmed!\nYour website has successfully recovered and is now responding normally.\n\n📊 Current Status:\n- URL: https://google.com\n- Method: GET \n- Response Time: 1068ms\n- Status: ONLINE ✅\n- Check Interval: Every 1 minutes\n- Recovery Time: 10/3/2025, 5:40:53 PM\n\nThe monitoring system will continue to track your website's status.\n\nThis is an automated recovery alert from InfraMon.\nMonitor ID: 1\n      	2025-10-03 11:40:53.368+00	2025-10-03 11:40:53.368+00	1	1
21	telegram	2025-10-03 11:40:53.368+00	\n✅ *RECOVERY ALERT: Website Back Online* ✅\n\n*Website:* GOOGLE\n*URL:* https://google\\.com  \n*Status:* ONLINE ✅\n*Response Time:* 1068ms\n*Method:* GET\n\n🎉 *Recovery Confirmed!*\nYour website has successfully recovered and is now responding normally.\n\n📊 *Current Status:*\n• URL: https://google\\.com\n• Monitoring Method: GET\n• Response Time: 1068ms\n• Status: ONLINE ✅\n• Check Interval: Every 1 minutes\n• Recovery Time: 10/3/2025, 5:40:53 PM\n\nThe monitoring system will continue to track your website's status.\n\n_This is an automated recovery alert from InfraMon_\n_Monitor ID: 1_\n    	2025-10-03 11:40:53.368+00	2025-10-03 11:40:53.368+00	1	1
22	email	2025-10-04 02:27:25.129+00	\n🚨 CRITICAL: Website Down Alert\n================================\n\nWebsite: GOOGLE\nURL: https://google.com\nStatus: DOWN ❌\nResponse Time: 10011ms\nStatus Code: N/A\nMonitoring Method: GET\nError: HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com\n\n📊 Technical Details:\n- URL: https://google.com\n- Method: GET\n- Status Code: N/A\n- Response Time: 10011ms\n- Timestamp: 10/4/2025, 8:27:25 AM\n\n🔧 Recommended Actions:\n• Check server status and logs\n• Verify network connectivity  \n• Review recent deployments\n• Check SSL certificate validity\n\nThis is an automated alert from InfraMon.\nMonitor ID: 1\n      	2025-10-04 02:27:25.138+00	2025-10-04 02:27:25.138+00	1	1
23	telegram	2025-10-04 02:27:25.138+00	\n🚨 *CRITICAL ALERT: Website Down* 🚨\n\n*Website:* GOOGLE\n*URL:* https://google\\.com\n*Status:* DOWN ❌\n*Response Time:* 10011ms\n*Status Code:* N/A\n*Method:* GET\n\n📊 *Technical Details:*\n• URL: https://google\\.com\n• Monitoring Method: GET\n• Status Code: N/A\n• Response Time: 10011ms\n• Timestamp: 10/4/2025, 8:27:25 AM\n\n⚠️ *Error:* HTTP failed and PING fallback also failed: getaddrinfo EAI\\_AGAIN google\\.com\n\n🔧 *Recommended Actions:*\n• Check server status\n• Verify network connectivity\n• Review recent changes\n• Check SSL certificates\n\n_This is an automated alert from InfraMon_\n_Monitor ID: 1_\n    	2025-10-04 02:27:25.138+00	2025-10-04 02:27:25.138+00	1	1
24	email	2025-10-04 02:42:26.162+00	\n🚨 CRITICAL: Website Down Alert\n================================\n\nWebsite: GOOGLE\nURL: https://google.com\nStatus: DOWN ❌\nResponse Time: 11037ms\nStatus Code: N/A\nMonitoring Method: GET\nError: HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com\n\n📊 Technical Details:\n- URL: https://google.com\n- Method: GET\n- Status Code: N/A\n- Response Time: 11037ms\n- Timestamp: 10/4/2025, 8:42:26 AM\n\n🔧 Recommended Actions:\n• Check server status and logs\n• Verify network connectivity  \n• Review recent deployments\n• Check SSL certificate validity\n\nThis is an automated alert from InfraMon.\nMonitor ID: 1\n      	2025-10-04 02:42:26.162+00	2025-10-04 02:42:26.162+00	1	1
25	telegram	2025-10-04 02:42:26.162+00	\n🚨 *CRITICAL ALERT: Website Down* 🚨\n\n*Website:* GOOGLE\n*URL:* https://google\\.com\n*Status:* DOWN ❌\n*Response Time:* 11037ms\n*Status Code:* N/A\n*Method:* GET\n\n📊 *Technical Details:*\n• URL: https://google\\.com\n• Monitoring Method: GET\n• Status Code: N/A\n• Response Time: 11037ms\n• Timestamp: 10/4/2025, 8:42:26 AM\n\n⚠️ *Error:* HTTP failed and PING fallback also failed: getaddrinfo EAI\\_AGAIN google\\.com\n\n🔧 *Recommended Actions:*\n• Check server status\n• Verify network connectivity\n• Review recent changes\n• Check SSL certificates\n\n_This is an automated alert from InfraMon_\n_Monitor ID: 1_\n    	2025-10-04 02:42:26.162+00	2025-10-04 02:42:26.162+00	1	1
26	email	2025-10-04 02:58:27.079+00	\n🚨 CRITICAL: Website Down Alert\n================================\n\nWebsite: GOOGLE\nURL: https://google.com\nStatus: DOWN ❌\nResponse Time: 11929ms\nStatus Code: N/A\nMonitoring Method: GET\nError: HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com\n\n📊 Technical Details:\n- URL: https://google.com\n- Method: GET\n- Status Code: N/A\n- Response Time: 11929ms\n- Timestamp: 10/4/2025, 8:58:27 AM\n\n🔧 Recommended Actions:\n• Check server status and logs\n• Verify network connectivity  \n• Review recent deployments\n• Check SSL certificate validity\n\nThis is an automated alert from InfraMon.\nMonitor ID: 1\n      	2025-10-04 02:58:27.079+00	2025-10-04 02:58:27.079+00	1	1
27	telegram	2025-10-04 02:58:27.079+00	\n🚨 *CRITICAL ALERT: Website Down* 🚨\n\n*Website:* GOOGLE\n*URL:* https://google\\.com\n*Status:* DOWN ❌\n*Response Time:* 11929ms\n*Status Code:* N/A\n*Method:* GET\n\n📊 *Technical Details:*\n• URL: https://google\\.com\n• Monitoring Method: GET\n• Status Code: N/A\n• Response Time: 11929ms\n• Timestamp: 10/4/2025, 8:58:27 AM\n\n⚠️ *Error:* HTTP failed and PING fallback also failed: getaddrinfo EAI\\_AGAIN google\\.com\n\n🔧 *Recommended Actions:*\n• Check server status\n• Verify network connectivity\n• Review recent changes\n• Check SSL certificates\n\n_This is an automated alert from InfraMon_\n_Monitor ID: 1_\n    	2025-10-04 02:58:27.079+00	2025-10-04 02:58:27.079+00	1	1
28	email	2025-10-04 03:13:27.387+00	\n🚨 CRITICAL: Website Down Alert\n================================\n\nWebsite: GOOGLE\nURL: https://google.com\nStatus: DOWN ❌\nResponse Time: 12218ms\nStatus Code: N/A\nMonitoring Method: GET\nError: HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com\n\n📊 Technical Details:\n- URL: https://google.com\n- Method: GET\n- Status Code: N/A\n- Response Time: 12218ms\n- Timestamp: 10/4/2025, 9:13:27 AM\n\n🔧 Recommended Actions:\n• Check server status and logs\n• Verify network connectivity  \n• Review recent deployments\n• Check SSL certificate validity\n\nThis is an automated alert from InfraMon.\nMonitor ID: 1\n      	2025-10-04 03:13:27.387+00	2025-10-04 03:13:27.387+00	1	1
29	telegram	2025-10-04 03:13:27.387+00	\n🚨 *CRITICAL ALERT: Website Down* 🚨\n\n*Website:* GOOGLE\n*URL:* https://google\\.com\n*Status:* DOWN ❌\n*Response Time:* 12218ms\n*Status Code:* N/A\n*Method:* GET\n\n📊 *Technical Details:*\n• URL: https://google\\.com\n• Monitoring Method: GET\n• Status Code: N/A\n• Response Time: 12218ms\n• Timestamp: 10/4/2025, 9:13:27 AM\n\n⚠️ *Error:* HTTP failed and PING fallback also failed: getaddrinfo EAI\\_AGAIN google\\.com\n\n🔧 *Recommended Actions:*\n• Check server status\n• Verify network connectivity\n• Review recent changes\n• Check SSL certificates\n\n_This is an automated alert from InfraMon_\n_Monitor ID: 1_\n    	2025-10-04 03:13:27.387+00	2025-10-04 03:13:27.387+00	1	1
30	email	2025-10-04 03:29:16.248+00	\n✅ RECOVERY: Website Back Online\n================================\n\nWebsite: GOOGLE\nURL: https://google.com\nStatus: ONLINE ✅\nResponse Time: 1061ms\nMonitoring Method: GET\n\n🎉 Recovery Confirmed!\nYour website has successfully recovered and is now responding normally.\n\n📊 Current Status:\n- URL: https://google.com\n- Method: GET \n- Response Time: 1061ms\n- Status: ONLINE ✅\n- Check Interval: Every 1 minutes\n- Recovery Time: 10/4/2025, 9:29:16 AM\n\nThe monitoring system will continue to track your website's status.\n\nThis is an automated recovery alert from InfraMon.\nMonitor ID: 1\n      	2025-10-04 03:29:16.248+00	2025-10-04 03:29:16.248+00	1	1
31	telegram	2025-10-04 03:29:16.248+00	\n✅ *RECOVERY ALERT: Website Back Online* ✅\n\n*Website:* GOOGLE\n*URL:* https://google\\.com  \n*Status:* ONLINE ✅\n*Response Time:* 1061ms\n*Method:* GET\n\n🎉 *Recovery Confirmed!*\nYour website has successfully recovered and is now responding normally.\n\n📊 *Current Status:*\n• URL: https://google\\.com\n• Monitoring Method: GET\n• Response Time: 1061ms\n• Status: ONLINE ✅\n• Check Interval: Every 1 minutes\n• Recovery Time: 10/4/2025, 9:29:16 AM\n\nThe monitoring system will continue to track your website's status.\n\n_This is an automated recovery alert from InfraMon_\n_Monitor ID: 1_\n    	2025-10-04 03:29:16.248+00	2025-10-04 03:29:16.248+00	1	1
32	email	2025-10-04 04:38:19.867+00	\n🚨 CRITICAL: Website Down Alert\n================================\n\nWebsite: GOOGLE\nURL: https://google.com\nStatus: DOWN ❌\nResponse Time: 1317ms\nStatus Code: N/A\nMonitoring Method: GET\nError: HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com\n\n📊 Technical Details:\n- URL: https://google.com\n- Method: GET\n- Status Code: N/A\n- Response Time: 1317ms\n- Timestamp: 10/4/2025, 10:38:19 AM\n\n🔧 Recommended Actions:\n• Check server status and logs\n• Verify network connectivity  \n• Review recent deployments\n• Check SSL certificate validity\n\nThis is an automated alert from InfraMon.\nMonitor ID: 1\n      	2025-10-04 04:38:19.868+00	2025-10-04 04:38:19.868+00	1	1
33	telegram	2025-10-04 04:38:19.869+00	\n🚨 *CRITICAL ALERT: Website Down* 🚨\n\n*Website:* GOOGLE\n*URL:* https://google\\.com\n*Status:* DOWN ❌\n*Response Time:* 1317ms\n*Status Code:* N/A\n*Method:* GET\n\n📊 *Technical Details:*\n• URL: https://google\\.com\n• Monitoring Method: GET\n• Status Code: N/A\n• Response Time: 1317ms\n• Timestamp: 10/4/2025, 10:38:19 AM\n\n⚠️ *Error:* HTTP failed and PING fallback also failed: getaddrinfo EAI\\_AGAIN google\\.com\n\n🔧 *Recommended Actions:*\n• Check server status\n• Verify network connectivity\n• Review recent changes\n• Check SSL certificates\n\n_This is an automated alert from InfraMon_\n_Monitor ID: 1_\n    	2025-10-04 04:38:19.87+00	2025-10-04 04:38:19.87+00	1	1
34	email	2025-10-04 05:02:21.217+00	\n✅ RECOVERY: Website Back Online\n================================\n\nWebsite: GOOGLE\nURL: https://google.com\nStatus: ONLINE ✅\nResponse Time: 1485ms\nMonitoring Method: GET\n\n🎉 Recovery Confirmed!\nYour website has successfully recovered and is now responding normally.\n\n📊 Current Status:\n- URL: https://google.com\n- Method: GET \n- Response Time: 1485ms\n- Status: ONLINE ✅\n- Check Interval: Every 1 minutes\n- Recovery Time: 10/4/2025, 11:02:21 AM\n\nThe monitoring system will continue to track your website's status.\n\nThis is an automated recovery alert from InfraMon.\nMonitor ID: 1\n      	2025-10-04 05:02:21.217+00	2025-10-04 05:02:21.217+00	1	1
35	telegram	2025-10-04 05:02:21.217+00	\n✅ *RECOVERY ALERT: Website Back Online* ✅\n\n*Website:* GOOGLE\n*URL:* https://google\\.com  \n*Status:* ONLINE ✅\n*Response Time:* 1485ms\n*Method:* GET\n\n🎉 *Recovery Confirmed!*\nYour website has successfully recovered and is now responding normally.\n\n📊 *Current Status:*\n• URL: https://google\\.com\n• Monitoring Method: GET\n• Response Time: 1485ms\n• Status: ONLINE ✅\n• Check Interval: Every 1 minutes\n• Recovery Time: 10/4/2025, 11:02:21 AM\n\nThe monitoring system will continue to track your website's status.\n\n_This is an automated recovery alert from InfraMon_\n_Monitor ID: 1_\n    	2025-10-04 05:02:21.218+00	2025-10-04 05:02:21.218+00	1	1
36	email	2025-10-05 07:26:40.484+00	\n🚨 CRITICAL: Website Down Alert\n================================\n\nWebsite: GOOGLE\nURL: https://google.com\nStatus: DOWN ❌\nResponse Time: 20391ms\nStatus Code: N/A\nMonitoring Method: GET\nError: HTTP failed and PING fallback also failed: Request timeout\n\n📊 Technical Details:\n- URL: https://google.com\n- Method: GET\n- Status Code: N/A\n- Response Time: 20391ms\n- Timestamp: 10/5/2025, 1:26:40 PM\n\n🔧 Recommended Actions:\n• Check server status and logs\n• Verify network connectivity  \n• Review recent deployments\n• Check SSL certificate validity\n\nThis is an automated alert from InfraMon.\nMonitor ID: 1\n      	2025-10-05 07:26:40.49+00	2025-10-05 07:26:40.49+00	1	1
37	telegram	2025-10-05 07:26:40.49+00	\n🚨 *CRITICAL ALERT: Website Down* 🚨\n\n*Website:* GOOGLE\n*URL:* https://google\\.com\n*Status:* DOWN ❌\n*Response Time:* 20391ms\n*Status Code:* N/A\n*Method:* GET\n\n📊 *Technical Details:*\n• URL: https://google\\.com\n• Monitoring Method: GET\n• Status Code: N/A\n• Response Time: 20391ms\n• Timestamp: 10/5/2025, 1:26:40 PM\n\n⚠️ *Error:* HTTP failed and PING fallback also failed: Request timeout\n\n🔧 *Recommended Actions:*\n• Check server status\n• Verify network connectivity\n• Review recent changes\n• Check SSL certificates\n\n_This is an automated alert from InfraMon_\n_Monitor ID: 1_\n    	2025-10-05 07:26:40.49+00	2025-10-05 07:26:40.49+00	1	1
38	telegram	2025-10-05 07:28:43.889+00	\n✅ *RECOVERY ALERT: Website Back Online* ✅\n\n*Website:* GOOGLE\n*URL:* https://google\\.com  \n*Status:* ONLINE ✅\n*Response Time:* 10395ms\n*Method:* GET\n\n🎉 *Recovery Confirmed!*\nYour website has successfully recovered and is now responding normally.\n\n📊 *Current Status:*\n• URL: https://google\\.com\n• Monitoring Method: GET\n• Response Time: 10395ms\n• Status: ONLINE ✅\n• Check Interval: Every 1 minutes\n• Recovery Time: 10/5/2025, 1:28:43 PM\n\nThe monitoring system will continue to track your website's status.\n\n_This is an automated recovery alert from InfraMon_\n_Monitor ID: 1_\n    	2025-10-05 07:28:43.889+00	2025-10-05 07:28:43.889+00	1	1
39	email	2025-10-05 07:28:43.888+00	\n✅ RECOVERY: Website Back Online\n================================\n\nWebsite: GOOGLE\nURL: https://google.com\nStatus: ONLINE ✅\nResponse Time: 10395ms\nMonitoring Method: GET\n\n🎉 Recovery Confirmed!\nYour website has successfully recovered and is now responding normally.\n\n📊 Current Status:\n- URL: https://google.com\n- Method: GET \n- Response Time: 10395ms\n- Status: ONLINE ✅\n- Check Interval: Every 1 minutes\n- Recovery Time: 10/5/2025, 1:28:43 PM\n\nThe monitoring system will continue to track your website's status.\n\nThis is an automated recovery alert from InfraMon.\nMonitor ID: 1\n      	2025-10-05 07:28:43.889+00	2025-10-05 07:28:43.889+00	1	1
40	email	2025-10-05 07:32:59.621+00	\n🚨 CRITICAL: Website Down Alert\n================================\n\nWebsite: http://prportal.nidw.gov.bd/partner-portal/home\nURL: http://prportal.nidw.gov.bd/partner-portal/home\nStatus: DOWN ❌\nResponse Time: 10121ms\nStatus Code: N/A\nMonitoring Method: CURL GET\nError: CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "http://prportal.nidw.gov.bd/partner-portal/home"\n\n\n📊 Technical Details:\n- URL: http://prportal.nidw.gov.bd/partner-portal/home\n- Method: CURL GET\n- Status Code: N/A\n- Response Time: 10121ms\n- Timestamp: 10/5/2025, 1:32:59 PM\n\n🔧 Recommended Actions:\n• Check server status and logs\n• Verify network connectivity  \n• Review recent deployments\n• Check SSL certificate validity\n\nThis is an automated alert from InfraMon.\nMonitor ID: 3\n      	2025-10-05 07:32:59.621+00	2025-10-05 07:32:59.621+00	3	1
41	telegram	2025-10-05 07:32:59.621+00	\n🚨 *CRITICAL ALERT: Website Down* 🚨\n\n*Website:* http://prportal\\.nidw\\.gov\\.bd/partner\\-portal/home\n*URL:* http://prportal\\.nidw\\.gov\\.bd/partner\\-portal/home\n*Status:* DOWN ❌\n*Response Time:* 10121ms\n*Status Code:* N/A\n*Method:* CURL GET\n\n📊 *Technical Details:*\n• URL: http://prportal\\.nidw\\.gov\\.bd/partner\\-portal/home\n• Monitoring Method: CURL GET\n• Status Code: N/A\n• Response Time: 10121ms\n• Timestamp: 10/5/2025, 1:32:59 PM\n\n⚠️ *Error:* CURL GET failed: Command failed: curl \\-s \\-o /dev/null \\-w "%\\{http\\_code\\}" \\-X GET \\-\\-max\\-time 10 "http://prportal\\.nidw\\.gov\\.bd/partner\\-portal/home"\n\n\n🔧 *Recommended Actions:*\n• Check server status\n• Verify network connectivity\n• Review recent changes\n• Check SSL certificates\n\n_This is an automated alert from InfraMon_\n_Monitor ID: 3_\n    	2025-10-05 07:32:59.621+00	2025-10-05 07:32:59.621+00	3	1
42	email	2025-10-05 07:33:21.686+00	\n✅ RECOVERY: Website Back Online\n================================\n\nWebsite: GOOGLE\nURL: https://google.com\nStatus: ONLINE ✅\nResponse Time: 1272ms\nMonitoring Method: GET\n\n🎉 Recovery Confirmed!\nYour website has successfully recovered and is now responding normally.\n\n📊 Current Status:\n- URL: https://google.com\n- Method: GET \n- Response Time: 1272ms\n- Status: ONLINE ✅\n- Check Interval: Every 1 minutes\n- Recovery Time: 10/5/2025, 1:33:21 PM\n\nThe monitoring system will continue to track your website's status.\n\nThis is an automated recovery alert from InfraMon.\nMonitor ID: 1\n      	2025-10-05 07:33:21.686+00	2025-10-05 07:33:21.686+00	1	1
43	telegram	2025-10-05 07:33:21.686+00	\n✅ *RECOVERY ALERT: Website Back Online* ✅\n\n*Website:* GOOGLE\n*URL:* https://google\\.com  \n*Status:* ONLINE ✅\n*Response Time:* 1272ms\n*Method:* GET\n\n🎉 *Recovery Confirmed!*\nYour website has successfully recovered and is now responding normally.\n\n📊 *Current Status:*\n• URL: https://google\\.com\n• Monitoring Method: GET\n• Response Time: 1272ms\n• Status: ONLINE ✅\n• Check Interval: Every 1 minutes\n• Recovery Time: 10/5/2025, 1:33:21 PM\n\nThe monitoring system will continue to track your website's status.\n\n_This is an automated recovery alert from InfraMon_\n_Monitor ID: 1_\n    	2025-10-05 07:33:21.686+00	2025-10-05 07:33:21.686+00	1	1
44	email	2025-10-05 07:48:11.87+00	\n✅ RECOVERY: Website Back Online\n================================\n\nWebsite: NID SERVER\nURL: https://prportal.nidw.gov.bd/partner-portal/home\nStatus: ONLINE ✅\nResponse Time: 316ms\nMonitoring Method: CURL GET\n\n🎉 Recovery Confirmed!\nYour website has successfully recovered and is now responding normally.\n\n📊 Current Status:\n- URL: https://prportal.nidw.gov.bd/partner-portal/home\n- Method: CURL GET \n- Response Time: 316ms\n- Status: ONLINE ✅\n- Check Interval: Every 1 minutes\n- Recovery Time: 10/5/2025, 1:48:11 PM\n\nThe monitoring system will continue to track your website's status.\n\nThis is an automated recovery alert from InfraMon.\nMonitor ID: 3\n      	2025-10-05 07:48:11.87+00	2025-10-05 07:48:11.87+00	3	1
45	telegram	2025-10-05 07:48:11.871+00	\n✅ *RECOVERY ALERT: Website Back Online* ✅\n\n*Website:* NID SERVER\n*URL:* https://prportal\\.nidw\\.gov\\.bd/partner\\-portal/home  \n*Status:* ONLINE ✅\n*Response Time:* 316ms\n*Method:* CURL GET\n\n🎉 *Recovery Confirmed!*\nYour website has successfully recovered and is now responding normally.\n\n📊 *Current Status:*\n• URL: https://prportal\\.nidw\\.gov\\.bd/partner\\-portal/home\n• Monitoring Method: CURL GET\n• Response Time: 316ms\n• Status: ONLINE ✅\n• Check Interval: Every 1 minutes\n• Recovery Time: 10/5/2025, 1:48:11 PM\n\nThe monitoring system will continue to track your website's status.\n\n_This is an automated recovery alert from InfraMon_\n_Monitor ID: 3_\n    	2025-10-05 07:48:11.871+00	2025-10-05 07:48:11.871+00	3	1
46	telegram	2025-10-05 07:48:14.523+00	\n✅ *RECOVERY ALERT: Website Back Online* ✅\n\n*Website:* NID SERVER\n*URL:* https://prportal\\.nidw\\.gov\\.bd/partner\\-portal/home  \n*Status:* ONLINE ✅\n*Response Time:* 258ms\n*Method:* CURL GET\n\n🎉 *Recovery Confirmed!*\nYour website has successfully recovered and is now responding normally.\n\n📊 *Current Status:*\n• URL: https://prportal\\.nidw\\.gov\\.bd/partner\\-portal/home\n• Monitoring Method: CURL GET\n• Response Time: 258ms\n• Status: ONLINE ✅\n• Check Interval: Every 1 minutes\n• Recovery Time: 10/5/2025, 1:48:14 PM\n\nThe monitoring system will continue to track your website's status.\n\n_This is an automated recovery alert from InfraMon_\n_Monitor ID: 3_\n    	2025-10-05 07:48:14.523+00	2025-10-05 07:48:14.523+00	3	1
47	email	2025-10-05 07:48:14.522+00	\n✅ RECOVERY: Website Back Online\n================================\n\nWebsite: NID SERVER\nURL: https://prportal.nidw.gov.bd/partner-portal/home\nStatus: ONLINE ✅\nResponse Time: 258ms\nMonitoring Method: CURL GET\n\n🎉 Recovery Confirmed!\nYour website has successfully recovered and is now responding normally.\n\n📊 Current Status:\n- URL: https://prportal.nidw.gov.bd/partner-portal/home\n- Method: CURL GET \n- Response Time: 258ms\n- Status: ONLINE ✅\n- Check Interval: Every 1 minutes\n- Recovery Time: 10/5/2025, 1:48:14 PM\n\nThe monitoring system will continue to track your website's status.\n\nThis is an automated recovery alert from InfraMon.\nMonitor ID: 3\n      	2025-10-05 07:48:14.523+00	2025-10-05 07:48:14.523+00	3	1
48	email	2025-10-05 07:57:54.584+00	\n🚨 CRITICAL: Website Down Alert\n================================\n\nWebsite: CC Portal\nURL: https://cc.mynagad.com:20030/\nStatus: DOWN ❌\nResponse Time: 265ms\nStatus Code: N/A\nMonitoring Method: CURL GET\nError: CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n\n\n📊 Technical Details:\n- URL: https://cc.mynagad.com:20030/\n- Method: CURL GET\n- Status Code: N/A\n- Response Time: 265ms\n- Timestamp: 10/5/2025, 1:57:54 PM\n\n🔧 Recommended Actions:\n• Check server status and logs\n• Verify network connectivity  \n• Review recent deployments\n• Check SSL certificate validity\n\nThis is an automated alert from InfraMon.\nMonitor ID: 7\n      	2025-10-05 07:57:54.584+00	2025-10-05 07:57:54.584+00	7	1
49	telegram	2025-10-05 07:57:54.584+00	\n🚨 *CRITICAL ALERT: Website Down* 🚨\n\n*Website:* CC Portal\n*URL:* https://cc\\.mynagad\\.com:20030/\n*Status:* DOWN ❌\n*Response Time:* 265ms\n*Status Code:* N/A\n*Method:* CURL GET\n\n📊 *Technical Details:*\n• URL: https://cc\\.mynagad\\.com:20030/\n• Monitoring Method: CURL GET\n• Status Code: N/A\n• Response Time: 265ms\n• Timestamp: 10/5/2025, 1:57:54 PM\n\n⚠️ *Error:* CURL GET failed: Command failed: curl \\-s \\-o /dev/null \\-w "%\\{http\\_code\\}" \\-X GET \\-\\-max\\-time 10 "https://cc\\.mynagad\\.com:20030/"\n\n\n🔧 *Recommended Actions:*\n• Check server status\n• Verify network connectivity\n• Review recent changes\n• Check SSL certificates\n\n_This is an automated alert from InfraMon_\n_Monitor ID: 7_\n    	2025-10-05 07:57:54.585+00	2025-10-05 07:57:54.585+00	7	1
50	email	2025-10-05 07:58:12.445+00	\n🚨 CRITICAL: Website Down Alert\n================================\n\nWebsite: SYS Portal\nURL: https://sys.mynagad.com:20020/\nStatus: DOWN ❌\nResponse Time: 10138ms\nStatus Code: N/A\nMonitoring Method: CURL GET\nError: CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n\n\n📊 Technical Details:\n- URL: https://sys.mynagad.com:20020/\n- Method: CURL GET\n- Status Code: N/A\n- Response Time: 10138ms\n- Timestamp: 10/5/2025, 1:58:12 PM\n\n🔧 Recommended Actions:\n• Check server status and logs\n• Verify network connectivity  \n• Review recent deployments\n• Check SSL certificate validity\n\nThis is an automated alert from InfraMon.\nMonitor ID: 6\n      	2025-10-05 07:58:12.446+00	2025-10-05 07:58:12.446+00	6	1
51	telegram	2025-10-05 07:58:12.446+00	\n🚨 *CRITICAL ALERT: Website Down* 🚨\n\n*Website:* SYS Portal\n*URL:* https://sys\\.mynagad\\.com:20020/\n*Status:* DOWN ❌\n*Response Time:* 10138ms\n*Status Code:* N/A\n*Method:* CURL GET\n\n📊 *Technical Details:*\n• URL: https://sys\\.mynagad\\.com:20020/\n• Monitoring Method: CURL GET\n• Status Code: N/A\n• Response Time: 10138ms\n• Timestamp: 10/5/2025, 1:58:12 PM\n\n⚠️ *Error:* CURL GET failed: Command failed: curl \\-s \\-o /dev/null \\-w "%\\{http\\_code\\}" \\-X GET \\-\\-max\\-time 10 "https://sys\\.mynagad\\.com:20020/"\n\n\n🔧 *Recommended Actions:*\n• Check server status\n• Verify network connectivity\n• Review recent changes\n• Check SSL certificates\n\n_This is an automated alert from InfraMon_\n_Monitor ID: 6_\n    	2025-10-05 07:58:12.446+00	2025-10-05 07:58:12.446+00	6	1
52	email	2025-10-05 07:59:53.016+00	\n✅ RECOVERY: Website Back Online\n================================\n\nWebsite: CC Portal\nURL: https://cc.mynagad.com:20030/\nStatus: ONLINE ✅\nResponse Time: 301ms\nMonitoring Method: CURL GET\n\n🎉 Recovery Confirmed!\nYour website has successfully recovered and is now responding normally.\n\n📊 Current Status:\n- URL: https://cc.mynagad.com:20030/\n- Method: CURL GET \n- Response Time: 301ms\n- Status: ONLINE ✅\n- Check Interval: Every 1 minutes\n- Recovery Time: 10/5/2025, 1:59:53 PM\n\nThe monitoring system will continue to track your website's status.\n\nThis is an automated recovery alert from InfraMon.\nMonitor ID: 7\n      	2025-10-05 07:59:53.016+00	2025-10-05 07:59:53.016+00	7	1
53	telegram	2025-10-05 07:59:53.016+00	\n✅ *RECOVERY ALERT: Website Back Online* ✅\n\n*Website:* CC Portal\n*URL:* https://cc\\.mynagad\\.com:20030/  \n*Status:* ONLINE ✅\n*Response Time:* 301ms\n*Method:* CURL GET\n\n🎉 *Recovery Confirmed!*\nYour website has successfully recovered and is now responding normally.\n\n📊 *Current Status:*\n• URL: https://cc\\.mynagad\\.com:20030/\n• Monitoring Method: CURL GET\n• Response Time: 301ms\n• Status: ONLINE ✅\n• Check Interval: Every 1 minutes\n• Recovery Time: 10/5/2025, 1:59:53 PM\n\nThe monitoring system will continue to track your website's status.\n\n_This is an automated recovery alert from InfraMon_\n_Monitor ID: 7_\n    	2025-10-05 07:59:53.016+00	2025-10-05 07:59:53.016+00	7	1
54	email	2025-10-05 08:00:02.479+00	\n✅ RECOVERY: Website Back Online\n================================\n\nWebsite: SYS Portal\nURL: https://sys.mynagad.com:20020/\nStatus: ONLINE ✅\nResponse Time: 208ms\nMonitoring Method: CURL GET\n\n🎉 Recovery Confirmed!\nYour website has successfully recovered and is now responding normally.\n\n📊 Current Status:\n- URL: https://sys.mynagad.com:20020/\n- Method: CURL GET \n- Response Time: 208ms\n- Status: ONLINE ✅\n- Check Interval: Every 1 minutes\n- Recovery Time: 10/5/2025, 2:00:02 PM\n\nThe monitoring system will continue to track your website's status.\n\nThis is an automated recovery alert from InfraMon.\nMonitor ID: 6\n      	2025-10-05 08:00:02.479+00	2025-10-05 08:00:02.479+00	6	1
55	telegram	2025-10-05 08:00:02.479+00	\n✅ *RECOVERY ALERT: Website Back Online* ✅\n\n*Website:* SYS Portal\n*URL:* https://sys\\.mynagad\\.com:20020/  \n*Status:* ONLINE ✅\n*Response Time:* 208ms\n*Method:* CURL GET\n\n🎉 *Recovery Confirmed!*\nYour website has successfully recovered and is now responding normally.\n\n📊 *Current Status:*\n• URL: https://sys\\.mynagad\\.com:20020/\n• Monitoring Method: CURL GET\n• Response Time: 208ms\n• Status: ONLINE ✅\n• Check Interval: Every 1 minutes\n• Recovery Time: 10/5/2025, 2:00:02 PM\n\nThe monitoring system will continue to track your website's status.\n\n_This is an automated recovery alert from InfraMon_\n_Monitor ID: 6_\n    	2025-10-05 08:00:02.479+00	2025-10-05 08:00:02.479+00	6	1
56	email	2025-10-05 08:00:11.855+00	\n✅ RECOVERY: Website Back Online\n================================\n\nWebsite: NID SERVER\nURL: https://prportal.nidw.gov.bd/partner-portal/home\nStatus: ONLINE ✅\nResponse Time: 239ms\nMonitoring Method: CURL GET\n\n🎉 Recovery Confirmed!\nYour website has successfully recovered and is now responding normally.\n\n📊 Current Status:\n- URL: https://prportal.nidw.gov.bd/partner-portal/home\n- Method: CURL GET \n- Response Time: 239ms\n- Status: ONLINE ✅\n- Check Interval: Every 1 minutes\n- Recovery Time: 10/5/2025, 2:00:11 PM\n\nThe monitoring system will continue to track your website's status.\n\nThis is an automated recovery alert from InfraMon.\nMonitor ID: 3\n      	2025-10-05 08:00:11.855+00	2025-10-05 08:00:11.855+00	3	1
57	telegram	2025-10-05 08:00:11.855+00	\n✅ *RECOVERY ALERT: Website Back Online* ✅\n\n*Website:* NID SERVER\n*URL:* https://prportal\\.nidw\\.gov\\.bd/partner\\-portal/home  \n*Status:* ONLINE ✅\n*Response Time:* 239ms\n*Method:* CURL GET\n\n🎉 *Recovery Confirmed!*\nYour website has successfully recovered and is now responding normally.\n\n📊 *Current Status:*\n• URL: https://prportal\\.nidw\\.gov\\.bd/partner\\-portal/home\n• Monitoring Method: CURL GET\n• Response Time: 239ms\n• Status: ONLINE ✅\n• Check Interval: Every 1 minutes\n• Recovery Time: 10/5/2025, 2:00:11 PM\n\nThe monitoring system will continue to track your website's status.\n\n_This is an automated recovery alert from InfraMon_\n_Monitor ID: 3_\n    	2025-10-05 08:00:11.855+00	2025-10-05 08:00:11.855+00	3	1
58	email	2025-10-05 08:04:59.517+00	\n🚨 CRITICAL: Website Down Alert\n================================\n\nWebsite: ERP \nURL: \nStatus: DOWN ❌\nResponse Time: 12190ms\nStatus Code: N/A\nMonitoring Method: CUSTOM CURL\nError: Custom CURL failed: Command failed: curl 'https://nagaderp.mynagad.com:7070/Security/User/SignInWithMenus' -H 'Accept: application/json, text/plain, */*' -H 'Accept-Language: en-US,en;q=0.9' -H 'Authorization: Bearer null' -H 'Connection: keep-alive' -H 'Content-Type: application/json;charset=UTF-8' -H 'Origin: https://nagaderp.mynagad.com:9090' -H 'Referer: https://nagaderp.mynagad.com:9090/' -H 'Sec-Fetch-Dest: empty' -H 'Sec-Fetch-Mode: cors' -H 'Sec-Fetch-Site: same-site' -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36' -H 'X-Requested-With: XMLHttpRequest' -H 'sec-ch-ua: "Chromium";v="140", "Not=A?Brand";v="24", "Google Chrome";v="140"' -H 'sec-ch-ua-mobile: ?0' -H 'sec-ch-ua-platform: "Windows"' --data-raw '{"UserName":"2410	2025-10-05 08:04:59.518+00	2025-10-05 08:04:59.518+00	4	1
59	telegram	2025-10-05 08:04:59.518+00	\n🚨 *CRITICAL ALERT: Website Down* 🚨\n\n*Website:* ERP \n*URL:* \n*Status:* DOWN ❌\n*Response Time:* 12190ms\n*Status Code:* N/A\n*Method:* CUSTOM CURL\n\n📊 *Technical Details:*\n• URL: \n• Monitoring Method: CUSTOM CURL\n• Status Code: N/A\n• Response Time: 12190ms\n• Timestamp: 10/5/2025, 2:04:59 PM\n\n⚠️ *Error:* Custom CURL failed: Command failed: curl 'https://nagaderp\\.mynagad\\.com:7070/Security/User/SignInWithMenus' \\-H 'Accept: application/json, text/plain, \\*/\\*' \\-H 'Accept\\-Language: en\\-US,en;q\\=0\\.9' \\-H 'Authorization: Bearer null' \\-H 'Connection: keep\\-alive' \\-H 'Content\\-Type: application/json;charset\\=UTF\\-8' \\-H 'Origin: https://nagaderp\\.mynagad\\.com:9090' \\-H 'Referer: https://nagaderp\\.mynagad\\.com:9090/' \\-H 'Sec\\-Fetch\\-Dest: empty' \\-H 'Sec\\-Fetch\\-Mode: cors' \\-H 'Sec\\-Fetch\\-Site: same\\-site' \\-H 'User\\-Agent: Mozilla/5\\.0 \\(Windows NT 10\\.0; Win64; x64\\) AppleWebKit/537\\.36 \\(KHTML, like Gecko\\) Chrome/140\\.0\\.0\\.0 Safari/537\\.36' \\-H 'X\\-Requested\\-With: XMLHttpRequest'	2025-10-05 08:04:59.518+00	2025-10-05 08:04:59.518+00	4	1
60	email	2025-10-05 08:05:21.973+00	\n🚨 CRITICAL: Website Down Alert\n================================\n\nWebsite: DMS Portal\nURL: https://channel.mynagad.com:20010/\nStatus: DOWN ❌\nResponse Time: 10173ms\nStatus Code: N/A\nMonitoring Method: CURL GET\nError: CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://channel.mynagad.com:20010/"\n\n\n📊 Technical Details:\n- URL: https://channel.mynagad.com:20010/\n- Method: CURL GET\n- Status Code: N/A\n- Response Time: 10173ms\n- Timestamp: 10/5/2025, 2:05:21 PM\n\n🔧 Recommended Actions:\n• Check server status and logs\n• Verify network connectivity  \n• Review recent deployments\n• Check SSL certificate validity\n\nThis is an automated alert from InfraMon.\nMonitor ID: 5\n      	2025-10-05 08:05:21.976+00	2025-10-05 08:05:21.976+00	5	1
61	telegram	2025-10-05 08:05:21.976+00	\n🚨 *CRITICAL ALERT: Website Down* 🚨\n\n*Website:* DMS Portal\n*URL:* https://channel\\.mynagad\\.com:20010/\n*Status:* DOWN ❌\n*Response Time:* 10173ms\n*Status Code:* N/A\n*Method:* CURL GET\n\n📊 *Technical Details:*\n• URL: https://channel\\.mynagad\\.com:20010/\n• Monitoring Method: CURL GET\n• Status Code: N/A\n• Response Time: 10173ms\n• Timestamp: 10/5/2025, 2:05:21 PM\n\n⚠️ *Error:* CURL GET failed: Command failed: curl \\-s \\-o /dev/null \\-w "%\\{http\\_code\\}" \\-X GET \\-\\-max\\-time 10 "https://channel\\.mynagad\\.com:20010/"\n\n\n🔧 *Recommended Actions:*\n• Check server status\n• Verify network connectivity\n• Review recent changes\n• Check SSL certificates\n\n_This is an automated alert from InfraMon_\n_Monitor ID: 5_\n    	2025-10-05 08:05:21.976+00	2025-10-05 08:05:21.976+00	5	1
62	email	2025-10-05 08:05:41.923+00	\n🚨 CRITICAL: Website Down Alert\n================================\n\nWebsite: GOOGLE\nURL: https://google.com\nStatus: DOWN ❌\nResponse Time: 21272ms\nStatus Code: N/A\nMonitoring Method: GET\nError: HTTP failed and PING fallback also failed: Request timeout\n\n📊 Technical Details:\n- URL: https://google.com\n- Method: GET\n- Status Code: N/A\n- Response Time: 21272ms\n- Timestamp: 10/5/2025, 2:05:41 PM\n\n🔧 Recommended Actions:\n• Check server status and logs\n• Verify network connectivity  \n• Review recent deployments\n• Check SSL certificate validity\n\nThis is an automated alert from InfraMon.\nMonitor ID: 1\n      	2025-10-05 08:05:41.923+00	2025-10-05 08:05:41.923+00	1	1
63	telegram	2025-10-05 08:05:41.923+00	\n🚨 *CRITICAL ALERT: Website Down* 🚨\n\n*Website:* GOOGLE\n*URL:* https://google\\.com\n*Status:* DOWN ❌\n*Response Time:* 21272ms\n*Status Code:* N/A\n*Method:* GET\n\n📊 *Technical Details:*\n• URL: https://google\\.com\n• Monitoring Method: GET\n• Status Code: N/A\n• Response Time: 21272ms\n• Timestamp: 10/5/2025, 2:05:41 PM\n\n⚠️ *Error:* HTTP failed and PING fallback also failed: Request timeout\n\n🔧 *Recommended Actions:*\n• Check server status\n• Verify network connectivity\n• Review recent changes\n• Check SSL certificates\n\n_This is an automated alert from InfraMon_\n_Monitor ID: 1_\n    	2025-10-05 08:05:41.923+00	2025-10-05 08:05:41.923+00	1	1
64	email	2025-10-05 08:06:21.509+00	\n✅ RECOVERY: Website Back Online\n================================\n\nWebsite: GOOGLE\nURL: https://google.com\nStatus: ONLINE ✅\nResponse Time: 919ms\nMonitoring Method: GET\n\n🎉 Recovery Confirmed!\nYour website has successfully recovered and is now responding normally.\n\n📊 Current Status:\n- URL: https://google.com\n- Method: GET \n- Response Time: 919ms\n- Status: ONLINE ✅\n- Check Interval: Every 1 minutes\n- Recovery Time: 10/5/2025, 2:06:21 PM\n\nThe monitoring system will continue to track your website's status.\n\nThis is an automated recovery alert from InfraMon.\nMonitor ID: 1\n      	2025-10-05 08:06:21.509+00	2025-10-05 08:06:21.509+00	1	1
65	telegram	2025-10-05 08:06:21.509+00	\n✅ *RECOVERY ALERT: Website Back Online* ✅\n\n*Website:* GOOGLE\n*URL:* https://google\\.com  \n*Status:* ONLINE ✅\n*Response Time:* 919ms\n*Method:* GET\n\n🎉 *Recovery Confirmed!*\nYour website has successfully recovered and is now responding normally.\n\n📊 *Current Status:*\n• URL: https://google\\.com\n• Monitoring Method: GET\n• Response Time: 919ms\n• Status: ONLINE ✅\n• Check Interval: Every 1 minutes\n• Recovery Time: 10/5/2025, 2:06:21 PM\n\nThe monitoring system will continue to track your website's status.\n\n_This is an automated recovery alert from InfraMon_\n_Monitor ID: 1_\n    	2025-10-05 08:06:21.509+00	2025-10-05 08:06:21.509+00	1	1
66	email	2025-10-05 08:06:47.209+00	\n✅ RECOVERY: Website Back Online\n================================\n\nWebsite: ERP \nURL: \nStatus: ONLINE ✅\nResponse Time: 237ms\nMonitoring Method: CUSTOM CURL\n\n🎉 Recovery Confirmed!\nYour website has successfully recovered and is now responding normally.\n\n📊 Current Status:\n- URL: \n- Method: CUSTOM CURL \n- Response Time: 237ms\n- Status: ONLINE ✅\n- Check Interval: Every 1 minutes\n- Recovery Time: 10/5/2025, 2:06:47 PM\n\nThe monitoring system will continue to track your website's status.\n\nThis is an automated recovery alert from InfraMon.\nMonitor ID: 4\n      	2025-10-05 08:06:47.209+00	2025-10-05 08:06:47.209+00	4	1
67	telegram	2025-10-05 08:06:47.209+00	\n✅ *RECOVERY ALERT: Website Back Online* ✅\n\n*Website:* ERP \n*URL:*   \n*Status:* ONLINE ✅\n*Response Time:* 237ms\n*Method:* CUSTOM CURL\n\n🎉 *Recovery Confirmed!*\nYour website has successfully recovered and is now responding normally.\n\n📊 *Current Status:*\n• URL: \n• Monitoring Method: CUSTOM CURL\n• Response Time: 237ms\n• Status: ONLINE ✅\n• Check Interval: Every 1 minutes\n• Recovery Time: 10/5/2025, 2:06:47 PM\n\nThe monitoring system will continue to track your website's status.\n\n_This is an automated recovery alert from InfraMon_\n_Monitor ID: 4_\n    	2025-10-05 08:06:47.209+00	2025-10-05 08:06:47.209+00	4	1
68	email	2025-10-05 08:06:52.988+00	\n✅ RECOVERY: Website Back Online\n================================\n\nWebsite: CC Portal\nURL: https://cc.mynagad.com:20030/\nStatus: ONLINE ✅\nResponse Time: 272ms\nMonitoring Method: CURL GET\n\n🎉 Recovery Confirmed!\nYour website has successfully recovered and is now responding normally.\n\n📊 Current Status:\n- URL: https://cc.mynagad.com:20030/\n- Method: CURL GET \n- Response Time: 272ms\n- Status: ONLINE ✅\n- Check Interval: Every 1 minutes\n- Recovery Time: 10/5/2025, 2:06:52 PM\n\nThe monitoring system will continue to track your website's status.\n\nThis is an automated recovery alert from InfraMon.\nMonitor ID: 7\n      	2025-10-05 08:06:52.988+00	2025-10-05 08:06:52.988+00	7	1
69	telegram	2025-10-05 08:06:52.988+00	\n✅ *RECOVERY ALERT: Website Back Online* ✅\n\n*Website:* CC Portal\n*URL:* https://cc\\.mynagad\\.com:20030/  \n*Status:* ONLINE ✅\n*Response Time:* 272ms\n*Method:* CURL GET\n\n🎉 *Recovery Confirmed!*\nYour website has successfully recovered and is now responding normally.\n\n📊 *Current Status:*\n• URL: https://cc\\.mynagad\\.com:20030/\n• Monitoring Method: CURL GET\n• Response Time: 272ms\n• Status: ONLINE ✅\n• Check Interval: Every 1 minutes\n• Recovery Time: 10/5/2025, 2:06:52 PM\n\nThe monitoring system will continue to track your website's status.\n\n_This is an automated recovery alert from InfraMon_\n_Monitor ID: 7_\n    	2025-10-05 08:06:52.988+00	2025-10-05 08:06:52.988+00	7	1
72	email	2025-10-05 08:07:02.896+00	\n✅ RECOVERY: Website Back Online\n================================\n\nWebsite: SYS Portal\nURL: https://sys.mynagad.com:20020/\nStatus: ONLINE ✅\nResponse Time: 491ms\nMonitoring Method: CURL GET\n\n🎉 Recovery Confirmed!\nYour website has successfully recovered and is now responding normally.\n\n📊 Current Status:\n- URL: https://sys.mynagad.com:20020/\n- Method: CURL GET \n- Response Time: 491ms\n- Status: ONLINE ✅\n- Check Interval: Every 1 minutes\n- Recovery Time: 10/5/2025, 2:07:02 PM\n\nThe monitoring system will continue to track your website's status.\n\nThis is an automated recovery alert from InfraMon.\nMonitor ID: 6\n      	2025-10-05 08:07:02.897+00	2025-10-05 08:07:02.897+00	6	1
73	telegram	2025-10-05 08:07:02.897+00	\n✅ *RECOVERY ALERT: Website Back Online* ✅\n\n*Website:* SYS Portal\n*URL:* https://sys\\.mynagad\\.com:20020/  \n*Status:* ONLINE ✅\n*Response Time:* 491ms\n*Method:* CURL GET\n\n🎉 *Recovery Confirmed!*\nYour website has successfully recovered and is now responding normally.\n\n📊 *Current Status:*\n• URL: https://sys\\.mynagad\\.com:20020/\n• Monitoring Method: CURL GET\n• Response Time: 491ms\n• Status: ONLINE ✅\n• Check Interval: Every 1 minutes\n• Recovery Time: 10/5/2025, 2:07:02 PM\n\nThe monitoring system will continue to track your website's status.\n\n_This is an automated recovery alert from InfraMon_\n_Monitor ID: 6_\n    	2025-10-05 08:07:02.897+00	2025-10-05 08:07:02.897+00	6	1
74	email	2025-10-05 08:07:12.318+00	\n✅ RECOVERY: Website Back Online\n================================\n\nWebsite: NID SERVER\nURL: https://prportal.nidw.gov.bd/partner-portal/home\nStatus: ONLINE ✅\nResponse Time: 692ms\nMonitoring Method: CURL GET\n\n🎉 Recovery Confirmed!\nYour website has successfully recovered and is now responding normally.\n\n📊 Current Status:\n- URL: https://prportal.nidw.gov.bd/partner-portal/home\n- Method: CURL GET \n- Response Time: 692ms\n- Status: ONLINE ✅\n- Check Interval: Every 1 minutes\n- Recovery Time: 10/5/2025, 2:07:12 PM\n\nThe monitoring system will continue to track your website's status.\n\nThis is an automated recovery alert from InfraMon.\nMonitor ID: 3\n      	2025-10-05 08:07:12.318+00	2025-10-05 08:07:12.318+00	3	1
75	telegram	2025-10-05 08:07:12.318+00	\n✅ *RECOVERY ALERT: Website Back Online* ✅\n\n*Website:* NID SERVER\n*URL:* https://prportal\\.nidw\\.gov\\.bd/partner\\-portal/home  \n*Status:* ONLINE ✅\n*Response Time:* 692ms\n*Method:* CURL GET\n\n🎉 *Recovery Confirmed!*\nYour website has successfully recovered and is now responding normally.\n\n📊 *Current Status:*\n• URL: https://prportal\\.nidw\\.gov\\.bd/partner\\-portal/home\n• Monitoring Method: CURL GET\n• Response Time: 692ms\n• Status: ONLINE ✅\n• Check Interval: Every 1 minutes\n• Recovery Time: 10/5/2025, 2:07:12 PM\n\nThe monitoring system will continue to track your website's status.\n\n_This is an automated recovery alert from InfraMon_\n_Monitor ID: 3_\n    	2025-10-05 08:07:12.318+00	2025-10-05 08:07:12.318+00	3	1
76	email	2025-10-05 08:07:12.434+00	\n✅ RECOVERY: Website Back Online\n================================\n\nWebsite: DMS Portal\nURL: https://channel.mynagad.com:20010/\nStatus: ONLINE ✅\nResponse Time: 642ms\nMonitoring Method: CURL GET\n\n🎉 Recovery Confirmed!\nYour website has successfully recovered and is now responding normally.\n\n📊 Current Status:\n- URL: https://channel.mynagad.com:20010/\n- Method: CURL GET \n- Response Time: 642ms\n- Status: ONLINE ✅\n- Check Interval: Every 1 minutes\n- Recovery Time: 10/5/2025, 2:07:12 PM\n\nThe monitoring system will continue to track your website's status.\n\nThis is an automated recovery alert from InfraMon.\nMonitor ID: 5\n      	2025-10-05 08:07:12.434+00	2025-10-05 08:07:12.434+00	5	1
77	telegram	2025-10-05 08:07:12.434+00	\n✅ *RECOVERY ALERT: Website Back Online* ✅\n\n*Website:* DMS Portal\n*URL:* https://channel\\.mynagad\\.com:20010/  \n*Status:* ONLINE ✅\n*Response Time:* 642ms\n*Method:* CURL GET\n\n🎉 *Recovery Confirmed!*\nYour website has successfully recovered and is now responding normally.\n\n📊 *Current Status:*\n• URL: https://channel\\.mynagad\\.com:20010/\n• Monitoring Method: CURL GET\n• Response Time: 642ms\n• Status: ONLINE ✅\n• Check Interval: Every 1 minutes\n• Recovery Time: 10/5/2025, 2:07:12 PM\n\nThe monitoring system will continue to track your website's status.\n\n_This is an automated recovery alert from InfraMon_\n_Monitor ID: 5_\n    	2025-10-05 08:07:12.434+00	2025-10-05 08:07:12.434+00	5	1
78	email	2025-10-05 11:06:24.814+00	\n🚨 CRITICAL: Website Down Alert\n================================\n\nWebsite: ERP \nURL: \nStatus: DOWN ❌\nResponse Time: 33572ms\nStatus Code: 500\nMonitoring Method: CUSTOM CURL\nError: Unexpected status code: 500\n\n📊 Technical Details:\n- URL: \n- Method: CUSTOM CURL\n- Status Code: 500\n- Response Time: 33572ms\n- Timestamp: 10/5/2025, 5:06:24 PM\n\n🔧 Recommended Actions:\n• Check server status and logs\n• Verify network connectivity  \n• Review recent deployments\n• Check SSL certificate validity\n\nThis is an automated alert from InfraMon.\nMonitor ID: 4\n      	2025-10-05 11:06:24.826+00	2025-10-05 11:06:24.826+00	4	1
79	telegram	2025-10-05 11:06:24.827+00	\n🚨 *CRITICAL ALERT: Website Down* 🚨\n\n*Website:* ERP \n*URL:* \n*Status:* DOWN ❌\n*Response Time:* 33572ms\n*Status Code:* 500\n*Method:* CUSTOM CURL\n\n📊 *Technical Details:*\n• URL: \n• Monitoring Method: CUSTOM CURL\n• Status Code: 500\n• Response Time: 33572ms\n• Timestamp: 10/5/2025, 5:06:24 PM\n\n⚠️ *Error:* Unexpected status code: 500\n\n🔧 *Recommended Actions:*\n• Check server status\n• Verify network connectivity\n• Review recent changes\n• Check SSL certificates\n\n_This is an automated alert from InfraMon_\n_Monitor ID: 4_\n    	2025-10-05 11:06:24.827+00	2025-10-05 11:06:24.827+00	4	1
80	email	2025-10-05 11:16:51.217+00	\n✅ RECOVERY: Website Back Online\n================================\n\nWebsite: ERP \nURL: \nStatus: ONLINE ✅\nResponse Time: 428ms\nMonitoring Method: CUSTOM CURL\n\n🎉 Recovery Confirmed!\nYour website has successfully recovered and is now responding normally.\n\n📊 Current Status:\n- URL: \n- Method: CUSTOM CURL \n- Response Time: 428ms\n- Status: ONLINE ✅\n- Check Interval: Every 1 minutes\n- Recovery Time: 10/5/2025, 5:16:51 PM\n\nThe monitoring system will continue to track your website's status.\n\nThis is an automated recovery alert from InfraMon.\nMonitor ID: 4\n      	2025-10-05 11:16:51.217+00	2025-10-05 11:16:51.217+00	4	1
81	telegram	2025-10-05 11:16:51.218+00	\n✅ *RECOVERY ALERT: Website Back Online* ✅\n\n*Website:* ERP \n*URL:*   \n*Status:* ONLINE ✅\n*Response Time:* 428ms\n*Method:* CUSTOM CURL\n\n🎉 *Recovery Confirmed!*\nYour website has successfully recovered and is now responding normally.\n\n📊 *Current Status:*\n• URL: \n• Monitoring Method: CUSTOM CURL\n• Response Time: 428ms\n• Status: ONLINE ✅\n• Check Interval: Every 1 minutes\n• Recovery Time: 10/5/2025, 5:16:51 PM\n\nThe monitoring system will continue to track your website's status.\n\n_This is an automated recovery alert from InfraMon_\n_Monitor ID: 4_\n    	2025-10-05 11:16:51.218+00	2025-10-05 11:16:51.218+00	4	1
82	email	2025-10-06 04:37:13.666+00	\n🚨 CRITICAL: Website Down Alert\n================================\n\nWebsite: CC Portal\nURL: https://cc.mynagad.com:20030/\nStatus: DOWN ❌\nResponse Time: 10026ms\nStatus Code: N/A\nMonitoring Method: CURL GET\nError: CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n\n\n📊 Technical Details:\n- URL: https://cc.mynagad.com:20030/\n- Method: CURL GET\n- Status Code: N/A\n- Response Time: 10026ms\n- Timestamp: 10/6/2025, 10:37:13 AM\n\n🔧 Recommended Actions:\n• Check server status and logs\n• Verify network connectivity  \n• Review recent deployments\n• Check SSL certificate validity\n\nThis is an automated alert from InfraMon.\nMonitor ID: 7\n      	2025-10-06 04:37:13.668+00	2025-10-06 04:37:13.668+00	7	1
83	telegram	2025-10-06 04:37:13.669+00	\n🚨 *CRITICAL ALERT: Website Down* 🚨\n\n*Website:* CC Portal\n*URL:* https://cc\\.mynagad\\.com:20030/\n*Status:* DOWN ❌\n*Response Time:* 10026ms\n*Status Code:* N/A\n*Method:* CURL GET\n\n📊 *Technical Details:*\n• URL: https://cc\\.mynagad\\.com:20030/\n• Monitoring Method: CURL GET\n• Status Code: N/A\n• Response Time: 10026ms\n• Timestamp: 10/6/2025, 10:37:13 AM\n\n⚠️ *Error:* CURL GET failed: Command failed: curl \\-s \\-o /dev/null \\-w "%\\{http\\_code\\}" \\-X GET \\-\\-max\\-time 10 "https://cc\\.mynagad\\.com:20030/"\n\n\n🔧 *Recommended Actions:*\n• Check server status\n• Verify network connectivity\n• Review recent changes\n• Check SSL certificates\n\n_This is an automated alert from InfraMon_\n_Monitor ID: 7_\n    	2025-10-06 04:37:13.669+00	2025-10-06 04:37:13.669+00	7	1
84	email	2025-10-06 04:37:23.393+00	\n🚨 CRITICAL: Website Down Alert\n================================\n\nWebsite: SYS Portal\nURL: https://sys.mynagad.com:20020/\nStatus: DOWN ❌\nResponse Time: 10032ms\nStatus Code: N/A\nMonitoring Method: CURL GET\nError: CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n\n\n📊 Technical Details:\n- URL: https://sys.mynagad.com:20020/\n- Method: CURL GET\n- Status Code: N/A\n- Response Time: 10032ms\n- Timestamp: 10/6/2025, 10:37:23 AM\n\n🔧 Recommended Actions:\n• Check server status and logs\n• Verify network connectivity  \n• Review recent deployments\n• Check SSL certificate validity\n\nThis is an automated alert from InfraMon.\nMonitor ID: 6\n      	2025-10-06 04:37:23.393+00	2025-10-06 04:37:23.393+00	6	1
85	telegram	2025-10-06 04:37:23.393+00	\n🚨 *CRITICAL ALERT: Website Down* 🚨\n\n*Website:* SYS Portal\n*URL:* https://sys\\.mynagad\\.com:20020/\n*Status:* DOWN ❌\n*Response Time:* 10032ms\n*Status Code:* N/A\n*Method:* CURL GET\n\n📊 *Technical Details:*\n• URL: https://sys\\.mynagad\\.com:20020/\n• Monitoring Method: CURL GET\n• Status Code: N/A\n• Response Time: 10032ms\n• Timestamp: 10/6/2025, 10:37:23 AM\n\n⚠️ *Error:* CURL GET failed: Command failed: curl \\-s \\-o /dev/null \\-w "%\\{http\\_code\\}" \\-X GET \\-\\-max\\-time 10 "https://sys\\.mynagad\\.com:20020/"\n\n\n🔧 *Recommended Actions:*\n• Check server status\n• Verify network connectivity\n• Review recent changes\n• Check SSL certificates\n\n_This is an automated alert from InfraMon_\n_Monitor ID: 6_\n    	2025-10-06 04:37:23.393+00	2025-10-06 04:37:23.393+00	6	1
86	email	2025-10-06 04:37:31.636+00	\n🚨 CRITICAL: Website Down Alert\n================================\n\nWebsite: GOOGLE\nURL: https://google.com\nStatus: DOWN ❌\nResponse Time: 31ms\nStatus Code: N/A\nMonitoring Method: GET\nError: HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com\n\n📊 Technical Details:\n- URL: https://google.com\n- Method: GET\n- Status Code: N/A\n- Response Time: 31ms\n- Timestamp: 10/6/2025, 10:37:31 AM\n\n🔧 Recommended Actions:\n• Check server status and logs\n• Verify network connectivity  \n• Review recent deployments\n• Check SSL certificate validity\n\nThis is an automated alert from InfraMon.\nMonitor ID: 1\n      	2025-10-06 04:37:31.636+00	2025-10-06 04:37:31.636+00	1	1
87	telegram	2025-10-06 04:37:31.636+00	\n🚨 *CRITICAL ALERT: Website Down* 🚨\n\n*Website:* GOOGLE\n*URL:* https://google\\.com\n*Status:* DOWN ❌\n*Response Time:* 31ms\n*Status Code:* N/A\n*Method:* GET\n\n📊 *Technical Details:*\n• URL: https://google\\.com\n• Monitoring Method: GET\n• Status Code: N/A\n• Response Time: 31ms\n• Timestamp: 10/6/2025, 10:37:31 AM\n\n⚠️ *Error:* HTTP failed and PING fallback also failed: getaddrinfo EAI\\_AGAIN google\\.com\n\n🔧 *Recommended Actions:*\n• Check server status\n• Verify network connectivity\n• Review recent changes\n• Check SSL certificates\n\n_This is an automated alert from InfraMon_\n_Monitor ID: 1_\n    	2025-10-06 04:37:31.636+00	2025-10-06 04:37:31.636+00	1	1
88	email	2025-10-06 04:37:33.217+00	\n🚨 CRITICAL: Website Down Alert\n================================\n\nWebsite: NID SERVER\nURL: https://prportal.nidw.gov.bd/partner-portal/home\nStatus: DOWN ❌\nResponse Time: 10034ms\nStatus Code: N/A\nMonitoring Method: CURL GET\nError: CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://prportal.nidw.gov.bd/partner-portal/home"\n\n\n📊 Technical Details:\n- URL: https://prportal.nidw.gov.bd/partner-portal/home\n- Method: CURL GET\n- Status Code: N/A\n- Response Time: 10034ms\n- Timestamp: 10/6/2025, 10:37:33 AM\n\n🔧 Recommended Actions:\n• Check server status and logs\n• Verify network connectivity  \n• Review recent deployments\n• Check SSL certificate validity\n\nThis is an automated alert from InfraMon.\nMonitor ID: 3\n      	2025-10-06 04:37:33.217+00	2025-10-06 04:37:33.217+00	3	1
89	telegram	2025-10-06 04:37:33.217+00	\n🚨 *CRITICAL ALERT: Website Down* 🚨\n\n*Website:* NID SERVER\n*URL:* https://prportal\\.nidw\\.gov\\.bd/partner\\-portal/home\n*Status:* DOWN ❌\n*Response Time:* 10034ms\n*Status Code:* N/A\n*Method:* CURL GET\n\n📊 *Technical Details:*\n• URL: https://prportal\\.nidw\\.gov\\.bd/partner\\-portal/home\n• Monitoring Method: CURL GET\n• Status Code: N/A\n• Response Time: 10034ms\n• Timestamp: 10/6/2025, 10:37:33 AM\n\n⚠️ *Error:* CURL GET failed: Command failed: curl \\-s \\-o /dev/null \\-w "%\\{http\\_code\\}" \\-X GET \\-\\-max\\-time 10 "https://prportal\\.nidw\\.gov\\.bd/partner\\-portal/home"\n\n\n🔧 *Recommended Actions:*\n• Check server status\n• Verify network connectivity\n• Review recent changes\n• Check SSL certificates\n\n_This is an automated alert from InfraMon_\n_Monitor ID: 3_\n    	2025-10-06 04:37:33.217+00	2025-10-06 04:37:33.217+00	3	1
90	email	2025-10-06 04:38:32.438+00	\n✅ RECOVERY: Website Back Online\n================================\n\nWebsite: GOOGLE\nURL: https://google.com\nStatus: ONLINE ✅\nResponse Time: 830ms\nMonitoring Method: GET\n\n🎉 Recovery Confirmed!\nYour website has successfully recovered and is now responding normally.\n\n📊 Current Status:\n- URL: https://google.com\n- Method: GET \n- Response Time: 830ms\n- Status: ONLINE ✅\n- Check Interval: Every 1 minutes\n- Recovery Time: 10/6/2025, 10:38:32 AM\n\nThe monitoring system will continue to track your website's status.\n\nThis is an automated recovery alert from InfraMon.\nMonitor ID: 1\n      	2025-10-06 04:38:32.438+00	2025-10-06 04:38:32.438+00	1	1
91	telegram	2025-10-06 04:38:32.438+00	\n✅ *RECOVERY ALERT: Website Back Online* ✅\n\n*Website:* GOOGLE\n*URL:* https://google\\.com  \n*Status:* ONLINE ✅\n*Response Time:* 830ms\n*Method:* GET\n\n🎉 *Recovery Confirmed!*\nYour website has successfully recovered and is now responding normally.\n\n📊 *Current Status:*\n• URL: https://google\\.com\n• Monitoring Method: GET\n• Response Time: 830ms\n• Status: ONLINE ✅\n• Check Interval: Every 1 minutes\n• Recovery Time: 10/6/2025, 10:38:32 AM\n\nThe monitoring system will continue to track your website's status.\n\n_This is an automated recovery alert from InfraMon_\n_Monitor ID: 1_\n    	2025-10-06 04:38:32.438+00	2025-10-06 04:38:32.438+00	1	1
92	email	2025-10-06 05:07:23.509+00	\n🚨 CRITICAL: Website Down Alert\n================================\n\nWebsite: SYS Portal\nURL: https://sys.mynagad.com:20020/\nStatus: DOWN ❌\nResponse Time: 10040ms\nStatus Code: N/A\nMonitoring Method: CURL GET\nError: CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n\n\n📊 Technical Details:\n- URL: https://sys.mynagad.com:20020/\n- Method: CURL GET\n- Status Code: N/A\n- Response Time: 10040ms\n- Timestamp: 10/6/2025, 11:07:23 AM\n\n🔧 Recommended Actions:\n• Check server status and logs\n• Verify network connectivity  \n• Review recent deployments\n• Check SSL certificate validity\n\nThis is an automated alert from InfraMon.\nMonitor ID: 6\n      	2025-10-06 05:07:23.51+00	2025-10-06 05:07:23.51+00	6	1
93	telegram	2025-10-06 05:07:23.51+00	\n🚨 *CRITICAL ALERT: Website Down* 🚨\n\n*Website:* SYS Portal\n*URL:* https://sys\\.mynagad\\.com:20020/\n*Status:* DOWN ❌\n*Response Time:* 10040ms\n*Status Code:* N/A\n*Method:* CURL GET\n\n📊 *Technical Details:*\n• URL: https://sys\\.mynagad\\.com:20020/\n• Monitoring Method: CURL GET\n• Status Code: N/A\n• Response Time: 10040ms\n• Timestamp: 10/6/2025, 11:07:23 AM\n\n⚠️ *Error:* CURL GET failed: Command failed: curl \\-s \\-o /dev/null \\-w "%\\{http\\_code\\}" \\-X GET \\-\\-max\\-time 10 "https://sys\\.mynagad\\.com:20020/"\n\n\n🔧 *Recommended Actions:*\n• Check server status\n• Verify network connectivity\n• Review recent changes\n• Check SSL certificates\n\n_This is an automated alert from InfraMon_\n_Monitor ID: 6_\n    	2025-10-06 05:07:23.511+00	2025-10-06 05:07:23.511+00	6	1
94	email	2025-10-06 05:07:33.505+00	\n🚨 CRITICAL: Website Down Alert\n================================\n\nWebsite: NID SERVER\nURL: https://prportal.nidw.gov.bd/partner-portal/home\nStatus: DOWN ❌\nResponse Time: 10053ms\nStatus Code: N/A\nMonitoring Method: CURL GET\nError: CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://prportal.nidw.gov.bd/partner-portal/home"\n\n\n📊 Technical Details:\n- URL: https://prportal.nidw.gov.bd/partner-portal/home\n- Method: CURL GET\n- Status Code: N/A\n- Response Time: 10053ms\n- Timestamp: 10/6/2025, 11:07:33 AM\n\n🔧 Recommended Actions:\n• Check server status and logs\n• Verify network connectivity  \n• Review recent deployments\n• Check SSL certificate validity\n\nThis is an automated alert from InfraMon.\nMonitor ID: 3\n      	2025-10-06 05:07:33.505+00	2025-10-06 05:07:33.505+00	3	1
95	telegram	2025-10-06 05:07:33.505+00	\n🚨 *CRITICAL ALERT: Website Down* 🚨\n\n*Website:* NID SERVER\n*URL:* https://prportal\\.nidw\\.gov\\.bd/partner\\-portal/home\n*Status:* DOWN ❌\n*Response Time:* 10053ms\n*Status Code:* N/A\n*Method:* CURL GET\n\n📊 *Technical Details:*\n• URL: https://prportal\\.nidw\\.gov\\.bd/partner\\-portal/home\n• Monitoring Method: CURL GET\n• Status Code: N/A\n• Response Time: 10053ms\n• Timestamp: 10/6/2025, 11:07:33 AM\n\n⚠️ *Error:* CURL GET failed: Command failed: curl \\-s \\-o /dev/null \\-w "%\\{http\\_code\\}" \\-X GET \\-\\-max\\-time 10 "https://prportal\\.nidw\\.gov\\.bd/partner\\-portal/home"\n\n\n🔧 *Recommended Actions:*\n• Check server status\n• Verify network connectivity\n• Review recent changes\n• Check SSL certificates\n\n_This is an automated alert from InfraMon_\n_Monitor ID: 3_\n    	2025-10-06 05:07:33.505+00	2025-10-06 05:07:33.505+00	3	1
96	email	2025-10-06 05:08:13.661+00	\n🚨 CRITICAL: Website Down Alert\n================================\n\nWebsite: CC Portal\nURL: https://cc.mynagad.com:20030/\nStatus: DOWN ❌\nResponse Time: 10037ms\nStatus Code: N/A\nMonitoring Method: CURL GET\nError: CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n\n\n📊 Technical Details:\n- URL: https://cc.mynagad.com:20030/\n- Method: CURL GET\n- Status Code: N/A\n- Response Time: 10037ms\n- Timestamp: 10/6/2025, 11:08:13 AM\n\n🔧 Recommended Actions:\n• Check server status and logs\n• Verify network connectivity  \n• Review recent deployments\n• Check SSL certificate validity\n\nThis is an automated alert from InfraMon.\nMonitor ID: 7\n      	2025-10-06 05:08:13.661+00	2025-10-06 05:08:13.661+00	7	1
97	telegram	2025-10-06 05:08:13.662+00	\n🚨 *CRITICAL ALERT: Website Down* 🚨\n\n*Website:* CC Portal\n*URL:* https://cc\\.mynagad\\.com:20030/\n*Status:* DOWN ❌\n*Response Time:* 10037ms\n*Status Code:* N/A\n*Method:* CURL GET\n\n📊 *Technical Details:*\n• URL: https://cc\\.mynagad\\.com:20030/\n• Monitoring Method: CURL GET\n• Status Code: N/A\n• Response Time: 10037ms\n• Timestamp: 10/6/2025, 11:08:13 AM\n\n⚠️ *Error:* CURL GET failed: Command failed: curl \\-s \\-o /dev/null \\-w "%\\{http\\_code\\}" \\-X GET \\-\\-max\\-time 10 "https://cc\\.mynagad\\.com:20030/"\n\n\n🔧 *Recommended Actions:*\n• Check server status\n• Verify network connectivity\n• Review recent changes\n• Check SSL certificates\n\n_This is an automated alert from InfraMon_\n_Monitor ID: 7_\n    	2025-10-06 05:08:13.662+00	2025-10-06 05:08:13.662+00	7	1
98	email	2025-10-06 05:08:23.616+00	\n✅ RECOVERY: Website Back Online\n================================\n\nWebsite: NID SERVER\nURL: https://prportal.nidw.gov.bd/partner-portal/home\nStatus: ONLINE ✅\nResponse Time: 133ms\nMonitoring Method: CURL GET\n\n🎉 Recovery Confirmed!\nYour website has successfully recovered and is now responding normally.\n\n📊 Current Status:\n- URL: https://prportal.nidw.gov.bd/partner-portal/home\n- Method: CURL GET \n- Response Time: 133ms\n- Status: ONLINE ✅\n- Check Interval: Every 1 minutes\n- Recovery Time: 10/6/2025, 11:08:23 AM\n\nThe monitoring system will continue to track your website's status.\n\nThis is an automated recovery alert from InfraMon.\nMonitor ID: 3\n      	2025-10-06 05:08:23.616+00	2025-10-06 05:08:23.616+00	3	1
99	telegram	2025-10-06 05:08:23.616+00	\n✅ *RECOVERY ALERT: Website Back Online* ✅\n\n*Website:* NID SERVER\n*URL:* https://prportal\\.nidw\\.gov\\.bd/partner\\-portal/home  \n*Status:* ONLINE ✅\n*Response Time:* 133ms\n*Method:* CURL GET\n\n🎉 *Recovery Confirmed!*\nYour website has successfully recovered and is now responding normally.\n\n📊 *Current Status:*\n• URL: https://prportal\\.nidw\\.gov\\.bd/partner\\-portal/home\n• Monitoring Method: CURL GET\n• Response Time: 133ms\n• Status: ONLINE ✅\n• Check Interval: Every 1 minutes\n• Recovery Time: 10/6/2025, 11:08:23 AM\n\nThe monitoring system will continue to track your website's status.\n\n_This is an automated recovery alert from InfraMon_\n_Monitor ID: 3_\n    	2025-10-06 05:08:23.616+00	2025-10-06 05:08:23.616+00	3	1
100	email	2025-10-06 05:09:03.836+00	\n✅ RECOVERY: Website Back Online\n================================\n\nWebsite: CC Portal\nURL: https://cc.mynagad.com:20030/\nStatus: ONLINE ✅\nResponse Time: 217ms\nMonitoring Method: CURL GET\n\n🎉 Recovery Confirmed!\nYour website has successfully recovered and is now responding normally.\n\n📊 Current Status:\n- URL: https://cc.mynagad.com:20030/\n- Method: CURL GET \n- Response Time: 217ms\n- Status: ONLINE ✅\n- Check Interval: Every 1 minutes\n- Recovery Time: 10/6/2025, 11:09:03 AM\n\nThe monitoring system will continue to track your website's status.\n\nThis is an automated recovery alert from InfraMon.\nMonitor ID: 7\n      	2025-10-06 05:09:03.836+00	2025-10-06 05:09:03.836+00	7	1
101	telegram	2025-10-06 05:09:03.836+00	\n✅ *RECOVERY ALERT: Website Back Online* ✅\n\n*Website:* CC Portal\n*URL:* https://cc\\.mynagad\\.com:20030/  \n*Status:* ONLINE ✅\n*Response Time:* 217ms\n*Method:* CURL GET\n\n🎉 *Recovery Confirmed!*\nYour website has successfully recovered and is now responding normally.\n\n📊 *Current Status:*\n• URL: https://cc\\.mynagad\\.com:20030/\n• Monitoring Method: CURL GET\n• Response Time: 217ms\n• Status: ONLINE ✅\n• Check Interval: Every 1 minutes\n• Recovery Time: 10/6/2025, 11:09:03 AM\n\nThe monitoring system will continue to track your website's status.\n\n_This is an automated recovery alert from InfraMon_\n_Monitor ID: 7_\n    	2025-10-06 05:09:03.837+00	2025-10-06 05:09:03.837+00	7	1
102	email	2025-10-06 05:09:13.594+00	\n✅ RECOVERY: Website Back Online\n================================\n\nWebsite: SYS Portal\nURL: https://sys.mynagad.com:20020/\nStatus: ONLINE ✅\nResponse Time: 161ms\nMonitoring Method: CURL GET\n\n🎉 Recovery Confirmed!\nYour website has successfully recovered and is now responding normally.\n\n📊 Current Status:\n- URL: https://sys.mynagad.com:20020/\n- Method: CURL GET \n- Response Time: 161ms\n- Status: ONLINE ✅\n- Check Interval: Every 1 minutes\n- Recovery Time: 10/6/2025, 11:09:13 AM\n\nThe monitoring system will continue to track your website's status.\n\nThis is an automated recovery alert from InfraMon.\nMonitor ID: 6\n      	2025-10-06 05:09:13.594+00	2025-10-06 05:09:13.594+00	6	1
103	telegram	2025-10-06 05:09:13.594+00	\n✅ *RECOVERY ALERT: Website Back Online* ✅\n\n*Website:* SYS Portal\n*URL:* https://sys\\.mynagad\\.com:20020/  \n*Status:* ONLINE ✅\n*Response Time:* 161ms\n*Method:* CURL GET\n\n🎉 *Recovery Confirmed!*\nYour website has successfully recovered and is now responding normally.\n\n📊 *Current Status:*\n• URL: https://sys\\.mynagad\\.com:20020/\n• Monitoring Method: CURL GET\n• Response Time: 161ms\n• Status: ONLINE ✅\n• Check Interval: Every 1 minutes\n• Recovery Time: 10/6/2025, 11:09:13 AM\n\nThe monitoring system will continue to track your website's status.\n\n_This is an automated recovery alert from InfraMon_\n_Monitor ID: 6_\n    	2025-10-06 05:09:13.594+00	2025-10-06 05:09:13.594+00	6	1
\.


--
-- Data for Name: MonitorLogs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."MonitorLogs" (id, status, "responseTime", "statusCode", message, "createdAt", "updatedAt", "websiteId") FROM stdin;
1	up	5849	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 22:29:46.862+00	2025-10-01 22:29:46.862+00	1
2	up	5751	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 22:29:49.742+00	2025-10-01 22:29:49.742+00	1
3	up	702	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 22:30:41.722+00	2025-10-01 22:30:41.722+00	1
4	up	712	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 22:31:41.735+00	2025-10-01 22:31:41.735+00	1
5	up	786	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 22:31:44.034+00	2025-10-01 22:31:44.034+00	1
6	up	694	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 22:31:44.893+00	2025-10-01 22:31:44.893+00	1
7	up	714	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 22:31:45.95+00	2025-10-01 22:31:45.95+00	1
8	up	717	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 22:32:00.519+00	2025-10-01 22:32:00.519+00	1
9	up	5762	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 22:32:46.785+00	2025-10-01 22:32:46.785+00	1
10	up	904	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 22:33:41.935+00	2025-10-01 22:33:41.935+00	1
11	up	7474	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 22:34:48.515+00	2025-10-01 22:34:48.515+00	1
12	up	1176	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 22:35:42.218+00	2025-10-01 22:35:42.218+00	1
13	up	1366	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 22:36:42.419+00	2025-10-01 22:36:42.419+00	1
14	up	1016	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 22:37:29.148+00	2025-10-01 22:37:29.148+00	1
15	up	6146	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 22:38:34.269+00	2025-10-01 22:38:34.269+00	1
16	up	15408	200	Website is up (PING fallback successful) [PING (fallback)]	2025-10-01 22:39:43.539+00	2025-10-01 22:39:43.539+00	1
17	up	807	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 22:40:28.939+00	2025-10-01 22:40:28.939+00	1
18	up	796	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 22:41:28.933+00	2025-10-01 22:41:28.933+00	1
19	up	741	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 22:42:28.887+00	2025-10-01 22:42:28.887+00	1
20	up	699	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 22:43:28.848+00	2025-10-01 22:43:28.848+00	1
21	up	5755	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 22:44:33.908+00	2025-10-01 22:44:33.908+00	1
22	up	2494	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 22:45:30.656+00	2025-10-01 22:45:30.656+00	1
23	up	1003	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 22:46:29.169+00	2025-10-01 22:46:29.169+00	1
24	up	1536	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 22:47:29.703+00	2025-10-01 22:47:29.703+00	1
25	up	1084	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 22:48:29.288+00	2025-10-01 22:48:29.288+00	1
26	up	1041	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 22:49:29.251+00	2025-10-01 22:49:29.251+00	1
27	up	1327	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 22:50:29.541+00	2025-10-01 22:50:29.541+00	1
28	up	998	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 22:51:29.215+00	2025-10-01 22:51:29.215+00	1
29	up	1014	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 22:52:29.24+00	2025-10-01 22:52:29.24+00	1
30	up	750	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 22:53:28.977+00	2025-10-01 22:53:28.977+00	1
31	up	853	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 22:54:29.082+00	2025-10-01 22:54:29.082+00	1
32	up	754	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 22:55:28.988+00	2025-10-01 22:55:28.988+00	1
33	up	921	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 22:56:29.155+00	2025-10-01 22:56:29.155+00	1
34	up	1187	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 22:57:29.435+00	2025-10-01 22:57:29.435+00	1
35	up	966	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 22:58:29.217+00	2025-10-01 22:58:29.217+00	1
36	up	930	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 22:59:29.185+00	2025-10-01 22:59:29.185+00	1
37	up	1174	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:00:29.425+00	2025-10-01 23:00:29.425+00	1
38	up	762	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:01:29.014+00	2025-10-01 23:01:29.014+00	1
39	up	759	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:02:29.015+00	2025-10-01 23:02:29.015+00	1
40	up	987	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:03:29.248+00	2025-10-01 23:03:29.248+00	1
41	up	1310	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:04:29.576+00	2025-10-01 23:04:29.576+00	1
42	up	1025	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:05:29.298+00	2025-10-01 23:05:29.298+00	1
43	up	804	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:06:29.081+00	2025-10-01 23:06:29.081+00	1
44	up	860	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:07:29.14+00	2025-10-01 23:07:29.14+00	1
45	up	730	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:08:29.009+00	2025-10-01 23:08:29.009+00	1
46	up	823	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:09:29.112+00	2025-10-01 23:09:29.112+00	1
47	up	817	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:10:29.11+00	2025-10-01 23:10:29.11+00	1
48	up	846	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:11:29.146+00	2025-10-01 23:11:29.146+00	1
49	up	706	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:12:29.009+00	2025-10-01 23:12:29.009+00	1
50	up	797	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:13:29.108+00	2025-10-01 23:13:29.108+00	1
51	up	773	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:14:29.085+00	2025-10-01 23:14:29.085+00	1
52	up	836	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:15:29.153+00	2025-10-01 23:15:29.153+00	1
53	up	774	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:16:29.097+00	2025-10-01 23:16:29.097+00	1
54	up	754	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:17:29.083+00	2025-10-01 23:17:29.083+00	1
55	up	763	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:18:29.093+00	2025-10-01 23:18:29.093+00	1
56	up	778	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:19:29.111+00	2025-10-01 23:19:29.111+00	1
57	up	907	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:20:29.246+00	2025-10-01 23:20:29.246+00	1
58	up	756	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:21:29.101+00	2025-10-01 23:21:29.101+00	1
59	up	1332	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:22:29.712+00	2025-10-01 23:22:29.712+00	1
60	up	1323	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:23:29.705+00	2025-10-01 23:23:29.705+00	1
61	up	827	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:24:29.214+00	2025-10-01 23:24:29.214+00	1
62	up	747	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:25:29.139+00	2025-10-01 23:25:29.139+00	1
63	up	852	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:26:29.253+00	2025-10-01 23:26:29.253+00	1
64	up	804	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:27:29.207+00	2025-10-01 23:27:29.207+00	1
65	up	821	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:28:29.223+00	2025-10-01 23:28:29.223+00	1
66	up	897	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:29:29.302+00	2025-10-01 23:29:29.302+00	1
67	up	821	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:30:29.234+00	2025-10-01 23:30:29.234+00	1
68	up	756	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:31:29.17+00	2025-10-01 23:31:29.17+00	1
69	up	1437	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:32:29.854+00	2025-10-01 23:32:29.854+00	1
70	up	1207	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:33:29.631+00	2025-10-01 23:33:29.631+00	1
71	up	1577	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:34:30.005+00	2025-10-01 23:34:30.005+00	1
72	up	1611	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:35:30.041+00	2025-10-01 23:35:30.041+00	1
73	up	6085	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:36:04.06+00	2025-10-01 23:36:04.06+00	1
74	up	1432	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:36:59.409+00	2025-10-01 23:36:59.409+00	1
75	up	1084	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:37:06.426+00	2025-10-01 23:37:06.426+00	1
76	up	7264	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:38:05.553+00	2025-10-01 23:38:05.553+00	1
77	up	6029	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:39:04.32+00	2025-10-01 23:39:04.32+00	1
78	up	954	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:39:54.827+00	2025-10-01 23:39:54.827+00	1
79	up	1262	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:39:59.556+00	2025-10-01 23:39:59.556+00	1
1218	up	185	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:30:55.459+00	2025-10-05 09:30:55.459+00	7
1219	up	167	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:31:05.219+00	2025-10-05 09:31:05.219+00	6
1220	up	129	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:31:14.323+00	2025-10-05 09:31:14.323+00	3
1221	up	139	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:31:14.694+00	2025-10-05 09:31:14.694+00	5
1222	up	768	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:31:23.969+00	2025-10-05 09:31:23.969+00	1
85	up	6009	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:41:04.306+00	2025-10-01 23:41:04.306+00	1
1229	up	424	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:32:50.021+00	2025-10-05 09:32:50.021+00	4
87	up	968	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:41:59.265+00	2025-10-01 23:41:59.265+00	1
88	up	1624	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:42:59.93+00	2025-10-01 23:42:59.93+00	1
89	up	973	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:43:59.286+00	2025-10-01 23:43:59.286+00	1
90	up	804	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:44:59.122+00	2025-10-01 23:44:59.122+00	1
91	up	824	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:45:59.141+00	2025-10-01 23:45:59.141+00	1
92	up	806	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:46:59.132+00	2025-10-01 23:46:59.132+00	1
93	up	802	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:47:59.138+00	2025-10-01 23:47:59.138+00	1
94	up	834	200	Website is up (HTTP 200) [HTTP GET]	2025-10-01 23:48:59.173+00	2025-10-01 23:48:59.173+00	1
95	up	6059	200	Website is up (HTTP 200) [HTTP GET]	2025-10-02 00:23:29.432+00	2025-10-02 00:23:29.432+00	1
96	up	900	200	Website is up (HTTP 200) [HTTP GET]	2025-10-02 00:24:24.279+00	2025-10-02 00:24:24.279+00	1
97	up	6035	200	Website is up (HTTP 200) [HTTP GET]	2025-10-02 00:25:29.416+00	2025-10-02 00:25:29.416+00	1
98	up	1786	200	Website is up (HTTP 200) [HTTP GET]	2025-10-02 00:26:25.167+00	2025-10-02 00:26:25.167+00	1
99	up	5944	200	Website is up (HTTP 200) [HTTP GET]	2025-10-02 00:27:29.333+00	2025-10-02 00:27:29.333+00	1
100	up	979	200	Website is up (HTTP 200) [HTTP GET]	2025-10-02 00:28:07.847+00	2025-10-02 00:28:07.847+00	1
101	up	6059	200	Website is up (HTTP 200) [HTTP GET]	2025-10-02 00:28:29.45+00	2025-10-02 00:28:29.45+00	1
102	up	1029	200	Website is up (HTTP 200) [HTTP GET]	2025-10-02 00:29:24.424+00	2025-10-02 00:29:24.424+00	1
103	up	1004	200	Website is up (HTTP 200) [HTTP GET]	2025-10-02 00:30:24.402+00	2025-10-02 00:30:24.402+00	1
104	up	1006	200	Website is up (HTTP 200) [HTTP GET]	2025-10-02 00:31:24.413+00	2025-10-02 00:31:24.413+00	1
105	up	962	200	Website is up (HTTP 200) [HTTP GET]	2025-10-02 00:32:24.368+00	2025-10-02 00:32:24.368+00	1
106	up	954	200	Website is up (HTTP 200) [HTTP GET]	2025-10-02 00:33:24.369+00	2025-10-02 00:33:24.369+00	1
107	up	1122	200	Website is up (HTTP 200) [HTTP GET]	2025-10-02 00:34:24.539+00	2025-10-02 00:34:24.539+00	1
108	up	1074	200	Website is up (HTTP 200) [HTTP GET]	2025-10-02 00:35:24.496+00	2025-10-02 00:35:24.496+00	1
109	up	958	200	Website is up (HTTP 200) [HTTP GET]	2025-10-02 00:36:24.396+00	2025-10-02 00:36:24.396+00	1
110	up	712	200	Website is up (HTTP 200) [HTTP GET]	2025-10-02 00:37:24.149+00	2025-10-02 00:37:24.149+00	1
111	up	732	200	Website is up (HTTP 200) [HTTP GET]	2025-10-02 00:38:24.187+00	2025-10-02 00:38:24.187+00	1
112	up	779	200	Website is up (HTTP 200) [HTTP GET]	2025-10-02 00:39:24.239+00	2025-10-02 00:39:24.239+00	1
113	up	1600	200	Website is up (HTTP 200) [HTTP GET]	2025-10-02 00:40:25.065+00	2025-10-02 00:40:25.065+00	1
114	up	887	200	Website is up (HTTP 200) [HTTP GET]	2025-10-02 00:41:24.361+00	2025-10-02 00:41:24.361+00	1
115	up	1093	200	Website is up (HTTP 200) [HTTP GET]	2025-10-02 00:42:24.576+00	2025-10-02 00:42:24.576+00	1
116	up	1149	200	Website is up (HTTP 200) [HTTP GET]	2025-10-02 00:43:24.636+00	2025-10-02 00:43:24.636+00	1
117	up	1271	200	Website is up (HTTP 200) [HTTP GET]	2025-10-02 00:44:24.761+00	2025-10-02 00:44:24.761+00	1
118	up	1093	200	Website is up (HTTP 200) [HTTP GET]	2025-10-02 00:45:24.59+00	2025-10-02 00:45:24.59+00	1
119	up	1101	200	Website is up (HTTP 200) [HTTP GET]	2025-10-02 00:46:24.6+00	2025-10-02 00:46:24.6+00	1
120	up	973	200	Website is up (HTTP 200) [HTTP GET]	2025-10-02 00:47:24.476+00	2025-10-02 00:47:24.476+00	1
121	up	804	200	Website is up (HTTP 200) [HTTP GET]	2025-10-02 00:48:24.311+00	2025-10-02 00:48:24.311+00	1
122	up	776	200	Website is up (HTTP 200) [HTTP GET]	2025-10-02 00:49:24.288+00	2025-10-02 00:49:24.288+00	1
123	up	788	200	Website is up (HTTP 200) [HTTP GET]	2025-10-02 00:50:24.305+00	2025-10-02 00:50:24.305+00	1
124	up	760	200	Website is up (HTTP 200) [HTTP GET]	2025-10-02 00:51:24.287+00	2025-10-02 00:51:24.287+00	1
125	up	893	200	Website is up (HTTP 200) [HTTP GET]	2025-10-02 00:52:24.418+00	2025-10-02 00:52:24.418+00	1
126	up	924	200	Website is up (HTTP 200) [HTTP GET]	2025-10-02 00:53:24.454+00	2025-10-02 00:53:24.454+00	1
127	up	998	200	Website is up (HTTP 200) [HTTP GET]	2025-10-02 00:54:24.529+00	2025-10-02 00:54:24.529+00	1
128	up	1053	200	Website is up (HTTP 200) [HTTP GET]	2025-10-02 00:55:24.589+00	2025-10-02 00:55:24.589+00	1
129	up	1165	200	Website is up (HTTP 200) [HTTP GET]	2025-10-02 00:56:24.711+00	2025-10-02 00:56:24.711+00	1
130	up	1544	200	Website is up (HTTP 200) [HTTP GET]	2025-10-02 00:57:25.09+00	2025-10-02 00:57:25.09+00	1
131	up	1725	200	Website is up (HTTP 200) [HTTP GET]	2025-10-02 00:58:25.279+00	2025-10-02 00:58:25.279+00	1
132	up	1015	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:05:56.856+00	2025-10-03 09:05:56.856+00	1
133	up	1058	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:20:38.074+00	2025-10-03 09:20:38.074+00	1
134	up	1151	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:21:38.167+00	2025-10-03 09:21:38.167+00	1
135	up	1213	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:22:38.231+00	2025-10-03 09:22:38.231+00	1
136	up	697	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:23:37.717+00	2025-10-03 09:23:37.717+00	1
137	up	1120	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:24:38.14+00	2025-10-03 09:24:38.14+00	1
138	up	1209	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:25:38.231+00	2025-10-03 09:25:38.231+00	1
139	up	1107	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:26:38.129+00	2025-10-03 09:26:38.129+00	1
140	up	1299	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:27:38.322+00	2025-10-03 09:27:38.322+00	1
141	up	6329	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:28:43.352+00	2025-10-03 09:28:43.352+00	1
142	up	607	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:29:37.632+00	2025-10-03 09:29:37.632+00	1
143	up	2294	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:30:39.318+00	2025-10-03 09:30:39.318+00	1
144	up	1216	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:31:38.243+00	2025-10-03 09:31:38.243+00	1
145	up	828	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:32:37.31+00	2025-10-03 09:32:37.31+00	1
146	up	1713	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:33:38.194+00	2025-10-03 09:33:38.194+00	1
147	up	969	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:34:37.452+00	2025-10-03 09:34:37.452+00	1
148	up	953	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:35:37.436+00	2025-10-03 09:35:37.436+00	1
1230	up	324	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:32:55.605+00	2025-10-05 09:32:55.605+00	7
149	up	1440	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:36:37.926+00	2025-10-03 09:36:37.926+00	1
150	up	914	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:37:37.401+00	2025-10-03 09:37:37.401+00	1
151	up	1064	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:38:37.552+00	2025-10-03 09:38:37.552+00	1
152	up	1030	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:39:37.521+00	2025-10-03 09:39:37.521+00	1
153	up	1173	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:40:37.664+00	2025-10-03 09:40:37.664+00	1
154	up	1080	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:41:37.572+00	2025-10-03 09:41:37.572+00	1
155	up	859	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:42:37.354+00	2025-10-03 09:42:37.354+00	1
156	up	902	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:43:37.397+00	2025-10-03 09:43:37.397+00	1
157	up	1023	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:44:37.521+00	2025-10-03 09:44:37.521+00	1
158	up	1161	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:45:37.66+00	2025-10-03 09:45:37.66+00	1
159	up	1082	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:46:37.583+00	2025-10-03 09:46:37.583+00	1
160	up	995	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:47:37.495+00	2025-10-03 09:47:37.495+00	1
161	up	935	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:48:37.436+00	2025-10-03 09:48:37.436+00	1
162	up	1102	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:49:37.603+00	2025-10-03 09:49:37.603+00	1
163	up	987	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:50:37.49+00	2025-10-03 09:50:37.49+00	1
164	up	1014	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:51:37.521+00	2025-10-03 09:51:37.521+00	1
165	up	728	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:52:37.235+00	2025-10-03 09:52:37.235+00	1
166	up	658	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:53:37.165+00	2025-10-03 09:53:37.165+00	1
167	up	677	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:54:37.183+00	2025-10-03 09:54:37.183+00	1
168	up	1334	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:55:37.844+00	2025-10-03 09:55:37.844+00	1
169	up	777	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:56:37.288+00	2025-10-03 09:56:37.288+00	1
170	up	662	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:57:37.174+00	2025-10-03 09:57:37.174+00	1
171	up	590	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:58:37.103+00	2025-10-03 09:58:37.103+00	1
172	up	761	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 09:59:37.275+00	2025-10-03 09:59:37.275+00	1
173	up	2021	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 10:00:39.107+00	2025-10-03 10:00:39.107+00	1
174	up	1120	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 10:00:52.552+00	2025-10-03 10:00:52.552+00	1
175	up	1718	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 10:01:38.806+00	2025-10-03 10:01:38.806+00	1
176	up	1159	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 10:01:52.594+00	2025-10-03 10:01:52.594+00	1
177	up	545	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 10:02:37.635+00	2025-10-03 10:02:37.635+00	1
178	up	537	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 10:03:26.144+00	2025-10-03 10:03:26.144+00	1
179	up	587	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 10:03:37.685+00	2025-10-03 10:03:37.685+00	1
180	up	619	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 10:04:37.716+00	2025-10-03 10:04:37.716+00	1
181	up	1175	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 10:05:38.273+00	2025-10-03 10:05:38.273+00	1
182	down	5292	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-03 10:06:42.445+00	2025-10-03 10:06:42.445+00	1
183	down	60	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-03 10:07:37.213+00	2025-10-03 10:07:37.213+00	1
184	down	34	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-03 10:08:18.435+00	2025-10-03 10:08:18.435+00	1
185	down	34	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-03 10:08:21.601+00	2025-10-03 10:08:21.601+00	1
186	down	159	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-03 10:08:37.312+00	2025-10-03 10:08:37.312+00	1
187	down	41	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-03 10:42:37.684+00	2025-10-03 10:42:37.684+00	1
188	up	2099	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 10:42:55.624+00	2025-10-03 10:42:55.624+00	1
189	up	1740	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 10:42:55.631+00	2025-10-03 10:42:55.631+00	1
190	up	1128	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 10:43:55.028+00	2025-10-03 10:43:55.028+00	1
191	up	1144	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 10:44:55.046+00	2025-10-03 10:44:55.046+00	1
192	up	1134	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 10:45:55.048+00	2025-10-03 10:45:55.048+00	1
193	up	995	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 10:46:54.908+00	2025-10-03 10:46:54.908+00	1
194	up	2379	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 10:47:56.293+00	2025-10-03 10:47:56.293+00	1
195	up	1032	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 10:48:54.948+00	2025-10-03 10:48:54.948+00	1
196	up	1045	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 10:49:54.964+00	2025-10-03 10:49:54.964+00	1
197	up	1003	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 10:50:54.431+00	2025-10-03 10:50:54.431+00	1
198	up	1599	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 10:51:55.028+00	2025-10-03 10:51:55.028+00	1
199	up	1128	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 10:52:54.558+00	2025-10-03 10:52:54.558+00	1
200	up	1050	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 10:53:54.483+00	2025-10-03 10:53:54.483+00	1
201	up	1693	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 10:54:55.127+00	2025-10-03 10:54:55.127+00	1
202	up	1385	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 10:55:54.825+00	2025-10-03 10:55:54.825+00	1
203	up	1013	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 10:56:54.453+00	2025-10-03 10:56:54.453+00	1
204	up	1629	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 10:57:55.07+00	2025-10-03 10:57:55.07+00	1
205	up	1125	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 10:58:54.574+00	2025-10-03 10:58:54.574+00	1
206	up	1148	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 10:59:54.598+00	2025-10-03 10:59:54.598+00	1
207	up	1075	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:00:54.18+00	2025-10-03 11:00:54.18+00	1
208	up	1048	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:01:54.155+00	2025-10-03 11:01:54.155+00	1
209	up	1083	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:02:54.192+00	2025-10-03 11:02:54.192+00	1
210	up	2555	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:03:55.664+00	2025-10-03 11:03:55.664+00	1
211	up	1797	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:04:54.908+00	2025-10-03 11:04:54.908+00	1
212	up	1177	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:05:54.288+00	2025-10-03 11:05:54.288+00	1
213	up	1245	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:06:54.357+00	2025-10-03 11:06:54.357+00	1
214	up	1862	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:07:54.975+00	2025-10-03 11:07:54.975+00	1
215	up	2178	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:08:55.293+00	2025-10-03 11:08:55.293+00	1
216	up	1059	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:09:54.176+00	2025-10-03 11:09:54.176+00	1
217	up	6494	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:10:59.611+00	2025-10-03 11:10:59.611+00	1
218	up	1150	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:11:54.268+00	2025-10-03 11:11:54.268+00	1
219	up	1101	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:12:54.225+00	2025-10-03 11:12:54.225+00	1
220	up	1869	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:13:54.993+00	2025-10-03 11:13:54.993+00	1
221	up	1084	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:14:54.21+00	2025-10-03 11:14:54.21+00	1
222	up	1133	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:15:54.26+00	2025-10-03 11:15:54.26+00	1
223	up	1160	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:16:54.289+00	2025-10-03 11:16:54.289+00	1
224	up	1784	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:17:54.916+00	2025-10-03 11:17:54.916+00	1
225	up	1222	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:18:54.355+00	2025-10-03 11:18:54.355+00	1
226	up	1835	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:19:54.968+00	2025-10-03 11:19:54.968+00	1
227	up	1118	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:20:54.252+00	2025-10-03 11:20:54.252+00	1
228	up	1300	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:21:54.435+00	2025-10-03 11:21:54.435+00	1
229	up	1035	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:22:54.174+00	2025-10-03 11:22:54.174+00	1
230	up	1304	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:23:54.445+00	2025-10-03 11:23:54.445+00	1
231	up	1550	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:24:54.694+00	2025-10-03 11:24:54.694+00	1
232	up	1114	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:25:54.259+00	2025-10-03 11:25:54.259+00	1
233	up	1030	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:26:54.177+00	2025-10-03 11:26:54.177+00	1
234	up	1111	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:27:54.258+00	2025-10-03 11:27:54.258+00	1
235	up	1126	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:28:54.276+00	2025-10-03 11:28:54.276+00	1
236	up	1241	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:29:54.392+00	2025-10-03 11:29:54.392+00	1
237	up	2654	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:30:55.807+00	2025-10-03 11:30:55.807+00	1
238	up	1008	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:31:54.164+00	2025-10-03 11:31:54.164+00	1
239	up	1374	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:32:54.53+00	2025-10-03 11:32:54.53+00	1
240	up	1235	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:33:54.391+00	2025-10-03 11:33:54.391+00	1
241	up	2129	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:34:55.286+00	2025-10-03 11:34:55.286+00	1
242	up	1219	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:35:54.378+00	2025-10-03 11:35:54.378+00	1
243	up	1048	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:36:54.207+00	2025-10-03 11:36:54.207+00	1
244	up	1103	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:37:53.353+00	2025-10-03 11:37:53.353+00	1
245	up	685	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:38:52.934+00	2025-10-03 11:38:52.934+00	1
246	down	4737	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN www.google.com [PING (fallback)]	2025-10-03 11:39:56.987+00	2025-10-03 11:39:56.987+00	1
247	up	1068	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:40:53.319+00	2025-10-03 11:40:53.319+00	1
248	up	1533	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:41:53.786+00	2025-10-03 11:41:53.786+00	1
249	up	915	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:42:53.167+00	2025-10-03 11:42:53.167+00	1
250	up	1061	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:43:53.316+00	2025-10-03 11:43:53.316+00	1
251	up	809	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:44:53.067+00	2025-10-03 11:44:53.067+00	1
252	up	847	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:45:53.105+00	2025-10-03 11:45:53.105+00	1
253	up	1030	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:46:53.288+00	2025-10-03 11:46:53.288+00	1
254	up	1232	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:47:53.491+00	2025-10-03 11:47:53.491+00	1
255	up	693	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:48:52.954+00	2025-10-03 11:48:52.954+00	1
256	up	2650	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:49:54.911+00	2025-10-03 11:49:54.911+00	1
257	up	943	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:50:53.207+00	2025-10-03 11:50:53.207+00	1
258	up	1801	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:51:54.07+00	2025-10-03 11:51:54.07+00	1
259	up	2151	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:52:54.42+00	2025-10-03 11:52:54.42+00	1
260	up	1842	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:53:54.114+00	2025-10-03 11:53:54.114+00	1
261	up	1223	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:54:53.495+00	2025-10-03 11:54:53.495+00	1
262	up	1526	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:55:53.799+00	2025-10-03 11:55:53.799+00	1
263	up	1189	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:56:53.462+00	2025-10-03 11:56:53.462+00	1
264	up	1035	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:57:53.309+00	2025-10-03 11:57:53.309+00	1
265	up	1037	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:58:53.311+00	2025-10-03 11:58:53.311+00	1
266	up	1395	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 11:59:53.67+00	2025-10-03 11:59:53.67+00	1
267	up	6174	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:00:58.45+00	2025-10-03 12:00:58.45+00	1
268	up	1127	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:01:53.404+00	2025-10-03 12:01:53.404+00	1
269	up	1083	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:02:53.361+00	2025-10-03 12:02:53.361+00	1
270	up	1193	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:03:53.472+00	2025-10-03 12:03:53.472+00	1
271	up	1159	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:04:53.439+00	2025-10-03 12:04:53.439+00	1
272	up	1164	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:05:53.445+00	2025-10-03 12:05:53.445+00	1
273	up	1116	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:06:53.399+00	2025-10-03 12:06:53.399+00	1
274	up	1117	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:07:53.401+00	2025-10-03 12:07:53.401+00	1
275	up	1058	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:08:53.344+00	2025-10-03 12:08:53.344+00	1
276	up	1088	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:09:53.374+00	2025-10-03 12:09:53.374+00	1
277	up	1964	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:10:54.252+00	2025-10-03 12:10:54.252+00	1
278	up	1171	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:11:53.458+00	2025-10-03 12:11:53.458+00	1
279	up	1379	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:12:53.665+00	2025-10-03 12:12:53.665+00	1
280	up	1195	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:13:53.484+00	2025-10-03 12:13:53.484+00	1
281	up	1460	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:14:53.75+00	2025-10-03 12:14:53.75+00	1
282	up	1837	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:15:54.129+00	2025-10-03 12:15:54.129+00	1
283	up	1656	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:16:53.95+00	2025-10-03 12:16:53.95+00	1
284	up	1108	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:17:53.402+00	2025-10-03 12:17:53.402+00	1
285	up	1019	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:18:53.313+00	2025-10-03 12:18:53.313+00	1
286	up	1287	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:19:53.582+00	2025-10-03 12:19:53.582+00	1
287	up	1084	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:20:53.382+00	2025-10-03 12:20:53.382+00	1
288	up	1672	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:21:53.979+00	2025-10-03 12:21:53.979+00	1
289	up	1894	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:22:54.203+00	2025-10-03 12:22:54.203+00	1
290	up	2062	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:23:54.373+00	2025-10-03 12:23:54.373+00	1
291	up	1326	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:24:52.999+00	2025-10-03 12:24:52.999+00	1
292	up	1185	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:25:52.859+00	2025-10-03 12:25:52.859+00	1
293	up	1586	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:26:53.261+00	2025-10-03 12:26:53.261+00	1
294	up	1199	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:27:52.874+00	2025-10-03 12:27:52.874+00	1
295	up	1363	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:28:53.038+00	2025-10-03 12:28:53.038+00	1
296	up	1133	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:29:52.809+00	2025-10-03 12:29:52.809+00	1
297	up	1196	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:30:52.874+00	2025-10-03 12:30:52.874+00	1
298	up	1232	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:31:52.911+00	2025-10-03 12:31:52.911+00	1
299	up	1378	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:32:53.057+00	2025-10-03 12:32:53.057+00	1
300	up	2517	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:33:53.954+00	2025-10-03 12:33:53.954+00	1
301	up	3125	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:34:54.563+00	2025-10-03 12:34:54.563+00	1
302	up	1143	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:35:52.585+00	2025-10-03 12:35:52.585+00	1
303	up	1263	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:36:52.708+00	2025-10-03 12:36:52.708+00	1
304	up	1372	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:37:52.818+00	2025-10-03 12:37:52.818+00	1
305	up	1143	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:38:52.591+00	2025-10-03 12:38:52.591+00	1
306	up	1063	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:39:52.512+00	2025-10-03 12:39:52.512+00	1
307	up	1295	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:40:52.744+00	2025-10-03 12:40:52.744+00	1
308	up	1098	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:41:52.548+00	2025-10-03 12:41:52.548+00	1
309	up	1163	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:42:52.173+00	2025-10-03 12:42:52.173+00	1
310	up	1322	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:43:52.336+00	2025-10-03 12:43:52.336+00	1
311	up	6470	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:44:57.486+00	2025-10-03 12:44:57.486+00	1
312	up	1235	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:45:52.251+00	2025-10-03 12:45:52.251+00	1
313	up	1961	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:46:52.977+00	2025-10-03 12:46:52.977+00	1
314	up	1163	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:47:52.181+00	2025-10-03 12:47:52.181+00	1
315	up	1871	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:48:52.89+00	2025-10-03 12:48:52.89+00	1
316	up	1225	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:49:52.245+00	2025-10-03 12:49:52.245+00	1
317	up	1990	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:50:53.023+00	2025-10-03 12:50:53.023+00	1
318	up	1808	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:51:52.841+00	2025-10-03 12:51:52.841+00	1
319	up	1275	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:52:51.878+00	2025-10-03 12:52:51.878+00	1
320	up	1426	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:53:52.03+00	2025-10-03 12:53:52.03+00	1
321	up	1480	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:54:52.094+00	2025-10-03 12:54:52.094+00	1
322	up	1153	200	Website is up (HTTP 200) [HTTP GET]	2025-10-03 12:55:51.775+00	2025-10-03 12:55:51.775+00	1
323	down	10011	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 02:27:25.094+00	2025-10-04 02:27:25.094+00	1
324	down	11240	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 02:28:26.322+00	2025-10-04 02:28:26.322+00	1
325	down	10169	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 02:29:25.252+00	2025-10-04 02:29:25.252+00	1
326	down	10968	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 02:30:26.052+00	2025-10-04 02:30:26.052+00	1
327	down	11768	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 02:31:26.853+00	2025-10-04 02:31:26.853+00	1
328	down	10414	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 02:32:25.499+00	2025-10-04 02:32:25.499+00	1
329	down	11206	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 02:33:26.291+00	2025-10-04 02:33:26.291+00	1
330	down	10193	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 02:34:25.279+00	2025-10-04 02:34:25.279+00	1
331	down	10405	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 02:35:25.492+00	2025-10-04 02:35:25.492+00	1
332	down	9288	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 02:36:24.376+00	2025-10-04 02:36:24.376+00	1
333	down	11286	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 02:37:26.374+00	2025-10-04 02:37:26.374+00	1
334	down	11177	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 02:38:26.266+00	2025-10-04 02:38:26.266+00	1
335	down	9845	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 02:39:24.934+00	2025-10-04 02:39:24.934+00	1
336	down	9974	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 02:40:25.065+00	2025-10-04 02:40:25.065+00	1
337	down	11627	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 02:41:26.72+00	2025-10-04 02:41:26.72+00	1
338	down	11037	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 02:42:26.132+00	2025-10-04 02:42:26.132+00	1
339	down	9491	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 02:43:24.588+00	2025-10-04 02:43:24.588+00	1
340	down	11222	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 02:44:26.319+00	2025-10-04 02:44:26.319+00	1
341	down	11036	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 02:45:26.134+00	2025-10-04 02:45:26.134+00	1
342	down	9755	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 02:46:24.852+00	2025-10-04 02:46:24.852+00	1
343	down	9622	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 02:47:24.721+00	2025-10-04 02:47:24.721+00	1
344	down	11940	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 02:48:27.039+00	2025-10-04 02:48:27.039+00	1
345	down	12125	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 02:49:27.225+00	2025-10-04 02:49:27.225+00	1
346	down	11671	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 02:50:26.773+00	2025-10-04 02:50:26.773+00	1
347	down	10365	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 02:51:25.466+00	2025-10-04 02:51:25.466+00	1
348	down	10233	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 02:52:25.335+00	2025-10-04 02:52:25.335+00	1
349	down	9244	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 02:53:24.347+00	2025-10-04 02:53:24.347+00	1
350	down	10948	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 02:54:26.054+00	2025-10-04 02:54:26.054+00	1
351	down	9933	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 02:55:25.041+00	2025-10-04 02:55:25.041+00	1
352	down	9878	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 02:56:24.987+00	2025-10-04 02:56:24.987+00	1
353	down	9610	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 02:57:24.721+00	2025-10-04 02:57:24.721+00	1
354	down	11929	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 02:58:27.042+00	2025-10-04 02:58:27.042+00	1
355	down	11578	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 02:59:26.691+00	2025-10-04 02:59:26.691+00	1
356	down	10533	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 03:00:25.652+00	2025-10-04 03:00:25.652+00	1
357	down	10693	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 03:01:25.812+00	2025-10-04 03:01:25.812+00	1
358	down	20080	\N	HTTP failed and PING fallback also failed: Request timeout [PING (fallback)]	2025-10-04 03:02:35.2+00	2025-10-04 03:02:35.2+00	1
359	down	20078	\N	HTTP failed and PING fallback also failed: Request timeout [PING (fallback)]	2025-10-04 03:03:35.2+00	2025-10-04 03:03:35.2+00	1
360	down	20090	\N	HTTP failed and PING fallback also failed: Request timeout [PING (fallback)]	2025-10-04 03:04:35.212+00	2025-10-04 03:04:35.212+00	1
361	down	20116	\N	HTTP failed and PING fallback also failed: Request timeout [PING (fallback)]	2025-10-04 03:05:35.239+00	2025-10-04 03:05:35.239+00	1
362	down	20078	\N	HTTP failed and PING fallback also failed: Request timeout [PING (fallback)]	2025-10-04 03:06:35.205+00	2025-10-04 03:06:35.205+00	1
363	down	20089	\N	HTTP failed and PING fallback also failed: Request timeout [PING (fallback)]	2025-10-04 03:07:35.218+00	2025-10-04 03:07:35.218+00	1
364	down	20082	\N	HTTP failed and PING fallback also failed: Request timeout [PING (fallback)]	2025-10-04 03:08:35.213+00	2025-10-04 03:08:35.213+00	1
365	down	20048	\N	HTTP failed and PING fallback also failed: Request timeout [PING (fallback)]	2025-10-04 03:09:35.182+00	2025-10-04 03:09:35.182+00	1
366	down	10864	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 03:10:26.001+00	2025-10-04 03:10:26.001+00	1
367	down	9534	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 03:11:24.671+00	2025-10-04 03:11:24.671+00	1
368	down	12167	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 03:12:27.307+00	2025-10-04 03:12:27.307+00	1
369	down	12218	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 03:13:27.36+00	2025-10-04 03:13:27.36+00	1
370	down	10914	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 03:14:26.058+00	2025-10-04 03:14:26.058+00	1
371	down	11098	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 03:15:26.241+00	2025-10-04 03:15:26.241+00	1
372	down	10400	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 03:16:25.546+00	2025-10-04 03:16:25.546+00	1
373	down	9362	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 03:17:24.509+00	2025-10-04 03:17:24.509+00	1
374	down	11654	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 03:18:26.801+00	2025-10-04 03:18:26.801+00	1
375	down	11808	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 03:19:26.958+00	2025-10-04 03:19:26.958+00	1
376	down	10664	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 03:20:25.814+00	2025-10-04 03:20:25.814+00	1
377	down	10293	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 03:21:25.444+00	2025-10-04 03:21:25.444+00	1
378	down	9808	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 03:22:24.959+00	2025-10-04 03:22:24.959+00	1
379	down	12105	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 03:23:27.257+00	2025-10-04 03:23:27.257+00	1
380	down	9244	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 03:24:24.399+00	2025-10-04 03:24:24.399+00	1
381	down	11537	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 03:25:26.692+00	2025-10-04 03:25:26.692+00	1
382	down	10497	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 03:26:25.653+00	2025-10-04 03:26:25.653+00	1
383	down	10229	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 03:27:25.387+00	2025-10-04 03:27:25.387+00	1
384	down	12172	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 03:28:27.332+00	2025-10-04 03:28:27.332+00	1
385	up	1061	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 03:29:16.222+00	2025-10-04 03:29:16.222+00	1
386	up	1350	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 03:30:16.514+00	2025-10-04 03:30:16.514+00	1
387	up	1024	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 03:31:16.189+00	2025-10-04 03:31:16.189+00	1
388	up	1080	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 03:32:16.248+00	2025-10-04 03:32:16.248+00	1
389	up	1023	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 03:33:16.193+00	2025-10-04 03:33:16.193+00	1
390	up	1000	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 03:34:15.836+00	2025-10-04 03:34:15.836+00	1
391	up	1072	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 03:35:15.908+00	2025-10-04 03:35:15.908+00	1
392	up	1119	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 03:36:15.959+00	2025-10-04 03:36:15.959+00	1
393	up	1037	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 03:37:15.878+00	2025-10-04 03:37:15.878+00	1
394	up	1114	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 03:38:15.956+00	2025-10-04 03:38:15.956+00	1
395	up	1176	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 03:39:16.02+00	2025-10-04 03:39:16.02+00	1
396	up	1281	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 03:40:16.127+00	2025-10-04 03:40:16.127+00	1
397	up	2168	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 03:41:17.014+00	2025-10-04 03:41:17.014+00	1
398	up	6034	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 03:42:20.881+00	2025-10-04 03:42:20.881+00	1
399	up	1026	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 03:43:15.875+00	2025-10-04 03:43:15.875+00	1
400	up	1288	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 03:44:16.137+00	2025-10-04 03:44:16.137+00	1
401	up	986	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 03:45:15.835+00	2025-10-04 03:45:15.835+00	1
402	up	1056	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 03:46:15.906+00	2025-10-04 03:46:15.906+00	1
403	up	1182	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 03:47:16.038+00	2025-10-04 03:47:16.038+00	1
404	up	1085	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 03:48:15.941+00	2025-10-04 03:48:15.941+00	1
405	up	1251	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 03:49:16.108+00	2025-10-04 03:49:16.108+00	1
406	up	1173	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 03:50:16.035+00	2025-10-04 03:50:16.035+00	1
407	up	1182	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 03:51:16.045+00	2025-10-04 03:51:16.045+00	1
408	up	1128	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 03:52:15.993+00	2025-10-04 03:52:15.993+00	1
409	up	1275	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 03:53:16.14+00	2025-10-04 03:53:16.14+00	1
410	up	6671	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 03:54:21.536+00	2025-10-04 03:54:21.536+00	1
411	up	2011	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 03:55:16.877+00	2025-10-04 03:55:16.877+00	1
412	up	1530	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 03:56:16.398+00	2025-10-04 03:56:16.398+00	1
413	up	1145	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 03:57:16.014+00	2025-10-04 03:57:16.014+00	1
414	up	1068	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 03:58:15.939+00	2025-10-04 03:58:15.939+00	1
415	up	6468	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 03:59:21.342+00	2025-10-04 03:59:21.342+00	1
416	up	1211	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 04:00:16.085+00	2025-10-04 04:00:16.085+00	1
417	up	1087	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 04:01:15.964+00	2025-10-04 04:01:15.964+00	1
418	up	1507	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 04:02:16.384+00	2025-10-04 04:02:16.384+00	1
419	up	1049	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 04:03:15.928+00	2025-10-04 04:03:15.928+00	1
420	up	1885	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 04:04:16.765+00	2025-10-04 04:04:16.765+00	1
421	up	6123	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 04:05:21.002+00	2025-10-04 04:05:21.002+00	1
422	up	1607	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 04:06:16.486+00	2025-10-04 04:06:16.486+00	1
423	up	1231	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 04:07:16.113+00	2025-10-04 04:07:16.113+00	1
424	up	1250	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 04:08:16.135+00	2025-10-04 04:08:16.135+00	1
425	up	2005	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 04:09:16.891+00	2025-10-04 04:09:16.891+00	1
426	up	1632	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 04:10:16.519+00	2025-10-04 04:10:16.519+00	1
427	up	1866	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 04:11:16.516+00	2025-10-04 04:11:16.516+00	1
428	up	1216	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 04:12:15.874+00	2025-10-04 04:12:15.874+00	1
429	up	2774	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 04:13:17.432+00	2025-10-04 04:13:17.432+00	1
430	up	1353	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 04:14:16.012+00	2025-10-04 04:14:16.012+00	1
431	up	1236	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 04:15:15.897+00	2025-10-04 04:15:15.897+00	1
432	up	1215	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 04:16:15.876+00	2025-10-04 04:16:15.876+00	1
433	up	1579	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 04:17:16.24+00	2025-10-04 04:17:16.24+00	1
434	up	1211	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 04:18:15.873+00	2025-10-04 04:18:15.873+00	1
435	up	1290	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 04:19:15.954+00	2025-10-04 04:19:15.954+00	1
436	up	1559	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 04:20:16.224+00	2025-10-04 04:20:16.224+00	1
437	up	1287	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 04:21:15.953+00	2025-10-04 04:21:15.953+00	1
438	up	1289	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 04:22:15.956+00	2025-10-04 04:22:15.956+00	1
439	up	1292	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 04:23:15.96+00	2025-10-04 04:23:15.96+00	1
440	up	1301	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 04:24:15.969+00	2025-10-04 04:24:15.969+00	1
441	up	3565	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 04:25:22.268+00	2025-10-04 04:25:22.268+00	1
442	down	1317	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-04 04:38:19.577+00	2025-10-04 04:38:19.577+00	1
443	up	7440	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:01:27.107+00	2025-10-04 05:01:27.107+00	1
444	up	1485	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:02:21.152+00	2025-10-04 05:02:21.152+00	1
445	up	1817	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:03:21.485+00	2025-10-04 05:03:21.485+00	1
446	up	7521	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:04:27.192+00	2025-10-04 05:04:27.192+00	1
447	up	6871	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:05:26.546+00	2025-10-04 05:05:26.546+00	1
448	up	1342	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:06:21.019+00	2025-10-04 05:06:21.019+00	1
449	up	2088	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:07:21.765+00	2025-10-04 05:07:21.765+00	1
450	up	1825	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:08:21.505+00	2025-10-04 05:08:21.505+00	1
451	up	2935	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:09:22.615+00	2025-10-04 05:09:22.615+00	1
452	up	1655	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:10:21.339+00	2025-10-04 05:10:21.339+00	1
453	up	1391	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:11:21.078+00	2025-10-04 05:11:21.078+00	1
454	up	1541	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:12:21.227+00	2025-10-04 05:12:21.227+00	1
455	up	1537	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:13:21.226+00	2025-10-04 05:13:21.226+00	1
456	up	1956	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:14:21.647+00	2025-10-04 05:14:21.647+00	1
457	up	1867	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:15:21.559+00	2025-10-04 05:15:21.559+00	1
458	up	1357	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:16:21.05+00	2025-10-04 05:16:21.05+00	1
459	up	1549	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:17:21.245+00	2025-10-04 05:17:21.245+00	1
460	up	1498	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:18:21.196+00	2025-10-04 05:18:21.196+00	1
461	up	1447	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:19:21.146+00	2025-10-04 05:19:21.146+00	1
462	up	6569	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:20:26.272+00	2025-10-04 05:20:26.272+00	1
463	up	6292	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:21:25.997+00	2025-10-04 05:21:25.997+00	1
464	up	1806	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:22:21.512+00	2025-10-04 05:22:21.512+00	1
465	up	1649	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:23:21.356+00	2025-10-04 05:23:21.356+00	1
466	up	1788	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:24:21.498+00	2025-10-04 05:24:21.498+00	1
467	up	1846	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:25:21.555+00	2025-10-04 05:25:21.555+00	1
468	up	1638	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:26:21.35+00	2025-10-04 05:26:21.35+00	1
469	up	1693	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:27:21.406+00	2025-10-04 05:27:21.406+00	1
470	up	1976	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:28:21.691+00	2025-10-04 05:28:21.691+00	1
471	up	1620	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:29:21.336+00	2025-10-04 05:29:21.336+00	1
472	up	1746	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:30:21.463+00	2025-10-04 05:30:21.463+00	1
473	up	2277	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:31:21.999+00	2025-10-04 05:31:21.999+00	1
474	up	2342	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:32:22.075+00	2025-10-04 05:32:22.075+00	1
475	up	2176	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:33:21.913+00	2025-10-04 05:33:21.913+00	1
476	up	6916	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:34:26.657+00	2025-10-04 05:34:26.657+00	1
477	up	1526	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:35:21.275+00	2025-10-04 05:35:21.275+00	1
478	up	6330	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:36:26.085+00	2025-10-04 05:36:26.085+00	1
479	up	1430	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:37:21.186+00	2025-10-04 05:37:21.186+00	1
480	up	1556	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:38:21.314+00	2025-10-04 05:38:21.314+00	1
481	up	1977	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:39:21.736+00	2025-10-04 05:39:21.736+00	1
482	up	1824	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:40:21.586+00	2025-10-04 05:40:21.586+00	1
483	up	7386	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:41:27.147+00	2025-10-04 05:41:27.147+00	1
484	up	1821	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:42:21.584+00	2025-10-04 05:42:21.584+00	1
485	up	2109	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:43:21.874+00	2025-10-04 05:43:21.874+00	1
486	up	3063	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:44:22.832+00	2025-10-04 05:44:22.832+00	1
487	up	2044	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:45:21.815+00	2025-10-04 05:45:21.815+00	1
488	up	2961	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:46:22.732+00	2025-10-04 05:46:22.732+00	1
489	up	2023	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:47:21.796+00	2025-10-04 05:47:21.796+00	1
490	up	6813	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:48:26.586+00	2025-10-04 05:48:26.586+00	1
491	up	1642	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:49:21.417+00	2025-10-04 05:49:21.417+00	1
492	up	1832	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:50:21.609+00	2025-10-04 05:50:21.609+00	1
493	up	2726	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:51:22.504+00	2025-10-04 05:51:22.504+00	1
494	up	1774	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:52:21.556+00	2025-10-04 05:52:21.556+00	1
495	up	2334	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:53:22.116+00	2025-10-04 05:53:22.116+00	1
496	up	1552	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:54:21.336+00	2025-10-04 05:54:21.336+00	1
497	up	7999	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:55:27.788+00	2025-10-04 05:55:27.788+00	1
498	up	1811	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:56:21.603+00	2025-10-04 05:56:21.603+00	1
499	up	4158	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:57:23.951+00	2025-10-04 05:57:23.951+00	1
500	up	1675	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:58:21.472+00	2025-10-04 05:58:21.472+00	1
501	up	2419	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 05:59:22.225+00	2025-10-04 05:59:22.225+00	1
502	up	7348	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:00:27.155+00	2025-10-04 06:00:27.155+00	1
503	up	3050	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:01:22.857+00	2025-10-04 06:01:22.857+00	1
504	up	8694	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:02:28.501+00	2025-10-04 06:02:28.501+00	1
505	up	7717	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:03:27.528+00	2025-10-04 06:03:27.528+00	1
506	up	2170	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:04:21.984+00	2025-10-04 06:04:21.984+00	1
507	up	1796	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:05:21.612+00	2025-10-04 06:05:21.612+00	1
508	up	1632	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:06:21.448+00	2025-10-04 06:06:21.448+00	1
509	up	2263	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:07:22.081+00	2025-10-04 06:07:22.081+00	1
510	up	1738	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:08:21.557+00	2025-10-04 06:08:21.557+00	1
511	up	2311	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:09:22.132+00	2025-10-04 06:09:22.132+00	1
512	up	2405	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:10:22.229+00	2025-10-04 06:10:22.229+00	1
513	up	1284	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:11:21.108+00	2025-10-04 06:11:21.108+00	1
514	up	1458	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:12:21.289+00	2025-10-04 06:12:21.289+00	1
515	up	1756	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:13:21.587+00	2025-10-04 06:13:21.587+00	1
516	up	2805	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:14:22.637+00	2025-10-04 06:14:22.637+00	1
517	up	1922	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:15:21.757+00	2025-10-04 06:15:21.757+00	1
518	up	7532	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:16:27.368+00	2025-10-04 06:16:27.368+00	1
519	up	2077	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:17:21.929+00	2025-10-04 06:17:21.929+00	1
520	up	2521	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:18:22.375+00	2025-10-04 06:18:22.375+00	1
521	up	1462	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:19:21.316+00	2025-10-04 06:19:21.316+00	1
522	up	1397	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:20:21.253+00	2025-10-04 06:20:21.253+00	1
523	up	1874	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:21:21.732+00	2025-10-04 06:21:21.732+00	1
524	up	1693	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:22:21.552+00	2025-10-04 06:22:21.552+00	1
525	up	1455	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:23:21.316+00	2025-10-04 06:23:21.316+00	1
526	up	1415	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:24:21.277+00	2025-10-04 06:24:21.277+00	1
527	up	1378	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:25:21.241+00	2025-10-04 06:25:21.241+00	1
528	up	1781	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:26:21.645+00	2025-10-04 06:26:21.645+00	1
529	up	1364	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:27:21.23+00	2025-10-04 06:27:21.23+00	1
530	up	1895	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:28:21.763+00	2025-10-04 06:28:21.763+00	1
531	up	2438	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:29:22.306+00	2025-10-04 06:29:22.306+00	1
532	up	1526	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:30:21.396+00	2025-10-04 06:30:21.396+00	1
533	up	1561	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:31:21.431+00	2025-10-04 06:31:21.431+00	1
534	up	1513	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:32:21.384+00	2025-10-04 06:32:21.384+00	1
535	up	1684	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:33:21.556+00	2025-10-04 06:33:21.556+00	1
536	up	1619	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:34:21.491+00	2025-10-04 06:34:21.491+00	1
537	up	1804	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:35:21.678+00	2025-10-04 06:35:21.678+00	1
538	up	1311	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:36:21.186+00	2025-10-04 06:36:21.186+00	1
539	up	3103	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:37:22.978+00	2025-10-04 06:37:22.978+00	1
540	up	1385	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:38:21.263+00	2025-10-04 06:38:21.263+00	1
541	up	1392	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:39:21.271+00	2025-10-04 06:39:21.271+00	1
542	up	1458	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:40:21.338+00	2025-10-04 06:40:21.338+00	1
543	up	1698	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:41:21.584+00	2025-10-04 06:41:21.584+00	1
544	up	1269	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:42:21.157+00	2025-10-04 06:42:21.157+00	1
545	up	2874	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:43:22.763+00	2025-10-04 06:43:22.763+00	1
546	up	1992	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:44:21.885+00	2025-10-04 06:44:21.885+00	1
547	up	1378	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:45:21.27+00	2025-10-04 06:45:21.27+00	1
548	up	2011	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:46:21.904+00	2025-10-04 06:46:21.904+00	1
549	up	1764	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:47:21.659+00	2025-10-04 06:47:21.659+00	1
550	up	1502	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:48:21.398+00	2025-10-04 06:48:21.398+00	1
551	up	2319	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:49:22.22+00	2025-10-04 06:49:22.22+00	1
552	up	1323	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:50:21.227+00	2025-10-04 06:50:21.227+00	1
553	up	1286	200	Website is up (HTTP 200) [HTTP GET]	2025-10-04 06:51:21.19+00	2025-10-04 06:51:21.19+00	1
554	down	20391	\N	HTTP failed and PING fallback also failed: Request timeout [PING (fallback)]	2025-10-05 07:26:40.303+00	2025-10-05 07:26:40.303+00	1
555	down	22792	\N	HTTP failed and PING fallback also failed: Request timeout [PING (fallback)]	2025-10-05 07:27:42.977+00	2025-10-05 07:27:42.977+00	1
556	down	20155	\N	HTTP failed and PING fallback also failed: Request timeout [PING (fallback)]	2025-10-05 07:28:40.315+00	2025-10-05 07:28:40.315+00	1
557	up	10395	200	Website is up (PING fallback successful) [PING (fallback)]	2025-10-05 07:28:43.81+00	2025-10-05 07:28:43.81+00	1
558	up	2935	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 07:29:23.212+00	2025-10-05 07:29:23.212+00	1
559	up	968	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 07:30:21.246+00	2025-10-05 07:30:21.246+00	1
560	up	1845	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 07:31:22.123+00	2025-10-05 07:31:22.123+00	1
561	up	1200	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 07:32:21.571+00	2025-10-05 07:32:21.571+00	1
562	down	10121	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "http://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-05 07:32:59.577+00	2025-10-05 07:32:59.577+00	3
563	down	10050	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "http://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-05 07:33:03.54+00	2025-10-05 07:33:03.54+00	3
564	up	1272	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 07:33:21.644+00	2025-10-05 07:33:21.644+00	1
565	down	10022	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "http://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-05 07:33:59.176+00	2025-10-05 07:33:59.176+00	3
566	down	10034	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "http://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-05 07:33:59.472+00	2025-10-05 07:33:59.472+00	3
567	up	1204	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 07:34:21.579+00	2025-10-05 07:34:21.579+00	1
568	down	10090	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "http://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-05 07:34:59.526+00	2025-10-05 07:34:59.526+00	3
569	up	1205	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 07:35:21.588+00	2025-10-05 07:35:21.588+00	1
570	down	10105	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "http://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-05 07:35:59.793+00	2025-10-05 07:35:59.793+00	3
571	up	2016	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 07:36:22.473+00	2025-10-05 07:36:22.473+00	1
572	down	10091	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "http://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-05 07:36:59.967+00	2025-10-05 07:36:59.967+00	3
573	up	913	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 07:37:21.373+00	2025-10-05 07:37:21.373+00	1
574	up	611	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 07:37:26.678+00	2025-10-05 07:37:26.678+00	4
575	up	350	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 07:37:47.162+00	2025-10-05 07:37:47.162+00	4
576	down	10073	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "http://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-05 07:37:59.72+00	2025-10-05 07:37:59.72+00	3
577	down	10042	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "http://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-05 07:38:09.288+00	2025-10-05 07:38:09.288+00	3
578	up	1144	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 07:38:21.608+00	2025-10-05 07:38:21.608+00	1
579	up	313	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 07:38:47.146+00	2025-10-05 07:38:47.146+00	4
580	down	10043	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "http://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-05 07:39:09.743+00	2025-10-05 07:39:09.743+00	3
581	up	997	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 07:39:21.475+00	2025-10-05 07:39:21.475+00	1
582	up	371	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 07:39:47.265+00	2025-10-05 07:39:47.265+00	4
583	down	10131	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "http://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-05 07:40:09.893+00	2025-10-05 07:40:09.893+00	3
584	up	968	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 07:40:21.448+00	2025-10-05 07:40:21.448+00	1
585	up	208	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 07:40:47.038+00	2025-10-05 07:40:47.038+00	4
586	down	10058	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "http://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-05 07:41:09.805+00	2025-10-05 07:41:09.805+00	3
587	down	10060	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "http://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-05 07:41:15.699+00	2025-10-05 07:41:15.699+00	3
588	up	907	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 07:41:21.387+00	2025-10-05 07:41:21.387+00	1
589	up	313	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 07:41:47.147+00	2025-10-05 07:41:47.147+00	4
590	down	10070	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "http://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-05 07:42:09.831+00	2025-10-05 07:42:09.831+00	3
591	up	4006	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 07:42:24.493+00	2025-10-05 07:42:24.493+00	1
592	up	655	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 07:42:47.593+00	2025-10-05 07:42:47.593+00	4
593	down	10239	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "http://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-05 07:43:10.109+00	2025-10-05 07:43:10.109+00	3
594	up	1155	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 07:43:21.643+00	2025-10-05 07:43:21.643+00	1
595	up	371	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 07:43:47.254+00	2025-10-05 07:43:47.254+00	4
596	down	10062	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "http://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-05 07:44:09.813+00	2025-10-05 07:44:09.813+00	3
597	up	862	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 07:44:21.35+00	2025-10-05 07:44:21.35+00	1
598	up	234	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 07:44:47.083+00	2025-10-05 07:44:47.083+00	4
599	down	10033	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "http://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-05 07:45:09.773+00	2025-10-05 07:45:09.773+00	3
600	up	958	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 07:45:21.45+00	2025-10-05 07:45:21.45+00	1
601	up	319	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 07:45:47.15+00	2025-10-05 07:45:47.15+00	4
602	down	10061	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "http://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-05 07:46:09.828+00	2025-10-05 07:46:09.828+00	3
603	up	1468	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 07:46:21.961+00	2025-10-05 07:46:21.961+00	1
604	up	313	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 07:46:47.19+00	2025-10-05 07:46:47.19+00	4
605	down	10045	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "http://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-05 07:47:09.776+00	2025-10-05 07:47:09.776+00	3
606	up	1377	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 07:47:21.87+00	2025-10-05 07:47:21.87+00	1
607	up	785	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 07:47:47.694+00	2025-10-05 07:47:47.694+00	4
608	down	10039	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "http://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-05 07:48:09.79+00	2025-10-05 07:48:09.79+00	3
609	up	316	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 07:48:11.839+00	2025-10-05 07:48:11.839+00	3
610	up	258	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 07:48:14.496+00	2025-10-05 07:48:14.496+00	3
611	up	822	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 07:48:21.316+00	2025-10-05 07:48:21.316+00	1
612	up	318	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 07:48:47.211+00	2025-10-05 07:48:47.211+00	4
613	up	173	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 07:49:11.716+00	2025-10-05 07:49:11.716+00	3
614	up	4692	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 07:49:25.189+00	2025-10-05 07:49:25.189+00	1
615	up	5526	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 07:49:52.412+00	2025-10-05 07:49:52.412+00	4
616	up	280	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 07:50:11.831+00	2025-10-05 07:50:11.831+00	3
617	up	1051	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 07:50:21.55+00	2025-10-05 07:50:21.55+00	1
618	up	229	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 07:50:47.088+00	2025-10-05 07:50:47.088+00	4
619	up	303	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 07:51:11.864+00	2025-10-05 07:51:11.864+00	3
620	up	979	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 07:51:21.481+00	2025-10-05 07:51:21.481+00	1
621	up	336	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 07:51:47.187+00	2025-10-05 07:51:47.187+00	4
622	up	165	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 07:52:11.706+00	2025-10-05 07:52:11.706+00	3
623	up	1074	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 07:52:21.576+00	2025-10-05 07:52:21.576+00	1
624	up	284	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 07:52:47.162+00	2025-10-05 07:52:47.162+00	4
625	up	284	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 07:53:11.832+00	2025-10-05 07:53:11.832+00	3
626	up	808	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 07:53:21.312+00	2025-10-05 07:53:21.312+00	1
627	up	308	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 07:53:47.141+00	2025-10-05 07:53:47.141+00	4
628	up	237	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 07:54:11.779+00	2025-10-05 07:54:11.779+00	3
629	up	241	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 07:54:11.896+00	2025-10-05 07:54:11.896+00	5
630	up	1064	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 07:54:21.587+00	2025-10-05 07:54:21.587+00	1
631	up	405	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 07:54:47.295+00	2025-10-05 07:54:47.295+00	4
632	up	182	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 07:55:11.771+00	2025-10-05 07:55:11.771+00	3
633	up	157	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 07:55:11.792+00	2025-10-05 07:55:11.792+00	5
634	up	844	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 07:55:21.372+00	2025-10-05 07:55:21.372+00	1
635	up	368	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 07:55:47.24+00	2025-10-05 07:55:47.24+00	4
636	up	356	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 07:56:02.588+00	2025-10-05 07:56:02.588+00	6
637	up	407	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 07:56:11.983+00	2025-10-05 07:56:11.983+00	3
638	up	379	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 07:56:12.008+00	2025-10-05 07:56:12.008+00	5
639	up	1123	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 07:56:21.651+00	2025-10-05 07:56:21.651+00	1
640	up	373	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 07:56:47.257+00	2025-10-05 07:56:47.257+00	4
641	up	263	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 07:56:52.9+00	2025-10-05 07:56:52.9+00	7
642	up	235	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 07:57:02.442+00	2025-10-05 07:57:02.442+00	6
643	up	398	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 07:57:11.988+00	2025-10-05 07:57:11.988+00	3
644	up	417	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 07:57:12.065+00	2025-10-05 07:57:12.065+00	5
645	up	1019	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 07:57:21.549+00	2025-10-05 07:57:21.549+00	1
646	up	710	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 07:57:47.83+00	2025-10-05 07:57:47.83+00	4
647	down	265	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n [CURL GET]	2025-10-05 07:57:54.449+00	2025-10-05 07:57:54.449+00	7
648	up	426	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 07:58:12.077+00	2025-10-05 07:58:12.077+00	5
649	down	10138	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n [CURL GET]	2025-10-05 07:58:12.371+00	2025-10-05 07:58:12.371+00	6
650	up	937	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 07:58:21.467+00	2025-10-05 07:58:21.467+00	1
651	down	10093	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-05 07:58:21.691+00	2025-10-05 07:58:21.691+00	3
652	up	276	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 07:58:47.208+00	2025-10-05 07:58:47.208+00	4
653	down	10127	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n [CURL GET]	2025-10-05 07:59:02.774+00	2025-10-05 07:59:02.774+00	7
654	up	523	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 07:59:12.171+00	2025-10-05 07:59:12.171+00	5
655	down	10073	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n [CURL GET]	2025-10-05 07:59:12.295+00	2025-10-05 07:59:12.295+00	6
656	down	10048	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-05 07:59:21.662+00	2025-10-05 07:59:21.662+00	3
657	up	1371	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 07:59:21.904+00	2025-10-05 07:59:21.904+00	1
658	up	579	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 07:59:47.5+00	2025-10-05 07:59:47.5+00	4
659	up	301	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 07:59:52.948+00	2025-10-05 07:59:52.948+00	7
660	up	208	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:00:02.43+00	2025-10-05 08:00:02.43+00	6
661	up	239	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:00:11.837+00	2025-10-05 08:00:11.837+00	3
662	up	257	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:00:11.902+00	2025-10-05 08:00:11.902+00	5
663	up	1145	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:00:21.676+00	2025-10-05 08:00:21.676+00	1
664	up	561	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:00:47.448+00	2025-10-05 08:00:47.448+00	4
665	up	292	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:00:52.937+00	2025-10-05 08:00:52.937+00	7
666	up	285	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:01:02.502+00	2025-10-05 08:01:02.502+00	6
667	up	267	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:01:11.865+00	2025-10-05 08:01:11.865+00	3
668	up	262	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:01:11.919+00	2025-10-05 08:01:11.919+00	5
669	up	856	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:01:21.388+00	2025-10-05 08:01:21.388+00	1
670	up	404	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:01:47.29+00	2025-10-05 08:01:47.29+00	4
671	up	362	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:01:53.007+00	2025-10-05 08:01:53.007+00	7
672	up	204	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:02:02.434+00	2025-10-05 08:02:02.434+00	6
673	up	222	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:02:11.827+00	2025-10-05 08:02:11.827+00	3
674	up	225	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:02:11.889+00	2025-10-05 08:02:11.889+00	5
675	up	2325	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:02:22.857+00	2025-10-05 08:02:22.857+00	1
676	up	320	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:02:47.231+00	2025-10-05 08:02:47.231+00	4
677	up	502	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:02:53.187+00	2025-10-05 08:02:53.187+00	7
678	up	829	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:03:03.117+00	2025-10-05 08:03:03.117+00	6
679	up	352	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:03:11.955+00	2025-10-05 08:03:11.955+00	3
680	up	496	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:03:12.163+00	2025-10-05 08:03:12.163+00	5
681	up	798	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:03:21.331+00	2025-10-05 08:03:21.331+00	1
682	up	364	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:03:47.284+00	2025-10-05 08:03:47.284+00	4
683	up	576	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:03:53.227+00	2025-10-05 08:03:53.227+00	7
684	up	329	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:04:02.578+00	2025-10-05 08:04:02.578+00	6
685	up	249	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:04:11.85+00	2025-10-05 08:04:11.85+00	3
686	up	350	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:04:12.028+00	2025-10-05 08:04:12.028+00	5
687	up	925	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:04:21.479+00	2025-10-05 08:04:21.479+00	1
688	down	12190	\N	Custom CURL failed: Command failed: curl 'https://nagaderp.mynagad.com:7070/Security/User/SignInWithMenus' -H 'Accept: application/json, text/plain, */*' -H 'Accept-Language: en-US,en;q=0.9' -H 'Authorization: Bearer null' -H 'Connection: keep-alive' -H 'Content-Type: application/json;charset=UTF-8' -H 'Origin: https://nagaderp.mynagad.com:9090' -H 'Referer: https://nagaderp.mynagad.com:9090/' -H 'Sec-Fetch-Dest: empty' -H 'Sec-Fetch-Mode: cors' -H 'Sec-Fetch-Site: same-site' -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36' -H 'X-Requested-With: XMLHttpRequest' -H 'sec-ch-ua: "Chromium";v="140", "Not=A?Brand";v="24", "Google Chrome";v="140"' -H 'sec-ch-ua-mobile: ?0' -H 'sec-ch-ua-platform: "Windows"' --data-raw '{"UserName":"241075","Password":"Someonehere00@"}' -w "%{http_code}" -o /dev/null\n  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current\n                                 Dload  Upload   Total   Spent    Left  Speed\n\r  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0\r  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0\r  0     0    0     0    0     0      0      0 --:--:--  0:00:01 --:--:--     0\r  0     0    0     0    0     0      0      0 --:--:--  0:00:02 --:--:--     0\r  0     0    0     0    0     0      0      0 --:--:--  0:00:03 --:--:--     0\r  0     0    0     0    0     0      0      0 --:--:--  0:00:04 --:--:--     0\r  0     0    0     0    0     0      0      0 --:--:--  0:00:05 --:--:--     0\r  0     0    0     0    0     0      0      0 --:--:--  0:00:06 --:--:--     0\r  0     0    0     0    0     0      0      0 --:--:--  0:00:07 --:--:--     0\r  0     0    0     0    0     0      0      0 --:--:--  0:00:08 --:--:--     0\r  0     0    0     0    0     0      0      0 --:--:--  0:00:09 --:--:--     0\r  0     0    0     0    0     0      0      0 --:--:--  0:00:10 --:--:--     0\r  0     0    0     0    0     0      0      0 --:--:--  0:00:11 --:--:--     0curl: (6) Could not resolve host: nagaderp.mynagad.com\n [CUSTOM CURL]	2025-10-05 08:04:59.288+00	2025-10-05 08:04:59.288+00	4
689	down	9669	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n [CURL GET]	2025-10-05 08:05:02.34+00	2025-10-05 08:05:02.34+00	7
690	down	10553	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n [CURL GET]	2025-10-05 08:05:12.823+00	2025-10-05 08:05:12.823+00	6
691	down	2752	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-05 08:05:14.414+00	2025-10-05 08:05:14.414+00	3
692	down	10173	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://channel.mynagad.com:20010/"\n [CURL GET]	2025-10-05 08:05:21.92+00	2025-10-05 08:05:21.92+00	5
693	down	21272	\N	HTTP failed and PING fallback also failed: Request timeout [PING (fallback)]	2025-10-05 08:05:41.828+00	2025-10-05 08:05:41.828+00	1
694	down	10145	\N	Custom CURL failed: Command failed: curl 'https://nagaderp.mynagad.com:7070/Security/User/SignInWithMenus' -H 'Accept: application/json, text/plain, */*' -H 'Accept-Language: en-US,en;q=0.9' -H 'Authorization: Bearer null' -H 'Connection: keep-alive' -H 'Content-Type: application/json;charset=UTF-8' -H 'Origin: https://nagaderp.mynagad.com:9090' -H 'Referer: https://nagaderp.mynagad.com:9090/' -H 'Sec-Fetch-Dest: empty' -H 'Sec-Fetch-Mode: cors' -H 'Sec-Fetch-Site: same-site' -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36' -H 'X-Requested-With: XMLHttpRequest' -H 'sec-ch-ua: "Chromium";v="140", "Not=A?Brand";v="24", "Google Chrome";v="140"' -H 'sec-ch-ua-mobile: ?0' -H 'sec-ch-ua-platform: "Windows"' --data-raw '{"UserName":"241075","Password":"Someonehere00@"}' -w "%{http_code}" -o /dev/null\n  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current\n                                 Dload  Upload   Total   Spent    Left  Speed\n\r  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0\r  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0\r  0     0    0     0    0     0      0      0 --:--:--  0:00:01 --:--:--     0\r  0     0    0     0    0     0      0      0 --:--:--  0:00:02 --:--:--     0\r  0     0    0     0    0     0      0      0 --:--:--  0:00:03 --:--:--     0\r  0     0    0     0    0     0      0      0 --:--:--  0:00:04 --:--:--     0\r  0     0    0     0    0     0      0      0 --:--:--  0:00:05 --:--:--     0\r  0     0    0     0    0     0      0      0 --:--:--  0:00:06 --:--:--     0\r  0     0    0     0    0     0      0      0 --:--:--  0:00:07 --:--:--     0\r  0     0    0     0    0     0      0      0 --:--:--  0:00:08 --:--:--     0\r  0     0    0     0    0     0      0      0 --:--:--  0:00:09 --:--:--     0curl: (6) Could not resolve host: nagaderp.mynagad.com\n [CUSTOM CURL]	2025-10-05 08:05:57.036+00	2025-10-05 08:05:57.036+00	4
695	down	10032	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n [CURL GET]	2025-10-05 08:06:02.7+00	2025-10-05 08:06:02.7+00	7
696	down	37	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-05 08:06:11.641+00	2025-10-05 08:06:11.641+00	3
697	down	33	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://channel.mynagad.com:20010/"\n [CURL GET]	2025-10-05 08:06:11.769+00	2025-10-05 08:06:11.769+00	5
698	down	10039	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n [CURL GET]	2025-10-05 08:06:12.293+00	2025-10-05 08:06:12.293+00	6
699	up	919	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:06:21.474+00	2025-10-05 08:06:21.474+00	1
700	up	237	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:06:47.157+00	2025-10-05 08:06:47.157+00	4
701	up	272	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:06:52.962+00	2025-10-05 08:06:52.962+00	7
703	up	491	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:07:02.865+00	2025-10-05 08:07:02.865+00	6
705	up	692	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:07:12.296+00	2025-10-05 08:07:12.296+00	3
706	up	642	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:07:12.388+00	2025-10-05 08:07:12.388+00	5
707	up	1793	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:07:22.359+00	2025-10-05 08:07:22.359+00	1
709	up	462	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:07:47.497+00	2025-10-05 08:07:47.497+00	4
710	up	267	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:07:52.953+00	2025-10-05 08:07:52.953+00	7
711	up	281	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:08:02.583+00	2025-10-05 08:08:02.583+00	6
714	up	447	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:08:12.065+00	2025-10-05 08:08:12.065+00	3
715	up	449	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:08:12.186+00	2025-10-05 08:08:12.186+00	5
716	up	1107	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:08:21.675+00	2025-10-05 08:08:21.675+00	1
718	up	411	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:08:47.345+00	2025-10-05 08:08:47.345+00	4
719	up	211	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:08:52.915+00	2025-10-05 08:08:52.915+00	7
720	up	254	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:09:02.549+00	2025-10-05 08:09:02.549+00	6
721	up	237	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:09:11.845+00	2025-10-05 08:09:11.845+00	3
722	up	245	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:09:11.99+00	2025-10-05 08:09:11.99+00	5
723	up	782	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:09:21.349+00	2025-10-05 08:09:21.349+00	1
724	up	289	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:09:47.315+00	2025-10-05 08:09:47.315+00	4
725	up	201	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:09:52.908+00	2025-10-05 08:09:52.908+00	7
726	up	270	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:10:02.573+00	2025-10-05 08:10:02.573+00	6
727	up	266	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:10:11.875+00	2025-10-05 08:10:11.875+00	3
728	up	374	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:10:12.128+00	2025-10-05 08:10:12.128+00	5
729	up	1000	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:10:21.57+00	2025-10-05 08:10:21.57+00	1
730	up	434	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:10:47.519+00	2025-10-05 08:10:47.519+00	4
731	up	307	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:10:53.019+00	2025-10-05 08:10:53.019+00	7
732	up	687	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:11:03+00	2025-10-05 08:11:03+00	6
733	up	562	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:11:12.188+00	2025-10-05 08:11:12.188+00	3
734	up	703	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:11:12.477+00	2025-10-05 08:11:12.477+00	5
735	up	895	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:11:21.47+00	2025-10-05 08:11:21.47+00	1
736	up	521	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:11:47.536+00	2025-10-05 08:11:47.536+00	4
737	up	350	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:11:53.059+00	2025-10-05 08:11:53.059+00	7
738	up	239	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:12:02.549+00	2025-10-05 08:12:02.549+00	6
739	up	307	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:12:11.93+00	2025-10-05 08:12:11.93+00	3
740	up	289	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:12:12.061+00	2025-10-05 08:12:12.061+00	5
741	up	795	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:12:21.372+00	2025-10-05 08:12:21.372+00	1
742	up	316	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:12:49.206+00	2025-10-05 08:12:49.206+00	4
743	up	271	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:12:54.878+00	2025-10-05 08:12:54.878+00	7
744	up	416	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:13:04.651+00	2025-10-05 08:13:04.651+00	6
745	up	189	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:13:13.698+00	2025-10-05 08:13:13.698+00	3
746	up	320	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:13:13.975+00	2025-10-05 08:13:13.975+00	5
747	up	5827	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:13:28.291+00	2025-10-05 08:13:28.291+00	1
748	up	736	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:13:49.592+00	2025-10-05 08:13:49.592+00	4
749	up	245	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:13:54.844+00	2025-10-05 08:13:54.844+00	7
750	up	190	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:14:04.393+00	2025-10-05 08:14:04.393+00	6
751	up	187	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:14:13.691+00	2025-10-05 08:14:13.691+00	3
752	up	171	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:14:13.829+00	2025-10-05 08:14:13.829+00	5
753	up	853	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:14:23.317+00	2025-10-05 08:14:23.317+00	1
754	up	245	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:14:49.13+00	2025-10-05 08:14:49.13+00	4
755	up	158	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:14:54.756+00	2025-10-05 08:14:54.756+00	7
756	up	155	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:15:04.361+00	2025-10-05 08:15:04.361+00	6
757	up	193	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:15:13.7+00	2025-10-05 08:15:13.7+00	3
758	up	232	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:15:13.887+00	2025-10-05 08:15:13.887+00	5
759	up	854	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:15:23.319+00	2025-10-05 08:15:23.319+00	1
760	up	1825	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:15:50.816+00	2025-10-05 08:15:50.816+00	4
761	up	351	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:15:54.957+00	2025-10-05 08:15:54.957+00	7
762	up	904	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:16:05.151+00	2025-10-05 08:16:05.151+00	6
763	up	288	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:16:13.801+00	2025-10-05 08:16:13.801+00	3
764	up	256	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:16:13.935+00	2025-10-05 08:16:13.935+00	5
765	up	1114	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:16:23.579+00	2025-10-05 08:16:23.579+00	1
766	up	352	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:16:49.244+00	2025-10-05 08:16:49.244+00	4
767	up	270	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:16:54.89+00	2025-10-05 08:16:54.89+00	7
768	up	179	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:17:04.399+00	2025-10-05 08:17:04.399+00	6
769	up	304	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:17:13.84+00	2025-10-05 08:17:13.84+00	3
770	up	506	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:17:14.179+00	2025-10-05 08:17:14.179+00	5
771	up	922	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:17:23.389+00	2025-10-05 08:17:23.389+00	1
772	up	507	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:17:49.396+00	2025-10-05 08:17:49.396+00	4
773	up	300	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:17:54.909+00	2025-10-05 08:17:54.909+00	7
774	up	464	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:18:04.689+00	2025-10-05 08:18:04.689+00	6
775	up	728	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:18:14.256+00	2025-10-05 08:18:14.256+00	3
776	up	638	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:18:14.305+00	2025-10-05 08:18:14.305+00	5
777	up	876	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:18:23.346+00	2025-10-05 08:18:23.346+00	1
778	up	280	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:18:49.195+00	2025-10-05 08:18:49.195+00	4
779	up	237	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:18:54.844+00	2025-10-05 08:18:54.844+00	7
780	up	409	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:19:04.644+00	2025-10-05 08:19:04.644+00	6
781	up	327	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:19:13.851+00	2025-10-05 08:19:13.851+00	3
782	up	5314	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:19:18.987+00	2025-10-05 08:19:18.987+00	5
783	up	796	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:19:23.265+00	2025-10-05 08:19:23.265+00	1
784	up	484	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:19:49.377+00	2025-10-05 08:19:49.377+00	4
785	up	578	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:19:55.193+00	2025-10-05 08:19:55.193+00	7
786	up	305	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:20:04.529+00	2025-10-05 08:20:04.529+00	6
787	up	299	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:20:13.832+00	2025-10-05 08:20:13.832+00	3
788	up	286	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:20:14.005+00	2025-10-05 08:20:14.005+00	5
789	up	1055	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:20:23.526+00	2025-10-05 08:20:23.526+00	1
790	up	364	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:20:49.281+00	2025-10-05 08:20:49.281+00	4
791	up	214	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:20:54.821+00	2025-10-05 08:20:54.821+00	7
792	up	256	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:21:04.479+00	2025-10-05 08:21:04.479+00	6
793	up	285	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:21:13.817+00	2025-10-05 08:21:13.817+00	3
794	up	482	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:21:14.179+00	2025-10-05 08:21:14.179+00	5
795	up	1254	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:21:23.727+00	2025-10-05 08:21:23.727+00	1
796	up	606	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:21:49.599+00	2025-10-05 08:21:49.599+00	4
797	up	347	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:21:54.969+00	2025-10-05 08:21:54.969+00	7
798	up	281	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:22:04.511+00	2025-10-05 08:22:04.511+00	6
799	up	443	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:22:13.982+00	2025-10-05 08:22:13.982+00	3
800	up	284	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:22:14.011+00	2025-10-05 08:22:14.011+00	5
801	up	1059	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:22:23.533+00	2025-10-05 08:22:23.533+00	1
802	up	513	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:22:49.445+00	2025-10-05 08:22:49.445+00	4
803	up	647	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:22:55.292+00	2025-10-05 08:22:55.292+00	7
804	up	568	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:23:04.803+00	2025-10-05 08:23:04.803+00	6
805	up	404	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:23:13.954+00	2025-10-05 08:23:13.954+00	3
806	up	545	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:23:14.253+00	2025-10-05 08:23:14.253+00	5
807	up	958	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:23:23.433+00	2025-10-05 08:23:23.433+00	1
808	up	551	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:23:49.684+00	2025-10-05 08:23:49.684+00	4
809	up	1000	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:23:55.687+00	2025-10-05 08:23:55.687+00	7
810	up	316	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:24:04.559+00	2025-10-05 08:24:04.559+00	6
811	up	416	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:24:13.952+00	2025-10-05 08:24:13.952+00	3
812	up	412	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:24:14.15+00	2025-10-05 08:24:14.15+00	5
813	up	945	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:24:23.42+00	2025-10-05 08:24:23.42+00	1
814	up	384	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:24:49.352+00	2025-10-05 08:24:49.352+00	4
815	up	237	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:24:54.871+00	2025-10-05 08:24:54.871+00	7
816	up	686	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:25:04.938+00	2025-10-05 08:25:04.938+00	6
817	up	305	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:25:13.85+00	2025-10-05 08:25:13.85+00	3
818	up	311	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:25:14.056+00	2025-10-05 08:25:14.056+00	5
819	up	1095	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:25:23.573+00	2025-10-05 08:25:23.573+00	1
820	up	285	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:25:49.259+00	2025-10-05 08:25:49.259+00	4
821	up	306	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:25:54.939+00	2025-10-05 08:25:54.939+00	7
822	up	237	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:26:04.473+00	2025-10-05 08:26:04.473+00	6
823	up	371	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:26:13.907+00	2025-10-05 08:26:13.907+00	3
824	up	326	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:26:14.051+00	2025-10-05 08:26:14.051+00	5
825	up	1130	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:26:23.609+00	2025-10-05 08:26:23.609+00	1
826	up	230	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:26:54.867+00	2025-10-05 08:26:54.867+00	7
827	up	303	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:27:04.549+00	2025-10-05 08:27:04.549+00	6
828	up	254	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:27:13.806+00	2025-10-05 08:27:13.806+00	3
829	up	265	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:27:13.996+00	2025-10-05 08:27:13.996+00	5
830	up	1664	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:27:24.144+00	2025-10-05 08:27:24.144+00	1
831	up	37506	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:27:26.441+00	2025-10-05 08:27:26.441+00	4
832	up	669	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:27:49.612+00	2025-10-05 08:27:49.612+00	4
833	up	515	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:27:55.145+00	2025-10-05 08:27:55.145+00	7
834	up	250	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:28:04.493+00	2025-10-05 08:28:04.493+00	6
835	up	276	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:28:13.823+00	2025-10-05 08:28:13.823+00	3
836	up	350	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:28:14.106+00	2025-10-05 08:28:14.106+00	5
837	up	942	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:28:23.424+00	2025-10-05 08:28:23.424+00	1
838	up	378	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:28:49.3+00	2025-10-05 08:28:49.3+00	4
839	up	212	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:28:54.849+00	2025-10-05 08:28:54.849+00	7
840	up	327	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:29:04.578+00	2025-10-05 08:29:04.578+00	6
841	up	252	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:29:13.805+00	2025-10-05 08:29:13.805+00	3
842	up	295	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:29:14.052+00	2025-10-05 08:29:14.052+00	5
843	up	878	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:29:23.362+00	2025-10-05 08:29:23.362+00	1
844	up	376	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:29:49.34+00	2025-10-05 08:29:49.34+00	4
845	up	306	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:29:54.95+00	2025-10-05 08:29:54.95+00	7
846	up	388	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:30:04.665+00	2025-10-05 08:30:04.665+00	6
847	up	275	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:30:13.848+00	2025-10-05 08:30:13.848+00	3
848	up	421	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:30:14.192+00	2025-10-05 08:30:14.192+00	5
849	up	861	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:30:23.346+00	2025-10-05 08:30:23.346+00	1
850	up	283	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:30:49.212+00	2025-10-05 08:30:49.212+00	4
851	up	275	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:30:54.922+00	2025-10-05 08:30:54.922+00	7
852	up	247	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:31:04.512+00	2025-10-05 08:31:04.512+00	6
853	up	202	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:31:13.777+00	2025-10-05 08:31:13.777+00	3
854	up	293	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:31:14.056+00	2025-10-05 08:31:14.056+00	5
855	up	943	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:31:23.43+00	2025-10-05 08:31:23.43+00	1
856	up	2039	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:31:51.492+00	2025-10-05 08:31:51.492+00	4
857	up	645	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:31:55.493+00	2025-10-05 08:31:55.493+00	7
858	up	205	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:32:04.471+00	2025-10-05 08:32:04.471+00	6
859	up	633	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:32:14.233+00	2025-10-05 08:32:14.233+00	3
860	up	711	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:32:14.538+00	2025-10-05 08:32:14.538+00	5
861	up	1134	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:32:23.624+00	2025-10-05 08:32:23.624+00	1
862	up	236	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:32:49.206+00	2025-10-05 08:32:49.206+00	4
863	up	183	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:32:54.831+00	2025-10-05 08:32:54.831+00	7
864	up	369	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:33:04.639+00	2025-10-05 08:33:04.639+00	6
865	up	442	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:33:14.027+00	2025-10-05 08:33:14.027+00	3
866	up	465	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:33:14.258+00	2025-10-05 08:33:14.258+00	5
867	up	989	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:33:23.489+00	2025-10-05 08:33:23.489+00	1
868	up	427	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:33:49.376+00	2025-10-05 08:33:49.376+00	4
869	up	291	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:33:54.938+00	2025-10-05 08:33:54.938+00	7
870	up	317	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:34:04.597+00	2025-10-05 08:34:04.597+00	6
871	up	268	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:34:13.846+00	2025-10-05 08:34:13.846+00	3
872	up	265	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:34:14.042+00	2025-10-05 08:34:14.042+00	5
873	up	1484	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:34:23.986+00	2025-10-05 08:34:23.986+00	1
874	up	327	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:34:49.278+00	2025-10-05 08:34:49.278+00	4
875	up	250	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:34:54.905+00	2025-10-05 08:34:54.905+00	7
876	up	420	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:35:04.698+00	2025-10-05 08:35:04.698+00	6
877	up	441	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:35:14.017+00	2025-10-05 08:35:14.017+00	3
878	up	568	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:35:14.38+00	2025-10-05 08:35:14.38+00	5
879	up	1027	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:35:23.533+00	2025-10-05 08:35:23.533+00	1
880	up	303	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:35:49.247+00	2025-10-05 08:35:49.247+00	4
881	up	5394	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:36:00.055+00	2025-10-05 08:36:00.055+00	7
882	up	269	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:36:04.546+00	2025-10-05 08:36:04.546+00	6
883	up	279	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:36:13.853+00	2025-10-05 08:36:13.853+00	3
884	up	244	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:36:14.037+00	2025-10-05 08:36:14.037+00	5
885	up	1454	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:36:23.961+00	2025-10-05 08:36:23.961+00	1
886	up	336	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:36:49.305+00	2025-10-05 08:36:49.305+00	4
887	up	220	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:36:54.872+00	2025-10-05 08:36:54.872+00	7
888	up	237	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:37:04.519+00	2025-10-05 08:37:04.519+00	6
889	up	339	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:37:13.913+00	2025-10-05 08:37:13.913+00	3
890	up	475	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:37:14.27+00	2025-10-05 08:37:14.27+00	5
891	up	925	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:37:23.432+00	2025-10-05 08:37:23.432+00	1
892	up	274	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:37:49.246+00	2025-10-05 08:37:49.246+00	4
893	up	265	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:37:54.918+00	2025-10-05 08:37:54.918+00	7
894	up	398	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:38:04.752+00	2025-10-05 08:38:04.752+00	6
895	up	375	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:38:13.953+00	2025-10-05 08:38:13.953+00	3
896	up	368	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:38:14.171+00	2025-10-05 08:38:14.171+00	5
897	up	883	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:38:23.392+00	2025-10-05 08:38:23.392+00	1
898	up	252	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:38:49.219+00	2025-10-05 08:38:49.219+00	4
899	up	210	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:38:54.868+00	2025-10-05 08:38:54.868+00	7
900	up	533	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:39:04.912+00	2025-10-05 08:39:04.912+00	6
901	up	229	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:39:13.806+00	2025-10-05 08:39:13.806+00	3
902	up	244	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:39:14.042+00	2025-10-05 08:39:14.042+00	5
903	up	939	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:39:23.448+00	2025-10-05 08:39:23.448+00	1
904	up	391	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:39:49.37+00	2025-10-05 08:39:49.37+00	4
905	up	434	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:39:55.097+00	2025-10-05 08:39:55.097+00	7
906	up	340	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:40:04.688+00	2025-10-05 08:40:04.688+00	6
907	up	258	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:40:13.836+00	2025-10-05 08:40:13.836+00	3
908	up	252	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:40:14.047+00	2025-10-05 08:40:14.047+00	5
909	up	782	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:40:23.296+00	2025-10-05 08:40:23.296+00	1
910	up	354	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:40:49.313+00	2025-10-05 08:40:49.313+00	4
911	up	234	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:40:54.888+00	2025-10-05 08:40:54.888+00	7
912	up	325	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:41:04.68+00	2025-10-05 08:41:04.68+00	6
913	up	335	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:41:13.913+00	2025-10-05 08:41:13.913+00	3
914	up	260	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:41:14.07+00	2025-10-05 08:41:14.07+00	5
915	up	931	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:41:23.449+00	2025-10-05 08:41:23.449+00	1
916	up	783	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:41:49.875+00	2025-10-05 08:41:49.875+00	4
917	up	285	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:41:54.95+00	2025-10-05 08:41:54.95+00	7
918	up	194	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:42:04.552+00	2025-10-05 08:42:04.552+00	6
919	up	262	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:42:13.839+00	2025-10-05 08:42:13.839+00	3
920	up	292	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:42:14.099+00	2025-10-05 08:42:14.099+00	5
921	up	5823	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:42:28.345+00	2025-10-05 08:42:28.345+00	1
922	up	244	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:42:49.201+00	2025-10-05 08:42:49.201+00	4
923	up	297	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:42:54.965+00	2025-10-05 08:42:54.965+00	7
924	up	315	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:43:04.664+00	2025-10-05 08:43:04.664+00	6
925	up	420	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:43:14.038+00	2025-10-05 08:43:14.038+00	3
926	up	546	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:43:14.369+00	2025-10-05 08:43:14.369+00	5
927	up	838	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:43:23.36+00	2025-10-05 08:43:23.36+00	1
928	up	380	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:43:49.363+00	2025-10-05 08:43:49.363+00	4
929	up	245	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:43:54.91+00	2025-10-05 08:43:54.91+00	7
930	up	637	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:44:04.987+00	2025-10-05 08:44:04.987+00	6
931	up	283	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:44:13.871+00	2025-10-05 08:44:13.871+00	3
932	up	307	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:44:14.116+00	2025-10-05 08:44:14.116+00	5
933	up	959	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:44:23.483+00	2025-10-05 08:44:23.483+00	1
934	up	305	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:44:49.262+00	2025-10-05 08:44:49.262+00	4
935	up	363	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:44:55.036+00	2025-10-05 08:44:55.036+00	7
936	up	266	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:45:04.633+00	2025-10-05 08:45:04.633+00	6
937	up	362	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:45:13.962+00	2025-10-05 08:45:13.962+00	3
938	up	270	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:45:14.096+00	2025-10-05 08:45:14.096+00	5
939	up	1454	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:45:23.982+00	2025-10-05 08:45:23.982+00	1
940	up	285	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:45:49.268+00	2025-10-05 08:45:49.268+00	4
941	up	249	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:45:54.914+00	2025-10-05 08:45:54.914+00	7
942	up	277	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:46:04.628+00	2025-10-05 08:46:04.628+00	6
943	up	226	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:46:13.818+00	2025-10-05 08:46:13.818+00	3
944	up	313	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:46:14.134+00	2025-10-05 08:46:14.134+00	5
945	up	848	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:46:23.378+00	2025-10-05 08:46:23.378+00	1
946	up	1312	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:46:50.28+00	2025-10-05 08:46:50.28+00	4
947	up	314	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:46:54.996+00	2025-10-05 08:46:54.996+00	7
948	up	253	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:47:04.609+00	2025-10-05 08:47:04.609+00	6
949	up	262	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:47:13.854+00	2025-10-05 08:47:13.854+00	3
950	up	290	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:47:14.116+00	2025-10-05 08:47:14.116+00	5
951	up	975	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:47:23.508+00	2025-10-05 08:47:23.508+00	1
952	up	330	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:47:49.32+00	2025-10-05 08:47:49.32+00	4
953	up	289	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:47:54.989+00	2025-10-05 08:47:54.989+00	7
954	up	191	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:48:04.539+00	2025-10-05 08:48:04.539+00	6
955	up	511	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:48:14.114+00	2025-10-05 08:48:14.114+00	3
956	up	514	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:48:14.361+00	2025-10-05 08:48:14.361+00	5
957	up	1372	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:48:23.905+00	2025-10-05 08:48:23.905+00	1
958	up	446	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:48:49.507+00	2025-10-05 08:48:49.507+00	4
959	up	261	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:48:54.942+00	2025-10-05 08:48:54.942+00	7
960	up	184	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:49:04.536+00	2025-10-05 08:49:04.536+00	6
961	up	427	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:49:14.019+00	2025-10-05 08:49:14.019+00	3
962	up	482	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:49:14.311+00	2025-10-05 08:49:14.311+00	5
963	up	1027	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:49:23.56+00	2025-10-05 08:49:23.56+00	1
964	up	313	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:49:49.272+00	2025-10-05 08:49:49.272+00	4
965	up	279	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:49:54.961+00	2025-10-05 08:49:54.961+00	7
966	up	241	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:50:04.611+00	2025-10-05 08:50:04.611+00	6
967	up	328	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:50:13.921+00	2025-10-05 08:50:13.921+00	3
968	up	336	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:50:14.169+00	2025-10-05 08:50:14.169+00	5
969	up	830	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:50:23.372+00	2025-10-05 08:50:23.372+00	1
970	up	3453	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:50:52.515+00	2025-10-05 08:50:52.515+00	4
971	up	320	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:50:54.997+00	2025-10-05 08:50:54.997+00	7
972	up	185	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:51:04.545+00	2025-10-05 08:51:04.545+00	6
973	up	187	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:51:13.777+00	2025-10-05 08:51:13.777+00	3
974	up	220	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:51:14.068+00	2025-10-05 08:51:14.068+00	5
975	up	882	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:51:23.425+00	2025-10-05 08:51:23.425+00	1
976	up	310	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:51:49.29+00	2025-10-05 08:51:49.29+00	4
977	up	305	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:51:55.008+00	2025-10-05 08:51:55.008+00	7
978	up	285	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:52:04.661+00	2025-10-05 08:52:04.661+00	6
979	up	178	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:52:13.771+00	2025-10-05 08:52:13.771+00	3
980	up	271	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:52:14.106+00	2025-10-05 08:52:14.106+00	5
981	up	826	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:52:23.37+00	2025-10-05 08:52:23.37+00	1
982	up	425	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:52:49.427+00	2025-10-05 08:52:49.427+00	4
983	up	310	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:52:55.007+00	2025-10-05 08:52:55.007+00	7
984	up	317	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:53:04.683+00	2025-10-05 08:53:04.683+00	6
985	up	279	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:53:13.873+00	2025-10-05 08:53:13.873+00	3
986	up	343	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:53:14.195+00	2025-10-05 08:53:14.195+00	5
987	up	2160	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:53:24.712+00	2025-10-05 08:53:24.712+00	1
988	up	202	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:53:49.131+00	2025-10-05 08:53:49.131+00	4
989	up	314	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:53:55.01+00	2025-10-05 08:53:55.01+00	7
990	up	207	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:54:04.58+00	2025-10-05 08:54:04.58+00	6
991	up	187	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:54:13.791+00	2025-10-05 08:54:13.791+00	3
992	up	222	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:54:14.083+00	2025-10-05 08:54:14.083+00	5
993	up	957	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:54:23.51+00	2025-10-05 08:54:23.51+00	1
994	up	530	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:54:49.489+00	2025-10-05 08:54:49.489+00	4
995	up	198	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:54:54.889+00	2025-10-05 08:54:54.889+00	7
996	up	260	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:55:04.632+00	2025-10-05 08:55:04.632+00	6
997	up	287	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:55:13.895+00	2025-10-05 08:55:13.895+00	3
998	up	459	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:55:14.313+00	2025-10-05 08:55:14.313+00	5
999	up	827	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:55:23.382+00	2025-10-05 08:55:23.382+00	1
1000	up	250	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:55:49.204+00	2025-10-05 08:55:49.204+00	4
1001	up	227	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:55:54.919+00	2025-10-05 08:55:54.919+00	7
1002	up	139	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:56:04.512+00	2025-10-05 08:56:04.512+00	6
1003	up	172	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:56:13.779+00	2025-10-05 08:56:13.779+00	3
1004	up	198	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:56:14.051+00	2025-10-05 08:56:14.051+00	5
1005	up	778	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:56:23.334+00	2025-10-05 08:56:23.334+00	1
1006	up	268	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:56:49.251+00	2025-10-05 08:56:49.251+00	4
1007	up	186	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:56:54.88+00	2025-10-05 08:56:54.88+00	7
1008	up	225	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:57:04.596+00	2025-10-05 08:57:04.596+00	6
1009	up	373	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:57:13.986+00	2025-10-05 08:57:13.986+00	3
1010	up	369	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:57:14.25+00	2025-10-05 08:57:14.25+00	5
1011	up	779	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:57:23.342+00	2025-10-05 08:57:23.342+00	1
1012	up	272	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:57:49.222+00	2025-10-05 08:57:49.222+00	4
1013	up	148	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:57:54.837+00	2025-10-05 08:57:54.837+00	7
1014	up	233	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:58:04.603+00	2025-10-05 08:58:04.603+00	6
1015	up	322	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:58:13.937+00	2025-10-05 08:58:13.937+00	3
1016	up	363	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:58:14.25+00	2025-10-05 08:58:14.25+00	5
1017	up	1413	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:58:23.978+00	2025-10-05 08:58:23.978+00	1
1018	up	252	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:58:49.207+00	2025-10-05 08:58:49.207+00	4
1019	up	196	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:58:54.888+00	2025-10-05 08:58:54.888+00	7
1020	up	297	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:59:04.67+00	2025-10-05 08:59:04.67+00	6
1021	up	248	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 08:59:13.86+00	2025-10-05 08:59:13.86+00	3
1022	up	398	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:59:14.306+00	2025-10-05 08:59:14.306+00	5
1023	up	872	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 08:59:23.439+00	2025-10-05 08:59:23.439+00	1
1024	up	200	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 08:59:49.178+00	2025-10-05 08:59:49.178+00	4
1025	up	174	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 08:59:54.879+00	2025-10-05 08:59:54.879+00	7
1026	up	252	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:00:04.641+00	2025-10-05 09:00:04.641+00	6
1027	up	301	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:00:13.933+00	2025-10-05 09:00:13.933+00	3
1028	up	323	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:00:14.225+00	2025-10-05 09:00:14.225+00	5
1029	up	1122	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:00:23.688+00	2025-10-05 09:00:23.688+00	1
1030	up	413	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:00:49.399+00	2025-10-05 09:00:49.399+00	4
1031	up	194	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:00:54.899+00	2025-10-05 09:00:54.899+00	7
1032	up	316	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:01:04.691+00	2025-10-05 09:01:04.691+00	6
1033	up	170	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:01:13.784+00	2025-10-05 09:01:13.784+00	3
1034	up	233	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:01:14.119+00	2025-10-05 09:01:14.119+00	5
1035	up	857	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:01:23.425+00	2025-10-05 09:01:23.425+00	1
1036	up	241	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:01:49.211+00	2025-10-05 09:01:49.211+00	4
1037	up	376	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:01:55.081+00	2025-10-05 09:01:55.081+00	7
1038	up	343	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:02:04.724+00	2025-10-05 09:02:04.724+00	6
1039	up	217	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:02:13.843+00	2025-10-05 09:02:13.843+00	3
1040	up	290	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:02:14.193+00	2025-10-05 09:02:14.193+00	5
1041	up	853	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:02:23.423+00	2025-10-05 09:02:23.423+00	1
1042	up	411	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:02:49.366+00	2025-10-05 09:02:49.366+00	4
1043	up	275	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:02:54.982+00	2025-10-05 09:02:54.982+00	7
1044	up	211	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:03:04.591+00	2025-10-05 09:03:04.591+00	6
1045	up	190	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:03:13.811+00	2025-10-05 09:03:13.811+00	3
1046	up	212	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:03:14.116+00	2025-10-05 09:03:14.116+00	5
1047	up	942	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:03:23.536+00	2025-10-05 09:03:23.536+00	1
1048	up	243	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:03:49.249+00	2025-10-05 09:03:49.249+00	4
1049	up	449	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:03:55.155+00	2025-10-05 09:03:55.155+00	7
1050	up	5469	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:04:09.856+00	2025-10-05 09:04:09.856+00	6
1051	up	220	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:04:13.855+00	2025-10-05 09:04:13.855+00	3
1052	up	210	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:04:14.116+00	2025-10-05 09:04:14.116+00	5
1053	up	1082	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:04:23.678+00	2025-10-05 09:04:23.678+00	1
1054	up	295	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:04:49.26+00	2025-10-05 09:04:49.26+00	4
1055	up	188	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:04:55.108+00	2025-10-05 09:04:55.108+00	7
1056	up	396	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:05:04.997+00	2025-10-05 09:05:04.997+00	6
1057	up	263	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:05:14.106+00	2025-10-05 09:05:14.106+00	3
1058	up	311	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:05:14.455+00	2025-10-05 09:05:14.455+00	5
1059	up	1626	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:05:24.431+00	2025-10-05 09:05:24.431+00	1
1060	up	593	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:05:49.769+00	2025-10-05 09:05:49.769+00	4
1061	up	1533	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:05:56.448+00	2025-10-05 09:05:56.448+00	7
1062	up	272	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:06:04.865+00	2025-10-05 09:06:04.865+00	6
1063	up	233	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:06:14.08+00	2025-10-05 09:06:14.08+00	3
1064	up	562	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:06:14.686+00	2025-10-05 09:06:14.686+00	5
1065	up	945	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:06:23.757+00	2025-10-05 09:06:23.757+00	1
1066	up	361	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:06:49.572+00	2025-10-05 09:06:49.572+00	4
1067	up	401	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:06:55.331+00	2025-10-05 09:06:55.331+00	7
1068	up	485	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:07:05.125+00	2025-10-05 09:07:05.125+00	6
1069	up	529	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:07:14.438+00	2025-10-05 09:07:14.438+00	3
1070	up	456	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:07:14.705+00	2025-10-05 09:07:14.705+00	5
1071	up	848	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:07:23.664+00	2025-10-05 09:07:23.664+00	1
1072	up	223	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:07:49.382+00	2025-10-05 09:07:49.382+00	4
1073	up	267	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:07:55.194+00	2025-10-05 09:07:55.194+00	7
1074	up	164	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:08:04.802+00	2025-10-05 09:08:04.802+00	6
1075	up	395	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:08:14.244+00	2025-10-05 09:08:14.244+00	3
1076	up	548	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:08:14.867+00	2025-10-05 09:08:14.867+00	5
1077	up	802	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:08:23.625+00	2025-10-05 09:08:23.625+00	1
1078	up	449	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:08:49.617+00	2025-10-05 09:08:49.617+00	4
1079	up	216	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:08:55.137+00	2025-10-05 09:08:55.137+00	7
1080	up	399	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:09:05.035+00	2025-10-05 09:09:05.035+00	6
1081	up	520	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:09:14.366+00	2025-10-05 09:09:14.366+00	3
1082	up	417	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:09:14.591+00	2025-10-05 09:09:14.591+00	5
1083	up	875	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:09:23.7+00	2025-10-05 09:09:23.7+00	1
1084	up	179	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:09:49.363+00	2025-10-05 09:09:49.363+00	4
1085	up	185	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:09:55.108+00	2025-10-05 09:09:55.108+00	7
1086	up	252	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:10:04.89+00	2025-10-05 09:10:04.89+00	6
1087	up	252	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:10:14.102+00	2025-10-05 09:10:14.102+00	3
1088	up	236	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:10:14.42+00	2025-10-05 09:10:14.42+00	5
1089	up	834	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:10:23.658+00	2025-10-05 09:10:23.658+00	1
1090	up	273	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:10:49.463+00	2025-10-05 09:10:49.463+00	4
1091	up	163	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:10:55.089+00	2025-10-05 09:10:55.089+00	7
1092	up	215	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:11:04.86+00	2025-10-05 09:11:04.86+00	6
1093	up	177	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:11:14.03+00	2025-10-05 09:11:14.03+00	3
1094	up	163	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:11:14.332+00	2025-10-05 09:11:14.332+00	5
1095	up	1008	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:11:23.837+00	2025-10-05 09:11:23.837+00	1
1096	up	229	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:11:49.422+00	2025-10-05 09:11:49.422+00	4
1097	up	230	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:11:55.158+00	2025-10-05 09:11:55.158+00	7
1098	up	164	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:12:04.811+00	2025-10-05 09:12:04.811+00	6
1099	up	350	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:12:14.208+00	2025-10-05 09:12:14.208+00	3
1100	up	332	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:12:14.513+00	2025-10-05 09:12:14.513+00	5
1101	up	970	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:12:23.8+00	2025-10-05 09:12:23.8+00	1
1102	up	336	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:12:49.534+00	2025-10-05 09:12:49.534+00	4
1103	up	161	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:12:55.086+00	2025-10-05 09:12:55.086+00	7
1104	up	227	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:13:04.932+00	2025-10-05 09:13:04.932+00	6
1105	up	122	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:13:13.973+00	2025-10-05 09:13:13.973+00	3
1106	up	140	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:13:14.316+00	2025-10-05 09:13:14.316+00	5
1107	up	1009	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:13:23.839+00	2025-10-05 09:13:23.839+00	1
1108	up	923	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:13:30.603+00	2025-10-05 09:13:30.603+00	1
1109	up	788	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:13:34.456+00	2025-10-05 09:13:34.456+00	1
1110	up	900	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:13:37.898+00	2025-10-05 09:13:37.898+00	1
1111	up	896	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:13:41.708+00	2025-10-05 09:13:41.708+00	1
1112	up	877	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:13:42.988+00	2025-10-05 09:13:42.988+00	1
1113	up	873	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:13:44.819+00	2025-10-05 09:13:44.819+00	1
1114	up	886	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:13:46.102+00	2025-10-05 09:13:46.102+00	1
1115	up	395	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:13:49.562+00	2025-10-05 09:13:49.562+00	4
1116	up	572	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:13:55.515+00	2025-10-05 09:13:55.515+00	7
1117	up	250	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:14:04.959+00	2025-10-05 09:14:04.959+00	6
1118	up	262	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:14:14.123+00	2025-10-05 09:14:14.123+00	3
1119	up	298	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:14:14.475+00	2025-10-05 09:14:14.475+00	5
1120	up	856	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:14:23.687+00	2025-10-05 09:14:23.687+00	1
1121	up	354	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:14:49.545+00	2025-10-05 09:14:49.545+00	4
1122	up	281	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:14:55.227+00	2025-10-05 09:14:55.227+00	7
1123	up	173	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:15:04.878+00	2025-10-05 09:15:04.878+00	6
1124	up	193	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:15:14.068+00	2025-10-05 09:15:14.068+00	3
1125	up	209	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:15:14.393+00	2025-10-05 09:15:14.393+00	5
1126	up	785	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:15:23.617+00	2025-10-05 09:15:23.617+00	1
1127	up	432	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:15:49.637+00	2025-10-05 09:15:49.637+00	4
1128	up	191	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:15:55.132+00	2025-10-05 09:15:55.132+00	7
1129	up	289	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:16:05.006+00	2025-10-05 09:16:05.006+00	6
1130	up	243	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:16:14.102+00	2025-10-05 09:16:14.102+00	3
1131	up	217	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:16:14.401+00	2025-10-05 09:16:14.401+00	5
1132	up	805	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:16:23.638+00	2025-10-05 09:16:23.638+00	1
1133	up	360	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:16:49.572+00	2025-10-05 09:16:49.572+00	4
1134	up	257	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:16:55.206+00	2025-10-05 09:16:55.206+00	7
1135	up	262	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:17:04.991+00	2025-10-05 09:17:04.991+00	6
1136	up	165	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:17:14.025+00	2025-10-05 09:17:14.025+00	3
1137	up	179	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:17:14.36+00	2025-10-05 09:17:14.36+00	5
1138	up	899	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:17:23.732+00	2025-10-05 09:17:23.732+00	1
1139	up	418	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:17:49.638+00	2025-10-05 09:17:49.638+00	4
1140	up	193	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:17:55.136+00	2025-10-05 09:17:55.136+00	7
1141	up	182	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:18:04.907+00	2025-10-05 09:18:04.907+00	6
1142	up	179	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:18:14.047+00	2025-10-05 09:18:14.047+00	3
1143	up	251	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:18:14.444+00	2025-10-05 09:18:14.444+00	5
1144	up	806	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:18:23.64+00	2025-10-05 09:18:23.64+00	1
1145	up	241	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:18:49.455+00	2025-10-05 09:18:49.455+00	4
1146	up	158	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:18:55.11+00	2025-10-05 09:18:55.11+00	7
1147	up	191	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:19:04.913+00	2025-10-05 09:19:04.913+00	6
1148	up	194	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:19:14.057+00	2025-10-05 09:19:14.057+00	3
1149	up	204	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:19:14.402+00	2025-10-05 09:19:14.402+00	5
1150	up	836	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:19:23.672+00	2025-10-05 09:19:23.672+00	1
1151	up	230	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:19:49.445+00	2025-10-05 09:19:49.445+00	4
1152	up	199	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:19:55.154+00	2025-10-05 09:19:55.154+00	7
1153	up	182	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:20:04.914+00	2025-10-05 09:20:04.914+00	6
1154	up	165	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:20:14.034+00	2025-10-05 09:20:14.034+00	3
1155	up	235	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:20:14.441+00	2025-10-05 09:20:14.441+00	5
1156	up	813	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:20:23.651+00	2025-10-05 09:20:23.651+00	1
1157	up	196	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:20:49.398+00	2025-10-05 09:20:49.398+00	4
1158	up	182	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:20:55.135+00	2025-10-05 09:20:55.135+00	7
1159	up	193	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:21:04.923+00	2025-10-05 09:21:04.923+00	6
1160	up	219	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:21:14.088+00	2025-10-05 09:21:14.088+00	3
1161	up	194	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:21:14.399+00	2025-10-05 09:21:14.399+00	5
1162	up	772	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:21:23.611+00	2025-10-05 09:21:23.611+00	1
1163	up	251	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:21:49.47+00	2025-10-05 09:21:49.47+00	4
1164	up	211	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:21:55.165+00	2025-10-05 09:21:55.165+00	7
1165	up	245	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:22:04.973+00	2025-10-05 09:22:04.973+00	6
1166	up	176	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:22:14.044+00	2025-10-05 09:22:14.044+00	3
1167	up	241	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:22:14.448+00	2025-10-05 09:22:14.448+00	5
1168	up	935	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:22:23.776+00	2025-10-05 09:22:23.776+00	1
1169	up	285	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:22:49.837+00	2025-10-05 09:22:49.837+00	4
1170	up	161	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:22:55.422+00	2025-10-05 09:22:55.422+00	7
1171	up	212	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:23:05.249+00	2025-10-05 09:23:05.249+00	6
1172	up	164	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:23:14.343+00	2025-10-05 09:23:14.343+00	3
1173	up	246	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:23:14.76+00	2025-10-05 09:23:14.76+00	5
1174	up	797	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:23:23.956+00	2025-10-05 09:23:23.956+00	1
1175	up	225	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:23:49.752+00	2025-10-05 09:23:49.752+00	4
1176	up	178	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:23:55.444+00	2025-10-05 09:23:55.444+00	7
1177	up	223	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:24:05.257+00	2025-10-05 09:24:05.257+00	6
1178	up	232	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:24:14.422+00	2025-10-05 09:24:14.422+00	3
1179	up	283	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:24:14.804+00	2025-10-05 09:24:14.804+00	5
1180	up	843	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:24:24.004+00	2025-10-05 09:24:24.004+00	1
1181	up	192	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:24:49.742+00	2025-10-05 09:24:49.742+00	4
1182	up	175	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:24:55.439+00	2025-10-05 09:24:55.439+00	7
1183	up	223	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:25:05.267+00	2025-10-05 09:25:05.267+00	6
1184	up	191	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:25:14.369+00	2025-10-05 09:25:14.369+00	3
1185	up	216	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:25:14.731+00	2025-10-05 09:25:14.731+00	5
1186	up	830	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:25:24.006+00	2025-10-05 09:25:24.006+00	1
1187	up	301	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:25:49.832+00	2025-10-05 09:25:49.832+00	4
1188	up	251	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:25:55.518+00	2025-10-05 09:25:55.518+00	7
1189	up	292	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:26:05.33+00	2025-10-05 09:26:05.33+00	6
1190	up	222	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:26:14.41+00	2025-10-05 09:26:14.41+00	3
1191	up	325	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:26:14.888+00	2025-10-05 09:26:14.888+00	5
1192	up	798	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:26:23.981+00	2025-10-05 09:26:23.981+00	1
1193	up	289	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:26:49.836+00	2025-10-05 09:26:49.836+00	4
1194	up	192	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:26:55.471+00	2025-10-05 09:26:55.471+00	7
1195	up	273	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:27:05.311+00	2025-10-05 09:27:05.311+00	6
1196	up	187	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:27:14.384+00	2025-10-05 09:27:14.384+00	3
1197	up	180	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:27:14.729+00	2025-10-05 09:27:14.729+00	5
1198	up	815	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:27:23.998+00	2025-10-05 09:27:23.998+00	1
1199	up	245	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:27:49.802+00	2025-10-05 09:27:49.802+00	4
1200	up	168	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:27:55.441+00	2025-10-05 09:27:55.441+00	7
1201	up	194	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:28:05.238+00	2025-10-05 09:28:05.238+00	6
1202	up	189	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:28:14.379+00	2025-10-05 09:28:14.379+00	3
1203	up	282	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:28:14.836+00	2025-10-05 09:28:14.836+00	5
1204	up	888	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:28:24.074+00	2025-10-05 09:28:24.074+00	1
1205	up	257	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:28:49.837+00	2025-10-05 09:28:49.837+00	4
1206	up	143	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:28:55.418+00	2025-10-05 09:28:55.418+00	7
1207	up	148	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:29:05.206+00	2025-10-05 09:29:05.206+00	6
1208	up	158	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:29:14.35+00	2025-10-05 09:29:14.35+00	3
1209	up	215	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:29:14.77+00	2025-10-05 09:29:14.77+00	5
1210	up	823	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:29:24.013+00	2025-10-05 09:29:24.013+00	1
1211	up	342	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:29:49.917+00	2025-10-05 09:29:49.917+00	4
1212	up	215	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:29:55.495+00	2025-10-05 09:29:55.495+00	7
1213	up	231	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:30:05.287+00	2025-10-05 09:30:05.287+00	6
1214	up	194	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:30:14.387+00	2025-10-05 09:30:14.387+00	3
1215	up	246	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:30:14.807+00	2025-10-05 09:30:14.807+00	5
1216	up	803	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:30:23.995+00	2025-10-05 09:30:23.995+00	1
1217	up	227	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:30:49.795+00	2025-10-05 09:30:49.795+00	4
1223	up	330	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:31:49.902+00	2025-10-05 09:31:49.902+00	4
1224	up	185	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:31:55.468+00	2025-10-05 09:31:55.468+00	7
1225	up	206	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:32:05.293+00	2025-10-05 09:32:05.293+00	6
1226	up	172	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:32:14.365+00	2025-10-05 09:32:14.365+00	3
1227	up	162	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:32:14.722+00	2025-10-05 09:32:14.722+00	5
1228	up	1898	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:32:25.1+00	2025-10-05 09:32:25.1+00	1
1231	up	430	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:33:05.52+00	2025-10-05 09:33:05.52+00	6
1232	up	151	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:33:14.349+00	2025-10-05 09:33:14.349+00	3
1233	up	233	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:33:14.798+00	2025-10-05 09:33:14.798+00	5
1234	up	910	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:33:24.112+00	2025-10-05 09:33:24.112+00	1
1235	up	411	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:33:49.983+00	2025-10-05 09:33:49.983+00	4
1236	up	198	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:33:55.478+00	2025-10-05 09:33:55.478+00	7
1237	up	158	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:34:05.246+00	2025-10-05 09:34:05.246+00	6
1238	up	242	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:34:14.439+00	2025-10-05 09:34:14.439+00	3
1239	up	278	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:34:14.847+00	2025-10-05 09:34:14.847+00	5
1240	up	863	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:34:24.07+00	2025-10-05 09:34:24.07+00	1
1241	up	304	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:34:49.895+00	2025-10-05 09:34:49.895+00	4
1242	up	215	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:34:55.501+00	2025-10-05 09:34:55.501+00	7
1243	up	202	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:35:05.289+00	2025-10-05 09:35:05.289+00	6
1244	up	206	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:35:14.406+00	2025-10-05 09:35:14.406+00	3
1245	up	195	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:35:14.762+00	2025-10-05 09:35:14.762+00	5
1246	up	927	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:35:24.131+00	2025-10-05 09:35:24.131+00	1
1247	up	282	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:35:49.88+00	2025-10-05 09:35:49.88+00	4
1248	up	189	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:35:55.478+00	2025-10-05 09:35:55.478+00	7
1249	up	175	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:36:05.272+00	2025-10-05 09:36:05.272+00	6
1250	up	192	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:36:14.394+00	2025-10-05 09:36:14.394+00	3
1251	up	181	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:36:14.747+00	2025-10-05 09:36:14.747+00	5
1252	up	742	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:36:23.948+00	2025-10-05 09:36:23.948+00	1
1253	up	271	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:36:49.861+00	2025-10-05 09:36:49.861+00	4
1254	up	373	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:36:55.66+00	2025-10-05 09:36:55.66+00	7
1255	up	209	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:37:05.306+00	2025-10-05 09:37:05.306+00	6
1256	up	169	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:37:14.38+00	2025-10-05 09:37:14.38+00	3
1257	up	215	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:37:14.78+00	2025-10-05 09:37:14.78+00	5
1258	up	752	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:37:23.957+00	2025-10-05 09:37:23.957+00	1
1259	up	190	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:37:49.795+00	2025-10-05 09:37:49.795+00	4
1260	up	329	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:37:55.626+00	2025-10-05 09:37:55.626+00	7
1261	up	164	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:38:05.257+00	2025-10-05 09:38:05.257+00	6
1262	up	204	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:38:14.408+00	2025-10-05 09:38:14.408+00	3
1263	up	181	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:38:14.771+00	2025-10-05 09:38:14.771+00	5
1264	up	827	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:38:24.033+00	2025-10-05 09:38:24.033+00	1
1265	up	235	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:38:49.889+00	2025-10-05 09:38:49.889+00	4
1266	up	294	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:38:55.603+00	2025-10-05 09:38:55.603+00	7
1267	up	233	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:39:05.327+00	2025-10-05 09:39:05.327+00	6
1268	up	206	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:39:14.411+00	2025-10-05 09:39:14.411+00	3
1269	up	224	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:39:14.801+00	2025-10-05 09:39:14.801+00	5
1270	up	1000	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:39:24.207+00	2025-10-05 09:39:24.207+00	1
1271	up	261	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:39:49.868+00	2025-10-05 09:39:49.868+00	4
1272	up	239	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:39:55.536+00	2025-10-05 09:39:55.536+00	7
1273	up	141	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:40:05.244+00	2025-10-05 09:40:05.244+00	6
1274	up	149	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:40:14.353+00	2025-10-05 09:40:14.353+00	3
1275	up	177	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:40:14.755+00	2025-10-05 09:40:14.755+00	5
1276	up	793	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:40:24.008+00	2025-10-05 09:40:24.008+00	1
1277	up	258	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:40:49.877+00	2025-10-05 09:40:49.877+00	4
1278	up	141	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:40:55.447+00	2025-10-05 09:40:55.447+00	7
1279	up	143	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:41:05.238+00	2025-10-05 09:41:05.238+00	6
1280	up	205	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:41:14.418+00	2025-10-05 09:41:14.418+00	3
1281	up	234	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:41:14.825+00	2025-10-05 09:41:14.825+00	5
1282	up	957	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:41:24.173+00	2025-10-05 09:41:24.173+00	1
1283	up	431	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:41:50.056+00	2025-10-05 09:41:50.056+00	4
1284	up	168	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:41:55.468+00	2025-10-05 09:41:55.468+00	7
1285	up	650	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:42:05.758+00	2025-10-05 09:42:05.758+00	6
1286	up	170	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:42:14.377+00	2025-10-05 09:42:14.377+00	3
1287	up	236	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:42:14.822+00	2025-10-05 09:42:14.822+00	5
1288	up	939	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:42:24.155+00	2025-10-05 09:42:24.155+00	1
1289	up	209	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:42:49.824+00	2025-10-05 09:42:49.824+00	4
1290	up	198	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:42:55.499+00	2025-10-05 09:42:55.499+00	7
1291	up	247	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:43:05.358+00	2025-10-05 09:43:05.358+00	6
1292	up	158	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:43:14.373+00	2025-10-05 09:43:14.373+00	3
1293	up	161	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:43:14.742+00	2025-10-05 09:43:14.742+00	5
1294	up	5740	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:43:28.96+00	2025-10-05 09:43:28.96+00	1
1295	up	265	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:43:49.878+00	2025-10-05 09:43:49.878+00	4
1296	up	170	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:43:55.477+00	2025-10-05 09:43:55.477+00	7
1297	up	243	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:44:05.347+00	2025-10-05 09:44:05.347+00	6
1298	up	246	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:44:14.471+00	2025-10-05 09:44:14.471+00	3
1299	up	439	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:44:15.07+00	2025-10-05 09:44:15.07+00	5
1300	up	888	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:44:24.109+00	2025-10-05 09:44:24.109+00	1
1301	up	235	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:44:49.846+00	2025-10-05 09:44:49.846+00	4
1302	up	5264	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:45:00.567+00	2025-10-05 09:45:00.567+00	7
1303	up	249	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:45:05.357+00	2025-10-05 09:45:05.357+00	6
1304	up	304	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:45:14.53+00	2025-10-05 09:45:14.53+00	3
1305	up	176	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:45:14.791+00	2025-10-05 09:45:14.791+00	5
1306	up	850	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:45:24.071+00	2025-10-05 09:45:24.071+00	1
1307	up	316	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:45:49.937+00	2025-10-05 09:45:49.937+00	4
1308	up	152	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:45:55.457+00	2025-10-05 09:45:55.457+00	7
1309	up	120	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:46:05.224+00	2025-10-05 09:46:05.224+00	6
1310	up	162	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:46:14.38+00	2025-10-05 09:46:14.38+00	3
1311	up	155	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:46:14.769+00	2025-10-05 09:46:14.769+00	5
1312	up	747	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:46:23.968+00	2025-10-05 09:46:23.968+00	1
1313	up	277	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:46:49.882+00	2025-10-05 09:46:49.882+00	4
1314	up	175	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:46:55.481+00	2025-10-05 09:46:55.481+00	7
1315	up	265	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:47:05.372+00	2025-10-05 09:47:05.372+00	6
1316	up	167	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:47:14.385+00	2025-10-05 09:47:14.385+00	3
1317	up	215	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:47:14.833+00	2025-10-05 09:47:14.833+00	5
1318	up	1247	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:47:24.469+00	2025-10-05 09:47:24.469+00	1
1319	up	213	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:47:49.825+00	2025-10-05 09:47:49.825+00	4
1320	up	210	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:47:55.515+00	2025-10-05 09:47:55.515+00	7
1321	up	263	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:48:05.381+00	2025-10-05 09:48:05.381+00	6
1322	up	135	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:48:14.354+00	2025-10-05 09:48:14.354+00	3
1323	up	206	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:48:14.823+00	2025-10-05 09:48:14.823+00	5
1324	up	790	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:48:24.014+00	2025-10-05 09:48:24.014+00	1
1325	up	425	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:48:50.039+00	2025-10-05 09:48:50.039+00	4
1326	up	224	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:48:55.542+00	2025-10-05 09:48:55.542+00	7
1327	up	247	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:49:05.364+00	2025-10-05 09:49:05.364+00	6
1328	up	193	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:49:14.414+00	2025-10-05 09:49:14.414+00	3
1329	up	206	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:49:14.827+00	2025-10-05 09:49:14.827+00	5
1330	up	856	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:49:24.081+00	2025-10-05 09:49:24.081+00	1
1331	up	266	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:49:49.905+00	2025-10-05 09:49:49.905+00	4
1332	up	170	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:49:55.486+00	2025-10-05 09:49:55.486+00	7
1333	up	273	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:50:05.391+00	2025-10-05 09:50:05.391+00	6
1334	up	282	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:50:14.504+00	2025-10-05 09:50:14.504+00	3
1335	up	234	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:50:14.855+00	2025-10-05 09:50:14.855+00	5
1336	up	5859	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:50:29.086+00	2025-10-05 09:50:29.086+00	1
1337	up	284	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:50:49.943+00	2025-10-05 09:50:49.943+00	4
1338	up	242	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:50:55.562+00	2025-10-05 09:50:55.562+00	7
1339	up	181	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:51:05.307+00	2025-10-05 09:51:05.307+00	6
1340	up	280	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:51:14.511+00	2025-10-05 09:51:14.511+00	3
1341	up	261	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:51:14.891+00	2025-10-05 09:51:14.891+00	5
1342	up	917	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:51:24.147+00	2025-10-05 09:51:24.147+00	1
1343	up	1514	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:51:51.164+00	2025-10-05 09:51:51.164+00	4
1344	up	183	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:51:55.501+00	2025-10-05 09:51:55.501+00	7
1345	up	254	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:52:05.385+00	2025-10-05 09:52:05.385+00	6
1346	up	283	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:52:14.518+00	2025-10-05 09:52:14.518+00	3
1347	up	379	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:52:15.011+00	2025-10-05 09:52:15.011+00	5
1348	up	787	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:52:24.017+00	2025-10-05 09:52:24.017+00	1
1349	up	386	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:52:50.031+00	2025-10-05 09:52:50.031+00	4
1350	up	165	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:52:55.481+00	2025-10-05 09:52:55.481+00	7
1351	up	248	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:53:05.377+00	2025-10-05 09:53:05.377+00	6
1352	up	308	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:53:14.549+00	2025-10-05 09:53:14.549+00	3
1353	up	427	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:53:15.091+00	2025-10-05 09:53:15.091+00	5
1354	up	804	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:53:24.033+00	2025-10-05 09:53:24.033+00	1
1355	up	295	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:53:49.952+00	2025-10-05 09:53:49.952+00	4
1356	up	352	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:53:55.682+00	2025-10-05 09:53:55.682+00	7
1357	up	205	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:54:05.336+00	2025-10-05 09:54:05.336+00	6
1358	up	248	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:54:14.478+00	2025-10-05 09:54:14.478+00	3
1359	up	225	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:54:14.885+00	2025-10-05 09:54:14.885+00	5
1360	up	770	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:54:24+00	2025-10-05 09:54:24+00	1
1361	up	308	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:54:49.951+00	2025-10-05 09:54:49.951+00	4
1362	up	319	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:54:55.643+00	2025-10-05 09:54:55.643+00	7
1363	up	195	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:55:05.335+00	2025-10-05 09:55:05.335+00	6
1364	up	178	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:55:14.406+00	2025-10-05 09:55:14.406+00	3
1365	up	281	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:55:14.932+00	2025-10-05 09:55:14.932+00	5
1366	up	772	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:55:24.003+00	2025-10-05 09:55:24.003+00	1
1367	up	208	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:55:49.85+00	2025-10-05 09:55:49.85+00	4
1368	up	183	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:55:55.51+00	2025-10-05 09:55:55.51+00	7
1369	up	292	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:56:05.433+00	2025-10-05 09:56:05.433+00	6
1370	up	157	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:56:14.385+00	2025-10-05 09:56:14.385+00	3
1371	up	138	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:56:14.789+00	2025-10-05 09:56:14.789+00	5
1372	up	859	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:56:24.091+00	2025-10-05 09:56:24.091+00	1
1373	up	236	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:56:49.881+00	2025-10-05 09:56:49.881+00	4
1374	up	157	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:56:55.486+00	2025-10-05 09:56:55.486+00	7
1375	up	181	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:57:05.315+00	2025-10-05 09:57:05.315+00	6
1376	up	373	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:57:14.602+00	2025-10-05 09:57:14.602+00	3
1377	up	303	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:57:14.96+00	2025-10-05 09:57:14.96+00	5
1378	up	948	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:57:24.183+00	2025-10-05 09:57:24.183+00	1
1379	up	306	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:57:50.125+00	2025-10-05 09:57:50.125+00	4
1380	up	152	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:57:55.661+00	2025-10-05 09:57:55.661+00	7
1381	up	175	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:58:05.492+00	2025-10-05 09:58:05.492+00	6
1382	up	185	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:58:14.615+00	2025-10-05 09:58:14.615+00	3
1383	up	249	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:58:15.096+00	2025-10-05 09:58:15.096+00	5
1384	up	814	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:58:24.232+00	2025-10-05 09:58:24.232+00	1
1385	up	242	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:58:50.063+00	2025-10-05 09:58:50.063+00	4
1386	up	175	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:58:55.687+00	2025-10-05 09:58:55.687+00	7
1387	up	274	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:59:05.609+00	2025-10-05 09:59:05.609+00	6
1388	up	169	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 09:59:14.595+00	2025-10-05 09:59:14.595+00	3
1389	up	221	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:59:15.081+00	2025-10-05 09:59:15.081+00	5
1390	up	884	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 09:59:24.302+00	2025-10-05 09:59:24.302+00	1
1391	up	539	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 09:59:50.377+00	2025-10-05 09:59:50.377+00	4
1392	up	719	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 09:59:56.233+00	2025-10-05 09:59:56.233+00	7
1393	up	174	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:00:05.495+00	2025-10-05 10:00:05.495+00	6
1394	up	159	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:00:14.587+00	2025-10-05 10:00:14.587+00	3
1395	up	214	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:00:15.07+00	2025-10-05 10:00:15.07+00	5
1396	up	1000	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:00:24.419+00	2025-10-05 10:00:24.419+00	1
1397	up	352	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:00:50.198+00	2025-10-05 10:00:50.198+00	4
1398	up	187	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:00:55.699+00	2025-10-05 10:00:55.699+00	7
1399	up	139	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:01:05.463+00	2025-10-05 10:01:05.463+00	6
1400	up	291	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:01:14.747+00	2025-10-05 10:01:14.747+00	3
1401	up	223	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:01:15.087+00	2025-10-05 10:01:15.087+00	5
1402	up	979	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:01:24.401+00	2025-10-05 10:01:24.401+00	1
1403	up	316	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:01:50.154+00	2025-10-05 10:01:50.154+00	4
1404	up	197	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:01:55.709+00	2025-10-05 10:01:55.709+00	7
1405	up	280	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:02:05.619+00	2025-10-05 10:02:05.619+00	6
1406	up	320	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:02:14.763+00	2025-10-05 10:02:14.763+00	3
1407	up	181	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:02:15.041+00	2025-10-05 10:02:15.041+00	5
1408	up	888	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:02:24.309+00	2025-10-05 10:02:24.309+00	1
1409	up	268	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:02:50.087+00	2025-10-05 10:02:50.087+00	4
1410	up	245	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:02:55.76+00	2025-10-05 10:02:55.76+00	7
1411	up	196	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:03:05.534+00	2025-10-05 10:03:05.534+00	6
1412	up	162	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:03:14.604+00	2025-10-05 10:03:14.604+00	3
1413	up	251	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:03:15.118+00	2025-10-05 10:03:15.118+00	5
1414	up	922	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:03:24.353+00	2025-10-05 10:03:24.353+00	1
1415	up	365	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:03:50.23+00	2025-10-05 10:03:50.23+00	4
1416	up	319	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:03:55.839+00	2025-10-05 10:03:55.839+00	7
1417	up	171	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:04:05.513+00	2025-10-05 10:04:05.513+00	6
1418	up	289	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:04:14.754+00	2025-10-05 10:04:14.754+00	3
1419	up	263	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:04:15.146+00	2025-10-05 10:04:15.146+00	5
1420	up	791	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:04:24.227+00	2025-10-05 10:04:24.227+00	1
1421	up	263	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:04:50.118+00	2025-10-05 10:04:50.118+00	4
1422	up	222	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:04:55.74+00	2025-10-05 10:04:55.74+00	7
1423	up	175	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:05:05.524+00	2025-10-05 10:05:05.524+00	6
1424	up	132	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:05:14.593+00	2025-10-05 10:05:14.593+00	3
1425	up	233	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:05:15.112+00	2025-10-05 10:05:15.112+00	5
1426	up	894	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:05:24.331+00	2025-10-05 10:05:24.331+00	1
1427	up	360	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:05:50.244+00	2025-10-05 10:05:50.244+00	4
1428	up	147	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:05:55.666+00	2025-10-05 10:05:55.666+00	7
1429	up	242	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:06:05.596+00	2025-10-05 10:06:05.596+00	6
1430	up	440	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:06:14.924+00	2025-10-05 10:06:14.924+00	3
1431	up	474	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:06:15.368+00	2025-10-05 10:06:15.368+00	5
1432	up	960	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:06:24.399+00	2025-10-05 10:06:24.399+00	1
1433	up	479	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:06:50.379+00	2025-10-05 10:06:50.379+00	4
1434	up	240	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:06:55.764+00	2025-10-05 10:06:55.764+00	7
1435	up	313	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:07:05.669+00	2025-10-05 10:07:05.669+00	6
1436	up	1262	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:07:15.762+00	2025-10-05 10:07:15.762+00	3
1437	up	1337	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:07:16.241+00	2025-10-05 10:07:16.241+00	5
1438	up	1858	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:07:25.297+00	2025-10-05 10:07:25.297+00	1
1439	up	342	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:07:50.236+00	2025-10-05 10:07:50.236+00	4
1440	up	295	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:07:55.826+00	2025-10-05 10:07:55.826+00	7
1441	up	365	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:08:05.714+00	2025-10-05 10:08:05.714+00	6
1442	up	262	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:08:14.737+00	2025-10-05 10:08:14.737+00	3
1443	up	243	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:08:15.144+00	2025-10-05 10:08:15.144+00	5
1444	up	791	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:08:24.231+00	2025-10-05 10:08:24.231+00	1
1445	up	424	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:08:50.339+00	2025-10-05 10:08:50.339+00	4
1446	up	226	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:08:55.75+00	2025-10-05 10:08:55.75+00	7
1447	up	294	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:09:05.653+00	2025-10-05 10:09:05.653+00	6
1448	up	349	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:09:14.847+00	2025-10-05 10:09:14.847+00	3
1449	up	470	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:09:15.373+00	2025-10-05 10:09:15.373+00	5
1450	up	979	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:09:24.423+00	2025-10-05 10:09:24.423+00	1
1451	up	296	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:09:50.192+00	2025-10-05 10:09:50.192+00	4
1452	up	226	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:09:55.754+00	2025-10-05 10:09:55.754+00	7
1453	up	180	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:10:05.528+00	2025-10-05 10:10:05.528+00	6
1454	up	158	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:10:14.643+00	2025-10-05 10:10:14.643+00	3
1455	up	160	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:10:15.057+00	2025-10-05 10:10:15.057+00	5
1456	up	770	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:10:24.214+00	2025-10-05 10:10:24.214+00	1
1457	up	210	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:10:50.099+00	2025-10-05 10:10:50.099+00	4
1458	up	310	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:10:55.835+00	2025-10-05 10:10:55.835+00	7
1459	up	5219	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:11:10.57+00	2025-10-05 10:11:10.57+00	6
1460	up	285	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:11:14.773+00	2025-10-05 10:11:14.773+00	3
1461	up	429	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:11:15.355+00	2025-10-05 10:11:15.355+00	5
1462	up	10213	200	Website is up (PING fallback successful) [PING (fallback)]	2025-10-05 10:11:33.657+00	2025-10-05 10:11:33.657+00	1
1463	up	235	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:11:50.118+00	2025-10-05 10:11:50.118+00	4
1464	up	202	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:11:55.725+00	2025-10-05 10:11:55.725+00	7
1465	up	150	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:12:05.501+00	2025-10-05 10:12:05.501+00	6
1466	up	134	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:12:14.617+00	2025-10-05 10:12:14.617+00	3
1467	up	202	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:12:15.101+00	2025-10-05 10:12:15.101+00	5
1468	up	870	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:12:24.317+00	2025-10-05 10:12:24.317+00	1
1469	up	245	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:12:50.126+00	2025-10-05 10:12:50.126+00	4
1470	up	487	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:12:56.016+00	2025-10-05 10:12:56.016+00	7
1471	up	130	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:13:05.486+00	2025-10-05 10:13:05.486+00	6
1472	up	228	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:13:14.718+00	2025-10-05 10:13:14.718+00	3
1473	up	300	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:13:15.209+00	2025-10-05 10:13:15.209+00	5
1474	up	1196	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:13:24.643+00	2025-10-05 10:13:24.643+00	1
1475	up	193	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:13:50.085+00	2025-10-05 10:13:50.085+00	4
1476	up	162	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:13:55.688+00	2025-10-05 10:13:55.688+00	7
1477	up	344	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:14:05.705+00	2025-10-05 10:14:05.705+00	6
1478	up	262	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:14:14.756+00	2025-10-05 10:14:14.756+00	3
1479	up	277	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:14:15.187+00	2025-10-05 10:14:15.187+00	5
1480	up	6073	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:14:29.521+00	2025-10-05 10:14:29.521+00	1
1481	up	423	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:14:50.386+00	2025-10-05 10:14:50.386+00	4
1482	up	239	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:14:55.779+00	2025-10-05 10:14:55.779+00	7
1483	up	327	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:15:05.698+00	2025-10-05 10:15:05.698+00	6
1484	up	161	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:15:14.648+00	2025-10-05 10:15:14.648+00	3
1485	up	194	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:15:15.097+00	2025-10-05 10:15:15.097+00	5
1486	up	872	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:15:24.322+00	2025-10-05 10:15:24.322+00	1
1487	up	303	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:15:50.207+00	2025-10-05 10:15:50.207+00	4
1488	up	300	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:15:55.836+00	2025-10-05 10:15:55.836+00	7
1489	up	174	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:16:05.535+00	2025-10-05 10:16:05.535+00	6
1490	up	208	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:16:14.712+00	2025-10-05 10:16:14.712+00	3
1491	up	199	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:16:15.137+00	2025-10-05 10:16:15.137+00	5
1492	up	892	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:16:24.343+00	2025-10-05 10:16:24.343+00	1
1493	up	236	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:16:50.12+00	2025-10-05 10:16:50.12+00	4
1494	up	215	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:16:55.754+00	2025-10-05 10:16:55.754+00	7
1495	up	243	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:17:05.613+00	2025-10-05 10:17:05.613+00	6
1496	up	314	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:17:14.81+00	2025-10-05 10:17:14.81+00	3
1497	up	138	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:17:15.067+00	2025-10-05 10:17:15.067+00	5
1498	up	1169	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:17:24.622+00	2025-10-05 10:17:24.622+00	1
1499	up	306	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:17:50.203+00	2025-10-05 10:17:50.203+00	4
1500	up	270	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:17:55.823+00	2025-10-05 10:17:55.823+00	7
1501	up	212	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:18:05.584+00	2025-10-05 10:18:05.584+00	6
1502	up	234	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:18:14.729+00	2025-10-05 10:18:14.729+00	3
1503	up	245	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:18:15.171+00	2025-10-05 10:18:15.171+00	5
1504	up	843	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:18:24.298+00	2025-10-05 10:18:24.298+00	1
1505	up	398	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:18:50.33+00	2025-10-05 10:18:50.33+00	4
1506	up	178	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:18:55.721+00	2025-10-05 10:18:55.721+00	7
1507	up	212	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:19:05.577+00	2025-10-05 10:19:05.577+00	6
1508	up	372	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:19:14.868+00	2025-10-05 10:19:14.868+00	3
1509	up	480	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:19:15.417+00	2025-10-05 10:19:15.417+00	5
1510	up	859	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:19:24.317+00	2025-10-05 10:19:24.317+00	1
1511	up	181	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:19:55.733+00	2025-10-05 10:19:55.733+00	7
1512	up	367	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:20:05.751+00	2025-10-05 10:20:05.751+00	6
1513	up	137	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:20:14.635+00	2025-10-05 10:20:14.635+00	3
1514	up	191	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:20:15.123+00	2025-10-05 10:20:15.123+00	5
1515	up	759	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:20:24.217+00	2025-10-05 10:20:24.217+00	1
1516	up	35879	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:20:25.769+00	2025-10-05 10:20:25.769+00	4
1517	up	1011	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:20:50.963+00	2025-10-05 10:20:50.963+00	4
1518	up	399	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:20:55.963+00	2025-10-05 10:20:55.963+00	7
1519	up	250	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:21:05.636+00	2025-10-05 10:21:05.636+00	6
1520	up	161	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:21:15.091+00	2025-10-05 10:21:15.091+00	5
1521	up	1193	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:21:15.69+00	2025-10-05 10:21:15.69+00	3
1522	up	967	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:21:24.432+00	2025-10-05 10:21:24.432+00	1
1523	up	242	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:21:50.197+00	2025-10-05 10:21:50.197+00	4
1524	up	209	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:21:55.756+00	2025-10-05 10:21:55.756+00	7
1525	up	402	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:22:05.787+00	2025-10-05 10:22:05.787+00	6
1526	up	197	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:22:14.695+00	2025-10-05 10:22:14.695+00	3
1527	up	201	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:22:15.138+00	2025-10-05 10:22:15.138+00	5
1528	up	1051	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:22:24.519+00	2025-10-05 10:22:24.519+00	1
1529	up	414	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:22:50.38+00	2025-10-05 10:22:50.38+00	4
1530	up	165	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:22:55.718+00	2025-10-05 10:22:55.718+00	7
1531	up	268	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:23:05.664+00	2025-10-05 10:23:05.664+00	6
1532	up	179	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:23:14.677+00	2025-10-05 10:23:14.677+00	3
1533	up	175	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:23:15.107+00	2025-10-05 10:23:15.107+00	5
1534	up	845	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:23:24.313+00	2025-10-05 10:23:24.313+00	1
1535	up	347	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:23:50.291+00	2025-10-05 10:23:50.291+00	4
1536	up	499	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:23:56.073+00	2025-10-05 10:23:56.073+00	7
1537	up	288	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:24:05.687+00	2025-10-05 10:24:05.687+00	6
1538	up	268	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:24:14.771+00	2025-10-05 10:24:14.771+00	3
1539	up	358	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:24:15.315+00	2025-10-05 10:24:15.315+00	5
1540	up	896	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:24:24.374+00	2025-10-05 10:24:24.374+00	1
1541	up	632	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:24:50.605+00	2025-10-05 10:24:50.605+00	4
1542	up	305	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:24:55.877+00	2025-10-05 10:24:55.877+00	7
1543	up	249	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:25:05.65+00	2025-10-05 10:25:05.65+00	6
1544	up	265	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:25:14.772+00	2025-10-05 10:25:14.772+00	3
1545	up	225	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:25:15.201+00	2025-10-05 10:25:15.201+00	5
1546	up	806	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:25:24.286+00	2025-10-05 10:25:24.286+00	1
1547	up	296	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:25:50.254+00	2025-10-05 10:25:50.254+00	4
1548	up	320	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:25:55.893+00	2025-10-05 10:25:55.893+00	7
1549	up	234	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:26:05.628+00	2025-10-05 10:26:05.628+00	6
1550	up	184	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:26:14.694+00	2025-10-05 10:26:14.694+00	3
1551	up	196	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:26:15.167+00	2025-10-05 10:26:15.167+00	5
1552	up	940	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:26:24.42+00	2025-10-05 10:26:24.42+00	1
1553	up	289	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:26:50.242+00	2025-10-05 10:26:50.242+00	4
1554	up	401	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:26:55.973+00	2025-10-05 10:26:55.973+00	7
1555	up	236	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:27:05.66+00	2025-10-05 10:27:05.66+00	6
1556	up	150	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:27:14.659+00	2025-10-05 10:27:14.659+00	3
1557	up	197	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:27:15.169+00	2025-10-05 10:27:15.169+00	5
1558	up	934	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:27:24.43+00	2025-10-05 10:27:24.43+00	1
1559	up	217	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:27:50.177+00	2025-10-05 10:27:50.177+00	4
1560	up	238	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:27:55.81+00	2025-10-05 10:27:55.81+00	7
1561	up	207	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:28:05.608+00	2025-10-05 10:28:05.608+00	6
1562	up	216	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:28:14.729+00	2025-10-05 10:28:14.729+00	3
1563	up	260	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:28:15.242+00	2025-10-05 10:28:15.242+00	5
1564	up	1051	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:28:24.549+00	2025-10-05 10:28:24.549+00	1
1565	up	217	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:28:50.153+00	2025-10-05 10:28:50.153+00	4
1566	up	209	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:28:55.778+00	2025-10-05 10:28:55.778+00	7
1567	up	233	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:29:05.665+00	2025-10-05 10:29:05.665+00	6
1568	up	219	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:29:14.731+00	2025-10-05 10:29:14.731+00	3
1569	up	440	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:29:15.433+00	2025-10-05 10:29:15.433+00	5
1570	up	876	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:29:24.376+00	2025-10-05 10:29:24.376+00	1
1571	up	380	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:29:50.345+00	2025-10-05 10:29:50.345+00	4
1572	up	191	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:29:55.79+00	2025-10-05 10:29:55.79+00	7
1573	up	166	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:30:05.603+00	2025-10-05 10:30:05.603+00	6
1574	up	238	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:30:14.751+00	2025-10-05 10:30:14.751+00	3
1575	up	476	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:30:15.479+00	2025-10-05 10:30:15.479+00	5
1576	up	934	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:30:24.435+00	2025-10-05 10:30:24.435+00	1
1577	up	1291	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:30:51.299+00	2025-10-05 10:30:51.299+00	4
1578	up	256	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:30:55.859+00	2025-10-05 10:30:55.859+00	7
1579	up	321	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:31:05.766+00	2025-10-05 10:31:05.766+00	6
1580	up	150	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:31:14.665+00	2025-10-05 10:31:14.665+00	3
1581	up	178	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:31:15.164+00	2025-10-05 10:31:15.164+00	5
1582	up	1148	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:31:24.653+00	2025-10-05 10:31:24.653+00	1
1583	up	227	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:31:50.238+00	2025-10-05 10:31:50.238+00	4
1584	up	193	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:31:55.822+00	2025-10-05 10:31:55.822+00	7
1585	up	327	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:32:05.782+00	2025-10-05 10:32:05.782+00	6
1586	up	167	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:32:14.678+00	2025-10-05 10:32:14.678+00	3
1587	up	5296	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:32:20.298+00	2025-10-05 10:32:20.298+00	5
1588	up	805	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:32:24.31+00	2025-10-05 10:32:24.31+00	1
1589	up	1292	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:32:51.285+00	2025-10-05 10:32:51.285+00	4
1590	up	193	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:32:55.815+00	2025-10-05 10:32:55.815+00	7
1591	up	207	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:33:05.651+00	2025-10-05 10:33:05.651+00	6
1592	up	186	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:33:14.697+00	2025-10-05 10:33:14.697+00	3
1593	up	191	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:33:15.195+00	2025-10-05 10:33:15.195+00	5
1594	up	1020	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:33:24.869+00	2025-10-05 10:33:24.869+00	1
1595	up	340	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:33:50.636+00	2025-10-05 10:33:50.636+00	4
1596	up	241	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:33:56.201+00	2025-10-05 10:33:56.201+00	7
1597	up	234	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:34:06.01+00	2025-10-05 10:34:06.01+00	6
1598	up	421	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:34:15.297+00	2025-10-05 10:34:15.297+00	3
1599	up	334	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:34:15.729+00	2025-10-05 10:34:15.729+00	5
1600	up	924	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:34:24.773+00	2025-10-05 10:34:24.773+00	1
1601	up	306	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:34:50.632+00	2025-10-05 10:34:50.632+00	4
1602	up	173	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:34:56.135+00	2025-10-05 10:34:56.135+00	7
1603	up	219	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:35:06.002+00	2025-10-05 10:35:06.002+00	6
1604	up	349	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:35:15.223+00	2025-10-05 10:35:15.223+00	3
1605	up	429	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:35:15.81+00	2025-10-05 10:35:15.81+00	5
1606	up	892	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:35:24.757+00	2025-10-05 10:35:24.757+00	1
1607	up	319	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:35:50.626+00	2025-10-05 10:35:50.626+00	4
1608	up	270	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:35:56.239+00	2025-10-05 10:35:56.239+00	7
1609	up	365	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:36:06.185+00	2025-10-05 10:36:06.185+00	6
1610	up	183	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:36:15.065+00	2025-10-05 10:36:15.065+00	3
1611	up	253	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:36:15.627+00	2025-10-05 10:36:15.627+00	5
1612	up	744	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:36:24.613+00	2025-10-05 10:36:24.613+00	1
1613	up	669	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:36:51.003+00	2025-10-05 10:36:51.003+00	4
1614	up	324	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:36:56.311+00	2025-10-05 10:36:56.311+00	7
1615	up	261	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:37:06.047+00	2025-10-05 10:37:06.047+00	6
1616	up	164	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:37:15.043+00	2025-10-05 10:37:15.043+00	3
1617	up	230	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:37:15.604+00	2025-10-05 10:37:15.604+00	5
1618	up	902	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:37:24.791+00	2025-10-05 10:37:24.791+00	1
1619	up	290	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:37:50.609+00	2025-10-05 10:37:50.609+00	4
1620	up	261	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:37:56.252+00	2025-10-05 10:37:56.252+00	7
1621	up	255	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:38:06.04+00	2025-10-05 10:38:06.04+00	6
1622	up	450	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:38:15.347+00	2025-10-05 10:38:15.347+00	3
1623	up	337	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:38:15.781+00	2025-10-05 10:38:15.781+00	5
1624	up	899	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:38:24.788+00	2025-10-05 10:38:24.788+00	1
1625	up	365	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:38:50.696+00	2025-10-05 10:38:50.696+00	4
1626	up	164	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:38:56.151+00	2025-10-05 10:38:56.151+00	7
1627	up	214	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:39:06.008+00	2025-10-05 10:39:06.008+00	6
1628	up	257	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:39:15.14+00	2025-10-05 10:39:15.14+00	3
1629	up	220	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:39:15.613+00	2025-10-05 10:39:15.613+00	5
1630	up	5925	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:39:29.833+00	2025-10-05 10:39:29.833+00	1
1631	up	325	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:39:50.665+00	2025-10-05 10:39:50.665+00	4
1632	up	160	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:39:56.154+00	2025-10-05 10:39:56.154+00	7
1633	up	250	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:40:06.036+00	2025-10-05 10:40:06.036+00	6
1634	up	151	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:40:15.03+00	2025-10-05 10:40:15.03+00	3
1635	up	174	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:40:15.564+00	2025-10-05 10:40:15.564+00	5
1636	up	918	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:40:24.83+00	2025-10-05 10:40:24.83+00	1
1637	up	497	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:40:50.848+00	2025-10-05 10:40:50.848+00	4
1638	up	441	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:40:56.445+00	2025-10-05 10:40:56.445+00	7
1639	up	316	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:41:06.123+00	2025-10-05 10:41:06.123+00	6
1640	up	296	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:41:15.182+00	2025-10-05 10:41:15.182+00	3
1641	up	267	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:41:15.663+00	2025-10-05 10:41:15.663+00	5
1642	up	868	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:41:24.779+00	2025-10-05 10:41:24.779+00	1
1643	up	870	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:41:51.199+00	2025-10-05 10:41:51.199+00	4
1644	up	211	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:41:56.211+00	2025-10-05 10:41:56.211+00	7
1645	up	685	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:42:06.487+00	2025-10-05 10:42:06.487+00	6
1646	up	356	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:42:15.243+00	2025-10-05 10:42:15.243+00	3
1647	up	321	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:42:15.713+00	2025-10-05 10:42:15.713+00	5
1648	up	980	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:42:24.895+00	2025-10-05 10:42:24.895+00	1
1649	up	3331	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:42:53.7+00	2025-10-05 10:42:53.7+00	4
1650	up	250	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:42:56.249+00	2025-10-05 10:42:56.249+00	7
1651	up	233	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:43:06.026+00	2025-10-05 10:43:06.026+00	6
1652	up	232	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:43:15.119+00	2025-10-05 10:43:15.119+00	3
1653	up	314	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:43:15.711+00	2025-10-05 10:43:15.711+00	5
1654	up	856	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:43:24.772+00	2025-10-05 10:43:24.772+00	1
1655	up	375	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:43:50.727+00	2025-10-05 10:43:50.727+00	4
1656	up	234	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:43:56.243+00	2025-10-05 10:43:56.243+00	7
1657	up	240	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:44:06.042+00	2025-10-05 10:44:06.042+00	6
1658	up	1224	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:44:18.157+00	2025-10-05 10:44:18.157+00	3
1659	up	1213	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:44:18.518+00	2025-10-05 10:44:18.518+00	5
1660	up	803	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:44:24.746+00	2025-10-05 10:44:24.746+00	1
1661	up	1130	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:44:51.484+00	2025-10-05 10:44:51.484+00	4
1662	up	371	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:44:56.401+00	2025-10-05 10:44:56.401+00	7
1663	up	2110	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:45:08.024+00	2025-10-05 10:45:08.024+00	6
1664	up	315	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:45:15.821+00	2025-10-05 10:45:15.821+00	5
1665	up	520	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:45:15.974+00	2025-10-05 10:45:15.974+00	3
1666	up	779	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:45:24.724+00	2025-10-05 10:45:24.724+00	1
1667	up	257	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:45:50.597+00	2025-10-05 10:45:50.597+00	4
1668	up	233	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:45:56.248+00	2025-10-05 10:45:56.248+00	7
1669	up	305	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:46:06.168+00	2025-10-05 10:46:06.168+00	6
1670	up	413	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:46:15.926+00	2025-10-05 10:46:15.926+00	5
1671	up	482	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:46:15.947+00	2025-10-05 10:46:15.947+00	3
1672	up	963	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:46:24.909+00	2025-10-05 10:46:24.909+00	1
1673	up	2482	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:46:52.84+00	2025-10-05 10:46:52.84+00	4
1674	up	183	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:46:56.243+00	2025-10-05 10:46:56.243+00	7
1675	up	303	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:47:06.155+00	2025-10-05 10:47:06.155+00	6
1676	up	296	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:47:15.752+00	2025-10-05 10:47:15.752+00	3
1677	up	297	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:47:15.809+00	2025-10-05 10:47:15.809+00	5
1678	up	979	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:47:24.925+00	2025-10-05 10:47:24.925+00	1
1679	up	442	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:47:50.883+00	2025-10-05 10:47:50.883+00	4
1680	up	246	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:47:56.294+00	2025-10-05 10:47:56.294+00	7
1681	up	212	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:48:06.079+00	2025-10-05 10:48:06.079+00	6
1682	up	424	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:48:15.879+00	2025-10-05 10:48:15.879+00	3
1683	up	501	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:48:16.029+00	2025-10-05 10:48:16.029+00	5
1684	up	893	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:48:24.842+00	2025-10-05 10:48:24.842+00	1
1685	up	300	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:48:50.75+00	2025-10-05 10:48:50.75+00	4
1686	up	321	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:48:56.368+00	2025-10-05 10:48:56.368+00	7
1687	up	193	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:49:06.059+00	2025-10-05 10:49:06.059+00	6
1688	up	172	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:49:15.635+00	2025-10-05 10:49:15.635+00	3
1689	up	285	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:49:15.794+00	2025-10-05 10:49:15.794+00	5
1690	up	785	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:49:24.736+00	2025-10-05 10:49:24.736+00	1
1691	up	287	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:49:50.639+00	2025-10-05 10:49:50.639+00	4
1692	up	158	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:49:56.199+00	2025-10-05 10:49:56.199+00	7
1693	up	105	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:50:05.965+00	2025-10-05 10:50:05.965+00	6
1694	up	133	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:50:15.591+00	2025-10-05 10:50:15.591+00	3
1695	up	206	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:50:15.726+00	2025-10-05 10:50:15.726+00	5
1696	up	1107	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:50:25.06+00	2025-10-05 10:50:25.06+00	1
1697	up	167	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:50:50.509+00	2025-10-05 10:50:50.509+00	4
1698	up	119	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:50:56.161+00	2025-10-05 10:50:56.161+00	7
1699	up	256	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:51:06.118+00	2025-10-05 10:51:06.118+00	6
1700	up	179	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:51:15.688+00	2025-10-05 10:51:15.688+00	5
1701	up	259	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:51:15.717+00	2025-10-05 10:51:15.717+00	3
1702	up	6268	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:51:30.221+00	2025-10-05 10:51:30.221+00	1
1703	up	178	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:51:50.52+00	2025-10-05 10:51:50.52+00	4
1704	up	113	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:51:56.156+00	2025-10-05 10:51:56.156+00	7
1705	up	121	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:52:05.982+00	2025-10-05 10:52:05.982+00	6
1706	up	160	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:52:15.617+00	2025-10-05 10:52:15.617+00	3
1707	up	360	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:52:15.874+00	2025-10-05 10:52:15.874+00	5
1708	up	830	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:52:24.785+00	2025-10-05 10:52:24.785+00	1
1709	up	193	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:52:50.54+00	2025-10-05 10:52:50.54+00	4
1710	up	172	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:52:56.214+00	2025-10-05 10:52:56.214+00	7
1711	up	144	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:53:06.01+00	2025-10-05 10:53:06.01+00	6
1712	up	115	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:53:15.571+00	2025-10-05 10:53:15.571+00	3
1713	up	185	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:53:15.696+00	2025-10-05 10:53:15.696+00	5
1714	up	748	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:53:24.704+00	2025-10-05 10:53:24.704+00	1
1715	up	158	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:53:50.508+00	2025-10-05 10:53:50.508+00	4
1716	up	129	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:53:56.175+00	2025-10-05 10:53:56.175+00	7
1717	up	167	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:54:06.039+00	2025-10-05 10:54:06.039+00	6
1718	up	136	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:54:15.597+00	2025-10-05 10:54:15.597+00	3
1719	up	185	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:54:15.7+00	2025-10-05 10:54:15.7+00	5
1720	up	781	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:54:24.737+00	2025-10-05 10:54:24.737+00	1
1721	up	221	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:54:50.565+00	2025-10-05 10:54:50.565+00	4
1722	up	111	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:54:56.155+00	2025-10-05 10:54:56.155+00	7
1723	up	126	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:55:05.991+00	2025-10-05 10:55:05.991+00	6
1724	up	124	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:55:15.585+00	2025-10-05 10:55:15.585+00	3
1725	up	138	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:55:15.662+00	2025-10-05 10:55:15.662+00	5
1726	up	751	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:55:24.708+00	2025-10-05 10:55:24.708+00	1
1727	up	250	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:55:50.597+00	2025-10-05 10:55:50.597+00	4
1728	up	164	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:55:56.235+00	2025-10-05 10:55:56.235+00	7
1729	up	142	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:56:06.011+00	2025-10-05 10:56:06.011+00	6
1730	up	184	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:56:15.648+00	2025-10-05 10:56:15.648+00	3
1731	up	179	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:56:15.707+00	2025-10-05 10:56:15.707+00	5
1732	up	910	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:56:24.868+00	2025-10-05 10:56:24.868+00	1
1733	up	234	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:56:50.596+00	2025-10-05 10:56:50.596+00	4
1734	up	196	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:56:56.25+00	2025-10-05 10:56:56.25+00	7
1735	up	217	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:57:06.086+00	2025-10-05 10:57:06.086+00	6
1736	up	1377	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:57:16.882+00	2025-10-05 10:57:16.882+00	3
1737	up	2478	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:57:18.031+00	2025-10-05 10:57:18.031+00	5
1738	up	1062	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:57:25.022+00	2025-10-05 10:57:25.022+00	1
1739	up	586	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:57:50.946+00	2025-10-05 10:57:50.946+00	4
1740	up	187	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:57:56.242+00	2025-10-05 10:57:56.242+00	7
1741	up	231	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:58:06.099+00	2025-10-05 10:58:06.099+00	6
1742	up	193	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:58:15.735+00	2025-10-05 10:58:15.735+00	5
1743	up	545	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:58:16.019+00	2025-10-05 10:58:16.019+00	3
1744	up	920	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:58:24.88+00	2025-10-05 10:58:24.88+00	1
1745	up	316	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:58:50.666+00	2025-10-05 10:58:50.666+00	4
1746	up	132	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:58:56.185+00	2025-10-05 10:58:56.185+00	7
1747	up	230	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:59:06.099+00	2025-10-05 10:59:06.099+00	6
1748	up	197	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 10:59:15.669+00	2025-10-05 10:59:15.669+00	3
1749	up	193	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:59:15.73+00	2025-10-05 10:59:15.73+00	5
1750	up	799	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 10:59:24.761+00	2025-10-05 10:59:24.761+00	1
1751	up	239	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 10:59:50.603+00	2025-10-05 10:59:50.603+00	4
1752	up	171	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 10:59:56.226+00	2025-10-05 10:59:56.226+00	7
1753	up	320	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:00:06.189+00	2025-10-05 11:00:06.189+00	6
1754	up	215	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:00:15.693+00	2025-10-05 11:00:15.693+00	3
1755	up	287	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:00:15.833+00	2025-10-05 11:00:15.833+00	5
1756	up	6096	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:00:30.06+00	2025-10-05 11:00:30.06+00	1
1757	up	352	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:00:50.723+00	2025-10-05 11:00:50.723+00	4
1758	up	178	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:00:56.23+00	2025-10-05 11:00:56.23+00	7
1759	up	294	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:01:06.167+00	2025-10-05 11:01:06.167+00	6
1760	up	348	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:01:15.825+00	2025-10-05 11:01:15.825+00	3
1761	up	302	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:01:15.897+00	2025-10-05 11:01:15.897+00	5
1762	up	796	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:01:24.761+00	2025-10-05 11:01:24.761+00	1
1763	up	687	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:01:51.049+00	2025-10-05 11:01:51.049+00	4
1764	up	231	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:01:56.285+00	2025-10-05 11:01:56.285+00	7
1765	up	234	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:02:06.106+00	2025-10-05 11:02:06.106+00	6
1766	up	212	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:02:15.689+00	2025-10-05 11:02:15.689+00	3
1767	up	222	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:02:15.771+00	2025-10-05 11:02:15.771+00	5
1768	up	938	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:02:24.904+00	2025-10-05 11:02:24.904+00	1
1769	up	744	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:02:51.113+00	2025-10-05 11:02:51.113+00	4
1770	up	161	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:02:56.216+00	2025-10-05 11:02:56.216+00	7
1771	up	176	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:03:06.047+00	2025-10-05 11:03:06.047+00	6
1772	up	230	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:03:15.706+00	2025-10-05 11:03:15.706+00	3
1773	up	267	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:03:15.824+00	2025-10-05 11:03:15.824+00	5
1774	up	1303	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:03:25.27+00	2025-10-05 11:03:25.27+00	1
1775	up	423	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:03:50.792+00	2025-10-05 11:03:50.792+00	4
1776	up	231	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:03:56.29+00	2025-10-05 11:03:56.29+00	7
1777	up	5316	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:04:11.192+00	2025-10-05 11:04:11.192+00	6
1778	up	158	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:04:15.64+00	2025-10-05 11:04:15.64+00	3
1779	up	187	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:04:15.754+00	2025-10-05 11:04:15.754+00	5
1780	up	826	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:04:24.793+00	2025-10-05 11:04:24.793+00	1
1781	up	374	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:04:50.743+00	2025-10-05 11:04:50.743+00	4
1782	up	330	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:04:56.391+00	2025-10-05 11:04:56.391+00	7
1783	up	215	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:05:06.092+00	2025-10-05 11:05:06.092+00	6
1784	up	223	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:05:15.706+00	2025-10-05 11:05:15.706+00	3
1785	up	242	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:05:15.822+00	2025-10-05 11:05:15.822+00	5
1786	up	823	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:05:24.79+00	2025-10-05 11:05:24.79+00	1
1787	up	269	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:05:56.338+00	2025-10-05 11:05:56.338+00	7
1788	up	207	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:06:06.085+00	2025-10-05 11:06:06.085+00	6
1789	up	292	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:06:15.777+00	2025-10-05 11:06:15.777+00	3
1790	up	373	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:06:15.952+00	2025-10-05 11:06:15.952+00	5
1791	down	33572	500	Unexpected status code: 500 [CUSTOM CURL]	2025-10-05 11:06:23.956+00	2025-10-05 11:06:23.956+00	4
1792	up	1824	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:06:25.795+00	2025-10-05 11:06:25.795+00	1
1793	down	180	404	Unexpected status code: 404 [CUSTOM CURL]	2025-10-05 11:06:50.558+00	2025-10-05 11:06:50.558+00	4
1794	up	181	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:06:56.242+00	2025-10-05 11:06:56.242+00	7
1795	up	190	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:07:06.066+00	2025-10-05 11:07:06.066+00	6
1796	up	230	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:07:15.718+00	2025-10-05 11:07:15.718+00	3
1797	up	212	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:07:15.794+00	2025-10-05 11:07:15.794+00	5
1798	up	928	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:07:24.9+00	2025-10-05 11:07:24.9+00	1
1799	down	161	404	Unexpected status code: 404 [CUSTOM CURL]	2025-10-05 11:07:50.532+00	2025-10-05 11:07:50.532+00	4
1800	up	174	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:07:56.235+00	2025-10-05 11:07:56.235+00	7
1801	up	248	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:08:06.128+00	2025-10-05 11:08:06.128+00	6
1802	up	351	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:08:15.843+00	2025-10-05 11:08:15.843+00	3
1803	up	387	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:08:15.981+00	2025-10-05 11:08:15.981+00	5
1804	up	959	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:08:24.931+00	2025-10-05 11:08:24.931+00	1
1805	down	140	404	Unexpected status code: 404 [CUSTOM CURL]	2025-10-05 11:08:50.507+00	2025-10-05 11:08:50.507+00	4
1806	up	182	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:08:56.25+00	2025-10-05 11:08:56.25+00	7
1807	up	273	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:09:06.477+00	2025-10-05 11:09:06.477+00	6
1808	up	200	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:09:16.008+00	2025-10-05 11:09:16.008+00	3
1809	up	215	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:09:16.13+00	2025-10-05 11:09:16.13+00	5
1810	up	1070	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:09:25.37+00	2025-10-05 11:09:25.37+00	1
1811	down	226	404	Unexpected status code: 404 [CUSTOM CURL]	2025-10-05 11:09:50.984+00	2025-10-05 11:09:50.984+00	4
1812	up	140	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:09:56.532+00	2025-10-05 11:09:56.532+00	7
1813	up	168	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:10:06.372+00	2025-10-05 11:10:06.372+00	6
1814	up	267	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:10:16.084+00	2025-10-05 11:10:16.084+00	3
1815	up	270	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:10:16.188+00	2025-10-05 11:10:16.188+00	5
1816	up	785	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:10:25.084+00	2025-10-05 11:10:25.084+00	1
1817	down	129	404	Unexpected status code: 404 [CUSTOM CURL]	2025-10-05 11:10:50.826+00	2025-10-05 11:10:50.826+00	4
1818	up	290	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:10:56.68+00	2025-10-05 11:10:56.68+00	7
1819	up	152	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:11:06.357+00	2025-10-05 11:11:06.357+00	6
1820	up	189	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:11:16.008+00	2025-10-05 11:11:16.008+00	3
1821	up	368	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:11:16.305+00	2025-10-05 11:11:16.305+00	5
1822	up	901	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:11:25.201+00	2025-10-05 11:11:25.201+00	1
1823	down	190	404	Unexpected status code: 404 [CUSTOM CURL]	2025-10-05 11:11:50.904+00	2025-10-05 11:11:50.904+00	4
1824	up	140	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:11:56.536+00	2025-10-05 11:11:56.536+00	7
1825	up	149	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:12:06.355+00	2025-10-05 11:12:06.355+00	6
1826	up	168	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:12:15.993+00	2025-10-05 11:12:15.993+00	3
1827	up	233	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:12:16.16+00	2025-10-05 11:12:16.16+00	5
1828	up	771	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:12:25.073+00	2025-10-05 11:12:25.073+00	1
1829	down	184	404	Unexpected status code: 404 [CUSTOM CURL]	2025-10-05 11:12:50.889+00	2025-10-05 11:12:50.889+00	4
1830	up	381	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:12:56.789+00	2025-10-05 11:12:56.789+00	7
1831	up	204	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:13:06.417+00	2025-10-05 11:13:06.417+00	6
1832	up	195	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:13:16.023+00	2025-10-05 11:13:16.023+00	3
1833	up	5271	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:13:21.206+00	2025-10-05 11:13:21.206+00	5
1834	up	5858	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:13:30.161+00	2025-10-05 11:13:30.161+00	1
1835	down	165	404	Unexpected status code: 404 [CUSTOM CURL]	2025-10-05 11:13:50.878+00	2025-10-05 11:13:50.878+00	4
1836	up	213	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:13:56.609+00	2025-10-05 11:13:56.609+00	7
1837	up	218	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:14:06.431+00	2025-10-05 11:14:06.431+00	6
1838	up	148	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:14:15.969+00	2025-10-05 11:14:15.969+00	3
1839	up	149	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:14:16.073+00	2025-10-05 11:14:16.073+00	5
1840	up	748	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:14:25.052+00	2025-10-05 11:14:25.052+00	1
1841	down	178	404	Unexpected status code: 404 [CUSTOM CURL]	2025-10-05 11:14:50.896+00	2025-10-05 11:14:50.896+00	4
1842	up	224	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:14:56.627+00	2025-10-05 11:14:56.627+00	7
1843	up	152	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:15:06.366+00	2025-10-05 11:15:06.366+00	6
1844	up	202	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:15:16.025+00	2025-10-05 11:15:16.025+00	3
1845	up	259	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:15:16.208+00	2025-10-05 11:15:16.208+00	5
1846	up	937	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:15:25.241+00	2025-10-05 11:15:25.241+00	1
1847	down	171	503	Unexpected status code: 503 [CUSTOM CURL]	2025-10-05 11:15:50.88+00	2025-10-05 11:15:50.88+00	4
1848	up	190	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:15:56.592+00	2025-10-05 11:15:56.592+00	7
1849	up	164	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:16:06.384+00	2025-10-05 11:16:06.384+00	6
1850	up	223	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:16:16.052+00	2025-10-05 11:16:16.052+00	3
1851	up	225	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:16:16.173+00	2025-10-05 11:16:16.173+00	5
1852	up	843	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:16:25.148+00	2025-10-05 11:16:25.148+00	1
1853	up	428	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:16:51.141+00	2025-10-05 11:16:51.141+00	4
1854	up	249	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:16:56.646+00	2025-10-05 11:16:56.646+00	7
1855	up	231	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:17:06.454+00	2025-10-05 11:17:06.454+00	6
1856	up	314	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:17:16.264+00	2025-10-05 11:17:16.264+00	5
1857	up	447	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:17:16.279+00	2025-10-05 11:17:16.279+00	3
1858	up	1029	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:17:25.34+00	2025-10-05 11:17:25.34+00	1
1859	up	252	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:17:50.955+00	2025-10-05 11:17:50.955+00	4
1860	up	381	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:17:56.781+00	2025-10-05 11:17:56.781+00	7
1861	up	451	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:18:06.686+00	2025-10-05 11:18:06.686+00	6
1862	up	674	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:18:16.524+00	2025-10-05 11:18:16.524+00	3
1863	up	815	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:18:16.81+00	2025-10-05 11:18:16.81+00	5
1864	up	1185	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:18:25.526+00	2025-10-05 11:18:25.526+00	1
1865	up	553	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:18:51.288+00	2025-10-05 11:18:51.288+00	4
1866	up	229	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:18:56.632+00	2025-10-05 11:18:56.632+00	7
1867	up	310	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:19:06.543+00	2025-10-05 11:19:06.543+00	6
1868	up	351	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:19:16.187+00	2025-10-05 11:19:16.187+00	3
1869	up	301	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:19:16.287+00	2025-10-05 11:19:16.287+00	5
1870	up	887	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:19:25.228+00	2025-10-05 11:19:25.228+00	1
1871	up	313	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:19:51.065+00	2025-10-05 11:19:51.065+00	4
1872	up	312	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:19:56.733+00	2025-10-05 11:19:56.733+00	7
1873	up	253	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:20:06.482+00	2025-10-05 11:20:06.482+00	6
1874	up	188	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:20:16.022+00	2025-10-05 11:20:16.022+00	3
1875	up	260	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:20:16.225+00	2025-10-05 11:20:16.225+00	5
1876	up	942	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:20:25.284+00	2025-10-05 11:20:25.284+00	1
1877	up	313	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:20:51.078+00	2025-10-05 11:20:51.078+00	4
1878	up	247	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:20:56.666+00	2025-10-05 11:20:56.666+00	7
1879	up	213	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:21:06.445+00	2025-10-05 11:21:06.445+00	6
1880	up	308	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:21:16.149+00	2025-10-05 11:21:16.149+00	3
1881	up	300	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:21:16.283+00	2025-10-05 11:21:16.283+00	5
1882	up	1045	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:21:25.39+00	2025-10-05 11:21:25.39+00	1
1883	up	432	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:21:51.173+00	2025-10-05 11:21:51.173+00	4
1884	up	406	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:21:56.832+00	2025-10-05 11:21:56.832+00	7
1885	up	397	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:22:06.639+00	2025-10-05 11:22:06.639+00	6
1886	up	347	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:22:16.189+00	2025-10-05 11:22:16.189+00	3
1887	up	350	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:22:16.323+00	2025-10-05 11:22:16.323+00	5
1888	up	877	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:22:25.222+00	2025-10-05 11:22:25.222+00	1
1889	up	332	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:22:51.067+00	2025-10-05 11:22:51.067+00	4
1890	up	296	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:22:56.724+00	2025-10-05 11:22:56.724+00	7
1891	up	268	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:23:06.501+00	2025-10-05 11:23:06.501+00	6
1892	up	303	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:23:16.145+00	2025-10-05 11:23:16.145+00	3
1893	up	432	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:23:16.409+00	2025-10-05 11:23:16.409+00	5
1894	up	908	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:23:25.26+00	2025-10-05 11:23:25.26+00	1
1895	up	380	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:23:51.136+00	2025-10-05 11:23:51.136+00	4
1896	up	259	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:23:56.688+00	2025-10-05 11:23:56.688+00	7
1897	up	243	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:24:06.474+00	2025-10-05 11:24:06.474+00	6
1898	up	401	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:24:16.246+00	2025-10-05 11:24:16.246+00	3
1899	up	370	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:24:16.349+00	2025-10-05 11:24:16.349+00	5
1900	up	856	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:24:25.205+00	2025-10-05 11:24:25.205+00	1
1901	up	423	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:24:51.2+00	2025-10-05 11:24:51.2+00	4
1902	up	402	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:24:56.83+00	2025-10-05 11:24:56.83+00	7
1903	up	270	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:25:06.503+00	2025-10-05 11:25:06.503+00	6
1904	up	268	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:25:16.114+00	2025-10-05 11:25:16.114+00	3
1905	up	288	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:25:16.28+00	2025-10-05 11:25:16.28+00	5
1906	up	1040	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:25:25.39+00	2025-10-05 11:25:25.39+00	1
1907	up	311	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:25:51.063+00	2025-10-05 11:25:51.063+00	4
1908	up	287	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:25:56.738+00	2025-10-05 11:25:56.738+00	7
1909	up	232	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:26:06.471+00	2025-10-05 11:26:06.471+00	6
1910	up	224	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:26:16.065+00	2025-10-05 11:26:16.065+00	3
1911	up	233	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:26:16.216+00	2025-10-05 11:26:16.216+00	5
1912	up	894	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:26:25.25+00	2025-10-05 11:26:25.25+00	1
1913	up	254	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:26:51.02+00	2025-10-05 11:26:51.02+00	4
1914	up	238	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:26:56.686+00	2025-10-05 11:26:56.686+00	7
1915	up	309	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:27:06.554+00	2025-10-05 11:27:06.554+00	6
1916	up	566	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:27:16.418+00	2025-10-05 11:27:16.418+00	3
1917	up	568	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:27:16.564+00	2025-10-05 11:27:16.564+00	5
1918	up	991	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:27:25.349+00	2025-10-05 11:27:25.349+00	1
1919	up	302	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:27:51.122+00	2025-10-05 11:27:51.122+00	4
1920	up	213	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:27:56.648+00	2025-10-05 11:27:56.648+00	7
1921	up	496	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:28:06.789+00	2025-10-05 11:28:06.789+00	6
1922	up	409	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:28:16.271+00	2025-10-05 11:28:16.271+00	3
1923	up	495	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:28:16.492+00	2025-10-05 11:28:16.492+00	5
1924	up	905	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:28:25.264+00	2025-10-05 11:28:25.264+00	1
1925	up	277	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:28:51.035+00	2025-10-05 11:28:51.035+00	4
1926	up	393	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:28:56.863+00	2025-10-05 11:28:56.863+00	7
1927	up	211	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:29:06.464+00	2025-10-05 11:29:06.464+00	6
1928	up	277	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:29:16.143+00	2025-10-05 11:29:16.143+00	3
1929	up	411	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:29:16.414+00	2025-10-05 11:29:16.414+00	5
1930	up	796	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:29:25.159+00	2025-10-05 11:29:25.159+00	1
1931	up	351	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:29:51.134+00	2025-10-05 11:29:51.134+00	4
1932	up	418	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:29:56.87+00	2025-10-05 11:29:56.87+00	7
1933	up	312	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:30:06.586+00	2025-10-05 11:30:06.586+00	6
1934	up	515	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:30:16.402+00	2025-10-05 11:30:16.402+00	3
1935	up	454	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:30:16.49+00	2025-10-05 11:30:16.49+00	5
1936	up	1070	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:30:25.434+00	2025-10-05 11:30:25.434+00	1
1937	up	372	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:30:51.138+00	2025-10-05 11:30:51.138+00	4
1938	up	246	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:30:56.702+00	2025-10-05 11:30:56.702+00	7
1939	up	328	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:31:06.583+00	2025-10-05 11:31:06.583+00	6
1940	up	228	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:31:16.093+00	2025-10-05 11:31:16.093+00	3
1941	up	349	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:31:16.352+00	2025-10-05 11:31:16.352+00	5
1942	up	896	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:31:25.26+00	2025-10-05 11:31:25.26+00	1
1943	up	303	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:31:51.083+00	2025-10-05 11:31:51.083+00	4
1944	up	303	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:31:56.754+00	2025-10-05 11:31:56.754+00	7
1945	up	322	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:32:06.585+00	2025-10-05 11:32:06.585+00	6
1946	up	184	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:32:16.05+00	2025-10-05 11:32:16.05+00	3
1947	up	267	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:32:16.276+00	2025-10-05 11:32:16.276+00	5
1948	up	875	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:32:25.24+00	2025-10-05 11:32:25.24+00	1
1949	up	300	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:32:51.075+00	2025-10-05 11:32:51.075+00	4
1950	up	187	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:32:56.641+00	2025-10-05 11:32:56.641+00	7
1951	up	248	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:33:06.503+00	2025-10-05 11:33:06.503+00	6
1952	up	350	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:33:16.217+00	2025-10-05 11:33:16.217+00	3
1953	up	447	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:33:16.459+00	2025-10-05 11:33:16.459+00	5
1954	up	968	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:33:25.333+00	2025-10-05 11:33:25.333+00	1
1955	up	289	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:33:51.057+00	2025-10-05 11:33:51.057+00	4
1956	up	308	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:33:56.782+00	2025-10-05 11:33:56.782+00	7
1957	up	248	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:34:06.515+00	2025-10-05 11:34:06.515+00	6
1958	up	230	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:34:16.099+00	2025-10-05 11:34:16.099+00	3
1959	up	268	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:34:16.279+00	2025-10-05 11:34:16.279+00	5
1960	up	976	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:34:25.345+00	2025-10-05 11:34:25.345+00	1
1961	up	319	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:34:51.091+00	2025-10-05 11:34:51.091+00	4
1962	up	391	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:34:56.862+00	2025-10-05 11:34:56.862+00	7
1963	up	345	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:35:06.618+00	2025-10-05 11:35:06.618+00	6
1964	up	265	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:35:16.142+00	2025-10-05 11:35:16.142+00	3
1965	up	256	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:35:16.273+00	2025-10-05 11:35:16.273+00	5
1966	up	837	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:35:25.213+00	2025-10-05 11:35:25.213+00	1
1967	up	339	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:35:51.133+00	2025-10-05 11:35:51.133+00	4
1968	up	224	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:35:56.686+00	2025-10-05 11:35:56.686+00	7
1969	up	212	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:36:06.476+00	2025-10-05 11:36:06.476+00	6
1970	up	1816	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:36:18.025+00	2025-10-05 11:36:18.025+00	3
1971	up	3069	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:36:19.388+00	2025-10-05 11:36:19.388+00	5
1972	up	885	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:36:25.256+00	2025-10-05 11:36:25.256+00	1
1973	up	332	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:36:51.13+00	2025-10-05 11:36:51.13+00	4
1974	up	192	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:36:56.654+00	2025-10-05 11:36:56.654+00	7
1975	up	451	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:37:06.713+00	2025-10-05 11:37:06.713+00	6
1976	up	239	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:37:16.223+00	2025-10-05 11:37:16.223+00	3
1977	up	303	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:37:16.381+00	2025-10-05 11:37:16.381+00	5
1978	up	940	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:37:25.317+00	2025-10-05 11:37:25.317+00	1
1979	up	308	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:37:51.088+00	2025-10-05 11:37:51.088+00	4
1980	up	188	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:37:56.651+00	2025-10-05 11:37:56.651+00	7
1981	up	207	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:38:06.468+00	2025-10-05 11:38:06.468+00	6
1982	up	318	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:38:16.301+00	2025-10-05 11:38:16.301+00	3
1983	up	413	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:38:16.466+00	2025-10-05 11:38:16.466+00	5
1984	up	895	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:38:25.29+00	2025-10-05 11:38:25.29+00	1
1985	up	310	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:38:51.113+00	2025-10-05 11:38:51.113+00	4
1986	up	319	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:38:56.782+00	2025-10-05 11:38:56.782+00	7
1987	up	294	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:39:06.568+00	2025-10-05 11:39:06.568+00	6
1988	up	376	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:39:16.441+00	2025-10-05 11:39:16.441+00	5
1989	up	504	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:39:16.488+00	2025-10-05 11:39:16.488+00	3
1990	up	1047	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:39:25.446+00	2025-10-05 11:39:25.446+00	1
1991	up	221	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:39:50.998+00	2025-10-05 11:39:50.998+00	4
1992	up	307	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:39:56.773+00	2025-10-05 11:39:56.773+00	7
1993	up	192	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:40:06.456+00	2025-10-05 11:40:06.456+00	6
1994	up	172	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:40:16.154+00	2025-10-05 11:40:16.154+00	3
1995	up	201	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:40:16.254+00	2025-10-05 11:40:16.254+00	5
1996	up	865	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:40:25.265+00	2025-10-05 11:40:25.265+00	1
1997	up	228	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:40:50.991+00	2025-10-05 11:40:50.991+00	4
1998	up	268	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:40:56.744+00	2025-10-05 11:40:56.744+00	7
1999	up	199	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:41:06.466+00	2025-10-05 11:41:06.466+00	6
2000	up	190	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:41:16.175+00	2025-10-05 11:41:16.175+00	3
2001	up	187	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:41:16.239+00	2025-10-05 11:41:16.239+00	5
2002	up	817	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:41:25.22+00	2025-10-05 11:41:25.22+00	1
2003	up	215	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:41:50.995+00	2025-10-05 11:41:50.995+00	4
2004	up	131	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:41:56.602+00	2025-10-05 11:41:56.602+00	7
2005	up	143	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:42:06.405+00	2025-10-05 11:42:06.405+00	6
2006	up	337	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:42:16.329+00	2025-10-05 11:42:16.329+00	3
2007	up	292	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:42:16.35+00	2025-10-05 11:42:16.35+00	5
2008	up	1478	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:42:25.883+00	2025-10-05 11:42:25.883+00	1
2009	up	370	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:42:51.138+00	2025-10-05 11:42:51.138+00	4
2010	up	174	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:42:56.654+00	2025-10-05 11:42:56.654+00	7
2011	up	5450	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:43:11.734+00	2025-10-05 11:43:11.734+00	6
2012	up	370	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:43:16.438+00	2025-10-05 11:43:16.438+00	5
2013	up	447	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:43:16.441+00	2025-10-05 11:43:16.441+00	3
2014	up	1138	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:43:25.62+00	2025-10-05 11:43:25.62+00	1
2015	up	536	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:43:51.307+00	2025-10-05 11:43:51.307+00	4
2016	up	142	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:43:56.623+00	2025-10-05 11:43:56.623+00	7
2017	up	314	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:44:06.597+00	2025-10-05 11:44:06.597+00	6
2018	up	183	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:44:16.174+00	2025-10-05 11:44:16.174+00	3
2019	up	243	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:44:16.3+00	2025-10-05 11:44:16.3+00	5
2020	up	735	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:44:25.219+00	2025-10-05 11:44:25.219+00	1
2021	up	256	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:44:51.038+00	2025-10-05 11:44:51.038+00	4
2022	up	265	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:44:56.75+00	2025-10-05 11:44:56.75+00	7
2023	up	179	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:45:06.458+00	2025-10-05 11:45:06.458+00	6
2024	up	163	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:45:16.157+00	2025-10-05 11:45:16.157+00	3
2025	up	240	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:45:16.308+00	2025-10-05 11:45:16.308+00	5
2026	up	903	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:45:25.388+00	2025-10-05 11:45:25.388+00	1
2027	up	270	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:45:51.041+00	2025-10-05 11:45:51.041+00	4
2028	up	158	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:45:56.643+00	2025-10-05 11:45:56.643+00	7
2029	up	276	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:46:06.553+00	2025-10-05 11:46:06.553+00	6
2030	up	160	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:46:16.153+00	2025-10-05 11:46:16.153+00	3
2031	up	169	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:46:16.236+00	2025-10-05 11:46:16.236+00	5
2032	up	726	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:46:25.215+00	2025-10-05 11:46:25.215+00	1
2033	up	212	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:46:50.991+00	2025-10-05 11:46:50.991+00	4
2034	up	232	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:46:56.725+00	2025-10-05 11:46:56.725+00	7
2035	up	272	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:47:06.553+00	2025-10-05 11:47:06.553+00	6
2036	up	174	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:47:16.169+00	2025-10-05 11:47:16.169+00	3
2037	up	185	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:47:16.25+00	2025-10-05 11:47:16.25+00	5
2038	up	815	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:47:25.304+00	2025-10-05 11:47:25.304+00	1
2039	up	401	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:47:51.204+00	2025-10-05 11:47:51.204+00	4
2040	up	204	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:47:56.691+00	2025-10-05 11:47:56.691+00	7
2041	up	138	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:48:06.418+00	2025-10-05 11:48:06.418+00	6
2042	up	193	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:48:16.189+00	2025-10-05 11:48:16.189+00	3
2043	up	225	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:48:16.293+00	2025-10-05 11:48:16.293+00	5
2044	up	807	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:48:25.297+00	2025-10-05 11:48:25.297+00	1
2045	up	189	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:48:50.986+00	2025-10-05 11:48:50.986+00	4
2046	up	140	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:48:56.628+00	2025-10-05 11:48:56.628+00	7
2047	up	130	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:49:06.41+00	2025-10-05 11:49:06.41+00	6
2048	up	253	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:49:16.254+00	2025-10-05 11:49:16.254+00	3
2049	up	204	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:49:16.279+00	2025-10-05 11:49:16.279+00	5
2050	up	917	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:49:25.408+00	2025-10-05 11:49:25.408+00	1
2051	up	278	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:49:51.071+00	2025-10-05 11:49:51.071+00	4
2052	up	164	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:49:56.659+00	2025-10-05 11:49:56.659+00	7
2053	up	201	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:50:06.49+00	2025-10-05 11:50:06.49+00	6
2054	up	204	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:50:16.205+00	2025-10-05 11:50:16.205+00	3
2055	up	235	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:50:16.33+00	2025-10-05 11:50:16.33+00	5
2056	up	821	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:50:25.314+00	2025-10-05 11:50:25.314+00	1
2057	up	241	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:50:51.049+00	2025-10-05 11:50:51.049+00	4
2058	up	138	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:50:56.633+00	2025-10-05 11:50:56.633+00	7
2059	up	159	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:51:06.443+00	2025-10-05 11:51:06.443+00	6
2060	up	204	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:51:16.204+00	2025-10-05 11:51:16.204+00	3
2061	up	289	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:51:16.37+00	2025-10-05 11:51:16.37+00	5
2062	up	860	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:51:25.357+00	2025-10-05 11:51:25.357+00	1
2063	up	235	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:51:51.054+00	2025-10-05 11:51:51.054+00	4
2064	up	156	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:51:56.652+00	2025-10-05 11:51:56.652+00	7
2065	up	150	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:52:06.437+00	2025-10-05 11:52:06.437+00	6
2066	up	167	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:52:16.167+00	2025-10-05 11:52:16.167+00	3
2067	up	204	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:52:16.284+00	2025-10-05 11:52:16.284+00	5
2068	up	817	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:52:25.314+00	2025-10-05 11:52:25.314+00	1
2069	up	189	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:52:50.986+00	2025-10-05 11:52:50.986+00	4
2070	up	280	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:52:56.778+00	2025-10-05 11:52:56.778+00	7
2071	up	224	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:53:06.517+00	2025-10-05 11:53:06.517+00	6
2072	up	296	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:53:16.314+00	2025-10-05 11:53:16.314+00	3
2073	up	5291	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:53:21.39+00	2025-10-05 11:53:21.39+00	5
2074	up	1090	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:53:25.593+00	2025-10-05 11:53:25.593+00	1
2075	up	360	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:53:51.214+00	2025-10-05 11:53:51.214+00	4
2076	up	226	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:53:56.727+00	2025-10-05 11:53:56.727+00	7
2077	up	196	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:54:06.485+00	2025-10-05 11:54:06.485+00	6
2078	up	176	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:54:16.186+00	2025-10-05 11:54:16.186+00	3
2079	up	204	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:54:16.306+00	2025-10-05 11:54:16.306+00	5
2080	up	799	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:54:25.308+00	2025-10-05 11:54:25.308+00	1
2081	up	170	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:54:50.988+00	2025-10-05 11:54:50.988+00	4
2082	up	227	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:54:56.751+00	2025-10-05 11:54:56.751+00	7
2083	up	212	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:55:06.503+00	2025-10-05 11:55:06.503+00	6
2084	up	137	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:55:16.148+00	2025-10-05 11:55:16.148+00	3
2085	up	176	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:55:16.27+00	2025-10-05 11:55:16.27+00	5
2086	up	831	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:55:25.345+00	2025-10-05 11:55:25.345+00	1
2087	up	220	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:55:51.041+00	2025-10-05 11:55:51.041+00	4
2088	up	130	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:55:56.63+00	2025-10-05 11:55:56.63+00	7
2089	up	163	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:56:06.454+00	2025-10-05 11:56:06.454+00	6
2090	up	126	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:56:16.138+00	2025-10-05 11:56:16.138+00	3
2091	up	154	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:56:16.244+00	2025-10-05 11:56:16.244+00	5
2092	up	2058	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:56:26.584+00	2025-10-05 11:56:26.584+00	1
2093	up	688	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:56:51.735+00	2025-10-05 11:56:51.735+00	4
2094	up	548	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:56:57.066+00	2025-10-05 11:56:57.066+00	7
2095	up	336	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:57:06.646+00	2025-10-05 11:57:06.646+00	6
2096	up	548	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:57:16.57+00	2025-10-05 11:57:16.57+00	3
2097	up	572	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:57:16.704+00	2025-10-05 11:57:16.704+00	5
2098	up	933	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:57:25.466+00	2025-10-05 11:57:25.466+00	1
2099	up	256	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:57:51.089+00	2025-10-05 11:57:51.089+00	4
2100	up	230	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:57:56.731+00	2025-10-05 11:57:56.731+00	7
2101	up	264	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:58:06.573+00	2025-10-05 11:58:06.573+00	6
2102	up	180	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:58:16.197+00	2025-10-05 11:58:16.197+00	3
2103	up	186	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:58:16.284+00	2025-10-05 11:58:16.284+00	5
2104	up	871	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:58:25.402+00	2025-10-05 11:58:25.402+00	1
2105	up	346	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:58:51.22+00	2025-10-05 11:58:51.22+00	4
2106	up	262	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:58:56.775+00	2025-10-05 11:58:56.775+00	7
2107	up	204	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:59:06.52+00	2025-10-05 11:59:06.52+00	6
2108	up	254	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 11:59:16.277+00	2025-10-05 11:59:16.277+00	3
2109	up	286	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:59:16.381+00	2025-10-05 11:59:16.381+00	5
2110	up	813	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 11:59:25.346+00	2025-10-05 11:59:25.346+00	1
2111	up	238	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 11:59:51.102+00	2025-10-05 11:59:51.102+00	4
2112	up	402	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 11:59:56.915+00	2025-10-05 11:59:56.915+00	7
2113	up	481	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:00:06.798+00	2025-10-05 12:00:06.798+00	6
2114	up	316	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 12:00:16.338+00	2025-10-05 12:00:16.338+00	3
2115	up	269	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:00:16.383+00	2025-10-05 12:00:16.383+00	5
2116	up	1006	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 12:00:25.552+00	2025-10-05 12:00:25.552+00	1
2117	up	305	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 12:00:51.189+00	2025-10-05 12:00:51.189+00	4
2118	up	206	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:00:56.727+00	2025-10-05 12:00:56.727+00	7
2119	up	238	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:01:06.556+00	2025-10-05 12:01:06.556+00	6
2120	up	229	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 12:01:16.274+00	2025-10-05 12:01:16.274+00	3
2121	up	262	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:01:16.374+00	2025-10-05 12:01:16.374+00	5
2122	up	832	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 12:01:25.38+00	2025-10-05 12:01:25.38+00	1
2123	up	256	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 12:01:51.106+00	2025-10-05 12:01:51.106+00	4
2124	up	246	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:01:56.771+00	2025-10-05 12:01:56.771+00	7
2125	up	261	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:02:06.573+00	2025-10-05 12:02:06.573+00	6
2126	up	224	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 12:02:16.248+00	2025-10-05 12:02:16.248+00	3
2127	up	208	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:02:16.305+00	2025-10-05 12:02:16.305+00	5
2128	up	810	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 12:02:25.358+00	2025-10-05 12:02:25.358+00	1
2129	up	225	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 12:02:51.093+00	2025-10-05 12:02:51.093+00	4
2130	up	252	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:02:56.775+00	2025-10-05 12:02:56.775+00	7
2131	up	237	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:03:06.558+00	2025-10-05 12:03:06.558+00	6
2132	up	228	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 12:03:16.253+00	2025-10-05 12:03:16.253+00	3
2133	up	398	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:03:16.501+00	2025-10-05 12:03:16.501+00	5
2134	up	933	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 12:03:25.483+00	2025-10-05 12:03:25.483+00	1
2135	up	273	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 12:03:51.147+00	2025-10-05 12:03:51.147+00	4
2136	up	194	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:03:56.728+00	2025-10-05 12:03:56.728+00	7
2137	up	226	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:04:06.541+00	2025-10-05 12:04:06.541+00	6
2138	up	303	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 12:04:16.33+00	2025-10-05 12:04:16.33+00	3
2139	up	379	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:04:16.5+00	2025-10-05 12:04:16.5+00	5
2140	up	1599	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 12:04:26.159+00	2025-10-05 12:04:26.159+00	1
2141	up	274	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 12:04:51.175+00	2025-10-05 12:04:51.175+00	4
2142	up	601	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:04:57.173+00	2025-10-05 12:04:57.173+00	7
2143	up	1233	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:05:07.574+00	2025-10-05 12:05:07.574+00	6
2144	up	508	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 12:05:16.641+00	2025-10-05 12:05:16.641+00	3
2145	up	516	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:05:16.754+00	2025-10-05 12:05:16.754+00	5
2146	up	971	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 12:05:25.53+00	2025-10-05 12:05:25.53+00	1
2147	up	386	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 12:05:51.281+00	2025-10-05 12:05:51.281+00	4
2148	up	172	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:05:56.725+00	2025-10-05 12:05:56.725+00	7
2149	up	260	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:06:06.585+00	2025-10-05 12:06:06.585+00	6
2150	up	279	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 12:06:16.4+00	2025-10-05 12:06:16.4+00	3
2151	up	230	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:06:16.45+00	2025-10-05 12:06:16.45+00	5
2152	up	819	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 12:06:25.38+00	2025-10-05 12:06:25.38+00	1
2153	up	368	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 12:06:51.286+00	2025-10-05 12:06:51.286+00	4
2154	up	974	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:06:57.557+00	2025-10-05 12:06:57.557+00	7
2155	up	429	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:07:06.756+00	2025-10-05 12:07:06.756+00	6
2156	up	308	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 12:07:16.421+00	2025-10-05 12:07:16.421+00	3
2157	up	250	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:07:16.464+00	2025-10-05 12:07:16.464+00	5
2158	up	917	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 12:07:25.478+00	2025-10-05 12:07:25.478+00	1
2159	up	413	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 12:07:51.329+00	2025-10-05 12:07:51.329+00	4
2160	up	241	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:07:56.785+00	2025-10-05 12:07:56.785+00	7
2161	up	299	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:08:06.626+00	2025-10-05 12:08:06.626+00	6
2162	up	294	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 12:08:16.411+00	2025-10-05 12:08:16.411+00	3
2163	up	233	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:08:16.444+00	2025-10-05 12:08:16.444+00	5
2164	up	946	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 12:08:25.511+00	2025-10-05 12:08:25.511+00	1
2165	up	189	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 12:08:51.093+00	2025-10-05 12:08:51.093+00	4
2166	up	331	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:08:56.885+00	2025-10-05 12:08:56.885+00	7
2167	up	243	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:09:06.579+00	2025-10-05 12:09:06.579+00	6
2168	up	260	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 12:09:16.377+00	2025-10-05 12:09:16.377+00	3
2169	up	311	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:09:16.522+00	2025-10-05 12:09:16.522+00	5
2170	up	831	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 12:09:25.408+00	2025-10-05 12:09:25.408+00	1
2171	up	524	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 12:09:51.48+00	2025-10-05 12:09:51.48+00	4
2172	up	203	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:09:56.751+00	2025-10-05 12:09:56.751+00	7
2173	up	449	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:10:06.788+00	2025-10-05 12:10:06.788+00	6
2174	up	858	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 12:10:17.089+00	2025-10-05 12:10:17.089+00	3
2175	up	796	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:10:17.192+00	2025-10-05 12:10:17.192+00	5
2176	up	803	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 12:10:25.38+00	2025-10-05 12:10:25.38+00	1
2177	up	446	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 12:10:51.372+00	2025-10-05 12:10:51.372+00	4
2178	up	330	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:10:56.884+00	2025-10-05 12:10:56.884+00	7
2179	up	254	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:11:06.601+00	2025-10-05 12:11:06.601+00	6
2180	up	296	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 12:11:16.472+00	2025-10-05 12:11:16.472+00	3
2181	up	301	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:11:16.614+00	2025-10-05 12:11:16.614+00	5
2182	up	850	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 12:11:25.427+00	2025-10-05 12:11:25.427+00	1
2183	up	647	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 12:11:51.577+00	2025-10-05 12:11:51.577+00	4
2184	up	311	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:11:56.865+00	2025-10-05 12:11:56.865+00	7
2185	up	324	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:12:06.68+00	2025-10-05 12:12:06.68+00	6
2186	up	266	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 12:12:16.436+00	2025-10-05 12:12:16.436+00	3
2187	up	307	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:12:16.616+00	2025-10-05 12:12:16.616+00	5
2188	up	1043	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 12:12:25.622+00	2025-10-05 12:12:25.622+00	1
2189	up	277	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 12:12:51.194+00	2025-10-05 12:12:51.194+00	4
2190	up	242	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:12:56.796+00	2025-10-05 12:12:56.796+00	7
2191	up	211	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:13:06.559+00	2025-10-05 12:13:06.559+00	6
2192	up	228	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 12:13:16.398+00	2025-10-05 12:13:16.398+00	3
2193	up	222	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:13:16.544+00	2025-10-05 12:13:16.544+00	5
2194	up	895	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 12:13:25.475+00	2025-10-05 12:13:25.475+00	1
2195	up	473	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 12:13:51.415+00	2025-10-05 12:13:51.415+00	4
2196	up	185	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:13:56.739+00	2025-10-05 12:13:56.739+00	7
2197	up	381	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:14:06.726+00	2025-10-05 12:14:06.726+00	6
2198	up	281	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 12:14:16.454+00	2025-10-05 12:14:16.454+00	3
2199	up	236	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:14:16.564+00	2025-10-05 12:14:16.564+00	5
2200	up	926	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 12:14:25.508+00	2025-10-05 12:14:25.508+00	1
2201	up	232	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 12:14:51.169+00	2025-10-05 12:14:51.169+00	4
2202	up	180	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:14:56.734+00	2025-10-05 12:14:56.734+00	7
2203	up	296	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:15:06.65+00	2025-10-05 12:15:06.65+00	6
2204	up	268	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 12:15:16.451+00	2025-10-05 12:15:16.451+00	3
2205	up	333	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:15:16.676+00	2025-10-05 12:15:16.676+00	5
2206	up	790	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 12:15:25.373+00	2025-10-05 12:15:25.373+00	1
2207	up	340	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 12:15:51.239+00	2025-10-05 12:15:51.239+00	4
2208	up	209	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:15:56.757+00	2025-10-05 12:15:56.757+00	7
2209	up	225	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:16:06.573+00	2025-10-05 12:16:06.573+00	6
2210	up	136	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 12:16:16.308+00	2025-10-05 12:16:16.308+00	3
2211	up	155	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:16:16.498+00	2025-10-05 12:16:16.498+00	5
2212	up	785	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 12:16:25.369+00	2025-10-05 12:16:25.369+00	1
2213	up	301	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 12:16:51.257+00	2025-10-05 12:16:51.257+00	4
2214	up	277	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:16:56.847+00	2025-10-05 12:16:56.847+00	7
2215	up	594	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:17:06.965+00	2025-10-05 12:17:06.965+00	6
2216	up	173	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 12:17:16.351+00	2025-10-05 12:17:16.351+00	3
2217	up	176	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:17:16.52+00	2025-10-05 12:17:16.52+00	5
2218	up	814	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 12:17:25.413+00	2025-10-05 12:17:25.413+00	1
2219	up	185	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 12:17:51.11+00	2025-10-05 12:17:51.11+00	4
2220	up	138	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:17:56.707+00	2025-10-05 12:17:56.707+00	7
2221	up	198	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:18:06.553+00	2025-10-05 12:18:06.553+00	6
2222	up	211	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 12:18:16.389+00	2025-10-05 12:18:16.389+00	3
2223	up	231	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:18:16.575+00	2025-10-05 12:18:16.575+00	5
2224	up	906	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 12:18:25.506+00	2025-10-05 12:18:25.506+00	1
2225	up	423	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 12:18:51.392+00	2025-10-05 12:18:51.392+00	4
2226	up	184	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:18:56.769+00	2025-10-05 12:18:56.769+00	7
2227	up	213	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:19:06.567+00	2025-10-05 12:19:06.567+00	6
2228	up	248	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 12:19:16.432+00	2025-10-05 12:19:16.432+00	3
2229	up	388	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:19:16.77+00	2025-10-05 12:19:16.77+00	5
2230	up	770	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 12:19:25.369+00	2025-10-05 12:19:25.369+00	1
2231	up	231	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-05 12:19:51.155+00	2025-10-05 12:19:51.155+00	4
2232	up	150	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:19:56.722+00	2025-10-05 12:19:56.722+00	7
2233	up	183	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:20:06.542+00	2025-10-05 12:20:06.542+00	6
2234	up	161	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-05 12:20:16.339+00	2025-10-05 12:20:16.339+00	3
2235	up	168	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-05 12:20:16.541+00	2025-10-05 12:20:16.541+00	5
2236	up	904	200	Website is up (HTTP 200) [HTTP GET]	2025-10-05 12:20:25.504+00	2025-10-05 12:20:25.504+00	1
2237	up	330	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 04:36:58.412+00	2025-10-06 04:36:58.412+00	4
2238	down	10026	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n [CURL GET]	2025-10-06 04:37:13.588+00	2025-10-06 04:37:13.588+00	7
2239	down	10032	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n [CURL GET]	2025-10-06 04:37:23.373+00	2025-10-06 04:37:23.373+00	6
2240	up	137	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 04:37:23.476+00	2025-10-06 04:37:23.476+00	5
2241	down	31	\N	HTTP failed and PING fallback also failed: getaddrinfo EAI_AGAIN google.com [PING (fallback)]	2025-10-06 04:37:31.616+00	2025-10-06 04:37:31.616+00	1
2242	down	10034	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-06 04:37:33.195+00	2025-10-06 04:37:33.195+00	3
2243	up	164	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 04:37:58.073+00	2025-10-06 04:37:58.073+00	4
2244	down	10029	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n [CURL GET]	2025-10-06 04:38:13.587+00	2025-10-06 04:38:13.587+00	7
2245	down	10029	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n [CURL GET]	2025-10-06 04:38:23.37+00	2025-10-06 04:38:23.37+00	6
2246	up	167	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 04:38:23.506+00	2025-10-06 04:38:23.506+00	5
2247	up	830	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 04:38:32.415+00	2025-10-06 04:38:32.415+00	1
2248	down	10040	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-06 04:38:33.205+00	2025-10-06 04:38:33.205+00	3
2249	up	1225	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 04:38:59.147+00	2025-10-06 04:38:59.147+00	4
2250	down	10042	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n [CURL GET]	2025-10-06 04:39:13.601+00	2025-10-06 04:39:13.601+00	7
2251	down	10050	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n [CURL GET]	2025-10-06 04:39:23.394+00	2025-10-06 04:39:23.394+00	6
2252	up	206	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 04:39:23.553+00	2025-10-06 04:39:23.553+00	5
2253	up	802	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 04:39:32.387+00	2025-10-06 04:39:32.387+00	1
2254	down	10050	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-06 04:39:33.22+00	2025-10-06 04:39:33.22+00	3
2255	up	252	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 04:39:58.183+00	2025-10-06 04:39:58.183+00	4
2256	down	10044	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n [CURL GET]	2025-10-06 04:40:13.604+00	2025-10-06 04:40:13.604+00	7
2257	down	10047	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n [CURL GET]	2025-10-06 04:40:23.392+00	2025-10-06 04:40:23.392+00	6
2258	up	249	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 04:40:23.592+00	2025-10-06 04:40:23.592+00	5
2259	up	852	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 04:40:32.438+00	2025-10-06 04:40:32.438+00	1
2260	down	10052	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-06 04:40:33.224+00	2025-10-06 04:40:33.224+00	3
2261	up	235	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 04:40:58.158+00	2025-10-06 04:40:58.158+00	4
2262	down	10034	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n [CURL GET]	2025-10-06 04:41:13.597+00	2025-10-06 04:41:13.597+00	7
2263	down	10031	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n [CURL GET]	2025-10-06 04:41:23.378+00	2025-10-06 04:41:23.378+00	6
2264	up	240	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 04:41:23.583+00	2025-10-06 04:41:23.583+00	5
2265	down	10035	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-06 04:41:33.202+00	2025-10-06 04:41:33.202+00	3
2266	up	7047	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 04:41:38.633+00	2025-10-06 04:41:38.633+00	1
2267	up	200	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 04:41:58.119+00	2025-10-06 04:41:58.119+00	4
2268	down	10036	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n [CURL GET]	2025-10-06 04:42:13.602+00	2025-10-06 04:42:13.602+00	7
2269	down	10031	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n [CURL GET]	2025-10-06 04:42:23.38+00	2025-10-06 04:42:23.38+00	6
2270	up	131	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 04:42:23.477+00	2025-10-06 04:42:23.477+00	5
2271	up	740	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 04:42:32.328+00	2025-10-06 04:42:32.328+00	1
2272	down	10027	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-06 04:42:33.195+00	2025-10-06 04:42:33.195+00	3
2273	up	1261	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 04:42:59.173+00	2025-10-06 04:42:59.173+00	4
2274	down	10031	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n [CURL GET]	2025-10-06 04:43:13.595+00	2025-10-06 04:43:13.595+00	7
2275	down	10039	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n [CURL GET]	2025-10-06 04:43:23.387+00	2025-10-06 04:43:23.387+00	6
2276	up	120	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 04:43:23.509+00	2025-10-06 04:43:23.509+00	5
2277	up	774	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 04:43:32.429+00	2025-10-06 04:43:32.429+00	1
2278	down	10020	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-06 04:43:33.404+00	2025-10-06 04:43:33.404+00	3
2279	up	390	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 04:43:58.342+00	2025-10-06 04:43:58.342+00	4
2280	down	10023	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n [CURL GET]	2025-10-06 04:44:13.59+00	2025-10-06 04:44:13.59+00	7
2281	down	10037	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n [CURL GET]	2025-10-06 04:44:23.387+00	2025-10-06 04:44:23.387+00	6
2282	up	103	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 04:44:23.482+00	2025-10-06 04:44:23.482+00	5
2283	up	795	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 04:44:32.452+00	2025-10-06 04:44:32.452+00	1
2284	down	10031	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-06 04:44:33.414+00	2025-10-06 04:44:33.414+00	3
2285	up	194	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 04:44:58.125+00	2025-10-06 04:44:58.125+00	4
2286	down	10021	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n [CURL GET]	2025-10-06 04:45:13.588+00	2025-10-06 04:45:13.588+00	7
2287	down	10027	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n [CURL GET]	2025-10-06 04:45:23.377+00	2025-10-06 04:45:23.377+00	6
2288	up	103	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 04:45:23.494+00	2025-10-06 04:45:23.494+00	5
2289	up	832	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 04:45:32.489+00	2025-10-06 04:45:32.489+00	1
2290	down	10025	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-06 04:45:33.411+00	2025-10-06 04:45:33.411+00	3
2291	down	10036	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n [CURL GET]	2025-10-06 04:46:13.602+00	2025-10-06 04:46:13.602+00	7
2292	down	10045	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n [CURL GET]	2025-10-06 04:46:23.402+00	2025-10-06 04:46:23.402+00	6
2293	up	152	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 04:46:23.537+00	2025-10-06 04:46:23.537+00	5
2294	up	791	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 04:46:32.448+00	2025-10-06 04:46:32.448+00	1
2295	down	10028	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-06 04:46:33.406+00	2025-10-06 04:46:33.406+00	3
2296	up	36663	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 04:46:34.586+00	2025-10-06 04:46:34.586+00	4
2297	up	181	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 04:46:58.109+00	2025-10-06 04:46:58.109+00	4
2298	down	10030	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n [CURL GET]	2025-10-06 04:47:13.599+00	2025-10-06 04:47:13.599+00	7
2299	down	10058	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n [CURL GET]	2025-10-06 04:47:23.414+00	2025-10-06 04:47:23.414+00	6
2300	up	311	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 04:47:23.71+00	2025-10-06 04:47:23.71+00	5
2301	up	864	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 04:47:32.522+00	2025-10-06 04:47:32.522+00	1
2302	down	10051	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-06 04:47:33.471+00	2025-10-06 04:47:33.471+00	3
2303	up	250	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 04:47:58.18+00	2025-10-06 04:47:58.18+00	4
2304	down	10034	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n [CURL GET]	2025-10-06 04:48:13.601+00	2025-10-06 04:48:13.601+00	7
2305	down	10034	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n [CURL GET]	2025-10-06 04:48:23.393+00	2025-10-06 04:48:23.393+00	6
2306	up	153	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 04:48:23.541+00	2025-10-06 04:48:23.541+00	5
2307	up	699	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 04:48:32.358+00	2025-10-06 04:48:32.358+00	1
2308	down	10030	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-06 04:48:33.411+00	2025-10-06 04:48:33.411+00	3
2309	up	204	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 04:48:58.147+00	2025-10-06 04:48:58.147+00	4
2310	down	10060	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n [CURL GET]	2025-10-06 04:49:13.636+00	2025-10-06 04:49:13.636+00	7
2311	down	10039	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n [CURL GET]	2025-10-06 04:49:23.397+00	2025-10-06 04:49:23.397+00	6
2312	up	177	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 04:49:23.57+00	2025-10-06 04:49:23.57+00	5
2313	up	847	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 04:49:32.52+00	2025-10-06 04:49:32.52+00	1
2314	down	10036	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-06 04:49:33.422+00	2025-10-06 04:49:33.422+00	3
2315	up	307	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 04:49:58.283+00	2025-10-06 04:49:58.283+00	4
2316	down	10046	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n [CURL GET]	2025-10-06 04:50:13.619+00	2025-10-06 04:50:13.619+00	7
2317	down	10142	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n [CURL GET]	2025-10-06 04:50:23.503+00	2025-10-06 04:50:23.503+00	6
2318	up	388	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 04:50:23.848+00	2025-10-06 04:50:23.848+00	5
2319	up	890	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 04:50:32.564+00	2025-10-06 04:50:32.564+00	1
2320	down	10137	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-06 04:50:33.56+00	2025-10-06 04:50:33.56+00	3
2321	up	279	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 04:50:58.235+00	2025-10-06 04:50:58.235+00	4
2322	down	10040	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n [CURL GET]	2025-10-06 04:51:13.615+00	2025-10-06 04:51:13.615+00	7
2323	down	10057	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n [CURL GET]	2025-10-06 04:51:23.421+00	2025-10-06 04:51:23.421+00	6
2324	up	144	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 04:51:23.558+00	2025-10-06 04:51:23.558+00	5
2325	up	762	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 04:51:32.437+00	2025-10-06 04:51:32.437+00	1
2326	down	10038	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-06 04:51:33.427+00	2025-10-06 04:51:33.427+00	3
2327	up	181	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 04:51:58.118+00	2025-10-06 04:51:58.118+00	4
2328	down	10031	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n [CURL GET]	2025-10-06 04:52:13.607+00	2025-10-06 04:52:13.607+00	7
2329	down	10030	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n [CURL GET]	2025-10-06 04:52:23.395+00	2025-10-06 04:52:23.395+00	6
2330	up	153	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 04:52:23.571+00	2025-10-06 04:52:23.571+00	5
2331	up	1214	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 04:52:32.89+00	2025-10-06 04:52:32.89+00	1
2332	down	10033	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-06 04:52:33.422+00	2025-10-06 04:52:33.422+00	3
2333	up	158	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 04:52:58.087+00	2025-10-06 04:52:58.087+00	4
2334	down	10034	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n [CURL GET]	2025-10-06 04:53:13.61+00	2025-10-06 04:53:13.61+00	7
2335	down	10173	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n [CURL GET]	2025-10-06 04:53:23.542+00	2025-10-06 04:53:23.542+00	6
2336	up	723	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 04:53:24.23+00	2025-10-06 04:53:24.23+00	5
2337	up	1338	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 04:53:33.042+00	2025-10-06 04:53:33.042+00	1
2338	down	10219	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-06 04:53:33.621+00	2025-10-06 04:53:33.621+00	3
2339	up	467	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 04:53:58.506+00	2025-10-06 04:53:58.506+00	4
2340	down	10117	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n [CURL GET]	2025-10-06 04:54:13.697+00	2025-10-06 04:54:13.697+00	7
2341	down	10133	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n [CURL GET]	2025-10-06 04:54:23.538+00	2025-10-06 04:54:23.538+00	6
2342	up	408	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 04:54:23.927+00	2025-10-06 04:54:23.927+00	5
2343	up	849	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 04:54:32.553+00	2025-10-06 04:54:32.553+00	1
2344	down	10066	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-06 04:54:33.473+00	2025-10-06 04:54:33.473+00	3
2345	up	146	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 04:54:58.074+00	2025-10-06 04:54:58.074+00	4
2346	down	10092	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n [CURL GET]	2025-10-06 04:55:13.686+00	2025-10-06 04:55:13.686+00	7
2347	down	10017	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n [CURL GET]	2025-10-06 04:55:23.394+00	2025-10-06 04:55:23.394+00	6
2348	up	144	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 04:55:23.62+00	2025-10-06 04:55:23.62+00	5
2349	up	749	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 04:55:32.452+00	2025-10-06 04:55:32.452+00	1
2350	down	10109	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-06 04:55:33.51+00	2025-10-06 04:55:33.51+00	3
2351	up	707	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 04:55:58.791+00	2025-10-06 04:55:58.791+00	4
2352	down	10061	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n [CURL GET]	2025-10-06 04:56:13.644+00	2025-10-06 04:56:13.644+00	7
2353	down	10063	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n [CURL GET]	2025-10-06 04:56:23.443+00	2025-10-06 04:56:23.443+00	6
2354	up	416	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 04:56:23.906+00	2025-10-06 04:56:23.906+00	5
2355	up	882	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 04:56:32.591+00	2025-10-06 04:56:32.591+00	1
2356	down	10230	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-06 04:56:33.648+00	2025-10-06 04:56:33.648+00	3
2357	up	1125	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 04:56:59.29+00	2025-10-06 04:56:59.29+00	4
2358	down	10414	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n [CURL GET]	2025-10-06 04:57:14.062+00	2025-10-06 04:57:14.062+00	7
2359	down	10298	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n [CURL GET]	2025-10-06 04:57:23.689+00	2025-10-06 04:57:23.689+00	6
2360	up	343	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 04:57:23.874+00	2025-10-06 04:57:23.874+00	5
2361	up	742	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 04:57:32.451+00	2025-10-06 04:57:32.451+00	1
2362	down	10246	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-06 04:57:33.657+00	2025-10-06 04:57:33.657+00	3
2363	up	1143	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 04:57:59.549+00	2025-10-06 04:57:59.549+00	4
2364	down	10228	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n [CURL GET]	2025-10-06 04:58:13.846+00	2025-10-06 04:58:13.846+00	7
2365	down	10183	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n [CURL GET]	2025-10-06 04:58:23.583+00	2025-10-06 04:58:23.583+00	6
2366	up	452	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 04:58:23.979+00	2025-10-06 04:58:23.979+00	5
2367	up	799	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 04:58:32.513+00	2025-10-06 04:58:32.513+00	1
2368	down	10089	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-06 04:58:33.504+00	2025-10-06 04:58:33.504+00	3
2369	up	5235	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 04:59:03.191+00	2025-10-06 04:59:03.191+00	4
2370	down	10045	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n [CURL GET]	2025-10-06 04:59:13.627+00	2025-10-06 04:59:13.627+00	7
2371	down	10072	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n [CURL GET]	2025-10-06 04:59:23.488+00	2025-10-06 04:59:23.488+00	6
2372	up	494	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 04:59:24.051+00	2025-10-06 04:59:24.051+00	5
2373	up	948	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 04:59:32.662+00	2025-10-06 04:59:32.662+00	1
2374	down	10082	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-06 04:59:33.511+00	2025-10-06 04:59:33.511+00	3
2375	up	173	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 04:59:58.108+00	2025-10-06 04:59:58.108+00	4
2376	down	10028	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n [CURL GET]	2025-10-06 05:00:13.613+00	2025-10-06 05:00:13.613+00	7
2377	down	10020	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n [CURL GET]	2025-10-06 05:00:23.407+00	2025-10-06 05:00:23.407+00	6
2378	up	124	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:00:23.65+00	2025-10-06 05:00:23.65+00	5
2379	up	868	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:00:32.582+00	2025-10-06 05:00:32.582+00	1
2380	down	10026	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-06 05:00:33.435+00	2025-10-06 05:00:33.435+00	3
2381	up	424	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:00:58.385+00	2025-10-06 05:00:58.385+00	4
2382	down	10051	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n [CURL GET]	2025-10-06 05:01:13.638+00	2025-10-06 05:01:13.638+00	7
2383	down	10038	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n [CURL GET]	2025-10-06 05:01:23.425+00	2025-10-06 05:01:23.425+00	6
2384	up	125	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:01:23.65+00	2025-10-06 05:01:23.65+00	5
2385	up	1167	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:01:32.882+00	2025-10-06 05:01:32.882+00	1
2386	down	10045	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-06 05:01:33.457+00	2025-10-06 05:01:33.457+00	3
2387	up	5159	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:02:03.11+00	2025-10-06 05:02:03.11+00	4
2388	down	10028	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n [CURL GET]	2025-10-06 05:02:13.613+00	2025-10-06 05:02:13.613+00	7
2389	down	10034	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n [CURL GET]	2025-10-06 05:02:23.421+00	2025-10-06 05:02:23.421+00	6
2390	up	150	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:02:23.678+00	2025-10-06 05:02:23.678+00	5
2391	up	940	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:02:32.658+00	2025-10-06 05:02:32.658+00	1
2392	down	10057	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-06 05:02:33.469+00	2025-10-06 05:02:33.469+00	3
2393	up	223	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:02:58.177+00	2025-10-06 05:02:58.177+00	4
2394	down	10032	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n [CURL GET]	2025-10-06 05:03:13.625+00	2025-10-06 05:03:13.625+00	7
2395	down	10065	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n [CURL GET]	2025-10-06 05:03:23.458+00	2025-10-06 05:03:23.458+00	6
2396	up	253	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:03:23.811+00	2025-10-06 05:03:23.811+00	5
2397	up	939	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:03:32.671+00	2025-10-06 05:03:32.671+00	1
2398	down	10166	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-06 05:03:33.584+00	2025-10-06 05:03:33.584+00	3
2399	up	236	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:03:58.196+00	2025-10-06 05:03:58.196+00	4
2400	down	10084	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n [CURL GET]	2025-10-06 05:04:13.684+00	2025-10-06 05:04:13.684+00	7
2401	down	10050	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n [CURL GET]	2025-10-06 05:04:23.44+00	2025-10-06 05:04:23.44+00	6
2402	up	592	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:04:24.144+00	2025-10-06 05:04:24.144+00	5
2403	up	959	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:04:32.69+00	2025-10-06 05:04:32.69+00	1
2404	down	10102	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-06 05:04:33.526+00	2025-10-06 05:04:33.526+00	3
2405	up	365	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:04:58.323+00	2025-10-06 05:04:58.323+00	4
2406	down	10035	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n [CURL GET]	2025-10-06 05:05:13.621+00	2025-10-06 05:05:13.621+00	7
2407	down	10053	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n [CURL GET]	2025-10-06 05:05:23.446+00	2025-10-06 05:05:23.446+00	6
2408	up	330	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:05:23.87+00	2025-10-06 05:05:23.87+00	5
2409	up	843	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:05:32.575+00	2025-10-06 05:05:32.575+00	1
2410	down	10034	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-06 05:05:33.458+00	2025-10-06 05:05:33.458+00	3
2411	up	242	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:05:58.192+00	2025-10-06 05:05:58.192+00	4
2473	up	143	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:16:22.557+00	2025-10-06 05:16:22.557+00	6
2412	down	10029	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n [CURL GET]	2025-10-06 05:06:13.62+00	2025-10-06 05:06:13.62+00	7
2413	down	10043	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n [CURL GET]	2025-10-06 05:06:23.434+00	2025-10-06 05:06:23.434+00	6
2414	up	124	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:06:23.664+00	2025-10-06 05:06:23.664+00	5
2415	up	848	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:06:32.581+00	2025-10-06 05:06:32.581+00	1
2416	down	10040	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-06 05:06:33.46+00	2025-10-06 05:06:33.46+00	3
2417	up	189	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:06:58.147+00	2025-10-06 05:06:58.147+00	4
2418	down	10031	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n [CURL GET]	2025-10-06 05:07:13.623+00	2025-10-06 05:07:13.623+00	7
2419	down	10040	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n [CURL GET]	2025-10-06 05:07:23.437+00	2025-10-06 05:07:23.437+00	6
2420	up	154	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:07:23.725+00	2025-10-06 05:07:23.725+00	5
2421	up	833	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:07:32.567+00	2025-10-06 05:07:32.567+00	1
2422	down	10053	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://prportal.nidw.gov.bd/partner-portal/home"\n [CURL GET]	2025-10-06 05:07:33.475+00	2025-10-06 05:07:33.475+00	3
2423	up	296	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:07:58.275+00	2025-10-06 05:07:58.275+00	4
2424	down	10037	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://cc.mynagad.com:20030/"\n [CURL GET]	2025-10-06 05:08:13.63+00	2025-10-06 05:08:13.63+00	7
2425	down	10033	\N	CURL GET failed: Command failed: curl -s -o /dev/null -w "%{http_code}" -X GET --max-time 10 "https://sys.mynagad.com:20020/"\n [CURL GET]	2025-10-06 05:08:23.426+00	2025-10-06 05:08:23.426+00	6
2426	up	133	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:08:23.555+00	2025-10-06 05:08:23.555+00	3
2427	up	153	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:08:23.698+00	2025-10-06 05:08:23.698+00	5
2428	up	827	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:08:32.562+00	2025-10-06 05:08:32.562+00	1
2429	up	368	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:08:58.32+00	2025-10-06 05:08:58.32+00	4
2430	up	217	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:09:03.816+00	2025-10-06 05:09:03.816+00	7
2431	up	161	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:09:13.557+00	2025-10-06 05:09:13.557+00	6
2432	up	198	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:09:23.62+00	2025-10-06 05:09:23.62+00	3
2433	up	150	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:09:23.693+00	2025-10-06 05:09:23.693+00	5
2434	up	742	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:09:32.478+00	2025-10-06 05:09:32.478+00	1
2435	up	274	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:09:58.237+00	2025-10-06 05:09:58.237+00	4
2436	up	199	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:10:03.794+00	2025-10-06 05:10:03.794+00	7
2437	up	131	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:10:13.532+00	2025-10-06 05:10:13.532+00	6
2438	up	132	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:10:23.675+00	2025-10-06 05:10:23.675+00	5
2439	up	404	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:10:23.831+00	2025-10-06 05:10:23.831+00	3
2440	up	10206	200	Website is up (PING fallback successful) [PING (fallback)]	2025-10-06 05:10:41.946+00	2025-10-06 05:10:41.946+00	1
2441	up	1099	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:10:59.192+00	2025-10-06 05:10:59.192+00	4
2442	up	273	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:11:03.888+00	2025-10-06 05:11:03.888+00	7
2443	up	195	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:11:13.588+00	2025-10-06 05:11:13.588+00	6
2444	up	141	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:11:23.566+00	2025-10-06 05:11:23.566+00	3
2445	up	252	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:11:23.8+00	2025-10-06 05:11:23.8+00	5
2446	up	1050	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:11:32.791+00	2025-10-06 05:11:32.791+00	1
2447	up	176	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:11:58.145+00	2025-10-06 05:11:58.145+00	4
2448	up	212	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:12:03.819+00	2025-10-06 05:12:03.819+00	7
2449	up	136	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:12:13.529+00	2025-10-06 05:12:13.529+00	6
2450	up	128	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:12:23.564+00	2025-10-06 05:12:23.564+00	3
2451	up	151	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:12:23.697+00	2025-10-06 05:12:23.697+00	5
2452	up	766	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:12:32.508+00	2025-10-06 05:12:32.508+00	1
2453	up	221	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:12:58.204+00	2025-10-06 05:12:58.204+00	4
2454	up	140	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:13:12.774+00	2025-10-06 05:13:12.774+00	7
2455	up	137	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:13:22.547+00	2025-10-06 05:13:22.547+00	6
2456	up	129	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:13:32.571+00	2025-10-06 05:13:32.571+00	3
2457	up	119	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:13:32.677+00	2025-10-06 05:13:32.677+00	5
2458	up	754	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:13:41.509+00	2025-10-06 05:13:41.509+00	1
2459	up	334	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:14:07.376+00	2025-10-06 05:14:07.376+00	4
2460	up	323	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:14:12.952+00	2025-10-06 05:14:12.952+00	7
2461	up	323	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:14:22.737+00	2025-10-06 05:14:22.737+00	6
2462	up	333	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:14:32.803+00	2025-10-06 05:14:32.803+00	3
2463	up	291	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:14:32.867+00	2025-10-06 05:14:32.867+00	5
2464	up	2064	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:14:42.821+00	2025-10-06 05:14:42.821+00	1
2465	up	264	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:15:07.289+00	2025-10-06 05:15:07.289+00	4
2466	up	630	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:15:13.347+00	2025-10-06 05:15:13.347+00	7
2467	up	672	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:15:23.099+00	2025-10-06 05:15:23.099+00	6
2468	up	166	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:15:32.617+00	2025-10-06 05:15:32.617+00	3
2469	up	224	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:15:32.803+00	2025-10-06 05:15:32.803+00	5
2470	up	738	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:15:41.496+00	2025-10-06 05:15:41.496+00	1
2471	up	222	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:16:07.211+00	2025-10-06 05:16:07.211+00	4
2472	up	113	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:16:12.75+00	2025-10-06 05:16:12.75+00	7
2474	up	121	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:16:32.564+00	2025-10-06 05:16:32.564+00	3
2475	up	156	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:16:32.746+00	2025-10-06 05:16:32.746+00	5
2476	up	847	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:16:41.618+00	2025-10-06 05:16:41.618+00	1
2477	up	175	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:17:07.161+00	2025-10-06 05:17:07.161+00	4
2478	up	135	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:17:12.775+00	2025-10-06 05:17:12.775+00	7
2479	up	203	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:17:22.619+00	2025-10-06 05:17:22.619+00	6
2480	up	144	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:17:32.589+00	2025-10-06 05:17:32.589+00	3
2481	up	208	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:17:32.789+00	2025-10-06 05:17:32.789+00	5
2482	up	789	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:17:41.56+00	2025-10-06 05:17:41.56+00	1
2483	up	148	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:18:07.143+00	2025-10-06 05:18:07.143+00	4
2484	up	108	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:18:12.746+00	2025-10-06 05:18:12.746+00	7
2485	up	111	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:18:22.527+00	2025-10-06 05:18:22.527+00	6
2486	up	123	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:18:32.569+00	2025-10-06 05:18:32.569+00	3
2487	up	154	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:18:32.736+00	2025-10-06 05:18:32.736+00	5
2488	up	729	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:18:41.5+00	2025-10-06 05:18:41.5+00	1
2489	up	253	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:19:07.244+00	2025-10-06 05:19:07.244+00	4
2490	up	123	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:19:12.771+00	2025-10-06 05:19:12.771+00	7
2491	up	106	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:19:22.521+00	2025-10-06 05:19:22.521+00	6
2492	up	156	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:19:32.601+00	2025-10-06 05:19:32.601+00	3
2493	up	186	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:19:32.767+00	2025-10-06 05:19:32.767+00	5
2494	up	704	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:19:41.476+00	2025-10-06 05:19:41.476+00	1
2495	up	99	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:20:12.773+00	2025-10-06 05:20:12.773+00	7
2496	up	179	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:20:22.599+00	2025-10-06 05:20:22.599+00	6
2497	up	165	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:20:32.611+00	2025-10-06 05:20:32.611+00	3
2498	up	159	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:20:32.749+00	2025-10-06 05:20:32.749+00	5
2499	up	791	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:20:41.564+00	2025-10-06 05:20:41.564+00	1
2500	up	36039	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:20:43.036+00	2025-10-06 05:20:43.036+00	4
2501	up	172	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:21:07.175+00	2025-10-06 05:21:07.175+00	4
2502	up	167	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:21:12.893+00	2025-10-06 05:21:12.893+00	7
2503	up	156	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:21:22.582+00	2025-10-06 05:21:22.582+00	6
2504	up	147	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:21:32.596+00	2025-10-06 05:21:32.596+00	3
2505	up	136	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:21:32.724+00	2025-10-06 05:21:32.724+00	5
2506	up	759	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:21:41.533+00	2025-10-06 05:21:41.533+00	1
2507	up	287	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:22:07.281+00	2025-10-06 05:22:07.281+00	4
2508	up	128	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:22:12.871+00	2025-10-06 05:22:12.871+00	7
2509	up	182	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:22:22.609+00	2025-10-06 05:22:22.609+00	6
2510	up	110	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:22:32.561+00	2025-10-06 05:22:32.561+00	3
2511	up	129	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:22:32.715+00	2025-10-06 05:22:32.715+00	5
2512	up	879	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:22:41.656+00	2025-10-06 05:22:41.656+00	1
2513	up	153	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:23:07.148+00	2025-10-06 05:23:07.148+00	4
2514	up	137	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:23:12.881+00	2025-10-06 05:23:12.881+00	7
2515	up	114	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:23:22.547+00	2025-10-06 05:23:22.547+00	6
2516	up	191	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:23:32.66+00	2025-10-06 05:23:32.66+00	3
2517	up	1492	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:23:34.081+00	2025-10-06 05:23:34.081+00	5
2518	up	723	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:23:41.502+00	2025-10-06 05:23:41.502+00	1
2519	up	154	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:24:07.155+00	2025-10-06 05:24:07.155+00	4
2520	up	216	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:24:12.966+00	2025-10-06 05:24:12.966+00	7
2521	up	123	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:24:22.554+00	2025-10-06 05:24:22.554+00	6
2522	up	153	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:24:32.619+00	2025-10-06 05:24:32.619+00	3
2523	up	133	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:24:32.744+00	2025-10-06 05:24:32.744+00	5
2524	up	713	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:24:41.493+00	2025-10-06 05:24:41.493+00	1
2525	up	324	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:25:07.339+00	2025-10-06 05:25:07.339+00	4
2526	up	209	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:25:12.967+00	2025-10-06 05:25:12.967+00	7
2527	up	124	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:25:22.576+00	2025-10-06 05:25:22.576+00	6
2528	up	123	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:25:32.591+00	2025-10-06 05:25:32.591+00	3
2529	up	5245	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:25:37.853+00	2025-10-06 05:25:37.853+00	5
2530	up	5830	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:25:46.61+00	2025-10-06 05:25:46.61+00	1
2531	up	218	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:26:07.588+00	2025-10-06 05:26:07.588+00	4
2532	up	129	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:26:12.887+00	2025-10-06 05:26:12.887+00	7
2533	up	124	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:26:22.576+00	2025-10-06 05:26:22.576+00	6
2534	up	290	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:26:32.911+00	2025-10-06 05:26:32.911+00	5
2535	up	494	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:26:32.962+00	2025-10-06 05:26:32.962+00	3
2536	up	751	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:26:41.531+00	2025-10-06 05:26:41.531+00	1
2537	up	229	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:27:07.555+00	2025-10-06 05:27:07.555+00	4
2538	up	173	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:27:12.932+00	2025-10-06 05:27:12.932+00	7
2539	up	143	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:27:22.596+00	2025-10-06 05:27:22.596+00	6
2540	up	107	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:27:32.581+00	2025-10-06 05:27:32.581+00	3
2541	up	110	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:27:32.746+00	2025-10-06 05:27:32.746+00	5
2542	up	766	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:27:41.547+00	2025-10-06 05:27:41.547+00	1
2543	up	320	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:28:07.676+00	2025-10-06 05:28:07.676+00	4
2544	up	145	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:28:12.903+00	2025-10-06 05:28:12.903+00	7
2545	up	128	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:28:22.582+00	2025-10-06 05:28:22.582+00	6
2546	up	104	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:28:32.577+00	2025-10-06 05:28:32.577+00	3
2547	up	158	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:28:32.801+00	2025-10-06 05:28:32.801+00	5
2548	up	807	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:28:41.588+00	2025-10-06 05:28:41.588+00	1
2549	up	290	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:29:07.656+00	2025-10-06 05:29:07.656+00	4
2550	up	209	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:29:12.974+00	2025-10-06 05:29:12.974+00	7
2551	up	119	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:29:22.571+00	2025-10-06 05:29:22.571+00	6
2552	up	112	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:29:32.589+00	2025-10-06 05:29:32.589+00	3
2553	up	175	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:29:32.822+00	2025-10-06 05:29:32.822+00	5
2554	up	795	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:29:41.576+00	2025-10-06 05:29:41.576+00	1
2555	up	157	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:30:07.517+00	2025-10-06 05:30:07.517+00	4
2556	up	116	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:30:12.882+00	2025-10-06 05:30:12.882+00	7
2557	up	114	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:30:22.57+00	2025-10-06 05:30:22.57+00	6
2558	up	267	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:30:32.753+00	2025-10-06 05:30:32.753+00	3
2559	up	259	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:30:32.912+00	2025-10-06 05:30:32.912+00	5
2560	up	715	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:30:41.497+00	2025-10-06 05:30:41.497+00	1
2561	up	277	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:31:07.642+00	2025-10-06 05:31:07.642+00	4
2562	up	136	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:31:12.901+00	2025-10-06 05:31:12.901+00	7
2563	up	139	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:31:22.594+00	2025-10-06 05:31:22.594+00	6
2564	up	588	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:31:33.084+00	2025-10-06 05:31:33.084+00	3
2565	up	583	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:31:33.244+00	2025-10-06 05:31:33.244+00	5
2566	up	1013	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:31:41.799+00	2025-10-06 05:31:41.799+00	1
2567	up	228	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:32:07.597+00	2025-10-06 05:32:07.597+00	4
2568	up	109	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:32:12.876+00	2025-10-06 05:32:12.876+00	7
2569	up	435	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:32:22.907+00	2025-10-06 05:32:22.907+00	6
2570	up	144	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:32:32.629+00	2025-10-06 05:32:32.629+00	3
2571	up	166	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:32:32.818+00	2025-10-06 05:32:32.818+00	5
2572	up	826	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:32:41.611+00	2025-10-06 05:32:41.611+00	1
2573	up	227	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:33:07.603+00	2025-10-06 05:33:07.603+00	4
2574	up	233	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:33:13.006+00	2025-10-06 05:33:13.006+00	7
2575	up	217	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:33:22.674+00	2025-10-06 05:33:22.674+00	6
2576	up	136	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:33:32.623+00	2025-10-06 05:33:32.623+00	3
2577	up	186	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:33:32.84+00	2025-10-06 05:33:32.84+00	5
2578	up	5753	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:33:46.539+00	2025-10-06 05:33:46.539+00	1
2579	up	269	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:34:07.668+00	2025-10-06 05:34:07.668+00	4
2580	up	139	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:34:12.91+00	2025-10-06 05:34:12.91+00	7
2581	up	158	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:34:22.617+00	2025-10-06 05:34:22.617+00	6
2582	up	180	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:34:32.672+00	2025-10-06 05:34:32.672+00	3
2583	up	218	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:34:32.874+00	2025-10-06 05:34:32.874+00	5
2584	up	804	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:34:41.592+00	2025-10-06 05:34:41.592+00	1
2585	up	358	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:35:07.792+00	2025-10-06 05:35:07.792+00	4
2586	up	226	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:35:13.006+00	2025-10-06 05:35:13.006+00	7
2587	up	130	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:35:22.59+00	2025-10-06 05:35:22.59+00	6
2588	up	177	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:35:32.672+00	2025-10-06 05:35:32.672+00	3
2589	up	227	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:35:32.886+00	2025-10-06 05:35:32.886+00	5
2590	up	789	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:35:41.579+00	2025-10-06 05:35:41.579+00	1
2591	up	179	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:36:07.555+00	2025-10-06 05:36:07.555+00	4
2592	up	133	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:36:12.903+00	2025-10-06 05:36:12.903+00	7
2593	up	155	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:36:22.62+00	2025-10-06 05:36:22.62+00	6
2594	up	135	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:36:32.621+00	2025-10-06 05:36:32.621+00	3
2595	up	142	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:36:32.802+00	2025-10-06 05:36:32.802+00	5
2596	up	782	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:36:41.576+00	2025-10-06 05:36:41.576+00	1
2597	up	163	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:37:07.544+00	2025-10-06 05:37:07.544+00	4
2598	up	193	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:37:12.963+00	2025-10-06 05:37:12.963+00	7
2599	up	155	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:37:22.621+00	2025-10-06 05:37:22.621+00	6
2600	up	173	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:37:32.66+00	2025-10-06 05:37:32.66+00	3
2601	up	149	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:37:32.803+00	2025-10-06 05:37:32.803+00	5
2602	up	796	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:37:41.592+00	2025-10-06 05:37:41.592+00	1
2603	up	338	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:38:07.708+00	2025-10-06 05:38:07.708+00	4
2604	up	153	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:38:12.925+00	2025-10-06 05:38:12.925+00	7
2605	up	222	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:38:22.722+00	2025-10-06 05:38:22.722+00	6
2606	up	379	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:38:32.893+00	2025-10-06 05:38:32.893+00	3
2607	up	405	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:38:33.087+00	2025-10-06 05:38:33.087+00	5
2608	up	763	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:38:41.56+00	2025-10-06 05:38:41.56+00	1
2609	up	191	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:39:07.567+00	2025-10-06 05:39:07.567+00	4
2610	up	193	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:39:12.973+00	2025-10-06 05:39:12.973+00	7
2611	up	296	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:39:22.79+00	2025-10-06 05:39:22.79+00	6
2612	up	172	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:39:32.666+00	2025-10-06 05:39:32.666+00	3
2613	up	161	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:39:32.83+00	2025-10-06 05:39:32.83+00	5
2614	up	743	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:39:41.542+00	2025-10-06 05:39:41.542+00	1
2615	up	336	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:40:07.755+00	2025-10-06 05:40:07.755+00	4
2616	up	207	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:40:12.988+00	2025-10-06 05:40:12.988+00	7
2617	up	225	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:40:22.773+00	2025-10-06 05:40:22.773+00	6
2618	up	132	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:40:32.665+00	2025-10-06 05:40:32.665+00	3
2619	up	172	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:40:32.831+00	2025-10-06 05:40:32.831+00	5
2620	up	883	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:40:41.683+00	2025-10-06 05:40:41.683+00	1
2621	up	198	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:41:07.611+00	2025-10-06 05:41:07.611+00	4
2622	up	183	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:41:12.973+00	2025-10-06 05:41:12.973+00	7
2623	up	143	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:41:22.688+00	2025-10-06 05:41:22.688+00	6
2624	up	208	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:41:32.745+00	2025-10-06 05:41:32.745+00	3
2625	up	223	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:41:32.886+00	2025-10-06 05:41:32.886+00	5
2626	up	742	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:41:41.543+00	2025-10-06 05:41:41.543+00	1
2627	up	258	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:42:07.672+00	2025-10-06 05:42:07.672+00	4
2628	up	297	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:42:13.076+00	2025-10-06 05:42:13.076+00	7
2629	up	160	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:42:22.716+00	2025-10-06 05:42:22.716+00	6
2630	up	262	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:42:32.793+00	2025-10-06 05:42:32.793+00	3
2631	up	203	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:42:32.886+00	2025-10-06 05:42:32.886+00	5
2632	up	1426	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:42:42.227+00	2025-10-06 05:42:42.227+00	1
2633	up	299	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:43:07.757+00	2025-10-06 05:43:07.757+00	4
2634	up	303	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:43:13.089+00	2025-10-06 05:43:13.089+00	7
2635	up	250	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:43:22.813+00	2025-10-06 05:43:22.813+00	6
2636	up	163	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:43:32.759+00	2025-10-06 05:43:32.759+00	3
2637	up	208	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:43:32.891+00	2025-10-06 05:43:32.891+00	5
2638	up	1241	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:43:42.042+00	2025-10-06 05:43:42.042+00	1
2639	up	198	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:44:07.656+00	2025-10-06 05:44:07.656+00	4
2640	up	229	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:44:13.031+00	2025-10-06 05:44:13.031+00	7
2641	up	186	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:44:22.749+00	2025-10-06 05:44:22.749+00	6
2642	up	897	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:44:33.53+00	2025-10-06 05:44:33.53+00	3
2643	up	821	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:44:33.544+00	2025-10-06 05:44:33.544+00	5
2644	up	2162	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:44:43.066+00	2025-10-06 05:44:43.066+00	1
2645	up	260	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:45:07.736+00	2025-10-06 05:45:07.736+00	4
2646	up	261	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:45:13.064+00	2025-10-06 05:45:13.064+00	7
2647	up	281	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:45:22.88+00	2025-10-06 05:45:22.88+00	6
2648	up	375	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:45:33.097+00	2025-10-06 05:45:33.097+00	5
2649	up	1242	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:45:33.887+00	2025-10-06 05:45:33.887+00	3
2650	up	1496	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:45:42.436+00	2025-10-06 05:45:42.436+00	1
2651	up	273	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:46:07.73+00	2025-10-06 05:46:07.73+00	4
2652	up	274	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:46:13.076+00	2025-10-06 05:46:13.076+00	7
2653	up	187	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:46:22.752+00	2025-10-06 05:46:22.752+00	6
2654	up	679	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:46:33.32+00	2025-10-06 05:46:33.32+00	3
2655	up	630	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:46:33.365+00	2025-10-06 05:46:33.365+00	5
2656	up	1211	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:46:42.152+00	2025-10-06 05:46:42.152+00	1
2657	up	267	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:47:07.731+00	2025-10-06 05:47:07.731+00	4
2658	up	330	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:47:13.132+00	2025-10-06 05:47:13.132+00	7
2659	up	311	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:47:22.876+00	2025-10-06 05:47:22.876+00	6
2660	up	382	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:47:33.025+00	2025-10-06 05:47:33.025+00	3
2661	up	397	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:47:33.129+00	2025-10-06 05:47:33.129+00	5
2662	up	952	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:47:41.895+00	2025-10-06 05:47:41.895+00	1
2663	up	639	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:48:08.105+00	2025-10-06 05:48:08.105+00	4
2664	up	203	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:48:13.006+00	2025-10-06 05:48:13.006+00	7
2665	up	198	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:48:22.766+00	2025-10-06 05:48:22.766+00	6
2666	up	168	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:48:32.805+00	2025-10-06 05:48:32.805+00	3
2667	up	237	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:48:32.967+00	2025-10-06 05:48:32.967+00	5
2668	up	1021	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:48:40.595+00	2025-10-06 05:48:40.595+00	1
2669	up	218	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:49:06.307+00	2025-10-06 05:49:06.307+00	4
2670	up	5220	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:49:16.643+00	2025-10-06 05:49:16.643+00	7
2671	up	229	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:49:21.422+00	2025-10-06 05:49:21.422+00	6
2672	up	250	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:49:31.508+00	2025-10-06 05:49:31.508+00	3
2673	up	234	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:49:31.605+00	2025-10-06 05:49:31.605+00	5
2674	up	864	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:49:40.438+00	2025-10-06 05:49:40.438+00	1
2675	up	628	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:50:06.714+00	2025-10-06 05:50:06.714+00	4
2676	up	312	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:50:11.748+00	2025-10-06 05:50:11.748+00	7
2677	up	162	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:50:21.352+00	2025-10-06 05:50:21.352+00	6
2678	up	162	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:50:31.425+00	2025-10-06 05:50:31.425+00	3
2679	up	470	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:50:31.834+00	2025-10-06 05:50:31.834+00	5
2680	up	968	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:50:40.582+00	2025-10-06 05:50:40.582+00	1
2681	up	533	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:51:06.628+00	2025-10-06 05:51:06.628+00	4
2682	up	195	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:51:11.621+00	2025-10-06 05:51:11.621+00	7
2683	up	264	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:51:21.47+00	2025-10-06 05:51:21.47+00	6
2684	up	173	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:51:31.434+00	2025-10-06 05:51:31.434+00	3
2685	up	247	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:51:31.635+00	2025-10-06 05:51:31.635+00	5
2686	up	821	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:51:40.437+00	2025-10-06 05:51:40.437+00	1
2687	up	338	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:52:06.428+00	2025-10-06 05:52:06.428+00	4
2688	up	163	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:52:11.596+00	2025-10-06 05:52:11.596+00	7
2689	up	152	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:52:21.353+00	2025-10-06 05:52:21.353+00	6
2690	up	147	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:52:31.408+00	2025-10-06 05:52:31.408+00	3
2691	up	147	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:52:31.528+00	2025-10-06 05:52:31.528+00	5
2692	up	875	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:52:40.492+00	2025-10-06 05:52:40.492+00	1
2693	up	350	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:53:06.444+00	2025-10-06 05:53:06.444+00	4
2694	up	169	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:53:11.602+00	2025-10-06 05:53:11.602+00	7
2695	up	141	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:53:21.343+00	2025-10-06 05:53:21.343+00	6
2696	up	155	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:53:31.418+00	2025-10-06 05:53:31.418+00	3
2697	up	179	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:53:31.567+00	2025-10-06 05:53:31.567+00	5
2698	up	872	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:53:40.49+00	2025-10-06 05:53:40.49+00	1
2699	up	289	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:54:06.373+00	2025-10-06 05:54:06.373+00	4
2700	up	177	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:54:11.616+00	2025-10-06 05:54:11.616+00	7
2701	up	180	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:54:21.382+00	2025-10-06 05:54:21.382+00	6
2702	up	170	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:54:31.436+00	2025-10-06 05:54:31.436+00	3
2703	up	150	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:54:31.534+00	2025-10-06 05:54:31.534+00	5
2704	up	890	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:54:40.509+00	2025-10-06 05:54:40.509+00	1
2705	up	206	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:55:06.289+00	2025-10-06 05:55:06.289+00	4
2706	up	171	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:55:11.604+00	2025-10-06 05:55:11.604+00	7
2707	up	282	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:55:21.484+00	2025-10-06 05:55:21.484+00	6
2708	up	343	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:55:31.614+00	2025-10-06 05:55:31.614+00	3
2709	up	364	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:55:31.759+00	2025-10-06 05:55:31.759+00	5
2710	up	1391	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:55:41.01+00	2025-10-06 05:55:41.01+00	1
2711	up	212	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:56:06.304+00	2025-10-06 05:56:06.304+00	4
2712	up	267	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:56:11.702+00	2025-10-06 05:56:11.702+00	7
2713	up	191	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:56:21.395+00	2025-10-06 05:56:21.395+00	6
2714	up	148	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:56:31.421+00	2025-10-06 05:56:31.421+00	3
2715	up	222	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:56:31.61+00	2025-10-06 05:56:31.61+00	5
2716	up	959	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:56:40.599+00	2025-10-06 05:56:40.599+00	1
2717	up	292	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:57:06.379+00	2025-10-06 05:57:06.379+00	4
2718	up	177	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:57:11.614+00	2025-10-06 05:57:11.614+00	7
2719	up	174	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:57:21.391+00	2025-10-06 05:57:21.391+00	6
2720	up	161	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:57:31.435+00	2025-10-06 05:57:31.435+00	3
2721	up	5374	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:57:36.769+00	2025-10-06 05:57:36.769+00	5
2722	up	852	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:57:40.493+00	2025-10-06 05:57:40.493+00	1
2723	up	250	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:58:06.334+00	2025-10-06 05:58:06.334+00	4
2724	up	173	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:58:11.612+00	2025-10-06 05:58:11.612+00	7
2725	up	156	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:58:21.382+00	2025-10-06 05:58:21.382+00	6
2726	up	188	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:58:31.465+00	2025-10-06 05:58:31.465+00	3
2727	up	153	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:58:31.546+00	2025-10-06 05:58:31.546+00	5
2728	up	1381	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:58:41.024+00	2025-10-06 05:58:41.024+00	1
2729	up	3696	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 05:59:09.79+00	2025-10-06 05:59:09.79+00	4
2730	up	121	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:59:11.564+00	2025-10-06 05:59:11.564+00	7
2731	up	313	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:59:21.523+00	2025-10-06 05:59:21.523+00	6
2732	up	145	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 05:59:31.425+00	2025-10-06 05:59:31.425+00	3
2733	up	5208	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 05:59:36.607+00	2025-10-06 05:59:36.607+00	5
2734	up	831	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 05:59:40.474+00	2025-10-06 05:59:40.474+00	1
2735	up	1558	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:00:07.647+00	2025-10-06 06:00:07.647+00	4
2736	up	141	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:00:11.579+00	2025-10-06 06:00:11.579+00	7
2737	up	210	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:00:21.421+00	2025-10-06 06:00:21.421+00	6
2738	up	306	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:00:31.588+00	2025-10-06 06:00:31.588+00	3
2739	up	245	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:00:31.637+00	2025-10-06 06:00:31.637+00	5
2740	up	828	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:00:40.471+00	2025-10-06 06:00:40.471+00	1
2741	up	231	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:01:06.338+00	2025-10-06 06:01:06.338+00	4
2742	up	182	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:01:11.628+00	2025-10-06 06:01:11.628+00	7
2743	up	314	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:01:21.529+00	2025-10-06 06:01:21.529+00	6
2744	up	205	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:01:31.484+00	2025-10-06 06:01:31.484+00	3
2745	up	179	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:01:31.578+00	2025-10-06 06:01:31.578+00	5
2746	up	1188	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:01:40.833+00	2025-10-06 06:01:40.833+00	1
2747	up	604	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:02:06.726+00	2025-10-06 06:02:06.726+00	4
2748	up	207	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:02:11.66+00	2025-10-06 06:02:11.66+00	7
2749	up	158	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:02:21.371+00	2025-10-06 06:02:21.371+00	6
2750	up	168	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:02:31.449+00	2025-10-06 06:02:31.449+00	3
2751	up	216	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:02:31.613+00	2025-10-06 06:02:31.613+00	5
2752	up	901	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:02:40.546+00	2025-10-06 06:02:40.546+00	1
2753	up	312	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:03:06.428+00	2025-10-06 06:03:06.428+00	4
2754	up	144	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:03:11.587+00	2025-10-06 06:03:11.587+00	7
2755	up	133	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:03:21.349+00	2025-10-06 06:03:21.349+00	6
2756	up	150	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:03:31.432+00	2025-10-06 06:03:31.432+00	3
2757	up	239	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:03:31.635+00	2025-10-06 06:03:31.635+00	5
2758	up	878	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:03:40.524+00	2025-10-06 06:03:40.524+00	1
2759	up	212	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:04:06.302+00	2025-10-06 06:04:06.302+00	4
2760	up	130	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:04:11.577+00	2025-10-06 06:04:11.577+00	7
2761	up	124	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:04:21.35+00	2025-10-06 06:04:21.35+00	6
2762	up	180	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:04:31.462+00	2025-10-06 06:04:31.462+00	3
2763	up	203	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:04:31.614+00	2025-10-06 06:04:31.614+00	5
2764	up	918	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:04:40.563+00	2025-10-06 06:04:40.563+00	1
2765	up	3336	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:05:09.426+00	2025-10-06 06:05:09.426+00	4
2766	up	147	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:05:11.593+00	2025-10-06 06:05:11.593+00	7
2767	up	287	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:05:21.541+00	2025-10-06 06:05:21.541+00	6
2768	up	158	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:05:31.439+00	2025-10-06 06:05:31.439+00	3
2769	up	182	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:05:31.598+00	2025-10-06 06:05:31.598+00	5
2770	up	1441	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:05:41.088+00	2025-10-06 06:05:41.088+00	1
2771	up	470	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:06:06.581+00	2025-10-06 06:06:06.581+00	4
2772	up	165	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:06:11.61+00	2025-10-06 06:06:11.61+00	7
2773	up	248	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:06:21.478+00	2025-10-06 06:06:21.478+00	6
2774	up	195	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:06:31.476+00	2025-10-06 06:06:31.476+00	3
2775	up	196	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:06:31.615+00	2025-10-06 06:06:31.615+00	5
2776	up	3460	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:06:43.107+00	2025-10-06 06:06:43.107+00	1
2777	up	232	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:07:06.331+00	2025-10-06 06:07:06.331+00	4
2778	up	223	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:07:11.676+00	2025-10-06 06:07:11.676+00	7
2779	up	150	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:07:21.375+00	2025-10-06 06:07:21.375+00	6
2780	up	146	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:07:31.431+00	2025-10-06 06:07:31.431+00	3
2781	up	171	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:07:31.588+00	2025-10-06 06:07:31.588+00	5
2782	up	1416	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:07:41.065+00	2025-10-06 06:07:41.065+00	1
2783	up	190	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:08:06.295+00	2025-10-06 06:08:06.295+00	4
2784	up	314	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:08:11.762+00	2025-10-06 06:08:11.762+00	7
2785	up	150	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:08:21.377+00	2025-10-06 06:08:21.377+00	6
2786	up	291	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:08:31.578+00	2025-10-06 06:08:31.578+00	3
2787	up	208	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:08:31.623+00	2025-10-06 06:08:31.623+00	5
2788	up	2525	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:08:42.175+00	2025-10-06 06:08:42.175+00	1
2789	up	5510	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:09:11.609+00	2025-10-06 06:09:11.609+00	4
2790	up	184	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:09:11.631+00	2025-10-06 06:09:11.631+00	7
2791	up	162	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:09:21.39+00	2025-10-06 06:09:21.39+00	6
2792	up	142	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:09:31.427+00	2025-10-06 06:09:31.427+00	3
2793	up	259	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:09:31.674+00	2025-10-06 06:09:31.674+00	5
2794	up	1345	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:09:40.999+00	2025-10-06 06:09:40.999+00	1
2795	up	214	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:10:06.326+00	2025-10-06 06:10:06.326+00	4
2796	up	211	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:10:11.659+00	2025-10-06 06:10:11.659+00	7
2797	up	118	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:10:21.369+00	2025-10-06 06:10:21.369+00	6
2798	up	167	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:10:31.585+00	2025-10-06 06:10:31.585+00	5
2799	up	420	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:10:31.705+00	2025-10-06 06:10:31.705+00	3
2800	up	2595	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:10:42.254+00	2025-10-06 06:10:42.254+00	1
2801	up	1314	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:11:07.418+00	2025-10-06 06:11:07.418+00	4
2802	up	175	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:11:11.624+00	2025-10-06 06:11:11.624+00	7
2803	up	137	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:11:21.386+00	2025-10-06 06:11:21.386+00	6
2804	up	149	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:11:31.457+00	2025-10-06 06:11:31.457+00	3
2805	up	148	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:11:31.564+00	2025-10-06 06:11:31.564+00	5
2806	up	3664	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:11:43.322+00	2025-10-06 06:11:43.322+00	1
2807	up	217	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:12:06.331+00	2025-10-06 06:12:06.331+00	4
2808	up	205	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:12:11.664+00	2025-10-06 06:12:11.664+00	7
2809	up	354	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:12:21.613+00	2025-10-06 06:12:21.613+00	6
2810	up	141	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:12:31.452+00	2025-10-06 06:12:31.452+00	3
2811	up	159	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:12:31.578+00	2025-10-06 06:12:31.578+00	5
2812	up	2449	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:12:42.108+00	2025-10-06 06:12:42.108+00	1
2813	up	235	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:13:06.356+00	2025-10-06 06:13:06.356+00	4
2814	up	168	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:13:11.621+00	2025-10-06 06:13:11.621+00	7
2815	up	459	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:13:21.714+00	2025-10-06 06:13:21.714+00	6
2816	up	174	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:13:31.489+00	2025-10-06 06:13:31.489+00	3
2817	up	185	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:13:31.603+00	2025-10-06 06:13:31.603+00	5
2818	up	1565	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:13:41.225+00	2025-10-06 06:13:41.225+00	1
2819	up	272	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:14:06.397+00	2025-10-06 06:14:06.397+00	4
2820	up	265	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:14:11.719+00	2025-10-06 06:14:11.719+00	7
2821	up	184	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:14:21.443+00	2025-10-06 06:14:21.443+00	6
2822	up	178	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:14:31.488+00	2025-10-06 06:14:31.488+00	3
2823	up	207	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:14:31.632+00	2025-10-06 06:14:31.632+00	5
2824	up	2433	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:14:42.093+00	2025-10-06 06:14:42.093+00	1
2825	up	266	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:15:06.395+00	2025-10-06 06:15:06.395+00	4
2826	up	180	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:15:11.631+00	2025-10-06 06:15:11.631+00	7
2827	up	389	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:15:21.702+00	2025-10-06 06:15:21.702+00	6
2828	up	202	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:15:31.518+00	2025-10-06 06:15:31.518+00	3
2829	up	282	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:15:31.723+00	2025-10-06 06:15:31.723+00	5
2830	up	2459	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:15:42.12+00	2025-10-06 06:15:42.12+00	1
2831	up	436	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:16:06.558+00	2025-10-06 06:16:06.558+00	4
2832	up	140	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:16:11.601+00	2025-10-06 06:16:11.601+00	7
2833	up	168	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:16:21.426+00	2025-10-06 06:16:21.426+00	6
2834	up	174	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:16:31.484+00	2025-10-06 06:16:31.484+00	3
2835	up	161	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:16:31.594+00	2025-10-06 06:16:31.594+00	5
2836	up	2420	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:16:42.083+00	2025-10-06 06:16:42.083+00	1
2837	up	241	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:17:06.364+00	2025-10-06 06:17:06.364+00	4
2838	up	185	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:17:11.646+00	2025-10-06 06:17:11.646+00	7
2839	up	150	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:17:21.408+00	2025-10-06 06:17:21.408+00	6
2840	up	596	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:17:31.951+00	2025-10-06 06:17:31.951+00	3
2841	up	615	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:17:32.092+00	2025-10-06 06:17:32.092+00	5
2842	up	1471	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:17:41.147+00	2025-10-06 06:17:41.147+00	1
2843	up	235	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:18:06.363+00	2025-10-06 06:18:06.363+00	4
2844	up	210	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:18:11.675+00	2025-10-06 06:18:11.675+00	7
2845	up	262	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:18:21.524+00	2025-10-06 06:18:21.524+00	6
2846	up	174	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:18:31.499+00	2025-10-06 06:18:31.499+00	3
2847	up	129	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:18:31.573+00	2025-10-06 06:18:31.573+00	5
2848	up	1398	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:18:41.069+00	2025-10-06 06:18:41.069+00	1
2849	up	3278	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:19:09.405+00	2025-10-06 06:19:09.405+00	4
2850	up	257	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:19:11.719+00	2025-10-06 06:19:11.719+00	7
2851	up	215	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:19:21.488+00	2025-10-06 06:19:21.488+00	6
2852	up	132	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:19:31.456+00	2025-10-06 06:19:31.456+00	3
2853	up	168	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:19:31.612+00	2025-10-06 06:19:31.612+00	5
2854	up	1373	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:19:41.044+00	2025-10-06 06:19:41.044+00	1
2855	up	229	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:20:06.352+00	2025-10-06 06:20:06.352+00	4
2856	up	135	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:20:11.601+00	2025-10-06 06:20:11.601+00	7
2857	up	154	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:20:21.422+00	2025-10-06 06:20:21.422+00	6
2858	up	159	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:20:31.485+00	2025-10-06 06:20:31.485+00	3
2859	up	183	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:20:31.625+00	2025-10-06 06:20:31.625+00	5
2860	up	1951	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:20:41.623+00	2025-10-06 06:20:41.623+00	1
2861	up	225	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:21:06.346+00	2025-10-06 06:21:06.346+00	4
2862	up	201	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:21:11.674+00	2025-10-06 06:21:11.674+00	7
2863	up	197	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:21:21.474+00	2025-10-06 06:21:21.474+00	6
2864	up	170	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:21:31.497+00	2025-10-06 06:21:31.497+00	3
2865	up	250	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:21:31.698+00	2025-10-06 06:21:31.698+00	5
2866	up	2973	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:21:42.648+00	2025-10-06 06:21:42.648+00	1
2867	up	1288	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:22:07.45+00	2025-10-06 06:22:07.45+00	4
2868	up	290	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:22:11.77+00	2025-10-06 06:22:11.77+00	7
2869	up	235	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:22:21.504+00	2025-10-06 06:22:21.504+00	6
2870	up	155	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:22:31.494+00	2025-10-06 06:22:31.494+00	3
2871	up	181	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:22:31.634+00	2025-10-06 06:22:31.634+00	5
2872	up	1294	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:22:40.97+00	2025-10-06 06:22:40.97+00	1
2873	up	224	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:23:06.357+00	2025-10-06 06:23:06.357+00	4
2874	up	231	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:23:11.709+00	2025-10-06 06:23:11.709+00	7
2875	up	161	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:23:21.429+00	2025-10-06 06:23:21.429+00	6
2876	up	139	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:23:31.591+00	2025-10-06 06:23:31.591+00	5
2877	up	941	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:23:32.27+00	2025-10-06 06:23:32.27+00	3
2878	up	3672	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:23:43.349+00	2025-10-06 06:23:43.349+00	1
2879	up	210	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:24:06.695+00	2025-10-06 06:24:06.695+00	4
2880	up	170	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:24:11.986+00	2025-10-06 06:24:11.986+00	7
2881	up	346	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:24:21.967+00	2025-10-06 06:24:21.967+00	6
2882	up	379	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:24:32.059+00	2025-10-06 06:24:32.059+00	3
2883	up	588	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:24:32.388+00	2025-10-06 06:24:32.388+00	5
2884	up	2802	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:24:42.817+00	2025-10-06 06:24:42.817+00	1
2885	up	1197	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:25:07.664+00	2025-10-06 06:25:07.664+00	4
2886	up	356	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:25:12.185+00	2025-10-06 06:25:12.185+00	7
2887	up	184	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:25:21.808+00	2025-10-06 06:25:21.808+00	6
2888	up	144	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:25:31.817+00	2025-10-06 06:25:31.817+00	3
2889	up	155	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:25:31.948+00	2025-10-06 06:25:31.948+00	5
2890	up	1406	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:25:41.428+00	2025-10-06 06:25:41.428+00	1
2891	up	403	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:26:06.925+00	2025-10-06 06:26:06.925+00	4
2892	up	298	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:26:12.119+00	2025-10-06 06:26:12.119+00	7
2893	up	220	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:26:21.84+00	2025-10-06 06:26:21.84+00	6
2894	up	205	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:26:31.883+00	2025-10-06 06:26:31.883+00	3
2895	up	506	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:26:32.329+00	2025-10-06 06:26:32.329+00	5
2896	up	1339	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:26:41.36+00	2025-10-06 06:26:41.36+00	1
2897	up	230	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:27:06.703+00	2025-10-06 06:27:06.703+00	4
2898	up	215	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:27:12.032+00	2025-10-06 06:27:12.032+00	7
2899	up	872	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:27:22.501+00	2025-10-06 06:27:22.501+00	6
2900	up	335	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:27:32.022+00	2025-10-06 06:27:32.022+00	3
2901	up	275	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:27:32.098+00	2025-10-06 06:27:32.098+00	5
2902	up	6340	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:27:46.363+00	2025-10-06 06:27:46.363+00	1
2903	up	227	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:28:06.702+00	2025-10-06 06:28:06.702+00	4
2904	up	175	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:28:11.994+00	2025-10-06 06:28:11.994+00	7
2905	up	234	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:28:21.865+00	2025-10-06 06:28:21.865+00	6
2906	up	151	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:28:31.828+00	2025-10-06 06:28:31.828+00	3
2907	up	158	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:28:31.98+00	2025-10-06 06:28:31.98+00	5
2908	up	1380	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:28:41.408+00	2025-10-06 06:28:41.408+00	1
2909	up	290	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:29:06.771+00	2025-10-06 06:29:06.771+00	4
2910	up	170	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:29:11.99+00	2025-10-06 06:29:11.99+00	7
2911	up	186	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:29:21.812+00	2025-10-06 06:29:21.812+00	6
2912	up	297	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:29:31.976+00	2025-10-06 06:29:31.976+00	3
2913	up	239	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:29:32.062+00	2025-10-06 06:29:32.062+00	5
2914	up	1176	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:29:41.204+00	2025-10-06 06:29:41.204+00	1
2915	up	1196	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:30:07.669+00	2025-10-06 06:30:07.669+00	4
2916	up	166	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:30:11.984+00	2025-10-06 06:30:11.984+00	7
2917	up	329	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:30:21.959+00	2025-10-06 06:30:21.959+00	6
2918	up	160	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:30:31.842+00	2025-10-06 06:30:31.842+00	3
2919	up	225	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:30:32.049+00	2025-10-06 06:30:32.049+00	5
2920	up	2318	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:30:42.347+00	2025-10-06 06:30:42.347+00	1
2921	up	285	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:31:06.769+00	2025-10-06 06:31:06.769+00	4
2922	up	181	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:31:12.001+00	2025-10-06 06:31:12.001+00	7
2923	up	362	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:31:21.99+00	2025-10-06 06:31:21.99+00	6
2924	up	140	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:31:31.821+00	2025-10-06 06:31:31.821+00	3
2925	up	175	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:31:32.001+00	2025-10-06 06:31:32.001+00	5
2926	up	1319	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:31:41.35+00	2025-10-06 06:31:41.35+00	1
2927	up	247	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:32:06.728+00	2025-10-06 06:32:06.728+00	4
2928	up	173	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:32:11.998+00	2025-10-06 06:32:11.998+00	7
2929	up	372	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:32:22.008+00	2025-10-06 06:32:22.008+00	6
2930	up	184	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:32:31.868+00	2025-10-06 06:32:31.868+00	3
2931	up	242	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:32:32.096+00	2025-10-06 06:32:32.096+00	5
2932	up	2195	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:32:42.226+00	2025-10-06 06:32:42.226+00	1
2933	up	209	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:33:06.696+00	2025-10-06 06:33:06.696+00	4
2934	up	160	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:33:11.988+00	2025-10-06 06:33:11.988+00	7
2935	up	161	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:33:21.799+00	2025-10-06 06:33:21.799+00	6
2936	up	132	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:33:31.815+00	2025-10-06 06:33:31.815+00	3
2937	up	300	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:33:32.144+00	2025-10-06 06:33:32.144+00	5
2938	up	1215	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:33:41.247+00	2025-10-06 06:33:41.247+00	1
2939	up	209	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:34:06.699+00	2025-10-06 06:34:06.699+00	4
2940	up	199	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:34:12.025+00	2025-10-06 06:34:12.025+00	7
2941	up	136	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:34:21.771+00	2025-10-06 06:34:21.771+00	6
2942	up	136	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:34:31.818+00	2025-10-06 06:34:31.818+00	3
2943	up	211	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:34:32.055+00	2025-10-06 06:34:32.055+00	5
2944	up	1404	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:34:41.437+00	2025-10-06 06:34:41.437+00	1
2945	up	1315	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:35:07.806+00	2025-10-06 06:35:07.806+00	4
2946	up	419	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:35:12.244+00	2025-10-06 06:35:12.244+00	7
2947	up	171	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:35:21.804+00	2025-10-06 06:35:21.804+00	6
2948	up	171	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:35:31.855+00	2025-10-06 06:35:31.855+00	3
2949	up	149	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:35:31.983+00	2025-10-06 06:35:31.983+00	5
2950	up	1366	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:35:41.401+00	2025-10-06 06:35:41.401+00	1
2951	up	242	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:36:06.738+00	2025-10-06 06:36:06.738+00	4
2952	up	235	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:36:12.063+00	2025-10-06 06:36:12.063+00	7
2953	up	218	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:36:21.859+00	2025-10-06 06:36:21.859+00	6
2954	up	134	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:36:31.824+00	2025-10-06 06:36:31.824+00	3
2955	up	154	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:36:31.994+00	2025-10-06 06:36:31.994+00	5
2956	up	1438	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:36:41.476+00	2025-10-06 06:36:41.476+00	1
2957	up	1645	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:37:08.15+00	2025-10-06 06:37:08.15+00	4
2958	up	364	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:37:12.195+00	2025-10-06 06:37:12.195+00	7
2959	up	127	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:37:21.76+00	2025-10-06 06:37:21.76+00	6
2960	up	152	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:37:31.841+00	2025-10-06 06:37:31.841+00	3
2961	up	181	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:37:32.017+00	2025-10-06 06:37:32.017+00	5
2962	up	1364	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:37:41.403+00	2025-10-06 06:37:41.403+00	1
2963	up	767	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:38:07.26+00	2025-10-06 06:38:07.26+00	4
2964	up	168	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:38:11.997+00	2025-10-06 06:38:11.997+00	7
2965	up	143	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:38:21.785+00	2025-10-06 06:38:21.785+00	6
2966	up	182	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:38:31.872+00	2025-10-06 06:38:31.872+00	3
2967	up	137	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:38:31.97+00	2025-10-06 06:38:31.97+00	5
2968	up	1492	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:38:41.533+00	2025-10-06 06:38:41.533+00	1
2969	up	190	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:39:06.68+00	2025-10-06 06:39:06.68+00	4
2970	up	423	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:39:12.261+00	2025-10-06 06:39:12.261+00	7
2971	up	187	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:39:21.821+00	2025-10-06 06:39:21.821+00	6
2972	up	118	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:39:31.808+00	2025-10-06 06:39:31.808+00	3
2973	up	191	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:39:32.026+00	2025-10-06 06:39:32.026+00	5
2974	up	3018	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:39:43.06+00	2025-10-06 06:39:43.06+00	1
2975	up	277	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:40:06.785+00	2025-10-06 06:40:06.785+00	4
2976	up	149	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:40:11.982+00	2025-10-06 06:40:11.982+00	7
2977	up	199	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:40:21.834+00	2025-10-06 06:40:21.834+00	6
2978	up	171	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:40:31.862+00	2025-10-06 06:40:31.862+00	3
2979	up	147	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:40:31.989+00	2025-10-06 06:40:31.989+00	5
2980	up	3445	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:40:43.488+00	2025-10-06 06:40:43.488+00	1
2981	up	1221	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:41:07.738+00	2025-10-06 06:41:07.738+00	4
2982	up	245	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:41:12.077+00	2025-10-06 06:41:12.077+00	7
2983	up	186	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:41:21.823+00	2025-10-06 06:41:21.823+00	6
2984	up	164	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:41:31.86+00	2025-10-06 06:41:31.86+00	3
2985	up	186	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:41:32.025+00	2025-10-06 06:41:32.025+00	5
2986	up	2514	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:41:42.56+00	2025-10-06 06:41:42.56+00	1
2987	up	194	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:42:06.71+00	2025-10-06 06:42:06.71+00	4
2988	up	286	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:42:12.12+00	2025-10-06 06:42:12.12+00	7
2989	up	229	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:42:21.866+00	2025-10-06 06:42:21.866+00	6
2990	up	136	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:42:31.83+00	2025-10-06 06:42:31.83+00	3
2991	up	159	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:42:32.01+00	2025-10-06 06:42:32.01+00	5
2992	up	1471	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:42:41.519+00	2025-10-06 06:42:41.519+00	1
2993	up	234	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:43:06.752+00	2025-10-06 06:43:06.752+00	4
2994	up	193	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:43:12.032+00	2025-10-06 06:43:12.032+00	7
2995	up	208	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:43:21.844+00	2025-10-06 06:43:21.844+00	6
2996	up	259	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:43:31.958+00	2025-10-06 06:43:31.958+00	3
2997	up	202	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:43:32.055+00	2025-10-06 06:43:32.055+00	5
2998	up	4116	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:43:44.165+00	2025-10-06 06:43:44.165+00	1
2999	up	234	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:44:06.743+00	2025-10-06 06:44:06.743+00	4
3000	up	215	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:44:12.052+00	2025-10-06 06:44:12.052+00	7
3001	up	244	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:44:21.886+00	2025-10-06 06:44:21.886+00	6
3002	up	253	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:44:31.953+00	2025-10-06 06:44:31.953+00	3
3003	up	182	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:44:32.033+00	2025-10-06 06:44:32.033+00	5
3004	up	1399	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:44:41.449+00	2025-10-06 06:44:41.449+00	1
3005	up	191	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:45:06.712+00	2025-10-06 06:45:06.712+00	4
3006	up	138	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:45:11.98+00	2025-10-06 06:45:11.98+00	7
3007	up	134	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:45:21.773+00	2025-10-06 06:45:21.773+00	6
3008	up	360	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:45:32.07+00	2025-10-06 06:45:32.07+00	3
3009	up	376	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:45:32.253+00	2025-10-06 06:45:32.253+00	5
3010	up	2020	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:45:42.07+00	2025-10-06 06:45:42.07+00	1
3011	up	436	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:46:07.017+00	2025-10-06 06:46:07.017+00	4
3012	up	187	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:46:12.036+00	2025-10-06 06:46:12.036+00	7
3013	up	363	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:46:22.023+00	2025-10-06 06:46:22.023+00	6
3014	up	261	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:46:31.987+00	2025-10-06 06:46:31.987+00	3
3015	up	304	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:46:32.187+00	2025-10-06 06:46:32.187+00	5
3016	up	2527	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:46:42.578+00	2025-10-06 06:46:42.578+00	1
3017	up	582	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:47:07.151+00	2025-10-06 06:47:07.151+00	4
3018	up	225	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:47:12.071+00	2025-10-06 06:47:12.071+00	7
3019	up	304	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:47:21.952+00	2025-10-06 06:47:21.952+00	6
3020	up	309	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:47:32.029+00	2025-10-06 06:47:32.029+00	3
3021	up	255	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:47:32.123+00	2025-10-06 06:47:32.123+00	5
3022	up	2730	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:47:42.782+00	2025-10-06 06:47:42.782+00	1
3023	up	1320	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:48:07.879+00	2025-10-06 06:48:07.879+00	4
3024	up	404	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:48:12.264+00	2025-10-06 06:48:12.264+00	7
3025	up	314	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:48:21.96+00	2025-10-06 06:48:21.96+00	6
3026	up	308	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:48:32.035+00	2025-10-06 06:48:32.035+00	3
3027	up	380	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:48:32.249+00	2025-10-06 06:48:32.249+00	5
3028	up	7220	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:48:47.275+00	2025-10-06 06:48:47.275+00	1
3029	up	549	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:49:07.102+00	2025-10-06 06:49:07.102+00	4
3030	up	238	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:49:12.092+00	2025-10-06 06:49:12.092+00	7
3031	up	215	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:49:21.864+00	2025-10-06 06:49:21.864+00	6
3032	up	361	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:49:32.084+00	2025-10-06 06:49:32.084+00	3
3033	up	301	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:49:32.213+00	2025-10-06 06:49:32.213+00	5
3034	up	2255	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:49:42.327+00	2025-10-06 06:49:42.327+00	1
3035	up	397	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:50:06.95+00	2025-10-06 06:50:06.95+00	4
3036	up	250	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:50:12.107+00	2025-10-06 06:50:12.107+00	7
3037	up	318	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:50:21.97+00	2025-10-06 06:50:21.97+00	6
3038	up	448	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:50:32.168+00	2025-10-06 06:50:32.168+00	3
3039	up	557	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:50:32.483+00	2025-10-06 06:50:32.483+00	5
3040	up	6592	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:50:46.664+00	2025-10-06 06:50:46.664+00	1
3041	up	421	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:51:06.993+00	2025-10-06 06:51:06.993+00	4
3042	up	338	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:51:12.207+00	2025-10-06 06:51:12.207+00	7
3043	up	418	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:51:22.08+00	2025-10-06 06:51:22.08+00	6
3044	up	559	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:51:32.307+00	2025-10-06 06:51:32.307+00	3
3045	up	590	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:51:32.517+00	2025-10-06 06:51:32.517+00	5
3046	up	1730	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:51:41.805+00	2025-10-06 06:51:41.805+00	1
3047	up	1873	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:52:08.485+00	2025-10-06 06:52:08.485+00	4
3048	up	390	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:52:12.253+00	2025-10-06 06:52:12.253+00	7
3049	up	457	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:52:22.117+00	2025-10-06 06:52:22.117+00	6
3050	up	405	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:52:32.13+00	2025-10-06 06:52:32.13+00	3
3051	up	497	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:52:32.418+00	2025-10-06 06:52:32.418+00	5
3052	up	1630	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:52:41.706+00	2025-10-06 06:52:41.706+00	1
3053	up	449	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:53:07.046+00	2025-10-06 06:53:07.046+00	4
3054	up	422	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:53:12.286+00	2025-10-06 06:53:12.286+00	7
3055	up	311	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:53:21.972+00	2025-10-06 06:53:21.972+00	6
3056	up	393	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:53:32.118+00	2025-10-06 06:53:32.118+00	3
3057	up	448	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:53:32.374+00	2025-10-06 06:53:32.374+00	5
3058	up	3378	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:53:43.455+00	2025-10-06 06:53:43.455+00	1
3059	up	398	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:54:06.959+00	2025-10-06 06:54:06.959+00	4
3060	up	344	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:54:12.206+00	2025-10-06 06:54:12.206+00	7
3061	up	435	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:54:22.098+00	2025-10-06 06:54:22.098+00	6
3062	up	453	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:54:32.18+00	2025-10-06 06:54:32.18+00	3
3063	up	521	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:54:32.466+00	2025-10-06 06:54:32.466+00	5
3064	up	1557	200	Website is up (HTTP 200) [HTTP GET]	2025-10-06 06:54:41.636+00	2025-10-06 06:54:41.636+00	1
3065	up	335	200	Custom CURL successful (Status 200) [CUSTOM CURL]	2025-10-06 06:55:06.89+00	2025-10-06 06:55:06.89+00	4
3066	up	237	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:55:12.107+00	2025-10-06 06:55:12.107+00	7
3067	up	250	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:55:21.915+00	2025-10-06 06:55:21.915+00	6
3068	up	250	302	Website is up (CURL GET - Status 302) [CURL GET]	2025-10-06 06:55:31.973+00	2025-10-06 06:55:31.973+00	3
3069	up	377	200	Website is up (CURL GET - Status 200) [CURL GET]	2025-10-06 06:55:32.307+00	2025-10-06 06:55:32.307+00	5
\.


--
-- Data for Name: Users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Users" (id, username, email, password, "firstName", "lastName", phone, role, "telegramChatId", "isActive", "alertPreferences", "createdAt", "updatedAt") FROM stdin;
1	admin	nfuad32@gmail.com	$2b$12$1vzW8uOUMvD2pKM.T600CeInYdgY2G/Sy.EztWs8xUTJDDexKgUY.	System	Administrator	\N	admin	6728790693	t	{"email": true, "telegram": true, "minUptime": 80, "notifyOnUp": true, "quietHours": {"end": "06:00", "start": "22:00", "enabled": true}, "notifyOnDown": true, "alertCooldown": 30}	2025-10-01 22:27:57.767+00	2025-10-05 07:34:29.836+00
2	soc	toc@nagad.com.bd	$2b$12$L1BIlfpnvY5Nghap.tgQM.St2gDkY3CtOMCty2h9r2QwUJ8i6yw7i	\N	\N	\N	user	\N	t	{"email": true, "telegram": false, "minUptime": 99.5, "notifyOnUp": true, "quietHours": {"end": "06:00", "start": "22:00", "enabled": false}, "notifyOnDown": true, "alertCooldown": 30}	2025-10-05 09:13:04.204+00	2025-10-05 09:13:04.204+00
\.


--
-- Data for Name: Websites; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Websites" (id, url, name, "interval", "httpMethod", "expectedStatusCodes", "isActive", headers, "customCurlCommand", "createdAt", "updatedAt", "userId") FROM stdin;
1	https://google.com	GOOGLE	1	GET	{200,301,302}	t	[]	\N	2025-10-01 22:29:40.977+00	2025-10-01 22:29:40.977+00	1
4		ERP 	1	CUSTOM_CURL	{200,301,302}	t	[]	curl 'https://nagaderp.mynagad.com:7070/Security/User/SignInWithMenus' -H 'Accept: application/json, text/plain, */*' -H 'Accept-Language: en-US,en;q=0.9' -H 'Authorization: Bearer null' -H 'Connection: keep-alive' -H 'Content-Type: application/json;charset=UTF-8' -H 'Origin: https://nagaderp.mynagad.com:9090' -H 'Referer: https://nagaderp.mynagad.com:9090/' -H 'Sec-Fetch-Dest: empty' -H 'Sec-Fetch-Mode: cors' -H 'Sec-Fetch-Site: same-site' -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36' -H 'X-Requested-With: XMLHttpRequest' -H 'sec-ch-ua: "Chromium";v="140", "Not=A?Brand";v="24", "Google Chrome";v="140"' -H 'sec-ch-ua-mobile: ?0' -H 'sec-ch-ua-platform: "Windows"' --data-raw '{"UserName":"241075","Password":"Someonehere00@"}'	2025-10-05 07:37:26.018+00	2025-10-05 07:37:46.78+00	1
3	https://prportal.nidw.gov.bd/partner-portal/home	NID SERVER	1	CURL_GET	{200,301,302}	t	[]	\N	2025-10-05 07:32:49.397+00	2025-10-05 07:48:11.502+00	1
5	https://channel.mynagad.com:20010/	DMS Portal	1	CURL_GET	{200,301,302}	t	[]	\N	2025-10-05 07:54:11.602+00	2025-10-05 07:54:11.602+00	1
6	https://sys.mynagad.com:20020/	SYS Portal	1	CURL_GET	{200,301,302}	t	[]	\N	2025-10-05 07:56:02.166+00	2025-10-05 07:56:02.166+00	1
7	https://cc.mynagad.com:20030/	CC Portal	1	CURL_GET	{200,301,302}	t	[]	\N	2025-10-05 07:56:52.602+00	2025-10-05 07:56:52.602+00	1
\.


--
-- Name: Alerts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Alerts_id_seq"', 103, true);


--
-- Name: MonitorLogs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."MonitorLogs_id_seq"', 3069, true);


--
-- Name: Users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Users_id_seq"', 2, true);


--
-- Name: Websites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Websites_id_seq"', 8, true);


--
-- Name: Alerts Alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Alerts"
    ADD CONSTRAINT "Alerts_pkey" PRIMARY KEY (id);


--
-- Name: MonitorLogs MonitorLogs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."MonitorLogs"
    ADD CONSTRAINT "MonitorLogs_pkey" PRIMARY KEY (id);


--
-- Name: Users Users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key" UNIQUE (email);


--
-- Name: Users Users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_pkey" PRIMARY KEY (id);


--
-- Name: Users Users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_username_key" UNIQUE (username);


--
-- Name: Websites Websites_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Websites"
    ADD CONSTRAINT "Websites_pkey" PRIMARY KEY (id);


--
-- Name: Alerts Alerts_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Alerts"
    ADD CONSTRAINT "Alerts_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Alerts Alerts_websiteId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Alerts"
    ADD CONSTRAINT "Alerts_websiteId_fkey" FOREIGN KEY ("websiteId") REFERENCES public."Websites"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: MonitorLogs MonitorLogs_websiteId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."MonitorLogs"
    ADD CONSTRAINT "MonitorLogs_websiteId_fkey" FOREIGN KEY ("websiteId") REFERENCES public."Websites"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Websites Websites_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Websites"
    ADD CONSTRAINT "Websites_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict 1bthCmbix2Uu3ylj80vd9St4x0el1vbg9s5PJxp00DHNuDt1Zb29rVCEVzSNrUZ

