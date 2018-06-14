#!/usr/bin/env node

// Test Plugin for Cronicle
var js = require('fs');
var JSONStream = require('pixl-json-stream');
var Logger = require('pixl-logger');
var Tools = require('pixl-tools');
var Perf = require('pixl-perf');
var client = require('scp2');
var perf = new Perf();
perf.setScale( 1 ); // seconds
perf.begin();

// setup stdin / stdout streams 
process.stdin.setEncoding('utf8');
process.stdout.setEncoding('utf8');

console.warn("Printed this with console.warn, should go to stderr, and thus straight to our logfile.");
console.log("Printed this with console.log, should be ignored as not json, and also end up in our logfile.");

if (process.argv.length > 2) console.log("ARGV: " + JSON.stringify(process.argv));

/*process.on('SIGTERM', function() {
	console.warn("Caught SIGTERM and ignoring it!  Hahahahaha!");
} );*/

var stream = new JSONStream( process.stdin, process.stdout );

stream.on('json', function(job) {
	// got job from parent
	var params = job.params;
	
	var print = function(text) {
		fs.appendFileSync( job.log_file, text );
	};
	
	print("Sending file to host " + params.targethost + "  file:\n" + params.filepath + "\n");
	
	client.scp(params.filepath, {
	    host: params.targethost,
	    username:params.username,
	    password:params.password,
	    path: params.targetfilepath
	}, function(err) {
		console.log("File copy faild");
		print("Sending file to host " + params.targethost + " failed file" + params.filepath + "\n");
	})
	print("Sending file to host " + params.targethost + "file copies" + params.filepath + "\n");
	console.log("File copy sucess");
});