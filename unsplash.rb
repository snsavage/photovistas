require 'pry'
require 'unsplash'

Unsplash.configure do |config|
  config.application_id     = "4792f58797fa2fba67bacf48e208920a587165151c8dd67c385309fe69144935"
  config.application_secret = "beee0e149b56e80060024be8978c0ec2bcae74a092345141a9a0f8038ea80551"
  config.application_redirect_uri = "urn:ietf:wg:oauth:2.0:oob"
end

pry.start

