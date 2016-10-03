# Install node.js
execute "Add node.js to package" do
  user "vagrant"
  command "curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -"
end

package "nodejs"

# Make app root dir and deploy Gemfile
directory "#{node['rails']['app_root']}/#{node['app_name']}" do
  mode "775"
  owner "vagrant"
  group "vagrant"
  not_if "test -d #{node['rails']['app_root']}/#{node['app_name']}"
end

###
# Rails特有の環境変数は別途ymlで設定
###

# Using rails environments
# remote_file "#{node['rails']['env_script']}" do
#   source "#{node['pathes']['cookbooks_root']}/rails/remote_files#{node['rails']['env_script']}"
#   mode "644"
#   owner "root"
#   group "root"
# end