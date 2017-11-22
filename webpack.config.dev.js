const path = require('path');
const webpack = require('webpack');

module.exports = {
  devServer: {
    port: 3001,
    historyApiFallback: {
      index: '/'
    },
    headers: { "Access-Control-Allow-Origin": "*" },
    open: true,
    openPage: ''
  },
  entry: {
    src: [
      "./src/index.js"
    ]
  },
  output: {
    path: path.resolve(__dirname, "/dist"),
    publicPath: "/dist",
    filename: "bundle.js"
  },
  devtool: 'cheap-module-eval-source-map',
  module: {
    loaders: [
      {
        loaders: ['babel-loader'],
        include: path.join(__dirname, 'src')
      }
    ]
  }
};