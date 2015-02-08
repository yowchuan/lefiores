#!/bin/sh

bundle exec cap production deploy
bundle exec cap production lefiores:install_bundle

bundle exec cap production lefiores:compile_assets
bundle exec cap production lefiores:stop
bundle exec cap production lefiores:start

