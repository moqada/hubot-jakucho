var coffeeCoverage = require('coffee-coverage');

var coverageVar = coffeeCoverage.findIstanbulVariable();
// Only write a coverage report if we're not running inside of Istanbul.
var writeOnExit = !coverageVar ? 'coverage/coverage-coffee.json' : null;


coffeeCoverage.register({
  instrumentor: 'istanbul',
  basePath: process.cwd(),
  exclude: ['index.coffee', '/test', '/node_modules', '/.git'],
  coverageVar: coverageVar,
  writeOnExit: writeOnExit,
  initAll: true
});
