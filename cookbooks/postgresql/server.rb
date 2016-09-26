include_recipe "#{node['pathes']['cookbooks_root']}/postgresql/base.rb"

service "postgresql"

remote_file node['pgsql']['hba_conf'] do
  source "#{node['pathes']['cookbooks_root']}/postgresql/remote_files#{node['pgsql']['hba_conf']}"
  mode "644"
  owner "postgres"
  group "postgres"
  notifies :reload, "service[postgresql]"
end

remote_file node['pgsql']['postgresql_conf'] do
  source "#{node['pathes']['cookbooks_root']}/postgresql/remote_files#{node['pgsql']['postgresql_conf']}"
  mode "644"
  owner "postgres"
  group "postgres"
  notifies :reload, "service[postgresql]"
end

#service "postgresql" do
#  action :restart
#end

execute 'create user' do
  user_exists = <<-EOL
    sudo -u postgres -i sh -c "psql -c \\"SELECT * FROM pg_user WHERE usename='#{node['pgsql']['user']}'\\"" | grep #{node['pgsql']['user']}
  EOL

  command <<-EOL
    sudo -u postgres -i sh -c "psql -c \\"CREATE ROLE #{node['pgsql']['user']} LOGIN CREATEDB PASSWORD '#{node['pgsql']['password']}'\\""
  EOL

  not_if user_exists
end

