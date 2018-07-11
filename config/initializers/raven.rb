Raven.configure do |config|
  config.dsn = ENV['RAVEN_URL']
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
end
