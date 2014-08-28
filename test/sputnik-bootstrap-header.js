$errCount = 0;
$ERROR = function (message) {
	console.log('ERROR: ' + message);
	$errCount++;
}

$PRINT = function (message) {}

var $start = Date.now()

