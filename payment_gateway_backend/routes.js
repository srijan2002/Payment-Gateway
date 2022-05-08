const express=require('express');
const routes=express.Router();
const Controllers=require('./Controllers/controllers');

routes.post('/order',Controllers.getOrderId);
routes.use(Controllers.Err);
module.exports=routes;