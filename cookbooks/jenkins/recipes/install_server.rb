
#
# Here I primitively install the jenkins server for Ubuntu
#
# From: https://wiki.jenkins-ci.org/display/JENKINS/Installing+Jenkins+on+Ubuntu
#

execute 'Install Jenkins the simple way' do
  command <<-EOH
    wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add - && \
    sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list' && 
    sudo apt-get update -y && \
    sudo apt-get install jenkins -y
  EOH
  not_if " dpkg -l jenkins "
end

node[:jenkins][:packages].each do |pkg|
  package pkg do
    action :install
  end
end



