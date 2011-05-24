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

  r301 '/halloween-2010', '/halloween-2010/'
  send_file '/halloween-2010/', 'public/halloween-2010/index.html'

  rewrite "/halloween-2010/", "/halloween-2010/index.html"
  rewrite "/dear-bankwest/", "/dear-bankwest/index.html"
end

require 'sinatra'
require 'haml'

set :views, Sinatra::Application.root
set :haml, :format => :html5

get "/" do
  redirect "/hello-berlin"
end

get "/hello-berlin" do
  haml :"public/hello-berlin/index"
end

not_found do
  send_file '404.html'
end

run Sinatra::Application
