# Installation of a necessary package
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

# rbenv install
git node['rbenv']['dirs']['root'] do
  repository "https://github.com/sstephenson/rbenv.git"
end

directory node['rbenv']['dirs']['plugins'] do
  action :create
end

git node['rbenv']['dirs']['ruby-build'] do
  repository "https://github.com/sstephenson/ruby-build.git"
end

execute "install ruby-build" do
  command "#{node['rbenv']['dirs']['ruby-build']}/install.sh"
end

remote_file node['rbenv']['script'] do
  action :create
  source "#{node['pathes']['cookbooks_root']}/rbenv/remote_files#{node['rbenv']['script']}"
  mode "644"
  owner "root"
  group "root"
end

execute "install ruby #{node['rbenv']['version']}" do
  command ". #{node['rbenv']['script']}; rbenv install #{node['rbenv']['version']}"
  not_if ". #{node['rbenv']['script']}; rbenv versions | grep #{node['rbenv']['version']}"
end

execute "set global ruby-#{node['rbenv']['version']}" do
  command ". #{node['rbenv']['script']}; rbenv global #{node['rbenv']['global']}; rbenv rehash"
  not_if ". #{node['rbenv']['script']}; rbenv global | grep #{node['rbenv']['global']}"
end

node['rbenv']['gems'].each do |gem|
  execute "gem install #{gem}" do
    command ". #{node['rbenv']['script']}; gem install #{gem} --no-ri --no-rdoc; rbenv rehash"
    not_if ". #{node['rbenv']['script']}; gem list | grep #{gem}"
  end
end
