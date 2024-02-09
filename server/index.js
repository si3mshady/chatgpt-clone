// export OPENAI_API_KEY=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
const express = require('express')
const {OpenAI} = require("openai")


const app = express()
port = 888

const openai = new OpenAI({
  organization: 'org-8esesGeqUvDcfmR62Dco9Bx5',
})


app.post('/', async (req,res) => {
    const completion = await openai.completions.create({
        model: "gpt-3.5-turbo-instruct",
        prompt: "What is water.",
        max_tokens: 99,
        temperature: 0,
      });
    
      console.log(completion);
      res.json({
        data: completion.choices[0].text
      })
})


app.listen(port, ()=> {
    console.log(`Server listening on port ${port}`)
})

