#hand should be able to discard up to 3
#hand should be able to draw cards
#hand starts out with 5 cards
#hand should be able to compute biggest hand it forms
#hand should be able to tell if it beats another hand
#hand should hold an array of cards

require 'hand'
require 'card'

RSpec.describe Hand do
  let(:cards) { [Card.new(5, :club),
                 Card.new(6, :club),
                 Card.new(10, :heart),
                 Card.new(11, :diamond),
                 Card.new(12, :spade)] } 
  subject(:hand) { Hand.new(cards) }
  let(:hand1) { Hand.new(cards) }
  let(:hand2) { Hand.new(cards) }
  
  describe "card properties" do
    
    it "holds an array of cards" do
      expect(hand.cards).to be_an(Array)
    end
    
    it "contains 5 actual card objects" do
      cards.each do |card|
        expect(hand.cards).to include(card)
      end
    end
    
    it "starts with 5 cards" do
      expect(hand.size).to eq(5)
    end    
  end
  
  describe "discarding phase" do
    
    it "raises an error if you try to discard more than 3 cards" do
      expect { hand.discard([0,1,2,3]) }.to raise_error
    end
    
    it "discards unwanted cards" do
      discard_pos = [1, 2]
      non_discarded_card = hand.cards[0]
      discarded_card = hand.cards[1]
      hand.discard(discard_pos)
      
      expect(hand.size).to eq(3)
      expect(hand.cards).to include(non_discarded_card)
      expect(hand.cards).not_to include(discarded_card)
    end
    
    let(:new_cards) { [Card.new(7, :heart), Card.new(8, :heart)] }
    
    it "gets cards and puts them in hand" do
      hand.get_cards(new_cards)
      
      expect(hand.cards).to include(new_cards[0])
    end
    
  end
  
  
  describe "show hand method" do
    
    it "should use to_s method to show the hand" do
      expect(hand.to_s).to include("Five of Clubs")
    end
    
  end
                     
  let(:straight_flush) { [
    Card.new(5, :club),
    Card.new(6, :club),
    Card.new(7, :club),
    Card.new(8, :club),
    Card.new(9, :club)]
  } 
  
  let(:royal_flush) { [
    Card.new(10, :club),
    Card.new(11, :club),
    Card.new(12, :club),
    Card.new(13, :club),
    Card.new(14, :club)]
  }
  
  let(:four_of_a_kind) { [
    Card.new(10, :club),
    Card.new(10, :diamond),
    Card.new(10, :heart),
    Card.new(10, :spade),
    Card.new(14, :club)]
  }
  
  let(:full_house) { [
    Card.new(5, :heart),
    Card.new(5, :club),
    Card.new(5, :diamond),
    Card.new(3, :heart),
    Card.new(3, :club)]
  } 
  
  let(:flush) { [
    Card.new(10, :club),
    Card.new(9, :club),
    Card.new(2, :club),
    Card.new(3, :club),
    Card.new(14, :club)]
  }
  
  let(:straight) { [
    Card.new(10, :club),
    Card.new(9, :diamond),
    Card.new(8, :heart),
    Card.new(7, :spade),
    Card.new(6, :club)]
  }
  
  let(:higher_three_of_a_kind) {[
    Card.new(11, :club),
    Card.new(11, :diamond),
    Card.new(9, :heart),
    Card.new(11, :spade),
    Card.new(14, :club)]
  }
  
  let(:three_of_a_kind) { [
    Card.new(10, :club),
    Card.new(10, :diamond),
    Card.new(9, :heart),
    Card.new(10, :spade),
    Card.new(14, :club)]
  }
  
  let(:two_pair) { [
    Card.new(10, :club),
    Card.new(10, :diamond),
    Card.new(3, :heart),
    Card.new(3, :spade),
    Card.new(11, :club)]
  }
  
  let(:higher_kicker_two_pair) { [
    Card.new(10, :club),
    Card.new(10, :diamond),
    Card.new(3, :heart),
    Card.new(3, :spade),
    Card.new(14, :club)]
  }
  
  let(:pair) { [
    Card.new(10, :club),
    Card.new(10, :diamond),
    Card.new(11, :heart),
    Card.new(9, :spade),
    Card.new(14, :club)]
  }
  
  let(:higher_pair) { [
    Card.new(11, :club),
    Card.new(11, :diamond),
    Card.new(10, :heart),
    Card.new(3, :spade),
    Card.new(14, :club)]
  }
  
  let(:higher_kicker_pair) { [
    Card.new(10, :club),
    Card.new(10, :diamond),
    Card.new(11, :heart),
    Card.new(12, :spade),
    Card.new(14, :club)]
  }
  
  let(:singles) { [
    Card.new(10, :club),
    Card.new(11, :diamond),
    Card.new(4, :heart),
    Card.new(7, :spade),
    Card.new(14, :club)]
  }
  
  describe "self worth" do
    
    it "correctly determines a singles" do
      expect(hand.worth).to eq(:singles)
    end
    
    it "correctly determines a straight flush" do
      hand.cards = straight_flush
      expect(hand.worth).to eq(:straight_flush)
    end
  
    it "correctly determines a royal flush" do
      hand.cards = royal_flush
      expect(hand.worth).to eq(:royal_flush)
    end 
    
    it "correctly determines a four of a kind" do
      hand.cards = four_of_a_kind
      expect(hand.worth).to eq(:four_of_a_kind)
    end
    
    it "correctly determines a full house" do
      hand.cards = full_house
      expect(hand.worth).to eq(:full_house)
    end
    
    it "correctly determines a flush" do
      hand.cards = flush
      expect(hand.worth).to eq(:flush)
    end
    
    it "correctly determines a straight" do
      hand.cards = straight
      expect(hand.worth).to eq(:straight)
    end
    
    it "correctly determines a three of a kind" do
      hand.cards = three_of_a_kind
      expect(hand.worth).to eq(:three_of_a_kind)
    end
    
    it "correctly determines a two pair" do
      hand.cards = two_pair
      expect(hand.worth).to eq(:two_pair)
    end
   
    it "correctly determines a pair" do
      hand.cards = pair
      expect(hand.worth).to eq(:pair)
    end
  end
  
  
  
  describe "value comparison" do
    
    it "correctly determines easy comparison" do
      hand1.cards = full_house
      hand2.cards = straight

      expect(hand1.beats?(hand2)).to be true
      expect(hand2.beats?(hand1)).not_to be true
    end
    
    it "correctly determines straght beats pair" do
      hand1.cards = straight 
      hand2.cards = pair
      
      expect(hand1.beats?(hand2)).to be true
      expect(hand2.beats?(hand1)).not_to be true
    end
    
    it "correctly determines winner when one TOAK is better than another TOAK" do
      hand1.cards = higher_three_of_a_kind
      hand2.cards = three_of_a_kind
      
      expect(hand1.beats?(hand2)).to be true
      expect(hand2.beats?(hand1)).not_to be true
    end
    
    it "correctly determines winner when hand level is same two pairs" do
      hand1.cards = higher_kicker_two_pair
      hand2.cards = two_pair
      
      expect(hand1.beats?(hand2)).to be true
      expect(hand2.beats?(hand1)).not_to be true
    end
    
    it "correctly determines winner when hand level is pair" do
      hand1.cards = higher_kicker_pair
      hand2.cards = pair
      
      expect(hand1.beats?(hand2)).to be true
      expect(hand2.beats?(hand1)).not_to be true
    end
    
    it "correctly determines winner when one pair is bigger than other pair" do
      hand1.cards = higher_pair
      hand2.cards = pair
      
      expect(hand1.beats?(hand2)).to be true
      expect(hand2.beats?(hand1)).not_to be true
    end
  end
  
end