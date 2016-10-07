###
# Local variables
###
app_root_dir               = "#{node[:rails][:app_root]}/#{node[:app_name]}#{node[:rails][:current_path]}"
rails_database_file        = node[:rails][:database][:file]
rails_database_remote_file = "#{node[:pathes][:cookbooks_root]}/rails/remote_files#{rails_database_file}"
rails_secrets_file         = node[:rails][:secret_file]
rails_secrets_remote_file  = "#{node[:pathes][:cookbooks_root]}/rails/remote_files#{rails_secrets_file}"
rbenv_script               = node[:rbenv][:script]

###
# Imoort nodejs package
###
execute "Add node.js to package" do
  user "vagrant"
  command "curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -"
end

###
# Install nodejs
###
package "nodejs"

###
# Make app root dir
###
directory app_root_dir do
  mode "775"
  owner "vagrant"
  group "vagrant"
  not_if "test -d #{app_root_dir}"
end

###
# git clonning project
###
git app_root_dir do
  repository "https://github.com/label8/rooster.git"
  user "vagrant"
  not_if "test -d #{app_root_dir}/.git"
end

###
# Deploy rails database file to remote
###
remote_file "#{app_root_dir}#{rails_database_file}" do
  source rails_database_remote_file
  mode "755"
  owner "vagrant"
  group "vagrant"
  not_if "test -f #{app_root_dir}#{rails_database_file}"
end

###
# Deploy rails secrets file to remote
###
remote_file "#{app_root_dir}#{rails_secrets_file}" do
  source rails_secrets_remote_file
  mode "755"
  owner "vagrant"
  group "vagrant"
  not_if "test -f #{app_root_dir}#{rails_secrets_file}"
end

###
# Install bundler
###
execute "install bundler" do
  user "vagrant"
  cwd app_root_dir
  command ". #{rbenv_script}; bundle install --path vendor/bundle"
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