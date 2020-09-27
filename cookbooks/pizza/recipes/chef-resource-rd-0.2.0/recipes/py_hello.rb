python 'test_script' do
	code <<-EOH
import os
f=open("/tmp/arockia/super.txt","w+")
f.write("This is fine")
f.write(str(dir(os)))
f.close()
	EOH
end
