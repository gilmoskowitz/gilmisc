var fs = require('fs');

process.argv.forEach(function(val, index, ary) {
  if (index < 2)
    return;
  var buffer = fs.readFileSync(val, 'utf8')
    , data   = JSON.parse(buffer)
    ;
  
  data.forEach(function (val, index, ary) {
    var fields = [ val.name, val.default_branch, val.private, val.html_url, val.description ];
    console.log(fields.join('\t'));
  });
});
