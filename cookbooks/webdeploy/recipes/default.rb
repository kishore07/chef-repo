#
# Cookbook Name:: webdeploy
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.



package "apache" do
	package_name 'httpd'
	action :install
	notifies :start, 'service[httpd]', :immediately
end

service "httpd" do
	supports :start => true
	action :nothing
end

include_recipe env_sample
