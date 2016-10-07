###
# Local variables
###
default_conf_file     = node[:nginx_web][:default_conf]
default_conf_template = "#{node[:pathes][:cookbooks_root]}/nginx/web/templates#{default_conf_file}.erb"

###
# Nginx service (action :nothing)
###
service "nginx"

###
# Deploy nginx configration template to remote, and extract
###
template default_conf_file do
  source default_conf_template
  mode "644"
  owner "root"
  group "root"
  notifies :restart, "service[nginx]"
end
