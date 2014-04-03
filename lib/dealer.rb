class Dealer

  def initialize(name, shoe)
    @name = name
    @hand = []
    @shoe = shoe
  end

  def name
    @name
  end

  def hand
    @hand
  end

  def new_hand
    @hand = Hand.new
  end

  def play_hand
    Print.heading('Playing dealer hand!')

    totals = Logic.get_hand_values(@hand)
    Print.player_score(self, @hand, totals)
    while !Logic.is_busted?(@hand) && (Logic.seventeen_or_above(totals) == false || Logic.contains_soft_seventeen(@hand))
      card = @shoe.draw
      @hand.add_card(card, true)
      #puts "Dealer draws a #{card}"
      totals = Logic.get_hand_values(@hand)
      Print.player_score(self, @hand, totals)
    end

    if Logic.is_busted?(@hand)
      puts "Dealer busts with #{@hand} values: #{Logic.get_hand_values(@hand).join(',')}"
    end
  end

end