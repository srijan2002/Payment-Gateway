const express = require('express');
const app = express();
const routes = require('./routes');
const morgan = require('morgan');
let port = process.env.PORT || 3000;

app.set('view engine','ejs');
app.use(morgan('dev'));
app.use(express.json());
app.use(express.urlencoded({extended:true}));
app.listen(port);
console.log(`http://localhost:${port}`);
app.use(routes);
