template '/tmp/nodeinfo' do
	source 'example.erb'
	owner 'kishore'
	group 'kishore'
	mode '650'
	variables({ 
	:client => 'chef client' })
end
  
