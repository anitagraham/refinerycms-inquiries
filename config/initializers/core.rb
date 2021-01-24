Refinery::Core.configure do |config|
  # Register extra javascripts for backend
  # Our js is for the front end
  # config.register_javascript "refinerycms-inquiries.js"

  # Register extra stylesheets for backend
  config.register_stylesheet "refinerycms-inquiries.css"
end

Rails.application.config.assets.precompile += %w( refinerycms-inquiries.css refinerycms-inquiries-frontend.css refinerycms-inquiries.js )
