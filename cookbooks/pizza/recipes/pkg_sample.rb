package 'install apache' do
	package_name 'httpd'
	action :install
end

service 'httpd' do
	supports :status => true, :restart => true, :reload => true
	action [:enable, :start]
end

cookbook_file '/var/www/html/index.html' do
	source 'index.html'
	owner 'root'
	group 'root'
	mode '0644'
	action :create
	Chef::Log.info('Webserver is deployed successfully')
end

