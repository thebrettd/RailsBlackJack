class Wager

  def self.get_player_antes(players)
    current_round_players = []
    Print.heading('Wagers')
    players.each do |curr_player|
      wager_amount = self.get_wager_for_player(curr_player)

      if wager_amount >= 1
        curr_player.new_hands
        curr_player.place_wager(wager_amount, curr_player.hands[0])
        current_round_players.push(curr_player)
      else
        puts "#{curr_player.name} abstains"
      end
    end
    current_round_players
  end

  def self.get_wager_for_player(curr_player)
    print "#{curr_player.name} (Bankroll: $#{curr_player.bankroll}) - Enter wager or anything < 1 to abstain: "

    wager_amount, wager_invalid = 0, true
    while wager_invalid
      begin
        wager_amount = Integer(gets.chomp)
        wager_invalid = Wager.invalid_wager?(curr_player, wager_amount)
      rescue ArgumentError
        #Catches non-number input and betting more than you have
        print "Invalid wager #{curr_player.name}, please wager <= $#{curr_player.bankroll}: "
      end
    end
    wager_amount
  end

  def self.invalid_wager?(curr_player, wager_amount)
    if wager_amount > curr_player.bankroll
      raise ArgumentError
    end
    false
  end

end