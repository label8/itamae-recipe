###
# Local variables
###
rbenv_root_dir           = node[:rbenv][:dirs][:root]
rbenv_plugins_dir        = node[:rbenv][:dirs][:plugins]
rbenv_ruby_build_dir     = node[:rbenv][:dirs][:ruby_build]
rbenv_script             = node[:rbenv][:script]
rbenv_script_remote_file = "#{node[:pathes][:cookbooks_root]}/rbenv/remote_files#{rbenv_script}"
install_ruby_version     = node[:rbenv][:version]
use_global_ruby_version  = node[:rbenv][:global]
rbenv_gems               = node[:rbenv][:gems]

###
# Installation of a necessary package
###
%w(
  zlib1g-dev
  libssl-dev
  libreadline-dev
  libyaml-dev
  libsqlite3-dev
  sqlite3
  libpq-dev
  libxml2-dev
  libxslt1-dev
  libcurl4-openssl-dev
  libffi-dev
).each do |pkg|
  package "#{pkg}" do
    action :install
  end
end

###
# git cloning rbenv
###
git rbenv_root_dir do
  repository "https://github.com/sstephenson/rbenv.git"
end

###
# Make rbenv plugins dir
###
directory rbenv_plugins_dir do
  action :create
end

###
# git cloning ruby-build
###
git rbenv_ruby_build_dir do
  repository "https://github.com/sstephenson/ruby-build.git"
end

###
# Install ruby-build
###
execute "install ruby-build" do
  command "#{rbenv_ruby_build_dir}/install.sh"
end

###
# Deploy rbenv script to remote
###
remote_file rbenv_script do
  action :create
  source rbenv_script_remote_file
  mode "644"
  owner "root"
  group "root"
end

###
# Install ruby
###
execute "install ruby #{install_ruby_version}" do
  command ". #{rbenv_script}; rbenv install #{install_ruby_version}"
  not_if ". #{rbenv_script}; rbenv versions | grep #{install_ruby_version}"
end

###
# Set global ruby version
###
execute "set global ruby-#{install_ruby_version}" do
  command ". #{rbenv_script}; rbenv global #{use_global_ruby_version}; rbenv rehash"
  not_if ". #{rbenv_script}; rbenv global | grep #{use_global_ruby_version}"
end

###
# Install gems
###
rbenv_gems.each do |gem|
  execute "gem install #{gem}" do
    command ". #{rbenv_script}; gem install #{gem} --no-ri --no-rdoc; rbenv rehash"
    not_if ". #{rbenv_script}; gem list | grep #{gem}"
  end
end