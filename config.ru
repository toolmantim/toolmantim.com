require 'rack/rewrite'

use Rack::Rewrite do

  r301 %r{.*}, 'http://toolmantim.com$&', :if => Proc.new {|rack_env|
    %w( www.toolmantim.com ww.toolmantim.com ).include? rack_env['SERVER_NAME']
  }

  r301 '/photos', 'http://flickr.com/photos/toolmantim/'
  r301 %r{/photos/(\d+)}, 'http://flickr.com/photos/toolmantim/$1/'

  r301 '/thoughts/setting_up_a_new_remote_git_repository', 'http://gist.github.com/569530'

  r301 %r{/articles/(.+)}, '/thoughts/$1'

  r301 %r{.*}, 'http://toolmantim.tumblr.com$&', :if => Proc.new {|env|
    %w( notes.toolmantim.com notebook.toolmantim.com tumble.toolmantim.com shoebox.toolmantim.com ).include? env['SERVER_NAME']
  }

  { "n" => "http://www.tumblr.com", "s" => "http://www.tumblr.com", "p" => "http://flickr.com/p" }.each_pair do |path, host|
    r302 %r{/#{path}/(.*)}, host + '/$1'
  end
  
  [
    'dear-bankwest',
    'bankwest-after.png',
    'bankwest-before.png',
    'pjb-banana.gif',
    'illo.png',
    'html5.js',
  ].each do |p|
    send_file "/#{p}", "public/#{p}"
  end
  
  send_file '/', 'public/index.html'

end

run lambda {|env|
  body = File.read("public/404.html")
  [404, {'Content-Type' => 'text/html', 'Content-Length' => body.size.to_s}, [body]]
}