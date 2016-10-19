require 'sinatra'
require 'sinatra/reloader' if development?

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
    update_game(guess)
  else
    message = "Invalid input. Please try again"
  end
  erb :index, :locals => {:message => message}
end

get '/winner' do
  @secret_word = session[:secret_word]
  erb :winner
end

get '/loser' do
  @secret_word = session[:secret_word]
  erb :loser
end

helpers do

  def game_setup
    session[:secret_word] = get_secret_word
    session[:guessed_letters] = []
    session[:turns_left] = [1,2,3,4,5,6,7]
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

  def update_game(guess)
    @guessed_letters << guess
    @guessed_letters = @guessed_letters.sort
    if winner?
      redirect '/winner'
    end
    update_turns_left(guess)
    if @turns_left.empty?
      redirect '/loser'
    end
  end

  def winner?
    @secret_word.split("").all? {|letter| @guessed_letters.include?(letter)}
  end

  def update_turns_left(guess)
    @turns_left.pop unless @secret_word.split("").include?(guess)
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
