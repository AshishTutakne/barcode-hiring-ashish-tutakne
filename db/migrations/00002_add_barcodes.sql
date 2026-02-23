-- +goose Up
-- +goose StatementBegin

ALTER TABLE dirac.product 
ADD COLUMN barcode VARCHAR(130) UNIQUE;

-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin

ALTER TABLE dirac.product 
DROP COLUMN IF EXISTS barcode;

-- +goose StatementEnd