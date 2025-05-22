const path = require("path");

module.exports = {
  entry: "./index.js",
  output: {
    path: path.resolve(__dirname, ".."),
    filename: "./n39calendar.js",
    libraryTarget: "var",
    library: "N39Calendar",
  },
};
