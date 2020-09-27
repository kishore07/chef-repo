
python 'systeminfo' do
	code <<-EOC
import os
a=os.uname()
print a
	EOC
end
