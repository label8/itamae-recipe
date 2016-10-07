###
# Local variables
###
source_list             = node[:nginx_common][:source_list]
source_list_remote_file = "#{node[:pathes][:cookbooks_root]}/nginx/common/remote_files#{source_list}"
preference              = node[:nginx_common][:preference]
preference_remote_file  = "#{node[:pathes][:cookbooks_root]}/nginx/common/remote_files#{preference}"

###
# Deploy list file to remote
###
remote_file source_list do
  source source_list_remote_file
  mode "644"
  owner "root"
  group "root"
end

###
# GPG key importing
###
execute "GPG key importing" do
  command "wget -O - http://nginx.org/keys/nginx_signing.key | sudo apt-key add -"
  not_if "apt-key list | grep nginx"
end

###
# apt-get update
###
execute "apt-get update" do
  subscribes :run, "remote_file[#{preference}]", :immediately
  action :nothing
end

###
# Deploy preference file to remote
###
remote_file preference do
  source preference_remote_file
  mode "644"
  owner "root"
  group "root"
end

###
# Install package of nginx
###
package "nginx"

###
# Nginx service start and enable
###
service "nginx" do
  action [:enable, :start]
end
