# firstlast-pg
[![Build Status](https://travis-ci.org/alecdotninja/firstlast-pg.svg?branch=master)](https://travis-ci.org/alecdotninja/firstlast-pg)

This repo provides `FIRST` and `LAST` aggregate functions for [all recent versions of PostgreSQL](.travis.yml).

## Motivation / Usage

Given some `dogs`:

```sql
CREATE TABLE dogs (
    id              SERIAL PRIMARY KEY,
    owner_name      VARCHAR(255) NOT NULL,
    name            VARCHAR(255) NOT NULL,
    age             INTEGER NOT NULL
);

INSERT INTO dogs (owner_name, name, age) VALUES
    ('John', 'Fido', 3),
    ('Jane', 'Fred', 5);
    ('John', 'Rex', 5),
    ('Jane', 'Tibbles', 4),
```

The built-in `DISTINCT ON` clause can be used to find the youngest and oldest dog name for each owner:

```sql
SELECT
    DISTINCT ON (owner_name)
    owner_name,
    name AS youngest_dog_name
FROM dogs
ORDER BY owner_name, age ASC;

SELECT
    DISTINCT ON (owner_name)
    owner_name,
    name AS oldest_dog_name
FROM dogs
ORDER BY owner_name, age DESC;
```

This works and is indeed [an intended usage of `DISTINCT ON`](), but I personally find this a bit awkward.
It also has the major technical drawback of requiring two queries (and, more importantly, two table scans).

It is possible to get both the oldest *and* the youngest in a single table scan with window functions:

```sql
SELECT
    DISTINCT
    owner_name,
    FIRST_VALUE(name) OVER owner_name_by_age AS youngest_dog_name,
    LAST_VALUE(name)  OVER owner_name_by_age AS oldest_dog_name
FROM dogs
WINDOW owner_name_by_age AS (PARTITION BY owner_name ORDER BY age ASC)
```

Again, this works, but I personally find it even more awkard (and much more difficult to follow) than the last example.

The `FIRST` and `LAST` aggregate functions defined here have the semantics I want while still allowing for multiple orderings with a single table scan:

```sql
SELECT
    owner_name,
    FIRST(name ORDER BY age ASC) AS youngest_dog_name,
    LAST (name ORDER BY age ASC) AS oldest_dog_name
FROM
    dogs
GROUP BY owner_name
```

## Installation

Run the `up.sql` for each feature in [the `src` directiory](src) that you want to install.

To install all features at once, checkout the repo, then execute:

    $ cat src/*/up.sql | psql

**Note:** To remove a feature, perform the same steps with the corresponding `down.sql` file.

## Development

A rudimentary test suite is located in [the `test` directory](test).
To verify it locally, run `bin/test`.
It is verfied against [all recent versions of PostgreSQL](.travis.yml) in CI.

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/alecdotninja/firstlast-pg).

## License

The code is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
