service "nginx"

template node['nginx_web']['unicorn_conf'] do
  source "#{node['pathes']['cookbooks_root']}/nginx/web/templates#{node['nginx_web']['unicorn_conf']}.erb"
  mode "644"
  owner "root"
  group "root"
  notifies :restart, "service[nginx]"
end
