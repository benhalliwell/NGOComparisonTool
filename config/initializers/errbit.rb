Airbrake.configure do |config|
  config.api_key = 'e097032fc9c0ddcba6fbd5f0de856ed0'
  config.host    = 'errbit.software-hut.org.uk'
  config.port    = 443
  config.secure  = config.port == 443
end