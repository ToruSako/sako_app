$timeout = 30
$app_dir = '/var/www/rails/sako_app'
#$listen  = File.expand_path 'tmp/sockets/.unicorn.sock', $app_dir
#$pid     = File.expand_path 'tmp/pids/unicorn.pid', $app_dir
$std_log = File.expand_path 'log/unicorn.log', $app_dir
# set config
worker_processes 2
working_directory $app_dir
stderr_path $std_log
stdout_path $std_log
timeout $timeout
listen '/var/www/rails/sako_app/tmp/sockets/.unicorn.sock'
pid '/var/www/rails/sako_app/tmp/pids/unicorn.pid'
# loading booster
preload_app true
# before starting processes
before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      Process.kill "QUIT", File.read(old_pid).to_i
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end
# after finishing processes
after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
