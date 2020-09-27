###############################################################
############# Integration of Apache, Tomcat, Mod_jk ##########
###############################################################

include_recipe '::apache_tomcat'

#Install httpd-devel, gcc, gcc-+ 

yum_package 'Install components' do
	package_name ['httpd-devel','gcc','gcc-c++']
end

# Transfer the file using cookbook_file resource


cookbook_file '/tmp/tomcat-connectors-1.2.41-src.tar.gz' do
	source 'tomcat-connectors-1.2.41-src.tar.gz'
end

# Extract and make install 


bash 'Extract and Install mod_jk' do
	code <<-EOH
tar -xvf /tmp/mod_jk.tar.gz
cd /tmp/tomcat-connectors-1.2.41-src/native
./configure --with-apxs=/usr/sbin/apxs
make
make install
	
EOH
	not_if "ls -l | grep 'tomcat-connectors-1.2.41-src$'"
end


# Edit the config file to incorporate mod_jk.so

bash 'Edit httpd conf file' do
	code <<-EOH
echo -e 'LoadModule jk_module modules/mod_jk.so\nJkWorkersFile conf/workers.properties\nJkLogFile logs/mod_jk.log\nJkRequestLogFormat "%w %V %T"\nJkOptions +ForwardKeySize +ForwardURICompat -ForwardDirectories\nJkLogLevel emerg\nJkLogStampFormat "[%a %b %d %H:%M:%S %Y]"\nJkMount /* worker1' >> /etc/httpd/conf/httpd.conf
EOH
	not_if "grep -qE '^LoadModule jk_module modules/mod_jk.so' /etc/httpd/conf/httpd.conf"
end

# Configure workers.properties file

cookbook_file '/etc/httpd/conf/workers.properties' do
	source 'workers.properties'
	
	notifies :restart, "service[apache]", :immediately
	notifies :restart, "service[tomcat]", :immediately
end

