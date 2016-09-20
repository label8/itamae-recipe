node['roles'] = node['roles'] || []
node['roles'].each do |role|
  include_recipe "roles/#{role}/base.rb"
end
