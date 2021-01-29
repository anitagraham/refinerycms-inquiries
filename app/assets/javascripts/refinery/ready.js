const windowReady = (callback, options) => {
  window.addEventListener('load', () => {
    callback(options)
  })
}

const domReady = (callback, options) => {

  let ready = document.readyState === "interactive" || document.readyState === "complete"
  let msg = `calling ${callback}`;
  if (options) {
    msg +=` with ${options}`
  }
  if (ready) {
    callback(options)
  } else {
    document.addEventListener("DOMContentLoaded", () => {
      callback(options)
    })
  }
}
const turboReady = (callback) => {
  const callbackWithOptions = options => callback(options)
  document.addEventListener('turbolinks:load', callbackWithOptions, {once: true})
  document.addEventListener('turbolinks:render', callbackWithOptions);
}

export {turboReady, domReady, windowReady}
