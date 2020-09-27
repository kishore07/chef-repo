
#installation of java and env variable setup
#

bash "java setup" do
	user "root"
	code <<-EOC
cd /opt/
cd /usr/
rpm -qa|grep -i ^jdk1.8.0_92*
if [ $? -ne 0 ]
then
wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u92-b14/jdk-8u92-linux-x64.rpm
rpm -ivh /opt/jdk-8u92-linux-x64.rpm
fi
echo "export JAVA_HOME=/usr/java/jdk1.8.0_92" >> /root/.bash_profile
source ~/.bash_profile
	EOC
not_if "grep -q JAVA_HOME /root/.bash_profile"
end

bash "env" do
	code <<-EOC
echo "export PATH=$PATH:$JAVA_HOME/bin" >> /root/.bash_profile
echo "export CLASSPATH=.:$JAVA_HOME/jre/lib:$JAVA_HOME/lib:$JAVA_HOME/lib/tools.jar" >> /root/.bash_profile
source ~/.bash_profile
	EOC
not_if "grep -q CLASSPATH /root/.bash_profile"
end
	

