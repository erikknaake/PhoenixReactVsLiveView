// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import {Socket} from "phoenix"
import NProgress from "nprogress"
import {LiveSocket} from "phoenix_live_view"

let Uploaders = {}

Uploaders.S3 = function(entries, onViewError){
  entries.forEach(entry => {
    console.log("entry: ", entry);
    let formData = new FormData()
    let {url, fields} = entry.meta
    console.log("fields: ", fields)
    Object.entries(fields).forEach(([key, val]) => formData.append(key, val))
    formData.append("file", entry.file)
    console.log("form data: ", formData);
    let xhr = new XMLHttpRequest()
    onViewError(() => xhr.abort())
    xhr.onload = () => xhr.status === 204 || entry.error()
    xhr.onerror = () => entry.error()
    xhr.upload.addEventListener("progress", (event) => {
      if(event.lengthComputable){
        let percent = Math.round((event.loaded / event.total) * 100)
        entry.progress(percent)
      }
    })

    xhr.open("POST", url, true)
    xhr.send(formData)
  })
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  uploaders: Uploaders,
  params: {_csrf_token: csrfToken}
})


// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", info => NProgress.start())
window.addEventListener("phx:page-loading-stop", info => NProgress.done())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
window.liveSocket = liveSocket
