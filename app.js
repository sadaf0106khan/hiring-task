const express = require('express')
const pg = require('pg')

const app = express()
const port = process.env.port || 3000
const pool = new pg.Pool({
    user: 'ykxjqjnh',
    host: 'dumbo.db.elephantsql.com',
    database: 'ykxjqjnh',
    password: 'GrRQdIK8KbTjh5WwE5na3yX3qRrZO5XB',
    port: 5432
})

app.get('/q1', (req, res) => {
  pool.query('select * from customer where customer_id in(select cid from max_consecutive() where m>=3)',(err, result) => {
      if(err) throw err
      else res.status(200).json(result.rows)
  })  
})
app.get('/q2', (req, res) => {
    pool.query('select * from customer where customer_id in(select cid from max_consecutive() order by (m, c) desc limit 3)',(err, result) => {
        if(err) throw err
        else res.status(200).json(result.rows)
    })  
  })
app.listen(port,() => {
    console.log(`server is listening on ${port}`)
})