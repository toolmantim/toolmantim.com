require 'rack/rewrite'

use Rack::Rewrite do

  r301 %r{.*}, 'http://toolmantim.com$&', :if => Proc.new {|rack_env|
    %w( www.toolmantim.com ww.toolmantim.com ).include? rack_env['SERVER_NAME']
  }

  r302 '/photos', 'http://flickr.com/photos/toolmantim/'
  r302 %r{/photos/(\d+)}, 'http://flickr.com/photos/toolmantim/$1/'

  r302 '/thoughts/setting_up_a_new_remote_git_repository', 'http://gist.github.com/569530'

  r301 %r{/articles/(.+)}, '/thoughts/$1'

  r301 %r{.*}, 'http://scrapbook.toolmantim.com$&', :if => Proc.new {|env|
    %w( tumble.toolmantim.com shoebox.toolmantim.com ).include? env['SERVER_NAME']
  }

  r301 %r{.*}, 'http://notebook.toolmantim.com$&', :if => Proc.new {|env|
    env['SERVER_NAME'] == 'notes.toolmantim.com'
  }
  
  { "n" => "http://www.tumblr.com", "s" => "http://www.tumblr.com", "p" => "http://flickr.com/p" }.each_pair do |path, host|
    r302 %r{/#{path}/(.*)}, host + '/$1'
  end
  
  send_file '/dear-bankwest', 'public/dear-bankwest.html'
  send_file '/bankwest-after.png', 'public/bankwest-after.png'
  send_file '/bankwest-before.png', 'public/bankwest-before.png'
  send_file '/pjb-banana.gif', 'public/pjb-banana.gif'
  send_file '/', 'public/index.html'

end

run lambda {|env|
  body = File.read("public/404.html")
  [404, {'Content-Type' => 'text/html', 'Content-Length' => body.size.to_s}, [body]]
}
