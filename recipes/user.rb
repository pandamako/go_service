node[:go_service].each do |service_config|
  user service_config[:user] do
    comment "#{service_config[:name]} user"
    home "/home/#{service_config[:user]}"
    shell "/bin/bash"

    supports manage_home: true
  end

  group "apps" do
    action :modify
    members service_config[:user]
    append true
  end

  template "/home/#{service_config[:user]}/.bashrc" do
    source "bashrc.erb"
    owner service_config[:user]
    group service_config[:user]
  end
end
