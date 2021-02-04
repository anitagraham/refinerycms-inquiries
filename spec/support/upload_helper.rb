#https://blog.eq8.eu/til/factory-bot-trait-for-active-storange-has_attached.html
module UploadHelper
  extend self

  def png_name; 'fathead.png' end
  def png; upload(png_name, 'image/png') end

  def jpeg_name; 'beach-alternate.jpeg' end
  def jpeg; upload(jpeg_name, 'image/jpeg') end

  def big_jpeg_name; 'beach.jpeg' end
  def big_jpeg; upload(big_jpeg_name, 'image/jpeg') end

  def pdf_name; 'cape-town-tide-table.pdf' end
  def pdf; upload(pdf_name, 'application/pdf') end

  private
    def upload(name, type)
      file = Rails.root.join('..', 'fixtures', name)
      Rack::Test::UploadedFile.new(file, type)
    end
end
