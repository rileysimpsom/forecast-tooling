# Data Schema

This document defines the canonical schema for the forecasting tool’s sales dataset.  
All ingestion and validation steps must conform to this schema.

| Column         | Type    | Constraints / Notes                          |
|----------------|---------|----------------------------------------------|
| date           | date    | Daily granularity, not null                  |
| sku_id         | string  | Unique product identifier, not null          |
| store_id       | int     | Store identifier, >= 0                       |
| units_sold     | int     | Units sold that day, >= 0                    |
| price          | float   | Unit price in USD, >= 0                      |
| promotion_flag | int     | 0 = no promo, 1 = promo active               |
| on_hand        | int     | Inventory on hand at end of day, >= 0        |

---

## Notes

- **date**: Should be timezone‑agnostic (UTC recommended).  
- **sku_id**: String identifier for each product. Together with `store_id`, forms a composite key for uniqueness.  
- **store_id**