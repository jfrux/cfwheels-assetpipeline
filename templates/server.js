'use strict';


//
// Require some modules
//


var fs      = require('fs');
var connect = require('connect');
var Mincer  = require('mincer');


//
// Get Mincer environment
//


var environment = require('./environment');

console.log(environment);
//
// Create connect application
//


var app = connect();


//
// Fix NODE_ENV environment variable
//


process.env.NODE_ENV = process.env.NODE_ENV || 'development';

console.log(process.env.NODE_ENV);
//
// Attach assets server
//

app.use('/assets/', Mincer.createServer(environment));

//
// Prepare HTML layout for our dummy application
// See `views/layout.jade` for example of `javascript` and `stylesheet` usage.
//

//
// Define some view helpers
//

//
// Attach some dummy handler, that simply renders layout
//

app.use(function (req, res, next) {
  // make sure our assets were compiled, so their `digestPath`
  // will be 100% correct, otherwise first request will produce
  // wrong digestPath. That's not a big deal, as assets will be
  // served anyway, but to keep everything correct, we use this
  // precompilation, which is similar to using manifest, but
  // without writing files on disk.
  //
  // See [[Base#precompile]] for details,
  environment.precompile(['application.js', 'application.css'], function (err) {
    if (err) {
      next(err);
      return;
    }
  });
});


//
// Start listening
//
app.listen(3000, function (err) {
  if (err) {
    console.error("Failed start server: " + (err.message || err.toString()));
    process.exit(128);
  }

  console.info('Listening on localhost:3000');
});
