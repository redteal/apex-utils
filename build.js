var build = require('sfdc-travisci-coveralls');

build({
  loginUrl: process.env.SFDC_LOGINURL,
  username: process.env.SFDC_USERNAME,
  password: process.env.SFDC_PASSWORD,
  securityToken: process.env.SFDC_TOKEN,
  travisJobId: process.env.TRAVIS_JOB_ID,
  coverallsRepoToken: process.env.COVERALLS_REPO_TOKEN,
  testLevel: 'RunSpecifiedTests',
  runTests: [
    'RT_AssertTest',
    'RT_UtilTest'
  ]
}, function (err) {
  console.error(err);
  process.exit(1);
}, function (data) {
  console.log('done.');
  process.exit(0);
});
