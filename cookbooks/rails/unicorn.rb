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

directory "#{node['rails']['app_root']}/tmp/pids" do
  mode "775"
  owner "vagrant"
  group "vagrant"
  not_if "test -d #{node['rails']['app_root']}/tmp/pids"
end

execute "Load unicorn service" do
  user "root"
  command "systemctl daemon-reload"
  only_if "test -f #{node['rails']['unicorn']['script']}"
end

service "unicorn" do
  user "root"
  action [:enable, :restart]
end
