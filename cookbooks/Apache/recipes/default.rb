#installation of apache package and service enable

package "apache" do
	package_name 'httpd'
	action :install
end

service "httpd" do
	supports :enable => true, :start => true
	action [:start, :enable]
end
