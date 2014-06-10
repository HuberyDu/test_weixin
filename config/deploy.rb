require 'rvm/capistrano' # 支持rvm
require 'bundler/capistrano'  # 支持自动bundler
set :rvm_autolibs_flag, "read-only"        # more info: rvm help autolibs

set :application, "test_weixin" #应用的名字
set :location, "http://10.211.55.3/"
role :web, location                       # Your HTTP server, Apache/etc
role :app, location                       # This may be the same as your `Web` server
#server details
set :deploy_to, "/var/apps/wx/"  #部署在服务器上的地址

set :user, "bhqa" #ssh连接服务器的帐号
set :use_sudo, false
set :ssh_options, { :forward_agent => true }
set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"
#repo details
set :scm, :none
set :repository,  "."
set :local_repository, "." 
set :deploy_via, :copy

#tasks
namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && RAILS_ENV=production bundle exec unicorn_rails -c #{unicorn_config} -D"
  end

  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
      #do nonthing
  end 
end

