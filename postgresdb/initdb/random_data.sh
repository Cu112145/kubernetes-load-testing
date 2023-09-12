#!/bin/bash

SQL_COMMAND=$(cat <<- EOM
    DO $$ 
    BEGIN
        FOR i IN 1..1000 LOOP
            INSERT INTO employees (name, age)
            VALUES (md5(random()::text), floor(random() * (70-18+1) + 18)::integer);
        END LOOP;
    END $$;
EOM
)

PGPASSWORD="$POSTGRES_PASSWORD" psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "$SQL_COMMAND"