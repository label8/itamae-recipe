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
  not_if "ls -l #{node['rails']['app_root']}"
end

remote_file node['rails']['gemfile'] do
  source "#{node['pathes']['cookbooks_root']}/rails/remote_files#{node['rails']['gemfile']}"
  mode "664"
  owner "vagrant"
  group "vagrant"
end

execute "Gem install" do
  user "vagrant"
  cwd node['rails']['app_root']
  command ". #{node['rbenv']['script']}; bundle install --path vendor/bundle"
  not_if "ls -l #{node['rails']['app_root']}/vendor/bundle"
end

execute "Rails install" do
  user "vagrant"
  cwd node['rails']['app_root'] 
  command ". #{node['rbenv']['script']}; bundle exec rails new -f -T -d #{node['rails']['database']} ."
  not_if "ls -l #{node['rails']['app_root']}/app"
end

