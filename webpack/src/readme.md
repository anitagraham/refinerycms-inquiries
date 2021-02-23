## RefineryInquiries

This module is a companion to the Refinery CMS extension Refinerycms-Inquiries.

Refinery-Inquiries is now able to accept attachments with inquiries. This capability is controlled by several configuration options.

It uses Rails ActiveStorage and DirectUpload to handle the upload of the files to a permanent file store - bypassing your Rails application's handling of the file.

To use this feature in a production system you will need to configure ActiveStorage (via `config/storage.yml') to use a provider such as Amazon S3 or Google Cloud.  [Active Storage Overview](https://edgeguides.rubyonrails.org/active_storage_overview.html)

## Installation

`npm install @refinerycms/refineryInquiries`

## Usage

In your application's javascript, import this module and, when the document/dom/turbolinks is ready, initialize it.

```js
import inquiriesInit from '@refinerycms/refinery-inquiries'

 domReady( () => {

   inquiriesInit('trigger_id')
   
 })
```

A user can now submit an inquiry with attached files. The files are available via the Refinery backend.


