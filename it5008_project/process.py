import csv
import os
import sys

def read_csv(csvfilename, num_rows=100):
    """
    Read .csv file with path verification and row limit
    - file: the .csv file with the full path
    - num_rows: number of rows to process (default 100)
    """
    try:
        print(f"Current working directory: {os.getcwd()}")
        print(f"Attempting to open: {csvfilename}")
        print(f"File exists: {os.path.exists(csvfilename)}")
        
        rows = []
        with open(csvfilename, encoding='utf-8') as csvfile:
            file_reader = csv.reader(csvfile)
            header = next(file_reader)  # Skip header
            for i, row in enumerate(file_reader):
                if i >= num_rows:
                    break
                rows.append(row)
        return rows
    except FileNotFoundError as e:
        print(f"Error: File not found - {e}")
        return []

# Get command line arguments for filename and number of rows
if len(sys.argv) < 2:
    print("Usage: python process.py <csv_filename> [num_rows]")
    sys.exit(1)

csv_filename = sys.argv[1]
row_limit = int(sys.argv[2]) if len(sys.argv) > 2 else 100

# Fix the path using correct directory structure
script_dir = os.path.dirname(os.path.abspath(__file__))
csv_path = os.path.join(script_dir, csv_filename)

print(f"Full path being used: {csv_path}")
table_name = os.path.splitext(csv_filename)[0].lower()
for row in read_csv(csv_path, row_limit):
    print(f"""INSERT INTO {table_name} VALUES ('{"', '".join(row)}');""")