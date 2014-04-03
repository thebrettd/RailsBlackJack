class Value

  TWO = :two
  THREE = :three
  FOUR = :four
  FIVE = :five
  SIX = :six
  SEVEN = :seven
  EIGHT = :eight
  NINE = :nine
  TEN = :ten
  JACK = :jack
  QUEEN = :queen
  KING = :king
  ACE = :ace

  @@value_set = [TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING, ACE]

  def self.value_set
    @@value_set
  end
end