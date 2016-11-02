#
# Cookbook Name:: go_service
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
chef_gem 'hash_symbolizer'
require 'hash_symbolizer'

node[:go_service].each do |service_config|
  mkdir = proc do |path|
    directory path do
      owner service_config[:user]
      group "apps"
      mode "0775"
      recursive true
    end
  end

  mkdir.call "/home/apps/#{service_config[:name]}"

  service_config[:environments].each do |environment|
    app_name = "#{service_config[:name]}_#{environment[:name]}"
    app_root = "/home/apps/#{service_config[:name]}/#{environment[:name]}/current"
    app_shared = "/home/apps/#{service_config[:name]}/#{environment[:name]}/shared"

    # basic directories
    mkdir.call "/home/#{service_config[:user]}/#{app_name}"
    mkdir.call "/home/apps/#{service_config[:name]}/#{environment[:name]}"
    mkdir.call "/home/apps/#{service_config[:name]}/#{environment[:name]}/releases"
    mkdir.call app_shared

    %w{config public log tmp tmp/pids}.each do |dir|
      mkdir.call "#{app_shared}/#{dir}"
      file("#{app_shared}/#{dir}/keep_it.touch") { action :touch }
    end
  end
end
