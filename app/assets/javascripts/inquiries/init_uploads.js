import { DirectUpload } from 'activestorage'; // https://www.npmjs.com/package/@rails/activestorage

createAttachment = (name, attachment) => { // name is a string, the_attachment is a File object
  const upload = new DirectUpload( attachment, '/rails/active_storage/direct_uploads', // This url is exposed by default in your app
  );
  upload.create((error, blob) => {
    if (error) {
      console.log(error)
    } else {
      // blob.signed_id, a String, is the key piece of data that lets Rails identify the file we are referring to
      let signed_id = blob.signed_id;
      console.log(blob)
      // BONUS: We can already request the uploaded file from Rails by using this url.
      let url = `/rails/active_storage/blobs/${signed_id}/${"whatever_we_want_the_filename_to_be"}`;
      let request_body = {
        name: name,
        attachment: signed_id
      }
      post_thing_to_rails(request_body) // This can be REST, or GraphQL, doesn't matter
    }
  });
};
