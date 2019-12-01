BEGIN;
    CREATE TABLE dogs (
        id              SERIAL PRIMARY KEY,
        owner_name      VARCHAR(255) NOT NULL,
        name            VARCHAR(255) NOT NULL,
        age             INTEGER NOT NULL
    );

    INSERT INTO dogs (owner_name, name, age) VALUES
        ('John', 'Fido', 3),
        ('John', 'Rex', 5),
        ('Jane', 'Tibbles', 4),
        ('Jane', 'Fred', 5);

    SELECT
        owner_name,
        FIRST(name ORDER BY age ASC) AS youngest_dog_name
    FROM dogs
    GROUP BY owner_name
    ORDER BY owner_name ASC;
ROLLBACK;