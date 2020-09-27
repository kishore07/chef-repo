#Deom of using case stmt and ohai attributes


service "Apache" do
	case node['platform']
	when 'redhat','centos'
		service_name 'httpd'
		action :restart
		Chef::Log.info('restarted apache in redhat/cent os')
	when 'ubuntu','debain'
		service_name 'apache'
		action :restart
		Chef::Log.info('restarted apache in ubuntu/debain')
	end
end


