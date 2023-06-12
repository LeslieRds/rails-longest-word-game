require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = generate_grid.join("")
  end

  def generate_grid
    Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def score
    @grid = params[:grid]
    @word = params[:word]
    @word.split('').each do |letter|
      if @grid.include?(letter.upcase) && english_word?(@word)
        @result = "Congratulations! #{@word.upcase} is a valid English word!!"
      elsif @grid.include?(letter.upcase)
        @result = "Sorry but #{@word.upcase} does not seem to be an English word"
      else
        @result = "Sorry but #{@word.upcase} can't be built out of #{@grid}"
      end
    end
  end
end
