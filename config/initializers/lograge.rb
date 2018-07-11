Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.base_controller_class = 'ActionController::API'
  config.lograge.ignore_actions = ['Api::SuperWishsController#index']
  config.lograge.formatter = Lograge::Formatters::Json.new
end
