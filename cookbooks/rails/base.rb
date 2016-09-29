# node.js install
execute "Add node.js to package" do
  user "vagrant"
  command "curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -"
end

package "nodejs"

# setup rails
directory "#{node['rails']['app_root']}/#{node['app_name']}" do
  mode "775"
  owner "vagrant"
  group "vagrant"
  not_if "test -d #{node['rails']['app_root']}/#{node['app_name']}"
end

remote_file "#{node['rails']['app_root']}/#{node['app_name']}#{node['rails']['gemfile']}" do
  source "#{node['pathes']['cookbooks_root']}/rails/remote_files#{node['rails']['gemfile']}"
  mode "664"
  owner "vagrant"
  group "vagrant"
end

execute "Bundle install" do
  user "vagrant"
  cwd "#{node['rails']['app_root']}/#{node['app_name']}"
  command ". #{node['rbenv']['script']}; bundle install --path vendor/bundle"
  not_if "test -d #{node['rails']['app_root']}/#{node['app_name']}/vendor/bundle"
end

if node['rails']['env'] == "development"
  execute "Rails install" do
    user "vagrant"
    cwd "#{node['rails']['app_root']}/#{node['app_name']}"
    command ". #{node['rbenv']['script']}; bundle exec rails new -s -T -d #{node['rails']['database']['adapter']} ."
    not_if "test -d #{node['rails']['app_root']}/#{node['app_name']}/app"
  end

  template "#{node['rails']['app_root']}/#{node['app_name']}#{node['rails']['database']['file']}" do
    source "#{node['pathes']['cookbooks_root']}/rails/templates#{node['rails']['database']['file']}.erb"
    mode "644"
    owner "vagrant"
    group "vagrant"
  end
end
# %w(
#   RAILS_DATABASE_PASSWORD=G8BrneBL
#   SECRET_KEY_BASE=8afd9a8924107f0818d0ee79f6814ed3358fecfd59102b093880662763a1b764d35443bdeb3289856944aec1fc14f4816c6318cf640dc1614f8f513bbd76706f
# ).each do |env|
#   execute "Add Environment" do
#     user "root"
#     command "export #{env};"
#   end
# end