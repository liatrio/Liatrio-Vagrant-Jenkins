
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

execute "run Nexus OSS" do
  command <<-EOL
    ./nexus start
  EOL
  cwd "/usr/local/nexus/bin"
  user node[:nexus][:user]
end

# set NEXUS_HOME ?


