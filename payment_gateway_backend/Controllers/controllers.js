const Razorpay = require('razorpay');
const getOrderId = async(req,res)=>{
    const {key,secret,amount}=req.body;
    console.log(key);
    console.log(secret);
    // console.log(req.body);

    var instance = new Razorpay({ key_id: key, key_secret: secret })

   var response =  instance.orders.create({
      amount: amount,
      currency: "INR",
      receipt: "receipt#1",
      notes: {
        key1: "value3",
        key2: "value2"
      }
    }, function(err,order){
      console.log(order);
      if(order!=null)
      res.send(order.id);
      else
      res.status(401).send("INVALID AUTH");
    });
   

   
}

const Err = (req,res)=>{
    res.status(404).send("invalid_request");
}

module.exports={
    getOrderId, Err
}