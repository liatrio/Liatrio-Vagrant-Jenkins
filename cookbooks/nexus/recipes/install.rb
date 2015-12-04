
user node[:nexus][:user] do
  action :create
end

group node[:nexus][:group] do
  action :create
end

execute "download Nexus OSS" do
  command <<-EOL
    wget http://www.sonatype.org/downloads/nexus-latest-bundle.tar.gz;
  EOL
  not_if { ::File.exists?('/opt/nexus-latest-bundle.tar.gz') }
  cwd "/opt"
end

execute "unpack Nexus OSS" do
  command <<-EOL
    rm -frv trash; mkdir -p trash; 
    tar --directory trash -xvf nexus-latest-bundle.tar.gz;
  EOL
  cwd "/opt"
end

execute "move Nexus OSS" do
  command "mv /opt/trash/nexus-* .; ln -s nexus-* nexus"
  cwd "/usr/local"
end

# configure nexus as a service
template "/etc/init.d/nexus" do
  source "usr/local/nexus/bin/nexus.erb"
  owner node[:nexus][:user]
  group node[:nexus][:group]
  mode "0644"
  variables({
    :nexus_home   => node[:nexus][:home],
    :nexus_user   => node[:nexus][:user],
    :nexus_piddir => node[:nexus][:pid_dir]
  })
end

execute "update_rcd" do
  command "update-rc.d nexus defaults"
  cwd "/etc/init.d"
end

service 'nexus' do
  action [ :enable, :start ]
end

# set NEXUS_HOME ?
# export NEXUS_HOME=/usr/local/nexus

