
template '/opt/config.xml' do
  source   'var/lib/jenkins/jobs/petclinic/config.xml.erb'
  mode     '0755'
  variables({
    :nexus_repo => node[:jenkins][:nexus_repo]
  })
end
execute "java -jar jenkins-cli.jar -s http://#{node[:jenkins][:ip]} create-job #{node[:jenkins][:job_name]} < config.xml" do
  cwd "/opt"
  not_if "java -jar jenkins-cli.jar -s http://#{node[:jenkins][:ip]} list-jobs | grep #{node[:jenkins][:job_name]}"
end




