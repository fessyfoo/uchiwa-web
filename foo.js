'use strict';
var PEG    = require('pegjs'),
    fs     = require('fs'),
    util   = require('util'),
    colors = require('colors'); // jshint ignore:line

function error(err) {
  console.log(
    'ERROR:'.red,
    util.inspect(err, {depth: null, colors: true}
  ));
}

function parseSample(parser) {
  var sampleFile = 'sample.search',
  result;

  // if (err) { return console.log(err); }
  fs.readFile(sampleFile, function (err, data) {
    if (err) { return console.log(err); }
    try {
      result = parser.parse(data.toString());
    } catch(e) {
      error(e);
    }
    console.log(util.inspect(result, {depth: null, colors: true}));
  });
}

function doParse(msg) {
  if (msg) {
    console.log(msg.blue);
  }

  fs.readFile('search.pegjs', 'utf8', function(err, pegjs) {
    var parser;

    if (err) { return console.log(err); }
    try {
      parser = PEG.buildParser(pegjs);
      parseSample(parser);
    } catch (e) {
      error(e);
    }
  });
}

function watch() {
  fs.watch('.', function( event, filename) {
    // console.log('event: ', event, filename);

    if (filename.match(/\.(pegjs|js|search)$/) && filename !== 'foo.js') {
      doParse(filename);
    }
  });
}

doParse('starting...');
watch();
