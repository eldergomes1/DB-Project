var express = require('express');
var router = express.Router();

//var users = require('../controllers/UserController.js');

router.get('/', function(req, res, next) 
{
  	res.send("user home");
});

/* GET users listing. */
/*
router.get('/', function(req, res, next) {
  res.send('respond with a resource');
});
*/

//router.get('/', users.login);
//router.get('/otravaina', users.f2);

module.exports = router;
