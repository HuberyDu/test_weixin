require 'unicorn'

working_directory "/home/duxiaolong/test_weixin"
pid "/home/duxiaolong/test_weixin" + "/tmp/pids/unicorn.pid"
stderr_path "/home/duxiaolong/test_weixin" + "/log/unicorn.log"
stdout_path "/home/duxiaolong/test_weixin" + "/log/unicorn.log"

listen "/tmp/unicorn.test_weixin.sock"
worker_processes 2
timeout 30
