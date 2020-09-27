
cookbook_file "/var/www/html/index.html" do
	source 'index.html'
	owner 'root'
	group 'root'
	mode '0766'
end

service 'httpd' do
	supports :reload => true
	subscribes :reload, 'cookbook_file[/var/www/html/index.html]', :immediately
end	
