-- +goose Up
-- +goose StatementBegin

CREATE OR REPLACE PROCEDURE dirac.ingest_product(
    p_name VARCHAR,
    p_description TEXT,
    p_barcode VARCHAR
) AS $$
DECLARE
    v_clean_barcode VARCHAR;
BEGIN
    -- Check if the barcode is too long. If this is the case, the subsequent LPAD step 
    -- will strip values from the right, leading to an incorrect (And potentially duplicable)
    -- barcode being uploaded. We never expect the cleaned barcode to be longer than 128 characters.
    IF char_length(v_clean_barcode) > 130 THEN
        RAISE EXCEPTION 'Please check barcode %s. Even after removing invalid characters, it is too long (Greater than 48 characters).', p_barcode;
    END IF;

    -- Pad the barcode to 130 characters long and make it upper case for consistency.
    v_clean_barcode := LPAD(UPPER(v_clean_barcode), 130, '0');

    -- Given a clean barcode, we now upsert the product.
    INSERT INTO dirac.product(name, description, barcode)
    VALUES(p_name, p_description, v_clean_barcode)
    ON CONFLICT (barcode) -- If the barcode already exists, we update the record.
    DO UPDATE SET
        name=EXCLUDED.name,
        description=EXCLUDED.description;
    
END$$ LANGUAGE plpgsql;

-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin

DROP PROCEDURE IF EXISTS dirac.ingest_product(VARCHAR, TEXT, VARCHAR);

-- +goose StatementEnd
