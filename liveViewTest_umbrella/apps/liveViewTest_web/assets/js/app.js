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
import * as UpChunk from "@mux/upchunk"

let Uploaders = {}

// Uploaders.S3 = function(entries, onViewError){
//     console.log("Uploader: ", entries);
//   entries.forEach(entry => {
//
//     let formData = new FormData()
//     let {entrypoint} = entry.meta
//
//     // Object.entries(fields).forEach(([key, val]) => formData.append(key, val))
//     formData.append("file", entry.file)
//     let xhr = new XMLHttpRequest()
//     onViewError(() => xhr.abort())
//     xhr.onload = () => xhr.status === 204 || entry.error()
//     xhr.onerror = () => entry.error()
//     xhr.upload.addEventListener("progress", (event) => {
//       if(event.lengthComputable){
//         let percent = Math.round((event.loaded / event.total) * 100)
//         entry.progress(percent)
//       }
//     })
//
//     xhr.open("POST", entrypoint, true)
//     xhr.send(formData)
//   })
// }
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

Uploaders.UpChunk = function(entries, onViewError){
  entries.forEach(entry => {
    // create the upload session with UpChunk
    console.log("entry: ", entry);
    let { file, meta: { entrypoint } } = entry
    console.log("Upchunk, entrypoint: ", entrypoint, "  ", typeof entrypoint)
    fetch("http://localhost:3000/" + entry.fileEl.id).then(resp => resp.json()).then((signedUrl) => {
        console.log("fetched, entrypoint: ", signedUrl, "  ", typeof signedUrl)
        let upload = UpChunk.createUpload({ endpoint: signedUrl, file })

        // stop uploading in the event of a view error
        onViewError(() => upload.pause())

        // upload error triggers LiveView error
        upload.on("error", (e) => entry.error(e.detail.message))

        // notify progress events to LiveView
        upload.on("progress", (e) => entry.progress(e.detail))
    })

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
