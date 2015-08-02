var express = require('express');
var bodyParser = require('body-parser');
var app = express();

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({
  extended: true
}));

app.post('/temperature', function(req, res) {
  console.log("Temperature reçue ! -> ", req.body.temperature_value);
});

app.listen(4242);
