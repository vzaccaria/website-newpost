#!/usr/bin/env node --harmony
// Generated by LiveScript 1.3.1
(function(){
  var docopt, lodash, moment, fs, $, __, co, shelljs, doc, exec, getOption, getOptions, main;
  docopt = require('docopt').docopt;
  lodash = require('lodash');
  moment = require('moment');
  fs = require('fs');
  $ = require('string');
  __ = require('bluebird');
  co = require('co');
  shelljs = require('shelljs');
  doc = shelljs.cat(__dirname + "/docs/usage.md");
  exec = __.promisify(shelljs.exec);
  getOption = function(a, b, def, o){
    if (!o[a] && !o[b]) {
      return def;
    } else {
      return o[b];
    }
  };
  getOptions = function(){
    var o, edit, publish, file, title, category;
    o = docopt(doc);
    edit = o['edit'];
    publish = o['publish'];
    file = o['FILE'];
    title = o['TITLE'];
    category = getOption('-c', '--category', 'infob', o);
    return {
      edit: edit,
      title: title,
      category: category,
      publish: publish,
      file: file
    };
  };
  main = function*(){
    var ref$, title, category, edit, file, filename, name, content, year, month, day, commands;
    ref$ = getOptions(), title = ref$.title, category = ref$.category, edit = ref$.edit, file = ref$.file;
    if (edit) {
      filename = $(title.toLowerCase()).dasherize() + ".md";
      name = moment().format("YYYY-MM-DD") + ("-" + filename);
      content = "---\ntitle: " + title + "\ndate: " + moment().format('YYYY-MM-DD') + "\n\nlayout: post\ncategory : " + category + "\ntags : ['']\n---";
      year = moment().format('YYYY');
      month = moment().format('MM');
      day = moment().format('DD');
      yield exec("mkdir -p _drafts");
      content.to("_drafts/" + name);
      commands = [exec("open _drafts/" + name + " -a 'MacDown'")];
      yield commands;
    } else {
      commands = [exec("cp " + file + " _posts"), exec("git add _posts"), exec("git commit -m 'publish post'")];
      yield commands;
    }
  };
  co(main).then(function(){
    return console.log("done.");
  });
}).call(this);
