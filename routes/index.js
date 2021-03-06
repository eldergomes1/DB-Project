var express = require('express');
var router = express.Router();
var Campaign = require('../controllers/CampaignController');
var User = require('../controllers/UserController');
var Order = require('../controllers/OrderController');

/* GET home page. */
router.get('/', function(req, res, next) {
  // res.render('index', { title: 'Express' });
  res.redirect("/login");
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
router.post('/campana/:id/edit', Campaign.addProductsPost);
router.get('/donar', Order.index);
router.post('/donar', Order.donar);
// router.get('/ordenes', Order.getOrders);
router.get('/ordenes', Order.details);
router.get('/ordenes/:idcampana', Order.orders);

module.exports = router;
