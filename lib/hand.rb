class Hand

  def initialize()
    @cards = []
    @wager = nil
  end

  def wager
    @wager
  end

  def set_wager(amount)
    @wager = amount
  end

  def cards
    @cards
  end

  def size
    @cards.length
  end

  def add_card(card, print)
    @cards.push(card)
    if print
      #todo remove blackjack specific logic
      puts "Drew a #{card} \n"
    end
  end

  def only_two_cards?
    @cards.length == 2
  end

  def to_s
    @cards.join(',')
  end

end