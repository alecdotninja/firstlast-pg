-- This files reverses any changes made in `up.sql`.
BEGIN TRANSACTION;
	DROP AGGREGATE IF EXISTS LAST(anyelement);

	DROP FUNCTION IF EXISTS last_agg_accum(anyelement, anyelement);
END TRANSACTION;

