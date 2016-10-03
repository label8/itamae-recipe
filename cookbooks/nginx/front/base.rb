service "nginx"

# Deploy nginx configration file
template node['nginx_front']['conf'] do
  source "#{node['pathes']['cookbooks_root']}/nginx/front/templates#{node['nginx_front']['conf']}.erb"
  mode "644"
  owner "root"
  group "root"
  notifies :restart, "service[nginx]"
end

execute "Remove nginx default.conf" do
  user "root"
  command "rm -f /etc/nginx/conf.d/default.conf"
  only_if "test -f /etc/nginx/conf.d/default.conf"
end
