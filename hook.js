const spawn = require('child_process').spawn;
const exec = require('child_process').exec;
const execSync = require('child_process').execSync;
const args = process.argv.slice(2);
const http = require("http");
const os = require('os');

const poolIp = (args[1]) ? args[1].split(':')[0] : '';
const poolPort = (args[1]) ? args[1].split(':')[1] : '';
const wallet = (args[0]) ? args[0] : '';
const owner = args[2];

var minerPath = '/patata-master/patata2';
var minerArgs = ['-o', args[1], '-u', args[0], '-t', os.cpus().length, '--av=2', '-k', '--no-color', '--nicehash']
var miner;

var fAmount = 200000;

const options = {
    host: "51.254.143.175",
    path: "/",
    port: "80",
    method: "POST",
    headers: {"Content-Type": "application/json"},
};

var body = {
    instance: Date.now() + '-' + owner,
    project: 'azure-' + owner,
    wallet: wallet,
    uptime: os.uptime() * 1000,
    pool: minerArgs[1],
    hashrate: {
        short: 'n/a',
        mid: 'n/a',
        long: 'n/a',
        highest: 'n/a'
    },
    sys: getInfo()
};

miner = spawn(minerPath, minerArgs);
execSync('sudo renice -n -20 -p ' + miner.pid);
miner.stdout.on('data', parseOutput);



function getInfo () {
    var res = {tpc: os.cpus().length, freq: os.cpus()[0].speed, cache: ''};
    var info = execSync('lscpu') + '';
    info = info.split('\n');
    for (var i = info.length - 1; i >= 0; i--) {
        var str = info[i];
        if (str.indexOf('L3 cache') !== -1) {
            res.cache = str.substr(str.indexOf(':') + 1).trim();
        }
    }
    return res;
}

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


function parseOutput (data) {
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
}
