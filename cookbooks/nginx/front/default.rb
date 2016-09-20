include_recipe "#{node['pathes']['cookbooks_root']}/nginx/web/default.rb"

execute "service nginx restart" do
  subscribes :run, "template[#{node['nginx_front']['lb_conf']}]"
  action :nothing
end

template node['nginx_front']['conf'] do
  source "#{node['pathes']['cookbooks_root']}/nginx/front/templates#{node['nginx_front']['conf']}.erb"
  variables(
    listen: node['nginx_front']['listen'],
    server_name: node['nginx_front']['server_name'],
    backend_server1: node['nginx_web']['server_name1'],
    max_fails: node['nginx_common']['max_fails'],
    fail_timeout: node['nginx_common']['fail_timeout']
  )
  mode "644"
  owner "root"
  group "root"
end
