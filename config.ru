require 'rack/rewrite'

use Rack::Rewrite do

  r301 %r{.*}, 'http://toolmantim.com$&', :if => Proc.new {|rack_env|
    %w( www.toolmantim.com ww.toolmantim.com ).include? rack_env['SERVER_NAME']
  }

  r302 '/photos', 'http://flickr.com/photos/toolmantim/'
  r302 %r{/photos/(\d+)}, 'http://flickr.com/photos/toolmantim/$1/'

  r302 '/thoughts/setting_up_a_new_remote_git_repository', 'http://gist.github.com/569530'

  r301 %r{.*}, 'http://shoebox.toolmantim.com$&', :if => Proc.new {|env|
    %w( tumble.toolmantim.com shoebox.toolmantim.com ).include? env['SERVER_NAME']
  }
  
  send_file '/', 'public/index.html'

end

run lambda {|env|
  body = File.read("public/404.html")
  [404, {'Content-Type' => 'text/html', 'Content-Length' => body.size.to_s}, [body]]
}
