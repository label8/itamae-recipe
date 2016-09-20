template node['rails']['unicorn']['file'] do
  source "#{node['pathes']['cookbooks_root']}/rails/templates#{node['rails']['unicorn']['file']}.erb"
  variables(
    worker_processes: node['rails']['unicorn']['worker_processes'],
    timeout: node['rails']['unicorn']['timeout'],
    preload_app: node['rails']['unicorn']['preload_app']
  )
  mode "664"
  owner "vagrant"
  group "vagrant"
end
