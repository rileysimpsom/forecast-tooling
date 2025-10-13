import pandas as pd
from scripts.ingest_data import schema

def test_schema_validation():
    df = pd.DataFrame([{
        "date": "2024-01-01",
        "sku_id": "SKU-1",
        "store_id": 101,
        "units_sold": 10,
        "price": 9.99,
        "promotion_flag": 1,
        "on_hand": 50
    }])
    validated = schema.validate(df)
    assert not validated.empty