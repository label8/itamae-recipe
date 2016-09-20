execute "service nginx restart" do
  subscribes :run, "template[#{node['nginx_web']['default_conf']}]"
  action :nothing
end

template node['nginx_web']['default_conf'] do
  source "#{node['pathes']['cookbooks_root']}/nginx/web/templates#{node['nginx_web']['default_conf']}.erb"
  variables(
    listen: node['nginx_web']['listen'],
    server_name: node['nginx_web']['server_names'][0]
  )
  mode "644"
  owner "root"
  group "root"
end
