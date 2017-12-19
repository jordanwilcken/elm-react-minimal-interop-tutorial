var path = require('path');

var BUILD_DIR = path.resolve(__dirname, 'build');
var APP_DIR = path.resolve(__dirname);

var config = {
  entry: APP_DIR + '/index.jsx',

  resolve: {
    modules: ['node_modules'],
    extensions: ['*', '.js', '.elm']
  },

  module : {
    loaders : [
      {
        test : /\.jsx?/,
        include : APP_DIR,
        exclude: [/elm-stuff/, /node_modules/],
        loader : 'babel-loader'
      },
      {
        test: /\.html$/,
        loader: "html"
      },
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: 'elm-webpack-loader'
      }
    ],

    noParse: /\.elm$/
  },
  output: {
    path: BUILD_DIR,
    filename: 'bundle.js'
  }
};

module.exports = config;
