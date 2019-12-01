-- This file defines the `FIRST` aggregate function.
BEGIN TRANSACTION;
    CREATE FUNCTION
        first_agg_accum(accumulator anyarray, next_value anyelement)
        RETURNS anyarray
        AS $$
            BEGIN
                IF cardinality(accumulator) = 0 THEN
                    RETURN ARRAY[next_value];
                ELSE
                    RETURN accumulator;
                END IF;
            END;
        $$ LANGUAGE plpgsql
        IMMUTABLE;

    CREATE FUNCTION
        first_agg_final(accumulator anyarray)
        RETURNS anyelement
        AS $$
            BEGIN
                RETURN accumulator[1];
            END;
        $$ LANGUAGE plpgsql
        IMMUTABLE;

    CREATE AGGREGATE
        FIRST(anyelement)
        (
            sfunc = first_agg_accum,
            stype = anyarray,
            finalfunc = first_agg_final,
            initcond = '{}'
        );
END TRANSACTION;

