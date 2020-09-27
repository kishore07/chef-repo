#######################################################################################
############### This cookbook installs and configures Apache, Tomcat ##################
#######################################################################################


# Install Apache based on the target platform. Since Chef handles this automatincally, we have mentioned 
# here explicitly because of the change in package name respectively

service 'apache' do
	service_name 'httpd'
	action [:enable, :nothing]
end
bash 'apache_service' do
	user 'root'
	code <<-EOC
#!/bin/bash
a=`netstat -tulpn|grep LISTEN|tr -s " "|awk '{print $4}'|egrep -E "[0-9]+.[0-9]+.[0-9]+.[0-9]+[:]80$"`
if [ $? -eq 0 ]
then
#b=`sestatus|egrep "enabled|enforced"`
#status1=$?
#c=`semanage port -l|grep http|grep 49155` 2> /dev/null
#status2=$?
#if [[ $status1 -eq 0 && $status2 -ne 0 ]]
#then
#semanage port -a -t http_port_t -p tcp 49155
#fi
sed -r -i 's/^#Listen.*80/Listen 10.121.49.120:49155/' /etc/httpd/conf/httpd.conf
#/sbin/service httpd start 1> /dev/null
fi
EOC
	not_if "service httpd status|grep -q running"
	notifies :start, service["apache"], :immediately
	action :nothing
end

package 'Install Apache' do
	case node['platform']
	when 'redhat', 'centos'
		package_name 'httpd'
	when 'ubuntu', 'debian'
		package_name 'apache2'
	end
	notifies :start, bash["apache_service"], :immediately
end



yum_package 'Install/Upgrade java' do
	package_name node.java.version
end

#Set JAVA Path
#de
ruby_block 'Set JAVA_HOME in /etc/profile' do
    block do
      file = Chef::Util::FileEdit.new('/etc/profile')
      file.insert_line_if_no_match(/^JAVA_HOME=/, "JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.101-3.b13.el6_8.x86_64/jre/")
      file.search_file_replace_line(/^JAVA_HOME=/, "JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.101-3.b13.el6_8.x86_64/jre/")
	
      file.insert_line_if_no_match(/^PATH=/, "PATH=$PATH:$JAVA_HOME/bin/")
      file.search_file_replace_line(/^PATH=/, "PATH=$PATH:$JAVA_HOME/bin/")


      file.insert_line_if_no_match(/^CLASSPATH=/, "CLASSPATH=$JAVA_HOME/jre/lib:$JAVA_HOME/lib/tools.jar")
      file.search_file_replace_line(/^CLASSPATH=/, "CLASSPATH=$JAVA_HOME/jre/lib:$JAVA_HOME/lib/tools.jar")

      file.write_file
    end
end


# Install Tomcat package and relevant package
#package 'Install Tomcat' do
#	package_name ['tomcat6','tomcat6-webapps','tomcat6-admin-webapps']
#end

#service 'tomcat' do
#	service_name 'tomcat6'
#	action [:enable, :start]
#end

cookbook_file "#{node.tomcat.path}/apache-tomcat-7.0.70.tar.gz" do
	source 'apache-tomcat-7.0.70.tar.gz'
end

bash 'untar and config tomcat' do
	code <<-EOH
mkdir node.tomcat.path/tomcat7
tar -xf node.tomcat.path/apache-tomcat-7.0.70.tar.gz -C node.tomcat.path/tomcat7/
mv node.tomcat.path/tomcat7/apache-tomcat-7.0.70/* node.tomcat.path/tomcat7/
rm -rf node.tomcat.path/tomcat7/apache-tomcat-7.0.70
rm -f node.tomcat.path/apache-tomcat-7.0.70.tar.gz
cd node.tomcat.path/tomcat7/bin/
chmod +x ./startup.sh
./startup.sh
EOH
	not_if "ls #{node.tomcat.path} | grep 'tomcat7'"
end


# Create service for tomcat7 

cookbook_file '/etc/init.d/tomcat7' do
	source 'tomcat7'
	mode '0755'
	not_if 'ls -ltr /etc/init.d/ | grep "tomcat7"'
end

# Update chkconfig for tomcat7 service

bash 'do chkconfig' do
	code <<-EOH
chkconfig tomcat7 --level 2345 on

EOH
end

# tomcat service

service 'tomcat' do
	service_name 'tomcat7'
	action [:enable, :start]
end

#Modify tomcat config file to add user
#

ruby_block 'Create_Tomcat_User' do
	block do
		file = Chef::Util::FileEdit.new('#{node["tomcat"]["path"]}/tomcat7/conf/tomcat-users.xml')
		file.insert_line_after_match(/^<tomcat-users>/,'<role rolename="manager-gui" />
<user username="manager" password="manager123" roles="manager-gui" />
<role rolename="admin-gui" />
<user username="admin" password="root123_" roles="manager-gui,admin-gui" />')
		file.write_file
	end
	not_if "grep -qE '^<user username=\"manager\"' #{node['tomcat']['path']}/tomcat7/conf/tomcat-users.xml"
end

#Disable firewall

service 'Disable_FW' do
	case node['platform']
	when 'redhat', 'centos'
		if node['platform_version'] == '6.5'
			service_name 'iptables'
		else
			service_name 'firewalld'
		end
	when 'ubuntu','debian'
		service_name 'iptables'
	end
	action :stop
end

# Create webapps folder to deploy applications

directory '#{node["tomcat"]["path"]}/tomcat7/webapps' do
	action :create
end
