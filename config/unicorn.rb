working_directory "#{Rails.root}"
pid "#{Rails.root}" + "/tmp/pids/unicorn.pid"
stderr_path "#{Rails.root}" + "/log/unicorn.log"
stdout_path "#{Rails.root}" + "/log/unicorn.log"

listen "/tmp/unicorn.#{appname}.sock"
worker_processes 2
timeout 30