#############################################################
############### Sample web application to test ##############
#############################################################


directory '#{node["tomcat"]["apps"]}/test' do
end


directory '#{node["tomcat"]["apps"]}/test/WEB-INF' do
end

cookbook_file '#{node["tomcat"]["apps"]}/test/WEB-INF/web.xml' do
	source 'web.xml'
end


cookbook_file '#{node["tomcat"]["apps"]}/test/test.jsp' do
	source 'test.jsp'
end


directory '#{node["tomcat"]["apps"]}/test/WEB-INF/lib' do
end


cookbook_file '#{node["tomcat"]["apps"]}/test/WEB-INF/lib/jstl.jar' do
	source 'jstl.jar'
end

bash "copy jar files" do
	code <<-EOH
cp #{node["tomcat"]["apps"]}/examples/WEB-INF/lib/*.* #{node["tomcat"]["apps"]}/test/WEB-INF/lib
EOH
end
