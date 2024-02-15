


from openai import OpenAI
client = OpenAI()



res = client.chat.completions.create(
    model="gpt-3.5-turbo",
    messages=[
        {"role": "assistant", "content": "the saints won the super bowk"},
        {"role": "user", "content": "who won the super bowl"}
    ]


    )

print(res.choices[0].message.content)