require 'rubygems'
require 'spork'

ENV["RAILS_ENV"] = 'test'


Spork.prefork do
  
  # Loading more in this block will cause your tests to run faster. However, 
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  require File.dirname(__FILE__) + '/../config/environment.rb'
  require 'spec'
  require 'spec/rails'
  require 'factory_girl'
  require 'authlogic/test_case'
  
end

Spork.each_run do
  # This code will be run each time you run your specs.
  Spec::Runner.configure do |config|
    # If you're not using ActiveRecord you should remove these
    # lines, delete config/database.yml and disable :active_record
    # in your config/boot.rb
    config.use_transactional_fixtures = true
    config.use_instantiated_fixtures  = false
    config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
    # config.global_fixtures = :table_a, :table_b
    config.mock_with :mocha
    # For more information take a look at Spec::Runner::Configuration and Spec::Runner
  end  

end

