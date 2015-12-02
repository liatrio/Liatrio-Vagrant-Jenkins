
job_name = node[:jenkins][:job_name]
job_name = "petclinic-simple-auto-1"
template '/opt/config.xml' do
  source   'var/lib/jenkins/jobs/petclinic-simple/config.xml.erb'
  mode     '0755'
  variables({
    :nexus_repo => node[:jenkins][:nexus_repo]
  })
end
execute "create_job" do
  command "java -jar jenkins-cli.jar -s http://#{node[:jenkins][:ip]} create-job #{job_name} < config.xml"
  cwd "/opt"
  not_if "cd /opt && java -jar jenkins-cli.jar -s http://#{node[:jenkins][:ip]} list-jobs | grep #{job_name}"
end




