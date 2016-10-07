###
# Local variables
###
app_root_dir            = "#{node[:rails][:app_root]}/#{node[:app_name]}#{node[:rails][:current_path]}"
unicorn_file            = node[:rails][:unicorn][:file]
unicorn_file_template   = "#{node[:pathes][:cookbooks_root]}/rails/templates#{unicorn_file}.erb"
unicorn_script          = node[:rails][:unicorn][:script]
unicorn_script_template = "#{node[:pathes][:cookbooks_root]}/rails/templates#{unicorn_script}.erb"

###
# Deploy unicorn file template to remote, and extract
###
template "#{app_root_dir}#{unicorn_file}" do
  source unicorn_file_template
  mode "664"
  owner "vagrant"
  group "vagrant"
  variables(
    :worker_process        => node[:rails][:unicorn][:worker_processes],
    :unicorn_listen_socket => node[:rails][:unicorn][:listen],
    :unicorn_pid_file      => "#{app_root_dir}#{node[:rails][:unicorn][:pid_file]}",
    :unicorn_timeout       => node[:rails][:unicorn][:timeout],
    :is_preload_app        => node[:rails][:unicorn][:preload_app],
    :unicorn_stdout_path   => "#{app_root_dir}#{node[:rails][:unicorn][:stdout_log]}",
    :unicorn_stderr_path   => "#{app_root_dir}#{node[:rails][:unicorn][:stderr_log]}",
  )
end

###
# Deploy unicorn script template to remote, and extract
###
template unicorn_script do
  source unicorn_script_template
  mode "755"
  owner "root"
  group "root"
  variables(
    :unicorn_run_user      => node[:rails][:unicorn][:user],
    :app_root              => app_root_dir,
    :rails_environment     => node['rails']['env'],
    :unicorn_pid_file      => "#{app_root_dir}#{node[:rails][:unicorn][:pid_file]}",
    :unicorn_config_file   => "#{app_root_dir}#{node[:rails][:unicorn][:config_file]}",
    :unicorn_command       => "#{node[:rbenv][:dirs][:root]}/shims/bundle exec #{app_root_dir}#{node[:rails][:vendor_bin_path]}/unicorn"
  )
end

###
# Make unicorn pids dir
###
directory "#{app_root_dir}/tmp/pids" do
  mode "775"
  owner "vagrant"
  group "vagrant"
  not_if "test -d #{app_root_dir}/tmp/pids"
end

###
# Load unicorn service
###
execute "Load unicorn service" do
  user "root"
  command "systemctl daemon-reload"
  only_if "test -f #{unicorn_script}"
end

###
# Unicorn service restart and enable
###
service "unicorn" do
  user "root"
  action [:enable, :restart]
end