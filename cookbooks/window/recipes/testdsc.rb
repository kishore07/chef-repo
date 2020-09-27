dsc_resource 'Unzip' do 
	resource :archive
	property :path, 'C:\Users\Administrator\Documents\testdir.zip'
	property :destination, 'C:\Users\Administrator\Documents'
end
