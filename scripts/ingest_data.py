import pandas as pd
import pandera as pa
from pandera import Column, DataFrameSchema, Check
from sqlalchemy import create_engine

# Define schema
schema = DataFrameSchema({
    "date": Column(pa.DateTime, nullable=False),
    "sku_id": Column(str, nullable=False),
    "store_id": Column(int, Check.ge(0), nullable=False),
    "units_sold": Column(int, Check.ge(0), nullable=False),
    "price": Column(float, Check.ge(0), nullable=False),
    "promotion_flag": Column(int, Check.isin([0, 1]), nullable=False),
    "on_hand": Column(int, Check.ge(0), nullable=False),
})

# Load CSV
df = pd.read_csv("data/sales_history.csv", parse_dates=["date"])

# Validate
validated = schema.validate(df)

# Connect to Postgres
engine = create_engine("postgresql+psycopg2://forecast:forecast@localhost:5432/forecastdb")

# Write to table (replace with append if you want incremental loads)
validated.to_sql("sales", engine, if_exists="replace", index=False)

print(f"Ingested {len(validated)} rows into Postgres")