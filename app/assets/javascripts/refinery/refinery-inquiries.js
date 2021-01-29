import domReady from './ready'
domReady( () => {
  const triggerId = 'atttachments_trigger'
  console.log(document.readyState)

  let trigger = document.getElementById(triggerId)

  trigger && trigger.addEventListener('click', event => {
    event.preventDefault()
    let uploadId = event.target.dataset.targetId
    document.getElementById(uploadId).classList.remove('hidden')
  })
})

