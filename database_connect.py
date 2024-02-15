from flask import Flask,request
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
api = Api(app)
CORS(app)
# openai.api_key = os.environ["OPENAI_API_KEY"]

def inint_connection():
    documents = SimpleDirectoryReader("./superbowldata").load_data()
    print("Document ID:", documents[0].doc_id)

    connection_string = "postgresql://postgres:test@localhost:5432"

    db_name = "vector_db2"
    conn = psycopg2.connect(connection_string)
    conn.autocommit = True

    with conn.cursor() as c:
        print('connected to database')
        c.execute(f"DROP DATABASE IF EXISTS {db_name}")
        c.execute(f"CREATE DATABASE {db_name}")
        print('new database created')

    return connection_string, documents, db_name



########


def get_oai_response(context, message):
    res = client.chat.completions.create(
            model="gpt-3.5-turbo",
            response_format={ "type": "json_object" },
            messages=[
                {"role": "assistant", "content": context},
                {"role": "user", "content": message}
            ]


            )
    print(res)
    return res.choices[0].message.content





class VectorSearch(Resource):
    

    def post(self):
        connection_string, documents, db_name = inint_connection()
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

        # response = query_engine.query("Who won the super bowl")
        # print(response)

        data = request.get_json()
        message = data['message']

        engine_response = query_engine.query(message)
        # print(engine_response)

        


        return {
                "message": get_oai_response(engine_response,message)
            } 

            # res.choices[0].text)




##
## Actually setup the Api resource routing here
##
api.add_resource(VectorSearch, '/')


if __name__ == '__main__':
    app.run()




# curl -X POST -d '{"message":"hello world"}' -H "Content-Type: application/json" http://localhost:5000