require_relative 'deck.rb'


class Array
  def greater_than?(other_arr)
    #only works on sorted arrays
    (self.length-1).downto(0).each do |idx|
      next if self[idx] == other_arr[idx]
      return true if self[idx] > other_arr[idx]
      return false if self[idx] < other_arr[idx] 
    end
  end
  
  
end


class Hand
  
  HAND_WORTH ={
    singles: 0,
    pair: 1,
    two_pair: 2,
    three_of_a_kind: 3,
    straight: 4,
    flush: 5,
    full_house: 6,
    four_of_a_kind: 7,
    straight_flush: 8,
    royal_flush: 9
    
  }
  
  attr_accessor :cards
  
  def initialize(cards)
    @cards = cards
  end
  
  def size
    @cards.count
  end
  
  def to_s
    output_arr = []
    @cards.each do |card|
      output_arr << card.to_s
    end
    output_arr.join(", ")
  end
  
  def discard(card_pos)
    raise "can't discard more than 3" if card_pos.count > 3
    @cards.reject!.with_index do |card, idx|
      card_pos.include?(idx)
    end
  end
  
  def get_cards(cards)
    #receives an array of cards
    @cards += cards
  end
  
  def check_pair_greater?(hand1, hand2, pairs)
    h1_arr = hand1.card_val_arr_sorted
    h2_arr = hand2.card_val_arr_sorted

    h1_arr.reject! { |value| pairs.include?(value) }.sort!
    h2_arr.reject! { |value| pairs.include?(value) }.sort!
    h1_arr.greater_than?(h2_arr)
  end
  
  def check_tie_breaker?(other_hand)
    #return true if hand is bigger than other if they're same level
    if royal_flush? || straight_flush? || flush? || straight? || worth == :singles
      #will return true if one hand is higher than another, false if otherwise
      card_val_arr_sorted.greater_than?(other_hand.card_val_arr_sorted)
      
    elsif four_of_a_kind || full_house || three_of_a_kind
      unique_hand_biggest > other_hand.unique_hand_biggest
    elsif two_pair
      if two_pair.sort == other_hand.two_pair.sort
        check_pair_greater?(self, other_hand, two_pair)
      else
        two_pair.sort.greater_than?(other_hand.two_pair.sort)
      end
    else
      if self.pair == other_hand.pair
        check_pair_greater?(self, other_hand, pair)
      else
        pair.greater_than?(other_hand.pair)
      end
    end
  end
  
  def beats?(other_hand)
    if HAND_WORTH[self.worth] == HAND_WORTH[other_hand.worth]
      check_tie_breaker?(other_hand) 
    else
      HAND_WORTH[self.worth] > HAND_WORTH[other_hand.worth]
    end
  end
  
  def unique_hand_biggest
    four_of_a_kind || full_house || three_of_a_kind
  end
  
  def worth
    return :royal_flush if royal_flush?
    return :straight_flush if straight_flush?
    return :four_of_a_kind if four_of_a_kind
    return :full_house if full_house
    return :flush if flush?
    return :straight if straight?
    return :three_of_a_kind if three_of_a_kind
    return :two_pair if two_pair
    return :pair if pair
    :singles
  end
  
  def cards_value_count_hash
    count = Hash.new(0)
    card_val_arr_sorted.each do |el|
      count[el] += 1
    end
    
    count
  end
  
  def four_of_a_kind
    cards_value_count_hash.key(4)
  end
  
  def three_of_a_kind
    cards_value_count_hash.key(3)
  end
  
  def full_house
    cards_value_count_hash.key(3) if three_of_a_kind && pair
  end
  
  def two_pair
    pairs = []
    cards_value_count_hash.each do |key, value|
      pairs << key if value == 2
    end
    
    return pairs if pairs.size == 2
    
    false
  end
  
  def pair
    pairs = []
    cards_value_count_hash.each do |key, value|
      pairs << key if value == 2
    end
    
    return pairs if pairs.size == 1
    
    false
  end
  
  def card_val_arr_sorted
    result = []
    @cards.each do |card|
      result << card.value
    end
    
    result.sort
  end
  
  def straight?
    card_values = card_val_arr_sorted
    if card_values[-1] == 14 && card_values.include?(4)
      card_values[-1] = 1
      card_values.sort!
    end
    
    
    card_values.each_index do |idx|
      next if idx == card_values.length - 1
      return false unless card_values [idx] + 1 == card_values[idx + 1]
    end
    
    true
  end
  
  def flush?
    suit = @cards[0].suit
    @cards.all? { |card| card.suit == suit }
  end
  
  def straight_flush?
    straight? && flush?
  end
  
  def royal_flush?
    straight? && flush? && 
    card_val_arr_sorted.include?(13) && card_val_arr_sorted.include?(14)
  end
  
end
