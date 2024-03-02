const express = require('express')
const {OpenAI} = require("openai")


const app = express()
const port = 888

const bodyParser = require('body-parser')
const cors = require('cors')
app.use(bodyParser.json())
app.use(cors())


const openai = new OpenAI({
  organization: 'org-8esesGeqUvDcfmR62Dco9Bx5',
})


app.post('/', async (req,res) => {
    const {message} = req.body
    console.log(message)
    const completion = await openai.completions.create({
        model: "gpt-3.5-turbo-instruct",
        prompt: `${message}`,
        max_tokens: 99,
        temperature: 0,
      });
    
    
    res.json({
        message: completion.choices[0].text
    })
})


app.listen(port, ()=> {
    console.log(`Server listening on port ${port}`)
})

