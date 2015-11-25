
#
# recipe to install various jenkins plugins
#
# GIT  Client Plugin is the first, GIT Plugin depends on it.
#
# From: http://stackoverflow.com/questions/7709993/how-can-i-update-jenkins-plugins-from-the-terminal
#


user node[:jenkins][:user] do
  action :create
end

group node[:jenkins][:group] do
  action :create
end

execute "wget http://#{node[:jenkins][:ip]}/jnlpJars/jenkins-cli.jar" do
  cwd "/opt"
  not_if { ::File.exists?('/opt/jenkins-cli.jar') }
end

directory node[:jenkins][:plugins_dir] do
  action :create
  recursive true
  owner node[:jenkins][:user]
  group node[:jenkins][:group]
  mode '0755'
  not_if { ::File.exists?( node[:jenkins][:plugins_dir] ) }
end

node[:jenkins][:plugins_list].each do |plugin_name|
  remote_file "#{node[:jenkins][:plugins_dir]}/#{plugin_name}.hpi" do
    source "#{node[:jenkins][:plugins_site]}/#{plugin_name}.hpi"
    not_if { ::File.exists?( "#{node[:jenkins][:plugins_dir]}/#{plugin_name}.hpi" ) }
  end
end

# link maven
template '/var/lib/jenkins/hudson.tasks.Maven.xml' do
  source   'var/lib/jenkins/hudson.tasks.Maven.xml.erb'
  mode     '0755'
  variables({})
end

execute "curl http://#{node[:jenkins][:ip]}/safeRestart -X POST -i && sleep #{node[:jenkins][:sleep_interval]}"
sleep node[:jenkins][:sleep_interval]

directory "/var/lib/jenkins/.m2" do
  action :create
  recursive true
  owner node[:jenkins][:user]
  group node[:jenkins][:group]
  mode '0755'
end

template '/etc/maven/settings.xml' do
  source   'etc/maven/settings.xml.erb'
  mode     '0755'
  variables({})
end









