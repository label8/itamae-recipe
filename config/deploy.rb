# config valid only for current version of Capistrano
lock '3.6.1'

#アプリケーション名
set :application, 'rooster'
#レポジトリURL
set :repo_url, 'https://github.com/label8/rooster.git'
#デプロイ先ディレクトリ フルパスで指定
set :deploy_to, '/var/app/rooster'
#gitを利用
set :scm, :git
#情報レベル info or debug
set :log_level, :debug
#sudoに必要 これをtrueにするとssh -tで実行される
set :pty, true
#sharedに入るものを指定
set :linked_files, %w{config/database.yml config/secrets.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets bundle public/system public/assets}
#capistrano用bundleするのに必要
set :default_env, { path: "/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH" }
#5回分のreleasesを保持する
set :keep_releases, 5
#rbenv
set :rbenv_type, :system
set :rbenv_ruby, '2.3.1'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all
#unicorn
set :unicorn_pid, "#{shared_path}/tmp/pids/unicorn.pid"
set :bundle_jobs, 4

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  # アプリの再起動を行うタスク
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :mkdir, '-p', release_path.join('tmp')
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  # linked_files で使用するファイルをアップロードするタスク
  # deployが行われる前に実行する必要がある。
  desc 'upload important files'
  task :upload do
    on roles(:app) do |host|
      execute :mkdir, '-p', "#{shared_path}/config"
      upload!('config/database.yml',"#{shared_path}/config/database.yml")
      upload!('config/secrets.yml',"#{shared_path}/config/secrets.yml")
    end
  end

  # webサーバー再起動時にキャッシュを削除する
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      within release_path do
        execute :rm, '-rf', release_path.join('tmp/cache')
      end
    end
  end

  # Flow の before, after のタイミングで上記タスクを実行
  before :started, 'deploy:upload'
  after :finishing, 'deploy:cleanup'

  # Unicorn 再起動タスク
  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart' # lib/capustrano/tasks/unicorn.cap 内処理を実行
  end
end

# after 'deploy:publishing', 'deploy:restart'
# namespace :deploy do
#   task :restart do
#     invoke 'unicorn:restart'
#   end
# end
