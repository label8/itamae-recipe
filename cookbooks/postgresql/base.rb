###
# Local variables
###
source_list             = node[:pgsql][:source_list]
source_list_remote_file = "#{node['pathes']['cookbooks_root']}/postgresql/remote_files#{source_list}"

###
# Deploy list file to remote
###
remote_file source_list do
  source source_list_remote_file
  owner "root"
  group "root"
end

###
# Key importing
###
execute "key importing" do
  command "wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -"
  not_if "apt-key list | grep PostgreSQL"
end

###
# apt-get update
###
execute "Update package" do
  command "apt-get update"
end

###
# Install package of postgresql
###
package "postgresql"