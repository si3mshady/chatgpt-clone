from flask import Flask,request
from flask import jsonify
from flask_cors import CORS
from flask_restful import reqparse, abort, Api, Resource
from llama_index.core import SimpleDirectoryReader, StorageContext
from llama_index.core import VectorStoreIndex
from llama_index.vector_stores.postgres import PGVectorStore
from sqlalchemy import make_url
import psycopg2
import textwrap
import json 
import openai
import os 


from openai import OpenAI
client = OpenAI()

app = Flask(__name__)
# api = Api(app)
CORS(app)
# openai.api_key = os.environ["OPENAI_API_KEY"]

DATABASE_NAME = os.environ["DATABASE_NAME"]
DATABASE_PASSWORD = os.environ["DATABASE_PASSWORD"]
DB_CONTAINER_NAME = os.environ["DB_CONTAINER_NAME"]
DB_TABLE_NAME = os.environ["DB_TABLE_NAME"]
PORT = os.environ["PORT"]

def inint_connection():
    documents = SimpleDirectoryReader("./domain").load_data()
    print("Document ID:", documents[0].doc_id)

    connection_string = f"postgresql://postgres:{DATABASE_PASSWORD}@{DB_CONTAINER_NAME}:5432"

    db_name = DATABASE_NAME
    conn = psycopg2.connect(connection_string)
    conn.autocommit = True

    with conn.cursor() as c:
        print('connected to database')
        c.execute(f"DROP DATABASE IF EXISTS {db_name}")
        c.execute(f"CREATE DATABASE {db_name}")
        print('new database created')

    return connection_string, documents, db_name


connection_string, documents, db_name = inint_connection()
url = make_url(connection_string)
vector_store = PGVectorStore.from_params(
        database=db_name,
        host=url.host,
        password=url.password,
        port=url.port,
        user=url.username,
        table_name=DB_TABLE_NAME,
        embed_dim=1536,  # openai embedding dimension
    )
storage_context = StorageContext.from_defaults(vector_store=vector_store)
index = VectorStoreIndex.from_documents(  documents, storage_context=storage_context, show_progress=True )

########


def get_oai_response(message):
    res = client.chat.completions.create(
            model="gpt-3.5-turbo-0125",
            messages=[
                {"role": "user", "content": message}
            ]


            )

    return jsonify({"message": res.choices[0].message.content})
    




@app.route('/', methods=['POST'])
def submit_data():
    if request.method == 'POST':
        # Access the data from the POST request
        data = request.json  # Assuming the data is in JSON format
            

        query_engine = index.as_query_engine()


        message = data['message']

        engine_response = query_engine.query(message)

        print('This is the rag response -> ',engine_response)

        if "I'm sorry" not in str(engine_response):

            q = f"answer this question {message} using the following context {engine_response}"
            return get_oai_response(q)
        else:
            return(get_oai_response(message))

if __name__ == '__main__':
     app.run(host='0.0.0.0', port=PORT)




# curl -X POST -d '{"message":"hello world"}' -H "Content-Type: application/json" http://localhost:5000