class Suit

  SPADE = :spade
  HEART = :heart
  DIAMOND = :diamond
  CLUB = :club

  @@suit_set = [SPADE, HEART, DIAMOND, CLUB]

  def self.suit_set
    @@suit_set
  end

end