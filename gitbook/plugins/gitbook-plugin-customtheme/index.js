module.exports = {
  book: {
    assets: ".",
    js: [
    ],
    html: {
      "head:end": function(cur, b) {
        var config = this.options.pluginsConfig.customtheme || {js:[], css:[]};
        var updateElements;
        updateElements = '';
        var getPathHierarchy = function() {
          var temp = '';
          if (!cur._input) {
            return temp;
          }
          var depth = cur._input.split('/');
          for (var i = 0; i < depth.length - 1; i++) {
            temp += '../';
          }
          return temp;
        };
        var resolvePath = function(fileName) {
          var temp = fileName.replace('../', '');
          return  getPathHierarchy() + temp;
        };
        if (config.options && config.options.ignoreChooseLang && !cur._input && cur.langs) {
          	return updateElements;
        }
        if (config.js && config.js.length > 0) {
          for (var i in config.js) {
            if (config.js.hasOwnProperty(i)) {
              updateElements += '<script type="text/javascript" src="' + resolvePath(config.js[i]) + '"></script>';
            }
          }
        }
        if (config.css && config.css.length > 0) {
          var temp;
          for (var i in config.css) {
            if (config.css.hasOwnProperty(i)) {
              temp = config.css[i].replace('../', '');
              updateElements += '<link rel="stylesheet" type="text/css" href="' + resolvePath(temp) +'">';
            }
          }
        }
        return updateElements;
      }
    }
  }
};
