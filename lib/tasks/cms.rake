namespace :db do
  
  task :bootstrap => :environment do |task_args|
    
    puts '-'*100
    puts 'Loading schema'
    Rake::Task["db:schema:load"].execute

    puts '-'*100
    puts 'Loading initial data'
    require RAILS_ROOT + '/db/seed.rb'

    puts '-'*100
    puts 'Done'
    puts '-'*100
    
  end
  
end