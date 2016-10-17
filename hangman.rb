require 'sinatra'
require 'sinatra/reloader'

enable :sessions
set :session_secret, '290584395084360958609684605986dogjdflgkdfhge9e'

get '/' do
  session[:secret_word] = get_secret_word
  @secret_word = session[:secret_word]
  erb :index
end

helpers do
  def get_secret_word
    word_arr = create_word_array
    word_arr.sample
  end

  def create_word_array
    return_arr = []
    File.open("5desk.txt", "r") do |f|
      f.each_line do |line|
        if line.chomp.length >= 5 && line.chomp.length <= 12
          return_arr << line.downcase.chomp
        end
      end
    end
    return_arr
  end
end
