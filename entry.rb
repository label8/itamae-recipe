# itamae ssh で指定したIPアドレスの第四オクテットを見て
# どのロールを読み込むか決める
matches = ARGV[2].match(/.+\.(\d+)$/)
fourth_octet = matches[1]

case fourth_octet.to_i
when 20
  include_recipe "roles/front/base.rb"
when 21
  include_recipe "roles/web/base.rb"
  include_recipe "roles/app/base.rb"
when 40
  include_recipe "roles/db/base.rb"
else
  p "192.168.1.[20:front, 21-39:web, 40:db]"
end
