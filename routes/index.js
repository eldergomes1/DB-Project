var express = require('express');
var router = express.Router();
var Campaign = require('../controllers/CampaignController');
var User = require('../controllers/UserController');

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

router.get('/login', User.loginGet);
router.post('/login', User.loginPost);
router.post('/logout', User.logout);
router.get('/usuario', User.findAll);
router.get('/usuario/create', User.createGet);
router.post('/usuario/create', User.createPost);

router.get('/campana/create',Campaign.createGet);
router.post('/campana/create', Campaign.createPost);
router.get('/campana', Campaign.findAll);
router.get('/campana/:id', Campaign.find);
router.get('/campana/:id/edit', Campaign.addProductsGet);

module.exports = router;
