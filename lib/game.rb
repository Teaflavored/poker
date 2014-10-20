require_relative 'deck'
require_relative 'player'

class Game
  ANTE = 10
  
  attr_accessor :players, :deck, :current_player, :pot, :current_bet
  
  def initialize
    @deck = Deck.new
    @players = [Player.new("computer", 10000, self, @deck), Player.new("comp2", 5000, self, @deck)]
    #the ante is the player who has to place money in, switches every round
    @ante_player = 0
    @current_bet = 0
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
    @deck = Deck.new
    @deck.shuffle!
    
    #put_ante_player_in_round
    put_all_players_in_round
    #reset everyone's current bet
    reset_all_player_current_bet
    deal_cards_to_all_players
    ante_player_bet
  end
  
  def betting_phase
    @current_bet = 0
    
  end
  
  def discard_phase
    
  end
  
  def each_turn
    @players.each do |player|
      play_turn(player) if player.in_round
    end
  end
  
  def play_turn(player)
    puts "*****************************************************"
    puts "You have $#{player.bank}, your name is #{player.name}"
    player.show_hand
    puts "Current bet is #{@current_bet}, current pot is #{@pot}, you have bet $#{player.money_into_current_bet} towards the current bet"
    player.action
    puts "Current bet is #{@current_bet}, current pot is #{@pot}, you have bet $#{player.money_into_current_bet} towards the current bet"
    if player.in_round
      player.discard_action 
      player.show_hand
    end
  end
  
  def betting_phase_over?
    finished_betting? || players_remaining == 1
  end
  
  def distribute_pot(player)
    player.receive_amt(@pot)
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
    puts "$#{@pot} paid to #{winner.name}"
    winner
  end
  
  def finished_betting?
    @players.all? do |player|
         player.money_into_current_bet == @current_bet
    end
  end
  
  def players_remaining
    remaining_player_count = 0
    @players.each do |player|
      remaining_player_count += 1 if player.in_round
    end
    
    remaining_player_count
  end
  
  def over?
    @players.any? do |player|
      player.bank == 0
    end
  end
  
  def run
    until over?
      restart_round
      until betting_phase_over?
        each_turn
      end
      distribute_pot(winner)
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
    @players[@ante_player].raise(10)
  end
  
  def reset_all_player_current_bet
    @players.each do |player|
      player.reset_betting_money
    end
  end 
  
end
game = Game.new
game.run