require 'player'
require 'value'
require 'shoe'
require 'move'
require 'result'
require 'print'
require 'logic'
require 'wager'
require 'dealer'

class Blackjack


  def dealer
    @dealer
  end

  def player_array
    @player_array
  end

  def current_round_players
    @current_round_players
  end

  def shoe
    @shoe
  end

  #Command line driver
  def self.start
    Print.heading("Welcome to Brett's Blackjack Casino!")
    print 'How many players? '
    num_players = get_number_of_players
    game = Blackjack.new(num_players)
    game.play_game
  end

  #Command line driver helper
  def self.get_number_of_players
    number_invalid = true
    while number_invalid
      begin
        num_players = Integer(gets.chomp)
        number_invalid = number_valid?(num_players)
      rescue ArgumentError
        print 'Please enter a valid number > 0: '
      end
    end
    num_players
  end
  #Command line driver helper
  def self.number_valid?(number)
    if number <= 0
      raise ArgumentError
    end
    false
  end

  def initialize(player_name)
    @player_array = []
    @shoe = Shoe.new(6)
    @dealer = Dealer.new('Dealer', @shoe)
    @current_round_players = []
    player = Player.new(player_name, @shoe, @dealer)
    @player_array.push(player)
  end

  #Main game loop. Exit when all the money is gone
  def play_game
    while @player_array.select{ |player| player.bankroll > 0 }.length > 0
      play_round
      Print.round_over
      gets
    end
    Print.game_over
  end

  def play_round
    reset
    @current_round_players = Wager.get_player_antes(@player_array)
    deal_cards
    do_all_players_turns
    if @current_round_players.length > 0
      @dealer.play_hand
      calculate_results
    end
  end

  #Reset dealer's hand
  def reset
    @dealer.new_hand
  end

  #Deal initial cards to all players in the following order
  # All players get one card - exposed
  # Dealer gets one card - hidden
  # All players get one card - exposed
  # Dealer gets one card - hidden
  def deal_cards
    Print.heading('Dealing initial cards')
    deal_card_to_players
    dealer_card_to_dealer(false) #false to hide first dealer card
    deal_card_to_players
    dealer_card_to_dealer(true)
  end

  def dealer_card_to_dealer(show)
    deal_card_to_dealer(@dealer, @shoe.draw, show)
  end

  def deal_card_to_dealer(dealer, card, show)
    if show
      puts "Dealing to #{dealer.name}: #{card}"
    elsif
    puts "Dealing hidden card to #{dealer.name}"
    end
    dealer.hand.add_card(card, false)
  end

  def deal_card_to_players
    @current_round_players.each do |curr_player|
      deal_card_to_player(curr_player, @shoe.draw, true)
    end
  end

  def do_all_players_turns
    @current_round_players.each do |curr_player|
      curr_player.play_turn
    end
  end

  def calculate_results
    Print.heading('Results')
    Print.dealer_final_score(@dealer, @dealer.hand)

    @current_round_players.each do |player|
      calculate_results_for_player(player)
    end
  end

  def calculate_results_for_player(player)
    player.hands.each do |hand|
      result = Logic.evaluate_hand(hand, @dealer.hand)
      if result == Result::PUSH
        puts "\n#{player.name} pushes with #{hand}! Final Score: #{Logic.max_under_twenty_two(hand)}"
        player.credit(hand.wager)
      elsif result == Result::BLACKJACK
        winnings = hand.wager * (3/2)
        puts "\nBLACKJACK! #{player.name} wins with #{hand}! Final Score: #{Logic.max_under_twenty_two(hand)}\nWinnings: $#{winnings}"
        player.credit(winnings)
      elsif result == Result::WIN
        winnings = hand.wager * 2
        puts "\n#{player.name} wins with #{hand}! Final Score: #{Logic.max_under_twenty_two(hand)}\nWinnings: $#{winnings}"
        player.credit(winnings)
      else
        puts "\n#{player.name} loses with #{hand}! Final Score: #{Logic.losing_score(hand)}"
      end
    end
  end

  #Adds the card to a player (does not draw card)
  def deal_card_to_player(player, card, show)
    if show
      puts "Dealing to #{player.name}: #{card}"
    elsif
      puts "Dealing hidden card to #{player.name}"
    end
    player.hands[0].add_card(card, false)
  end

end

