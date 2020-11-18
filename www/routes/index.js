var debug = require('debug')('myapp:routes/index.js');
var express = require('express');
var router = express.Router();

router.get('/', function(req, res, next) {
    res.render('index', {
    });
});

router.get('/done', function(req, res, next) {
    res.render('done', {
    });
});


// router.get('/2', function(req, res, next) {
//     res.render('page1', {
//         title: 'page 2',
//         prev_link : true,
//         next_link : true,
//         prev : '',
//         next : '3'
//     });
// });

// router.get('/3', function(req, res, next) {
//     res.render('page1', {
//         title: 'page 3',
//         prev_link : true,
//         next_link : false,
//         prev : '2',
//         next : null
//     });
// });

module.exports = router;
