set :application, 'lefiores'
set :repo_url, 'https://github.com/emilenriquez/lefiores.git'
set :linked_files, %w{config/database.yml .env}
set :linked_dirs, %w{tmp/pids}
set :unicorn_config_path, "config/unicorn.rb"
set :rbenv_type, :user
set :rbenv_ruby, '2.1.2'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'unicorn:restart'
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end


set :domain, '106.187.55.19'
set :deploy_to, '/home/deployer/lefiores'
set :repository, 'https://github.com/emilenriquez/lefiores.git'
set :branch, 'master'
set :user, 'deployer'
set :forward_agent, true
set :port, '22'
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"

set :user, "deployer"

set :stages, ["development","staging", "production"]
set :default_stage, "development"
