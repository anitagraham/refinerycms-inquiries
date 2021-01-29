import Uppy from '@uppy/core'
import DragDrop from '@uppy/drag-drop'
import FileInput from '@uppy/file-input'
import ProgressBar from '@uppy/progress-bar'
import StatusBar from '@uppy/status-bar'

// import XHRUpload from '@uppy/xhr-upload'

// And their styles (for UI plugins)
import '@uppy/core/src/style.scss'
import '@uppy/drag-drop/src/style.scss'
import '@uppy/file-input/src/style.scss'
import '@uppy/progress-bar/src/style.scss'
import '@uppy/status-bar/src/style.scss'

const uppyOptions = {
  id: 'uppy',
  autoProceed: false,
  allowMultipleUploads: true,
  debug: true,
  restrictions: {
    maxFileSize: 5242880,
    maxTotalFileSize: null,
    maxNumberOfFiles: 3,
    minNumberOfFiles: 1,
    allowedFileTypes: ['image/*', '.jpg', '.jpeg', '.png', '.gif', 'application/pdf']
  },
  logger: Uppy.debugLogger,
  infoTimeout: 5000
}
const initUppy = (selector) => {
  let uppy = new Uppy(uppyOptions)
  uppy.use(DragDrop, { target: selector })
  uppy.use(FileInput, { pretty: true, inputName: 'attachments', })
  uppy.use(ProgressBar, { target: selector })
  uppy.use(StatusBar, { target: selector })

  uppy.on('complete', (result) => {
    console.log('Upload complete! We’ve uploaded these files:', result.successful)
  })
  return uppy;
}
export default initUppy
