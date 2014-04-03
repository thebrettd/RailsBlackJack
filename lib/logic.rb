require 'move'

class Logic

  def self.seventeen_or_above(totals)
    totals.select { |total| total >= 17 && total <= 21 }.length > 0
  end

  #Return array of all distinct hand values. Ace counts as 1 or 11
  #
  #Loop through each card, and lookup its point value
  #If it returns 2 values (ace):
  # - Add one to every previous total
  # - Add two to every previous total
  # - Combine above two sets to get final total
  #Else it is just one value, add it to every previous total
  def self.get_hand_values(hand)
    totals = [0]
    hand.cards.each do |card|
      card_points = self.get_card_value(card)
      if card_points.size == 2
        #Add a value of 1 to all known sums
        one_totals = totals.map { |old_total| old_total + card_points[0] }
        #Add a value of 11 to all known sums
        eleven_totals = totals.map { |old_total| old_total + card_points[1] }
        #Combine 11-ace and 1-ace totals
        totals = one_totals + eleven_totals
      else
        #Non-ace, just add the value to all known sums
        totals.map! { |old_total| old_total + card_points[0] }
      end
    end
    totals.uniq
  end

  #Same logic as above, but return true if any 11-valued ace results in a sum of 17.
  #Also shortcircuit false if no aces in hand
  def self.contains_soft_seventeen(hand)

    if hand.cards.select { |card| card.value == Value::ACE }.length == 0
      return false
    end

    totals = [0]
    soft_totals = []
    hand.cards.each do |card|
      card_points = self.get_card_value(card)
      if card_points.size == 2
        #Add a value of 1 to all known sums
        one_totals = totals.map { |old_total| old_total + card_points[0] }
        #Add a value of 11 to all known sums
        eleven_totals = totals.map { |old_total| old_total + card_points[1] }
        soft_totals = soft_totals + eleven_totals
        #Combine 11-ace and 1-ace totals
        totals = one_totals + eleven_totals
      else
        #Non-ace, just add the value to all known sums
        totals.map! { |old_total| old_total + card_points[0] }
        soft_totals.map! { |old_total| old_total + card_points[0] }
      end
    end

    return soft_totals.select {|value| value == 17}.length > 0

  end

  def self.max_under_twenty_two(hand)
    Logic.get_hand_values(hand).select{|total| total <= 21 }.max
  end

  def self.blackjack(hand)
    hand.size == 2 && Logic.get_hand_values(hand).select{|total| total == 21 }.size > 0
  end

  def self.minimum_score(hand)
    Logic.get_hand_values(hand).min
  end

  def self.is_busted?(hand)
    Logic.get_hand_values(hand).select { |total| total <= 21}.length == 0
  end

  def self.losing_score(hand)
    if Logic.is_busted?(hand)
      Logic.minimum_score(hand)
    else
      Logic.max_under_twenty_two(hand)
    end
  end

  #Closest to 21 without going over wins.
  #Most ties result in push except as follows:
  #Blackjack (2-card 21) trumps 3+ card twenty one.
  #Player && Dealer blackjack is a push
  def self.evaluate_hand(hand, dealer_hand)
    dealers_totals = Logic.get_hand_values(dealer_hand)
    player_totals = Logic.get_hand_values(hand)
    dealer_bust = dealers_totals.min > 21
    player_bust = player_totals.min > 21

    dealers_best = Logic.max_under_twenty_two(dealer_hand)
    players_best = Logic.max_under_twenty_two(hand)

    dealer_blackjack = Logic.blackjack(dealer_hand)
    player_blackjack = Logic.blackjack(hand)

    if player_bust || dealer_blackjack && !player_blackjack
      return Result::LOSE
    elsif player_blackjack && !dealer_blackjack
      return Result::BLACKJACK
    elsif dealer_bust
      return Result::WIN
    elsif dealers_best > players_best
      return Result::LOSE
    elsif players_best > dealers_best
      return Result::WIN
    elsif players_best == dealers_best
      return Result::PUSH
    end
  end

  def self.get_card_value(card)
    @@point_map[card.value]
  end

  #Blackjack game should manage the point values for cards, so that card class can be reused for other card games
  @@point_map = {
      Value::TWO => [2],
      Value::THREE => [3],
      Value::FOUR => [4],
      Value::FIVE => [5],
      Value::SIX => [6],
      Value::SEVEN => [7],
      Value::EIGHT => [8],
      Value::NINE => [9],
      Value::TEN => [10],
      Value::JACK => [10],
      Value::QUEEN => [10],
      Value::KING => [10],
      Value::ACE => [1,11]
  }

  def self.compute_valid_moves(player, hand)
    moves = [Move::STAND]

    totals = Logic.get_hand_values(hand)
    #Don't allow hit if player has 21 (You're welcome)
    if totals.select{ |total| total == 21}.length >= 1
      #noop
    else
      if totals.select{ |total| total < 21}.length >= 1
        moves.push(Move::HIT)
      end
      #Player can double down if he only has 2 cards and enough money
      if hand.only_two_cards? && player.bankroll >= hand.wager
        moves.push(Move::DOUBLEDOWN)
        #Player can hit if he has a total < 21
      end
      #Player can split if this hand has exactly 2 two cards and are the same
      if hand.only_two_cards? && hand.cards[0].value == hand.cards[1].value && player.bankroll >= hand.wager
        moves.push(Move::SPLIT)
      end
    end
    moves
  end

end