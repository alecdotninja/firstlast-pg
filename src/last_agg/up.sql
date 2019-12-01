-- This file defines the `LAST` aggregate function.
BEGIN TRANSACTION;
    CREATE FUNCTION
        last_agg_accum(anyelement, next_value anyelement)
        RETURNS anyelement
        AS $$
            BEGIN
                RETURN next_value;
            END;
        $$ LANGUAGE plpgsql
        IMMUTABLE;

    CREATE AGGREGATE
        LAST(anyelement)
        (
            sfunc = last_agg_accum,
            stype = anyelement,
            initcond = NULL
        );
END TRANSACTION;
