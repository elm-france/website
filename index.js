import hljs from "highlight.js/lib/highlight";
import "highlight.js/styles/github.css";
import elm from 'highlight.js/lib/languages/elm';
hljs.registerLanguage('elm', elm);


import "./style.css";
// @ts-ignore
window.hljs = hljs;
const { Elm } = require("./src/Main.elm");
const pagesInit = require("elm-pages");

pagesInit({
  mainElmModule: Elm.Main
}).then(app => {
  window.jsonpCallback = function(data) {
    app.ports.jsonpCallback.send(data);
  };
  app.ports.execJsonp.subscribe(execJsonp);
});


function execJsonp(url) {
  const script = document.createElement('script');
  script.type = 'text/javascript';
  script.async = true;
  script.src = url;

  const tag = document.getElementsByTagName('script')[0];
  tag.parentNode.insertBefore(script, tag);
  script.parentNode.removeChild(script);
}
