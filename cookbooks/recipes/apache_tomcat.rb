#######################################################################################
############### This cookbook installs and configures Apache, Tomcat ##################
#######################################################################################


# Install Apache based on the target platform. Since Chef handles this automatincally, we have mentioned 
# here explicitly because of the change in package name respectively

package 'Install Apache' do
	case node['platform']
	when 'redhat', 'centos'
		package_name 'httpd'
	when 'ubuntu', 'debian'
		package_name 'apache2'
	end
end

service 'apache' do
	service_name 'httpd'
	action [:enable, :start]
end


yum_package 'Install/Upgrade java' do
	package_name 'java-1.8.0-openjdk-devel.x86_64'
end

#Set JAVA Path
ruby_block 'Set JAVA_HOME in /etc/profile' do
    block do
      file = Chef::Util::FileEdit.new('/etc/profile')
      file.insert_line_if_no_match(/^JAVA_HOME=/, "JAVA_HOME=/usr/lib/jvm/java-1.8.0")
      file.search_file_replace_line(/^JAVA_HOME=/, "JAVA_HOME=/usr/lib/jvm/java-1.8.0")
	
      file.insert_line_if_no_match(/^PATH=/, "PATH=$PATH:$JAVA_HOME/bin/")
      file.search_file_replace_line(/^PATH=/, "PATH=$PATH:$JAVA_HOME/bin/")


      file.insert_line_if_no_match(/^CLASSPATH=/, "CLASSPATH=$JAVA_HOME/jre/lib:$JAVA_HOME/lib/tools.jar")
      file.search_file_replace_line(/^CLASSPATH=/, "CLASSPATH=$JAVA_HOME/jre/lib:$JAVA_HOME/lib/tools.jar")

      file.write_file
    end
end


# Install Tomcat package and relevant package
package 'Install Tomcat' do
	package_name ['tomcat6','tomcat6-webapps','tomcat6-admin-webapps']
end

service 'tomcat' do
	service_name 'tomcat6'
	action [:enable, :start]
end

#Modify tomcat config file to add user
#

ruby_block 'Create_Tomcat_User' do
	block do
		file = Chef::Util::FileEdit.new('/etc/tomcat6/tomcat-users.xml')
		file.insert_line_after_match(/^<tomcat-users>/,'<user username="root" password="root123" roles="manager" />')
		file.write_file
	end
	not_if "grep -qE '^<user username=\"root\"' /etc/tomcat6/tomcat-users.xml"
end

#Disable firewall

service 'Disable_FW' do
	case node['platform']
	when 'redhat', 'centos'
		service_name 'firewalld'
	when 'ubuntu','debian'
		service_name 'iptables'
	end
	action :stop
end

# Create webapps folder to deploy applications

directory '/usr/share/tomcat6/webapps' do
	action :create
end
