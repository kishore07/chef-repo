python 'Send a Request' do
	code <<-EOH
		import requests
		resp=requests.get("https://onecognizant.cognizant.com")
		file = open('/tmp/arockia/response.html','w+')
		file.writelines(resp.text)
		file.close()
	EOH
	path 	"/usr/bin/python"
end
