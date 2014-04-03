require 'deck'

class Shoe

  def initialize(shoe_size)
    @shoe_size = shoe_size
    @shoe = []
    create_new_shoe(shoe_size)
  end

  def create_new_shoe(shoe_size)
    puts "\nCreating #{shoe_size}-deck shoe"
    deck_count = 0
    shoe_size.times do
      deck = Deck.new.cards
      @shoe.concat(deck)
      deck_count += 1
    end
  end

  def draw
    if @shoe.size <= 20
      puts 'Shoe size <= 20, generating new shoe'
      @shoe = []
      create_new_shoe(@shoe_size)
      @shoe.pop
    else
      @shoe.pop
    end
  end

  def shoe_size
    @shoe_size
  end

  def cards
    @shoe.length
  end

end