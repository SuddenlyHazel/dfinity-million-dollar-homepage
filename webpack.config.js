const path = require("path");
const TerserPlugin = require("terser-webpack-plugin");
const { VueLoaderPlugin } = require("vue-loader");
const dfxJson = require("./dfx.json");
const HtmlWebpackPlugin = require('html-webpack-plugin');

// List of all aliases for canisters. This creates the module alias for
// the `import ... from "ic:canisters/xyz"` where xyz is the name of a
// canister.
const aliases = Object.entries(dfxJson.canisters).reduce(
  (acc, [name, _value]) => {
    // Get the network name, or `local` by default.
    const networkName = process.env["DFX_NETWORK"] || "local";
    const outputRoot = path.join(
      __dirname,
      ".dfx",
      networkName,
      "canisters",
      name
    );

    return {
      ...acc,
      ["ic:canisters/" + name]: path.join(outputRoot, name + ".js"),
      ["ic:idl/" + name]: path.join(outputRoot, name + ".did.js"),
    };
  },
  {}
);

/**
 * Generate a webpack configuration for a canister.
 */
function generateWebpackConfigForCanister(name, info) {
  if (typeof info.frontend !== "object") {
    return;
  }

  return {
    mode: "production",
    entry: {
      index: path.join(__dirname, info.frontend.entrypoint),
    },
    devtool: undefined,
    optimization: {
      minimize: true,
      minimizer: [new TerserPlugin()],
    },
    resolve: {
      alias: aliases,
    },
    output: {
      filename: "[name].js",
      path: path.join(__dirname, "dist", name),
    },

    module: {
      rules: [
        {
          test: /\.vue$/,
          loader: "vue-loader",
        },
        {
          test: /\.js$/,
          loader: "babel-loader",
        },
        {
          test: /\.wasm$/,
          loaders: ['wasm-loader'],
          type: "javascript/auto"
        },
        { test: /\.css$/, use: [
          'style-loader',
          'css-loader'
        ] },
      ],
    },

    plugins: [new VueLoaderPlugin(), new HtmlWebpackPlugin()],

    devServer: {
      proxy: {
        "/api": `http://${dfxJson.networks.local.bind}`,
      },
    },
  };
}

// If you have additional webpack configurations you want to build
//  as part of this configuration, add them to the section below.
module.exports = [
  ...Object.entries(dfxJson.canisters)
    .map(([name, info]) => {
      return generateWebpackConfigForCanister(name, info);
    })
    .filter((x) => !!x),
];
