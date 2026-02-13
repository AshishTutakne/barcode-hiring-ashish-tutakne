-- +goose Up
-- +goose StatementBegin

CREATE SCHEMA IF NOT EXISTS dirac;
-- Simple product table - candidates will need to figure out how to handle barcodes
CREATE TABLE dirac.product (
	id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
	description TEXT,
	created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- +goose StatementEnd


-- +goose Down
DROP SCHEMA IF EXISTS dirac CASCADE;
