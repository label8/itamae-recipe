#環境変数名
set :rails_env, :staging
set :unicorn_rack_env, :staging
#ソースをmasterブランチから落す
set :branch, 'master'
#各サーバの役割を記述
role :web, %w{vagrant@192.168.1.16}
role :app, %w{vagrant@192.168.1.16}

set :ssh_options, {
  keys: %w(/home/vagrant/.ssh/id_rsa),
  forward_agent: true,
  auth_methods: %w(publickey)
}