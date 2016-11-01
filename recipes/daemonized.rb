node[:go_service].each do |service_config|
  service_config[:environments].each do |environment|
    next unless environment[:daemonized]

    environment[:daemonized].each do |daemon_name|
      app_name = "#{daemon_name}_#{environment[:name]}"
      app_root = "/home/apps/#{service_config[:name]}/#{environment[:name]}/current"
      app_shared = "/home/apps/#{service_config[:name]}/#{environment[:name]}/shared"

      template "/etc/init.d/#{app_name}" do
        source "init_daemon.erb"
        variables(
          app_name: app_name,
          app_root: app_root,
          app_shared: app_shared,
          daemon_name: daemon_name,
          environment: environment[:name],
          user: service_config[:user]
        )
        mode '0755'
      end
      service app_name do
        action :enable
      end
    end
  end
end
