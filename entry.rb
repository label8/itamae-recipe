# itamaeコマンドのオプションを配列として取得
options = ARGV
# デフォルト値セット
host_name = nil
# コマンドオプション配列からオプションのホスト接続(-h)に対するセット値(ホスト名)を取得
# -hの次の配列を取得
options.each_with_index do |opt, i|
  if opt.to_s == "-h"
    host_name = options[i+1]
  end
end

front_server = node['nginx_front']['server_name']
web_servers   = node['nginx_web']['server_names']
db_servers    = node['pgsql']['server_names']

# コマンドのホスト名が各アトリビュートのホスト名に含まれていたら該当のロールを読み込む
if front_server.include?(host_name)
  include_recipe "roles/front.rb"
elsif web_servers.include?(host_name)
  include_recipe "roles/web.rb"
elsif db_servers.include?(host_name)
  include_recipe "roles/db.rb"
end