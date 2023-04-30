import os
from dotenv import load_dotenv
from google.oauth2 import service_account
from google.cloud import bigquery
import pyarrow.parquet as pq

load_dotenv()

try:
    GOOGLE_PROJECT_ID = os.environ["GOOGLE_PROJECT_ID"]
    GOOGLE_CLIENT_EMAIL = os.environ["GOOGLE_CLIENT_EMAIL"]
    GOOGLE_PRIVATE_KEY = os.environ["GOOGLE_PRIVATE_KEY"].replace('\\n', '\n')
except KeyError:
    raise Exception("Missing env var")

project_id = GOOGLE_PROJECT_ID

credentials = service_account.Credentials.from_service_account_info({
    "private_key": GOOGLE_PRIVATE_KEY,
    "client_email": GOOGLE_CLIENT_EMAIL,
    "token_uri": "https://oauth2.googleapis.com/token",
})

client = bigquery.Client(credentials=credentials, project=project_id)

with open("src/query.sql", "r") as f:
    sql = f.read()

arrow = client.query(sql).to_arrow(create_bqstorage_client=True)

parquet_path = "data/github-repos.parquet"
compression = "brotli" # This method results in smallest file size

pq.write_table(arrow, parquet_path, use_dictionary=True, compression=compression)

print("Rows: ", arrow.num_rows)
print(f"Arrow size: {arrow.nbytes} bytes")
print(f"Parquet file size: {os.path.getsize(parquet_path)} bytes")
