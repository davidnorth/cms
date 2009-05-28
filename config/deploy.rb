set :user, "web"
set :site_directory, "/home/web/html/thirstyplanet" 
role :web, "89.234.0.99" 

desc "Perform svn update, migrations and server restart"
task :update, :roles => :web do
  run "svn update #{site_directory}" 
  run "cd #{site_directory}; rake environment RAILS_ENV=production migrate" 
  run "mongrel_rails cluster::restart -C #{site_directory}/config/mongrel_cluster.yml"
end
