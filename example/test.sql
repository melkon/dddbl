[TEST-QUERY]
QUERY = "CREATE TABLE  muff (id SERIAL, name VARCHAR(255))"

[TEST-INSERT]
QUERY = "INSERT INTO muff (name) VALUES(?)"

[TEST-SELECT]
QUERY = "SELECT * FROM muff"
HANDLER = YAML

[TEST-DROP]
QUERY = "DROP TABLE IF EXISTS muff"