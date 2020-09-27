#
# Cookbook Name:: pizza
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
template '/etc/sudoers' do
	source 'sudoers.erb'
	mode '0440'
	owner 'root'
	group 'root'
	variables({ 
	:sudoers_users => node[:authorization][:sudo][:users]
})
end

