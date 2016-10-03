#環境変数名
set :rails_env, :development
set :unicorn_rack_env, :development
#ソースをmasterブランチから落す
set :branch, 'master'
#各サーバの役割を記述
role :web, %w{vagrant@192.168.1.15}
role :app, %w{vagrant@192.168.1.15}

set :ssh_options, {
  keys: %w(/home/vagrant/.ssh/id_rsa),
  forward_agent: true,
  auth_methods: %w(publickey)
}