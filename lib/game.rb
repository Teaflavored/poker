require_relative 'deck'
require_relative 'player'

class Game
  ANTE = 10
  
  attr_accessor :players, :deck, :current_player, :pot, :current_bet
  
  def initialize
    @deck = Deck.new
    @players = [Player.new("Player1", 10000, self), Player.new("Player2", 5000, self)]
    #the ante is the player who has to place money in, switches every round
    @ante_player = 0
    @round_over = false
    @current_bet = 0
    @pot = 0
  end
  
  def next_ante_player
    #switches the ante player to the next player 
    if @ante_player < @players.size - 1
      @ante_player += 1
    else
      @ante_player = 0
    end
  end
  
  def start_of_round
    #deck needs to be shuffled at the beginning
    system("clear")
    @round_over = false
    @deck = Deck.new
    @deck.shuffle!
    @pot = 0
    #put_ante_player_in_round
    put_all_players_in_round
    #reset everyone's current bet
    reset_all_player_current_bet
    deal_cards_to_all_players
    ante_player_bet
  end
  
  def main_phase
    betting_phase
    check_winner
    unless @round_over
      discard_phase
      reset_all_player_current_bet
      reset_current_bet
      ante_player_bet
      betting_phase
      @round_over = true
    end
    winner
    next_ante_player
  end
 
  def over?
    @players.any? do |player|
      player.bank == 0
    end
  end
  
  def run
    until over?
      start_of_round
      main_phase
    end
  end
  
  private
  
  def deal_cards_to_all_players
    @players.each do |player|
      player.get_hand(@deck.deal_cards(5))
    end
  end
  
  def put_all_players_in_round
    @players.each do |player|
      player.in_round = true
    end
  end
  
  def ante_player_bet
    @players[@ante_player].bet_amt(10)
    @current_bet = 10
  end
  
  def reset_all_player_current_bet
    @players.each do |player|
      player.reset_betting_money
    end
  end 
  
  
  def reset_current_bet
    @current_bet = 0
  end
  
  def betting_phase
    
    until betting_phase_over?
      @players.each do |player|
        if player.in_round
          puts "********************************************************************"
          puts "#{player.name}, You have $#{player.bank} in your bank"
          player.show_hand
          puts "Current bet is #{@current_bet}, current pot is #{@pot}, you have bet $#{player.money_into_current_bet} towards the current bet"
          player.action
        end
      end
    end
  end
  
  def betting_phase_over?
    finished_betting? || players_remaining == 1
  end
  
  def finished_betting?
    @players.each do |player|
      return false if player.in_round && player.money_into_current_bet != @current_bet
    end
    
    true
  end
  
  
  def discard_phase
    @players.each do |player|
      if player.in_round
        puts "********************************************************************"
        puts "#{player.name}, It's your turn to discard"
        player.discard_action
        player.show_hand
      end
    end
  end
  
  
  def players_remaining
    remaining_player_count = 0
    @players.each do |player|
      remaining_player_count += 1 if player.in_round
    end
    
    remaining_player_count
  end
  
  
 
  def check_winner
    if players_remaining == 1
      @round_over = true
    end
    
    nil
  end
  
  
  def winner
    winner = nil
    
    @players.each do |player|
      next unless player.in_round
      if winner.nil? || player.hand.beats?(winner.hand)
        winner.fold! unless winner.nil?
        winner = player
      end
    end
    puts "---------------------------------------"
    puts "$#{@pot} paid to #{winner.name}"
    puts "#{winner.name} won with a #{winner.hand.worth}"
    puts "---------------------------------------"
    sleep 5
    winner.receive_amt(@pot)
    winner
  end
  
end
game = Game.new
game.run