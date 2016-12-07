require_relative "./config/environment"

use Rack::MethodOverride
# use BetterErrors::Middleware
use QueueController
use SessionsController
use UsersController
use UnsplashController
run ApplicationController

