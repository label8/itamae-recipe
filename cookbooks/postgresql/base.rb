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