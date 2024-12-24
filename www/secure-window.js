var exec = require('cordova/exec');

exports.makeSecure = function (success, error) {
    exec(success, error, "SecureWindow", "makeSecure", []);
};
