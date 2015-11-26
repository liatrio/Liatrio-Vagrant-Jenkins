
#
# Here I primitively install the jenkins server for Ubuntu
#
# From: https://wiki.jenkins-ci.org/display/JENKINS/Installing+Jenkins+on+Ubuntu
#

#
# home config
#
node[:home][:packages].each do |pkg|
  package pkg
end


#
# part of configuration of jenkins; install relevant pacjages (e.g. maven, java)
#
case node['platform']
when 'debian', 'ubuntu'
  node[:ubuntu][:packages].each do |pkg|
    package pkg
  end
when 'redhat', 'centos', 'fedora'
  node[:centos][:packages].each do |pkg|
    package pkg
  end
end


#
# jenkins install
#
service "jenkins" do
  action :nothing
end
case node['platform']
when 'debian', 'ubuntu'
  execute "Install Jenkins the simple way on #{node['platform']}" do
    command <<-EOH
      wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add - && \
      sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list' && 
      sudo apt-get update -y && \
      sudo apt-get install jenkins -y
    EOH
    not_if " dpkg -l jenkins "
  end
when 'redhat', 'centos', 'fedora'
  execute "Install Jenkins the simple way on #{node['platform']}" do
    command <<-EOH
      wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo && \
      sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
    EOH
    not_if " yum list installed jenkins "
  end
  package 'jenkins' do
    action :install
    notifies :restart, 'service[jenkins]', :immediately
  end
end








