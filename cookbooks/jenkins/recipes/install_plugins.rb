
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

service "jenkins" do
  action [ :enable, :start ]
end

ruby_block "before_wait_for_jenkins" do
  block do
    while true do
      ` curl http://127.0.0.1:8080/jnlpJars/jenkins-cli.jar -X HEAD -I -s | grep "200 OK" `
      exitstatus = $?.exitstatus
      ( puts "+++ +++ before_wait_for_jenkins should exit!" && break ) if 0 == exitstatus
      puts "+++ +++ Sleeping in before_wait_for_jenkins..."
      sleep node[:jenkins][:sleep_interval_small]
    end
  end
  notifies :run, 'execute[get_jenkins_cli_jar]', :immediately
end

execute "get_jenkins_cli_jar" do
  command "sleep #{node[:jenkins][:sleep_interval]} && wget http://#{node[:jenkins][:ip]}/jnlpJars/jenkins-cli.jar"
  cwd "/opt"
  # not_if { ::File.exists?('/opt/jenkins-cli.jar') }
  action :nothing
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
    notifies :run, 'execute[restart_jenkins]',     :delayed
    notifies :run, 'ruby_block[wait_for_jenkins]', :delayed
  end
end

# link maven
template '/var/lib/jenkins/hudson.tasks.Maven.xml' do
  source   'var/lib/jenkins/hudson.tasks.Maven.xml.erb'
  mode     '0755'
  variables({})
  notifies :run, 'execute[restart_jenkins]',     :delayed
  notifies :run, 'ruby_block[wait_for_jenkins]', :delayed
end

execute "restart_jenkins" do
  command <<-EOL
    curl http://#{node[:jenkins][:ip]}/safeRestart -X POST -i && sleep #{node[:jenkins][:sleep_interval]}
  EOL
  action :nothing
end

ruby_block "wait_for_jenkins" do
  block do
    while true do
      ` curl http://127.0.0.1:8080/jnlpJars/jenkins-cli.jar -X HEAD -I -s | grep "200 OK" `
      exitstatus = $?.exitstatus
      break if 0 == exitstatus
      sleep node[:jenkins][:sleep_interval]
    end
  end
end

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









