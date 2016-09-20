execute "service nginx restart" do
  subscribes :run, "template[#{node['nginx_web']['unicorn_conf']}]"
  action :nothing
end

template node['nginx_web']['unicorn_conf'] do
  source "#{node['pathes']['cookbooks_root']}/nginx/web/templates#{node['nginx_web']['unicorn_conf']}.erb"
  variables(
    listen: node['nginx_web']['listen']
  )
  mode "644"
  owner "root"
  group "root"
end
