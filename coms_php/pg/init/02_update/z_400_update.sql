

SET default_transaction_read_only = off;

SET client_encoding = 'LATIN1';
SET standard_conforming_strings = on;


\connect db00060892

SET default_transaction_read_only = off;


SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'WIN1251';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;





-- SET search_path = cmsconfschema, pg_catalog;

SET search_path = coms01, pg_catalog;


ALTER TABLE context ADD COLUMN IF NOT EXISTS review_deadline character varying(255);



