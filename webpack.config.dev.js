const path = require('path');
const webpack = require('webpack');

module.exports = {
  devServer: {
    port: 4040,
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
      { test: /\.css$/, loaders: ['style-loader', 'css-loader'] },
      {
        include: path.join(__dirname, 'src'),
        loaders: ['babel-loader', 'eslint-loader']
      }
    ]
  }
};