import Vue from "vue";
import Buefy from 'buefy'
import 'buefy/dist/buefy.css'

import './'
const ic = require("@dfinity/agent");

import { Ed25519KeyIdentity } from "@dfinity/authentication";
const { IDL, Principal } = ic;
const LOCAL_KEY_ID = "testKey";

import {
  HttpAgent,
  makeExpiryTransform,
  makeNonceTransform,
} from "@dfinity/agent";

let createLink = function (url) {
  var l = document.createElement('link')
  l.href = url;
  l.rel = 'stylesheet'
  return l;
}

document.head.appendChild(createLink('https://fonts.googleapis.com/css?family=Roboto:100,300,400,500,700,900'))
document.head.appendChild(createLink('https://cdn.jsdelivr.net/npm/@mdi/font@5.8.55/css/materialdesignicons.min.css'))

let renderApp = function () {
  const App = require("./App/App.vue").default;
  const State = require('./App/state.js');

  const _el = document.getElementById("vue_app");
  Vue.use(Buefy)

  const _app = new Vue({
    el: _el,
    components: {
      App,
    },
    render: (h) => h("App")
  });
}


if (!window.ic) {
  var keyIdentity = undefined;
  var keyMaybe = window.localStorage.getItem(LOCAL_KEY_ID);
  if (!keyMaybe) {
    const createRandomSeed = () => crypto.getRandomValues(new Uint8Array(32));
    keyIdentity = Ed25519KeyIdentity.generate(createRandomSeed());
    window.localStorage.setItem(LOCAL_KEY_ID, JSON.stringify(keyIdentity.toJSON()));
  } else {
    keyIdentity = Ed25519KeyIdentity.fromJSON(keyMaybe);
  }

  let agent = new HttpAgent({
    identity: keyIdentity,
  });

  agent.addTransform(makeNonceTransform());
  agent.addTransform(makeExpiryTransform(5 * 60 * 1000));

  window.ic = { agent, HttpAgent, IDL };
}

if (process.env.NODE_ENV === 'development') {
  if (!document.getElementById("vue_app")) {
    document.write('<div id="vue_app" style="height:100vh%;"></div>');
  }

  renderApp();

} else {
  const canisterAssets = require("ic:canisters/frontend").default;
  // use the asset canister's retrieve method to request a file (the `index.html` file from above)
  canisterAssets.retrieve("index.html").then((htmlBytes) => {
    // now that you have the html, decode it and create a new element
    const html = new TextDecoder().decode(new Uint8Array(htmlBytes));
    const el = new DOMParser().parseFromString(html, "text/html");
    // insert your HTML into the bootstrap HTML under the element with id `"app"`
    document.body.replaceChild(
      el.firstElementChild,
      document.getElementById("app")
    );

    renderApp();
  });
};

