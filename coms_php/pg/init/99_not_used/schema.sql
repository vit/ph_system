--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.4
-- Dumped by pg_dump version 9.5.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'WIN1251';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: cmsconfschema; Type: SCHEMA; Schema: -; Owner: db00060892
--

CREATE SCHEMA cmsconfschema;


ALTER SCHEMA cmsconfschema OWNER TO db00060892;

--
-- Name: cmsmlschema; Type: SCHEMA; Schema: -; Owner: db00060892
--

CREATE SCHEMA cmsmlschema;


ALTER SCHEMA cmsmlschema OWNER TO db00060892;

--
-- Name: coms01; Type: SCHEMA; Schema: -; Owner: db00060892
--

CREATE SCHEMA coms01;


ALTER SCHEMA coms01 OWNER TO db00060892;

--
-- Name: comsml01; Type: SCHEMA; Schema: -; Owner: db00060892
--

CREATE SCHEMA comsml01;


ALTER SCHEMA comsml01 OWNER TO db00060892;

--
-- Name: lib01; Type: SCHEMA; Schema: -; Owner: db00060892
--

CREATE SCHEMA lib01;


ALTER SCHEMA lib01 OWNER TO db00060892;

--
-- Name: membership01; Type: SCHEMA; Schema: -; Owner: db00060892
--

CREATE SCHEMA membership01;


ALTER SCHEMA membership01 OWNER TO db00060892;

--
-- Name: newsschema; Type: SCHEMA; Schema: -; Owner: db00060892
--

CREATE SCHEMA newsschema;


ALTER SCHEMA newsschema OWNER TO db00060892;

--
-- Name: portalschema; Type: SCHEMA; Schema: -; Owner: db00060892
--

CREATE SCHEMA portalschema;


ALTER SCHEMA portalschema OWNER TO db00060892;

--
-- Name: statschema; Type: SCHEMA; Schema: -; Owner: db00060892
--

CREATE SCHEMA statschema;


ALTER SCHEMA statschema OWNER TO db00060892;

--
-- Name: subscriptionschema; Type: SCHEMA; Schema: -; Owner: db00060892
--

CREATE SCHEMA subscriptionschema;


ALTER SCHEMA subscriptionschema OWNER TO db00060892;

--
-- Name: userschema; Type: SCHEMA; Schema: -; Owner: db00060892
--

CREATE SCHEMA userschema;


ALTER SCHEMA userschema OWNER TO db00060892;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = portalschema, pg_catalog;

--
-- Name: cat2list; Type: TYPE; Schema: portalschema; Owner: db00060892
--

CREATE TYPE cat2list AS (
	catid bigint,
	title character varying,
	catid2 bigint,
	title2 character varying
);


ALTER TYPE cat2list OWNER TO db00060892;

--
-- Name: catrestoplist; Type: TYPE; Schema: portalschema; Owner: db00060892
--

CREATE TYPE catrestoplist AS (
	cnt integer,
	topid bigint,
	toptit character varying,
	resid bigint,
	url character varying,
	title character varying,
	description text,
	isevent boolean,
	diapazon character varying,
	place character varying
);


ALTER TYPE catrestoplist OWNER TO db00060892;

SET search_path = userschema, pg_catalog;

--
-- Name: gendertype; Type: DOMAIN; Schema: userschema; Owner: db00060892
--

CREATE DOMAIN gendertype AS character(6)
	CONSTRAINT "$1" CHECK (((VALUE = 'Male'::bpchar) OR (VALUE = 'Female'::bpchar)));


ALTER DOMAIN gendertype OWNER TO db00060892;

SET search_path = cmsconfschema, pg_catalog;

--
-- Name: addnewpaper(integer, integer, character varying, text); Type: FUNCTION; Schema: cmsconfschema; Owner: db00060892
--

CREATE FUNCTION addnewpaper(_contid integer, _registrator integer, _title character varying, _abstract text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
  num INTEGER;
BEGIN
  SELECT createnewpapnum(_contid) INTO num;
  INSERT INTO paper (context, papnum, registrator, title, abstract)
    VALUES (_contid, num, _registrator, _title, _abstract);
  RETURN num;
END;
$$;


ALTER FUNCTION cmsconfschema.addnewpaper(_contid integer, _registrator integer, _title character varying, _abstract text) OWNER TO db00060892;

--
-- Name: createnewpapnum(integer); Type: FUNCTION; Schema: cmsconfschema; Owner: db00060892
--

CREATE FUNCTION createnewpapnum(_contid integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
  num INTEGER;
BEGIN
  SELECT max(papnum) FROM paper WHERE context=_contid INTO num;
  IF num IS NULL THEN
    num := 0;
  END IF;
  num := num + 1;
  RETURN num;
END;
$$;


ALTER FUNCTION cmsconfschema.createnewpapnum(_contid integer) OWNER TO db00060892;

SET search_path = coms01, pg_catalog;

--
-- Name: addnewpaper(integer, integer, character varying, text, integer, integer); Type: FUNCTION; Schema: coms01; Owner: db00060892
--

CREATE FUNCTION addnewpaper(_contid integer, _registrator integer, _title character varying, _abstract text, _subject integer, _presenttype integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
  num INTEGER;
BEGIN
  SELECT createnewnumber(_contid, 1) INTO num;
  INSERT INTO paper (context, papnum, registrator, title, abstract, subject, presenttype)
    VALUES (_contid, num, _registrator, _title, _abstract, _subject, _presenttype);
  RETURN num;
END;
$$;


ALTER FUNCTION coms01.addnewpaper(_contid integer, _registrator integer, _title character varying, _abstract text, _subject integer, _presenttype integer) OWNER TO db00060892;

--
-- Name: addnewpaper2(integer, integer, character varying, text, character varying, integer, integer); Type: FUNCTION; Schema: coms01; Owner: db00060892
--

CREATE FUNCTION addnewpaper2(integer, integer, character varying, text, character varying, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
_contid ALIAS FOR $1;
_registrator ALIAS FOR $2;
_title ALIAS FOR $3;
_abstract ALIAS FOR $4;
_authors ALIAS FOR $5;
_subject ALIAS FOR $6;
_presenttype ALIAS FOR $7;
num INTEGER;
BEGIN
  SELECT createnewnumber(_contid, 1) INTO num;
  INSERT INTO paper (context, papnum, registrator, title, abstract, authors, subject, presenttype)
    VALUES (_contid, num, _registrator, _title, _abstract, _authors, _subject, _presenttype);
  RETURN num;
END;
$_$;


ALTER FUNCTION coms01.addnewpaper2(integer, integer, character varying, text, character varying, integer, integer) OWNER TO db00060892;

--
-- Name: concatpaperauthors(integer, integer); Type: FUNCTION; Schema: coms01; Owner: db00060892
--

CREATE FUNCTION concatpaperauthors(integer, integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
_context ALIAS FOR $1;
_papnum ALIAS FOR $2;
_rec RECORD;
_result VARCHAR;
BEGIN
  _result := NULL;

  FOR _rec IN SELECT getfullnamewithpin(autpin) AS name, autpin
                FROM author
                WHERE context=_context AND papnum=_papnum
                ORDER BY autpin
  LOOP
    IF _result IS NULL THEN
      _result := _rec.name;
    ELSE
      _result := _result || ', ' || _rec.name;
    END IF;

  END LOOP;


  RETURN _result;
END;
$_$;


ALTER FUNCTION coms01.concatpaperauthors(integer, integer) OWNER TO db00060892;

--
-- Name: concatpaperauthorswopin(integer, integer); Type: FUNCTION; Schema: coms01; Owner: db00060892
--

CREATE FUNCTION concatpaperauthorswopin(integer, integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
_context ALIAS FOR $1;
_papnum ALIAS FOR $2;
_rec RECORD;
_result VARCHAR;
BEGIN
  _result := NULL;

  FOR _rec IN SELECT getfullnamewopin(autpin) AS name, autpin
                FROM author
                WHERE context=_context AND papnum=_papnum
                ORDER BY autpin
  LOOP
    IF _result IS NULL THEN
      _result := _rec.name;
    ELSE
      _result := _result || ', ' || _rec.name;
    END IF;

  END LOOP;


  RETURN _result;
END;
$_$;


ALTER FUNCTION coms01.concatpaperauthorswopin(integer, integer) OWNER TO db00060892;

--
-- Name: concatpaperkeywords(integer, integer, integer); Type: FUNCTION; Schema: coms01; Owner: db00060892
--

CREATE FUNCTION concatpaperkeywords(integer, integer, integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
_context ALIAS FOR $1;
_papnum ALIAS FOR $2;
_weight ALIAS FOR $3;
_rec RECORD;
_result VARCHAR;
BEGIN
  _result := NULL;

  FOR _rec IN SELECT k.name
                FROM pap_kw AS pk INNER JOIN keyword AS k 
                  ON pk.context=_context AND 
                     pk.papnum=_papnum AND 
                     pk.weight=_weight AND 
                     pk.keyword=k.kwid
                ORDER BY name
  LOOP
    IF _result IS NULL THEN
      _result := _rec.name;
    ELSE
      _result := _result || ', ' || _rec.name;
    END IF;

  END LOOP;


  RETURN _result;
END;
$_$;


ALTER FUNCTION coms01.concatpaperkeywords(integer, integer, integer) OWNER TO db00060892;

--
-- Name: createnewnumber(integer, integer); Type: FUNCTION; Schema: coms01; Owner: db00060892
--

CREATE FUNCTION createnewnumber(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
_context ALIAS FOR $1;
_topic ALIAS FOR $2;
_num INTEGER;
_n INTEGER;
BEGIN
  SELECT COUNT(*) FROM contseq WHERE context=_context AND topic=_topic INTO _n;
  IF _n = 0 THEN
    INSERT INTO contseq (context, topic, lastvalue) VALUES(_context, _topic, 0);
  END IF;
  UPDATE contseq SET lastvalue = lastvalue + 1 WHERE context=_context AND topic=_topic;
  SELECT lastvalue FROM contseq WHERE context=_context AND topic=_topic INTO _num;
  RETURN _num;
END;
$_$;


ALTER FUNCTION coms01.createnewnumber(integer, integer) OWNER TO db00060892;

--
-- Name: getfullnamewithpin(integer); Type: FUNCTION; Schema: coms01; Owner: db00060892
--

CREATE FUNCTION getfullnamewithpin(integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
_pin ALIAS FOR $1;
_result VARCHAR;
BEGIN
--  SELECT t.shortstr || ' ' || u.fname || ' ' || u.lname || ' (PIN:' || u.pin || ')'
  SELECT t.shortstr || ' ' || u.fname || ' ' || u.lname || ' (PIN:' || u.pin || ')'
    FROM userschema.userpin AS u
      LEFT JOIN userschema.title AS t ON t.titleid=u.title
    WHERE u.pin=_pin
    INTO _result;
  RETURN _result;
END;
$_$;


ALTER FUNCTION coms01.getfullnamewithpin(integer) OWNER TO db00060892;

--
-- Name: getfullnamewopin(integer); Type: FUNCTION; Schema: coms01; Owner: db00060892
--

CREATE FUNCTION getfullnamewopin(integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
_pin ALIAS FOR $1;
_result VARCHAR;
BEGIN
  SELECT t.shortstr || ' ' || u.fname || ' ' || u.lname
    FROM userschema.userpin AS u
      LEFT JOIN userschema.title AS t ON t.titleid=u.title
    WHERE u.pin=_pin
    INTO _result;
  RETURN _result;
END;
$_$;


ALTER FUNCTION coms01.getfullnamewopin(integer) OWNER TO db00060892;

SET search_path = comsml01, pg_catalog;

--
-- Name: nulltochar(character varying); Type: FUNCTION; Schema: comsml01; Owner: db00060892
--

CREATE FUNCTION nulltochar(character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
BEGIN
  IF $1 IS NULL THEN
    RETURN '';
  ELSE
    RETURN $1;
  END IF;
END;
$_$;


ALTER FUNCTION comsml01.nulltochar(character varying) OWNER TO db00060892;

--
-- Name: producer_editorsall(integer, integer, integer, integer); Type: FUNCTION; Schema: comsml01; Owner: db00060892
--

CREATE FUNCTION producer_editorsall(integer, integer, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
_tid ALIAS FOR $1;
_mlid ALIAS FOR $2;
_contid ALIAS FOR $3;
_status ALIAS FOR $4;

_argname varchar[];
_argvalue varchar[];

_rec RECORD;

BEGIN

  FOR _rec IN
    SELECT
      u.pin AS pin, u.pass AS password,
      u.fname AS fname, u.lname AS lname,
      u.email AS email,
      t.shortstr AS usertitle,
      getfullnamewithpin(u.pin) AS userfullname,
      c.contid AS contid, c.title AS conttitle
    FROM 
      ((editor AS e LEFT JOIN userpin AS u ON e.userpin=u.pin)
      LEFT JOIN title AS t ON u.title=t.titleid)
      LEFT JOIN context AS c ON e.context=c.contid
    WHERE e.context=_contid
  LOOP
    _argname = '{}'::varchar[];
    _argvalue = '{}'::varchar[];

    _argname[0] := 'CONTEXTID';
    _argvalue[0] := nulltochar(_contid::varchar);

    _argname[1] := 'PIN';
    _argvalue[1] := nulltochar(_rec.pin::varchar);
    _argname[2] := 'PASSWORD';
    _argvalue[2] := nulltochar(_rec.password);
    _argname[3] := 'TITLE';
    _argvalue[3] := nulltochar(_rec.usertitle);
    _argname[4] := 'FNAME';
    _argvalue[4] := nulltochar(_rec.fname);
    _argname[5] := 'LNAME';
    _argvalue[5] := nulltochar(_rec.lname);
    _argname[6] := 'EMAIL';
    _argvalue[6] := nulltochar(_rec.email);

--    _argname[7] := 'CONTID';
--    _argvalue[7] := nulltochar(_rec.contid::varchar);

    _argname[7] := 'CONTTITLE';
    _argvalue[7] := nulltochar(_rec.conttitle);


    PERFORM putToQueue(_tid, _argname, _argvalue, _status);

  END LOOP;


  RETURN 0;
END;
$_$;


ALTER FUNCTION comsml01.producer_editorsall(integer, integer, integer, integer) OWNER TO db00060892;

--
-- Name: producer_ipacsmembersall(integer, integer, integer, integer); Type: FUNCTION; Schema: comsml01; Owner: db00060892
--

CREATE FUNCTION producer_ipacsmembersall(integer, integer, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
_tid ALIAS FOR $1;
_mlid ALIAS FOR $2;
_contid ALIAS FOR $3;
_status ALIAS FOR $4;

_argname varchar[];
_argvalue varchar[];

_rec RECORD;

BEGIN

  FOR _rec IN
    SELECT
      u.pin AS pin, u.pass AS password,
      u.fname AS fname, u.lname AS lname,
      u.email AS email,
      t.shortstr AS usertitle,
      getfullnamewithpin(u.pin) AS userfullname,
      c.contid AS contid, c.title AS conttitle
    FROM 
      ((membership01.ipacs_member AS m LEFT JOIN userpin AS u ON m.userpin=u.pin)
      LEFT JOIN title AS t ON u.title=t.titleid)
--      LEFT JOIN context AS c ON e.context=c.contid
      LEFT JOIN context AS c ON _contid=c.contid
--    WHERE e.context=_contid
--    WHERE c.cont_id=_contid
  LOOP
    _argname = '{}'::varchar[];
    _argvalue = '{}'::varchar[];

    _argname[0] := 'CONTEXTID';
    _argvalue[0] := nulltochar(_contid::varchar);

    _argname[1] := 'PIN';
    _argvalue[1] := nulltochar(_rec.pin::varchar);
    _argname[2] := 'PASSWORD';
    _argvalue[2] := nulltochar(_rec.password);
    _argname[3] := 'TITLE';
    _argvalue[3] := nulltochar(_rec.usertitle);
    _argname[4] := 'FNAME';
    _argvalue[4] := nulltochar(_rec.fname);
    _argname[5] := 'LNAME';
    _argvalue[5] := nulltochar(_rec.lname);
    _argname[6] := 'EMAIL';
    _argvalue[6] := nulltochar(_rec.email);

--    _argname[7] := 'CONTID';
--    _argvalue[7] := nulltochar(_rec.contid::varchar);

    _argname[7] := 'CONTTITLE';
    _argvalue[7] := nulltochar(_rec.conttitle);


    PERFORM putToQueue(_tid, _argname, _argvalue, _status);

  END LOOP;


  RETURN 0;
END;
$_$;


ALTER FUNCTION comsml01.producer_ipacsmembersall(integer, integer, integer, integer) OWNER TO db00060892;

--
-- Name: producer_regautpapall(integer, integer, integer, integer); Type: FUNCTION; Schema: comsml01; Owner: db00060892
--

CREATE FUNCTION producer_regautpapall(integer, integer, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
BEGIN
  PERFORM producer_regautpapdecall($1, $2, $3, $4, -1);
  RETURN 0;
END;
$_$;


ALTER FUNCTION comsml01.producer_regautpapall(integer, integer, integer, integer) OWNER TO db00060892;

--
-- Name: producer_regautpapallaccepted(integer, integer, integer, integer); Type: FUNCTION; Schema: comsml01; Owner: db00060892
--

CREATE FUNCTION producer_regautpapallaccepted(integer, integer, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
BEGIN
  PERFORM producer_regautpapdecall($1, $2, $3, $4, 2);
  PERFORM producer_regautpapdecall($1, $2, $3, $4, 3);
  PERFORM producer_regautpapdecall($1, $2, $3, $4, 4);
  RETURN 0;
END;
$_$;


ALTER FUNCTION comsml01.producer_regautpapallaccepted(integer, integer, integer, integer) OWNER TO db00060892;

--
-- Name: producer_regautpapdec1(integer, integer, integer, integer); Type: FUNCTION; Schema: comsml01; Owner: db00060892
--

CREATE FUNCTION producer_regautpapdec1(integer, integer, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
BEGIN
  PERFORM producer_regautpapdecall($1, $2, $3, $4, 1);
  RETURN 0;
END;
$_$;


ALTER FUNCTION comsml01.producer_regautpapdec1(integer, integer, integer, integer) OWNER TO db00060892;

--
-- Name: producer_regautpapdec2(integer, integer, integer, integer); Type: FUNCTION; Schema: comsml01; Owner: db00060892
--

CREATE FUNCTION producer_regautpapdec2(integer, integer, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
BEGIN
  PERFORM producer_regautpapdecall($1, $2, $3, $4, 2);
  RETURN 0;
END;
$_$;


ALTER FUNCTION comsml01.producer_regautpapdec2(integer, integer, integer, integer) OWNER TO db00060892;

--
-- Name: producer_regautpapdec3(integer, integer, integer, integer); Type: FUNCTION; Schema: comsml01; Owner: db00060892
--

CREATE FUNCTION producer_regautpapdec3(integer, integer, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
BEGIN
  PERFORM producer_regautpapdecall($1, $2, $3, $4, 3);
  RETURN 0;
END;
$_$;


ALTER FUNCTION comsml01.producer_regautpapdec3(integer, integer, integer, integer) OWNER TO db00060892;

--
-- Name: producer_regautpapdec4(integer, integer, integer, integer); Type: FUNCTION; Schema: comsml01; Owner: db00060892
--

CREATE FUNCTION producer_regautpapdec4(integer, integer, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
BEGIN
  PERFORM producer_regautpapdecall($1, $2, $3, $4, 4);
  RETURN 0;
END;
$_$;


ALTER FUNCTION comsml01.producer_regautpapdec4(integer, integer, integer, integer) OWNER TO db00060892;

--
-- Name: producer_regautpapdecall(integer, integer, integer, integer, integer); Type: FUNCTION; Schema: comsml01; Owner: db00060892
--

CREATE FUNCTION producer_regautpapdecall(integer, integer, integer, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
_tid ALIAS FOR $1;
_mlid ALIAS FOR $2;
_contid ALIAS FOR $3;
_status ALIAS FOR $4;
_dec ALIAS FOR $5;

_argname varchar[];
_argvalue varchar[];

_rec RECORD;

BEGIN

  FOR _rec IN
    SELECT
      p.*,
      u.pin AS pin, u.pass AS password,
      u.fname AS fname, u.lname AS lname,
      u.email AS email,
      t.shortstr AS usertitle,
      concatpaperauthors(p.context, p.papnum) AS authors,
      concatpaperkeywords(p.context, p.papnum, 3) AS keywords1,
      concatpaperkeywords(p.context, p.papnum, 2) AS keywords2,
--      getfullnamewithpin(p.registrator) AS registratorname
      getfullnamewopin(p.registrator) AS registratorname
    FROM 
      (paper AS p LEFT JOIN userpin AS u ON p.registrator=u.pin)
      LEFT JOIN title AS t ON u.title=t.titleid
    WHERE p.context=_contid AND (p.finaldecision=_dec OR _dec<0)
    UNION
    SELECT
      p.*,
      u.pin AS pin, u.pass AS password,
      u.fname AS fname, u.lname AS lname,
      u.email AS email,
      t.shortstr AS usertitle,
      concatpaperauthors(p.context, p.papnum) AS authors,
      concatpaperkeywords(p.context, p.papnum, 3) AS keywords1,
      concatpaperkeywords(p.context, p.papnum, 2) AS keywords2,
--      getfullnamewithpin(p.registrator) AS registratorname
      getfullnamewopin(p.registrator) AS registratorname
    FROM 
      (
       (
        paper AS p
          INNER JOIN
            author AS a
            ON p.context=a.context AND p.papnum=a.papnum
       )
         LEFT JOIN userpin AS u ON a.autpin=u.pin
      )
      LEFT JOIN title AS t ON u.title=t.titleid
    WHERE p.context=_contid AND (p.finaldecision=_dec OR _dec<0)

  LOOP
    _argname = '{}'::varchar[];
    _argvalue = '{}'::varchar[];

    _argname[0] := 'CONTEXTID';
    _argvalue[0] := nulltochar(_contid::varchar);

    _argname[1] := 'PIN';
    _argvalue[1] := nulltochar(_rec.pin::varchar);
    _argname[2] := 'PASSWORD';
    _argvalue[2] := nulltochar(_rec.password);
    _argname[3] := 'TITLE';
    _argvalue[3] := nulltochar(_rec.usertitle);
    _argname[4] := 'FNAME';
    _argvalue[4] := nulltochar(_rec.fname);
    _argname[5] := 'LNAME';
    _argvalue[5] := nulltochar(_rec.lname);
    _argname[6] := 'EMAIL';
    _argvalue[6] := nulltochar(_rec.email);

    _argname[7] := 'PAPID';
    _argvalue[7] := nulltochar(_rec.papnum::varchar);
    _argname[8] := 'PAPTITLE';
    _argvalue[8] := nulltochar(_rec.title);
    _argname[9] := 'PAPREGISTRATOR';
    _argvalue[9] := nulltochar(_rec.registratorname);

    PERFORM putToQueue(_tid, _argname, _argvalue, _status);

  END LOOP;


  RETURN 0;
END;
$_$;


ALTER FUNCTION comsml01.producer_regautpapdecall(integer, integer, integer, integer, integer) OWNER TO db00060892;

--
-- Name: producer_regpapall(integer, integer, integer, integer); Type: FUNCTION; Schema: comsml01; Owner: db00060892
--

CREATE FUNCTION producer_regpapall(integer, integer, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
BEGIN
  PERFORM producer_regpapdecall($1, $2, $3, $4, -1);
  RETURN 0;
END;
$_$;


ALTER FUNCTION comsml01.producer_regpapall(integer, integer, integer, integer) OWNER TO db00060892;

--
-- Name: producer_regpapdec1(integer, integer, integer, integer); Type: FUNCTION; Schema: comsml01; Owner: db00060892
--

CREATE FUNCTION producer_regpapdec1(integer, integer, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
BEGIN
  PERFORM producer_regpapdecall($1, $2, $3, $4, 1);
  RETURN 0;
END;
$_$;


ALTER FUNCTION comsml01.producer_regpapdec1(integer, integer, integer, integer) OWNER TO db00060892;

--
-- Name: producer_regpapdec2(integer, integer, integer, integer); Type: FUNCTION; Schema: comsml01; Owner: db00060892
--

CREATE FUNCTION producer_regpapdec2(integer, integer, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
BEGIN
  PERFORM producer_regpapdecall($1, $2, $3, $4, 2);
  RETURN 0;
END;
$_$;


ALTER FUNCTION comsml01.producer_regpapdec2(integer, integer, integer, integer) OWNER TO db00060892;

--
-- Name: producer_regpapdec3(integer, integer, integer, integer); Type: FUNCTION; Schema: comsml01; Owner: db00060892
--

CREATE FUNCTION producer_regpapdec3(integer, integer, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
BEGIN
  PERFORM producer_regpapdecall($1, $2, $3, $4, 3);
  RETURN 0;
END;
$_$;


ALTER FUNCTION comsml01.producer_regpapdec3(integer, integer, integer, integer) OWNER TO db00060892;

--
-- Name: producer_regpapdec4(integer, integer, integer, integer); Type: FUNCTION; Schema: comsml01; Owner: db00060892
--

CREATE FUNCTION producer_regpapdec4(integer, integer, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
BEGIN
  PERFORM producer_regpapdecall($1, $2, $3, $4, 4);
  RETURN 0;
END;
$_$;


ALTER FUNCTION comsml01.producer_regpapdec4(integer, integer, integer, integer) OWNER TO db00060892;

--
-- Name: producer_regpapdecall(integer, integer, integer, integer, integer); Type: FUNCTION; Schema: comsml01; Owner: db00060892
--

CREATE FUNCTION producer_regpapdecall(integer, integer, integer, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
_tid ALIAS FOR $1;
_mlid ALIAS FOR $2;
_contid ALIAS FOR $3;
_status ALIAS FOR $4;
_dec ALIAS FOR $5;

_argname varchar[];
_argvalue varchar[];

_rec RECORD;

BEGIN
--  _argname = '{}'::varchar[];
--  _argvalue = '{}'::varchar[];

--  _cnt := 0;
  FOR _rec IN
    SELECT
      p.*,
      u.pin AS pin, u.pass AS password,
      u.fname AS fname, u.lname AS lname,
      u.email AS email,
      t.shortstr AS usertitle,
      concatpaperauthors(p.context, p.papnum) AS authors,
      concatpaperkeywords(p.context, p.papnum, 3) AS keywords1,
      concatpaperkeywords(p.context, p.papnum, 2) AS keywords2,
      getfullnamewithpin(p.registrator) AS registratorname
    FROM 
      (paper AS p LEFT JOIN userpin AS u ON p.registrator=u.pin)
      LEFT JOIN title AS t ON u.title=t.titleid
    WHERE p.context=_contid AND (p.finaldecision=_dec OR _dec<0)
  LOOP
    _argname = '{}'::varchar[];
    _argvalue = '{}'::varchar[];

    _argname[0] := 'CONTEXTID';
    _argvalue[0] := nulltochar(_contid::varchar);

    _argname[1] := 'PIN';
    _argvalue[1] := nulltochar(_rec.pin::varchar);
    _argname[2] := 'PASSWORD';
    _argvalue[2] := nulltochar(_rec.password);
    _argname[3] := 'TITLE';
    _argvalue[3] := nulltochar(_rec.usertitle);
    _argname[4] := 'FNAME';
    _argvalue[4] := nulltochar(_rec.fname);
    _argname[5] := 'LNAME';
    _argvalue[5] := nulltochar(_rec.lname);
    _argname[6] := 'EMAIL';
    _argvalue[6] := nulltochar(_rec.email);

    _argname[7] := 'PAPID';
    _argvalue[7] := nulltochar(_rec.papnum::varchar);
    _argname[8] := 'PAPTITLE';
    _argvalue[8] := nulltochar(_rec.title);

    PERFORM putToQueue(_tid, _argname, _argvalue, _status);

  END LOOP;


  RETURN 0;
END;
$_$;


ALTER FUNCTION comsml01.producer_regpapdecall(integer, integer, integer, integer, integer) OWNER TO db00060892;

--
-- Name: producer_reviewersall(integer, integer, integer, integer); Type: FUNCTION; Schema: comsml01; Owner: db00060892
--

CREATE FUNCTION producer_reviewersall(integer, integer, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
_tid ALIAS FOR $1;
_mlid ALIAS FOR $2;
_contid ALIAS FOR $3;
_status ALIAS FOR $4;

_argname varchar[];
_argvalue varchar[];

_rec RECORD;

BEGIN

  FOR _rec IN
    SELECT DISTINCT
      u.pin AS pin, u.pass AS password,
      u.fname AS fname, u.lname AS lname,
      u.email AS email,
      t.shortstr AS usertitle,
      getfullnamewithpin(u.pin) AS userfullname,
      c.contid AS contid, c.title AS conttitle
    FROM 
      ((review AS r LEFT JOIN userpin AS u ON r.revpin=u.pin)
      LEFT JOIN title AS t ON u.title=t.titleid)
      LEFT JOIN context AS c ON r.context=c.contid
    WHERE r.context=_contid 
-- AND (r.score>0 OR r.recommendation>0)
    ORDER BY u.pin
  LOOP
    _argname = '{}'::varchar[];
    _argvalue = '{}'::varchar[];

    _argname[0] := 'CONTEXTID';
    _argvalue[0] := nulltochar(_contid::varchar);

    _argname[1] := 'PIN';
    _argvalue[1] := nulltochar(_rec.pin::varchar);
    _argname[2] := 'PASSWORD';
    _argvalue[2] := nulltochar(_rec.password);
    _argname[3] := 'TITLE';
    _argvalue[3] := nulltochar(_rec.usertitle);
    _argname[4] := 'FNAME';
    _argvalue[4] := nulltochar(_rec.fname);
    _argname[5] := 'LNAME';
    _argvalue[5] := nulltochar(_rec.lname);
    _argname[6] := 'EMAIL';
    _argvalue[6] := nulltochar(_rec.email);

--    _argname[7] := 'CONTID';
--    _argvalue[7] := nulltochar(_rec.contid::varchar);

    _argname[7] := 'CONTTITLE';
    _argvalue[7] := nulltochar(_rec.conttitle);


    PERFORM putToQueue(_tid, _argname, _argvalue, _status);

  END LOOP;


  RETURN 0;
END;
$_$;


ALTER FUNCTION comsml01.producer_reviewersall(integer, integer, integer, integer) OWNER TO db00060892;

--
-- Name: producer_reviewersgood(integer, integer, integer, integer); Type: FUNCTION; Schema: comsml01; Owner: db00060892
--

CREATE FUNCTION producer_reviewersgood(integer, integer, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
_tid ALIAS FOR $1;
_mlid ALIAS FOR $2;
_contid ALIAS FOR $3;
_status ALIAS FOR $4;

_argname varchar[];
_argvalue varchar[];

_rec RECORD;

BEGIN

  FOR _rec IN
    SELECT DISTINCT
      u.pin AS pin, u.pass AS password,
      u.fname AS fname, u.lname AS lname,
      u.email AS email,
      t.shortstr AS usertitle,
      getfullnamewithpin(u.pin) AS userfullname,
      c.contid AS contid, c.title AS conttitle
    FROM 
      ((review AS r LEFT JOIN userpin AS u ON r.revpin=u.pin)
      LEFT JOIN title AS t ON u.title=t.titleid)
      LEFT JOIN context AS c ON r.context=c.contid
    WHERE r.context=_contid AND (r.score>0 OR r.recommendation>0)
    ORDER BY u.pin
  LOOP
    _argname = '{}'::varchar[];
    _argvalue = '{}'::varchar[];

    _argname[0] := 'CONTEXTID';
    _argvalue[0] := nulltochar(_contid::varchar);

    _argname[1] := 'PIN';
    _argvalue[1] := nulltochar(_rec.pin::varchar);
    _argname[2] := 'PASSWORD';
    _argvalue[2] := nulltochar(_rec.password);
    _argname[3] := 'TITLE';
    _argvalue[3] := nulltochar(_rec.usertitle);
    _argname[4] := 'FNAME';
    _argvalue[4] := nulltochar(_rec.fname);
    _argname[5] := 'LNAME';
    _argvalue[5] := nulltochar(_rec.lname);
    _argname[6] := 'EMAIL';
    _argvalue[6] := nulltochar(_rec.email);

--    _argname[7] := 'CONTID';
--    _argvalue[7] := nulltochar(_rec.contid::varchar);

    _argname[7] := 'CONTTITLE';
    _argvalue[7] := nulltochar(_rec.conttitle);


    PERFORM putToQueue(_tid, _argname, _argvalue, _status);

  END LOOP;


  RETURN 0;
END;
$_$;


ALTER FUNCTION comsml01.producer_reviewersgood(integer, integer, integer, integer) OWNER TO db00060892;

--
-- Name: producer_usersenabled(integer, integer, integer, integer); Type: FUNCTION; Schema: comsml01; Owner: db00060892
--

CREATE FUNCTION producer_usersenabled(integer, integer, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
_tid ALIAS FOR $1;
_mlid ALIAS FOR $2;
_contid ALIAS FOR $3;
_status ALIAS FOR $4;

_argname varchar[];
_argvalue varchar[];

_rec RECORD;

BEGIN

  FOR _rec IN
    SELECT
      u.pin AS pin, u.pass AS password,
      u.fname AS fname, u.lname AS lname,
      u.email AS email,
      t.shortstr AS usertitle,
      getfullnamewithpin(u.pin) AS userfullname
    FROM 
      userpin AS u LEFT JOIN title AS t ON u.title=t.titleid
    WHERE enabled
  LOOP
    _argname = '{}'::varchar[];
    _argvalue = '{}'::varchar[];

    _argname[0] := 'PIN';
    _argvalue[0] := nulltochar(_rec.pin::varchar);
    _argname[1] := 'PASSWORD';
    _argvalue[1] := nulltochar(_rec.password);
    _argname[2] := 'TITLE';
    _argvalue[2] := nulltochar(_rec.usertitle);
    _argname[3] := 'FNAME';
    _argvalue[3] := nulltochar(_rec.fname);
    _argname[4] := 'LNAME';
    _argvalue[4] := nulltochar(_rec.lname);
    _argname[5] := 'EMAIL';
    _argvalue[5] := nulltochar(_rec.email);



    PERFORM putToQueue(_tid, _argname, _argvalue, _status);

  END LOOP;


  RETURN 0;
END;
$_$;


ALTER FUNCTION comsml01.producer_usersenabled(integer, integer, integer, integer) OWNER TO db00060892;

--
-- Name: puttoqueue(integer, character varying[], character varying[], integer); Type: FUNCTION; Schema: comsml01; Owner: db00060892
--

CREATE FUNCTION puttoqueue(integer, character varying[], character varying[], integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
_tid ALIAS FOR $1;
_argname ALIAS FOR $2;
_argvalue ALIAS FOR $3;
_status ALIAS FOR $4;
BEGIN

  INSERT INTO mlqueue(task, argname, argvalue, status, error) VALUES(_tid, _argname, _argvalue, _status, 0);

  RETURN 0;
END;
$_$;


ALTER FUNCTION comsml01.puttoqueue(integer, character varying[], character varying[], integer) OWNER TO db00060892;

--
-- Name: treatmailpackage(integer, integer); Type: FUNCTION; Schema: comsml01; Owner: db00060892
--

CREATE FUNCTION treatmailpackage(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
_tid ALIAS FOR $1;
_status ALIAS FOR $2;
_mlid INTEGER;
_prid INTEGER;
_contid INTEGER;
_func VARCHAR;
_n INTEGER;
BEGIN
  SELECT mail, producer, context FROM mltask WHERE tid=_tid INTO _mlid, _prid, _contid;
  SELECT func FROM mlproducer WHERE prid=_prid INTO _func;
  EXECUTE 'SELECT ' || _func || '(' || _tid::varchar || ',' || _mlid::varchar || ',' || _contid::varchar || ',' || _status::varchar || ')';
  RETURN _contid;
END;
$_$;


ALTER FUNCTION comsml01.treatmailpackage(integer, integer) OWNER TO db00060892;

SET search_path = portalschema, pg_catalog;

--
-- Name: addanyresource(character varying, character varying, text, integer, integer, integer, integer, integer, integer, character varying); Type: FUNCTION; Schema: portalschema; Owner: db00060892
--

CREATE FUNCTION addanyresource(character varying, character varying, text, integer, integer, integer, integer, integer, integer, character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
_url ALIAS FOR $1;
_title ALIAS FOR $2;
_description ALIAS FOR $3;
_state ALIAS FOR $4;
_iseventint ALIAS FOR $5;
_beginyear ALIAS FOR $6;
_beginmonth ALIAS FOR $7;
_beginday ALIAS FOR $8;
_duration ALIAS FOR $9;
_place ALIAS FOR $10;
rez INTEGER;
_isevent BOOLEAN;
BEGIN
  _isevent = false;
  IF _iseventint = 1 THEN
    _isevent = true;
  END IF;
  INSERT INTO portalschema.resource (url, title, description, state, isevent, beginyear, beginmonth, beginday, duration, place)
    VALUES (_url, _title, _description, _state, _isevent, _beginyear, _beginmonth, _beginday, _duration, _place);
  SELECT last_value FROM portalschema.resource_resid_seq INTO rez;
  RETURN rez;
END;
$_$;


ALTER FUNCTION portalschema.addanyresource(character varying, character varying, text, integer, integer, integer, integer, integer, integer, character varying) OWNER TO db00060892;

--
-- Name: addcategory(integer, text, text); Type: FUNCTION; Schema: portalschema; Owner: db00060892
--

CREATE FUNCTION addcategory(integer, text, text) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
_lft0 ALIAS FOR $1;
_name ALIAS FOR $2;
_title ALIAS FOR $3;
_lft INTEGER;
_rgt INTEGER;
rez INTEGER;
r RECORD;
-- rez RECORD;
BEGIN
  _lft := _lft0 + 1; _rgt := _lft + 1;
  FOR r IN SELECT rgt FROM portalschema.category WHERE rgt>=_lft ORDER BY rgt DESC LOOP
    UPDATE portalschema.category SET rgt=rgt+2 WHERE rgt=r.rgt;
  END LOOP;
  FOR r IN SELECT lft FROM portalschema.category WHERE lft>=_lft ORDER BY lft DESC LOOP
    UPDATE portalschema.category SET lft=lft+2 WHERE lft=r.lft;
  END LOOP;
  INSERT INTO portalschema.category (lft, rgt, name, title) VALUES ( _lft, _rgt,  _name, _title);
  SELECT last_value FROM portalschema.category_catid_seq INTO rez;
  RETURN rez;
END;
$_$;


ALTER FUNCTION portalschema.addcategory(integer, text, text) OWNER TO db00060892;

--
-- Name: addcatres(integer, integer, integer); Type: FUNCTION; Schema: portalschema; Owner: db00060892
--

CREATE FUNCTION addcatres(integer, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
_lft ALIAS FOR $1;
_resid ALIAS FOR $2;
_state ALIAS FOR $3;
BEGIN
  INSERT INTO portalschema.catres (pos, resource, state) VALUES (_lft, _resid, _state);
  RETURN 0;
END;
$_$;


ALTER FUNCTION portalschema.addcatres(integer, integer, integer) OWNER TO db00060892;

--
-- Name: addresource(character varying, character varying, text, integer); Type: FUNCTION; Schema: portalschema; Owner: db00060892
--

CREATE FUNCTION addresource(character varying, character varying, text, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
_url ALIAS FOR $1;
_title ALIAS FOR $2;
_description ALIAS FOR $3;
_state ALIAS FOR $4;
rez INTEGER;
BEGIN
  INSERT INTO portalschema.resource (url, title, description, state) 
    VALUES (_url, _title, _description, _state);
  SELECT last_value FROM portalschema.resource_resid_seq INTO rez;
  RETURN rez;
END;
$_$;


ALTER FUNCTION portalschema.addresource(character varying, character varying, text, integer) OWNER TO db00060892;

--
-- Name: addtopres(integer, integer, integer); Type: FUNCTION; Schema: portalschema; Owner: db00060892
--

CREATE FUNCTION addtopres(integer, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
_topid ALIAS FOR $1;
_resid ALIAS FOR $2;
_state ALIAS FOR $3;
BEGIN
  INSERT INTO portalschema.topres (topic, resource, state) VALUES (_topid, _resid, _state);
  RETURN 0;
END;
$_$;


ALTER FUNCTION portalschema.addtopres(integer, integer, integer) OWNER TO db00060892;

--
-- Name: categories2levels(); Type: FUNCTION; Schema: portalschema; Owner: db00060892
--

CREATE FUNCTION categories2levels() RETURNS SETOF cat2list
    LANGUAGE sql
    AS $$

  SELECT c1.catid, c1.title, c2.catid AS catid2, c2.title AS title2
  FROM 
    (SELECT * FROM portalschema.category WHERE portalschema.levelnumber(lft)=0) AS c1
    LEFT JOIN
    (SELECT * FROM portalschema.category WHERE portalschema.levelnumber(lft)=1) AS c2
    ON c2.lft>c1.lft AND c2.rgt<c1.rgt
  ORDER BY c1.title;

$$;


ALTER FUNCTION portalschema.categories2levels() OWNER TO db00060892;

--
-- Name: countallchildrenbytopic(integer, integer); Type: FUNCTION; Schema: portalschema; Owner: db00060892
--

CREATE FUNCTION countallchildrenbytopic(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
_lft0 ALIAS FOR $1;
_rgt0 ALIAS FOR $2;
_lft INTEGER;
_rgt INTEGER;
rec RECORD;
rez INTEGER;
cnt INTEGER;
BEGIN
  _lft := _lft0; _rgt := _rgt0;
  IF _lft <= 0 OR _rgt <= 0 THEN
    _lft := 0; _rgt := 1000000;
  END IF;
  rez := 0;
  FOR rec IN SELECT * FROM portalschema.topic ORDER BY title LOOP
    cnt := portalschema.countsubresources(_lft, _rgt, rec.topid);
    rez := rez + cnt;
  END LOOP;

  SELECT COUNT(*) FROM 
    (SELECT * FROM portalschema.resource WHERE state=1 ORDER BY (-beginyear), (-beginmonth), (-beginday), title ) AS res
  WHERE res.resid IN
    (SELECT resource FROM portalschema.catres WHERE state=1 AND pos BETWEEN _lft AND _rgt)
    AND NOT EXISTS
    (SELECT resource FROM portalschema.topres WHERE state=1 AND resource=res.resid)
  INTO cnt;
  rez := rez + cnt;


  RETURN rez;
END;
$_$;


ALTER FUNCTION portalschema.countallchildrenbytopic(integer, integer) OWNER TO db00060892;

--
-- Name: countsubresources(integer, integer, bigint); Type: FUNCTION; Schema: portalschema; Owner: db00060892
--

CREATE FUNCTION countsubresources(integer, integer, bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
_lft0 ALIAS FOR $1;
_rgt0 ALIAS FOR $2;
_topic ALIAS FOR $3;
_lft INTEGER;
_rgt INTEGER;
rez INTEGER;
BEGIN
  _lft := _lft0; _rgt := _rgt0;
  IF _lft <= 0 OR _rgt <= 0 THEN
    _lft := 0; _rgt := 1000000;
  END IF;

  IF _topic > 0 THEN
    SELECT COUNT(*)
    FROM
      (SELECT DISTINCT cr.resource AS resource
       FROM 
         portalschema.catres AS cr INNER JOIN portalschema.topres AS tr ON cr.resource=tr.resource AND tr.topic=_topic
       WHERE cr.pos BETWEEN _lft AND _rgt AND cr.state=1 AND tr.state=1
      ) AS cr1
    INTO rez;
  ELSE
    SELECT COUNT(*)
    FROM
      (SELECT DISTINCT resource AS resource
       FROM 
         portalschema.catres
       WHERE pos BETWEEN _lft AND _rgt AND state=1
      ) AS cr
    INTO rez;
  END IF;
  RETURN rez;
END;
$_$;


ALTER FUNCTION portalschema.countsubresources(integer, integer, bigint) OWNER TO db00060892;

--
-- Name: delcategory(integer); Type: FUNCTION; Schema: portalschema; Owner: db00060892
--

CREATE FUNCTION delcategory(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
_lft ALIAS FOR $1;
_rgt INTEGER;
r RECORD;
BEGIN
  SELECT rgt FROM portalschema.category WHERE lft=_lft INTO _rgt;
  DELETE FROM portalschema.category WHERE lft=_lft;
  FOR r IN SELECT lft FROM portalschema.category WHERE lft>=_lft ORDER BY lft ASC LOOP
    UPDATE portalschema.category SET lft=lft-1 WHERE lft=r.lft;
  END LOOP;
  FOR r IN SELECT lft FROM portalschema.category WHERE lft>=_rgt ORDER BY lft ASC LOOP
    UPDATE portalschema.category SET lft=lft-1 WHERE lft=r.lft;
  END LOOP;
  FOR r IN SELECT rgt FROM portalschema.category WHERE rgt>=_lft ORDER BY rgt ASC LOOP
    UPDATE portalschema.category SET rgt=rgt-1 WHERE rgt=r.rgt;
  END LOOP;
  FOR r IN SELECT rgt FROM portalschema.category WHERE rgt>=_rgt ORDER BY rgt ASC LOOP
    UPDATE portalschema.category SET rgt=rgt-1 WHERE rgt=r.rgt;
  END LOOP;
  RETURN 0;
END;
$_$;


ALTER FUNCTION portalschema.delcategory(integer) OWNER TO db00060892;

--
-- Name: delresourcecatres(integer); Type: FUNCTION; Schema: portalschema; Owner: db00060892
--

CREATE FUNCTION delresourcecatres(integer) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$
DECLARE
_resid ALIAS FOR $1;
BEGIN
  DELETE FROM portalschema.catres WHERE resource=_resid;
  RETURN 0;
END;
$_$;


ALTER FUNCTION portalschema.delresourcecatres(integer) OWNER TO db00060892;

--
-- Name: delresourcetopres(integer); Type: FUNCTION; Schema: portalschema; Owner: db00060892
--

CREATE FUNCTION delresourcetopres(integer) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$
DECLARE
_resid ALIAS FOR $1;
BEGIN
  DELETE FROM portalschema.topres WHERE resource=_resid;
  RETURN 0;
END;
$_$;


ALTER FUNCTION portalschema.delresourcetopres(integer) OWNER TO db00060892;

--
-- Name: getcategoryresources(refcursor, integer, integer, integer, integer, integer); Type: FUNCTION; Schema: portalschema; Owner: db00060892
--

CREATE FUNCTION getcategoryresources(refcursor, integer, integer, integer, integer, integer) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$
DECLARE
rez ALIAS FOR $1;
_lft0 ALIAS FOR $2;
_rgt0 ALIAS FOR $3;
_topic ALIAS FOR $4;
_limit ALIAS FOR $5;
_offset ALIAS FOR $6;
_lft INTEGER;
_rgt INTEGER;
BEGIN
  _lft := _lft0; _rgt := _rgt0;
  IF _lft <= 0 OR _rgt <= 0 THEN
    _lft := 0; _rgt := 1000000;
  END IF;

  IF _topic > 0 THEN
    OPEN rez FOR
      SELECT *,
        portalschema.makediapazon (beginyear, beginmonth, beginday, duration) AS diapazon
      FROM 
        (SELECT * FROM portalschema.resource WHERE state=1 ORDER BY (-beginyear), (-beginmonth), (-beginday), title) AS res 
      WHERE 
        resid IN
          (SELECT cr.resource FROM portalschema.catres AS cr INNER JOIN portalschema.topres AS tr ON cr.resource=tr.resource WHERE cr.state=1 AND tr.state=1 AND cr.pos BETWEEN _lft AND _rgt AND topic=_topic)
      LIMIT _limit OFFSET _offset;
  ELSE
    OPEN rez FOR
      SELECT *,
        portalschema.makediapazon (beginyear, beginmonth, beginday, duration) AS diapazon
      FROM 
        (SELECT * FROM portalschema.resource WHERE state=1 ORDER BY (-beginyear), (-beginmonth), (-beginday), title) AS res 
      WHERE
        resid IN
          (SELECT resource FROM portalschema.catres WHERE state=1 AND pos BETWEEN _lft AND _rgt)
      LIMIT _limit OFFSET _offset;
  END IF;
  RETURN rez;
END;
$_$;


ALTER FUNCTION portalschema.getcategoryresources(refcursor, integer, integer, integer, integer, integer) OWNER TO db00060892;

--
-- Name: getcategoryresourcesbytopic(integer, integer, integer, integer); Type: FUNCTION; Schema: portalschema; Owner: db00060892
--

CREATE FUNCTION getcategoryresourcesbytopic(integer, integer, integer, integer) RETURNS SETOF catrestoplist
    LANGUAGE plpgsql
    AS $_$
DECLARE
_lft0 ALIAS FOR $1;
_rgt0 ALIAS FOR $2;
_limit ALIAS FOR $3;
_offset ALIAS FOR $4;
_lft INTEGER;
_rgt INTEGER;
_offset2 INTEGER;
_cnt INTEGER;
rec RECORD;
rec2 RECORD;
rez portalschema.catrestoplist%ROWTYPE;
BEGIN
  _lft := _lft0; _rgt := _rgt0;
  IF _lft <= 0 OR _rgt <= 0 THEN
    _lft := 0; _rgt := 1000000;
  END IF;
  _offset2 := _offset + _limit;
  _cnt := 1;

  FOR rec IN SELECT * FROM portalschema.topic ORDER BY title LOOP
    FOR rec2 IN 
      SELECT res.* FROM 
        (SELECT * FROM portalschema.resource WHERE state=1 ORDER BY (-beginyear), (-beginmonth), (-beginday), title ) AS res
      WHERE resid IN
        (SELECT cr.resource FROM portalschema.catres AS cr INNER JOIN portalschema.topres AS tr ON cr.resource=tr.resource WHERE cr.state=1 AND tr.state=1 AND cr.pos BETWEEN _lft AND _rgt AND topic=rec.topid)
      LOOP
      IF _cnt>_offset THEN
        IF _cnt>_offset2 THEN
          RETURN;
        END IF;
        rez.cnt := _cnt;
        rez.topid := rec.topid;
        rez.toptit := rec.title;
        rez.resid := rec2.resid;
        rez.url := rec2.url;
        rez.title := rec2.title;
        rez.description := rec2.description;
        rez.isevent := rec2.isevent;
        rez.diapazon := portalschema.makediapazon (rec2.beginyear, rec2.beginmonth, rec2.beginday, rec2.duration);
        rez.place := rec2.place;
        RETURN NEXT rez;
      END IF;
      _cnt := _cnt+1;
    END LOOP;
  END LOOP;
    FOR rec2 IN 
      SELECT res.* FROM 
        (SELECT * FROM portalschema.resource WHERE state=1 ORDER BY (-beginyear), (-beginmonth), (-beginday), title ) AS res
      WHERE res.resid IN
        (SELECT resource FROM portalschema.catres WHERE state=1 AND pos BETWEEN _lft AND _rgt)
        AND NOT EXISTS
        (SELECT resource FROM portalschema.topres WHERE state=1 AND resource=res.resid)
      LOOP
      IF _cnt>_offset THEN
        IF _cnt>_offset2 THEN
          RETURN;
        END IF;
        rez.cnt := _cnt;
        rez.topid := NULL;
        rez.toptit := NULL;
        rez.resid := rec2.resid;
        rez.url := rec2.url;
        rez.title := rec2.title;
        rez.description := rec2.description;
        rez.isevent := rec2.isevent;
        rez.diapazon := portalschema.makediapazon (rec2.beginyear, rec2.beginmonth, rec2.beginday, rec2.duration);
        rez.place := rec2.place;
        RETURN NEXT rez;
      END IF;
      _cnt := _cnt+1;
    END LOOP;
  RETURN;
END;
$_$;


ALTER FUNCTION portalschema.getcategoryresourcesbytopic(integer, integer, integer, integer) OWNER TO db00060892;

--
-- Name: getcategorytopics(refcursor, integer, integer, integer); Type: FUNCTION; Schema: portalschema; Owner: db00060892
--

CREATE FUNCTION getcategorytopics(refcursor, integer, integer, integer) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$
DECLARE
rez ALIAS FOR $1;
_lft ALIAS FOR $2;
_rgt ALIAS FOR $3;
_topic ALIAS FOR $4;
BEGIN

--  OPEN rez FOR
--  SELECT * FROM portalschema.topic ORDER BY title;

  IF _lft > 0 AND _rgt>0 THEN
    OPEN rez FOR
    SELECT t.*, portalschema.countsubresources(_lft, _rgt, t.topid) AS cnt
    FROM portalschema.topic AS t
    ORDER BY title;
  ELSE
    OPEN rez FOR
    SELECT t.*, portalschema.countsubresources(0, 0, t.topid) AS cnt
    FROM portalschema.topic AS t
    ORDER BY title;
  END IF;


  RETURN rez;
END;
$_$;


ALTER FUNCTION portalschema.getcategorytopics(refcursor, integer, integer, integer) OWNER TO db00060892;

--
-- Name: getcategorytopics2(refcursor, integer, integer, integer); Type: FUNCTION; Schema: portalschema; Owner: db00060892
--

CREATE FUNCTION getcategorytopics2(refcursor, integer, integer, integer) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$
DECLARE
rez ALIAS FOR $1;
_lft ALIAS FOR $2;
_rgt ALIAS FOR $3;
_topic ALIAS FOR $4;
BEGIN

--  OPEN rez FOR
--  SELECT * FROM portalschema.topic ORDER BY title;

  IF _lft > 0 AND _rgt>0 THEN
    OPEN rez FOR
    SELECT t.*, portalschema.countsubresources(_lft, _rgt, t.topid) AS cnt
    FROM portalschema.topic AS t
--    ORDER BY title;
    ORDER BY name;
  ELSE
    OPEN rez FOR
    SELECT t.*, portalschema.countsubresources(0, 0, t.topid) AS cnt
    FROM portalschema.topic AS t
--    ORDER BY title;
    ORDER BY name;
  END IF;


  RETURN rez;
END;
$_$;


ALTER FUNCTION portalschema.getcategorytopics2(refcursor, integer, integer, integer) OWNER TO db00060892;

--
-- Name: getcatlistwithparents(refcursor); Type: FUNCTION; Schema: portalschema; Owner: db00060892
--

CREATE FUNCTION getcatlistwithparents(refcursor) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$
DECLARE
rez ALIAS FOR $1;
-- _lft ALIAS FOR $2;
BEGIN
  OPEN rez FOR
    SELECT catid, name, title, lft, rgt, portalschema.getdirectparent(lft) AS parentleft
    FROM portalschema.category
    ORDER BY title;
  RETURN rez;
END;
$_$;


ALTER FUNCTION portalschema.getcatlistwithparents(refcursor) OWNER TO db00060892;

--
-- Name: getcatlistwithparentsandresid(refcursor, integer); Type: FUNCTION; Schema: portalschema; Owner: db00060892
--

CREATE FUNCTION getcatlistwithparentsandresid(refcursor, integer) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$
DECLARE
rez ALIAS FOR $1;
_resid ALIAS FOR $2;
BEGIN
  OPEN rez FOR
    SELECT * FROM
      (SELECT catid, name, title, lft, rgt, portalschema.getdirectparent(lft) AS parentleft
      FROM portalschema.category
--      ORDER BY title
      ) AS lst
      LEFT JOIN portalschema.catres
      ON lst.lft=pos AND resource=_resid
      ORDER BY title
;
  RETURN rez;
END;
$_$;


ALTER FUNCTION portalschema.getcatlistwithparentsandresid(refcursor, integer) OWNER TO db00060892;

--
-- Name: getchildcategories(refcursor, integer, integer, integer); Type: FUNCTION; Schema: portalschema; Owner: db00060892
--

CREATE FUNCTION getchildcategories(refcursor, integer, integer, integer) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$
DECLARE
rez ALIAS FOR $1;
_lft ALIAS FOR $2;
_rgt ALIAS FOR $3;
_topic ALIAS FOR $4;
BEGIN
  IF _lft > 0 AND _rgt>0 THEN

    OPEN rez FOR
    SELECT c1.catid, c1.title, portalschema.countsubresources(c1.lft, c1.rgt, _topic) AS cnt
    FROM portalschema.category AS c1
    WHERE c1.lft>_lft AND c1.rgt<_rgt AND
      NOT EXISTS (
        SELECT * FROM portalschema.category AS c2
        WHERE c2.lft>_lft AND c2.rgt<_rgt AND c1.lft BETWEEN c2.lft AND c2.rgt AND c1.catid!=c2.catid
      )
    ORDER BY c1.title;

  ELSE

    OPEN rez FOR
    SELECT c1.catid, c1.title, portalschema.countsubresources(c1.lft, c1.rgt, _topic) AS cnt
    FROM portalschema.category AS c1
    WHERE
      NOT EXISTS (
        SELECT * FROM portalschema.category AS c2
        WHERE c1.lft BETWEEN c2.lft AND c2.rgt AND c1.catid!=c2.catid
      )
    ORDER BY c1.title;

  END IF;
  RETURN rez;
END;
$_$;


ALTER FUNCTION portalschema.getchildcategories(refcursor, integer, integer, integer) OWNER TO db00060892;

--
-- Name: getchildcategoriessimple(refcursor, integer, integer); Type: FUNCTION; Schema: portalschema; Owner: db00060892
--

CREATE FUNCTION getchildcategoriessimple(refcursor, integer, integer) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$
DECLARE
rez ALIAS FOR $1;
_catid ALIAS FOR $2;
_lft ALIAS FOR $2;
_rgt ALIAS FOR $3;
-- _lft INTEGER;
-- _rgt INTEGER;
BEGIN
--  _lft := 0; _rgt := 0;
--  IF _catid > 0 THEN
--    SELECT lft, rgt FROM portalschema.category WHERE catid = _catid INTO _lft, _rgt;
--  END IF;

  IF _lft > 0 AND _rgt>0 THEN
    OPEN rez FOR
    SELECT c1.catid, c1.lft, c1.rgt, c1.name, c1.title
    FROM portalschema.category AS c1
    WHERE c1.lft>_lft AND c1.rgt<_rgt AND
      NOT EXISTS (
        SELECT * FROM portalschema.category AS c2
        WHERE c2.lft>_lft AND c2.rgt<_rgt AND c1.lft BETWEEN c2.lft AND c2.rgt AND c1.catid!=c2.catid
      )
    ORDER BY c1.title;
  ELSE
    OPEN rez FOR
    SELECT c1.catid, c1.lft, c1.rgt, c1.name, c1.title
    FROM portalschema.category AS c1
    WHERE
      NOT EXISTS (
        SELECT * FROM portalschema.category AS c2
        WHERE c1.lft BETWEEN c2.lft AND c2.rgt AND c1.catid!=c2.catid
      )
    ORDER BY c1.title;
  END IF;
  RETURN rez;
END;
$_$;


ALTER FUNCTION portalschema.getchildcategoriessimple(refcursor, integer, integer) OWNER TO db00060892;

--
-- Name: getdirectparent(integer); Type: FUNCTION; Schema: portalschema; Owner: db00060892
--

CREATE FUNCTION getdirectparent(integer) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$
DECLARE
_lft ALIAS FOR $1;
rez INTEGER;
s INTEGER;
BEGIN
--  rez := 0;
  SELECT lft, (rgt-lft) AS size
    FROM portalschema.category
    WHERE _lft > lft AND _lft < rgt
    ORDER BY size ASC
    LIMIT 1
  INTO rez, s;
  IF rez IS NULL THEN
    rez := 0;
  END IF;

  RETURN rez;
END;
$_$;


ALTER FUNCTION portalschema.getdirectparent(integer) OWNER TO db00060892;

--
-- Name: getnewevents(refcursor, integer); Type: FUNCTION; Schema: portalschema; Owner: db00060892
--

CREATE FUNCTION getnewevents(refcursor, integer) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$
DECLARE
rez ALIAS FOR $1;
_limit ALIAS FOR $2;
BEGIN
  OPEN rez FOR
--    SELECT DISTINCT res.*,
    SELECT *,
      portalschema.makediapazon (beginyear, beginmonth, beginday, duration) AS diapazon,
      to_char(addtime, 'Month DD, YYYY') AS date
    FROM 
    (SELECT * FROM
      portalschema.resource
      WHERE isevent AND state=1
      ORDER BY addtime DESC, beginyear DESC, beginmonth DESC, beginday DESC
      LIMIT _limit
    ) AS qqq;
  RETURN rez;
END;
$_$;


ALTER FUNCTION portalschema.getnewevents(refcursor, integer) OWNER TO db00060892;

--
-- Name: getnewresources(refcursor, integer); Type: FUNCTION; Schema: portalschema; Owner: db00060892
--

CREATE FUNCTION getnewresources(refcursor, integer) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$
DECLARE
rez ALIAS FOR $1;
_limit ALIAS FOR $2;
BEGIN
  OPEN rez FOR
    SELECT *,
      portalschema.makediapazon (beginyear, beginmonth, beginday, duration) AS diapazon,
      to_char(addtime, 'Month DD, YYYY') AS date
    FROM 
    (SELECT * FROM
      portalschema.resource
      WHERE NOT isevent AND state=1
      ORDER BY addtime DESC
--   , title ASC
      LIMIT _limit
    ) AS qqq;
  RETURN rez;
END;
$_$;


ALTER FUNCTION portalschema.getnewresources(refcursor, integer) OWNER TO db00060892;

--
-- Name: getparents(refcursor, integer); Type: FUNCTION; Schema: portalschema; Owner: db00060892
--

CREATE FUNCTION getparents(refcursor, integer) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$
DECLARE
rez ALIAS FOR $1;
_lft ALIAS FOR $2;
BEGIN
  OPEN rez FOR
    SELECT catid, name, title, lft, rgt, (rgt-lft) AS size
    FROM portalschema.category
    WHERE _lft BETWEEN lft AND rgt
    ORDER BY size DESC;
  RETURN rez;
END;
$_$;


ALTER FUNCTION portalschema.getparents(refcursor, integer) OWNER TO db00060892;

--
-- Name: getrgtbylft(integer); Type: FUNCTION; Schema: portalschema; Owner: db00060892
--

CREATE FUNCTION getrgtbylft(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
_lft ALIAS FOR $1;
_rgt INTEGER;
BEGIN
  SELECT rgt FROM portalschema.category WHERE lft=_lft INTO _rgt;
  IF _rgt IS NULL THEN
    _rgt := 0;
  END IF;
  RETURN _rgt;
END;
$_$;


ALTER FUNCTION portalschema.getrgtbylft(integer) OWNER TO db00060892;

--
-- Name: gettopiclist(refcursor); Type: FUNCTION; Schema: portalschema; Owner: db00060892
--

CREATE FUNCTION gettopiclist(refcursor) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$
DECLARE
rez ALIAS FOR $1;
BEGIN
  OPEN rez FOR
    SELECT *
    FROM portalschema.topic
    ORDER BY title;
  RETURN rez;
END;
$_$;


ALTER FUNCTION portalschema.gettopiclist(refcursor) OWNER TO db00060892;

--
-- Name: gettopiclist2(refcursor); Type: FUNCTION; Schema: portalschema; Owner: db00060892
--

CREATE FUNCTION gettopiclist2(refcursor) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$
DECLARE
rez ALIAS FOR $1;
BEGIN
  OPEN rez FOR
    SELECT *
    FROM portalschema.topic
--    ORDER BY title;
    ORDER BY name;
  RETURN rez;
END;
$_$;


ALTER FUNCTION portalschema.gettopiclist2(refcursor) OWNER TO db00060892;

--
-- Name: gettopiclistandresid(refcursor, integer); Type: FUNCTION; Schema: portalschema; Owner: db00060892
--

CREATE FUNCTION gettopiclistandresid(refcursor, integer) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$
DECLARE
rez ALIAS FOR $1;
_resid ALIAS FOR $2;
BEGIN
  OPEN rez FOR
    SELECT * FROM
      (SELECT * FROM portalschema.topic) AS lst
      LEFT JOIN portalschema.topres
      ON lst.topid=topic AND resource=_resid
    ORDER BY title;
  RETURN rez;
END;
$_$;


ALTER FUNCTION portalschema.gettopiclistandresid(refcursor, integer) OWNER TO db00060892;

--
-- Name: levelnumber(integer); Type: FUNCTION; Schema: portalschema; Owner: db00060892
--

CREATE FUNCTION levelnumber(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
_lft ALIAS FOR $1;
rez INTEGER;
BEGIN
    SELECT COUNT(*)
    FROM portalschema.category
    WHERE _lft>lft AND _lft<rgt
    INTO rez;
  RETURN rez;
END;
$_$;


ALTER FUNCTION portalschema.levelnumber(integer) OWNER TO db00060892;

--
-- Name: makediapazon(integer, integer, integer, integer); Type: FUNCTION; Schema: portalschema; Owner: db00060892
--

CREATE FUNCTION makediapazon(integer, integer, integer, integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
_year ALIAS FOR $1;
_month ALIAS FOR $2;
_day ALIAS FOR $3;
_duration ALIAS FOR $4;
_ts timestamp;
-- _d date;
_i interval;
rez TEXT;
BEGIN
  rez := '';
  IF _year > 0 THEN
    IF _month > 0 THEN
      IF _day > 0 THEN
        _ts := to_timestamp(_day || ' ' || _month || ' ' || _year, 'DD MM YYYY');
        rez := to_char(_ts, 'YYYY Month DD');
        IF _duration > 0 THEN
          _i := (_duration - 1)*60*60*24;
          rez := rez || to_char(_ts + _i, ' - Month DD');
        END IF;
      ELSE
        _ts := to_timestamp('01 ' || _month || ' ' || _year, 'DD MM YYYY');
        rez := to_char(_ts, 'YYYY Month');
      END IF;
    ELSE
      _ts := to_timestamp('01 01 ' || _year, 'DD MM YYYY');
      rez := to_char(_ts, 'YYYY');
    END IF;
  END IF;
  RETURN rez;
END;
$_$;


ALTER FUNCTION portalschema.makediapazon(integer, integer, integer, integer) OWNER TO db00060892;

--
-- Name: saveanyresource(bigint, character varying, character varying, text, integer, integer, integer, integer, integer, integer, character varying); Type: FUNCTION; Schema: portalschema; Owner: db00060892
--

CREATE FUNCTION saveanyresource(bigint, character varying, character varying, text, integer, integer, integer, integer, integer, integer, character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
_resid ALIAS FOR $1;
_url ALIAS FOR $2;
_title ALIAS FOR $3;
_description ALIAS FOR $4;
_state ALIAS FOR $5;
_iseventint ALIAS FOR $6;
_beginyear ALIAS FOR $7;
_beginmonth ALIAS FOR $8;
_beginday ALIAS FOR $9;
_duration ALIAS FOR $10;
_place ALIAS FOR $11;
rez INTEGER;
_isevent BOOLEAN;
BEGIN
  _isevent = false;
  IF _iseventint = 1 THEN
    _isevent = true;
  END IF;
  UPDATE portalschema.resource 
  SET url=_url, title=_title, description=_description, state=_state, isevent=_isevent, 
      beginyear=_beginyear, beginmonth=_beginmonth, beginday=_beginday, duration=_duration, place=_place
  WHERE resid=_resid;
  RETURN 0;
END;
$_$;


ALTER FUNCTION portalschema.saveanyresource(bigint, character varying, character varying, text, integer, integer, integer, integer, integer, integer, character varying) OWNER TO db00060892;

--
-- Name: test(integer); Type: FUNCTION; Schema: portalschema; Owner: db00060892
--

CREATE FUNCTION test(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
_n ALIAS FOR $1;
_i INTEGER;
rez INTEGER;
BEGIN
 rez :=0;
  FOR _i IN 1.._n LOOP
SELECT portalschema.addanyresource( 'http://conf.new1.physcon.ru/2003','International Conference  "PhysCon 2003"','', 1, 1, 2003, 08, 20, 3, 'Saint-Petersburg, Russia') INTO rez;
INSERT INTO portalschema.catres (pos, resource, state) VALUES (26, rez, 1);
INSERT INTO portalschema.topres (topic, resource, state) VALUES (5, rez, 1);

SELECT portalschema.addresource( 'http://www.rusycon.ru','Russian Systems and Control Archive (RUSYCON)','', 1) INTO rez;
INSERT INTO portalschema.catres (pos, resource, state) VALUES (8, rez, 1);
INSERT INTO portalschema.catres (pos, resource, state) VALUES (13, rez, 1);
INSERT INTO portalschema.catres (pos, resource, state) VALUES (19, rez, 1);
INSERT INTO portalschema.topres (topic, resource, state) VALUES (3, rez, 1);

SELECT portalschema.addresource( 'http://physicsweb.org','PhysicsWeb, The web site for physicists','', 1) INTO rez;
INSERT INTO portalschema.catres (pos, resource, state) VALUES (13, rez, 1);
INSERT INTO portalschema.topres (topic, resource, state) VALUES (5, rez, 1);

SELECT portalschema.addresource( 'http://www.physics.umd.edu/robot/','Robot:Physics News. Physics News from Y.S.Kim, University of Maryland','', 1) INTO rez;
INSERT INTO portalschema.catres (pos, resource, state) VALUES (13, rez, 1);
INSERT INTO portalschema.topres (topic, resource, state) VALUES (3, rez, 1);
INSERT INTO portalschema.topres (topic, resource, state) VALUES (4, rez, 1);
INSERT INTO portalschema.topres (topic, resource, state) VALUES (5, rez, 1);

SELECT portalschema.addanyresource( 'http://conf.new1.physcon.ru/2005','International Conference  "PhysCon 2005"','', 1, 1, 2005, 0, 0, 0, 'Saint-Petersburg, Russia') INTO rez;
INSERT INTO portalschema.catres (pos, resource, state) VALUES (30, rez, 1);

SELECT portalschema.addresource( 'http://www.cup.uni-muenchen.de/pc/devivie/','Theoretical Femtoscience Group','', 1) INTO rez;
INSERT INTO portalschema.catres (pos, resource, state) VALUES (10, rez, 1);
INSERT INTO portalschema.catres (pos, resource, state) VALUES (13, rez, 1);
INSERT INTO portalschema.topres (topic, resource, state) VALUES (5, rez, 1);
INSERT INTO portalschema.topres (topic, resource, state) VALUES (7, rez, 1);
INSERT INTO portalschema.topres (topic, resource, state) VALUES (8, rez, 1);

SELECT portalschema.addresource( 'http://www.phys.soton.ac.uk/quantum/links.htm','Quantum Control links from University of Southampton','', 1) INTO rez;
INSERT INTO portalschema.catres (pos, resource, state) VALUES (13, rez, 1);
INSERT INTO portalschema.catres (pos, resource, state) VALUES (15, rez, 1);
INSERT INTO portalschema.catres (pos, resource, state) VALUES (19, rez, 1);
INSERT INTO portalschema.topres (topic, resource, state) VALUES (7, rez, 1);

 SELECT portalschema.addresource( 'http://www.princeton.edu/~hrabitz/','Hershcel A. Rabitz Homepage','', 0) INTO rez;
 INSERT INTO portalschema.catres (pos, resource, state) VALUES (19, rez, 0);
 INSERT INTO portalschema.topres (topic, resource, state) VALUES (2, rez, 0);
 INSERT INTO portalschema.topres (topic, resource, state) VALUES (5, rez, 0);
 INSERT INTO portalschema.topres (topic, resource, state) VALUES (6, rez, 0);


  END LOOP;
  RETURN rez;
END;
$_$;


ALTER FUNCTION portalschema.test(integer) OWNER TO db00060892;

SET search_path = public, pg_catalog;

--
-- Name: plpgsql_call_handler(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION plpgsql_call_handler() RETURNS language_handler
    LANGUAGE c
    AS '$libdir/plpgsql', 'plpgsql_call_handler';


ALTER FUNCTION public.plpgsql_call_handler() OWNER TO postgres;

SET search_path = statschema, pg_catalog;

--
-- Name: bigint2int(bigint); Type: FUNCTION; Schema: statschema; Owner: db00060892
--

CREATE FUNCTION bigint2int(bigint) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
_n ALIAS FOR $1;
_result int;
_max bigint;

BEGIN
  _max := 2*1024*1024*1024::bigint;
  IF _n >= _max THEN
    _result := (_n - _max) - _max;
  ELSE
    _result := _n;
  END IF;
  return _result;
END;
$_$;


ALTER FUNCTION statschema.bigint2int(bigint) OWNER TO db00060892;

--
-- Name: int2bigint(integer); Type: FUNCTION; Schema: statschema; Owner: db00060892
--

CREATE FUNCTION int2bigint(integer) RETURNS bigint
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
_n ALIAS FOR $1;
_result bigint;
_max bigint;

BEGIN
  _max := 2*1024*1024*1024::bigint;
  IF _n < 0 THEN
    _result := (_n + _max) + _max;
  ELSE
    _result := _n;
  END IF;
  return _result;
END;
$_$;


ALTER FUNCTION statschema.int2bigint(integer) OWNER TO db00060892;

--
-- Name: registerclicktobuffer(integer, integer, character varying, character varying, character varying); Type: FUNCTION; Schema: statschema; Owner: db00060892
--

CREATE FUNCTION registerclicktobuffer(integer, integer, character varying, character varying, character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
_cnt ALIAS FOR $1;
_host ALIAS FOR $2;
_pagestr ALIAS FOR $3;
_refererstr ALIAS FOR $4;
_agentstr ALIAS FOR $5;
_result boolean;
_num int;

BEGIN
  SELECT cntid FROM counter WHERE cntid=_cnt INTO _num;
  IF _num IS NOT NULL THEN
    INSERT INTO click0 (cnt, host, pagestr, refererstr, agentstr)
      VALUES (_cnt, _host, trim(_pagestr), trim(_refererstr), trim(_agentstr));
    return TRUE;
  END IF;
  return FALSE;
END;
$_$;


ALTER FUNCTION statschema.registerclicktobuffer(integer, integer, character varying, character varying, character varying) OWNER TO db00060892;

--
-- Name: treatregisteredclicks(); Type: FUNCTION; Schema: statschema; Owner: db00060892
--

CREATE FUNCTION treatregisteredclicks() RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
_clickelm RECORD;
_agelm RECORD;

_clkid int;
_cnt int;
_host int;
_rawagent int;
_agentversion int;
_addrpage int;
_refererpage int;
_addrdomain int;
_refererdomain int;
_clickdate date;
_clickstamp timestamp;
_agentstr varchar;
_addrpagestr varchar;
_refererpagestr varchar;
_ccode varchar;
_ccode0 varchar;

_n int;
_asize int;
_agentarr varchar[0];
_agentidarr int[0];
_browser int;
_bversion varchar;
_s varchar;
_s2 varchar;

BEGIN
  _agentarr = '{}'::varchar[];
  _agentidarr = '{}'::int[];

  _n := 0;
  FOR _agelm IN SELECT * FROM agent ORDER BY ordnum LOOP 
    _n := _n + 1;
    _agentarr[_n] := _agelm.rule;
    _agentidarr[_n] := _agelm.agentid;
  END LOOP;

  FOR _clickelm IN SELECT * FROM click0 ORDER BY clkid LOOP 
    _clkid := _clickelm.clkid;
    _cnt := _clickelm.cnt;
    _clickdate := _clickelm.clickdate;
    _clickstamp := _clickelm.clickstamp;
    _agentstr := _clickelm.agentstr;
    _addrpagestr := _clickelm.pagestr;
    _refererpagestr := _clickelm.refererstr;

    _host := NULL;
    SELECT hostip FROM host WHERE hostip=_clickelm.host INTO _host;
    IF _host IS NULL THEN
      _host := _clickelm.host;
      _ccode := NULL;
      SELECT INTO _ccode country FROM ip2country WHERE int2bigint(_host) BETWEEN int2bigint(ip_from) AND int2bigint(ip_to);
      INSERT INTO host (hostip, country) VALUES (_host, _ccode);
    ELSE
      SELECT INTO _ccode0 country FROM host WHERE hostip=_host;
      IF _ccode0 IS NULL THEN
        SELECT INTO _ccode country FROM ip2country WHERE int2bigint(_host) BETWEEN int2bigint(ip_from) AND int2bigint(ip_to);
        UPDATE host SET country=_ccode WHERE hostip=_host;
      END IF;
    END IF;

    _rawagent := NULL;
--    SELECT INTO _rawagent * FROM rawagent WHERE value=_agentstr;
    SELECT INTO _rawagent rawagentid FROM rawagent WHERE value=_agentstr;
    IF _rawagent IS NULL THEN
      INSERT INTO rawagent (value) VALUES (_agentstr);
      SELECT INTO _rawagent last_value FROM rawagent_rawagentid_seq;
    END IF;

    _asize := array_upper(_agentarr, 1);

    FOR _n IN 1 .. _asize LOOP
      _s := substring(_agentstr from _agentarr[_n]);
      IF _s IS NOT NULL THEN
        _browser := (_agentidarr[_n]);
        _bversion := _s;
        EXIT;
      END IF;
    END LOOP;

    IF _browser IS NOT NULL THEN
      _agentversion := NULL;
      SELECT INTO _agentversion verid FROM agentversion WHERE agent=_browser AND version=_bversion;
      IF _agentversion IS NULL THEN
        INSERT INTO agentversion (agent, version) VALUES (_browser, _bversion);
        SELECT INTO _agentversion last_value FROM agentversion_verid_seq;
      END IF;
    END IF;


    -- Page address

    _addrdomain := NULL;
    _addrpage := NULL;
    IF _addrpagestr IS NOT NULL THEN
      _n := strpos(_addrpagestr, 'http://');
      IF _n = 1 THEN
        _s := substr(_addrpagestr, length('http://')+1 );
        _n := strpos(_s, '/');
        IF _n > 0 THEN
          _s2 := substr(_s, _n);
          _s := substr(_s, 1, _n-1);
        ELSE
          _s2 := '';
        END IF;

--        _addrdomain := NULL;
        SELECT INTO _addrdomain domainid FROM domain WHERE name=_s;
        IF _addrdomain IS NULL THEN
          INSERT INTO domain (name) VALUES (_s);
          SELECT INTO _addrdomain last_value FROM domain_domainid_seq;
        END IF;

--        _addrpage := NULL;
        SELECT INTO _addrpage pageid FROM page WHERE name=_s2 AND domain=_addrdomain;
        IF _addrpage IS NULL THEN
          INSERT INTO page (name, domain) VALUES (_s2, _addrdomain);
          SELECT INTO _addrpage last_value FROM page_pageid_seq;
        END IF;
      END IF;
    END IF;


    -- Referer

    _refererdomain := NULL;
    _refererpage := NULL;
    IF _refererpagestr IS NOT NULL THEN
      _n := strpos(_refererpagestr, 'http://');
      IF _n = 1 THEN
        _s := substr(_refererpagestr, length('http://')+1 );
        _n := strpos(_s, '/');
        IF _n > 0 THEN
          _s2 := substr(_s, _n);
          _s := substr(_s, 1, _n-1);
        ELSE
          _s2 := '';
        END IF;

--        _refererdomain := NULL;
        SELECT INTO _refererdomain domainid FROM domain WHERE name=_s;
        IF _refererdomain IS NULL THEN
          INSERT INTO domain (name) VALUES (_s);
          SELECT INTO _refererdomain last_value FROM domain_domainid_seq;
        END IF;

--        _refererpage := NULL;
        SELECT INTO _refererpage pageid FROM page WHERE name=_s2 AND domain=_refererdomain;
        IF _refererpage IS NULL THEN
          INSERT INTO page (name, domain) VALUES (_s2, _refererdomain);
          SELECT INTO _refererpage last_value FROM page_pageid_seq;
        END IF;
      END IF;
    END IF;


    SELECT INTO _n COUNT(*) FROM click WHERE clkid=_clkid;
    IF _n = 0 THEN
      INSERT INTO click (clkid, cnt, host, rawagent, agentversion, addrpage, refererpage, clickdate, clickstamp)
        VALUES (_clkid, _cnt, _host, _rawagent, _agentversion, _addrpage, _refererpage, _clickdate, _clickstamp);
    END IF;

    DELETE FROM click0 WHERE clkid=_clkid;
  END LOOP;

  return FALSE;
END;
$$;


ALTER FUNCTION statschema.treatregisteredclicks() OWNER TO db00060892;

SET search_path = subscriptionschema, pg_catalog;

--
-- Name: addsubscriber(character varying, integer); Type: FUNCTION; Schema: subscriptionschema; Owner: db00060892
--

CREATE FUNCTION addsubscriber(character varying, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
_addr ALIAS FOR $1;
_code ALIAS FOR $2;
rez INTEGER;
BEGIN
  INSERT INTO subscriber (ssaddr, addtime, code) VALUES (_addr, NOW(), _code);
  SELECT last_value FROM subscriber_ssid_seq INTO rez;
  RETURN rez;
END;
$_$;


ALTER FUNCTION subscriptionschema.addsubscriber(character varying, integer) OWNER TO db00060892;

--
-- Name: createrandomcode(); Type: FUNCTION; Schema: subscriptionschema; Owner: db00060892
--

CREATE FUNCTION createrandomcode() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
  rez INTEGER;
BEGIN
  rez := round( 899999 * random() ) + 100000;
  RETURN rez;
END;
$$;


ALTER FUNCTION subscriptionschema.createrandomcode() OWNER TO db00060892;

--
-- Name: deletenotconfirmed(); Type: FUNCTION; Schema: subscriptionschema; Owner: db00060892
--

CREATE FUNCTION deletenotconfirmed() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
rez INTEGER;
BEGIN
  rez := 0;
--  DELETE FROM subscriber WHERE addtime < (NOW() - interval '86400');
  DELETE FROM subscriber WHERE addtime < (NOW() - interval '86400') AND enabled=false;
  RETURN rez;
END;

$$;


ALTER FUNCTION subscriptionschema.deletenotconfirmed() OWNER TO db00060892;

SET search_path = userschema, pg_catalog;

--
-- Name: addusershort(integer, character varying, character varying, character varying); Type: FUNCTION; Schema: userschema; Owner: db00060892
--

CREATE FUNCTION addusershort(integer, character varying, character varying, character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
_title ALIAS FOR $1;
_fname ALIAS FOR $2;
_lname ALIAS FOR $3;
_email ALIAS FOR $4;
rez INTEGER;
BEGIN
  INSERT INTO userpin (pass, title, fname, lname, email)
    VALUES (create6digitsrandom(), _title, _fname, _lname, _email);
  SELECT last_value FROM userpin_pin_seq INTO rez;
  RETURN rez;
END;
$_$;


ALTER FUNCTION userschema.addusershort(integer, character varying, character varying, character varying) OWNER TO db00060892;

--
-- Name: adduserwithpassword(character varying, integer, character varying, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: userschema; Owner: db00060892
--

CREATE FUNCTION adduserwithpassword(character varying, integer, character varying, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
_pass ALIAS FOR $1;
_title ALIAS FOR $2;
_gender ALIAS FOR $3;
_fname ALIAS FOR $4;
_lname ALIAS FOR $5;
_affiliation ALIAS FOR $6;
_country ALIAS FOR $7;
_city ALIAS FOR $8;
_address ALIAS FOR $9;
_phone ALIAS FOR $10;
_fax ALIAS FOR $11;
_email ALIAS FOR $12;
_country1 INTEGER;
rez INTEGER;
BEGIN
 _country1 := NULL;
  IF _country>0 THEN
    _country1 := _country;
  END IF;
  INSERT INTO userpin (pass, title, gender, fname, lname, affiliation, country, city, address, phone, fax, email)
    VALUES (_pass, _title, _gender, _fname, _lname, _affiliation, _country1, _city, _address, _phone, _fax, _email);
  SELECT last_value FROM userpin_pin_seq INTO rez;
  RETURN rez;
END;
$_$;


ALTER FUNCTION userschema.adduserwithpassword(character varying, integer, character varying, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying) OWNER TO db00060892;

--
-- Name: checkseanskey(integer); Type: FUNCTION; Schema: userschema; Owner: db00060892
--

CREATE FUNCTION checkseanskey(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
_key ALIAS FOR $1;
rez INTEGER;
rez0 INTEGER;
BEGIN
  rez := 0;
  rez0 := deleteoldseanskeys();
  SELECT pin FROM userkey WHERE key=_key INTO rez;
  UPDATE userkey SET updtime=NOW() WHERE key=_key;
  RETURN rez;
END;
$_$;


ALTER FUNCTION userschema.checkseanskey(integer) OWNER TO db00060892;

--
-- Name: create6digitsrandom(); Type: FUNCTION; Schema: userschema; Owner: db00060892
--

CREATE FUNCTION create6digitsrandom() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
  rez INTEGER;
BEGIN
  rez := round( 899999 * random() ) + 100000;
  RETURN rez;
END;
$$;


ALTER FUNCTION userschema.create6digitsrandom() OWNER TO db00060892;

--
-- Name: createseanskey(integer); Type: FUNCTION; Schema: userschema; Owner: db00060892
--

CREATE FUNCTION createseanskey(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
_pin ALIAS FOR $1;
rez INTEGER;
BEGIN
  rez := round( 899999999 * random() ) + 100000000;
  WHILE rez IN (SELECT key FROM userkey) LOOP
    rez := round( 899999999 * random() ) + 100000000;
  END LOOP;
  INSERT INTO userkey (key, pin) VALUES (rez, _pin);

  RETURN rez;
END;
$_$;


ALTER FUNCTION userschema.createseanskey(integer) OWNER TO db00060892;

--
-- Name: deleteoldseanskeys(); Type: FUNCTION; Schema: userschema; Owner: db00060892
--

CREATE FUNCTION deleteoldseanskeys() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
rez INTEGER;
BEGIN
  rez := 0;
--  DELETE FROM userkey WHERE updtime < (NOW() - interval '600');
  DELETE FROM userkey WHERE updtime < (NOW() - interval '3600');
  RETURN rez;
END;
$$;


ALTER FUNCTION userschema.deleteoldseanskeys() OWNER TO db00060892;

--
-- Name: getuserbypinpassword(character varying, character varying); Type: FUNCTION; Schema: userschema; Owner: db00060892
--

CREATE FUNCTION getuserbypinpassword(_pin character varying, _pass character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
  rez INTEGER;
BEGIN
  rez := 0;
  SELECT pin FROM userpin WHERE pin=_pin::int AND pass=_pass AND enabled=true INTO rez;
  RETURN rez;
END;
$$;


ALTER FUNCTION userschema.getuserbypinpassword(_pin character varying, _pass character varying) OWNER TO db00060892;

--
-- Name: saveuserinfo(integer, character varying, integer, character varying, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: userschema; Owner: db00060892
--

CREATE FUNCTION saveuserinfo(integer, character varying, integer, character varying, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
_pin ALIAS FOR $1;
_pass ALIAS FOR $2;
_title ALIAS FOR $3;
_gender ALIAS FOR $4;
_fname ALIAS FOR $5;
_lname ALIAS FOR $6;
_affiliation ALIAS FOR $7;
_country ALIAS FOR $8;
_city ALIAS FOR $9;
_address ALIAS FOR $10;
_phone ALIAS FOR $11;
_fax ALIAS FOR $12;
_email ALIAS FOR $13;
_country1 INTEGER;
rez INTEGER;
BEGIN
 _country1 := NULL;
  IF _country>0 THEN
    _country1 := _country;
  END IF;

  UPDATE userpin SET pass=_pass, title=_title, gender=_gender, fname=_fname, lname=_lname, affiliation=_affiliation, country=_country1, city=_city, address=_address, phone=_phone, fax=_fax, email=_email, updtime=NOW()
  WHERE pin=_pin;

--  INSERT INTO userpin (pass, title, gender, fname, lname, affiliation, country, city, address, phone, fax, email)
--    VALUES (_pass, _title, _gender, _fname, _lname, _affiliation, _country1, _city, _address, _phone, _fax, _email);
--  SELECT last_value FROM userpin_pin_seq INTO rez;

  rez := 0;
  RETURN rez;
END;
$_$;


ALTER FUNCTION userschema.saveuserinfo(integer, character varying, integer, character varying, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying) OWNER TO db00060892;

SET search_path = cmsconfschema, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = true;

--
-- Name: author; Type: TABLE; Schema: cmsconfschema; Owner: db00060892
--

CREATE TABLE author (
    context integer NOT NULL,
    papnum integer NOT NULL,
    autpin integer NOT NULL
);


ALTER TABLE author OWNER TO db00060892;

--
-- Name: cont_kw; Type: TABLE; Schema: cmsconfschema; Owner: db00060892
--

CREATE TABLE cont_kw (
    context integer NOT NULL,
    keyword integer NOT NULL
);


ALTER TABLE cont_kw OWNER TO db00060892;

--
-- Name: context; Type: TABLE; Schema: cmsconfschema; Owner: db00060892
--

CREATE TABLE context (
    contid integer NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    homepage character varying(255),
    status integer DEFAULT 0 NOT NULL
);


ALTER TABLE context OWNER TO db00060892;

--
-- Name: context_contid_seq; Type: SEQUENCE; Schema: cmsconfschema; Owner: db00060892
--

CREATE SEQUENCE context_contid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE context_contid_seq OWNER TO db00060892;

--
-- Name: context_contid_seq; Type: SEQUENCE OWNED BY; Schema: cmsconfschema; Owner: db00060892
--

ALTER SEQUENCE context_contid_seq OWNED BY context.contid;


--
-- Name: editor; Type: TABLE; Schema: cmsconfschema; Owner: db00060892
--

CREATE TABLE editor (
    context integer NOT NULL,
    userpin integer NOT NULL
);


ALTER TABLE editor OWNER TO db00060892;

--
-- Name: keyword; Type: TABLE; Schema: cmsconfschema; Owner: db00060892
--

CREATE TABLE keyword (
    kwid integer NOT NULL,
    name character varying(40) NOT NULL
);


ALTER TABLE keyword OWNER TO db00060892;

--
-- Name: keyword_kwid_seq; Type: SEQUENCE; Schema: cmsconfschema; Owner: db00060892
--

CREATE SEQUENCE keyword_kwid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE keyword_kwid_seq OWNER TO db00060892;

--
-- Name: keyword_kwid_seq; Type: SEQUENCE OWNED BY; Schema: cmsconfschema; Owner: db00060892
--

ALTER SEQUENCE keyword_kwid_seq OWNED BY keyword.kwid;


--
-- Name: pap_kw; Type: TABLE; Schema: cmsconfschema; Owner: db00060892
--

CREATE TABLE pap_kw (
    context integer NOT NULL,
    papnum integer NOT NULL,
    keyword integer NOT NULL,
    weight integer
);


ALTER TABLE pap_kw OWNER TO db00060892;

--
-- Name: paper; Type: TABLE; Schema: cmsconfschema; Owner: db00060892
--

CREATE TABLE paper (
    context integer NOT NULL,
    papnum integer NOT NULL,
    registrator integer,
    editor integer,
    title character varying(250) NOT NULL,
    abstract text,
    filetype character varying(250),
    filename character varying(250)
);


ALTER TABLE paper OWNER TO db00060892;

--
-- Name: review; Type: TABLE; Schema: cmsconfschema; Owner: db00060892
--

CREATE TABLE review (
    context integer NOT NULL,
    papnum integer NOT NULL,
    revnum integer NOT NULL,
    revpin integer
);


ALTER TABLE review OWNER TO db00060892;

--
-- Name: user_kw; Type: TABLE; Schema: cmsconfschema; Owner: db00060892
--

CREATE TABLE user_kw (
    userpin integer NOT NULL,
    keyword integer NOT NULL,
    weight integer DEFAULT 0 NOT NULL
);


ALTER TABLE user_kw OWNER TO db00060892;

SET search_path = cmsmlschema, pg_catalog;

--
-- Name: maildata; Type: TABLE; Schema: cmsmlschema; Owner: db00060892
--

CREATE TABLE maildata (
    mlid integer NOT NULL,
    mltitle character varying(250),
    mlsubject character varying(250),
    mlfrom character varying(250),
    mlbody text,
    mldate timestamp without time zone NOT NULL,
    mlstatus integer,
    mlrcvrflags integer,
    mlrcvrpin integer,
    mlrcvraddr character varying(250)
);


ALTER TABLE maildata OWNER TO db00060892;

--
-- Name: maildata_mlid_seq; Type: SEQUENCE; Schema: cmsmlschema; Owner: db00060892
--

CREATE SEQUENCE maildata_mlid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maildata_mlid_seq OWNER TO db00060892;

--
-- Name: maildata_mlid_seq; Type: SEQUENCE OWNED BY; Schema: cmsmlschema; Owner: db00060892
--

ALTER SEQUENCE maildata_mlid_seq OWNED BY maildata.mlid;


--
-- Name: mailtask; Type: TABLE; Schema: cmsmlschema; Owner: db00060892
--

CREATE TABLE mailtask (
    taskid integer NOT NULL,
    mlid integer,
    taskstatus integer,
    taskerror integer,
    tasktrycnt integer,
    tasktype integer,
    taskpin integer,
    taskemail character varying(250)
);


ALTER TABLE mailtask OWNER TO db00060892;

--
-- Name: mailtask_taskid_seq; Type: SEQUENCE; Schema: cmsmlschema; Owner: db00060892
--

CREATE SEQUENCE mailtask_taskid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mailtask_taskid_seq OWNER TO db00060892;

--
-- Name: mailtask_taskid_seq; Type: SEQUENCE OWNED BY; Schema: cmsmlschema; Owner: db00060892
--

ALTER SEQUENCE mailtask_taskid_seq OWNED BY mailtask.taskid;


SET search_path = coms01, pg_catalog;

--
-- Name: author; Type: TABLE; Schema: coms01; Owner: db00060892
--

CREATE TABLE author (
    context integer NOT NULL,
    papnum integer NOT NULL,
    autpin integer NOT NULL
);


ALTER TABLE author OWNER TO db00060892;

--
-- Name: cont_kw; Type: TABLE; Schema: coms01; Owner: db00060892
--

CREATE TABLE cont_kw (
    context integer NOT NULL,
    keyword integer NOT NULL
);


ALTER TABLE cont_kw OWNER TO db00060892;

--
-- Name: cont_perm; Type: TABLE; Schema: coms01; Owner: db00060892
--

CREATE TABLE cont_perm (
    context integer NOT NULL,
    permission integer NOT NULL,
    value boolean DEFAULT false NOT NULL
);


ALTER TABLE cont_perm OWNER TO db00060892;

--
-- Name: context; Type: TABLE; Schema: coms01; Owner: db00060892
--

CREATE TABLE context (
    contid integer NOT NULL,
    title character varying NOT NULL,
    description text,
    homepage character varying,
    status integer DEFAULT 0 NOT NULL,
    manager integer,
    shorttitle character varying,
    email character varying,
    cont_type integer
);


ALTER TABLE context OWNER TO db00060892;

--
-- Name: context_contid_seq; Type: SEQUENCE; Schema: coms01; Owner: db00060892
--

CREATE SEQUENCE context_contid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE context_contid_seq OWNER TO db00060892;

--
-- Name: context_contid_seq; Type: SEQUENCE OWNED BY; Schema: coms01; Owner: db00060892
--

ALTER SEQUENCE context_contid_seq OWNED BY context.contid;


--
-- Name: contseq; Type: TABLE; Schema: coms01; Owner: db00060892
--

CREATE TABLE contseq (
    context integer NOT NULL,
    topic integer NOT NULL,
    lastvalue integer NOT NULL
);


ALTER TABLE contseq OWNER TO db00060892;

--
-- Name: editor; Type: TABLE; Schema: coms01; Owner: db00060892
--

CREATE TABLE editor (
    editorid integer NOT NULL,
    context integer NOT NULL,
    userpin integer NOT NULL
);


ALTER TABLE editor OWNER TO db00060892;

--
-- Name: editor_editorid_seq; Type: SEQUENCE; Schema: coms01; Owner: db00060892
--

CREATE SEQUENCE editor_editorid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE editor_editorid_seq OWNER TO db00060892;

--
-- Name: editor_editorid_seq; Type: SEQUENCE OWNED BY; Schema: coms01; Owner: db00060892
--

ALTER SEQUENCE editor_editorid_seq OWNED BY editor.editorid;


--
-- Name: keyword; Type: TABLE; Schema: coms01; Owner: db00060892
--

CREATE TABLE keyword (
    kwid integer NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE keyword OWNER TO db00060892;

--
-- Name: keyword_kwid_seq; Type: SEQUENCE; Schema: coms01; Owner: db00060892
--

CREATE SEQUENCE keyword_kwid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE keyword_kwid_seq OWNER TO db00060892;

--
-- Name: keyword_kwid_seq; Type: SEQUENCE OWNED BY; Schema: coms01; Owner: db00060892
--

ALTER SEQUENCE keyword_kwid_seq OWNED BY keyword.kwid;


--
-- Name: pap_kw; Type: TABLE; Schema: coms01; Owner: db00060892
--

CREATE TABLE pap_kw (
    context integer NOT NULL,
    papnum integer NOT NULL,
    keyword integer NOT NULL,
    weight integer
);


ALTER TABLE pap_kw OWNER TO db00060892;

--
-- Name: paper; Type: TABLE; Schema: coms01; Owner: db00060892
--

CREATE TABLE paper (
    context integer NOT NULL,
    papnum integer NOT NULL,
    registrator integer,
    editor integer,
    title character varying NOT NULL,
    abstract text,
    subject integer,
    presenttype integer,
    filetype character varying,
    filename character varying,
    ed_score integer,
    ed_subject integer,
    ed_ipccomments text,
    ed_authcomments text,
    ed_recommendation integer,
    finaldecision integer,
    finalsubject integer,
    authors character varying
);


ALTER TABLE paper OWNER TO db00060892;

--
-- Name: permission; Type: TABLE; Schema: coms01; Owner: db00060892
--

CREATE TABLE permission (
    permid integer NOT NULL,
    name character varying NOT NULL,
    description text
);


ALTER TABLE permission OWNER TO db00060892;

--
-- Name: permission_permid_seq; Type: SEQUENCE; Schema: coms01; Owner: db00060892
--

CREATE SEQUENCE permission_permid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE permission_permid_seq OWNER TO db00060892;

--
-- Name: permission_permid_seq; Type: SEQUENCE OWNED BY; Schema: coms01; Owner: db00060892
--

ALTER SEQUENCE permission_permid_seq OWNED BY permission.permid;


--
-- Name: review; Type: TABLE; Schema: coms01; Owner: db00060892
--

CREATE TABLE review (
    context integer NOT NULL,
    papnum integer NOT NULL,
    revpin integer NOT NULL,
    score integer,
    subject integer,
    ipccomments text,
    authcomments text,
    recommendation integer,
    isready boolean DEFAULT false NOT NULL,
    agreed boolean DEFAULT false NOT NULL
);


ALTER TABLE review OWNER TO db00060892;

--
-- Name: score; Type: TABLE; Schema: coms01; Owner: db00060892
--

CREATE TABLE score (
    scoreid integer NOT NULL,
    name character varying
);


ALTER TABLE score OWNER TO db00060892;

--
-- Name: score_scoreid_seq; Type: SEQUENCE; Schema: coms01; Owner: db00060892
--

CREATE SEQUENCE score_scoreid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE score_scoreid_seq OWNER TO db00060892;

--
-- Name: score_scoreid_seq; Type: SEQUENCE OWNED BY; Schema: coms01; Owner: db00060892
--

ALTER SEQUENCE score_scoreid_seq OWNED BY score.scoreid;


--
-- Name: subject; Type: TABLE; Schema: coms01; Owner: db00060892
--

CREATE TABLE subject (
    subjid integer NOT NULL,
    context integer NOT NULL,
    isinvited boolean DEFAULT false NOT NULL,
    manager integer,
    editor integer,
    title character varying NOT NULL,
    abstract text,
    ed_score integer,
    ed_ipccomments text,
    ed_authcomments text,
    ed_recommendation integer,
    finaldecision integer
);


ALTER TABLE subject OWNER TO db00060892;

--
-- Name: subject_subjid_seq; Type: SEQUENCE; Schema: coms01; Owner: db00060892
--

CREATE SEQUENCE subject_subjid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subject_subjid_seq OWNER TO db00060892;

--
-- Name: subject_subjid_seq; Type: SEQUENCE OWNED BY; Schema: coms01; Owner: db00060892
--

ALTER SEQUENCE subject_subjid_seq OWNED BY subject.subjid;


--
-- Name: subjectreview; Type: TABLE; Schema: coms01; Owner: db00060892
--

CREATE TABLE subjectreview (
    context integer NOT NULL,
    subjid integer NOT NULL,
    revpin integer NOT NULL,
    score integer,
    ipccomments text,
    authcomments text,
    recommendation integer,
    isready boolean DEFAULT false NOT NULL,
    agreed boolean DEFAULT false NOT NULL
);


ALTER TABLE subjectreview OWNER TO db00060892;

--
-- Name: user_kw; Type: TABLE; Schema: coms01; Owner: db00060892
--

CREATE TABLE user_kw (
    userpin integer NOT NULL,
    keyword integer NOT NULL,
    weight integer DEFAULT 0 NOT NULL
);


ALTER TABLE user_kw OWNER TO db00060892;

SET search_path = comsml01, pg_catalog;

--
-- Name: mlcont_synctask; Type: TABLE; Schema: comsml01; Owner: db00060892
--

CREATE TABLE mlcont_synctask (
    context integer NOT NULL,
    task integer NOT NULL,
    mail integer NOT NULL
);


ALTER TABLE mlcont_synctask OWNER TO db00060892;

--
-- Name: mldata; Type: TABLE; Schema: comsml01; Owner: db00060892
--

CREATE TABLE mldata (
    mlid integer NOT NULL,
    context integer NOT NULL,
    title character varying,
    subject character varying,
    ffrom character varying,
    tto character varying,
    body text,
    updtime timestamp without time zone NOT NULL
);


ALTER TABLE mldata OWNER TO db00060892;

--
-- Name: mldata_mlid_seq; Type: SEQUENCE; Schema: comsml01; Owner: db00060892
--

CREATE SEQUENCE mldata_mlid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mldata_mlid_seq OWNER TO db00060892;

--
-- Name: mldata_mlid_seq; Type: SEQUENCE OWNED BY; Schema: comsml01; Owner: db00060892
--

ALTER SEQUENCE mldata_mlid_seq OWNED BY mldata.mlid;


--
-- Name: mlproducer; Type: TABLE; Schema: comsml01; Owner: db00060892
--

CREATE TABLE mlproducer (
    prid integer NOT NULL,
    title character varying,
    description text,
    func character varying
);


ALTER TABLE mlproducer OWNER TO db00060892;

--
-- Name: mlproducer_prid_seq; Type: SEQUENCE; Schema: comsml01; Owner: db00060892
--

CREATE SEQUENCE mlproducer_prid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mlproducer_prid_seq OWNER TO db00060892;

--
-- Name: mlproducer_prid_seq; Type: SEQUENCE OWNED BY; Schema: comsml01; Owner: db00060892
--

ALTER SEQUENCE mlproducer_prid_seq OWNED BY mlproducer.prid;


--
-- Name: mlqueue; Type: TABLE; Schema: comsml01; Owner: db00060892
--

CREATE TABLE mlqueue (
    qid integer NOT NULL,
    task integer NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    error integer,
    trycnt integer,
    argname character varying[],
    argvalue character varying[],
    email character varying
);


ALTER TABLE mlqueue OWNER TO db00060892;

--
-- Name: mlqueue_qid_seq; Type: SEQUENCE; Schema: comsml01; Owner: db00060892
--

CREATE SEQUENCE mlqueue_qid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mlqueue_qid_seq OWNER TO db00060892;

--
-- Name: mlqueue_qid_seq; Type: SEQUENCE OWNED BY; Schema: comsml01; Owner: db00060892
--

ALTER SEQUENCE mlqueue_qid_seq OWNED BY mlqueue.qid;


--
-- Name: mlsynctask; Type: TABLE; Schema: comsml01; Owner: db00060892
--

CREATE TABLE mlsynctask (
    stid integer NOT NULL,
    title character varying,
    description text
);


ALTER TABLE mlsynctask OWNER TO db00060892;

--
-- Name: mlsynctask_stid_seq; Type: SEQUENCE; Schema: comsml01; Owner: db00060892
--

CREATE SEQUENCE mlsynctask_stid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mlsynctask_stid_seq OWNER TO db00060892;

--
-- Name: mlsynctask_stid_seq; Type: SEQUENCE OWNED BY; Schema: comsml01; Owner: db00060892
--

ALTER SEQUENCE mlsynctask_stid_seq OWNED BY mlsynctask.stid;


--
-- Name: mltask; Type: TABLE; Schema: comsml01; Owner: db00060892
--

CREATE TABLE mltask (
    tid integer NOT NULL,
    context integer NOT NULL,
    title character varying,
    mail integer NOT NULL,
    producer integer NOT NULL,
    updtime timestamp without time zone NOT NULL
);


ALTER TABLE mltask OWNER TO db00060892;

--
-- Name: mltask_tid_seq; Type: SEQUENCE; Schema: comsml01; Owner: db00060892
--

CREATE SEQUENCE mltask_tid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mltask_tid_seq OWNER TO db00060892;

--
-- Name: mltask_tid_seq; Type: SEQUENCE OWNED BY; Schema: comsml01; Owner: db00060892
--

ALTER SEQUENCE mltask_tid_seq OWNED BY mltask.tid;


--
-- Name: mltempl; Type: TABLE; Schema: comsml01; Owner: db00060892
--

CREATE TABLE mltempl (
    mtid integer NOT NULL,
    title character varying,
    subject character varying,
    ffrom character varying,
    tto character varying,
    body text
);


ALTER TABLE mltempl OWNER TO db00060892;

--
-- Name: mltempl_mtid_seq; Type: SEQUENCE; Schema: comsml01; Owner: db00060892
--

CREATE SEQUENCE mltempl_mtid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mltempl_mtid_seq OWNER TO db00060892;

--
-- Name: mltempl_mtid_seq; Type: SEQUENCE OWNED BY; Schema: comsml01; Owner: db00060892
--

ALTER SEQUENCE mltempl_mtid_seq OWNED BY mltempl.mtid;


SET search_path = lib01, pg_catalog;

SET default_with_oids = false;

--
-- Name: lib_tree_item; Type: TABLE; Schema: lib01; Owner: db00060892
--

CREATE TABLE lib_tree_item (
    item_id integer NOT NULL,
    addtime timestamp without time zone DEFAULT now() NOT NULL,
    parent integer,
    ordnum integer,
    title character varying,
    subtitle character varying,
    authors character varying,
    abstract character varying,
    acc_level integer DEFAULT 0 NOT NULL,
    item_type integer DEFAULT 0 NOT NULL,
    original_ext character varying DEFAULT ''::character varying NOT NULL,
    filepath character varying,
    mimetype character varying
);


ALTER TABLE lib_tree_item OWNER TO db00060892;

--
-- Name: lib_tree_item_item_id_seq; Type: SEQUENCE; Schema: lib01; Owner: db00060892
--

CREATE SEQUENCE lib_tree_item_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE lib_tree_item_item_id_seq OWNER TO db00060892;

--
-- Name: lib_tree_item_item_id_seq; Type: SEQUENCE OWNED BY; Schema: lib01; Owner: db00060892
--

ALTER SEQUENCE lib_tree_item_item_id_seq OWNED BY lib_tree_item.item_id;


SET search_path = membership01, pg_catalog;

--
-- Name: ipacs_member; Type: TABLE; Schema: membership01; Owner: db00060892
--

CREATE TABLE ipacs_member (
    userpin integer NOT NULL,
    addtime timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE ipacs_member OWNER TO db00060892;

SET search_path = newsschema, pg_catalog;

SET default_with_oids = true;

--
-- Name: news; Type: TABLE; Schema: newsschema; Owner: db00060892
--

CREATE TABLE news (
    newsid bigint NOT NULL,
    title character varying(255) DEFAULT ''::character varying NOT NULL,
    content text,
    addtime timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE news OWNER TO db00060892;

--
-- Name: news_newsid_seq; Type: SEQUENCE; Schema: newsschema; Owner: db00060892
--

CREATE SEQUENCE news_newsid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE news_newsid_seq OWNER TO db00060892;

--
-- Name: news_newsid_seq; Type: SEQUENCE OWNED BY; Schema: newsschema; Owner: db00060892
--

ALTER SEQUENCE news_newsid_seq OWNED BY news.newsid;


SET search_path = portalschema, pg_catalog;

--
-- Name: category; Type: TABLE; Schema: portalschema; Owner: db00060892
--

CREATE TABLE category (
    catid bigint NOT NULL,
    lft integer NOT NULL,
    rgt integer NOT NULL,
    name character varying(32) DEFAULT ''::character varying NOT NULL,
    title character varying(255) DEFAULT ''::character varying NOT NULL,
    CONSTRAINT "$1" CHECK ((lft < rgt)),
    CONSTRAINT category_lft CHECK ((lft > 0)),
    CONSTRAINT category_rgt CHECK ((rgt > 0))
);


ALTER TABLE category OWNER TO db00060892;

--
-- Name: category_catid_seq; Type: SEQUENCE; Schema: portalschema; Owner: db00060892
--

CREATE SEQUENCE category_catid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE category_catid_seq OWNER TO db00060892;

--
-- Name: category_catid_seq; Type: SEQUENCE OWNED BY; Schema: portalschema; Owner: db00060892
--

ALTER SEQUENCE category_catid_seq OWNED BY category.catid;


--
-- Name: catres; Type: TABLE; Schema: portalschema; Owner: db00060892
--

CREATE TABLE catres (
    pos integer NOT NULL,
    resource bigint NOT NULL,
    state integer NOT NULL
);


ALTER TABLE catres OWNER TO db00060892;

--
-- Name: resource; Type: TABLE; Schema: portalschema; Owner: db00060892
--

CREATE TABLE resource (
    resid bigint NOT NULL,
    url character varying(255) DEFAULT ''::character varying NOT NULL,
    title character varying(255) DEFAULT ''::character varying NOT NULL,
    description text,
    state integer DEFAULT 0 NOT NULL,
    addtime timestamp without time zone DEFAULT now() NOT NULL,
    isevent boolean DEFAULT false NOT NULL,
    beginyear integer DEFAULT 0 NOT NULL,
    beginmonth integer DEFAULT 0 NOT NULL,
    beginday integer DEFAULT 0 NOT NULL,
    duration integer DEFAULT 0 NOT NULL,
    place character varying(255) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE resource OWNER TO db00060892;

--
-- Name: resource_resid_seq; Type: SEQUENCE; Schema: portalschema; Owner: db00060892
--

CREATE SEQUENCE resource_resid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE resource_resid_seq OWNER TO db00060892;

--
-- Name: resource_resid_seq; Type: SEQUENCE OWNED BY; Schema: portalschema; Owner: db00060892
--

ALTER SEQUENCE resource_resid_seq OWNED BY resource.resid;


--
-- Name: topic; Type: TABLE; Schema: portalschema; Owner: db00060892
--

CREATE TABLE topic (
    topid bigint NOT NULL,
    name character varying(32) DEFAULT ''::character varying NOT NULL,
    title character varying(255) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE topic OWNER TO db00060892;

--
-- Name: topic_topid_seq; Type: SEQUENCE; Schema: portalschema; Owner: db00060892
--

CREATE SEQUENCE topic_topid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE topic_topid_seq OWNER TO db00060892;

--
-- Name: topic_topid_seq; Type: SEQUENCE OWNED BY; Schema: portalschema; Owner: db00060892
--

ALTER SEQUENCE topic_topid_seq OWNED BY topic.topid;


--
-- Name: topres; Type: TABLE; Schema: portalschema; Owner: db00060892
--

CREATE TABLE topres (
    topic bigint NOT NULL,
    resource bigint NOT NULL,
    state integer NOT NULL
);


ALTER TABLE topres OWNER TO db00060892;

SET search_path = statschema, pg_catalog;

--
-- Name: agent; Type: TABLE; Schema: statschema; Owner: db00060892
--

CREATE TABLE agent (
    agentid integer NOT NULL,
    name character varying(50) NOT NULL,
    ordnum integer NOT NULL,
    rule character varying(255) NOT NULL
);


ALTER TABLE agent OWNER TO db00060892;

--
-- Name: agent_agentid_seq; Type: SEQUENCE; Schema: statschema; Owner: db00060892
--

CREATE SEQUENCE agent_agentid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE agent_agentid_seq OWNER TO db00060892;

--
-- Name: agent_agentid_seq; Type: SEQUENCE OWNED BY; Schema: statschema; Owner: db00060892
--

ALTER SEQUENCE agent_agentid_seq OWNED BY agent.agentid;


--
-- Name: agentversion; Type: TABLE; Schema: statschema; Owner: db00060892
--

CREATE TABLE agentversion (
    verid integer NOT NULL,
    agent integer NOT NULL,
    version character varying(50) NOT NULL
);


ALTER TABLE agentversion OWNER TO db00060892;

--
-- Name: agentversion_verid_seq; Type: SEQUENCE; Schema: statschema; Owner: db00060892
--

CREATE SEQUENCE agentversion_verid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE agentversion_verid_seq OWNER TO db00060892;

--
-- Name: agentversion_verid_seq; Type: SEQUENCE OWNED BY; Schema: statschema; Owner: db00060892
--

ALTER SEQUENCE agentversion_verid_seq OWNED BY agentversion.verid;


--
-- Name: click; Type: TABLE; Schema: statschema; Owner: db00060892
--

CREATE TABLE click (
    clkid integer NOT NULL,
    cnt integer NOT NULL,
    host integer NOT NULL,
    rawagent integer,
    agentversion integer,
    addrpage integer,
    refererpage integer,
    clickdate date NOT NULL,
    clickstamp timestamp without time zone NOT NULL
);


ALTER TABLE click OWNER TO db00060892;

--
-- Name: click0; Type: TABLE; Schema: statschema; Owner: db00060892
--

CREATE TABLE click0 (
    clkid integer NOT NULL,
    cnt integer NOT NULL,
    host integer NOT NULL,
    pagestr character varying(255),
    refererstr character varying(255),
    agentstr character varying(255),
    clickdate date DEFAULT now() NOT NULL,
    clickstamp timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE click0 OWNER TO db00060892;

--
-- Name: click0_clkid_seq; Type: SEQUENCE; Schema: statschema; Owner: db00060892
--

CREATE SEQUENCE click0_clkid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE click0_clkid_seq OWNER TO db00060892;

--
-- Name: click0_clkid_seq; Type: SEQUENCE OWNED BY; Schema: statschema; Owner: db00060892
--

ALTER SEQUENCE click0_clkid_seq OWNED BY click0.clkid;


--
-- Name: counter; Type: TABLE; Schema: statschema; Owner: db00060892
--

CREATE TABLE counter (
    cntid integer NOT NULL,
    title character varying(80),
    address character varying(250),
    email character varying(250),
    userupdated timestamp without time zone DEFAULT now()
);


ALTER TABLE counter OWNER TO db00060892;

--
-- Name: counter_cntid_seq; Type: SEQUENCE; Schema: statschema; Owner: db00060892
--

CREATE SEQUENCE counter_cntid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE counter_cntid_seq OWNER TO db00060892;

--
-- Name: counter_cntid_seq; Type: SEQUENCE OWNED BY; Schema: statschema; Owner: db00060892
--

ALTER SEQUENCE counter_cntid_seq OWNED BY counter.cntid;


--
-- Name: country; Type: TABLE; Schema: statschema; Owner: db00060892
--

CREATE TABLE country (
    code character(2) NOT NULL,
    title character varying(255) DEFAULT ''::character varying NOT NULL,
    region character varying(255) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE country OWNER TO db00060892;

--
-- Name: domain; Type: TABLE; Schema: statschema; Owner: db00060892
--

CREATE TABLE domain (
    domainid integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE domain OWNER TO db00060892;

--
-- Name: domain_domainid_seq; Type: SEQUENCE; Schema: statschema; Owner: db00060892
--

CREATE SEQUENCE domain_domainid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE domain_domainid_seq OWNER TO db00060892;

--
-- Name: domain_domainid_seq; Type: SEQUENCE OWNED BY; Schema: statschema; Owner: db00060892
--

ALTER SEQUENCE domain_domainid_seq OWNED BY domain.domainid;


--
-- Name: host; Type: TABLE; Schema: statschema; Owner: db00060892
--

CREATE TABLE host (
    hostip integer NOT NULL,
    country character(2)
);


ALTER TABLE host OWNER TO db00060892;

--
-- Name: ip2country; Type: TABLE; Schema: statschema; Owner: db00060892
--

CREATE TABLE ip2country (
    ip_from integer NOT NULL,
    ip_to integer NOT NULL,
    country character(2) NOT NULL
);


ALTER TABLE ip2country OWNER TO db00060892;

--
-- Name: page; Type: TABLE; Schema: statschema; Owner: db00060892
--

CREATE TABLE page (
    pageid integer NOT NULL,
    name character varying(255) NOT NULL,
    domain integer
);


ALTER TABLE page OWNER TO db00060892;

--
-- Name: page_pageid_seq; Type: SEQUENCE; Schema: statschema; Owner: db00060892
--

CREATE SEQUENCE page_pageid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE page_pageid_seq OWNER TO db00060892;

--
-- Name: page_pageid_seq; Type: SEQUENCE OWNED BY; Schema: statschema; Owner: db00060892
--

ALTER SEQUENCE page_pageid_seq OWNED BY page.pageid;


--
-- Name: rawagent; Type: TABLE; Schema: statschema; Owner: db00060892
--

CREATE TABLE rawagent (
    rawagentid integer NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE rawagent OWNER TO db00060892;

--
-- Name: rawagent_rawagentid_seq; Type: SEQUENCE; Schema: statschema; Owner: db00060892
--

CREATE SEQUENCE rawagent_rawagentid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rawagent_rawagentid_seq OWNER TO db00060892;

--
-- Name: rawagent_rawagentid_seq; Type: SEQUENCE OWNED BY; Schema: statschema; Owner: db00060892
--

ALTER SEQUENCE rawagent_rawagentid_seq OWNED BY rawagent.rawagentid;


SET search_path = subscriptionschema, pg_catalog;

--
-- Name: mail; Type: TABLE; Schema: subscriptionschema; Owner: db00060892
--

CREATE TABLE mail (
    mlid integer NOT NULL,
    mltitle character varying(250),
    mlsubject character varying(250),
    mlfrom character varying(250),
    mlbody text,
    mldate timestamp without time zone NOT NULL,
    mlstatus integer,
    mlrcvrflags integer,
    mlrcvrid integer,
    mlrcvraddr character varying(250)
);


ALTER TABLE mail OWNER TO db00060892;

--
-- Name: mail_mlid_seq; Type: SEQUENCE; Schema: subscriptionschema; Owner: db00060892
--

CREATE SEQUENCE mail_mlid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mail_mlid_seq OWNER TO db00060892;

--
-- Name: mail_mlid_seq; Type: SEQUENCE OWNED BY; Schema: subscriptionschema; Owner: db00060892
--

ALTER SEQUENCE mail_mlid_seq OWNED BY mail.mlid;


--
-- Name: mailtask; Type: TABLE; Schema: subscriptionschema; Owner: db00060892
--

CREATE TABLE mailtask (
    taskid integer NOT NULL,
    mlid integer,
    taskstatus integer,
    taskerror integer,
    tasktrycnt integer,
    tasktype integer,
    taskssid integer,
    taskemail character varying(250)
);


ALTER TABLE mailtask OWNER TO db00060892;

--
-- Name: mailtask_taskid_seq; Type: SEQUENCE; Schema: subscriptionschema; Owner: db00060892
--

CREATE SEQUENCE mailtask_taskid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mailtask_taskid_seq OWNER TO db00060892;

--
-- Name: mailtask_taskid_seq; Type: SEQUENCE OWNED BY; Schema: subscriptionschema; Owner: db00060892
--

ALTER SEQUENCE mailtask_taskid_seq OWNED BY mailtask.taskid;


--
-- Name: subscriber; Type: TABLE; Schema: subscriptionschema; Owner: db00060892
--

CREATE TABLE subscriber (
    ssid integer NOT NULL,
    ssaddr character varying(250),
    addtime timestamp without time zone NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    code integer NOT NULL
);


ALTER TABLE subscriber OWNER TO db00060892;

--
-- Name: subscriber_ssid_seq; Type: SEQUENCE; Schema: subscriptionschema; Owner: db00060892
--

CREATE SEQUENCE subscriber_ssid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subscriber_ssid_seq OWNER TO db00060892;

--
-- Name: subscriber_ssid_seq; Type: SEQUENCE OWNED BY; Schema: subscriptionschema; Owner: db00060892
--

ALTER SEQUENCE subscriber_ssid_seq OWNED BY subscriber.ssid;


SET search_path = userschema, pg_catalog;

--
-- Name: country; Type: TABLE; Schema: userschema; Owner: db00060892
--

CREATE TABLE country (
    cid integer NOT NULL,
    code character(2),
    name character varying(50)
);


ALTER TABLE country OWNER TO db00060892;

--
-- Name: country_cid_seq; Type: SEQUENCE; Schema: userschema; Owner: db00060892
--

CREATE SEQUENCE country_cid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE country_cid_seq OWNER TO db00060892;

--
-- Name: country_cid_seq; Type: SEQUENCE OWNED BY; Schema: userschema; Owner: db00060892
--

ALTER SEQUENCE country_cid_seq OWNED BY country.cid;


--
-- Name: title; Type: TABLE; Schema: userschema; Owner: db00060892
--

CREATE TABLE title (
    titleid integer NOT NULL,
    shortstr character varying(12) DEFAULT ''::character varying,
    fullstr character varying(20) DEFAULT ''::character varying
);


ALTER TABLE title OWNER TO db00060892;

--
-- Name: title_titleid_seq; Type: SEQUENCE; Schema: userschema; Owner: db00060892
--

CREATE SEQUENCE title_titleid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE title_titleid_seq OWNER TO db00060892;

--
-- Name: title_titleid_seq; Type: SEQUENCE OWNED BY; Schema: userschema; Owner: db00060892
--

ALTER SEQUENCE title_titleid_seq OWNED BY title.titleid;


--
-- Name: userkey; Type: TABLE; Schema: userschema; Owner: db00060892
--

CREATE TABLE userkey (
    key integer NOT NULL,
    pin integer,
    updtime timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE userkey OWNER TO db00060892;

--
-- Name: userpin; Type: TABLE; Schema: userschema; Owner: db00060892
--

CREATE TABLE userpin (
    pin integer NOT NULL,
    pass character varying(12) DEFAULT ''::character varying,
    title integer,
    gender gendertype,
    fname character varying(40),
    lname character varying(40),
    affiliation character varying(250),
    country integer,
    city character varying(40),
    address character varying(250),
    phone character varying(25),
    fax character varying(25),
    email character varying(80),
    updtime timestamp without time zone DEFAULT now() NOT NULL,
    enabled boolean DEFAULT true NOT NULL
);


ALTER TABLE userpin OWNER TO db00060892;

--
-- Name: userpin_pin_seq; Type: SEQUENCE; Schema: userschema; Owner: db00060892
--

CREATE SEQUENCE userpin_pin_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE userpin_pin_seq OWNER TO db00060892;

--
-- Name: userpin_pin_seq; Type: SEQUENCE OWNED BY; Schema: userschema; Owner: db00060892
--

ALTER SEQUENCE userpin_pin_seq OWNED BY userpin.pin;


SET search_path = cmsconfschema, pg_catalog;

--
-- Name: contid; Type: DEFAULT; Schema: cmsconfschema; Owner: db00060892
--

ALTER TABLE ONLY context ALTER COLUMN contid SET DEFAULT nextval('context_contid_seq'::regclass);


--
-- Name: kwid; Type: DEFAULT; Schema: cmsconfschema; Owner: db00060892
--

ALTER TABLE ONLY keyword ALTER COLUMN kwid SET DEFAULT nextval('keyword_kwid_seq'::regclass);


SET search_path = cmsmlschema, pg_catalog;

--
-- Name: mlid; Type: DEFAULT; Schema: cmsmlschema; Owner: db00060892
--

ALTER TABLE ONLY maildata ALTER COLUMN mlid SET DEFAULT nextval('maildata_mlid_seq'::regclass);


--
-- Name: taskid; Type: DEFAULT; Schema: cmsmlschema; Owner: db00060892
--

ALTER TABLE ONLY mailtask ALTER COLUMN taskid SET DEFAULT nextval('mailtask_taskid_seq'::regclass);


SET search_path = coms01, pg_catalog;

--
-- Name: contid; Type: DEFAULT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY context ALTER COLUMN contid SET DEFAULT nextval('context_contid_seq'::regclass);


--
-- Name: editorid; Type: DEFAULT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY editor ALTER COLUMN editorid SET DEFAULT nextval('editor_editorid_seq'::regclass);


--
-- Name: kwid; Type: DEFAULT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY keyword ALTER COLUMN kwid SET DEFAULT nextval('keyword_kwid_seq'::regclass);


--
-- Name: permid; Type: DEFAULT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY permission ALTER COLUMN permid SET DEFAULT nextval('permission_permid_seq'::regclass);


--
-- Name: scoreid; Type: DEFAULT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY score ALTER COLUMN scoreid SET DEFAULT nextval('score_scoreid_seq'::regclass);


--
-- Name: subjid; Type: DEFAULT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY subject ALTER COLUMN subjid SET DEFAULT nextval('subject_subjid_seq'::regclass);


SET search_path = comsml01, pg_catalog;

--
-- Name: mlid; Type: DEFAULT; Schema: comsml01; Owner: db00060892
--

ALTER TABLE ONLY mldata ALTER COLUMN mlid SET DEFAULT nextval('mldata_mlid_seq'::regclass);


--
-- Name: prid; Type: DEFAULT; Schema: comsml01; Owner: db00060892
--

ALTER TABLE ONLY mlproducer ALTER COLUMN prid SET DEFAULT nextval('mlproducer_prid_seq'::regclass);


--
-- Name: qid; Type: DEFAULT; Schema: comsml01; Owner: db00060892
--

ALTER TABLE ONLY mlqueue ALTER COLUMN qid SET DEFAULT nextval('mlqueue_qid_seq'::regclass);


--
-- Name: stid; Type: DEFAULT; Schema: comsml01; Owner: db00060892
--

ALTER TABLE ONLY mlsynctask ALTER COLUMN stid SET DEFAULT nextval('mlsynctask_stid_seq'::regclass);


--
-- Name: tid; Type: DEFAULT; Schema: comsml01; Owner: db00060892
--

ALTER TABLE ONLY mltask ALTER COLUMN tid SET DEFAULT nextval('mltask_tid_seq'::regclass);


--
-- Name: mtid; Type: DEFAULT; Schema: comsml01; Owner: db00060892
--

ALTER TABLE ONLY mltempl ALTER COLUMN mtid SET DEFAULT nextval('mltempl_mtid_seq'::regclass);


SET search_path = lib01, pg_catalog;

--
-- Name: item_id; Type: DEFAULT; Schema: lib01; Owner: db00060892
--

ALTER TABLE ONLY lib_tree_item ALTER COLUMN item_id SET DEFAULT nextval('lib_tree_item_item_id_seq'::regclass);


SET search_path = newsschema, pg_catalog;

--
-- Name: newsid; Type: DEFAULT; Schema: newsschema; Owner: db00060892
--

ALTER TABLE ONLY news ALTER COLUMN newsid SET DEFAULT nextval('news_newsid_seq'::regclass);


SET search_path = portalschema, pg_catalog;

--
-- Name: catid; Type: DEFAULT; Schema: portalschema; Owner: db00060892
--

ALTER TABLE ONLY category ALTER COLUMN catid SET DEFAULT nextval('category_catid_seq'::regclass);


--
-- Name: resid; Type: DEFAULT; Schema: portalschema; Owner: db00060892
--

ALTER TABLE ONLY resource ALTER COLUMN resid SET DEFAULT nextval('resource_resid_seq'::regclass);


--
-- Name: topid; Type: DEFAULT; Schema: portalschema; Owner: db00060892
--

ALTER TABLE ONLY topic ALTER COLUMN topid SET DEFAULT nextval('topic_topid_seq'::regclass);


SET search_path = statschema, pg_catalog;

--
-- Name: agentid; Type: DEFAULT; Schema: statschema; Owner: db00060892
--

ALTER TABLE ONLY agent ALTER COLUMN agentid SET DEFAULT nextval('agent_agentid_seq'::regclass);


--
-- Name: verid; Type: DEFAULT; Schema: statschema; Owner: db00060892
--

ALTER TABLE ONLY agentversion ALTER COLUMN verid SET DEFAULT nextval('agentversion_verid_seq'::regclass);


--
-- Name: clkid; Type: DEFAULT; Schema: statschema; Owner: db00060892
--

ALTER TABLE ONLY click0 ALTER COLUMN clkid SET DEFAULT nextval('click0_clkid_seq'::regclass);


--
-- Name: cntid; Type: DEFAULT; Schema: statschema; Owner: db00060892
--

ALTER TABLE ONLY counter ALTER COLUMN cntid SET DEFAULT nextval('counter_cntid_seq'::regclass);


--
-- Name: domainid; Type: DEFAULT; Schema: statschema; Owner: db00060892
--

ALTER TABLE ONLY domain ALTER COLUMN domainid SET DEFAULT nextval('domain_domainid_seq'::regclass);


--
-- Name: pageid; Type: DEFAULT; Schema: statschema; Owner: db00060892
--

ALTER TABLE ONLY page ALTER COLUMN pageid SET DEFAULT nextval('page_pageid_seq'::regclass);


--
-- Name: rawagentid; Type: DEFAULT; Schema: statschema; Owner: db00060892
--

ALTER TABLE ONLY rawagent ALTER COLUMN rawagentid SET DEFAULT nextval('rawagent_rawagentid_seq'::regclass);


SET search_path = subscriptionschema, pg_catalog;

--
-- Name: mlid; Type: DEFAULT; Schema: subscriptionschema; Owner: db00060892
--

ALTER TABLE ONLY mail ALTER COLUMN mlid SET DEFAULT nextval('mail_mlid_seq'::regclass);


--
-- Name: taskid; Type: DEFAULT; Schema: subscriptionschema; Owner: db00060892
--

ALTER TABLE ONLY mailtask ALTER COLUMN taskid SET DEFAULT nextval('mailtask_taskid_seq'::regclass);


--
-- Name: ssid; Type: DEFAULT; Schema: subscriptionschema; Owner: db00060892
--

ALTER TABLE ONLY subscriber ALTER COLUMN ssid SET DEFAULT nextval('subscriber_ssid_seq'::regclass);


SET search_path = userschema, pg_catalog;

--
-- Name: cid; Type: DEFAULT; Schema: userschema; Owner: db00060892
--

ALTER TABLE ONLY country ALTER COLUMN cid SET DEFAULT nextval('country_cid_seq'::regclass);


--
-- Name: titleid; Type: DEFAULT; Schema: userschema; Owner: db00060892
--

ALTER TABLE ONLY title ALTER COLUMN titleid SET DEFAULT nextval('title_titleid_seq'::regclass);


--
-- Name: pin; Type: DEFAULT; Schema: userschema; Owner: db00060892
--

ALTER TABLE ONLY userpin ALTER COLUMN pin SET DEFAULT nextval('userpin_pin_seq'::regclass);


SET search_path = cmsconfschema, pg_catalog;

--
-- Name: author_pkey; Type: CONSTRAINT; Schema: cmsconfschema; Owner: db00060892
--

ALTER TABLE ONLY author
    ADD CONSTRAINT author_pkey PRIMARY KEY (context, papnum, autpin);


--
-- Name: cont_kw_pkey; Type: CONSTRAINT; Schema: cmsconfschema; Owner: db00060892
--

ALTER TABLE ONLY cont_kw
    ADD CONSTRAINT cont_kw_pkey PRIMARY KEY (context, keyword);


--
-- Name: context_pkey; Type: CONSTRAINT; Schema: cmsconfschema; Owner: db00060892
--

ALTER TABLE ONLY context
    ADD CONSTRAINT context_pkey PRIMARY KEY (contid);


--
-- Name: editor_pkey; Type: CONSTRAINT; Schema: cmsconfschema; Owner: db00060892
--

ALTER TABLE ONLY editor
    ADD CONSTRAINT editor_pkey PRIMARY KEY (context, userpin);


--
-- Name: keyword_pkey; Type: CONSTRAINT; Schema: cmsconfschema; Owner: db00060892
--

ALTER TABLE ONLY keyword
    ADD CONSTRAINT keyword_pkey PRIMARY KEY (kwid);


--
-- Name: pap_kw_pkey; Type: CONSTRAINT; Schema: cmsconfschema; Owner: db00060892
--

ALTER TABLE ONLY pap_kw
    ADD CONSTRAINT pap_kw_pkey PRIMARY KEY (context, papnum, keyword);


--
-- Name: paper_pkey; Type: CONSTRAINT; Schema: cmsconfschema; Owner: db00060892
--

ALTER TABLE ONLY paper
    ADD CONSTRAINT paper_pkey PRIMARY KEY (context, papnum);


--
-- Name: review_pkey; Type: CONSTRAINT; Schema: cmsconfschema; Owner: db00060892
--

ALTER TABLE ONLY review
    ADD CONSTRAINT review_pkey PRIMARY KEY (context, papnum, revnum);


--
-- Name: user_kw_pkey; Type: CONSTRAINT; Schema: cmsconfschema; Owner: db00060892
--

ALTER TABLE ONLY user_kw
    ADD CONSTRAINT user_kw_pkey PRIMARY KEY (userpin, keyword);


SET search_path = cmsmlschema, pg_catalog;

--
-- Name: maildata_pkey; Type: CONSTRAINT; Schema: cmsmlschema; Owner: db00060892
--

ALTER TABLE ONLY maildata
    ADD CONSTRAINT maildata_pkey PRIMARY KEY (mlid);


--
-- Name: mailtask_pkey; Type: CONSTRAINT; Schema: cmsmlschema; Owner: db00060892
--

ALTER TABLE ONLY mailtask
    ADD CONSTRAINT mailtask_pkey PRIMARY KEY (taskid);


SET search_path = coms01, pg_catalog;

--
-- Name: author_pkey; Type: CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY author
    ADD CONSTRAINT author_pkey PRIMARY KEY (context, papnum, autpin);


--
-- Name: cont_kw_pkey; Type: CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY cont_kw
    ADD CONSTRAINT cont_kw_pkey PRIMARY KEY (context, keyword);


--
-- Name: cont_perm_pkey; Type: CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY cont_perm
    ADD CONSTRAINT cont_perm_pkey PRIMARY KEY (context, permission);


--
-- Name: context_pkey; Type: CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY context
    ADD CONSTRAINT context_pkey PRIMARY KEY (contid);


--
-- Name: contseq_pkey; Type: CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY contseq
    ADD CONSTRAINT contseq_pkey PRIMARY KEY (context, topic);


--
-- Name: editor_context_key; Type: CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY editor
    ADD CONSTRAINT editor_context_key UNIQUE (context, userpin);


--
-- Name: editor_pkey; Type: CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY editor
    ADD CONSTRAINT editor_pkey PRIMARY KEY (editorid);


--
-- Name: keyword_pkey; Type: CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY keyword
    ADD CONSTRAINT keyword_pkey PRIMARY KEY (kwid);


--
-- Name: pap_kw_pkey; Type: CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY pap_kw
    ADD CONSTRAINT pap_kw_pkey PRIMARY KEY (context, papnum, keyword);


--
-- Name: paper_pkey; Type: CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY paper
    ADD CONSTRAINT paper_pkey PRIMARY KEY (context, papnum);


--
-- Name: permission_pkey; Type: CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY permission
    ADD CONSTRAINT permission_pkey PRIMARY KEY (permid);


--
-- Name: review_pkey; Type: CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY review
    ADD CONSTRAINT review_pkey PRIMARY KEY (context, papnum, revpin);


--
-- Name: score_pkey; Type: CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY score
    ADD CONSTRAINT score_pkey PRIMARY KEY (scoreid);


--
-- Name: subject_pkey; Type: CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY subject
    ADD CONSTRAINT subject_pkey PRIMARY KEY (subjid);


--
-- Name: subjectreview_pkey; Type: CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY subjectreview
    ADD CONSTRAINT subjectreview_pkey PRIMARY KEY (subjid, revpin);


--
-- Name: user_kw_pkey; Type: CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY user_kw
    ADD CONSTRAINT user_kw_pkey PRIMARY KEY (userpin, keyword);


SET search_path = comsml01, pg_catalog;

--
-- Name: mlcont_synctask_pkey; Type: CONSTRAINT; Schema: comsml01; Owner: db00060892
--

ALTER TABLE ONLY mlcont_synctask
    ADD CONSTRAINT mlcont_synctask_pkey PRIMARY KEY (context, task);


--
-- Name: mldata_pkey; Type: CONSTRAINT; Schema: comsml01; Owner: db00060892
--

ALTER TABLE ONLY mldata
    ADD CONSTRAINT mldata_pkey PRIMARY KEY (mlid);


--
-- Name: mlproducer_pkey; Type: CONSTRAINT; Schema: comsml01; Owner: db00060892
--

ALTER TABLE ONLY mlproducer
    ADD CONSTRAINT mlproducer_pkey PRIMARY KEY (prid);


--
-- Name: mlqueue_pkey; Type: CONSTRAINT; Schema: comsml01; Owner: db00060892
--

ALTER TABLE ONLY mlqueue
    ADD CONSTRAINT mlqueue_pkey PRIMARY KEY (qid);


--
-- Name: mlsynctask_pkey; Type: CONSTRAINT; Schema: comsml01; Owner: db00060892
--

ALTER TABLE ONLY mlsynctask
    ADD CONSTRAINT mlsynctask_pkey PRIMARY KEY (stid);


--
-- Name: mltask_pkey; Type: CONSTRAINT; Schema: comsml01; Owner: db00060892
--

ALTER TABLE ONLY mltask
    ADD CONSTRAINT mltask_pkey PRIMARY KEY (tid);


--
-- Name: mltempl_pkey; Type: CONSTRAINT; Schema: comsml01; Owner: db00060892
--

ALTER TABLE ONLY mltempl
    ADD CONSTRAINT mltempl_pkey PRIMARY KEY (mtid);


SET search_path = lib01, pg_catalog;

--
-- Name: lib_tree_item_pkey; Type: CONSTRAINT; Schema: lib01; Owner: db00060892
--

ALTER TABLE ONLY lib_tree_item
    ADD CONSTRAINT lib_tree_item_pkey PRIMARY KEY (item_id);


SET search_path = membership01, pg_catalog;

--
-- Name: ipacs_member_pkey; Type: CONSTRAINT; Schema: membership01; Owner: db00060892
--

ALTER TABLE ONLY ipacs_member
    ADD CONSTRAINT ipacs_member_pkey PRIMARY KEY (userpin);


SET search_path = newsschema, pg_catalog;

--
-- Name: news_pkey; Type: CONSTRAINT; Schema: newsschema; Owner: db00060892
--

ALTER TABLE ONLY news
    ADD CONSTRAINT news_pkey PRIMARY KEY (newsid);


SET search_path = portalschema, pg_catalog;

--
-- Name: category_lft_key; Type: CONSTRAINT; Schema: portalschema; Owner: db00060892
--

ALTER TABLE ONLY category
    ADD CONSTRAINT category_lft_key UNIQUE (lft);


--
-- Name: category_pkey; Type: CONSTRAINT; Schema: portalschema; Owner: db00060892
--

ALTER TABLE ONLY category
    ADD CONSTRAINT category_pkey PRIMARY KEY (catid);


--
-- Name: category_rgt_key; Type: CONSTRAINT; Schema: portalschema; Owner: db00060892
--

ALTER TABLE ONLY category
    ADD CONSTRAINT category_rgt_key UNIQUE (rgt);


--
-- Name: catres primary; Type: CONSTRAINT; Schema: portalschema; Owner: db00060892
--

ALTER TABLE ONLY catres
    ADD CONSTRAINT "catres primary" PRIMARY KEY (pos, resource);


--
-- Name: resource state; Type: CONSTRAINT; Schema: portalschema; Owner: db00060892
--

ALTER TABLE ONLY resource
    ADD CONSTRAINT "resource state" UNIQUE (resid, state);


--
-- Name: resource_pkey; Type: CONSTRAINT; Schema: portalschema; Owner: db00060892
--

ALTER TABLE ONLY resource
    ADD CONSTRAINT resource_pkey PRIMARY KEY (resid);


--
-- Name: topic_pkey; Type: CONSTRAINT; Schema: portalschema; Owner: db00060892
--

ALTER TABLE ONLY topic
    ADD CONSTRAINT topic_pkey PRIMARY KEY (topid);


--
-- Name: topres primary; Type: CONSTRAINT; Schema: portalschema; Owner: db00060892
--

ALTER TABLE ONLY topres
    ADD CONSTRAINT "topres primary" PRIMARY KEY (topic, resource);


SET search_path = statschema, pg_catalog;

--
-- Name: agent_ordnum_key; Type: CONSTRAINT; Schema: statschema; Owner: db00060892
--

ALTER TABLE ONLY agent
    ADD CONSTRAINT agent_ordnum_key UNIQUE (ordnum);


--
-- Name: agent_pkey; Type: CONSTRAINT; Schema: statschema; Owner: db00060892
--

ALTER TABLE ONLY agent
    ADD CONSTRAINT agent_pkey PRIMARY KEY (agentid);


--
-- Name: agentversion_pkey; Type: CONSTRAINT; Schema: statschema; Owner: db00060892
--

ALTER TABLE ONLY agentversion
    ADD CONSTRAINT agentversion_pkey PRIMARY KEY (verid);


--
-- Name: click0_pkey; Type: CONSTRAINT; Schema: statschema; Owner: db00060892
--

ALTER TABLE ONLY click0
    ADD CONSTRAINT click0_pkey PRIMARY KEY (clkid);


--
-- Name: click_pkey; Type: CONSTRAINT; Schema: statschema; Owner: db00060892
--

ALTER TABLE ONLY click
    ADD CONSTRAINT click_pkey PRIMARY KEY (clkid);


--
-- Name: counter_pkey; Type: CONSTRAINT; Schema: statschema; Owner: db00060892
--

ALTER TABLE ONLY counter
    ADD CONSTRAINT counter_pkey PRIMARY KEY (cntid);


--
-- Name: country_pkey; Type: CONSTRAINT; Schema: statschema; Owner: db00060892
--

ALTER TABLE ONLY country
    ADD CONSTRAINT country_pkey PRIMARY KEY (code);


--
-- Name: domain_name_key; Type: CONSTRAINT; Schema: statschema; Owner: db00060892
--

ALTER TABLE ONLY domain
    ADD CONSTRAINT domain_name_key UNIQUE (name);


--
-- Name: domain_pkey; Type: CONSTRAINT; Schema: statschema; Owner: db00060892
--

ALTER TABLE ONLY domain
    ADD CONSTRAINT domain_pkey PRIMARY KEY (domainid);


--
-- Name: host_pkey; Type: CONSTRAINT; Schema: statschema; Owner: db00060892
--

ALTER TABLE ONLY host
    ADD CONSTRAINT host_pkey PRIMARY KEY (hostip);


--
-- Name: ip2country_ip_from_key; Type: CONSTRAINT; Schema: statschema; Owner: db00060892
--

ALTER TABLE ONLY ip2country
    ADD CONSTRAINT ip2country_ip_from_key UNIQUE (ip_from);


--
-- Name: ip2country_ip_to_key; Type: CONSTRAINT; Schema: statschema; Owner: db00060892
--

ALTER TABLE ONLY ip2country
    ADD CONSTRAINT ip2country_ip_to_key UNIQUE (ip_to);


--
-- Name: ip2country_pkey; Type: CONSTRAINT; Schema: statschema; Owner: db00060892
--

ALTER TABLE ONLY ip2country
    ADD CONSTRAINT ip2country_pkey PRIMARY KEY (ip_from, ip_to);


--
-- Name: page_domain_key; Type: CONSTRAINT; Schema: statschema; Owner: db00060892
--

ALTER TABLE ONLY page
    ADD CONSTRAINT page_domain_key UNIQUE (domain, name);


--
-- Name: page_pkey; Type: CONSTRAINT; Schema: statschema; Owner: db00060892
--

ALTER TABLE ONLY page
    ADD CONSTRAINT page_pkey PRIMARY KEY (pageid);


--
-- Name: rawagent_pkey; Type: CONSTRAINT; Schema: statschema; Owner: db00060892
--

ALTER TABLE ONLY rawagent
    ADD CONSTRAINT rawagent_pkey PRIMARY KEY (rawagentid);


--
-- Name: rawagent_value_key; Type: CONSTRAINT; Schema: statschema; Owner: db00060892
--

ALTER TABLE ONLY rawagent
    ADD CONSTRAINT rawagent_value_key UNIQUE (value);


SET search_path = subscriptionschema, pg_catalog;

--
-- Name: mail_pkey; Type: CONSTRAINT; Schema: subscriptionschema; Owner: db00060892
--

ALTER TABLE ONLY mail
    ADD CONSTRAINT mail_pkey PRIMARY KEY (mlid);


--
-- Name: mailtask_pkey; Type: CONSTRAINT; Schema: subscriptionschema; Owner: db00060892
--

ALTER TABLE ONLY mailtask
    ADD CONSTRAINT mailtask_pkey PRIMARY KEY (taskid);


--
-- Name: subscriber_pkey; Type: CONSTRAINT; Schema: subscriptionschema; Owner: db00060892
--

ALTER TABLE ONLY subscriber
    ADD CONSTRAINT subscriber_pkey PRIMARY KEY (ssid);


SET search_path = userschema, pg_catalog;

--
-- Name: country_pkey; Type: CONSTRAINT; Schema: userschema; Owner: db00060892
--

ALTER TABLE ONLY country
    ADD CONSTRAINT country_pkey PRIMARY KEY (cid);


--
-- Name: title_pkey; Type: CONSTRAINT; Schema: userschema; Owner: db00060892
--

ALTER TABLE ONLY title
    ADD CONSTRAINT title_pkey PRIMARY KEY (titleid);


--
-- Name: userkey_pkey; Type: CONSTRAINT; Schema: userschema; Owner: db00060892
--

ALTER TABLE ONLY userkey
    ADD CONSTRAINT userkey_pkey PRIMARY KEY (key);


--
-- Name: userpin_pkey; Type: CONSTRAINT; Schema: userschema; Owner: db00060892
--

ALTER TABLE ONLY userpin
    ADD CONSTRAINT userpin_pkey PRIMARY KEY (pin);


SET search_path = portalschema, pg_catalog;

--
-- Name: category_idx_name; Type: INDEX; Schema: portalschema; Owner: db00060892
--

CREATE INDEX category_idx_name ON category USING btree (name);


--
-- Name: category_idx_size; Type: INDEX; Schema: portalschema; Owner: db00060892
--

CREATE INDEX category_idx_size ON category USING btree (((rgt - lft)));


--
-- Name: category_idx_title; Type: INDEX; Schema: portalschema; Owner: db00060892
--

CREATE INDEX category_idx_title ON category USING btree (title);


--
-- Name: catres_idx_posresource002; Type: INDEX; Schema: portalschema; Owner: db00060892
--

CREATE INDEX catres_idx_posresource002 ON catres USING btree (resource, pos) WHERE (state = 1);


--
-- Name: catres_idx_resource; Type: INDEX; Schema: portalschema; Owner: db00060892
--

CREATE INDEX catres_idx_resource ON catres USING btree (resource);


--
-- Name: idx_test; Type: INDEX; Schema: portalschema; Owner: db00060892
--

CREATE INDEX idx_test ON resource USING btree (title);


--
-- Name: resource_idx_time001; Type: INDEX; Schema: portalschema; Owner: db00060892
--

CREATE INDEX resource_idx_time001 ON resource USING btree (addtime) WHERE ((NOT isevent) AND (state = 1));


--
-- Name: resource_idx_time002; Type: INDEX; Schema: portalschema; Owner: db00060892
--

CREATE INDEX resource_idx_time002 ON resource USING btree (addtime, beginyear, beginmonth, beginday) WHERE (isevent AND (state = 1));


--
-- Name: resource_idx_title001; Type: INDEX; Schema: portalschema; Owner: db00060892
--

CREATE INDEX resource_idx_title001 ON resource USING btree (title) WHERE (state = 1);


--
-- Name: resource_idx_title003; Type: INDEX; Schema: portalschema; Owner: db00060892
--

CREATE INDEX resource_idx_title003 ON resource USING btree (((- beginyear)), ((- beginmonth)), ((- beginday)), title) WHERE (state = 1);


--
-- Name: topic_idx_name; Type: INDEX; Schema: portalschema; Owner: db00060892
--

CREATE INDEX topic_idx_name ON topic USING btree (name);


--
-- Name: topic_idx_title; Type: INDEX; Schema: portalschema; Owner: db00060892
--

CREATE INDEX topic_idx_title ON topic USING btree (title);


--
-- Name: topres_idx_resourcetopic; Type: INDEX; Schema: portalschema; Owner: db00060892
--

CREATE INDEX topres_idx_resourcetopic ON topres USING btree (resource, topic);


--
-- Name: topres_idx_topicresource002; Type: INDEX; Schema: portalschema; Owner: db00060892
--

CREATE INDEX topres_idx_topicresource002 ON topres USING btree (resource, topic) WHERE (state = 1);


SET search_path = statschema, pg_catalog;

--
-- Name: ip2country_idx_ipfbig; Type: INDEX; Schema: statschema; Owner: db00060892
--

CREATE INDEX ip2country_idx_ipfbig ON ip2country USING btree (int2bigint(ip_from));


SET search_path = userschema, pg_catalog;

--
-- Name: country_idx_name; Type: INDEX; Schema: userschema; Owner: db00060892
--

CREATE INDEX country_idx_name ON country USING btree (name);


SET search_path = cmsconfschema, pg_catalog;

--
-- Name: $1; Type: FK CONSTRAINT; Schema: cmsconfschema; Owner: db00060892
--

ALTER TABLE ONLY user_kw
    ADD CONSTRAINT "$1" FOREIGN KEY (userpin) REFERENCES userschema.userpin(pin) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: cmsconfschema; Owner: db00060892
--

ALTER TABLE ONLY cont_kw
    ADD CONSTRAINT "$1" FOREIGN KEY (context) REFERENCES context(contid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: cmsconfschema; Owner: db00060892
--

ALTER TABLE ONLY editor
    ADD CONSTRAINT "$1" FOREIGN KEY (context) REFERENCES context(contid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: cmsconfschema; Owner: db00060892
--

ALTER TABLE ONLY paper
    ADD CONSTRAINT "$1" FOREIGN KEY (context) REFERENCES context(contid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: cmsconfschema; Owner: db00060892
--

ALTER TABLE ONLY author
    ADD CONSTRAINT "$1" FOREIGN KEY (context, papnum) REFERENCES paper(context, papnum) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: cmsconfschema; Owner: db00060892
--

ALTER TABLE ONLY review
    ADD CONSTRAINT "$1" FOREIGN KEY (context, papnum) REFERENCES paper(context, papnum) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: cmsconfschema; Owner: db00060892
--

ALTER TABLE ONLY pap_kw
    ADD CONSTRAINT "$1" FOREIGN KEY (context, papnum) REFERENCES paper(context, papnum) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $2; Type: FK CONSTRAINT; Schema: cmsconfschema; Owner: db00060892
--

ALTER TABLE ONLY user_kw
    ADD CONSTRAINT "$2" FOREIGN KEY (keyword) REFERENCES keyword(kwid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $2; Type: FK CONSTRAINT; Schema: cmsconfschema; Owner: db00060892
--

ALTER TABLE ONLY cont_kw
    ADD CONSTRAINT "$2" FOREIGN KEY (keyword) REFERENCES keyword(kwid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $2; Type: FK CONSTRAINT; Schema: cmsconfschema; Owner: db00060892
--

ALTER TABLE ONLY editor
    ADD CONSTRAINT "$2" FOREIGN KEY (userpin) REFERENCES userschema.userpin(pin) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $2; Type: FK CONSTRAINT; Schema: cmsconfschema; Owner: db00060892
--

ALTER TABLE ONLY paper
    ADD CONSTRAINT "$2" FOREIGN KEY (registrator) REFERENCES userschema.userpin(pin) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: $2; Type: FK CONSTRAINT; Schema: cmsconfschema; Owner: db00060892
--

ALTER TABLE ONLY author
    ADD CONSTRAINT "$2" FOREIGN KEY (autpin) REFERENCES userschema.userpin(pin) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $2; Type: FK CONSTRAINT; Schema: cmsconfschema; Owner: db00060892
--

ALTER TABLE ONLY review
    ADD CONSTRAINT "$2" FOREIGN KEY (revpin) REFERENCES userschema.userpin(pin) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: $2; Type: FK CONSTRAINT; Schema: cmsconfschema; Owner: db00060892
--

ALTER TABLE ONLY pap_kw
    ADD CONSTRAINT "$2" FOREIGN KEY (context, keyword) REFERENCES cont_kw(context, keyword) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $3; Type: FK CONSTRAINT; Schema: cmsconfschema; Owner: db00060892
--

ALTER TABLE ONLY paper
    ADD CONSTRAINT "$3" FOREIGN KEY (editor) REFERENCES userschema.userpin(pin) ON UPDATE CASCADE ON DELETE SET NULL;


SET search_path = cmsmlschema, pg_catalog;

--
-- Name: $1; Type: FK CONSTRAINT; Schema: cmsmlschema; Owner: db00060892
--

ALTER TABLE ONLY mailtask
    ADD CONSTRAINT "$1" FOREIGN KEY (mlid) REFERENCES maildata(mlid) ON UPDATE CASCADE ON DELETE CASCADE;


SET search_path = coms01, pg_catalog;

--
-- Name: $1; Type: FK CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY user_kw
    ADD CONSTRAINT "$1" FOREIGN KEY (userpin) REFERENCES userschema.userpin(pin) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY context
    ADD CONSTRAINT "$1" FOREIGN KEY (manager) REFERENCES userschema.userpin(pin) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY contseq
    ADD CONSTRAINT "$1" FOREIGN KEY (context) REFERENCES context(contid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY cont_kw
    ADD CONSTRAINT "$1" FOREIGN KEY (context) REFERENCES context(contid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY cont_perm
    ADD CONSTRAINT "$1" FOREIGN KEY (context) REFERENCES context(contid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY editor
    ADD CONSTRAINT "$1" FOREIGN KEY (context) REFERENCES context(contid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY subject
    ADD CONSTRAINT "$1" FOREIGN KEY (ed_score) REFERENCES score(scoreid) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY paper
    ADD CONSTRAINT "$1" FOREIGN KEY (context) REFERENCES context(contid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY author
    ADD CONSTRAINT "$1" FOREIGN KEY (context, papnum) REFERENCES paper(context, papnum) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY review
    ADD CONSTRAINT "$1" FOREIGN KEY (score) REFERENCES score(scoreid) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY subjectreview
    ADD CONSTRAINT "$1" FOREIGN KEY (score) REFERENCES score(scoreid) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY pap_kw
    ADD CONSTRAINT "$1" FOREIGN KEY (context, papnum) REFERENCES paper(context, papnum) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $2; Type: FK CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY user_kw
    ADD CONSTRAINT "$2" FOREIGN KEY (keyword) REFERENCES keyword(kwid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $2; Type: FK CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY cont_kw
    ADD CONSTRAINT "$2" FOREIGN KEY (keyword) REFERENCES keyword(kwid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $2; Type: FK CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY cont_perm
    ADD CONSTRAINT "$2" FOREIGN KEY (permission) REFERENCES permission(permid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $2; Type: FK CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY editor
    ADD CONSTRAINT "$2" FOREIGN KEY (userpin) REFERENCES userschema.userpin(pin) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $2; Type: FK CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY subject
    ADD CONSTRAINT "$2" FOREIGN KEY (context) REFERENCES context(contid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $2; Type: FK CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY paper
    ADD CONSTRAINT "$2" FOREIGN KEY (registrator) REFERENCES userschema.userpin(pin) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: $2; Type: FK CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY author
    ADD CONSTRAINT "$2" FOREIGN KEY (autpin) REFERENCES userschema.userpin(pin) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $2; Type: FK CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY review
    ADD CONSTRAINT "$2" FOREIGN KEY (subject) REFERENCES subject(subjid) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: $2; Type: FK CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY subjectreview
    ADD CONSTRAINT "$2" FOREIGN KEY (subjid) REFERENCES subject(subjid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $2; Type: FK CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY pap_kw
    ADD CONSTRAINT "$2" FOREIGN KEY (keyword) REFERENCES keyword(kwid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $3; Type: FK CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY subject
    ADD CONSTRAINT "$3" FOREIGN KEY (manager) REFERENCES userschema.userpin(pin) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: $3; Type: FK CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY paper
    ADD CONSTRAINT "$3" FOREIGN KEY (editor) REFERENCES editor(editorid) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: $3; Type: FK CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY review
    ADD CONSTRAINT "$3" FOREIGN KEY (context, papnum) REFERENCES paper(context, papnum) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $3; Type: FK CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY subjectreview
    ADD CONSTRAINT "$3" FOREIGN KEY (revpin) REFERENCES userschema.userpin(pin) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: $4; Type: FK CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY subject
    ADD CONSTRAINT "$4" FOREIGN KEY (editor) REFERENCES editor(editorid) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: $4; Type: FK CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY paper
    ADD CONSTRAINT "$4" FOREIGN KEY (ed_score) REFERENCES score(scoreid) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: $4; Type: FK CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY review
    ADD CONSTRAINT "$4" FOREIGN KEY (revpin) REFERENCES userschema.userpin(pin) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: $4; Type: FK CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY subjectreview
    ADD CONSTRAINT "$4" FOREIGN KEY (context) REFERENCES context(contid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $5; Type: FK CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY paper
    ADD CONSTRAINT "$5" FOREIGN KEY (subject) REFERENCES subject(subjid) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: $6; Type: FK CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY paper
    ADD CONSTRAINT "$6" FOREIGN KEY (ed_subject) REFERENCES subject(subjid) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: $7; Type: FK CONSTRAINT; Schema: coms01; Owner: db00060892
--

ALTER TABLE ONLY paper
    ADD CONSTRAINT "$7" FOREIGN KEY (finalsubject) REFERENCES subject(subjid) ON UPDATE CASCADE ON DELETE SET NULL;


SET search_path = comsml01, pg_catalog;

--
-- Name: $1; Type: FK CONSTRAINT; Schema: comsml01; Owner: db00060892
--

ALTER TABLE ONLY mldata
    ADD CONSTRAINT "$1" FOREIGN KEY (context) REFERENCES coms01.context(contid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: comsml01; Owner: db00060892
--

ALTER TABLE ONLY mltask
    ADD CONSTRAINT "$1" FOREIGN KEY (mail) REFERENCES mldata(mlid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: comsml01; Owner: db00060892
--

ALTER TABLE ONLY mlqueue
    ADD CONSTRAINT "$1" FOREIGN KEY (task) REFERENCES mltask(tid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: comsml01; Owner: db00060892
--

ALTER TABLE ONLY mlcont_synctask
    ADD CONSTRAINT "$1" FOREIGN KEY (mail) REFERENCES mldata(mlid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $2; Type: FK CONSTRAINT; Schema: comsml01; Owner: db00060892
--

ALTER TABLE ONLY mltask
    ADD CONSTRAINT "$2" FOREIGN KEY (producer) REFERENCES mlproducer(prid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $2; Type: FK CONSTRAINT; Schema: comsml01; Owner: db00060892
--

ALTER TABLE ONLY mlcont_synctask
    ADD CONSTRAINT "$2" FOREIGN KEY (task) REFERENCES mlsynctask(stid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $3; Type: FK CONSTRAINT; Schema: comsml01; Owner: db00060892
--

ALTER TABLE ONLY mltask
    ADD CONSTRAINT "$3" FOREIGN KEY (context) REFERENCES coms01.context(contid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $3; Type: FK CONSTRAINT; Schema: comsml01; Owner: db00060892
--

ALTER TABLE ONLY mlcont_synctask
    ADD CONSTRAINT "$3" FOREIGN KEY (context) REFERENCES coms01.context(contid) ON UPDATE CASCADE ON DELETE CASCADE;


SET search_path = lib01, pg_catalog;

--
-- Name: lib_tree_item_parent_fkey; Type: FK CONSTRAINT; Schema: lib01; Owner: db00060892
--

ALTER TABLE ONLY lib_tree_item
    ADD CONSTRAINT lib_tree_item_parent_fkey FOREIGN KEY (parent) REFERENCES lib_tree_item(item_id) ON UPDATE CASCADE ON DELETE CASCADE;


SET search_path = membership01, pg_catalog;

--
-- Name: ipacs_member_userpin_fkey; Type: FK CONSTRAINT; Schema: membership01; Owner: db00060892
--

ALTER TABLE ONLY ipacs_member
    ADD CONSTRAINT ipacs_member_userpin_fkey FOREIGN KEY (userpin) REFERENCES userschema.userpin(pin) ON UPDATE CASCADE ON DELETE CASCADE;


SET search_path = portalschema, pg_catalog;

--
-- Name: $1; Type: FK CONSTRAINT; Schema: portalschema; Owner: db00060892
--

ALTER TABLE ONLY catres
    ADD CONSTRAINT "$1" FOREIGN KEY (pos) REFERENCES category(lft) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: portalschema; Owner: db00060892
--

ALTER TABLE ONLY topres
    ADD CONSTRAINT "$1" FOREIGN KEY (topic) REFERENCES topic(topid) ON DELETE CASCADE;


--
-- Name: $2; Type: FK CONSTRAINT; Schema: portalschema; Owner: db00060892
--

ALTER TABLE ONLY catres
    ADD CONSTRAINT "$2" FOREIGN KEY (resource) REFERENCES resource(resid) ON DELETE CASCADE;


--
-- Name: $2; Type: FK CONSTRAINT; Schema: portalschema; Owner: db00060892
--

ALTER TABLE ONLY topres
    ADD CONSTRAINT "$2" FOREIGN KEY (resource) REFERENCES resource(resid) ON DELETE CASCADE;


--
-- Name: catres foreign; Type: FK CONSTRAINT; Schema: portalschema; Owner: db00060892
--

ALTER TABLE ONLY catres
    ADD CONSTRAINT "catres foreign" FOREIGN KEY (resource, state) REFERENCES resource(resid, state) ON UPDATE CASCADE;


--
-- Name: topres foreign; Type: FK CONSTRAINT; Schema: portalschema; Owner: db00060892
--

ALTER TABLE ONLY topres
    ADD CONSTRAINT "topres foreign" FOREIGN KEY (resource, state) REFERENCES resource(resid, state) ON UPDATE CASCADE;


SET search_path = statschema, pg_catalog;

--
-- Name: click_addr; Type: FK CONSTRAINT; Schema: statschema; Owner: db00060892
--

ALTER TABLE ONLY click
    ADD CONSTRAINT click_addr FOREIGN KEY (addrpage) REFERENCES page(pageid) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: click_agentversion; Type: FK CONSTRAINT; Schema: statschema; Owner: db00060892
--

ALTER TABLE ONLY click
    ADD CONSTRAINT click_agentversion FOREIGN KEY (agentversion) REFERENCES agentversion(verid) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: click_cnt; Type: FK CONSTRAINT; Schema: statschema; Owner: db00060892
--

ALTER TABLE ONLY click0
    ADD CONSTRAINT click_cnt FOREIGN KEY (cnt) REFERENCES counter(cntid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: click_cnt; Type: FK CONSTRAINT; Schema: statschema; Owner: db00060892
--

ALTER TABLE ONLY click
    ADD CONSTRAINT click_cnt FOREIGN KEY (cnt) REFERENCES counter(cntid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: click_host; Type: FK CONSTRAINT; Schema: statschema; Owner: db00060892
--

ALTER TABLE ONLY click
    ADD CONSTRAINT click_host FOREIGN KEY (host) REFERENCES host(hostip) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: click_rawagent; Type: FK CONSTRAINT; Schema: statschema; Owner: db00060892
--

ALTER TABLE ONLY click
    ADD CONSTRAINT click_rawagent FOREIGN KEY (rawagent) REFERENCES rawagent(rawagentid) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: click_referer; Type: FK CONSTRAINT; Schema: statschema; Owner: db00060892
--

ALTER TABLE ONLY click
    ADD CONSTRAINT click_referer FOREIGN KEY (refererpage) REFERENCES page(pageid) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: host_country; Type: FK CONSTRAINT; Schema: statschema; Owner: db00060892
--

ALTER TABLE ONLY host
    ADD CONSTRAINT host_country FOREIGN KEY (country) REFERENCES country(code) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: ip2country foreign; Type: FK CONSTRAINT; Schema: statschema; Owner: db00060892
--

ALTER TABLE ONLY ip2country
    ADD CONSTRAINT "ip2country foreign" FOREIGN KEY (country) REFERENCES country(code) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: page_domain; Type: FK CONSTRAINT; Schema: statschema; Owner: db00060892
--

ALTER TABLE ONLY page
    ADD CONSTRAINT page_domain FOREIGN KEY (domain) REFERENCES domain(domainid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: version_agent; Type: FK CONSTRAINT; Schema: statschema; Owner: db00060892
--

ALTER TABLE ONLY agentversion
    ADD CONSTRAINT version_agent FOREIGN KEY (agent) REFERENCES agent(agentid) ON UPDATE CASCADE ON DELETE SET NULL;


SET search_path = subscriptionschema, pg_catalog;

--
-- Name: $1; Type: FK CONSTRAINT; Schema: subscriptionschema; Owner: db00060892
--

ALTER TABLE ONLY mailtask
    ADD CONSTRAINT "$1" FOREIGN KEY (mlid) REFERENCES mail(mlid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $2; Type: FK CONSTRAINT; Schema: subscriptionschema; Owner: db00060892
--

ALTER TABLE ONLY mailtask
    ADD CONSTRAINT "$2" FOREIGN KEY (taskssid) REFERENCES subscriber(ssid) ON UPDATE CASCADE ON DELETE CASCADE;


SET search_path = userschema, pg_catalog;

--
-- Name: $1; Type: FK CONSTRAINT; Schema: userschema; Owner: db00060892
--

ALTER TABLE ONLY userpin
    ADD CONSTRAINT "$1" FOREIGN KEY (country) REFERENCES country(cid) ON UPDATE CASCADE ON DELETE SET DEFAULT;


--
-- Name: $1; Type: FK CONSTRAINT; Schema: userschema; Owner: db00060892
--

ALTER TABLE ONLY userkey
    ADD CONSTRAINT "$1" FOREIGN KEY (pin) REFERENCES userpin(pin) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: $2; Type: FK CONSTRAINT; Schema: userschema; Owner: db00060892
--

ALTER TABLE ONLY userpin
    ADD CONSTRAINT "$2" FOREIGN KEY (title) REFERENCES title(titleid) ON UPDATE CASCADE ON DELETE SET DEFAULT;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


SET search_path = public, pg_catalog;

--
-- Name: plpgsql_call_handler(); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION plpgsql_call_handler() FROM PUBLIC;
REVOKE ALL ON FUNCTION plpgsql_call_handler() FROM postgres;
GRANT ALL ON FUNCTION plpgsql_call_handler() TO postgres;
GRANT ALL ON FUNCTION plpgsql_call_handler() TO PUBLIC;


--
-- PostgreSQL database dump complete
--

