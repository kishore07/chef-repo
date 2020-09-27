filepath="#{Chef::Config['file_cache_path']}/rubyops.pdf"
remote_file filepath do
	source "http://www.tutorialspoint.com/ruby/pdf/ruby_operators.pdf"
	action :create
end
