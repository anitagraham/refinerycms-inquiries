Refinery::Core.configure do |config|
  # Register extra javascripts for backend
  # Our js is for the front end
  # config.register_javascript "refinery-inquiries.js"

  # Register extra stylesheets for backend
  config.register_stylesheet "refinery-inquiries-server.css"

#  For frontend we have refinery-inquiries.js and refinery-inquiries-client.css
end

Rails.application.config.assets.precompile += %w[
  refinery-inquiries-client.css
  refinery-inquiries-server.css
  refinery-inquiries.js
]



