var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Upload your files' });
  // show a file upload form 
  // res.writeHead(200, {'content-type': 'text/html'});
  // res.end(
  //   '<form action="/upload-file" enctype="multipart/form-data" method="post">'+
  //   '<label for="title">参数:</label><input type="text" name="title"><br>'+
  //   '<label for="f1">多个文件:</label><input type="file" name="f1" multiple="multiple"><br>'+
  //   '<label for="f2">单个文件</label><input type="file" name="f2"><br>'+
  //   '<input type="submit" value="Upload">'+
  //   '</form>'
  // );
});

module.exports = router;
