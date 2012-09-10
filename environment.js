'use strict';


//
// Require some modules
//


var UglifyJS  = require('uglify-js');
var Csso      = require('csso');
var Mincer    = require('mincer');


//
// Configure Mincers logger, by default, all
// messages are going to the middle of nowhere
//


Mincer.logger.use(console);


//
// Create and export environment
//


var environment = module.exports = new Mincer.Environment(__dirname);


//
// Configure environment load paths (where to find ssets)
//


environment.appendPath('../../app/assets/javascripts');
environment.appendPath('../../app/assets/stylesheets');
environment.appendPath('../../app/assets/images');
environment.appendPath('../../vendor/assets/javascripts');
environment.appendPath('../../vendor/assets/stylesheets');
environment.appendPath('../../vendor/assets/images');


//
// Define environment helper that will be available in the processed assets
// See `assets/stylesheets/app.css.ejs` for example of `asset_path` usage.
//


environment.registerHelper('asset_path', function (logicalPath) {
  var asset = environment.findAsset(logicalPath);

  if (!asset) {
    throw new Error("File " + logicalPath + " not found");
  }

  return '/assets/' + asset.digestPath;
});


//
// Set JS and CSS compressors
//

if ('production' === process.env.NODE_ENV) {
  //
  // In production we assume that assets are not changed between requests,
  // so we use cached version of environment. See API docs for details.
  //

  environment = environment.index;

  //
  // Enable JS and CSS compression
  //

  environment.jsCompressor = function (context, data, callback) {
    try {
      var ast = UglifyJS.parser.parse(data);

      ast = UglifyJS.uglify.ast_mangle(ast);
      ast = UglifyJS.uglify.ast_squeeze(ast);

      callback(null, UglifyJS.uglify.gen_code(ast));
    } catch (err) {
      callback(err);
    }
  };

  environment.cssCompressor = function (context, data, callback) {
    try {
      callback(null, Csso.justDoIt(data));
    } catch (err) {
      callback(err);
    }
  };
}

//
// "Th-th-th-that's all folks!"
