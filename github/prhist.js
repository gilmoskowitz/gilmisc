var fs = require('fs');

process.argv.forEach(function(val, index, ary) {
  if (index < 2)
    return;
  var buffer = fs.readFileSync(val, 'utf8')
    , data   = JSON.parse(buffer)
    ;

  data.forEach(function (val, index, ary) {
    var fields = [ val.base.repo.name, val.number, val.user.login, val.created_at, val.merged_at, val.title ];
    console.log(fields.join('\t'));
  });
});
