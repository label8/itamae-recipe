remote_file node['pgsql']['source_list'] do
  source "#{node['pathes']['cookbooks_root']}/postgresql/remote_files#{node['pgsql']['source_list']}"
  owner "root"
  group "root"
end

execute "key importing" do
  command "wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -"
  not_if "apt-key list | grep PostgreSQL"
end

execute "Update package" do
  command "apt-get update"
end

package "postgresql"

template node['pgsql']['hba_conf'] do
  source "#{node['pathes']['cookbooks_root']}/postgresql/templates#{node['pgsql']['hba_conf']}.erb"
  variables(
    address: node['pgsql']['values']['hba']['address'],
    method: node['pgsql']['values']['hba']['method']
  )
  owner "postgres"
  group "postgres"
end

template node['pgsql']['postgresql_conf'] do
  source "#{node['pathes']['cookbooks_root']}/postgresql/templates#{node['pgsql']['postgresql_conf']}.erb"
  variables(
    lc_messages: node['pgsql']['values']['global']['lc_messages'],
    lc_monetary: node['pgsql']['values']['global']['lc_monetary'],
    lc_numeric: node['pgsql']['values']['global']['lc_numeric'],
    lc_time: node['pgsql']['values']['global']['lc_time']
  )
  owner "postgres"
  group "postgres"
end

service "postgresql" do
  action :restart
end

