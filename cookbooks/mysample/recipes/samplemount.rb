mount  '/dev/shm' do
	device 'tmpfs'
	fstype 'tmpfs'
	options 'size=700m,defaults'
	pass 0
	action [:remount, :enable]
end
	
