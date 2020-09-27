#############################################################################
################ mysql server installation #################################
#############################################################################

package 'install mysql' do
	package_name [ 'mysql', 'mysql-server', 'expect']

end

# mysqld service resource

service 'mysqld' do
	action [:enable, :start]
end

# configure mysql secure installation

cookbook_file '/tmp/mysql_conf.sh' do
	source 'mysql_conf.sh'
	only_if "mysql -e 'use mysql;select user from user;'"
end


# Configure the root user credentials and secure installation for mysql
bash 'configure mysql server' do
	code <<-EOH
bash /tmp/mysql_conf.sh
rm -f /tmp/mysql_conf.sh
EOH
	only_if "mysql -e 'use mysql;select user from user;'"
end

bash "DB_TEST creation and data insertion" do

        code <<-EOH
mysql -p'root123' <<EOD
create database DB_TEST;
use DB_TEST;
create table tab_test(name varchar(40), email varchar(40));
insert into tab_test(name,email) values('Kishore',"kishore.senagana@cognizant.com");
insert into tab_test(name,email) values('arockia',"arockia.arulnathan@cognizant.com");
insert into tab_test(name,email) values('Aishwarya',"aishwarya.r@cognizant.com");
insert into tab_test(name,email) values('Vivek',"vivek@cognizant.com");
quit
EOD
        EOH
not_if "mysql -p'root123' -t -e 'use DB_TEST;'"
end



# mysql connector setup
cookbook_file '#{node["tomcat"]["path"]}/tomcat7/lib/mysql-connector-java-5.1.39-bin.jar' do
	source 'mysql-connector-java-5.1.39-bin.jar'
end


ruby_block 'Set mysql CLASSPATH in /etc/profile' do
    block do
      file = Chef::Util::FileEdit.new('/etc/profile')
      file.search_file_replace_line(/^CLASSPATH=/, "CLASSPATH=$CLASSPATH:#{node["tomcat"]["path"]}/tomcat7/lib/mysql-connector-java-5.1.39-bin.jar")
      file.write_file
    end
    not_if "echo $CLASSPATH | grep 'mysql-connector'"
end


ruby_block 'Update context.xml' do
        block do
                file = Chef::Util::FileEdit.new('#{node["tomcat"]["path"]}/tomcat7/conf/context.xml')
                file.insert_line_after_match(/^<Context>/,'<Resource name="jdbc/DB_TEST" auth="Container" type="javax.sql.DataSource" maxActive="100" maxIdle="30" maxWait="10000" username="root" password="root123" driverClassName="com.mysql.jdbc.Driver" url="jdbc:mysql://localhost:3306/test"/>
')
                file.write_file
        end
        not_if "grep -qE '^<Resource name=\"jdbc/DB_Test\"' #{node["tomcat"]["path"]}/tomcat7/conf/context.xml"
end

