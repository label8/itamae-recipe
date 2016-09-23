#execute "service nginx restart" do
#  subscribes :run, "template[#{node['rails']['unicorn']['file']}]"
#  action :nothing
#end

template node['rails']['unicorn']['file'] do
  source "#{node['pathes']['cookbooks_root']}/rails/templates#{node['rails']['unicorn']['file']}.erb"
  mode "664"
  owner "vagrant"
  group "vagrant"
end

template node['rails']['unicorn']['script'] do
  source "#{node['pathes']['cookbooks_root']}/rails/templates#{node['rails']['unicorn']['script']}.erb"
  mode "755"
  owner "root"
  group "root"
end

execute "Load unicorn service" do
  user "root"
  command "systemctl daemon-reload"
  only_if "test -f #{node['rails']['unicorn']['script']}"
end

service "unicorn" do
  action [:enable, :start]
end
