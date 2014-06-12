require 'unicorn'

app_root = File.expand_path("../..", __FILE__)

working_directory "#{app_root}"
pid "#{app_root}" + "/tmp/pids/unicorn.pid"
stderr_path "#{app_root}" + "/log/unicorn.log"
stdout_path "#{app_root}" + "/log/unicorn.log"

listen 3016, :tcp_nopush => false
worker_processes 2
timeout 30
