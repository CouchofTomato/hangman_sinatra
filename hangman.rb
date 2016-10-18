require 'sinatra'
require 'sinatra/reloader'

enable :sessions
set :session_secret, '290584395084360958609684605986dogjdflgkdfhge9e'

get '/' do
  game_setup
  @secret_word = session[:secret_word]
  @guessed_letters = session[:guessed_letters]
  @turns_left = session[:turns_left]
  message = nil
  erb :index, :locals => {:message => message}
end

post '/' do
  @secret_word = session[:secret_word]
  @guessed_letters = session[:guessed_letters]
  @turns_left = session[:turns_left]
  guess = params['guess'].downcase
  good_guess = check_guess(guess)
  if good_guess
    update_game
  else
    message = "Invalid input. Please try again"
  end
  erb :index, :locals => {:message => message}
end

helpers do

  def game_setup
    session[:secret_word] = get_secret_word
    session[:guessed_letters] = ["a", "e", "i", "o", "u"]
    session[:turns_left] = 10
  end

  def get_secret_word
    word_arr = create_word_array
    word_arr.sample
  end

  def check_guess(guess)
    if letter?(guess) && not_already_chosen?(guess)
      return true
    end
    return false
  end

  def letter?(guess)
    return guess =~ /[A-Za-z]/ && guess.length == 1 ? true : false
  end

  def not_already_chosen?(guess)
    return @guessed_letters.include?(guess) ? false : true
  end

  def update_game
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
