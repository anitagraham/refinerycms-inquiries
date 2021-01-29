Refinery::Core.configure do |config|
  # Register extra javascripts for backend
  # config.register_javascript "refinery-inquiries.js"

  # Register extra stylesheets for backend
  config.register_stylesheet "refinery/refinery-inquiries-server.css"

#  For frontend we have refinery-inquiries.js and refinery-inquiries-client.css
end

Rails.application.config.assets.precompile += %w[
  refinery/refinery-inquiries-client.css
  refinery/refinery-inquiries-server.css
  refinery/ready.js
  refinery/refinery-inquiries.js
]



