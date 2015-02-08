lock '3.3.5'

# for rbenv
set :rbenv_type, :user
set :rbenv_ruby, '2.1.2'
#set :rbenv_path, '/home/deployer/.rbenv/bin/rbenv'
set :rbenv_path, '/home/deployer/.rbenv'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all

set :application, 'lefiores.com'
set :repo_url, 'git@github.com:emilenriquez/lefiores.git'

set :scm, :git
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
#set :pty, false

set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# secret_key_base格納用
#set :linked_files, %w{.env}

# for lefiores(unicorn)
set :lefiores_unicorn_pid, -> { File.join(current_path, "tmp", "pids", "unicorn.pid") }
set :lefiores_unicorn_config_path, -> { File.join(current_path, "config", "unicorn.rb") }

namespace :lefiores do
  desc "Start Lefiores(Unicorn)"
  task :start do
    on roles(:app) do
      within current_path do
        if test("[ -e #{fetch(:lefiores_unicorn_pid)} ] && kill -0 #{pid}")
          info "unicorn is running..."
        else
          with rails_env: fetch(:rails_env) do
            with bundle_gemfile: "#{current_path}/Gemfile" do
              execute :bundle, "exec unicorn", "-c", fetch(:lefiores_unicorn_config_path), "-E", fetch(:rails_env), "-D"
            end
          end
        end
      end
    end
  end
  
  desc 'bundle install'
  task :install_bundle do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :install
        end
      end
    end
  end

  desc "compile_assets"
  task :compile_assets do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, "rake assets:precompile"
        end
      end
    end
  end

  desc "Stop Lefiores(Unicorn) (QUIT)"
  task :stop do
    on roles(:app) do
      within current_path do
        if test("[ -e #{fetch(:lefiores_unicorn_pid)} ]")
          if test("kill -0 #{pid}")
            info "stopping unicorn..."
            execute :kill, "-s QUIT", pid
          else
            info "cleaning up dead unicorn pid..."
            execute :rm, fetch(:lefiores_unicorn_pid)
          end
        else
          info "unicorn is not running..."
        end
      end
    end
  end
 
  desc "Restart Gamerz(Unicorn) (USR2); use this when preload_app: true"
  task :restart do
    invoke "lefiores:start"
    on roles(:app) do
      within current_path do
        #execute :bundle, :install
        #execute :bundle, :exec, "rake assets:precompile"
        with bundle_gemfile: "#{current_path}/Gemfile" do
          info "unicorn restarting..."
          execute :kill, "-s USR2", pid
        end
      end
    end
  end

  desc 'restart nginx (service)'
  task :restart_nginx do
    on roles(:app), in: :sequence, wait: 3 do
      within release_path do
        execute :sudo, :service, :nginx, :restart
      end
    end
  end
  def pid
    "`cat #{fetch(:lefiores_unicorn_pid)}`"
  end

  def pid_oldbin
    "`cat #{fetch(:lefiores_unicorn_pid)}.oldbin`"
  end

  task :test do
    on roles(:app) do
    #  within current_path do
        execute :echo, "from server!"
        execute :hostname
        info 'asdfasdfa'
    #  end
    end
  end
end

Rake::Task['metrics:collect'].clear_actions
