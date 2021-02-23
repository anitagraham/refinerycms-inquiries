Refinery::Core.configure do |config|
  # Register extra javascripts for backend
  # Register extra stylesheets for backend
  config.register_stylesheet "refinery/refinery-inquiries.css"

end

Rails.application.config.assets.precompile += %w[
  refinery/refinery-inquiries.css
]



