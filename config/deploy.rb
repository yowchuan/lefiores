require 'capistrano/ext/multistage'

set :application, "lefiores"

set :scm, :git
set :repository, "git@github.com:emilenriquez/lefiores.git"
set :scm_passphrase, ""

set :user, "deployer"

set :stages, ["development","staging", "production"]
set :default_stage, "development"
