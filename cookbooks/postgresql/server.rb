include_recipe "#{node[:pathes][:cookbooks_root]}/postgresql/base.rb"

###
# Local variables
###
hba_conf_file        = node[:pgsql][:hba_conf]
hba_conf_remote_file = "#{node[:pathes][:cookbooks_root]}/postgresql/remote_files#{hba_conf_file}"
postgresql_conf_file = node[:pgsql][:postgresql_conf]
postgresql_conf_remote_file = "#{node[:pathes][:cookbooks_root]}/postgresql/remote_files#{postgresql_conf_file}"

###
# Postgresql service (action :nothing)
###
service "postgresql"

###
# Deploy hba configration file to remote
###
remote_file hba_conf_file do
  source hba_conf_remote_file
  mode "644"
  owner "postgres"
  group "postgres"
  notifies :reload, "service[postgresql]"
end

###
# Deploy postgresql configration file to remote
###
remote_file postgresql_conf_file do
  source postgresql_conf_remote_file
  mode "644"
  owner "postgres"
  group "postgres"
  notifies :reload, "service[postgresql]"
end

###
# Create user for postgresql
###
execute 'create user' do
  user_exists = <<-EOL
    sudo -u postgres -i sh -c "psql -c \\"SELECT * FROM pg_user WHERE usename='#{node[:pgsql][:user]}'\\"" | grep #{node[:pgsql][:user]}
  EOL

  command <<-EOL
    sudo -u postgres -i sh -c "psql -c \\"CREATE ROLE #{node[:pgsql][:user]} LOGIN CREATEDB PASSWORD '#{node[:pgsql][:password]}'\\""
  EOL

  not_if user_exists
end

###
# Postgresql service restart
###
service "postgresql" do
  action :restart
end