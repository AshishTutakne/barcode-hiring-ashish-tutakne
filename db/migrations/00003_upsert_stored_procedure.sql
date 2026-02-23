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
    -- Normalize the barcode.
    -- The normalization is done by removing all non numeric, letter or "^" characters, 
    -- as these are the only characters we expect to see in a barcode. We then add
    -- leading zeros to pad it to 50 digits long. This allows us to normalize barcodes
    -- of different formats, such as EAN-13, UPC-A, etc. The data limit of a code 128
    -- barcode is 48 charactsr, making 50 sufficient. We also set the barcode to be 
    -- uppercase to ensure consistency.
    v_clean_barcode := UPPER(REGEXP_REPLACE(p_barcode, '[^a-zA-Z0-9]', '', 'g'));
    
    -- Check if the barcode is too long. If this is the case, the subsequent LPAD step 
    -- will strip values from the right, leading to an incorrect (And potentially duplicable)
    -- barcode being uploaded. We never expect the cleaned barcode to be longer than 48 characters.
    IF char_length(v_clean_barcode) > 50 THEN
        RAISE EXCEPTION 'Please check barcode %s. Even after removing invalid characters, it is too long (Greater than 48 characters).', p_barcode;
    END IF;

    -- Pad the barcode to 50 digits long.
    v_clean_barcode := LPAD(v_clean_barcode, 50, '0');

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
