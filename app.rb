require 'sinatra'
require 'haml'

set :views, Sinatra::Application.root
set :haml, :format => :html5

require "./datafy"

helpers do
  def data_uri(f, content_type=mime_type(File.extname(f)))
    Datafy.make_data_uri File.read(File.join(settings.root, 'public', f)),
                         content_type
  end
end

get "/" do
  haml :index
end

get "/hallo-berlin/" do
  haml :"public/hallo-berlin/index"
end

not_found do
  send_file '404.html'
end
