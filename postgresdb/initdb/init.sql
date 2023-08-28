-- SQL script to create tables and populate them with random data
CREATE TABLE IF NOT EXISTS employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL
);

-- Insert some random data
INSERT INTO employees (name, age) VALUES ('Alice', 32);
INSERT INTO employees (name, age) VALUES ('Bob', 28);
INSERT INTO employees (name, age) VALUES ('Charlie', 45);
