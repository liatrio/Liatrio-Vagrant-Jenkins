
#
# Cookbook:    liatrio
# Recipe:      home
#
# Author:      Victor Piousbox <piousbox@gmail.com>
# Copyright:   Liatrio 2015
#
# Provides some home configuration and network configuration, particularly for the CI/CD pipeline. 
#



#
# home config
#
case node['platform']
when 'redhat', 'centos', 'fedora'
  node[:home][:centos][:packages].each do |pkg|
    package pkg
  end
when 'ubuntu', 'debian'
  node[:home][:ubuntu][:packages].each do |pkg|
    package pkg
  end
end



#
# Networking
#
# firewalld management
# From: http://serverfault.com/questions/341804/opening-up-port-8080-in-centos
#   sudo firewall-cmd --permanent --add-port=8081/tcp
#   sudo firewall-cmd --reload
#
# check OS version
#   cat /etc/centos-release
#

#
# networking with firewalld
#
case node['platform']
when 'redhat', 'centos', 'redora'
  node[:home][:open_ports].each do |port|
    execute "open_port_#{port}" do
      command "firewall-cmd --permanent --add-port=#{port}/tcp"
    end
  end
  execute "restart_firewalld" do
    command "firewall-cmd --reload"
  end
end


__END__
#
# networking with iptables
# From: http://stackoverflow.com/questions/24756240/how-can-i-use-iptables-on-centos-7
#
<<-TRASH
case node['platform']
when 'redhat', 'centos', 'fedora'
  # disable and mask firewalld
  execute " systemctl stop   firewalld  "
  execute " systemctl mask   firewalld  "
  execute " systemctl enable iptables   "
  
  node['home']['open_ports'].each do |port|
    execute "Open port #{port}" do
      command <<-EOL
        iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport #{port} -j ACCEPT -m comment --comment "some comment"
      EOL
    end
  end
when 'ubuntu', 'debian'
end

service 'iptables' do
  action :restart
end
TRASH



