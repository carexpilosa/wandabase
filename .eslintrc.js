const path = require('path');

module.exports = {
  "settings": {
    "import/resolver": { 
      "node" : {
        "paths": [path.resolve(__dirname)]
      }
    }
  },
  "env": {
    "browser": true,
    "es6": true
  },
  "extends": [
    "eslint:recommended",
    "plugin:react/recommended",
    "plugin:import/errors", 
    "plugin:import/warnings"
  ],
  "parserOptions": {
    "ecmaFeatures": {
      "experimentalObjectRestSpread": true,
      "jsx": true
    },
    "sourceType": "module"
  },
  "plugins": [
    "react",
    "import"
  ],
  "rules": {
    "indent": [
      "warn",
      2
    ],
    "no-console": [
      "off"
    ],
    "linebreak-style": [
      "error",
      "unix"
    ],
    "quotes": [
      "warn",
      "single"
    ],
    "semi": [
      "error",
      "always"
    ],
    "no-unused-vars": [
      "warn"
    ],
    "react/jsx-uses-vars": [
      "error"
    ],
    "camelcase": [
      2, {
        "properties": "always"
      }
    ],
    "react/prop-types": [
      "off"
    ]
  }
};