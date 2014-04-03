require 'blackjack'

class GamesController < ApplicationController

  def new

  end

  def create
    @game = Blackjack.new(params[:game]['player_name'])

    render :action => :show
  end

  def show

  end


end
