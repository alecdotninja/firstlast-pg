-- This files reverses any changes made in `up.sql`.
BEGIN TRANSACTION;
	DROP AGGREGATE IF EXISTS FIRST(anyelement);
	
	DROP FUNCTION IF EXISTS first_agg_accum(anyarray, anyelement);
	DROP FUNCTION IF EXISTS first_agg_final(anyarray);
END TRANSACTION;
