execute "environment path" do
command "bash"
command 'echo $PATH > /tmp/env.txt'
command 'export PATH="$PATH:/testdir/exe"'

end
