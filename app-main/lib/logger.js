'use strict';

var log4js = require('log4js')
  , logger = log4js.getLogger()
  , util   = require('util');

function prettyJSON(json) {
  return JSON.stringify(json, null, 4);
}

function debug() {
  logger.debug(util.format.apply(util, arguments));
}

function info() {
  logger.info(util.format.apply(util, arguments));
}

function warn() {
  logger.warn(util.format.apply(util, arguments));
}

function error() {
  logger.error(util.format.apply(util, arguments));
}

function fatal() {
  logger.fatal(util.format.apply(util, arguments));
}

module.exports = {
  prettyJSON: prettyJSON,
  debug:      debug,
  info:       info,
  warn:       warn,
  error:      error,
  fatal:      fatal
};
