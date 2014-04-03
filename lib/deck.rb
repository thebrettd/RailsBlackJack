require 'card'
require 'suit'
require 'value'

class Deck

  #http://blog.codinghorror.com/shuffling/
  def shuffle_deck
    puts 'Shuffling deck'
    unshuffled_deck = card_set
    random = Hash[unshuffled_deck.map { |card| [rand, card] }]
    shuffled_deck = []
    random.keys.sort.each { |key| shuffled_deck.push(random[key])}
    shuffled_deck
  end

  def card_set
    set = []
    Suit.suit_set.each { |suit| Value.value_set.each { |value| set.push(Card.new(suit, value)) } }
    set
  end

  def initialize
    @deck = shuffle_deck
  end

  def cards
    @deck
  end


end