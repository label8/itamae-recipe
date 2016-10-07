###
# Local variables
###
conf_file          = node[:nginx_front][:conf]
conf_file_template = "#{node[:pathes][:cookbooks_root]}/nginx/front/templates#{conf_file}.erb"

###
# Nginx service (action :nothing)
###
service "nginx"

###
# Deploy nginx configration template to remote, and extract
###
template conf_file do
  source conf_file_template
  mode "644"
  owner "root"
  group "root"
  variables(
    :front_listen_port => node[:nginx_front][:listen],
    :front_server_name => node[:nginx_front][:server_name],
    :web_server_names  => node[:nginx_web][:server_names],
    :web_listen_port   => node[:nginx_web][:listen],
    :load_balancing_max_fails    => node[:nginx_common][:max_fails],
    :load_balancing_fail_timeout => node[:nginx_common][:fail_timeout]
  )
  notifies :restart, "service[nginx]"
end

###
# Remove nginx default.conf
###
execute "Remove nginx default.conf" do
  user "root"
  command "rm -f /etc/nginx/conf.d/default.conf"
  only_if "test -f /etc/nginx/conf.d/default.conf"
end
