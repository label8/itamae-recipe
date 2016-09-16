remote_file node['nginx_common']['source_list'] do
  source "#{node['pathes']['cookbooks_root']}/nginx/common/remote_files#{node['nginx_common']['source_list']}"
  mode "644"
  owner "root"
  group "root"
end

execute "GPG key importing" do
  command "wget -O - http://nginx.org/keys/nginx_signing.key | sudo apt-key add -"
  not_if "apt-key list | grep nginx"
end

execute "apt-get update" do
  subscribes :run, "remote_file[#{node['nginx_common']['preference']}]", :immediately
  action :nothing
end

remote_file node['nginx_common']['preference'] do
  source "#{node['pathes']['cookbooks_root']}/nginx/common/remote_files#{node['nginx_common']['preference']}"
  mode "644"
  owner "root"
  group "root"
end

package "nginx"

service "nginx" do
  action [:enable, :start]
end
