require 'rack/rewrite'

use Rack::Rewrite do

  r302 '/photos', 'http://flickr.com/photos/toolmantim/'
  r302 %r{/photos/(\d+)}, 'http://flickr.com/photos/toolmantim/$1/'

  r302 '/thoughts/setting_up_a_new_remote_git_repository', 'http://book.git-scm.com/3_distributed_workflows.html'

  send_file '/', 'public/index.html'

end

run lambda {|env|
  body = File.read("public/404.html")
  [404, {'Content-Type' => 'text/html', 'Content-Length' => body.size.to_s}, [body]]
}
