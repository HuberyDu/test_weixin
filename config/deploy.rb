require 'rvm/capistrano' # 支持rvm
require 'bundler/capistrano'  # 支持自动bundler
set :rvm_autolibs_flag, "read-only"        # more info: rvm help autolibs

set :application, "test_weixin" #应用的名字
set :keep_releases, 10
set :location, "58.246.136.2"
role :web, location                       # Your HTTP server, Apache/etc
role :app, location                       # This may be the same as your `Web` server
#server details
default_run_options[:pty] = true  # Must be set for the password prompt
set :deploy_to, "/var/apps/wx/"  #部署在服务器上的地址

set :user, "bhqa" #ssh连接服务器的帐号
set :use_sudo, false
set :ssh_options, { :forward_agent => true }
set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"
#repo details
set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :repository,  "git@github.com:HuberyDu/test_weixin.git" #项目在github上的帐号
set :branch, "master" #github上具体的分支

#tasks
namespace :deploy do
desc "SCP transfer figaro configuration to the shared folder"
  task :setup do
  	run "cd #{current_path} && RAILS_ENV=production bundle exec unicorn_rails -c #{unicorn_config} -D"
end

task :restart, :roles => :app do
  run "touch #{current_path}/tmp/restart.txt"
end

task :stop, :roles => :app do
    #do nonthing
end 
end

