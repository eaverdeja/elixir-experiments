//https://elixirforum.com/t/phoenix-1-4-0-rc1-webpack-bootstrap-4/17354/3
const Webpack = require('webpack');
const path = require('path');
const glob = require('glob');

const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const UglifyJsPlugin = require('uglifyjs-webpack-plugin');
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

const VENDOR_LIBS = [
  'jquery', 'popper.js'
]

module.exports = (env, options) => ({
  optimization: {
    minimizer: [
      new UglifyJsPlugin({ cache: true, parallel: true, sourceMap: false }),
      new OptimizeCSSAssetsPlugin({}),
    ]
  },
  entry: {
    './js/app.js': VENDOR_LIBS.concat(['./js/app.js']).concat(glob.sync('./vendor/**/*.js')),
  },
  output: {
    filename: 'js/[name].js',
    path: path.resolve(__dirname, '../priv/static/js'),
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',
        }
      },
      {
        test: /\.(scss|css)$/,
        use: [MiniCssExtractPlugin.loader, 'css-loader', 'sass-loader'],
      },
      // Load images
      {
        test: /\.(png|svg|jpg|gif)(\?.*$|$)/,
        loader: 'url-loader?limit=10000',
      },
      // Load fonts
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?(\?.*$|$)/,
        use: 'url-loader?&limit=10000&name=/fonts/[name].[ext]',
      },
      {
        test: /\.(eot|ttf|otf)?(\?.*$|$)/,
        loader: 'file-loader?&limit=10000&name=/fonts/[name].[ext]',
      },
    ]
  },
  plugins: [
    new MiniCssExtractPlugin({ filename: './css/app.css' }),
    new CopyWebpackPlugin([{ from: 'static/', to: './' }]),
    
    new Webpack.ProvidePlugin({ // inject ES5 modules as global vars
      $: 'jquery',
      jQuery: 'jquery', 'window.jQuery': 'jquery',
      Popper: ['popper.js', 'default'],
    }),
  ],
  optimization: {
    // https://github.com/webpack/webpack/issues/6357
    splitChunks: {
      cacheGroups: {
        vendor: {
          test: /jquery|webpack-jquery-ui|popper|font-awesome/,
          chunks: "initial",
          name: "vendor",
          enforce: true
        }
      }
    },
    minimizer: [
      new UglifyJsPlugin({ cache: true, parallel: true, sourceMap: false }),
      new OptimizeCSSAssetsPlugin({})
    ],
  },
});
