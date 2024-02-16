


from openai import OpenAI
client = OpenAI()



res = client.chat.completions.create(
    model="gpt-3.5-turbo-0125",
    messages=[
        {"role":"system", "content": "use the assistant response to provide context for the answer" },
        {"role": "assistant", "content": "the saints won the super bowl in 2024"},
        {"role": "user", "content": "who won the super bowl in 2024"}
    ]


    )

print(res.choices[0].message.content)