import Uppy from '@uppy/core'
import Dashboard from '@uppy/dashboard'
import ActiveStorageUpload from '@excid3/uppy-activestorage-upload'
import Mustache from 'mustache'
//
import uploadTemplate from './uploads.mustache'

// And their styles (for UI plugins)
import '@uppy/core/src/style.scss'
import '@uppy/dashboard/src/style.scss'
import './inquiriesUppy.scss'

// some litte things
const notEmpty = ar => (Array.isArray(ar) && ar.length)
const emptyArray = ar => !notEmpty(ar)
const getMeta = name =>  document.querySelector(`meta[name="${name}"]`).getAttribute("content")

const setupUppy = trigger => {
  // 1. get the defining parts of this
  let form = trigger.closest('form')
  let element = document.getElementById('uppy')
  let fieldName = element.dataset.fieldName

  // 2. set up some configuration for uppy, including info stored in the <head> just for uppy.
  const uppyOptions = () =>( {
    autoProceed: false,
    allowMultipleUploads: true,
    restrictions: {
      maxFileSize: getMeta('inquiry-condition-max-size'),
      maxTotalFileSize: null,
      maxNumberOfFiles: getMeta('inquiry-condition-max-files'),
      minNumberOfFiles: 0,
      allowedFileTypes: getMeta('inquiry-condition-permitted-types').split(' '),
      infoTimeout: 5000
    }
  })

  const activeStorageOptions = {
    target: element,
    directUploadUrl: getMeta('direct-upload-url')
  }
  const dashBoardOptions = {
    replaceTargetContent: false,
    showProgressDetails: true,
    showLinkToFileUploadResult: true,
    target: element,
    trigger: trigger,
    metaFields: [
      {id: 'name', name: 'Name', placeholder: 'file name'},
    ],
    browserBackButtonClose: false
  }

  // 3. get an uploader, and add some handy helpers
  let uppy = Uppy(uppyOptions())

  uppy.use(Dashboard, dashBoardOptions)
  uppy.use(ActiveStorageUpload, activeStorageOptions)

  // 4. When it has finished uploading,, this is what uppy should do
  uppy.on('complete', result => {
    uploadsComplete(element, result, fieldName)
  })
}

const uploadsComplete = (element, result, fieldName) => {
  // here we are... uppy has tried to uploaded the files and given us a big swag of results
  // 1. for the successful uploads - tell the user AND tell the form
  showResults(result.successful, 'successful_uploads',  fieldName)
  // 2. for the failures, tell the user.
  showResults(result.failed, 'failed_uploads')
}

const showResults = (resultList, selector, fieldName='') => {
  // send selected parts of hte uppy data to a mustache template which
  // sends back some html for the user, and some html for the form
  let html =  uploadTemplate(uploadData(resultList, fieldName))

  // we send the failures and the successes to mustache. If one of the lists is empty mustache will return nothing
  if (html) {
    let location = document.getElementById(selector)
    location.innerHTML = html
  }
}

const uploadData = (list, fieldName) => {
  // Take our pick of what Uppy has given us, add in some "view logic" and send it all as an object to Mustache.

  if (emptyArray(list)) {
    // tell mustache not to bother with this one
    return {display: false}
  }
  // Is this a list of successes or failures? Check the first element
  let successList = list[0].progress.uploadComplete

  return {
    display: true,      // we want these results shown
    listClass: successList ? 'success' : 'fail',  // we can treat our lists differently based on their class
    heading: successList ? 'Uploads' : 'Failed to upload',
    // we use the fieldname to build a suitable hidden input field for each file
    // but as it is the same for each file  we don't need to add it to each files data
    fieldName: fieldName,
    // now an object for each file in the list
    results: list.map(item => ({
      'name': item.name,
      'preview': item?.preview,
      'signed_id': item?.response?.signed_id
    }))
  }
}

export default setupUppy
