# Project Setup

This project uses **PostgreSQL**.

---

## Environment Setup

It is recommended to use **uv** to manage dependencies. From the `it5008_project` directory, run:

```bash
uv venv .venv
uv sync
Alternatively, you may use pip or Poetry.
```

## Running `process.py`

To run the script, provide the filename as an argument. An optional second argument can specify the number of rows to process.

```bash
cd it5008_project/

# Process entire menu.csv:
python process.py menu.csv

# Process first 50 rows of order.csv:
python process.py order.csv 50

# Process first 10 rows of staff.csv:
python process.py staff.csv 10
```

## Database Setup

Before inserting order data, ensure that prerequisite tables are populated. Follow the sequence specified in `Insert_Sequence.md` to correctly populate the `cuisine`, `menu`, `staff`, and `staff_cuisine` tables.

## Verification

After inserting the first 100 rows from order.csv, you can verify the total count by running the following SQL query:

```SQL
SELECT COUNT(*) AS total_orders FROM orders;
```

## Submission

project_x_sub folders will only contain the final submission.
