from llama_index.core import SimpleDirectoryReader, StorageContext
from llama_index.core import VectorStoreIndex
from llama_index.vector_stores.postgres import PGVectorStore
import textwrap
import openai
import os 

openai.api_key = os.environ["OPENAI_API_KEY"]


documents = SimpleDirectoryReader("./superbowldata").load_data()
print("Document ID:", documents[0].doc_id)