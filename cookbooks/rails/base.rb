# node.js install
execute "Add node.js to package" do
  user "vagrant"
  command "curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -"
end

package "nodejs"

# setup rails
directory node['rails']['app_root'] do
  mode "775"
  owner "vagrant"
  group "vagrant"
  not_if "test -d #{node['rails']['app_root']}"
end

remote_file node['rails']['gemfile'] do
  source "#{node['pathes']['cookbooks_root']}/rails/remote_files#{node['rails']['gemfile']}"
  mode "664"
  owner "vagrant"
  group "vagrant"
end

execute "Bundle install" do
  user "vagrant"
  cwd node['rails']['app_root']
  command ". #{node['rbenv']['script']}; bundle install --path vendor/bundle"
#  not_if "test -d #{node['rails']['app_root']}/vendor/bundle"
end

execute "Rails install" do
  user "vagrant"
  cwd node['rails']['app_root'] 
  command ". #{node['rbenv']['script']}; bundle exec rails new -f -T -d #{node['rails']['database']['adapter']} ."
  not_if "test -d #{node['rails']['app_root']}/app"
end

execute "Set secret key and db password" do
  user "vagrant"
  cwd node['rails']['app_root']
  command "export SECRET_KEY_BASE=`bundle exec rake secret`; export APP_DATABASE_PASSWORD=#{node['rails']['database']['password']}"
end

template node['rails']['database']['file'] do
  source "#{node['pathes']['cookbooks_root']}/rails/templates#{node['rails']['database']['file']}.erb"
  variables(
    adapter: node['rails']['database']['adapter'],
    encoding: node['rails']['database']['encoding'],
    pool: node['rails']['database']['pool'],
    name: node['rails']['database']['name'],
    user: node['rails']['database']['user'],
    host: node['rails']['database']['host'],
    port: node['rails']['database']['port'],
    password: node['rails']['database']['password']
  )
  mode "644"
  owner "vagrant"
  group "vagrant"
end
