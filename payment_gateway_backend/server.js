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
app.use(function (req, res, next) {
    //Enabling CORS
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Methods", "GET,HEAD,OPTIONS,POST,PUT");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept, x-client-key, x-client-token, x-client-secret, Authorization");
    next();
    });
app.use(routes);
