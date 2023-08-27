#!/bin/bash

# Function to create a file with content
create_file() {
  local FILE_PATH="$1"
  local CONTENT="$2"
  echo -e "$CONTENT" > "$FILE_PATH"
}

# Create directory structure
mkdir -p my_postgres_image/initdb

# Create Dockerfile
DOCKERFILE_CONTENT="FROM postgres:13

# Copy initialization scripts to /docker-entrypoint-initdb.d/
COPY ./initdb /docker-entrypoint-initdb.d/"

create_file my_postgres_image/Dockerfile "$DOCKERFILE_CONTENT"

# Create init.sql
INIT_SQL_CONTENT="-- SQL script to create tables and populate them with random data
CREATE TABLE IF NOT EXISTS employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL
);

-- Insert some random data
INSERT INTO employees (name, age) VALUES ('Alice', 32);
INSERT INTO employees (name, age) VALUES ('Bob', 28);
INSERT INTO employees (name, age) VALUES ('Charlie', 45);"

create_file my_postgres_image/initdb/init.sql "$INIT_SQL_CONTENT"

# Create random_data.sh
RANDOM_DATA_SH_CONTENT="#!/bin/bash
PGPASSWORD=\$POSTGRES_PASSWORD psql -U \$POSTGRES_USER -d \$POSTGRES_DB -c \"
DO
\$$
BEGIN
    FOR i IN 1..1000 LOOP
        INSERT INTO employees (name, age) VALUES (md5(random()::text), floor(random() * (70-18+1) + 18)::integer);
    END LOOP;
END
\$$\""

create_file my_postgres_image/initdb/random_data.sh "$RANDOM_DATA_SH_CONTENT"
chmod +x my_postgres_image/initdb/random_data.sh

# Print out a success message
echo "Postgres Docker image directory 'my_postgres_image' has been generated."
