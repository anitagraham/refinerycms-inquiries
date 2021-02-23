const path = require('path');
const paths = require('./paths')

module.exports = {
  mode: 'development',
  entry: path.join(paths.Src, 'inquiries.js'),
  output: {
    filename: 'inquiries.js',
    path: paths.Root,
  },
  resolve: {
    alias: {
      Vendor: paths.Vendor
    },
    extensions: ['*', '.js']
  },
  module: {
    rules: [
      {
        test: /\.(js)$/,
        exclude: /node_modules/,
        use: ['babel-loader']
      },
      {
        test: /\.css/,
        sideEffects: true,
        use: [
          'style-loader',
          'css-loader'
        ]
      }
    ]
  }
}
