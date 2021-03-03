# Inquiries

![Refinery Inquiries](http://refinerycms.com/system/images/BAhbBlsHOgZmSSIqMjAxMS8wNS8wMS8wNF81MF8wMV81MDlfaW5xdWlyaWVzLnBuZwY6BkVU/inquiries.png)

## About

__Add a simple contact form to Refinery that notifies you and the customer when an inquiry is made.__

In summary you can:

* Collect and manage inquiries
* Specify who is notified when a new inquiry comes in
* Customise an auto responder email that is sent to the person making the inquiry
* Allow users to upload documents with their inquiries

When inquiries come in, you and the customer are generally notified. As we implemented spam filtering through the [filters_spam plugin](https://github.com/resolve/filters_spam#readme) you will not get notified if an inquiry is marked as 'spam'.  This feature is optional, and can be disabled in `config/initializers/refinery/inquiries.rb` by setting `config.filter_spam = false`.

## Gem Installation 

Include the latest [gem](http://rubygems.org/gems/refinerycms-inquiries) into your Refinery CMS application's Gemfile:

```ruby
gem 'refinerycms-inquiries', '~> 4.1.0'
```

Then type the following at command line inside your Refinery CMS application's root directory:

    bundle install

#### Migrations
To install the migrations, run:

    rails generate refinery:inquiries
    rake db:migrate

#### Install Seed Data
Adds a 'contact page' and a 'thank you page to the database and you're done:

    rake db:seed

#### Optionally include the stylesheet.

Next, you can include the stylesheet that improves the form's display a bit,
and also adds an asterisk to each `required` label: `Name *` instead of `Name`.

To do this, include it in your `application.css` manifest file and insert:

```css
//= require refinery/inquiries/inquiries
```

## Configuration

####Checklist of configuration requirements
- [ ] `config/application.rb`  - top level domains longer than one segment
- [ ] `config/credentials/production.yml.enc`, reCAPTCHA, 
- [ ] `config/initializers/refinery/inquiries.rb` enable/disable features
- [ ] `config/storage.yml` attachment storage services
- [ ] `config/environments/production.rb`, storage service, mailer config
- [ ]  `refinery/inquiries page`, addresses/notification/confirmation

### How do I enable reCAPTCHA support?

Note: enabling this feature disables the built in spam filtering.

When you register for reCAPTCHA you will receive a _site_key_ and a _secret_key_
For development environments Google provides a set of test keys. 

Rails provides access to an encrypted credentials file. You can have a separate credentials file for each environment.

Add your recaptcha keys to your credentials for development and production. Use the Google test keys in development.

```shell
rails credentials:edit --environment production
```

```yml
# config/credentials/production.yml.enc
recaptcha:
 site_key: "put your SITE Key here"
 secret_key: "put your SECRET key here"
```

The inquiries initialization file (`config/initializers/refinery/inquiries.rb`) will get your site_key out of the credentials file.

```ruby
config.recaptcha_site_key = Rails.application.credentials.dig(:recaptcha, :site_key)
```

When checking that a user is not a robot it will also use the value of `secret_key` to communicate with Google recaptcha services.

### How do I set up email to be sent from GMail, SendGrid or other service?

Inquiries uses `actionmailer` under the hood so you can refer to [Rails Action Mailer guide](http://guides.rubyonrails.org/action_mailer_basics.html). For example to use GMail see [Action Mailer Configuration for GMail](http://guides.rubyonrails.org/action_mailer_basics.html#action-mailer-configuration-for-gmail) guide.

Other mail services will provide guidance - and possibly a suitable Gem - for integrating with ActionMailer. 

### How do I get Notified?

Go into your 'Inquiries' tab in the Refinery admin area and click on "Update who gets notified"

### How do I Edit the Automatic Confirmation Email

Go into your 'Inquiries' tab in the Refinery admin area and click on "Edit confirmation email"

### Help! How do I send emails from no-reply@domain.com.au instead of no-reply@com.au?

Simply set the following in `config/application.rb`:

```ruby
config.action_dispatch.tld_length = 2
```

## Attachments
This is an optional feature and is not enabled by default.

To permit users to upload one or more attachments with their inquiry enable the feature in `config/initializers/refinery/inquiries.rb` by setting `config.permit_attachments = true`.

Attachments use Rails ActiveStorage to store files, and its javascript companion DirectUploads to upload the files to your storage service.  See [Rails Active Storage Guide](https://edgeguides.rubyonrails.org/active_storage_overview.html) for more information.

You will need to setup `config/storage.yml` with different storage service configurations, and each environment file should specify which storage configuration it will use.

```ruby
# config/environments/development.rb
  config.active_storage.service = :local   # :local is defined in config/storage.yml
```

```ruby
# config/environments/production.rb
  config.active_storage.service = :google # :google is defined in config/storage.yml
```

The other options available once attachments are permitted are

* `attachments_external_uploader`
* `attachments_max_size`
* `attachments_max_number`
* `attachments_permitted_types`

### Conditions
`attachments_max_size`, `attachments_max_number` and `attachments_permitted_types` all add limitations on uploaded files.

* `max_size` specifies the maximum size for each file to be uploaded.

  If a user tries to upload an attachment larger than this limit the form will fail validation.

* `max_number` limits how many files can be uploaded per inquiry
* `permitted_types` limits the file types that can be uploaded.

The configuration below will permit only two files, each one up to a maximum size of 2Mb, to be uploaded. Only .png and .jpg files will be permitted. Anything else will fail validation and the inquiry will not be saved.
```
 config.attachments_max_size = 2.Megabytes
 config.attachments_max_number = 2
 config.attachments_permitted_types = %w[png jpg]
```

### External Uploader
If you want to use a javascript package to enable provide extra upload features (like _dropzone_ or _uppy_ which provide drag and drop ) set this value to true. It will be up to you to add the package to your javascript, then to initiate and configure it. The elements here may be helpful.

When the external uploader is enabled two elements will be added to the standard new inquiry form.

It will look like this, with the numbers and sizes from the settings above:
```html
<button id="upload_trigger" class="button">Upload Files</button>
<div id="jsUploader" 
     data-direct-upload-url="/rails/active_storage/direct_uploads" 
     data-field-name="inquiry[attachments][]" 
     data-max-file-number="2" 
     data-max-file-size="2097152" 
     data-permitted-file-types="jpg png">
```

You can integrate your uploader in such a way that
* the uploader can be triggered when the user clicks on "Upload Files".
* it can use the same restrictions on files, at the front end, which will be applied on the backend
* it can use the directUpload url for uploading
* You will need to add the results returned by the uploader (file signatures probably) as hidden form fields with the name `inquiry[attachments][]`

