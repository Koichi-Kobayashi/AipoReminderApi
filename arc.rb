require 'rubygems'
require 'sinatra/base'
require 'json'

class Arc < Sinatra::Base
  # 開発モードのときリロード機構をONにする
  if development?
    require 'sinatra/reloader'
    register Sinatra::Reloader
  end

  get '/activity/:login_name' do
    activity = Activity.new
    results = activity.exe(params[:login_name])
    results.to_json
  end
end
