#This recipe is to create a database and table using mysql


bash "departments db" do

	code <<-EOH
mysql -p'root123' <<EOD
create database depart;
use depart;
create table types(id int(15),name char(40));
insert into types(id,name) values(100,"IT");
insert into types(id,name) values(101,"ITIS");
insert into types(id,name) values(102,"BPO");
insert into types(id,name) values(103,"NSS");
quit
EOD
	EOH
not_if "mysql -p'root123' -t -e 'use depart;'"
end



