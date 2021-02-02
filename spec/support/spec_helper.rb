def refinery_login
  let(:logged_in_user) { Refinery::Core::NilUser.new }
end

def ensure_on(path)
  visit(path) unless current_path == path
end

def create_blob(file)
  fh = Rails.root.join('spec', 'fixtures', file)
  ActiveStorage::Blob.create_after_upload!(
    io: File.open(fh, 'rb'),
    filename: file,
    content_type: 'image/jpeg'
  ).signed_id
end
