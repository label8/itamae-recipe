include_recipe "#{node['pathes']['cookbooks_root']}/nginx/web/base.rb"
include_recipe "#{node['pathes']['cookbooks_root']}/nginx/web/default.rb"
include_recipe "#{node['pathes']['cookbooks_root']}/nginx/web/unicorn.rb"
include_recipe "#{node['pathes']['cookbooks_root']}/postgresql/base.rb"
include_recipe "#{node['pathes']['cookbooks_root']}/rbenv/base.rb"
include_recipe "#{node['pathes']['cookbooks_root']}/rails/base.rb"
if node['rails']['env'] == "development"
include_recipe "#{node['pathes']['cookbooks_root']}/rails/unicorn.rb"
end