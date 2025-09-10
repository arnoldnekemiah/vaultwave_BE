Rails.application.configure do
  # Frontend URL configuration
  config.frontend_url = ENV.fetch("FRONTEND_URL", "http://localhost:3001")
end
