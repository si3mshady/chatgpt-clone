from llama_index.core import SimpleDirectoryReader, StorageContext
from llama_index.core import VectorStoreIndex
from llama_index.vector_stores.postgres import PGVectorStore
from sqlalchemy import make_url
import psycopg2
import textwrap
import openai
import os 

openai.api_key = os.environ["OPENAI_API_KEY"]


documents = SimpleDirectoryReader("./superbowldata").load_data()
print("Document ID:", documents[0].doc_id)

connection_string = "postgresql://postgres:test@localhost:5432"

db_name = "vector_db1"
conn = psycopg2.connect(connection_string)
conn.autocommit = True

with conn.cursor() as c:
    print('connected to database')
    c.execute(f"DROP DATABASE IF EXISTS {db_name}")
    c.execute(f"CREATE DATABASE {db_name}")
    print('new database created')



########



url = make_url(connection_string)
vector_store = PGVectorStore.from_params(
    database=db_name,
    host=url.host,
    password=url.password,
    port=url.port,
    user=url.username,
    table_name="superbowldata",
    embed_dim=1536,  # openai embedding dimension
)

storage_context = StorageContext.from_defaults(vector_store=vector_store)
index = VectorStoreIndex.from_documents(
    documents, storage_context=storage_context, show_progress=True
)
query_engine = index.as_query_engine()

response = query_engine.query("Who won the super bowl")
print(response)