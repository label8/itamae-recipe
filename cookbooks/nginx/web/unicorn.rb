###
# Local variables
###
unicorn_conf_file     = node[:nginx_web][:unicorn_conf]
unicorn_conf_template = "#{node[:pathes][:cookbooks_root]}/nginx/web/templates#{unicorn_conf_file}.erb"

###
# Nginx service (action :nothing)
###
service "nginx"

###
# Deploy nginx configration template to remote, and extract
###
template unicorn_conf_file do
  source unicorn_conf_template
  mode "644"
  owner "root"
  group "root"
  variables(
    :unicorn_listen_socket => node[:rails][:unicorn][:listen],
    :web_server_name       => node[:nginx_web][:server_names][0],
    :web_listen_port       => node[:nginx_web][:listen],
    :app_root_dir          => "#{node[:rails][:app_root]}/#{node[:app_name]}"
  )
  notifies :restart, "service[nginx]"
end
