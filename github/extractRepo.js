var repo  = require('./github.1'),
    repo2 = require('./github.2'),
    summary = [];

//console.log(repo.length + ' ' + repo2.length);
//console.log('===========================')

repo = repo.concat(repo2);

//console.log(repo.length);
//console.log('===========================')

repo.forEach(function (e) {
//  console.log(e.name);
  summary.push({ name: e.name,
                 private: e.private,
                 url:  e.html_url,
                 desc: e.description });
});
//console.log('===========================')

summary = summary.sort(function (a, b) {
//  console.log(a.name + ' ' + b.name);
  if (a.name < b.name)      return -1;
  else if (a.name > b.name) return 1;
  else                      return 0;
});

//console.log('===========================')
summary.forEach(function (e) {
  var ary = [e.name, e.private, e.url, e.desc]
  console.log(ary.join('\t'));
});
